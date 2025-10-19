#!/bin/bash

# Script para configurar Let's Encrypt con Certbot para producción
# Configurado para la IP externa 187.13.14.29
# Uso: ./setup-letsencrypt.sh tu-dominio.com

set -e

if [ -z "$1" ]; then
    echo "❌ Error: Debes proporcionar un dominio"
    echo "Uso: $0 tu-dominio.com"
    echo ""
    echo "📋 Para usar con IP externa 187.13.14.29:"
    echo "   1. Configura un dominio DNS que apunte a 187.13.14.29"
    echo "   2. Ejecuta: $0 tu-dominio.com"
    exit 1
fi

DOMAIN="$1"
EMAIL="${2:-admin@$DOMAIN}"
SSL_DIR="./nginx/ssl"

echo "🔐 Configurando Let's Encrypt para $DOMAIN (IP: 187.13.14.29)..."

# Verificar que el dominio esté apuntando a la IP correcta
echo "Verificando que el dominio $DOMAIN apunte a 187.13.14.29..."
DOMAIN_IP=$(dig +short $DOMAIN | tail -n1)

if [ "187.13.14.29" != "$DOMAIN_IP" ]; then
    echo "❌ Error: El dominio $DOMAIN no apunta a 187.13.14.29"
    echo "   IP del dominio: $DOMAIN_IP"
    echo "   IP esperada: 187.13.14.29"
    echo "   Por favor, configura los registros DNS correctamente"
    exit 1
fi

echo "✅ Verificación de DNS exitosa"

# Crear directorio para certificados
mkdir -p "$SSL_DIR"

# Instalar Certbot si no está instalado
if ! command -v certbot &> /dev/null; then
    echo "Instalando Certbot..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y certbot
    elif command -v yum &> /dev/null; then
        sudo yum install -y certbot
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y certbot
    else
        echo "❌ No se pudo instalar Certbot automáticamente"
        echo "   Por favor, instálalo manualmente desde https://certbot.eff.org/"
        exit 1
    fi
fi

# Detener nginx temporalmente para el desafío HTTP
echo "Deteniendo nginx para el desafío HTTP..."
docker-compose stop nginx

# Obtener certificado
echo "Obteniendo certificado SSL para $DOMAIN..."
sudo certbot certonly \
    --standalone \
    --email "$EMAIL" \
    --agree-tos \
    --no-eff-email \
    --domains "$DOMAIN"

# Copiar certificados al directorio del proyecto
echo "Copiando certificados al proyecto..."
sudo cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "$SSL_DIR/cert.pem"
sudo cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "$SSL_DIR/key.pem"
sudo chown $(whoami):$(whoami) "$SSL_DIR/cert.pem" "$SSL_DIR/key.pem"

# Crear script de renovación automática
echo "Creando script de renovación automática..."
cat > renew-ssl.sh << EOF
#!/bin/bash
# Script para renovar certificados SSL automáticamente

set -e

echo "🔄 Renovando certificados SSL..."

# Detener nginx
docker-compose stop nginx

# Renovar certificado
sudo certbot renew --standalone

# Copiar nuevos certificados
sudo cp "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" "./nginx/ssl/cert.pem"
sudo cp "/etc/letsencrypt/live/$DOMAIN/privkey.pem" "./nginx/ssl/key.pem"
sudo chown \$(whoami):\$(whoami) "./nginx/ssl/cert.pem" "./nginx/ssl/key.pem"

# Reiniciar nginx
docker-compose up -d nginx

echo "✅ Certificados renovados exitosamente"
EOF

chmod +x renew-ssl.sh

# Configurar cron job para renovación automática
echo "Configurando renovación automática..."
(crontab -l 2>/dev/null; echo "0 2 * * * $(pwd)/renew-ssl.sh >> $(pwd)/ssl-renewal.log 2>&1") | crontab -

# Reiniciar nginx
echo "Reiniciando nginx..."
docker-compose up -d nginx

echo ""
echo "✅ Configuración SSL completada exitosamente!"
echo ""
echo "📋 Información:"
echo "   - Dominio: $DOMAIN"
echo "   - IP: 187.13.14.29"
echo "   - Email: $EMAIL"
echo "   - Certificados: $SSL_DIR/"
echo "   - Renovación automática: Configurada"
echo ""
echo "🌐 Tu aplicación estará disponible en:"
echo "   - HTTP: http://$DOMAIN:8080 (redirige a HTTPS)"
echo "   - HTTPS: https://$DOMAIN:4433"
echo "   - También: http://187.13.14.29:8080 y https://187.13.14.29:4433"
echo ""
echo "📚 Para más información sobre renovación:"
echo "   - Logs: tail -f ssl-renewal.log"
echo "   - Renovar manualmente: ./renew-ssl.sh"
