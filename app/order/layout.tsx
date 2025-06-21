import OrderSumary from "@/components/order/OrderSumary";
import OrderSideBar from "../../components/order/OrderSideBar";

export default function RootLayout({
    children,
}: Readonly<{
    children: React.ReactNode;
}>) {
    return (
        <div className="md:flex">
            <OrderSideBar />
            <main className="md:flex-1 md:h-screen md:overflow-y-auto p-5">
                {children}
            </main>
            <OrderSumary />
        </div>
    );
}