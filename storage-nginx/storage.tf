resource "azurerm_storage_account" "storageaccountjochy" {
  name                     = "storageaccountjochy"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "share" {
  name                 = "build"
  storage_account_name = azurerm_storage_account.storageaccountjochy.name
  quota                = 20
}

