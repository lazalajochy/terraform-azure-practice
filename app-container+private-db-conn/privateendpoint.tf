resource "azurerm_private_endpoint" "postgres-private-endpoint" {
  name                = "postgres-private-endpoint"
  location            = azurerm_resource_group.db_private_conn.location
  resource_group_name = azurerm_resource_group.db_private_conn.name
  subnet_id           = azurerm_subnet.snet-private-endpoint.id

  private_service_connection {
    name                           = "postgres-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_flexible_server.pg-private-conn.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  depends_on = [
    azurerm_postgresql_flexible_server.pg-private-conn,
    azurerm_subnet.snet-private-endpoint
  ]
}
