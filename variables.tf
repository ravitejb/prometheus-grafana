variable "cluster_name" {
  description = "The name of the cluster."
  type        = string
}

variable "cluster_location" {
  description = <<EOF
The location (region or zone) in which the cluster master will be created, as well as the default node location.
If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master.
If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region,
and with default node locations in those zones as well.
EOF

  type = string
}

variable "cluster_vpc_network" {
  description = <<EOF
The name or self_link of VPC network to which the cluster is connected. For
Shared VPC, use the self link of the shared network.
EOF

  type = string
}

variable "cluster_vpc_network_subnet" {
  description = <<EOF
The name or self_link of the VPC subnet in which the cluster's instances are
launched.
EOF

  type = string
}

variable "monitoring_machine_type" {
  description = <<EOF
The name or self_link of the VPC subnet in which the cluster's instances are
launched.
EOF

  type = string
}

variable "master_ipv4_cidr_block" {
    description = <<EOF
The IP range in CIDR notation to use for the hosted master network.
This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP.
This range must not overlap with any other ranges in use within the clusters network, and it must be a /28 subnet.

EOF

  type = string
}

variable "project" {
  description = "Name of the GCP Project"
  type = string
}

variable "region" {
  description = "GCP Region"
  type = string
}
