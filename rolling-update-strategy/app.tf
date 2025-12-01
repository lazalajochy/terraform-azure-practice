resource "azurerm_container_app" "react-rolling" {
  name                         = "react-rolling"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Multiple"

  ingress {
    external_enabled = true
    target_port      = 80

    # Si no hay revision_suffix, 100% va a latest_revision (rolling update simple)
    # Si hay revision_suffix, 50% a latest y 50% a la revisión anterior (canary/blue-green)
    dynamic "traffic_weight" {
      for_each = var.revision_suffix != "" ? [1] : []
      content {
        revision_suffix = var.revision_suffix
        percentage      = 50
      }
    }

    traffic_weight {
      percentage      = var.revision_suffix != "" ? 50 : 100
      latest_revision = true
    }
  }

  tags = {
    name        = "react-rolling"
    env         = "dev"
    app         = "react-rolling"
    version     = "1.0.0"
    description = "React container app with rolling update strategy"
  }

  template {
    container {
      name  = "react-rolling"
      image = "${azurerm_container_registry.acr.login_server}/rollingupdatestrategy:latest"

      cpu    = 2
      memory = "4Gi"
    }
  }


  registry {
    server               = azurerm_container_registry.acr.login_server
    username             = azurerm_container_registry.acr.admin_username
    password_secret_name = "acr-pull-secret"
  }

  secret {
    name  = "acr-pull-secret"
    value = azurerm_container_registry.acr.admin_password
  }


}
