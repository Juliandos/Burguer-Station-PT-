import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";
import { categories } from "./data/categories";
import { products } from "./data/products";
import { additions } from "./data/additions";

const prisma = new PrismaClient();

async function main() {
  try {
    const hashedPassword = await bcrypt.hash("123456", 10);

    const user = await prisma.user.upsert({
      where: { email: "julian@gmail.com" },
      update: {},
      create: {
        nombre: "julian",
        email: "julian@gmail.com",
        password: hashedPassword,
      },
    });

    // Insertar categorías con userId asignado
    await prisma.category.createMany({
      data: categories.map((cat) => ({
        ...cat,
        userId: user.id,
      })),
    });

    await prisma.product.createMany({ data: products });

    await prisma.adiciones.createMany({ data: additions });

    console.log("✅ Seed completado con éxito");
    console.log(`👤 Usuario: ${user.email}`);
    console.log(`📦 ${products.length} productos`);
    console.log(`➕ ${additions.length} adiciones`);
  } catch (error) {
    console.error("❌ Error en seed:", error);
  } finally {
    await prisma.$disconnect();
  }
}

main();
