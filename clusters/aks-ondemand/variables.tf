variable "CLUSTER_NAME" {
  description = "The name of the AKS cluster."
  type        = string
  default     = "cluster-demonstration"
}

variable "location" {
  description = "The Azure region to host the cluster in."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The resource group name. If empty, <CLUSTER_NAME>-rg is used."
  type        = string
  default     = ""
}

variable "dns_prefix" {
  description = "The AKS DNS prefix. If empty, CLUSTER_NAME is used."
  type        = string
  default     = ""
}

variable "kubernetes_version" {
  description = "The AKS Kubernetes version. Leave empty to use the latest supported version for the region."
  type        = string
  default     = ""
}

variable "system_node_vm_size" {
  description = "The VM size for the system node pool."
  type        = string
  default     = "Standard_DC2ads_v5"
}

variable "system_node_count" {
  description = "The fixed node count for the system node pool."
  type        = number
  default     = 2
}

variable "zones" {
  description = "Availability zones for the AKS node pools. Keep empty for regions or subscriptions where AKS reports no zone support."
  type        = list(string)
  default     = []
}

variable "vnet_cidr" {
  description = "The CIDR block for the AKS virtual network."
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the AKS node subnet."
  type        = string
  default     = "10.20.1.0/24"
}

variable "service_cidr" {
  description = "The Kubernetes service CIDR."
  type        = string
  default     = "10.21.0.0/16"
}

variable "dns_service_ip" {
  description = "The Kubernetes DNS service IP. Must be inside service_cidr."
  type        = string
  default     = "10.21.0.10"
}

variable "tags" {
  description = "Tags to apply to Azure resources."
  type        = map(string)
  default     = {}
}
