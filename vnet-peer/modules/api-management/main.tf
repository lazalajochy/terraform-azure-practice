# API Management (Private)
resource "azurerm_api_management" "main" {
  name                = "apim-private-apps-${substr(md5(var.resource_group_name), 0, 8)}"
  location           = var.location
  resource_group_name = var.resource_group_name
  publisher_name     = "My Company"
  publisher_email    = "admin@mycompany.com"

  sku_name = "Developer_1"

  virtual_network_type = "Internal"
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  public_ip_address_id = null

  tags = var.tags
}

# Private DNS Zone for API Management
resource "azurerm_private_dns_zone" "api_management" {
  name                = "privatelink.azure-api.net"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "api_management" {
  name                  = "vnet-link-api-management"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.api_management.name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false

  tags = var.tags
}

# API Management Backend pointing to Container App
resource "azurerm_api_management_backend" "nestjs" {
  name                = "nestjs-backend"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  protocol            = "http"
  url                 = "http://${var.container_app_url}"

  tls {
    validate_certificate_chain = false
    validate_certificate_name   = false
  }
}

# API Management API
resource "azurerm_api_management_api" "nestjs" {
  name                = "nestjs-api"
  resource_group_name = var.resource_group_name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "NestJS API"
  path                = "api"
  protocols           = ["https"]

  import {
    content_format = "openapi"
    content_value  = <<EOF
openapi: 3.0.0
info:
  title: NestJS API
  version: 1.0.0
paths:
  /:
    get:
      responses:
        '200':
          description: Success
EOF
  }
}

# API Management API Operation
resource "azurerm_api_management_api_operation" "nestjs" {
  operation_id        = "get-root"
  api_name            = azurerm_api_management_api.nestjs.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name
  display_name        = "GET /"
  method              = "GET"
  url_template        = "/"

  response {
    status_code = 200
  }
}

# API Management API Backend Policy
resource "azurerm_api_management_api_policy" "nestjs" {
  api_name            = azurerm_api_management_api.nestjs.name
  api_management_name = azurerm_api_management.main.name
  resource_group_name = var.resource_group_name

  xml_content = <<XML
<policies>
  <inbound>
    <base />
    <set-backend-service backend-id="${azurerm_api_management_backend.nestjs.name}" />
  </inbound>
  <backend>
    <base />
  </backend>
  <outbound>
    <base />
  </outbound>
  <on-error>
    <base />
  </on-error>
</policies>
XML
}

