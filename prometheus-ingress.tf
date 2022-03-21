resource "google_compute_address" "ingress" {
  name    = "grafana-ingress"
}

resource "kubernetes_ingress" "grafana-ingress" {
  metadata {
    name = "grafana-ingress"
    namespace = module.prometheus.prometheus_namespace
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_address.ingress.name
      "cert-manager.io/cluster-issuer" = "letsencrypt-staging"
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    tls {
      hosts = ["grafana.cloudops.broadsoft.com"]
    }

    rule {
      host = "grafana.cloudops.broadsoft.com"

      http {
        path {
          path = "/"

          backend {
            service_name = "grafana-http"
            service_port = "3000"
          }
        }
      }
    }
  }
}