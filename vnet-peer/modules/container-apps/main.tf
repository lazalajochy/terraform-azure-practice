# Container Apps Environment (Private)
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-private-apps"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  infrastructure_subnet_id   = var.subnet_id
  internal_load_balancer_enabled = true

  tags = var.tags
}

# Container Registry (for storing images)
resource "azurerm_container_registry" "main" {
  name                = "acr${substr(md5(var.resource_group_name), 0, 12)}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = var.tags
}

# Container App for NestJS API
resource "azurerm_container_app" "nestjs" {
  name                         = "ca-nestjs-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  ingress {
    external_enabled = false
    target_port      = 3000
    transport        = "http"
    allow_insecure   = false
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = "nestjs-api"
      image  = "${azurerm_container_registry.main.login_server}/nestjs-api:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "PORT"
        value = "3000"
      }

      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    username = azurerm_container_registry.main.admin_username
    password_secret_name = "registry-password"
  }

  secret {
    name  = "registry-password"
    value = azurerm_container_registry.main.admin_password
  }

  tags = var.tags
}

