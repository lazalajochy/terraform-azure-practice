resource "azurerm_postgresql_flexible_server" "pg-private-conn" {
  name                   = "pg-private-conn"
  resource_group_name    = azurerm_resource_group.db_private_conn.name
  location               = "eastus2"
  administrator_login    = "pgadmin"
  administrator_password = "CibaoDev2025!"
  version                = "13"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  zone                   = "1"
  backup_retention_days  = 7

  public_network_access_enabled = false

  #Admin2020!test
  authentication {
    password_auth_enabled = true
  }

  # depends_on = [
  #  azurerm_virtual_network.vnet,
  #  azurerm_subnet.snet-private-endpoint
  #]

  lifecycle {
    ignore_changes = [administrator_password]
  }
}
