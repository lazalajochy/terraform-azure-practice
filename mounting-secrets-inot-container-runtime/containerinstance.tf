resource "azurerm_container_group" "nestjs_container" {
  name                = "nestjs-container"
  location            = azurerm_resource_group.certificate_rg.location
  resource_group_name = azurerm_resource_group.certificate_rg.name
  os_type             = "Linux"

  identity {
    type = "SystemAssigned"
  }

  container {
    name   = "nestjs-app"
    image  = "${azurerm_container_registry.acr.login_server}/backend-nest:latest"
    cpu    = 1
    memory = 1.5

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      NODE_ENV       = "production"
      PORT           = "3000"
      ACAP_CERT_PATH = "/app/certs/acapJwsPrivateKey.pem"
      NAME           = "nestjscloud-jochy"
    }

    volume {
      name                 = "cert-volume"
      mount_path           = "/app/certs"
      share_name           = azurerm_storage_share.share.name
      storage_account_name = azurerm_storage_account.storageaccountjochy.name
      storage_account_key  = azurerm_storage_account.storageaccountjochy.primary_access_key


    }
  }



  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  ip_address_type = "Public"
  dns_name_label  = "nestjscloud-jochy"
}
