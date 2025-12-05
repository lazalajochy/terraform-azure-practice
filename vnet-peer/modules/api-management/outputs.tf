output "api_management_id" {
  description = "API Management ID"
  value       = azurerm_api_management.main.id
}

output "hostname" {
  description = "API Management hostname"
  value       = azurerm_api_management.main.gateway_url
}

output "private_ip_address" {
  description = "API Management private IP address"
  value       = azurerm_api_management.main.private_ip_addresses[0]
}

