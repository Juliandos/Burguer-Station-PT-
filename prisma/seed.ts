import { categories } from "./data/categories";
import { products } from "./data/products";
import { additions } from "./data/additions"; // Importa las adiciones
import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";

const prisma = new PrismaClient();

async function main() {
  try {
    // Crear usuario admin con contraseña hasheada
    const hashedPassword = await bcrypt.hash("password123", 10);
    const user = await prisma.user.create({
      data: {
        nombre: "Admin",
        email: "admin@example.com",
        password: hashedPassword,
      },
    });

    // Crear categorías
    const categoriesWithUserId = categories.map((category) => ({
      ...category,
      userId: user.id,
    }));

    await prisma.category.createMany({
      data: categoriesWithUserId,
    });

    // Crear productos
    await prisma.product.createMany({
      data: products,
    });

    // Crear adiciones
    await prisma.adiciones.createMany({
      data: additions,
    });

    console.log("✅ Seed completado con éxito!");
    console.log(`👤 Usuario creado: admin@example.com / password123`);
    console.log(`🛒 ${products.length} productos creados`);
    console.log(`➕ ${additions.length} adiciones creadas`);
  } catch (error) {
    console.error("❌ Error en el seed:", error);
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