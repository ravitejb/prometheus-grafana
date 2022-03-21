resource "google_container_cluster" "cluster" {
  name     = var.cluster_name
  location = var.cluster_location
  description = "Cluster managed by Terraform"

  network    = var.cluster_vpc_network
  subnetwork = var.cluster_vpc_network_subnet

  initial_node_count       = 1
  remove_default_node_pool = true

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    master_global_access_config {
      enabled = false
    }
  }
}