output "cluster_name" {
  value       = google_container_cluster.cluster.name
  description = "The name of the cluster."
}

output "cluster_master_endpoint_ip" {
  value       = google_container_cluster.cluster.endpoint
  description = "The endpoint ip of the cluster master."
}

output "cluster_zones" {
  value       = google_container_cluster.cluster.node_locations
  description = "The list of zones within the cluster's region where the master replicas are deployed."
}

output "cluster_pod_ipv4_cidr" {
  value       = google_container_cluster.cluster.cluster_ipv4_cidr
  description = "The IP address range of the kubernetes pods in this cluster."
}

output "cluster_client_certificate" {
  value       = google_container_cluster.cluster.master_auth.0.client_certificate
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster endpoint."
}

output "cluster_ca_certificate" {
  value       = google_container_cluster.cluster.master_auth.0.cluster_ca_certificate
  description = "Base64 encoded public certificate that is the root of trust for the cluster."
}

output "cluster_client_cert_key" {
  value       = google_container_cluster.cluster.master_auth.0.client_key
  description = "Base64 encoded private key used by clients to authenticate to the cluster endpoint."
  sensitive   = true
}