resource "google_compute_network" "net" {
  auto_create_subnetworks = false
  name = "prometheus-grafana"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "prometheus-grafana"
  network       = google_compute_network.net.id
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "prometheus-grafana"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.net.id
}

resource "google_compute_address" "address" {
  count  = 2
  name   = "nat-manual-ip-${count.index}"
  region = google_compute_subnetwork.subnet.region
}

resource "google_compute_router_nat" "nat_manual" {
  name   = "prometheus-grafana-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.address.*.self_link

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}
