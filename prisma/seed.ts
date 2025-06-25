import { categories } from "./data/categories";
import { products } from "./data/products";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  try {
    // Crear usuario admin
    const user = await prisma.user.create({
      data: {
        nombre: "Admin",
        email: "admin@example.com",
        password: "password123", // Recuerda hashear en producción!
      },
    });

    // Crear categorías
    await prisma.category.createMany({
      data: categories.map(category => ({
        ...category,
        userId: user.id
      })),
    });

    // Crear productos
    await prisma.product.createMany({
      data: products,
    });

    // Crear adiciones
    await prisma.adiciones.createMany({
      data: [
        // Personalización de hamburguesas
        { nombre: "Huevo frito", precio: 100, tipo: "personalizacion" },
        { nombre: "Jalapeños", precio: 50, tipo: "personalizacion" },
        { nombre: "Guacamole", precio: 150, tipo: "personalizacion" },
        { nombre: "Piña caramelizada", precio: 75, tipo: "personalizacion" },
        { nombre: "Extra queso cheddar", precio: 80, tipo: "personalizacion" },
        { nombre: "Extra queso mozzarella", precio: 80, tipo: "personalizacion" },
        { nombre: "Bacon extra", precio: 100, tipo: "personalizacion" },
        
        // Salsas
        { nombre: "Kétchup", precio: 0, tipo: "salsa" },
        { nombre: "Mayonesa", precio: 0, tipo: "salsa" },
        { nombre: "Mostaza Dijón", precio: 0, tipo: "salsa" },
        { nombre: "Salsa BBQ ahumada", precio: 60, tipo: "salsa" },
        { nombre: "Mayonesa picante", precio: 60, tipo: "salsa" },
        { nombre: "Salsa de ajo", precio: 40, tipo: "salsa" },
        { nombre: "Salsa tártara", precio: 50, tipo: "salsa" },
        
        // Para bebidas
        { nombre: "Extra hielo", precio: 0, tipo: "bebida" },
        { nombre: "Sin hielo", precio: 0, tipo: "bebida" },
        { nombre: "Doble shot de café", precio: 50, tipo: "bebida" },
        { nombre: "Leche de almendras", precio: 30, tipo: "bebida" },
        { nombre: "Leche de soja", precio: 30, tipo: "bebida" },
        { nombre: "Crema batida extra", precio: 40, tipo: "bebida" },
        
        // Para pizzas
        { nombre: "Borde de queso", precio: 150, tipo: "pizza" },
        { nombre: "Extra pepperoni", precio: 120, tipo: "pizza" },
        { nombre: "Extra champiñones", precio: 80, tipo: "pizza" },
        { nombre: "Aceitunas extra", precio: 70, tipo: "pizza" },
        { nombre: "Pimiento extra", precio: 60, tipo: "pizza" },
      ],
    });

    console.log("✅ Seeding completado con éxito!");
    console.log(`📦 ${categories.length} categorías creadas`);
    console.log(`🍔 ${products.length} productos creados`);
    console.log(`➕ ${(await prisma.adiciones.count())} adiciones creadas`);
  } catch (error) {
    console.error("❌ Error en el seeding:", error);
  }
}

main()
  .then(async () => {
    await prisma.$disconnect();
  })
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });