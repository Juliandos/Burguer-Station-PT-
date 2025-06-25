'use client'

import { useEffect, useState } from 'react'
import { toast } from 'react-toastify'
import { PlusIcon, MinusIcon } from '@heroicons/react/24/outline'
import { useStore } from '@/src/store'

interface Adicion {
  id: number
  nombre: string
  precio: number
  tipo: string
}

export default function Adiciones() {
  const [adiciones, setAdiciones] = useState<Adicion[]>([])
  const [cantidades, setCantidades] = useState<Record<number, number>>({})
  const setAdicion = useStore((state) => state.setAdicion)

  useEffect(() => {
    const fetchAdiciones = async () => {
      try {
        const res = await fetch('/api/adiciones')
        if (!res.ok) throw new Error('Error al obtener adiciones')
        const data = await res.json()
        setAdiciones(data)

        // Inicializa cantidades en 0
        const iniciales: Record<number, number> = {}
        data.forEach((item: Adicion) => (iniciales[item.id] = 0))
        setCantidades(iniciales)
      } catch (error) {
        toast.error('Error al cargar adiciones')
        console.error(error)
      }
    }

    fetchAdiciones()
  }, [])

  const increase = (id: number) => {
    if (cantidades[id] < 3) {
      const nuevaCantidad = cantidades[id] + 1
      setCantidades((prev) => ({ ...prev, [id]: nuevaCantidad }))
      const precio = adiciones.find((a) => a.id === id)?.precio || 0
      setAdicion(id, precio, nuevaCantidad)
    } else {
      toast.warn('Máximo 3 unidades permitidas')
    }
  }

  const decrease = (id: number) => {
    const nuevaCantidad = cantidades[id] > 0 ? cantidades[id] - 1 : 0
    setCantidades((prev) => ({ ...prev, [id]: nuevaCantidad }))
    const precio = adiciones.find((a) => a.id === id)?.precio || 0
    setAdicion(id, precio, nuevaCantidad)
  }

  const formatCurrency = (value: number) =>
    new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0,
    }).format(value)

  return (
    <div className="mt-5 border-t border-gray-200 pt-5">
      <h2 className="text-xl font-bold mb-3">Adiciones</h2>

      <ul className="space-y-4">
        {adiciones.map((item) => (
          <li
            key={item.id}
            className="flex flex-col md:flex-row justify-between items-start md:items-center bg-white shadow px-4 py-3 border border-gray-200 rounded"
          >
            <div className="flex flex-col md:flex-row md:items-center md:gap-4 mb-2 md:mb-0">
            <p className="font-semibold">{item.nombre}</p>
            <p className="text-amber-500 font-bold">{formatCurrency(item.precio)}</p>
          </div>

            <div className="flex items-center gap-3">
              <button
                type="button"
                onClick={() => decrease(item.id)}
                disabled={cantidades[item.id] === 0}
                className="disabled:opacity-30 p-2 rounded bg-gray-100 hover:bg-gray-200"
              >
                <MinusIcon className="h-5 w-5" />
              </button>

              <span className="w-6 text-center font-bold">{cantidades[item.id]}</span>

              <button
                type="button"
                onClick={() => increase(item.id)}
                disabled={cantidades[item.id] >= 3}
                className="disabled:opacity-30 p-2 rounded bg-gray-100 hover:bg-gray-200"
              >
                <PlusIcon className="h-5 w-5" />
              </button>
            </div>
          </li>
        ))}
      </ul>
    </div>
  )
}
