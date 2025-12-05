output "storage_account_name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "Storage Account ID"
  value       = azurerm_storage_account.main.id
}

output "primary_web_endpoint" {
  description = "Storage Account primary web endpoint"
  value       = azurerm_storage_account.main.primary_web_endpoint
}

output "primary_web_host" {
  description = "Storage Account primary web host"
  value       = azurerm_storage_account.main.primary_web_host
}

