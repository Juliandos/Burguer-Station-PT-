import jwt from "jsonwebtoken";
import { cookies } from "next/headers";

const secretKey = process.env.JWT_SECRET || "your-secret-key";
const expiresIn = "1h";

export const generateToken = (payload: { id: number; email: string }) => {
  return jwt.sign(payload, secretKey, { expiresIn });
};

export const verifyToken = (token: string) => {
  try {
    return jwt.verify(token, secretKey) as { id: number; email: string };
  } catch (error) {
    return error;
  }
};

export const setTokenCookie = (token: string) => {
  cookies().set("auth_token", token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "strict",
    maxAge: 60 * 60, // 1 hora
    path: "/",
  });
};

export const getTokenFromCookie = () => {
  return cookies().get("auth_token")?.value;
};

export const clearTokenCookie = () => {
  cookies().delete("auth_token");
};
