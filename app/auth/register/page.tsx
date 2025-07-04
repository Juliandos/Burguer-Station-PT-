import RegisterForm from '@/components/auth/RegisterForm';

export default function RegisterPage() {
    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50">
            <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow">
                <h1 className="text-2xl font-bold text-center">Crear Cuenta</h1>
                <RegisterForm />
            </div>
        </div>
    );
}