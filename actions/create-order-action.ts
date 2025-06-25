"use server";

import { prisma } from "@/src/lib/prisma";
import { OrderSchema } from "@/src/schema";

type AdicionesMap = {
  [key: string]: {
    id: number;
    precio: number;
    cantidad: number;
  };
};


export async function createOrder(data: unknown) {
  const result = OrderSchema.safeParse(data);

  if (!result.success) {
    return {
      errors: result.error.issues,
    };
  }

  try {
    // await prisma.order.create({
    //     data: {
    //         name: result.data.name,
    //         total: result.data.total,
    //         orderProducts: {
    //             create: result.data.order.map(product => ({
    //                 productId: product.id,
    //                 quantity: product.quantity
    //             }))
    //         }
    //     }
    // });

    // 1. Crear la orden con productos
    const order = await prisma.order.create({
      data: {
        name: result.data.name,
        total: result.data.total,
        orderProducts: {
          create: result.data.order.map((product) => ({
            product: { connect: { id: product.id } },
            quantity: product.quantity,
          })),
        },
      },
      include: {
        orderProducts: true, // importante para obtener los IDs generados
      },
    });

    // 2. Insertar las adiciones solo para el primer producto
    const firstOrderProduct = order.orderProducts[0]; // primer producto creado

    const adicionesMap = result.data.adiciones as AdicionesMap;

    const adicionesArray = Object.values(adicionesMap);

    await prisma.orderProductsAdiciones.createMany({
      data: adicionesArray.map(adicion => ({
        orderproducts_id: firstOrderProduct.id,
        adiciones_id: adicion.id,
        cantidad: adicion.cantidad
      }))
    });
  } catch (error) {
    console.log(error);
  }
}
