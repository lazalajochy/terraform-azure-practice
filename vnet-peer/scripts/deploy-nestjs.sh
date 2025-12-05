#!/bin/bash

# Script para construir y desplegar la aplicación NestJS a Container Apps

set -e

echo "🚀 Desplegando NestJS API..."

# Cambiar al directorio de la aplicación
cd "$(dirname "$0")/../apps/nestjs-api"

# Verificar que Terraform esté inicializado
if [ ! -d "../../.terraform" ]; then
    echo "❌ Error: Terraform no está inicializado. Ejecuta 'terraform init' primero."
    exit 1
fi

# Obtener credenciales del Container Registry desde Terraform
echo "📦 Obteniendo información del Container Registry..."
ACR_NAME=$(cd ../.. && terraform output -raw container_registry_login_server 2>/dev/null | sed 's|https://||' || echo "")
ACR_USER=$(cd ../.. && terraform output -raw container_registry_admin_username 2>/dev/null || echo "")
ACR_PASS=$(cd ../.. && terraform output -raw container_registry_admin_password 2>/dev/null || echo "")

if [ -z "$ACR_NAME" ] || [ -z "$ACR_USER" ] || [ -z "$ACR_PASS" ]; then
    echo "❌ Error: No se pudieron obtener las credenciales del Container Registry."
    echo "   Asegúrate de que Terraform haya desplegado la infraestructura correctamente."
    exit 1
fi

echo "✅ Container Registry: $ACR_NAME"

# Instalar dependencias si no existen
if [ ! -d "node_modules" ]; then
    echo "📥 Instalando dependencias..."
    npm install
fi

# Construir la aplicación
echo "🔨 Construyendo la aplicación..."
npm run build

# Login al Container Registry
echo "🔐 Autenticando con Container Registry..."
echo "$ACR_PASS" | docker login "$ACR_NAME" -u "$ACR_USER" --password-stdin

# Construir imagen Docker
echo "🐳 Construyendo imagen Docker..."
docker build -t nestjs-api:latest .

# Tag y push de la imagen
echo "📤 Subiendo imagen al Container Registry..."
docker tag nestjs-api:latest "$ACR_NAME/nestjs-api:latest"
docker push "$ACR_NAME/nestjs-api:latest"

echo "✅ NestJS API desplegada exitosamente!"
echo "   Imagen: $ACR_NAME/nestjs-api:latest"
echo ""
echo "💡 Nota: El Container App se actualizará automáticamente con la nueva imagen."

