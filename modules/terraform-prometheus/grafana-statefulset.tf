resource "kubernetes_stateful_set" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.prometheus.metadata.0.name
  }

  spec {
    selector {
      match_labels = {
        app = "grafana"
      }
    }

    service_name = "grafana"

    update_strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "grafana"
        }
      }

      spec {
        security_context {
          run_as_user = 0
        }

        node_selector = var.node_selector_map

        container {
          name              = "grafana"
          image             = "grafana/grafana:${var.grafana_version}"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "CONF_MD5"
            value = md5(data.template_file.grafana_config.rendered)
          }

          env {
            name  = "GF_PATHS_CONFIG"
            value = "/etc/grafana/grafana.ini"
          }

          port {
            name           = "grafana"
            container_port = 3000
          }

          # resources {
          #   requests = {
          #     memory = "512Mi"
          #     cpu    = "500m"
          #   }

          #   limits = {
          #     memory = "1G"
          #     cpu    = "1"
          #   }
          # }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = 3000
            }

            initial_delay_seconds = 5
            timeout_seconds       = 30
          }

          liveness_probe {
            http_get {
              path = "/api/health"
              port = 3000
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          volume_mount {
            name       = "grafana-config"
            mount_path = "/etc/grafana"
            read_only  = true
          }

          volume_mount {
            name       = "grafana-datasources"
            mount_path = "/etc/grafana/provisioning/datasources"
            read_only  = false
          }

          volume_mount {
            name       = "grafana-data"
            mount_path = "/var/lib/grafana"
            read_only  = false
          }
        }


        volume {
          name = "grafana-config"

          config_map {
            name = kubernetes_config_map.grafana.metadata.0.name
            items {
              key  = "grafana_ini"
              path = "grafana.ini"
            }
          }
        }

        volume {
          name = "grafana-datasources"

          config_map {
            name = kubernetes_config_map.grafana_datasources.metadata.0.name
            items {
              key  = "prometheus_yml"
              path = "prometheus.yml"
            }
          }
        }

        volume {
          name = "grafana-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.grafana.metadata.0.name
          }
        }
      }
    }
  }
}
