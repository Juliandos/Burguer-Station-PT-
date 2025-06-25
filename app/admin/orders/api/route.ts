import { prisma } from "@/src/lib/prisma";

export const dynamic = "force-dynamic";

export async function GET() {
  const orders = await prisma.order.findMany({
    where: {
      status: false,
    },
    include: {
      orderProducts: {
        include: {
          product: true,
          adiciones: {
            include: {
              adiciones: true, // Incluye los datos de la tabla `Adiciones`
            },
          },
        },
      },
    },
  });

  console.log("orders", orders);

  return Response.json(orders);
}
