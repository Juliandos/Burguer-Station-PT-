@echo off
setlocal enabledelayedexpansion

REM Script para generar certificados SSL autofirmados para desarrollo en Windows
REM Configurado para la IP externa 187.13.14.29

set SSL_DIR=.\nginx\ssl
set DOMAIN=187.13.14.29

echo 🔐 Generando certificados SSL para %DOMAIN%...

REM Crear directorio si no existe
if not exist "%SSL_DIR%" mkdir "%SSL_DIR%"

REM Verificar si OpenSSL está disponible
openssl version >nul 2>&1
if errorlevel 1 (
    echo ❌ OpenSSL no está instalado o no está en el PATH.
    echo    Por favor, instala OpenSSL o usa Git Bash.
    echo    Descarga desde: https://www.openssl.org/source/
    pause
    exit /b 1
)

REM Crear archivo de configuración para SAN
echo [req] > "%SSL_DIR%\ssl.conf"
echo distinguished_name = req_distinguished_name >> "%SSL_DIR%\ssl.conf"
echo req_extensions = v3_req >> "%SSL_DIR%\ssl.conf"
echo prompt = no >> "%SSL_DIR%\ssl.conf"
echo. >> "%SSL_DIR%\ssl.conf"
echo [req_distinguished_name] >> "%SSL_DIR%\ssl.conf"
echo C=ES >> "%SSL_DIR%\ssl.conf"
echo ST=Madrid >> "%SSL_DIR%\ssl.conf"
echo L=Madrid >> "%SSL_DIR%\ssl.conf"
echo O=Burger Station >> "%SSL_DIR%\ssl.conf"
echo OU=IT Department >> "%SSL_DIR%\ssl.conf"
echo CN=%DOMAIN% >> "%SSL_DIR%\ssl.conf"
echo. >> "%SSL_DIR%\ssl.conf"
echo [v3_req] >> "%SSL_DIR%\ssl.conf"
echo keyUsage = keyEncipherment, dataEncipherment >> "%SSL_DIR%\ssl.conf"
echo extendedKeyUsage = serverAuth >> "%SSL_DIR%\ssl.conf"
echo subjectAltName = @alt_names >> "%SSL_DIR%\ssl.conf"
echo. >> "%SSL_DIR%\ssl.conf"
echo [alt_names] >> "%SSL_DIR%\ssl.conf"
echo DNS.1 = localhost >> "%SSL_DIR%\ssl.conf"
echo DNS.2 = %DOMAIN% >> "%SSL_DIR%\ssl.conf"
echo IP.1 = 127.0.0.1 >> "%SSL_DIR%\ssl.conf"
echo IP.2 = %DOMAIN% >> "%SSL_DIR%\ssl.conf"

REM Generar clave privada
echo Generando clave privada...
openssl genrsa -out "%SSL_DIR%\key.pem" 2048

REM Generar certificado autofirmado con SAN
echo Generando certificado autofirmado con SAN...
openssl req -new -x509 -key "%SSL_DIR%\key.pem" -out "%SSL_DIR%\cert.pem" -days 365 -config "%SSL_DIR%\ssl.conf" -extensions v3_req

REM Verificar certificados
echo Verificando certificados...
openssl x509 -in "%SSL_DIR%\cert.pem" -text -noout | findstr "Subject: Not After: Not Before: DNS: IP Address:"

REM Limpiar archivo temporal
del "%SSL_DIR%\ssl.conf"

echo.
echo ✅ Certificados SSL generados exitosamente en %SSL_DIR%
echo 📋 Archivos creados:
echo    - %SSL_DIR%\cert.pem (certificado con SAN)
echo    - %SSL_DIR%\key.pem (clave privada)
echo.
echo 🌐 Certificado válido para:
echo    - %DOMAIN% (IP externa)
echo    - localhost
echo    - 127.0.0.1
echo.
echo ⚠️  NOTA: Estos son certificados autofirmados para desarrollo.
echo    Para producción, usa Let's Encrypt o un certificado de CA válido.
echo.
echo 🔗 URLs de acceso:
echo    - HTTP: http://%DOMAIN%:8080 (redirige a HTTPS)
echo    - HTTPS: https://%DOMAIN%:4433

pause
