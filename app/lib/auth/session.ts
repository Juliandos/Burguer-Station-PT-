import { getTokenFromCookie, verifyToken } from "./jwt";
import { findUserByEmail } from "../db/user";

type DecodedToken = {
  email: string;
};

export const getCurrentUser = async () => {
  const token = await getTokenFromCookie(); // ✅ Aquí resuelves la promesa
  if (!token) return null;

  const decoded = verifyToken(token) as DecodedToken;
  if (!decoded || !decoded.email) return null;

  return await findUserByEmail(decoded.email);
};

export const requireAuth = async () => {
  const user = await getCurrentUser();
  if (!user) {
    throw new Error("Unauthorized");
  }
  return user;
};
