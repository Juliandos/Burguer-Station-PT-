# Makefile para Burger Station Docker

.PHONY: help build up down logs clean restart health status

# Variables
COMPOSE_FILE = docker-compose.yml
PROD_COMPOSE_FILE = docker-compose.prod.yml

help: ## Mostrar ayuda
	@echo "🍔 Burger Station - Comandos disponibles:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Construir las imágenes de Docker
	docker-compose build

up: ## Iniciar todos los servicios
	docker-compose up -d

up-build: ## Construir e iniciar todos los servicios
	docker-compose up --build -d

down: ## Detener todos los servicios
	docker-compose down

down-volumes: ## Detener servicios y eliminar volúmenes
	docker-compose down -v

logs: ## Ver logs de todos los servicios
	docker-compose logs -f

logs-app: ## Ver logs de la aplicación
	docker-compose logs -f app

logs-mysql: ## Ver logs de MySQL
	docker-compose logs -f mysql

restart: ## Reiniciar todos los servicios
	docker-compose restart

restart-app: ## Reiniciar solo la aplicación
	docker-compose restart app

restart-mysql: ## Reiniciar solo MySQL
	docker-compose restart mysql

status: ## Ver estado de los servicios
	docker-compose ps

health: ## Verificar estado de salud
	@echo "🏥 Verificando estado de salud..."
	@curl -f http://localhost:3000/api/health || echo "❌ Aplicación no responde"
	@docker-compose exec mysql mysqladmin ping -h localhost --silent && echo "✅ MySQL OK" || echo "❌ MySQL no responde"

clean: ## Limpiar contenedores, imágenes y volúmenes
	docker-compose down -v --remove-orphans
	docker system prune -f
	docker volume prune -f

setup: ## Configuración inicial
	@if [ ! -f .env ]; then \
		cp env.example .env; \
		echo "📝 Archivo .env creado. Por favor, edítalo con tus configuraciones."; \
	fi

prod: ## Ejecutar en modo producción
	docker-compose -f $(COMPOSE_FILE) -f $(PROD_COMPOSE_FILE) up -d --build

db-shell: ## Acceder a la shell de MySQL
	docker-compose exec mysql mysql -u burger_user -p burger_station

db-backup: ## Hacer backup de la base de datos
	@mkdir -p backups
	docker-compose exec mysql mysqldump -u burger_user -p burger_station > backups/backup_$(shell date +%Y%m%d_%H%M%S).sql

db-restore: ## Restaurar base de datos (usar: make db-restore FILE=backup.sql)
	docker-compose exec -T mysql mysql -u burger_user -p burger_station < $(FILE)

prisma-generate: ## Generar cliente de Prisma
	docker-compose exec app npx prisma generate

prisma-migrate: ## Ejecutar migraciones de Prisma
	docker-compose exec app npx prisma migrate deploy

prisma-seed: ## Ejecutar seed de la base de datos
	docker-compose exec app npx prisma db seed

dev: setup up-build ## Configuración inicial y ejecución en desarrollo
	@echo "🎉 ¡Aplicación ejecutándose en http://localhost:3000!"

install: ## Instalar dependencias localmente (para desarrollo)
	npm install

lint: ## Ejecutar linter
	npm run lint

test: ## Ejecutar tests
	npm test

# Comando por defecto
.DEFAULT_GOAL := help
