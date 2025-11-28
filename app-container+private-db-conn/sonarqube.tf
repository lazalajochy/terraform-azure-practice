resource "azurerm_container_app" "cg-stagingsonarqube" {
  name                         = "cg-stagingsonarqube"
  resource_group_name          = azurerm_resource_group.db_private_conn.name
  container_app_environment_id = azurerm_container_app_environment.cae-staging.id

  revision_mode = "Single"

  ingress {
    external_enabled = true
    target_port      = 9000

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = {
    name    = "sonarqube-db-private-conn"
    env     = "dev"
    app     = "sonarqube-db-private-conn"
    version = "1.0.0"
    description = "SonarQube container app with private DB connection"
  }

  template {
    container {
      name  = "sonarqube"
      image = "${azurerm_container_registry.acr-db-private-conn.login_server}/sonarqube:latest"
      env {
        name  = "SONAR_JDBC_URL"
        value = "jdbc:postgresql://pg-private-conn.postgres.database.azure.com:5432/sonarqube?sslmode=require"
      }
      env {
        name  = "SONAR_JDBC_USERNAME"
        value = "pgadmin"
      }
      env {
        name  = "SONAR_JDBC_PASSWORD"
        value = "CibaoDev2025!"
      }
      cpu    = 2
      memory = "4Gi"
    }
  }


  registry {
    server               = azurerm_container_registry.acr-db-private-conn.login_server
    username             = azurerm_container_registry.acr-db-private-conn.admin_username
    password_secret_name = "acr-pull-secret"
  }

  secret {
    name  = "acr-pull-secret"
    value = azurerm_container_registry.acr-db-private-conn.admin_password
  }

   depends_on = [
     azurerm_private_endpoint.postgres-private-endpoint,
     azurerm_private_dns_zone_virtual_network_link.dnszone-link
   ]
}
