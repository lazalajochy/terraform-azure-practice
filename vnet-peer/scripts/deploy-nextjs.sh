#!/bin/bash

# Script para construir y desplegar la aplicación Next.js a Storage Account

set -e

echo "🚀 Desplegando Next.js App..."

# Cambiar al directorio de la aplicación
cd "$(dirname "$0")/../apps/nextjs-app"

# Verificar que Terraform esté inicializado
if [ ! -d "../../.terraform" ]; then
    echo "❌ Error: Terraform no está inicializado. Ejecuta 'terraform init' primero."
    exit 1
fi

# Obtener información del Storage Account desde Terraform
echo "📦 Obteniendo información del Storage Account..."
STORAGE_ACCOUNT=$(cd ../.. && terraform output -raw storage_account_name 2>/dev/null || echo "")
RESOURCE_GROUP=$(cd ../.. && terraform output -raw resource_group_name 2>/dev/null || echo "")

if [ -z "$STORAGE_ACCOUNT" ] || [ -z "$RESOURCE_GROUP" ]; then
    echo "❌ Error: No se pudo obtener la información del Storage Account."
    echo "   Asegúrate de que Terraform haya desplegado la infraestructura correctamente."
    exit 1
fi

echo "✅ Storage Account: $STORAGE_ACCOUNT"
echo "✅ Resource Group: $RESOURCE_GROUP"

# Instalar dependencias si no existen
if [ ! -d "node_modules" ]; then
    echo "📥 Instalando dependencias..."
    npm install
fi

# Construir la aplicación para producción
echo "🔨 Construyendo la aplicación..."
npm run build

# Verificar que el directorio out existe
if [ ! -d "out" ]; then
    echo "❌ Error: El directorio 'out' no existe después de la construcción."
    exit 1
fi

# Subir archivos al Storage Account
echo "📤 Subiendo archivos al Storage Account..."
az storage blob upload-batch \
    --account-name "$STORAGE_ACCOUNT" \
    --destination '$web' \
    --source ./out \
    --auth-mode login \
    --overwrite

echo "✅ Next.js App desplegada exitosamente!"
echo "   Storage Account: $STORAGE_ACCOUNT"
echo ""
echo "💡 Nota: Los cambios pueden tardar unos minutos en reflejarse en Front Door."

