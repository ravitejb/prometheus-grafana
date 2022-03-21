locals {
  kubernetes_service_prometheus_annotations = {
    "prometheus.io/scrape" = "true"
    "prometheus.io/scheme" = "http"
    "prometheus.io/port"   = var.prometheus_port
  }
}

resource "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    annotations = local.kubernetes_service_prometheus_annotations
  }

  spec {
    selector = {
      app = "prometheus"
    }

    port {
      name        = "prometheus"
      port        = var.prometheus_port
      target_port = var.prometheus_port
    }

    type       = "ClusterIP"
    cluster_ip = "None"
  }
}