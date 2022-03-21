variable project_name {
  description = "The GCP Project of the monitored application. Will be added as a label to collected metrics."
}

variable region {
  description = "The GCP region of the monitored application. Will be added as a label to collected metrics."
}

variable environment {
  description = "'prod', 'stage' or 'netdev'"
  default     = "netdev"
}

variable application {
  description = "A short description of the monitored application (e.g. 'ucaas', 'hub', 'paas', 'console'). Avoid non-alphanumeric characters."
  default     = "NOTSET"
}

variable prometheus_port {
  description = "The port on which Prometheus pod will listen for HTTP requests."
  default     = "9090"
}

variable prometheus_version {
  description = "The prometheus docker image tag"
  default     = "v2.34.0"
}

variable grafana_version {
  description = "The grafana docker image tag"
  default     = "8.4.4"
}

variable prometheus_data_retention_days {
  description = "The number of days Prometheus will be configured to retain data."

  # This is the prometheus default if no value is specified
  default = 15
}

variable "node_selector_map" {
  type        = map
  description = "A map of labels to use for node selection."
  default     = {}
}

variable "recording_rules" {
  description = <<EOF
A blob of recording rules. Format https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/#recording-rules

groups:
  - name: my_rule_group
    rules:
    - record: recorded_metric_name
      expression: expressions_for_recorded_metric
EOF

  default = ""
}