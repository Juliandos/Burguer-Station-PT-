# Docker Setup - Burger Station con Nginx

Esta guía te ayudará a ejecutar la aplicación Burger Station usando Docker, Docker Compose y Nginx como proxy reverso.

## Arquitectura

La aplicación utiliza la siguiente arquitectura:
- **Nginx**: Proxy reverso con SSL/HTTPS
- **NextJS App**: Aplicación principal en contenedor
- **MySQL**: Base de datos en contenedor
- **SSL/TLS**: Certificados para HTTPS

## Requisitos Previos

- Docker (versión 20.10 o superior)
- Docker Compose (versión 2.0 o superior)
- OpenSSL (para generar certificados de desarrollo)

## Configuración Inicial

### 1. Clonar el repositorio y configurar variables de entorno

```bash
# Copiar el archivo de variables de entorno
cp env.example .env

# Editar las variables de entorno según tus necesidades
nano .env
```

### 2. Variables de entorno importantes

Asegúrate de configurar las siguientes variables en tu archivo `.env`:

```env
# Base de datos
MYSQL_ROOT_PASSWORD=tu_password_seguro
MYSQL_DATABASE=burger_station
MYSQL_USER=burger_user
MYSQL_PASSWORD=tu_password_usuario

# NextAuth
NEXTAUTH_SECRET=tu_clave_secreta_muy_larga_y_segura
NEXTAUTH_URL=http://localhost:3000

# Cloudinary (si usas imágenes)
CLOUDINARY_CLOUD_NAME=tu_cloud_name
CLOUDINARY_API_KEY=tu_api_key
CLOUDINARY_API_SECRET=tu_api_secret
```

## Configuración SSL

### Para Desarrollo (Certificados Autofirmados)

```bash
# Linux/Mac
./nginx/generate-ssl.sh

# Windows
nginx\generate-ssl.bat
```

### Para Producción (Let's Encrypt)

```bash
# Configurar con tu dominio (debe apuntar a 187.13.14.29)
./nginx/setup-letsencrypt.sh tu-dominio.com tu-email@dominio.com
```

## Ejecución

### Desarrollo

```bash
# 1. Generar certificados SSL para desarrollo
./nginx/generate-ssl.sh

# 2. Construir y ejecutar todos los servicios
docker-compose up --build

# Ejecutar.up -d --build

# Ver logs
docker-compose logs -f

# Ver logs de un servicio específico
docker-compose logs -f app
docker-compose logs -f nginx
docker-compose logs -f mysql
```

### Producción

```bash
# Ejecutar en modo producción
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

## Comandos Útiles

### Gestión de contenedores

```bash
# Detener todos los servicios
docker-compose down

# Detener y eliminar volúmenes (CUIDADO: esto borrará la base de datos)
docker-compose down -v

# Reiniciar un servicio específico
docker-compose restart app

# Reconstruir un servicio específico
docker-compose up --build app
```

### Base de datos

```bash
# Acceder al contenedor de MySQL
docker-compose exec mysql mysql -u burger_user -p burger_station

# Hacer backup de la base de datos
docker-compose exec mysql mysqldump -u burger_user -p burger_station > backup.sql

# Restaurar backup
docker-compose exec -T mysql mysql -u burger_user -p burger_station < backup.sql

# Ejecutar migraciones de Prisma
docker-compose exec app npx prisma migrate deploy

# Generar cliente de Prisma
docker-compose exec app npx prisma generate
```

### Aplicación

```bash
# Acceder al contenedor de la aplicación
docker-compose exec app sh

# Ver logs de la aplicación
docker-compose logs -f app

# Reiniciar la aplicación
docker-compose restart app
```

## Estructura de Archivos Docker

```
├── Dockerfile                 # Imagen de la aplicación NextJS
├── docker-compose.yml        # Configuración de servicios
├── .dockerignore             # Archivos a ignorar en el build
├── env.example               # Variables de entorno de ejemplo
├── script-bd.sql             # Script de inicialización de BD
├── nginx/
│   ├── nginx.conf            # Configuración de Nginx
│   ├── ssl/                  # Certificados SSL
│   ├── generate-ssl.sh       # Script para generar SSL de desarrollo
│   ├── generate-ssl.bat      # Script SSL para Windows
│   └── setup-letsencrypt.sh  # Script para Let's Encrypt
└── docker/
    ├── mysql/
    │   └── conf.d/
    │       └── mysql.cnf     # Configuración de MySQL
    └── init-db.sh            # Script de inicialización
```

## Puertos y URLs

- **Aplicación (HTTPS)**: https://187.13.14.29:4433
- **Aplicación (HTTP)**: http://187.13.14.29:8080 (redirige a HTTPS)
- **MySQL**: Solo acceso interno (puerto 3306 en contenedor)

## Volúmenes

- `mysql_data`: Datos persistentes de MySQL
- `./public/uploads`: Archivos subidos por usuarios

## Solución de Problemas

### La aplicación no puede conectarse a MySQL

```bash
# Verificar que MySQL esté ejecutándose
docker-compose ps

# Verificar logs de MySQL
docker-compose logs mysql

# Verificar conectividad
docker-compose exec app ping mysql
```

### Error de permisos en volúmenes

```bash
# En Linux/Mac, ajustar permisos
sudo chown -R 1001:1001 ./public/uploads
```

### Reconstruir desde cero

```bash
# Eliminar todo y reconstruir
docker-compose down -v
docker system prune -f
docker-compose up --build
```

### Verificar salud de los servicios

```bash
# Verificar estado de salud
docker-compose ps

# Verificar logs de salud
docker inspect burger-station-app | grep -A 10 Health
```

## Monitoreo

### Verificar estado de los servicios

```bash
# Estado general
docker-compose ps

# Uso de recursos
docker stats

# Logs en tiempo real
docker-compose logs -f
```

### Health Checks

La aplicación incluye health checks automáticos:

- **MySQL**: Verifica que el servicio esté respondiendo
- **App**: Verifica que la API esté disponible en `/api/health`

## Seguridad

### Recomendaciones de producción

1. **Cambiar todas las contraseñas por defecto**
2. **Usar certificados SSL/TLS**
3. **Configurar firewall adecuadamente**
4. **Usar secrets de Docker para información sensible**
5. **Habilitar logs de auditoría**

### Variables sensibles

```bash
# Usar Docker secrets para información sensible
echo "tu_password_secreto" | docker secret create mysql_password -
```

## Backup y Restauración

### Backup automático

```bash
#!/bin/bash
# backup.sh
DATE=$(date +%Y%m%d_%H%M%S)
docker-compose exec mysql mysqldump -u burger_user -p burger_station > "backup_${DATE}.sql"
```

### Restauración

```bash
# Restaurar desde backup
docker-compose exec -T mysql mysql -u burger_user -p burger_station < backup_20240101_120000.sql
```

## Actualización

```bash
# Actualizar la aplicación
git pull
docker-compose down
docker-compose up --build -d

# Actualizar solo la base de datos
docker-compose exec app npx prisma migrate deploy
```

## Soporte

Si encuentras problemas:

1. Verifica los logs: `docker-compose logs`
2. Verifica el estado: `docker-compose ps`
3. Revisa la configuración de variables de entorno
4. Consulta la documentación de Docker y Docker Compose
