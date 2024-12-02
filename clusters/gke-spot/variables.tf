variable "CLUSTER_NAME" {
  description = "The name of the cluster."
  default     = "cluster-demonstration"
}

variable "PROJECT_ID" {
  description = "The project ID to host the cluster in"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zones" {
  type        = list(string)
  description = "The zone to host the cluster in (required if is a zonal cluster)"
  default     = ["us-central1-a", "us-central1-b"]
}

variable "network" {
  description = "The VPC network to host the cluster in"
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  default     = "default"
}

variable "ip_range_pods" {
  description = "The secondary ip range to use for pods"
  default     = ""
}

variable "ip_range_services" {
  description = "The secondary ip range to use for services"
  default     = ""
}
