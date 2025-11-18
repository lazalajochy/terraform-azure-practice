resource "azurerm_container_app" "app1" {
  name                         = "app1"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  ingress {
    external_enabled = false
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "app1"
      image  = "nginx:latest"
      cpu    = 0.5
      memory = "1Gi"
      
    }
  }
}

# https://app1.wonderfulsand-18e38eca.eastus.azurecontainerapps.io/