import { Injectable } from "@nestjs/common";
import { randomBytes, scrypt, timingSafeEqual } from "node:crypto";
import { promisify } from "node:util";

const scryptAsync = promisify(scrypt);
const KEY_LENGTH = 64;
const SALT_LENGTH = 16;
const PREFIX = "scrypt";

/**
 * Hash/verify password cho Operator/Platform (custom, KHÔNG qua Better Auth).
 * scrypt (Node built-in) — mạnh, không cần native dep (distroless-safe).
 * Format lưu: `scrypt$<saltBase64>$<hashBase64>`.
 */
@Injectable()
export class CredentialService {
  async hash(password: string): Promise<string> {
    const salt = randomBytes(SALT_LENGTH);
    const derived = (await scryptAsync(password, salt, KEY_LENGTH)) as Buffer;
    return `${PREFIX}$${salt.toString("base64")}$${derived.toString("base64")}`;
  }

  async verify(password: string, stored: string): Promise<boolean> {
    const parts = stored.split("$");
    if (parts.length !== 3 || parts[0] !== PREFIX) {
      return false;
    }
    const salt = Buffer.from(parts[1], "base64");
    const expected = Buffer.from(parts[2], "base64");
    const derived = (await scryptAsync(password, salt, expected.length)) as Buffer;
    return derived.length === expected.length && timingSafeEqual(derived, expected);
  }
}
