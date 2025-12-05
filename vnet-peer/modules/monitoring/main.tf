# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-private-apps-${substr(md5(var.resource_group_name), 0, 8)}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

