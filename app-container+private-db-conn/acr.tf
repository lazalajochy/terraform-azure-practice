resource "azurerm_container_registry" "acr-db-private-conn" {
  name                = "acrdbprivateconn"
  resource_group_name = azurerm_resource_group.db_private_conn.name
  location            = azurerm_resource_group.db_private_conn.location
  sku                 = "Basic"
  admin_enabled       = true

}