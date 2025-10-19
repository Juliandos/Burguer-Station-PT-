#!/bin/bash

# Script de inicio rápido para Burger Station con Docker

set -e

echo "🍔 Iniciando Burger Station con Docker y Nginx..."

# Verificar si existe el archivo .env
if [ ! -f .env ]; then
    echo "⚠️  Archivo .env no encontrado. Copiando desde env.example..."
    cp env.example .env
    echo "📝 Por favor, edita el archivo .env con tus configuraciones antes de continuar."
    echo "   Variables importantes:"
    echo "   - MYSQL_ROOT_PASSWORD"
    echo "   - MYSQL_PASSWORD"
    echo "   - NEXTAUTH_SECRET"
    echo ""
    read -p "¿Continuar con la configuración por defecto? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Operación cancelada."
        exit 1
    fi
fi

# Verificar si existen certificados SSL
if [ ! -f nginx/ssl/cert.pem ] || [ ! -f nginx/ssl/key.pem ]; then
    echo "⚠️  Certificados SSL no encontrados. Generando certificados de desarrollo..."
    ./nginx/generate-ssl.sh
fi

# Verificar si Docker está ejecutándose
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker no está ejecutándose. Por favor, inicia Docker y vuelve a intentar."
    exit 1
fi

# Limpiar contenedores anteriores si existen
echo "🧹 Limpiando contenedores anteriores..."
docker-compose down 2>/dev/null || true

# Construir y ejecutar
echo "🔨 Construyendo y ejecutando servicios..."
docker-compose up --build -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios estén listos..."
sleep 10

# Verificar estado de los servicios
echo "📊 Estado de los servicios:"
docker-compose ps

# Verificar health checks
echo "🏥 Verificando estado de salud..."
sleep 5

# Verificar MySQL
if docker-compose exec mysql mysqladmin ping -h localhost --silent; then
    echo "✅ MySQL está funcionando correctamente"
else
    echo "❌ MySQL no está respondiendo"
fi

# Verificar aplicación
if curl -f http://localhost:3000/api/health > /dev/null 2>&1; then
    echo "✅ Aplicación está funcionando correctamente"
else
    echo "❌ Aplicación no está respondiendo"
fi

echo ""
echo "🎉 ¡Burger Station está ejecutándose!"
echo ""
echo "📍 URLs importantes:"
echo "   - Aplicación (HTTPS): https://187.13.14.29:4433"
echo "   - Aplicación (HTTP): http://187.13.14.29:8080 (redirige a HTTPS)"
echo "   - MySQL: Solo acceso interno (puerto 3306 en contenedor)"
echo ""
echo "📋 Comandos útiles:"
echo "   - Ver logs: docker-compose logs -f"
echo "   - Ver logs nginx: docker-compose logs -f nginx"
echo "   - Detener: docker-compose down"
echo "   - Reiniciar: docker-compose restart"
echo ""
echo "🔐 SSL/TLS:"
echo "   - Certificados de desarrollo generados automáticamente"
echo "   - Para producción: ./nginx/setup-letsencrypt.sh tu-dominio.com"
echo ""
echo "📚 Para más información, consulta DOCKER.md"
