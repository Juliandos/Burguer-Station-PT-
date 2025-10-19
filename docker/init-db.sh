#!/bin/bash
# Script de inicialización de la base de datos

set -e

echo "Esperando a que MySQL esté listo..."
until mysqladmin ping -h"$MYSQL_HOST" -P"$MYSQL_PORT" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent; do
    echo "MySQL no está listo - esperando..."
    sleep 2
done

echo "MySQL está listo. Ejecutando migraciones de Prisma..."

# Ejecutar migraciones de Prisma
npx prisma migrate deploy

echo "Ejecutando seed de la base de datos..."
npx prisma db seed

echo "Inicialización de base de datos completada."
