resource "azurerm_container_app" "nginx" {
  name                         = "nginx-gateway"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  ingress {
    external_enabled = true
    target_port      = 80
    
    traffic_weight {
      percentage      = 100
      # FIX: Specify that 100% of traffic goes to the current/latest revision.
      latest_revision = true 
    }
  }

  tags = {
        name = "latest"
      
      }
  

  template {
    container {
      name   = "nginx"
      image  = "nginx:latest"
      cpu    = 0.5
      memory = "1Gi"

      volume_mounts {
        name = "conf"
        path = "/etc/nginx.conf"
      }

      
    }

    volume {
      name         = "conf"
      storage_type = "EmptyDir"
    }
  }
}