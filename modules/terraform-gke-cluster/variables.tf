variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_location" {
  type = string
  description = <<EOF
The location (region or zone) in which the cluster master will be created, as well as the default node location.
If you specify a zone (such as us-central1-a), the cluster will be a zonal cluster with a single cluster master.
If you specify a region (such as us-west1), the cluster will be a regional cluster with multiple masters spread across zones in the region,
and with default node locations in those zones as well.
EOF

}

variable "cluster_vpc_network" {
  type = string
  description = "Name or self_link of VPC network to which the cluster is connected"
}

variable "cluster_vpc_network_subnet" {
  type = string
  description = "The name or self_link of the VPC subnet in which the cluster's instances are launched"
}

variable "master_ipv4_cidr_block" {
    description = <<EOF
The IP range in CIDR notation to use for the hosted master network.
This range will be used for assigning private IP addresses to the cluster master(s) and the ILB VIP.
This range must not overlap with any other ranges in use within the clusters network, and it must be a /28 subnet.

EOF

  type = string
}