resource "azurerm_storage_account" "storageaccountjochy" {
  name                     = "storageaccountjochy"
  resource_group_name      = azurerm_resource_group.stataic_web_app_rg.name
  location                 = azurerm_resource_group.stataic_web_app_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }
}


resource "azurerm_storage_container" "static_containerapp" {
  name                  = "staticcontainerapp"
  storage_account_name  = azurerm_storage_account.storageaccountjochy.name
  container_access_type = "blob"
}