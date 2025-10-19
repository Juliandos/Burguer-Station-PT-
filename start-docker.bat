@echo off
setlocal enabledelayedexpansion

echo 🍔 Iniciando Burger Station con Docker y Nginx...

REM Verificar si existe el archivo .env
if not exist .env (
    echo ⚠️  Archivo .env no encontrado. Copiando desde env.example...
    copy env.example .env
    echo 📝 Por favor, edita el archivo .env con tus configuraciones antes de continuar.
    echo    Variables importantes:
    echo    - MYSQL_ROOT_PASSWORD
    echo    - MYSQL_PASSWORD
    echo    - NEXTAUTH_SECRET
    echo.
    set /p continue="¿Continuar con la configuración por defecto? (y/N): "
    if /i not "!continue!"=="y" (
        echo ❌ Operación cancelada.
        exit /b 1
    )
)

REM Verificar si existen certificados SSL
if not exist nginx\ssl\cert.pem (
    echo ⚠️  Certificados SSL no encontrados. Generando certificados de desarrollo...
    nginx\generate-ssl.bat
)

REM Verificar si Docker está ejecutándose
docker info >nul 2>&1
if errorlevel 1 (
    echo ❌ Docker no está ejecutándose. Por favor, inicia Docker y vuelve a intentar.
    exit /b 1
)

REM Limpiar contenedores anteriores si existen
echo 🧹 Limpiando contenedores anteriores...
docker-compose down >nul 2>&1

REM Construir y ejecutar
echo 🔨 Construyendo y ejecutando servicios...
docker-compose up --build -d

REM Esperar a que los servicios estén listos
echo ⏳ Esperando a que los servicios estén listos...
timeout /t 10 /nobreak >nul

REM Verificar estado de los servicios
echo 📊 Estado de los servicios:
docker-compose ps

REM Verificar health checks
echo 🏥 Verificando estado de salud...
timeout /t 5 /nobreak >nul

REM Verificar aplicación
curl -f http://localhost:3000/api/health >nul 2>&1
if errorlevel 1 (
    echo ❌ Aplicación no está respondiendo
) else (
    echo ✅ Aplicación está funcionando correctamente
)

echo.
echo 🎉 ¡Burger Station está ejecutándose!
echo.
echo 📍 URLs importantes:
echo    - Aplicación (HTTPS): https://187.13.14.29:4433
echo    - Aplicación (HTTP): http://187.13.14.29:8080 (redirige a HTTPS)
echo    - MySQL: Solo acceso interno (puerto 3306 en contenedor)
echo.
echo 📋 Comandos útiles:
echo    - Ver logs: docker-compose logs -f
echo    - Ver logs nginx: docker-compose logs -f nginx
echo    - Detener: docker-compose down
echo    - Reiniciar: docker-compose restart
echo.
echo 🔐 SSL/TLS:
echo    - Certificados de desarrollo generados automáticamente
echo    - Para producción: nginx\setup-letsencrypt.sh tu-dominio.com
echo.
echo 📚 Para más información, consulta DOCKER.md

pause
