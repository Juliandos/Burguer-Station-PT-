import ProductSearchForm from "@/components/products/ProductSearchForm";
import ProductTable from "@/components/products/ProductsTable";
import Heading from "@/components/ui/Heading";
import { prisma } from "@/src/lib/prisma";

async function searchProducts(searchTerm: string) {
    const searchTermLower = searchTerm.toLowerCase();
    
    const products = await prisma.product.findMany({
        where: {
            name: {
                contains: searchTermLower
            }
        },
        include: {
            category: true
        }
    });
    
    // Filtra adicionalmente para case-insensitive
    return products.filter(product => 
        product.name.toLowerCase().includes(searchTermLower)
    );
}

export default async function SearchPage({ searchParams }: { searchParams: Promise<{ search?: string }> }) {

    const resolvedSearchParams = await searchParams
    const searchTerm = resolvedSearchParams.search || ''
    const products = await searchProducts(searchTerm)

    return (
        <>
            <Heading>Resultados de búsqueda: {searchTerm}</Heading>

            <div className='flex flex-col lg:flex-row lg:justify-end gap-5'>
                <ProductSearchForm />
            </div>

            {products.length ? (
                <ProductTable
                    products={products}
                />
            ) : <p className="text-center text-lg">No hay resultados</p>}

        </>
    )
}