# ?? Burger Station – App de Ventas de Comida Rápida

Burger Station es una aplicación web desarrollada con **Next.js** que permite gestionar pedidos de comida rápida de forma eficiente, moderna y adaptable a diferentes dispositivos. Incluye administración de productos, categorías, clientes y pedidos, así como la relación de productos con complementos (adiciones).

---

## ?? 1. Introducción

Esta plataforma fue diseñada pensando en los negocios de comida rápida que requieren:

- Crear productos con adiciones (ej. papas, salsas, bebidas).
- Tomar pedidos personalizados.
- Visualizar órdenes pendientes y marcarlas como completadas.
- Gestionar información desde un panel de administración.
- Usar tecnologías modernas y escalables.

---

## ?? 2. Requisitos

Antes de comenzar, asegúrate de tener instalado lo siguiente en tu entorno local o servidor:

- Node.js (versión recomendada: 18.x o superior)
- npm o yarn
- MySQL (5.7+ o 8.x)
- Git (opcional pero recomendado)

---

## ?? 3. Herramientas Utilizadas

| Herramienta | Descripción |
|-------------|-------------|
| **Next.js** | Framework React para renderizado híbrido SSR/SSG. |
| **Prisma ORM** | Mapear y consultar la base de datos de forma sencilla. |
| **MySQL** | Base de datos relacional para persistencia de información. |
| **Tailwind CSS** | Utilidad para estilos rápidos y adaptables. |

---

## ??? 4. Instalación

### Paso 1 – Clonar el repositorio

```bash
git clone https://github.com/tuusuario/burger-station.git
cd burger-station
```

### Paso 2 – Instalar dependencias

```bash
npm install
# o con yarn
# yarn
```

### Paso 3 – Configurar variables de entorno

Crea un archivo `.env` en la raíz del proyecto:

```env
DATABASE_URL="mysql://usuario:contraseña@localhost:3306/burger_station"
```

> Asegúrate de tener una base de datos MySQL creada con el nombre correspondiente.

### Paso 4 – Ejecutar migraciones de la base de datos

```bash
npx prisma migrate dev --name init
```

Esto creará las tablas necesarias según el esquema definido en `prisma/schema.prisma`.

### Paso 5 – Generar el cliente de Prisma

```bash
npx prisma generate
```

---

## ?? 5. Ejecución

### Modo desarrollo

```bash
npm run dev
```

La aplicación estará disponible en: [http://localhost:3000](http://localhost:3000)

---

## ?? Funcionalidades principales

- ? Gestión de productos, categorías y precios
- ? Soporte para adiciones por producto
- ? Panel de órdenes en tiempo real
- ? Relación entre órdenes y productos con complementos
- ? Interfaz responsive optimizada para móviles y tablets

---

## ?? Estructura del proyecto

```
+-- app/
¦   +-- admin/
¦   +-- api/
¦   +-- .../
+-- components/
+-- prisma/
¦   +-- schema.prisma
+-- public/
+-- styles/
+-- .env
+-- package.json
```

---

## ?? Despliegue sugerido

Puedes desplegar Burger Station en:

- **Vercel** (frontend + API)MySQL

---

## ?? Licencia

Este proyecto está bajo licencia [MIT](LICENSE).

---

Desarrollado por [Julián Ortega Solarte](https://github.com/Juliandos)
