"use client"
import { useRouter } from 'next/navigation'
import { ArrowLeftIcon } from '@heroicons/react/24/outline'

export default function BackToOrdersButton() {
  const router = useRouter()

  return (
    <button
      onClick={() => router.push('/admin/orders')}
      className="flex items-center gap-2 bg-amber-400 hover:bg-amber-500 text-white font-bold py-2 px-4 rounded-lg transition-colors duration-300 shadow-md hover:shadow-lg"
    >
      <ArrowLeftIcon className="h-5 w-5" />
      Volver a Órdenes
    </button>
  )
}