resource "kubernetes_stateful_set" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata.0.name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "prometheus"
      }
    }

    service_name = "prometheus"

    update_strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "prometheus"
        }
      }

      spec {
        node_selector = var.node_selector_map

        service_account_name            = kubernetes_service_account.prometheus.metadata.0.name
        automount_service_account_token = true

        security_context {
          run_as_user = 0
        }

        container {
          name              = "prometheus"
          image             = "prom/prometheus:${var.prometheus_version}"
          image_pull_policy = "IfNotPresent"

          args = [
            "--config.file",
            "/etc/prometheus/prometheus.yml",
            "--storage.tsdb.path",
            "/prometheus",
            "--storage.tsdb.retention",
            "${var.prometheus_data_retention_days}d",
            "--log.level",
            "info",
            "--web.enable-lifecycle",
          ]

          port {
            name           = "prometheus"
            container_port = var.prometheus_port
          }

          resources {
            requests = {
              memory = "512Mi"
              cpu    = "300m"
            }

            limits = {
              memory = "4Gi"
              cpu    = 2
            }
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = 9090
            }

            initial_delay_seconds = 10
            timeout_seconds       = 30
          }

          liveness_probe {
            http_get {
              path = "/-/healthy"
              port = 9090
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          volume_mount {
            name       = "prom-config"
            mount_path = "/etc/prometheus/"
            read_only  = true
          }

          volume_mount {
            name       = "prom-data"
            mount_path = "/prometheus"
            read_only  = false
          }
        }

        container {
          // This sidecar watches the prometheus configMap for changes,
          // and upon detecting a change, hits the Prometheus server reload
          // API endpoint to trigger the server to update it's running config.
          name = "reloader"

          image = "jimmidyson/configmap-reload"

          args = [
            "-volume-dir",
            "/etc/prometheus",
            "-webhook-url",
            "http://localhost:${var.prometheus_port}/-/reload",
          ]

          volume_mount {
            name       = "prom-config"
            mount_path = "/etc/prometheus/"
            read_only  = true
          }
        }

        volume {
          name = "prom-config"

          config_map {
            name = kubernetes_config_map.prometheus.metadata.0.name

            items {
              key  = "prometheus_yml"
              path = "prometheus.yml"
            }

            items {
              key  = "rules_yml"
              path = "rules.yml"
            }
          }
        }

        volume {
          name = "prom-data"

          persistent_volume_claim {
            claim_name = "${kubernetes_persistent_volume_claim.prometheus.metadata.0.name}"
          }
        }
      }
    }
  }
}