data "template_file" "prometheus_config" {
  template = file("${path.module}/templates/prometheus.yml")

  vars = {
    project         = var.project_name
    region          = var.region
    app             = var.application
    environment     = var.environment
  }
}

resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "prometheus-config"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = {
      app = "prometheus"
    }
  }

  data = {
    prometheus_yml = data.template_file.prometheus_config.rendered
    rules_yml      = var.recording_rules
  }
}