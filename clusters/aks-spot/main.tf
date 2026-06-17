provider "azurerm" {
  skip_provider_registration = true

  features {}
}

locals {
  resource_group_name = var.resource_group_name != "" ? var.resource_group_name : "${var.CLUSTER_NAME}-rg"
  dns_prefix          = var.dns_prefix != "" ? var.dns_prefix : var.CLUSTER_NAME
  kubernetes_version  = var.kubernetes_version != "" ? var.kubernetes_version : null
  system_zones        = var.system_zones != null ? var.system_zones : var.zones
  spot_zones          = var.spot_zones != null ? var.spot_zones : var.zones

  tags = merge(
    {
      Example      = var.CLUSTER_NAME
      Cloud        = "azure"
      CapacityType = "spot"
      CreatedBy    = "terraform"
    },
    var.tags,
  )
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.CLUSTER_NAME}-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.vnet_cidr]
  tags                = local.tags
}

resource "azurerm_subnet" "aks" {
  name                 = "${var.CLUSTER_NAME}-nodes"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_cidr]
}

resource "azurerm_user_assigned_identity" "aks" {
  name                = "${var.CLUSTER_NAME}-identity"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

resource "azurerm_role_assignment" "aks_network_contributor" {
  scope                = azurerm_subnet.aks.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.CLUSTER_NAME
  location                          = azurerm_resource_group.this.location
  resource_group_name               = azurerm_resource_group.this.name
  dns_prefix                        = local.dns_prefix
  kubernetes_version                = local.kubernetes_version
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  role_based_access_control_enabled = true

  default_node_pool {
    name                 = "system"
    vm_size              = var.system_node_vm_size
    type                 = "VirtualMachineScaleSets"
    node_count           = var.system_node_count
    vnet_subnet_id       = azurerm_subnet.aks.id
    zones                = local.system_zones
    orchestrator_version = local.kubernetes_version

    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  tags = local.tags

  depends_on = [
    azurerm_role_assignment.aks_network_contributor,
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "spot" {
  name                  = "spot"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.spot_node_vm_size
  mode                  = "User"
  os_type               = "Linux"
  priority              = "Spot"
  eviction_policy       = "Delete"
  spot_max_price        = var.spot_max_price
  node_count            = var.spot_node_count
  vnet_subnet_id        = azurerm_subnet.aks.id
  zones                 = local.spot_zones
  orchestrator_version  = local.kubernetes_version

  node_labels = {
    "cloudpilot.ai/capacity-type"           = "spot"
    "kubernetes.azure.com/scalesetpriority" = "spot"
  }

  node_taints = [
    "kubernetes.azure.com/scalesetpriority=spot:NoSchedule",
  ]

  tags = local.tags
}
