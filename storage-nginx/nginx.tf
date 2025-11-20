resource "azurerm_container_app" "nginx" {
  name                         = "nginx-gateway"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.webserver-env.id

  revision_mode = "Single"

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    name    = "cibao"
    env     = "dev"
    app     = "nginx-cibao"
    version = "1.0.0"
  }

  template {
    container {
      name   = "nginx"
      image  = "${azurerm_container_registry.arcnginx.login_server}/nginx-cibao:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  registry {
    server               = azurerm_container_registry.arcnginx.login_server
    username             = azurerm_container_registry.arcnginx.admin_username
    password_secret_name = "acr-pull-secret"
  }

  secret {
    name  = "acr-pull-secret"
    value = azurerm_container_registry.arcnginx.admin_password
  }
}