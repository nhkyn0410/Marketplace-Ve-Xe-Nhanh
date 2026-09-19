import {
  createCipheriv,
  createDecipheriv,
  createHmac,
  randomBytes,
  timingSafeEqual,
} from "node:crypto";

const BASE32_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
const TOTP_SECRET_BYTES = 20;
const AES_GCM_IV_BYTES = 12;
const AES_GCM_TAG_BYTES = 16;
const ENVELOPE_VERSION = "v1";

export const TOTP_PERIOD_SECONDS = 30;
export const TOTP_DIGITS = 6;
export const TOTP_WINDOW = 1;

export type TotpOptions = {
  timestampMs?: number;
  periodSeconds?: number;
  digits?: number;
};

export type VerifyTotpOptions = TotpOptions & {
  window?: number;
  lastCounter?: bigint | null;
};

/** 160-bit secret, as recommended for HMAC-SHA-1 by RFC 4226/6238. */
export function generateTotpSecret(): string {
  return base32Encode(randomBytes(TOTP_SECRET_BYTES));
}

export function generateTotp(
  secret: string,
  options: TotpOptions = {},
): string {
  const {
    timestampMs = Date.now(),
    periodSeconds = TOTP_PERIOD_SECONDS,
    digits = TOTP_DIGITS,
  } = options;
  assertTotpOptions(timestampMs, periodSeconds, digits);
  return hotp(
    base32Decode(secret),
    BigInt(Math.floor(timestampMs / 1000 / periodSeconds)),
    digits,
  );
}

/** Returns the accepted time-step counter so the caller can atomically prevent replay. */
export function verifyTotp(
  secret: string,
  code: string,
  options: VerifyTotpOptions = {},
): bigint | null {
  const {
    timestampMs = Date.now(),
    periodSeconds = TOTP_PERIOD_SECONDS,
    digits = TOTP_DIGITS,
    window = TOTP_WINDOW,
    lastCounter,
  } = options;
  assertTotpOptions(timestampMs, periodSeconds, digits);
  if (!Number.isInteger(window) || window < 0 || window > 10) {
    throw new Error("TOTP window must be an integer between 0 and 10.");
  }
  if (!new RegExp(`^\\d{${digits}}$`).test(code)) {
    return null;
  }

  const key = base32Decode(secret);
  const current = BigInt(Math.floor(timestampMs / 1000 / periodSeconds));
  const offsets = [0];
  for (let distance = 1; distance <= window; distance += 1) {
    offsets.push(-distance, distance);
  }

  for (const offset of offsets) {
    const counter = current + BigInt(offset);
    if (counter < 0n || (lastCounter != null && counter <= lastCounter)) {
      continue;
    }
    const expected = hotp(key, counter, digits);
    if (timingSafeEqual(Buffer.from(code), Buffer.from(expected))) {
      return counter;
    }
  }
  return null;
}

/**
 * Key URI format (Google Authenticator): nhãn và query đều mã hoá RFC 3986 (`%20`, không `+`), và
 * `issuer` phải trùng tiền tố nhãn — `URLSearchParams` ra `Ve+Xe+Nhanh`, vài app hiện nguyên dấu `+`.
 */
export function createOtpAuthUri(
  secret: string,
  label: string,
  issuer = "Ve Xe Nhanh",
): string {
  const query = [
    ["secret", secret],
    ["issuer", issuer],
    ["algorithm", "SHA1"],
    ["digits", String(TOTP_DIGITS)],
    ["period", String(TOTP_PERIOD_SECONDS)],
  ]
    .map(([name, value]) => `${name}=${encodeURIComponent(value!)}`)
    .join("&");
  return `otpauth://totp/${encodeURIComponent(`${issuer}:${label}`)}?${query}`;
}

/**
 * AES-256-GCM, envelope có version: `v1.iv.tag.ciphertext` (base64url). `context` đi vào AAD:
 * ciphertext chỉ mở được đúng ở ngữ cảnh đã khoá nó (vd secret của chủ thể A không dùng được cho
 * chủ thể B, payload challenge không chuyển sang token khác được).
 */
