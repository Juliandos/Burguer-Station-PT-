'use client'

import { useEffect } from 'react'
// import { useStore } from "@/src/store"
// import { prisma } from "@/src/lib/prisma"
import { toast } from 'react-toastify'

export default function Adiciones() {
    // const [adiciones, setAdiciones] = useState<prisma[]>([])
    // const [loading, setLoading] = useState(true)
    // const addAdicionToOrder = useStore((state) => state.addAdicionToOrder)
    // const order = useStore((state) => state.order)

    useEffect(() => {
        const fetchAdiciones = async () => {
            try {
                const response = await fetch('/api/adiciones')
                if (!response.ok) throw new Error('Error al obtener adiciones')
                const data = await response.json()
                console.log(data);
            
                // setAdiciones(data)
            } catch (error) {
                toast.error('Error al cargar adiciones')
                console.error(error)
            } finally {
                // setLoading(false)
            }
        }

        fetchAdiciones()
    }, [])

    // const handleAddAdicion = (adicion: Adicion) => {
    //     // Verifica si el producto actual tiene adiciones
    //     if (order.length === 0) {
    //         toast.warn('Primero agrega un producto al pedido')
    //         return
    //     }
        
    //     addAdicionToOrder(adicion)
    //     toast.success(`${adicion.nombre} agregada al pedido`)
    // }

    // if (loading) return <p>Cargando adiciones...</p>

    return (
        <div className="mt-5 border-t border-gray-200 pt-5">
            <h2 className="text-xl font-bold mb-3">Adiciones</h2>
            <div className="grid grid-cols-2 gap-2">
                {/* {adiciones.map((adicion) => (
                    <button
                        key={adicion.id}
                        onClick={() => handleAddAdicion(adicion)}
                        className="bg-white border border-gray-200 p-2 text-sm rounded hover:bg-gray-100 transition-colors"
                    >
                        {adicion.nombre} (+{adicion.precio})
                    </button>
                ))} */}Holaaa
            </div>
        </div>
    )
}