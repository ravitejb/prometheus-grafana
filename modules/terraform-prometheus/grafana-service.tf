resource "kubernetes_service" "grafana" {
  metadata {
    name      = "grafana-http"
    namespace = kubernetes_namespace.prometheus.metadata.0.name
  }

  spec {
    selector = {
      app = "grafana"
    }

    port {
      name        = "grafana-http"
      port        = 3000
      target_port = 3000
    }

    type = "NodePort"
  }
}