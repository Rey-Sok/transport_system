import { SignJWT, jwtVerify } from "jose";
import bcrypt from "bcryptjs";
import { createHash, randomBytes } from "node:crypto";
import { cookies } from "next/headers";
import type { NextResponse } from "next/server";
import { prisma } from "./db";
import { env } from "./env";
import { AppError } from "./errors";

/* ================================================================== */
/* jwt.ts : sign / verify access tokens                                */
/* ================================================================== */

export type TokenType = "staff" | "passenger";

const ISSUER = "transport-admin";
const ACCESS_TOKEN_TTL = "15m";
const ACCESS_TOKEN_SECONDS = 15 * 60;

// Separate secrets: a passenger token can never be accepted as a staff token.
const secrets: Record<TokenType, Uint8Array> = {
  staff: new TextEncoder().encode(env.JWT_STAFF_SECRET),
  passenger: new TextEncoder().encode(env.JWT_PASSENGER_SECRET),
};

export async function signAccessToken(type: TokenType, id: number) {
  return new SignJWT({ typ: type })
    .setProtectedHeader({ alg: "HS256" })
    .setSubject(String(id))
    .setIssuer(ISSUER)
    .setAudience(type)
    .setJti(crypto.randomUUID())
    .setIssuedAt()
    .setExpirationTime(ACCESS_TOKEN_TTL)
    .sign(secrets[type]);
}

/** Verifies signature, algorithm, issuer, audience and expiry. Throws on failure. */
export async function verifyAccessToken(type: TokenType, token: string) {
  const { payload } = await jwtVerify(token, secrets[type], {
    algorithms: ["HS256"], // pinned: blocks alg:none / algorithm swap
    issuer: ISSUER,
    audience: type,
  });

  const id = Number(payload.sub);
  if (!Number.isInteger(id) || id <= 0) throw new Error("Invalid token subject");

  return { id, jti: payload.jti as string };
}

/* ================================================================== */
/* password.ts : hash / verify passwords                               */
/* ================================================================== */

const BCRYPT_COST = 12;

// bcrypt only uses the first 72 bytes: enforce .max(72) in your Zod schema.
export function hashPassword(password: string) {
  return bcrypt.hash(password, BCRYPT_COST);
}

export async function verifyPassword(hash: string, password: string) {
  try {
    return await bcrypt.compare(password, hash);
  } catch {
    return false;
  }
}

/* ================================================================== */
/* tokens.ts : refresh token + password reset token                    */
/* ================================================================== */

export const REFRESH_TOKEN_TTL_DAYS = 30;
export const RESET_TOKEN_TTL_MINUTES = 30;

/** SHA-256 is fine here: tokens are high-entropy random, not passwords. */
export function hashToken(token: string) {
  return createHash("sha256").update(token).digest("hex");
}

function generateOpaqueToken(ttlMs: number) {
  const token = randomBytes(48).toString("base64url");
  return {
    token, // send to the client / email once
    tokenHash: hashToken(token), // store in the database
    expiresAt: new Date(Date.now() + ttlMs),
  };
}

/** Store tokenHash in RefreshToken.tokenHash. */
export function generateRefreshToken() {
  return generateOpaqueToken(REFRESH_TOKEN_TTL_DAYS * 24 * 60 * 60 * 1000);
}

/** Store tokenHash in PasswordResetToken.tokenHash. Single use (usedAt). */
export function generateResetToken() {
  return generateOpaqueToken(RESET_TOKEN_TTL_MINUTES * 60 * 1000);
}

/* ================================================================== */
/* cookies.ts : cookie helpers (web admin)                             */
/* ================================================================== */

export const STAFF_ACCESS_COOKIE = "staff_access";
export const STAFF_REFRESH_COOKIE = "staff_refresh";

export function cookieOptions(maxAgeSeconds: number) {
  return {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax" as const,
    path: "/",
    maxAge: maxAgeSeconds,
  };
}

export function setAuthCookies(res: NextResponse, accessToken: string, refreshToken: string) {
  res.cookies.set(STAFF_ACCESS_COOKIE, accessToken, cookieOptions(ACCESS_TOKEN_SECONDS));
  res.cookies.set(
    STAFF_REFRESH_COOKIE,
    refreshToken,
    cookieOptions(REFRESH_TOKEN_TTL_DAYS * 24 * 60 * 60),
  );
}

export function clearAuthCookies(res: NextResponse) {
  res.cookies.set(STAFF_ACCESS_COOKIE, "", cookieOptions(0));
  res.cookies.set(STAFF_REFRESH_COOKIE, "", cookieOptions(0));
}

/** Reads the token from Authorization: Bearer (mobile) or a cookie (web admin). */
export function extractToken(req: Request, cookieName: string): string | null {
  const header = req.headers.get("authorization");
  if (header?.startsWith("Bearer ")) return header.slice(7).trim() || null;

  const cookie = req.headers.get("cookie");
  if (!cookie) return null;
  const match = cookie
    .split(";")
    .map((c) => c.trim())
    .find((c) => c.startsWith(`${cookieName}=`));
  return match ? decodeURIComponent(match.slice(cookieName.length + 1)) : null;
}

/* ================================================================== */
/* session.ts : who is making this request?                            */
/* ================================================================== */

async function loadStaffFromToken(token: string) {
  let id: number;
  try {
    ({ id } = await verifyAccessToken("staff", token));
  } catch {
    throw new AppError("Unauthorized", 401);
  }

  // Always reload from the database: role changes and blocking apply immediately.
  const staff = await prisma.staff.findUnique({
    where: { staffId: id },
    include: {
      role: { include: { rolePermissions: { include: { permission: true } } } },
    },
  });

  if (!staff || staff.status !== "active") throw new AppError("Unauthorized", 401);
  return staff;
}

export type CurrentStaff = Awaited<ReturnType<typeof loadStaffFromToken>>;

/** For API routes (supports Bearer header and cookie). */
export async function getCurrentStaff(req: Request): Promise<CurrentStaff> {
  const token = extractToken(req, STAFF_ACCESS_COOKIE);
  if (!token) throw new AppError("Unauthorized", 401);
  return loadStaffFromToken(token);
}

/** For Server Components, layouts and Server Actions (cookie only). */
export async function getCurrentStaffFromCookies(): Promise<CurrentStaff> {
  const store = await cookies();
  const token = store.get(STAFF_ACCESS_COOKIE)?.value;
  if (!token) throw new AppError("Unauthorized", 401);
  return loadStaffFromToken(token);
}

/* ================================================================== */
/* permissions.ts : RBAC                                               */
/* ================================================================== */

export function hasPermission(staff: CurrentStaff, module: string, action: string) {
  return staff.role.rolePermissions.some(
    (rp) => rp.permission.module === module && rp.permission.action === action,
  );
}

/** Call inside every service function. Throws 403 when the staff lacks permission. */
export function requirePermission(staff: CurrentStaff, module: string, action: string) {
  if (!hasPermission(staff, module, action)) {
    throw new AppError("Forbidden", 403);
  }
}