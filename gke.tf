module "cluster_regional" {
  source = "./modules/terraform-gke-cluster"

  cluster_name                  = var.cluster_name
  cluster_location              = var.cluster_location
  cluster_vpc_network           = google_compute_network.net.id #var.cluster_vpc_network
  cluster_vpc_network_subnet    = google_compute_subnetwork.subnet.id #var.cluster_vpc_network_subnet
  master_ipv4_cidr_block        = var.master_ipv4_cidr_block
}

resource "google_container_node_pool" "monitoring_node_pool" {
  name     = "${var.cluster_name}-monitoring-pool"
  location = var.cluster_location
  cluster  = module.cluster_regional.cluster_name

  node_config {
    machine_type = var.monitoring_machine_type

    labels = {
      pool = "monitoring"
    }

    disk_size_gb = "10"
  }

  // 1 per zone
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 4
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      node_count,
    ]
  }
}
