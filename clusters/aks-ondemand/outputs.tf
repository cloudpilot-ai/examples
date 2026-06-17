output "cluster_name" {
  description = "The AKS cluster name."
  value       = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  description = "The AKS resource group name."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The AKS region."
  value       = azurerm_resource_group.this.location
}

output "node_resource_group" {
  description = "The AKS managed node resource group."
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "oidc_issuer_url" {
  description = "The AKS OIDC issuer URL."
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

output "subnet_id" {
  description = "The AKS node subnet ID."
  value       = azurerm_subnet.aks.id
}

output "user_assigned_identity_id" {
  description = "The user-assigned identity ID used by AKS."
  value       = azurerm_user_assigned_identity.aks.id
}

output "kube_config_raw" {
  description = "Raw kubeconfig for the AKS cluster."
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}