export function sealMfaValue(plaintext: string, key: Buffer, context: string): string {
  assertEncryptionKey(key);
  const iv = randomBytes(AES_GCM_IV_BYTES);
  const cipher = createCipheriv("aes-256-gcm", key, iv);
  cipher.setAAD(aadOf(context));
  const ciphertext = Buffer.concat([cipher.update(plaintext, "utf8"), cipher.final()]);
  return [
    ENVELOPE_VERSION,
    iv.toString("base64url"),
    cipher.getAuthTag().toString("base64url"),
    ciphertext.toString("base64url"),
  ].join(".");
}

/** Sai key / sai ngữ cảnh / bị sửa → throw (GCM xác thực tag). */
export function openMfaValue(envelope: string, key: Buffer, context: string): string {
  assertEncryptionKey(key);
  const [version, ivValue, tagValue, ciphertextValue, extra] = envelope.split(".");
  if (version !== ENVELOPE_VERSION || !ivValue || !tagValue || !ciphertextValue || extra !== undefined) {
    throw new Error("Invalid MFA envelope.");
  }
  const iv = Buffer.from(ivValue, "base64url");
  const tag = Buffer.from(tagValue, "base64url");
  if (iv.length !== AES_GCM_IV_BYTES || tag.length !== AES_GCM_TAG_BYTES) {
    throw new Error("Invalid MFA envelope.");
  }
  const decipher = createDecipheriv("aes-256-gcm", key, iv);
  decipher.setAAD(aadOf(context));
  decipher.setAuthTag(tag);
  return Buffer.concat([
    decipher.update(Buffer.from(ciphertextValue, "base64url")),
    decipher.final(),
  ]).toString("utf8");
}

function aadOf(context: string): Buffer {
  return Buffer.from(`vexenhanh:${context}:${ENVELOPE_VERSION}`, "utf8");
}

export function base32Encode(value: Buffer): string {
  let bits = 0;
  let accumulator = 0;
  let output = "";
  for (const byte of value) {
    accumulator = (accumulator << 8) | byte;
    bits += 8;
    while (bits >= 5) {
      bits -= 5;
      output += BASE32_ALPHABET[(accumulator >>> bits) & 31];
    }
  }
  if (bits > 0) {
    output += BASE32_ALPHABET[(accumulator << (5 - bits)) & 31];
  }
  return output;
}

function base32Decode(value: string): Buffer {
  const normalized = value.trim().toUpperCase().replace(/=+$/, "");
  if (!normalized || !/^[A-Z2-7]+$/.test(normalized)) {
    throw new Error("Invalid base32 TOTP secret.");
  }
  let bits = 0;
  let accumulator = 0;
  const output: number[] = [];
  for (const character of normalized) {
    accumulator = (accumulator << 5) | BASE32_ALPHABET.indexOf(character);
    bits += 5;
    if (bits >= 8) {
      bits -= 8;
      output.push((accumulator >>> bits) & 0xff);
    }
  }
  return Buffer.from(output);
}

function hotp(key: Buffer, counter: bigint, digits: number): string {
  const value = Buffer.alloc(8);
  value.writeBigUInt64BE(counter);
  const digest = createHmac("sha1", key).update(value).digest();
  const offset = digest[digest.length - 1]! & 0x0f;
  const binary =
    ((digest[offset]! & 0x7f) << 24) |
    ((digest[offset + 1]! & 0xff) << 16) |
    ((digest[offset + 2]! & 0xff) << 8) |
    (digest[offset + 3]! & 0xff);
  return String(binary % 10 ** digits).padStart(digits, "0");
}

function assertTotpOptions(
  timestampMs: number,
  periodSeconds: number,
  digits: number,
): void {
  if (!Number.isFinite(timestampMs) || timestampMs < 0) {
    throw new Error("TOTP timestamp must be a non-negative finite number.");
  }
  if (!Number.isInteger(periodSeconds) || periodSeconds <= 0) {
    throw new Error("TOTP period must be a positive integer.");
  }
  if (!Number.isInteger(digits) || digits < 6 || digits > 9) {
    throw new Error("TOTP digits must be an integer between 6 and 9.");
  }
}

function assertEncryptionKey(key: Buffer): void {
  if (key.length !== 32) {
    throw new Error("MFA encryption key must contain exactly 32 bytes.");
  }
}
