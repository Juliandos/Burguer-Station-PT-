import LoginForm from '@/components/auth/LoginForm';

export default function LoginPage() {
    return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50">
            <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow">
                <h1 className="text-2xl font-bold text-center">Iniciar Sesión</h1>
                <LoginForm />
            </div>
        </div>
    );
}