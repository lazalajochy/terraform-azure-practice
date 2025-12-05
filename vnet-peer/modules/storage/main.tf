# Storage Account for Static Website (Next.js)
resource "azurerm_storage_account" "main" {
  name                     = "st${substr(replace(var.resource_group_name, "-", ""), 0, 20)}${substr(md5(var.resource_group_name), 0, 8)}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  static_website {
    index_document     = "index.html"
    error_404_document = "404.html"
  }

  # Disable public access
  public_network_access_enabled = false

  tags = var.tags
}

# Private Endpoint for Storage Account
resource "azurerm_private_endpoint" "storage" {
  name                = "pe-storage-${azurerm_storage_account.main.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id

  private_service_connection {
    name                           = "psc-storage-${azurerm_storage_account.main.name}"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Private DNS Zone Record for Storage Account
resource "azurerm_private_dns_a_record" "storage" {
  name                = azurerm_storage_account.main.name
  zone_name           = var.private_dns_zone_storage_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage.private_ip_address]

  tags = var.tags
}

