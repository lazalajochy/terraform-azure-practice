resource "azurerm_container_app_environment" "env" {
  name                = "react-rolling-env"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}