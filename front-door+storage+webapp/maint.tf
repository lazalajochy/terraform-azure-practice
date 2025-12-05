resource "azurerm_resource_group" "rf-frontdoor-storage-webapp" {
  name     = "rgfrontdoorstoragewebapp"
  location = "East US"
  tags = {
    environment = "Development"
  }
}