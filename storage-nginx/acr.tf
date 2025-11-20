resource "azurerm_container_registry" "arcnginx" {
  name                = "acrnginx"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    environment = "production"
    project     = "nginx-forward-proxy"
  }

}