# Subnet para servicios generales (tu actual)
resource "azurerm_subnet" "sn-staging" {
  name                 = "sn-staging"
  resource_group_name  = azurerm_resource_group.db_private_conn.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/23"]
  service_endpoints    = ["Microsoft.Storage"]

}

# Subnet exclusiva para Private Endpoint de PostgreSQL
resource "azurerm_subnet" "snet-private-endpoint" {
  name                 = "snet-private-endpoint"
  resource_group_name  = azurerm_resource_group.db_private_conn.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}