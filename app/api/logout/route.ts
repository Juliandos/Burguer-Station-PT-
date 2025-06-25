import { NextResponse } from 'next/server';
import { clearTokenCookie, getTokenFromCookie } from '../../lib/auth/jwt';

export async function POST() {
  try {
    const response = NextResponse.json(
      { message: 'Logout successfull' },
      { status: 200 }
    );
    
    console.log('BEF cookie token', await getTokenFromCookie())
    await clearTokenCookie();
    console.log('AFT cookie token', await getTokenFromCookie())
    return response;
  } catch (error) {
    return NextResponse.json(
      { error: "Internal server error: " + error },
      { status: 500 }
    );
  }
}