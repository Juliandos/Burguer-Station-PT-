#!/bin/bash
set -e

echo "Esperando a que MySQL esté listo..."
until mysqladmin ping -h"localhost" -u"root" -p"password" --silent; do
    echo "MySQL no está listo - esperando..."
    sleep 2
done

echo "MySQL está listo. Ejecutando script de inicialización..."

# Ejecutar el script SQL
mysql -h"localhost" -u"root" -p"password" burger_station < /docker-entrypoint-initdb.d/01-script-bd.sql

echo "Base de datos inicializada correctamente."
