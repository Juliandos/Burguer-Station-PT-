import { getTokenFromCookie, verifyToken } from "./jwt";
import { findUserByEmail } from "../db/user";

export const getCurrentUser = async () => {
  const token = getTokenFromCookie();
  if (!token) return null;

  const decoded = verifyToken(token);
  if (!decoded) return null;

  return await findUserByEmail(decoded.email);
};

export const requireAuth = async () => {
  const user = await getCurrentUser();
  if (!user) {
    throw new Error("Unauthorized");
  }
  return user;
};
