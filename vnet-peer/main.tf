terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    # Configure backend in terraform.tfvars or via environment variables
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Network Module
module "network" {
  source = "./modules/network"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  vnet_address_space = var.vnet_address_space
  tags               = var.tags
}

# Container Apps Module
module "container_apps" {
  source = "./modules/container-apps"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.network.container_apps_subnet_id
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
  tags               = var.tags

  depends_on = [module.network]
}

# API Management Module
module "api_management" {
  source = "./modules/api-management"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  subnet_id          = module.network.api_management_subnet_id
  vnet_id            = module.network.vnet_id
  container_app_url  = module.container_apps.fqdn
  tags               = var.tags

  depends_on = [module.network, module.container_apps]
}

# Storage Account Module
module "storage" {
  source = "./modules/storage"

  resource_group_name            = azurerm_resource_group.main.name
  location                       = azurerm_resource_group.main.location
  private_endpoints_subnet_id    = module.network.private_endpoints_subnet_id
  private_dns_zone_storage_name  = module.network.private_dns_zone_storage_name
  tags                           = var.tags

  depends_on = [module.network]
}

# Front Door Module
module "front_door" {
  source = "./modules/front-door"

  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  storage_account_name     = module.storage.storage_account_name
  storage_account_id       = module.storage.storage_account_id
  api_management_hostname  = module.api_management.hostname
  tags                     = var.tags

  depends_on = [module.storage, module.api_management]
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  tags               = var.tags
}

