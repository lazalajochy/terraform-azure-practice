resource "azurerm_container_app" "app2" {
  name                         = "app2"
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

  template {
    container {
      name   = "app2"
      image  = "${azurerm_container_registry.arcnginx.login_server}/app:latest"
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