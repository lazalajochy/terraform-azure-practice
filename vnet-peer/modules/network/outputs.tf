output "vnet_id" {
  description = "Virtual Network ID"
  value       = azurerm_virtual_network.main.id
}

output "container_apps_subnet_id" {
  description = "Container Apps subnet ID"
  value       = azurerm_subnet.container_apps.id
}

output "api_management_subnet_id" {
  description = "API Management subnet ID"
  value       = azurerm_subnet.api_management.id
}

output "private_endpoints_subnet_id" {
  description = "Private Endpoints subnet ID"
  value       = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_storage_id" {
  description = "Private DNS Zone ID for Storage"
  value       = azurerm_private_dns_zone.storage.id
}

output "private_dns_zone_storage_name" {
  description = "Private DNS Zone name for Storage"
  value       = azurerm_private_dns_zone.storage.name
}

