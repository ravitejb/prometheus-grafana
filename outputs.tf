output "gke_auth_regional" {
  sensitive = true

  value = {
    client_certificate     = "${module.cluster_regional.cluster_client_certificate}"
    client_key             = "${module.cluster_regional.cluster_client_cert_key}"
    cluster_ca_certificate = "${module.cluster_regional.cluster_ca_certificate}"
  }
}