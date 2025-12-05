# Outputs para mostrar las URLs importantes
output "storage_account_primary_web_endpoint" {
  description = "URL del static website en el storage account"
  value       = azurerm_storage_account_static_website.static_website02.primary_web_endpoint
}

output "storage_account_primary_web_host" {
  description = "Host del static website en el storage account"
  value       = azurerm_storage_account_static_website.static_website02.primary_web_host
}

output "front_door_endpoint_hostname" {
  description = "Hostname del endpoint de Front Door (dominio por defecto)"
  value       = azurerm_cdn_frontdoor_endpoint.web_endpoint.host_name
}

output "front_door_endpoint_url" {
  description = "URL completa del endpoint de Front Door (sin dominio personalizado)"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.web_endpoint.host_name}"
}

output "custom_domain" {
  description = "Dominio personalizado configurado"
  value       = azurerm_cdn_frontdoor_custom_domain.ihelpyoutodo_domain.host_name
}

output "custom_domain_url" {
  description = "URL completa con dominio personalizado"
  value       = "https://${azurerm_cdn_frontdoor_custom_domain.ihelpyoutodo_domain.host_name}"
}


