output "front_door_url" {
  description = "Front Door URL (public endpoint)"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
}

output "front_door_endpoint_id" {
  description = "Front Door Endpoint ID"
  value       = azurerm_cdn_frontdoor_endpoint.main.id
}

