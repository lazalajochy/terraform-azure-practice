resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = azurerm_resource_group.db_private_conn.location
  resource_group_name = azurerm_resource_group.db_private_conn.name
  address_space       = ["10.0.0.0/16"]
}