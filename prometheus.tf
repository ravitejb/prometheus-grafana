module "prometheus" {
  source = "./modules/terraform-prometheus"
  project_name = var.project
  region = var.region
  environment = "netdev"
  application = "NOTSET"
  prometheus_port = "9090"
  prometheus_version = "v2.34.0"
  prometheus_data_retention_days = 15
  node_selector_map = {}
  recording_rules = ""
}
