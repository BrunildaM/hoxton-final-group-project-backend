import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { PrismaClient } from "@prisma/client";
import dotenv from "dotenv";
dotenv.config();
const prisma = new PrismaClient();
const SECRET = process.env.SECRET!;

export function hash(password: string) {
  const hashedPass = bcrypt.hashSync(password, 12);
  return hashedPass;
}

export function verify(password: string, hash: string) {
  return bcrypt.compareSync(password, hash);
}

export function generateToken(id: number) {
  const token = jwt.sign({ id }, SECRET, { expiresIn: "1h" });
  return token;
}

export async function getCurrentBusinessOwner(token: string) {
  try {
    const data = jwt.verify(token, SECRET);
    const businessOwner = await prisma.businessOwner.findUnique({
      //@ts-ignore
      where: { id: data.id }
    });
    return businessOwner;
  } catch (error) {
    return null;
  }
}

export async function getCurrentClient(token: string) {
  try {
    const data = jwt.verify(token, SECRET);
    const client = await prisma.client.findUnique({
      //@ts-ignore
      where: { id: data.id }
    });
    return client;
  } catch (error) {
    return null;
  }
}
