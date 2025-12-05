resource "azurerm_storage_account" "storage_staticwebtorageachraf002" {
  name                              = "staticwebtorageachraf002"
  resource_group_name               = azurerm_resource_group.rf-frontdoor-storage-webapp.name
  location                          = azurerm_resource_group.rf-frontdoor-storage-webapp.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  account_kind                      = "StorageV2"
  infrastructure_encryption_enabled = true
  tags = {
    environment = "Production"
  }

}

# https://www.youtube.com/watch?v=kApNoc4kaIU

resource "azurerm_storage_account_static_website" "static_website02" {
  storage_account_id = azurerm_storage_account.storage_staticwebtorageachraf002.id
  index_document     = "index.html"
  # error_404_document = "404.html"
}

# Upload index.html to the static website
resource "azurerm_storage_blob" "index_html" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.storage_staticwebtorageachraf002.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source_content         = <<-HTML
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Sitio Web Estático</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        p {
            line-height: 1.6;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 ¡Bienvenido a mi sitio web estático!</h1>
        <p>Este sitio está siendo servido desde Azure Storage Account a través de Azure Front Door.</p>
        <p>Si puedes ver esta página, significa que la configuración está funcionando correctamente.</p>
        <p><strong>Storage Account:</strong> staticwebtorageachraf002</p>
        <p><strong>Front Door Profile:</strong> achrafbenalayastaticwebsite008</p>
    </div>
</body>
</html>
HTML
}