# Infraestructura Azure con Terraform - Aplicaciones Privadas

Este proyecto implementa una arquitectura completa en Azure donde todas las aplicaciones están en red privada, excepto Azure Front Door que es el único punto de entrada público a Internet.

## Arquitectura

```
Internet
    ↓
Azure Front Door (Público)
    ↓
    ├─→ Storage Account (Privado) → Next.js App
    └─→ API Management (Privado) → Container Apps (Privado) → NestJS API
```

### Componentes

1. **Azure Front Door**: Único punto público de entrada
   - Sirve la aplicación Next.js desde Storage Account
   - Enruta las peticiones `/api/*` a API Management

2. **Storage Account**: Almacenamiento privado para la aplicación Next.js
   - Static Website habilitado
   - Acceso privado mediante Private Endpoint
   - Conectado a Front Door mediante Private Link

3. **API Management**: Gateway privado para APIs
   - Configurado en modo interno (sin IP pública)
   - Se comunica con Container Apps mediante red privada
   - Expone las APIs de NestJS

4. **Container Apps**: Entorno privado para aplicaciones contenedorizadas
   - Container Apps Environment con Load Balancer interno
   - Container App ejecutando NestJS API
   - Container Registry para almacenar imágenes

5. **Virtual Network**: Red privada que conecta todos los componentes
   - Subnets dedicadas para cada servicio
   - Private Endpoints para comunicación privada
   - Private DNS Zones para resolución de nombres

## Estructura del Proyecto

```
.
├── main.tf                 # Configuración principal de Terraform
├── variables.tf            # Variables de Terraform
├── outputs.tf             # Outputs de Terraform
├── terraform.tfvars.example # Ejemplo de variables
├── modules/                # Módulos de Terraform
│   ├── network/           # Módulo de red (VNet, subnets, DNS)
│   ├── container-apps/    # Módulo de Container Apps
│   ├── api-management/    # Módulo de API Management
│   ├── storage/           # Módulo de Storage Account
│   ├── front-door/        # Módulo de Front Door
│   └── monitoring/        # Módulo de Log Analytics
└── apps/                   # Aplicaciones
    ├── nestjs-api/        # API NestJS
    └── nextjs-app/        # Aplicación Next.js
```

## Prerrequisitos

1. **Azure CLI** instalado y configurado
2. **Terraform** >= 1.0 instalado
3. **Docker** instalado (para construir imágenes)
4. **Node.js** >= 18 instalado (para las aplicaciones)
5. **Permisos de Azure**:
   - Contributor o Owner en la suscripción
   - Permisos para crear Resource Groups, VNets, Container Apps, API Management, Storage Accounts, Front Door

## Configuración Inicial

### 1. Autenticación en Azure

```bash
az login
az account set --subscription "TU-SUSCRIPCION-ID"
```

### 2. Configurar Variables de Terraform

Copia el archivo de ejemplo y ajusta los valores:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edita `terraform.tfvars` con tus valores:

```hcl
resource_group_name = "rg-private-apps"
location           = "East US"
vnet_address_space = ["10.0.0.0/16"]

tags = {
  Environment = "dev"
  Project     = "private-apps"
  ManagedBy   = "Terraform"
}
```

### 3. Inicializar Terraform

```bash
terraform init
```

## Despliegue

### 1. Desplegar Infraestructura

```bash
# Revisar el plan
terraform plan

# Aplicar los cambios
terraform apply
```

Este proceso puede tardar 30-45 minutos ya que crea varios recursos de Azure.

### 2. Construir y Desplegar NestJS API

