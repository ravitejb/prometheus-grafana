provider "google" {
  project = var.project
  region  = var.region
  credentials = file("./bcld-xpn00-sandbox-835a97327a2e.json")
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

provider "kubernetes" {

  host  = "https://${module.cluster_regional.cluster_master_endpoint_ip}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.cluster_regional.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host  = "https://${module.cluster_regional.cluster_master_endpoint_ip}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(module.cluster_regional.cluster_ca_certificate)
  }
}

provider "kubectl" {
  host  = "https://${module.cluster_regional.cluster_master_endpoint_ip}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.cluster_regional.cluster_ca_certificate)
}