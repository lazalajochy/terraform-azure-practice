# Front Door Profile
resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "fd-${substr(replace(var.resource_group_name, "-", ""), 0, 15)}${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_AzureFrontDoor"

  tags = var.tags
}

# Front Door Origin Group for Storage Account (Next.js)
resource "azurerm_cdn_frontdoor_origin_group" "storage" {
  name                     = "fdog-storage"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    protocol            = "Https"
    request_type        = "HEAD"
    interval_in_seconds = 100
    path                = "/"
  }
}

# Front Door Origin for Storage Account
resource "azurerm_cdn_frontdoor_origin" "storage" {
  name                          = "fdo-storage"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage.id
  enabled                       = true

  certificate_name_check_enabled = true
  host_name                      = var.storage_account_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.storage_account_name
  priority                       = 1
  weight                         = 1000

  private_link {
    request_message        = "Request access for Front Door"
    target_type            = "blob"
    location               = var.location
    private_link_target_id = var.storage_account_id
  }
}

# Front Door Origin Group for API Management
resource "azurerm_cdn_frontdoor_origin_group" "api_management" {
  name                     = "fdog-apim"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    protocol            = "Https"
    request_type        = "HEAD"
    interval_in_seconds = 100
    path                = "/status-0123456789abcdef"
  }
}

# Front Door Origin for API Management
resource "azurerm_cdn_frontdoor_origin" "api_management" {
  name                          = "fdo-apim"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api_management.id
  enabled                       = true

  certificate_name_check_enabled = false
  host_name                      = var.api_management_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.api_management_hostname
  priority                       = 1
  weight                         = 1000
}

# Front Door Endpoint
resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "fde-${substr(replace(var.resource_group_name, "-", ""), 0, 15)}${substr(md5(var.resource_group_name), 0, 8)}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id

  tags = var.tags
}

# Front Door Route for Storage (Next.js) - Root path
resource "azurerm_cdn_frontdoor_route" "storage" {
  name                          = "fdr-storage"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.storage.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.storage.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_rule_set_ids = []

  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress      = ["text/html", "text/css", "application/javascript", "application/json"]
  }
}

# Front Door Route for API Management - /api/* path
resource "azurerm_cdn_frontdoor_route" "api_management" {
  name                          = "fdr-apim"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api_management.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.api_management.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = ["/api/*"]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_rule_set_ids = []
}

# Front Door Custom Domain (optional - you can add your own domain)
# For now, we'll use the default Front Door domain

