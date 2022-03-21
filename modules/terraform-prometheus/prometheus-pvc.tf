resource "kubernetes_namespace" "prometheus" {
  metadata {
    name = "prometheus"
  }
}

resource "kubernetes_persistent_volume_claim" "prometheus" {
  metadata {
    name      = "prometheus-data-claim"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = {
      app = "prometheus"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "50Gi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "grafana" {
  metadata {
    name      = "grafana-data-claim"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = {
      app = "grafana"
    }
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "50Gi"
      }
    }
  }
}