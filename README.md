# 🍔 Burger Station – App de Ventas de Comida Rápida

Burger Station es una aplicación web desarrollada con **Next.js** que permite gestionar pedidos de comida rápida de forma eficiente, moderna y adaptable a diferentes dispositivos. Incluye administración de productos, categorías, clientes y pedidos, así como la relación de productos con complementos (adiciones).
---

🎥 0. Video

Para ver la demostración en video del proyecto, accede al siguiente enlace:  
[Ver video demostrativo]([https://tu-enlace.com/video-demo](https://drive.google.com/file/d/1p70vhjDxHxj6AfiVATnrP0gR8GHTi5XF/view?usp=drive_link)) 
---

## 📌 1. Introducción

Esta plataforma fue diseñada pensando en los negocios de comida rápida que requieren:

- Crear productos con adiciones (ej. papas, salsas, bebidas).
- Tomar pedidos personalizados.
- Visualizar órdenes pendientes y marcarlas como completadas.
- Gestionar información desde un panel de administración.
- Usar tecnologías modernas y escalables.

---

## ⚙️ 2. Requisitos

Antes de comenzar, asegúrate de tener instalado lo siguiente en tu entorno local o servidor:

- Node.js (versión recomendada: 18.x o superior)
- npm o yarn
- MySQL (5.7+ o 8.x)
- Git (opcional pero recomendado)

---

## 🧰 3. Herramientas Utilizadas

| Herramienta | Descripción |
|-------------|-------------|
| **Next.js** | Framework React para renderizado híbrido SSR/SSG. |
| **Prisma ORM** | Mapear y consultar la base de datos de forma sencilla. |
| **MySQL** | Base de datos relacional para persistencia de información. |
| **Tailwind CSS** | Utilidad para estilos rápidos y adaptables. |

---

## 🛠️ 4. Instalación

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

## 🚀 5. Ejecución

### Modo desarrollo

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.
