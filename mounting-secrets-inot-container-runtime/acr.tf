resource "azurerm_container_registry" "acr" {
  name                = "certiacr12345"
  resource_group_name = azurerm_resource_group.certificate_rg.name
  location            = azurerm_resource_group.certificate_rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "Production"
  }
}