```bash
cd apps/nestjs-api

# Instalar dependencias
npm install

# Construir la aplicación
npm run build

# Obtener credenciales del Container Registry
ACR_NAME=$(terraform -chdir=../.. output -raw container_registry_login_server | sed 's|https://||')
ACR_USER=$(terraform -chdir=../.. output -raw container_registry_admin_username)
ACR_PASS=$(terraform -chdir=../.. output -raw container_registry_admin_password)

# Login al Container Registry
echo $ACR_PASS | docker login $ACR_NAME -u $ACR_USER --password-stdin

# Construir imagen Docker
docker build -t nestjs-api:latest .

# Tag y push de la imagen
docker tag nestjs-api:latest $ACR_NAME/nestjs-api:latest
docker push $ACR_NAME/nestjs-api:latest
```

### 3. Construir y Desplegar Next.js App

```bash
cd apps/nextjs-app

# Instalar dependencias
npm install

# Construir la aplicación para producción
npm run build

# Obtener nombre del Storage Account
STORAGE_ACCOUNT=$(terraform -chdir=../.. output -raw storage_account_name)
RESOURCE_GROUP=$(terraform -chdir=../.. output -raw resource_group_name)

# Subir archivos al Storage Account
az storage blob upload-batch \
  --account-name $STORAGE_ACCOUNT \
  --destination '$web' \
  --source ./out \
  --auth-mode login
```

## Uso

Una vez desplegado, obtén la URL de Front Door:

```bash
terraform output front_door_url
```

Accede a la URL en tu navegador. Deberías ver:
- La aplicación Next.js en la raíz
- Las APIs de NestJS disponibles en `/api/*`

## Endpoints Disponibles

- `GET /` - Página principal de Next.js
- `GET /api/` - Endpoint raíz de NestJS API
- `GET /api/health` - Health check de NestJS API
- `GET /api/api/data` - Datos de ejemplo de NestJS API

## Limpieza

Para eliminar todos los recursos:

```bash
terraform destroy
```

**Nota**: Esto eliminará todos los recursos creados. Asegúrate de tener backups si es necesario.

## Costos Estimados

Esta arquitectura incluye:
- Container Apps Environment: ~$0.20/hora
- API Management (Developer): ~$0.07/hora
- Storage Account: ~$0.02/GB/mes
- Front Door: ~$0.15/GB transferido
- VNet y otros recursos: ~$0.05/hora

**Total estimado**: ~$0.50-1.00/hora en modo desarrollo

## Troubleshooting

### Container App no inicia
- Verifica que la imagen esté en el Container Registry
- Revisa los logs en Log Analytics Workspace
- Verifica que el Container App tenga acceso a la subnet correcta

### API Management no responde
- Verifica que el DNS privado esté configurado correctamente
- Asegúrate de que el Container App esté accesible desde la subnet de API Management
- Revisa las políticas de API Management

### Front Door no sirve contenido
- Verifica que el Storage Account tenga Static Website habilitado
- Asegúrate de que los archivos estén en el contenedor `$web`
- Verifica las rutas configuradas en Front Door

## Mejores Prácticas Implementadas

✅ **Seguridad**:
- Todos los servicios en red privada (excepto Front Door)
- Private Endpoints para Storage Account
- API Management en modo interno
- Container Apps con Load Balancer interno

✅ **Escalabilidad**:
- Container Apps con auto-scaling (1-3 réplicas)
- Front Door con CDN global

✅ **Monitoreo**:
- Log Analytics Workspace para logs centralizados
- Health checks configurados

✅ **Modularidad**:
- Código Terraform organizado en módulos
- Separación de responsabilidades

## Próximos Pasos

- [ ] Agregar certificados SSL personalizados
- [ ] Configurar WAF (Web Application Firewall) en Front Door
- [ ] Implementar CI/CD con GitHub Actions
- [ ] Agregar Application Insights para monitoreo
- [ ] Configurar alertas y notificaciones

## Soporte

Para problemas o preguntas, revisa:
- [Documentación de Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Documentación de Azure Container Apps](https://learn.microsoft.com/azure/container-apps/)
- [Documentación de Azure API Management](https://learn.microsoft.com/azure/api-management/)

