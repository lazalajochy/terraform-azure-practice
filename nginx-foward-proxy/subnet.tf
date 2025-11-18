resource "azurerm_subnet" "subnet" {
  name                 = "aca-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/23"]

  #delegation {
  #  name = "delegation"
  #  service_delegation {
  #    name = "Microsoft.App/environments"
  #    actions = [
  #      "Microsoft.Network/virtualNetworks/subnets/join/action",
  #      "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
  #      "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
  #    ]
  #  }
  #}
}
