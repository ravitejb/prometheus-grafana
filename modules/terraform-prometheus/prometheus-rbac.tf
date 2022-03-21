locals {
  kubernetes_cluster_role_prometheus_labels = {
    "kubernetes.io/cluster-service"   = "true"
    "addonmanager.kubernetes.io/mode" = "Reconcile"
  }
}

resource "kubernetes_service_account" "prometheus" {
  metadata {
    name      = "prometheus"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = local.kubernetes_cluster_role_prometheus_labels
  }
}

resource "kubernetes_cluster_role" "prometheus" {
  metadata {
    name = "prometheus"

    labels = local.kubernetes_cluster_role_prometheus_labels
  }

  rule {
    api_groups = [""]

    resources = [
      "nodes",
      "nodes/proxy",
      "nodes/metrics",
      "services",
      "endpoints",
      "pods",
    ]

    verbs = ["get", "list", "watch"]
  }

  rule {
    api_groups = [""]

    resources = ["configmaps"]

    verbs = ["get"]
  }

  rule {
    api_groups = ["networking.k8s.io"]

    resources = ["ingresses"]

    verbs = ["get", "list", "watch"]
  }

  rule {
    non_resource_urls = ["/metrics"]

    verbs = ["get"]
  }
}

resource "kubernetes_cluster_role_binding" "prometheus" {
  metadata {
    name = "prometheus"

    labels = local.kubernetes_cluster_role_prometheus_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.prometheus.metadata.0.name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.prometheus.metadata.0.name
    namespace = kubernetes_stateful_set.prometheus.metadata.0.namespace
  }
}