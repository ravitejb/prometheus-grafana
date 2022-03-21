resource "random_string" "grafana_admin_pwd" {
  length = 20
}

data "template_file" "grafana_config" {
  template = file("${path.module}/templates/grafana.ini")

  vars = {
    instance_name       = "grafana"
    admin_password      = random_string.grafana_admin_pwd.result
  }
}

resource "kubernetes_config_map" "grafana" {
  metadata {
    name      = "grafana-config"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = {
      app = "grafana"
    }
  }

  data = {
    grafana_ini = data.template_file.grafana_config.rendered
  }
}

data "template_file" "grafana_datasources" {
  template = "${file("${path.module}/templates/grafana_datasources.yml")}"

  vars = {
    prometheus_service = kubernetes_service.prometheus.metadata.0.name
    prometheus_namespace = kubernetes_namespace.prometheus.metadata.0.name
    prometheus_port = var.prometheus_port
  }
}


resource "kubernetes_config_map" "grafana_datasources" {
  metadata {
    name      = "grafana-datasources"
    namespace = kubernetes_namespace.prometheus.metadata.0.name

    labels = {
      app = "grafana"
    }
  }

  data = {
    prometheus_yml = data.template_file.grafana_datasources.rendered
  }
}
