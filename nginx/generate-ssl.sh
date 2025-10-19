#!/bin/bash

# Script para generar certificados SSL autofirmados para desarrollo
# Configurado para la IP externa 187.13.14.29

set -e

SSL_DIR="./nginx/ssl"
DOMAIN="187.13.14.29"
ALT_NAMES="localhost,127.0.0.1"

echo "🔐 Generando certificados SSL para $DOMAIN..."

# Crear directorio si no existe
mkdir -p "$SSL_DIR"

# Generar clave privada
echo "Generando clave privada..."
openssl genrsa -out "$SSL_DIR/key.pem" 2048

# Crear archivo de configuración para SAN (Subject Alternative Names)
cat > "$SSL_DIR/ssl.conf" << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
C=ES
ST=Madrid
L=Madrid
O=Burger Station
OU=IT Department
CN=$DOMAIN

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = $DOMAIN
IP.1 = 127.0.0.1
IP.2 = $DOMAIN
EOF

# Generar certificado autofirmado con SAN
echo "Generando certificado autofirmado con SAN..."
openssl req -new -x509 -key "$SSL_DIR/key.pem" -out "$SSL_DIR/cert.pem" -days 365 \
    -config "$SSL_DIR/ssl.conf" -extensions v3_req

# Verificar certificados
echo "Verificando certificados..."
openssl x509 -in "$SSL_DIR/cert.pem" -text -noout | grep -E "(Subject:|Not After|Not Before|DNS:|IP Address:)"

# Limpiar archivo temporal
rm "$SSL_DIR/ssl.conf"

echo "✅ Certificados SSL generados exitosamente en $SSL_DIR"
echo "📋 Archivos creados:"
echo "   - $SSL_DIR/cert.pem (certificado con SAN)"
echo "   - $SSL_DIR/key.pem (clave privada)"
echo ""
echo "🌐 Certificado válido para:"
echo "   - $DOMAIN (IP externa)"
echo "   - localhost"
echo "   - 127.0.0.1"
echo ""
echo "⚠️  NOTA: Estos son certificados autofirmados para desarrollo."
echo "   Para producción, usa Let's Encrypt o un certificado de CA válido."
echo ""
echo "🔗 URLs de acceso:"
echo "   - HTTP: http://$DOMAIN:8080 (redirige a HTTPS)"
echo "   - HTTPS: https://$DOMAIN:4433"
