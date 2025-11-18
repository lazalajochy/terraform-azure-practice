resource "azurerm_container_app_environment" "env" {
  name                        = "aca-env"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  infrastructure_subnet_id    = azurerm_subnet.subnet.id
  internal_load_balancer_enabled = false
}
