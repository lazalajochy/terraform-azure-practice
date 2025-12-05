output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "front_door_url" {
  description = "Front Door URL (public endpoint)"
  value       = module.front_door.front_door_url
}

output "api_management_hostname" {
  description = "API Management hostname"
  value       = module.api_management.hostname
}

output "container_app_fqdn" {
  description = "Container App FQDN"
  value       = module.container_apps.fqdn
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = module.storage.storage_account_name
}

output "storage_primary_web_endpoint" {
  description = "Storage Account primary web endpoint"
  value       = module.storage.primary_web_endpoint
}

