import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { verifyToken } from "./app/lib/auth/jwt";

export async function middleware(request: NextRequest) {
  const path = request.nextUrl.pathname;

  // Rutas públicas
  const publicPaths = ["/auth/login", "/auth/register", '/logout'];
  if (publicPaths.includes(path)) {
    return NextResponse.next();
  }

  // Verificar token para rutas protegidas
  const token = request.cookies.get("auth_token")?.value;
  const verifiedToken = token && verifyToken(token);
  console.log("token: ", token);
  console.log("verifiedToken: ", verifiedToken);
  console.log("Antes de verificar el token");

  // Redirigir a login si no está autenticado
  if (!verifiedToken && !publicPaths.includes(path)) {
    console.log("no token");
    const loginUrl = new URL("/auth/login", request.url);
    // Puedes añadir parámetros para redirigir después del login si lo deseas
    // loginUrl.searchParams.set('from', request.nextUrl.pathname);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    "/((?!api|_next/static|_next/image|favicon.ico).*)",
  ],
};
