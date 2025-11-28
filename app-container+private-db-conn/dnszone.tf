# Private DNS Zone para PostgreSQL privado
resource "azurerm_private_dns_zone" "dnszone-postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.db_private_conn.name
}

# Vincular la DNS Zone con la VNET
resource "azurerm_private_dns_zone_virtual_network_link" "dnszone-link" {
  name                  = "vnet-dnszone-link"
  resource_group_name   = azurerm_resource_group.db_private_conn.name
  private_dns_zone_name = azurerm_private_dns_zone.dnszone-postgres.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

# Registro DNS A para el servidor PostgreSQL
resource "azurerm_private_dns_a_record" "postgres-a-record" {
  name                = "pg-private-conn"
  zone_name           = azurerm_private_dns_zone.dnszone-postgres.name
  resource_group_name = azurerm_resource_group.db_private_conn.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.postgres-private-endpoint.custom_dns_configs[0].ip_addresses[0]]

  depends_on = [
    azurerm_private_endpoint.postgres-private-endpoint,
    azurerm_private_dns_zone.dnszone-postgres
  ]
}
