resource "azurerm_container_app_environment" "cae-staging" {
  name                           = "cae-staging"
  location                       = azurerm_resource_group.db_private_conn.location
  resource_group_name            = azurerm_resource_group.db_private_conn.name
  internal_load_balancer_enabled = false
  infrastructure_subnet_id       = azurerm_subnet.sn-staging.id



  tags = {
    environment = "staging"
  }
}