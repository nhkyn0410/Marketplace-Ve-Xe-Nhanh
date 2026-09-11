import { Injectable } from "@nestjs/common";
import { randomBytes, scrypt, type ScryptOptions, timingSafeEqual } from "node:crypto";

// Wrapper thủ công để dùng overload scrypt CÓ options (promisify chỉ bắt overload 3-arg).
function deriveKey(
  password: string,
  salt: Buffer,
  keylen: number,
  options: ScryptOptions
): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    scrypt(password, salt, keylen, options, (error, derived) => {
      if (error) {
        reject(error);
      } else {
        resolve(derived);
      }
    });
  });
}

const KEY_LENGTH = 64;
const SALT_LENGTH = 16;
const PREFIX = "scrypt";

// Cost params. OWASP cho phép đánh đổi N thấp hơn bằng p cao hơn: N=2^16, r=8, p=2.
// Bộ nhớ = 128*N*r = 64 MiB/lần verify (thay vì 128 MiB ở N=2^17) — instance Render free chỉ có
// 512 MB, và mọi lần login đều tốn một lần verify kể cả khi account không tồn tại (dummy verify
// chống enumeration). Params được lưu kèm hash nên đổi cost KHÔNG vỡ hash cũ, không cần migration.
const SCRYPT_N = 1 << 16;
const SCRYPT_R = 8;
const SCRYPT_P = 2;
const SCRYPT_MAXMEM = 256 * 1024 * 1024;

/**
 * Hash/verify password cho Operator/Platform (custom, KHÔNG qua Better Auth).
 * scrypt (Node built-in) — mạnh, không cần native dep (distroless-safe).
 * Format: `scrypt$N$r$p$<saltBase64>$<hashBase64>` (params nhúng để forward-compatible).
 */
/**
 * Hash giả dùng khi account không tồn tại — PHẢI cùng tham số cost với hash thật,
 * nếu không thời gian hai nhánh lệch nhau → timing oracle cho account enumeration.
 * Dựng từ chính SCRYPT_* nên nâng cost không bao giờ làm lệch (không hardcode ở nơi khác).
 */
export const DUMMY_PASSWORD_HASH =
  `${PREFIX}$${SCRYPT_N}$${SCRYPT_R}$${SCRYPT_P}` +
  `$${Buffer.alloc(SALT_LENGTH).toString("base64")}$${Buffer.alloc(KEY_LENGTH).toString("base64")}`;

/**
 * Giới hạn số phép scrypt chạy song song. Mỗi phép cấp phát 128*N*r byte (N=2^16, r=8 → 64 MiB);
 * libuv threadpool mặc định 4 thread nên không chặn = 256 MiB cùng lúc trên instance 512 MB.
 * Hàng đợi ở đây giữ bộ nhớ đỉnh ở mức 128 MiB.
 */
const MAX_CONCURRENT_SCRYPT = 2;

@Injectable()
export class CredentialService {
  private active = 0;
  private readonly waiting: Array<() => void> = [];

  private async withSlot<T>(work: () => Promise<T>): Promise<T> {
    if (this.active >= MAX_CONCURRENT_SCRYPT) {
      await new Promise<void>((resolve) => this.waiting.push(resolve));
    }
    this.active += 1;
    try {
      return await work();
    } finally {
      this.active -= 1;
      this.waiting.shift()?.();
    }
  }

  async hash(password: string): Promise<string> {
    const salt = randomBytes(SALT_LENGTH);
    const derived = await this.withSlot(() =>
      deriveKey(password, salt, KEY_LENGTH, {
        N: SCRYPT_N,
        r: SCRYPT_R,
        p: SCRYPT_P,
        maxmem: SCRYPT_MAXMEM
      })
    );
    return `${PREFIX}$${SCRYPT_N}$${SCRYPT_R}$${SCRYPT_P}$${salt.toString("base64")}$${derived.toString("base64")}`;
  }

  async verify(password: string, stored: string): Promise<boolean> {
    const parts = stored.split("$");
    if (parts.length !== 6 || parts[0] !== PREFIX) {
      return false;
    }
    const n = Number(parts[1]);
    const r = Number(parts[2]);
    const p = Number(parts[3]);
    const salt = Buffer.from(parts[4], "base64");
    const expected = Buffer.from(parts[5], "base64");

    // Tham số đọc từ DB — hash hỏng/bị sửa không được làm scrypt ném lỗi (500 = kênh phân biệt
    // account) và không được cho phép chọn cost khuếch đại tài nguyên.
    if (!isValidCost(n, r, p) || expected.length !== KEY_LENGTH || salt.length === 0) {
      return false;
    }

    try {
      const derived = await this.withSlot(() =>
        deriveKey(password, salt, expected.length, { N: n, r, p, maxmem: SCRYPT_MAXMEM })
      );
      return derived.length === expected.length && timingSafeEqual(derived, expected);
    } catch {
      return false;
    }
  }
}

/** N phải là luỹ thừa 2 trong biên hợp lệ; r/p nhỏ để không vượt maxmem. */
function isValidCost(n: number, r: number, p: number): boolean {
  return (
    Number.isInteger(n) &&
    Number.isInteger(r) &&
    Number.isInteger(p) &&
    n >= 1 << 12 &&
    n <= 1 << 20 &&
    (n & (n - 1)) === 0 &&
    r >= 1 &&
    r <= 16 &&
    p >= 1 &&
    p <= 4 &&
    128 * n * r <= SCRYPT_MAXMEM
  );
}
