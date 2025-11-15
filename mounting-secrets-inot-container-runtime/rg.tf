resource "azurerm_resource_group" "certificate_rg" {
  name     = "certificate_rg"
  location = "East US"
  tags = {
    environment = "Production"
  }
}