import { categories } from "./data/categories";
import { products } from "./data/products";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

async function main() {
  try {
    // Primero crea un usuario
    const user = await prisma.user.create({
      data: {
        nombre: "Admin",
        email: "admin@example.com",
        password: "password123", // Recuerda hashear esto en producción
      },
    });

    // Modifica las categorías para incluir el userId
    const categoriesWithUserId = categories.map((category) => ({
      ...category,
      userId: user.id,
    }));

    await prisma.category.createMany({
      data: categoriesWithUserId,
    });

    await prisma.product.createMany({
      data: products,
    });
  } catch (error) {
    console.log(error);
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
