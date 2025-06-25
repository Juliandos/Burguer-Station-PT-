import { NextResponse } from 'next/server';
import { createUser, findUserByEmail, validatePassword } from '../../lib/db/user';
import { generateToken, setTokenCookie } from '../../lib/auth/jwt';

export async function POST(request: Request) {
    const { email, password, nombre, action } = await request.json();

    try {
        if (action === 'register') {
            // Validación de registro
            if (!email || !password) {
                return NextResponse.json(
                    { error: 'Email and password are required' },
                    { status: 400 }
                );
            }

            const existingUser = await findUserByEmail(email);
            if (existingUser) {
                return NextResponse.json(
                    { error: 'Email already in use' },
                    { status: 400 }
                );
            }

            const user = await createUser(email, password, nombre);
            const token = generateToken({ id: user.id, email: user.email });

            const response = NextResponse.json(
                { user: { id: user.id, email: user.email, nombre: user.nombre } },
                { status: 201 }
            );

            await setTokenCookie(token);
            return response;
        } else if (action === 'login') {
            // Validación de login
            if (!email || !password) {
                return NextResponse.json(
                    { error: 'Email and password are required' },
                    { status: 400 }
                );
            }

            const user = await findUserByEmail(email);
            if (!user) {
                return NextResponse.json(
                    { error: 'Invalid credentials' },
                    { status: 401 }
                );
            }

            const isValidPassword = await validatePassword(user, password);
            if (!isValidPassword) {
                return NextResponse.json(
                    { error: 'Invalid credentials' },
                    { status: 401 }
                );
            }

            const token = generateToken({ id: user.id, email: user.email });

            const response = NextResponse.json(
                { user: { id: user.id, email: user.email, nombre: user.nombre } },
                { status: 200 }
            );

            await setTokenCookie(token);
            return response;
        } else {
            return NextResponse.json(
                { error: 'Invalid action' },
                { status: 400 }
            );
        }
    } catch (error) {
        console.error('Auth error:', error);
        return NextResponse.json(
            { error: 'Internal server error' },
            { status: 500 }
        );
    }
}
