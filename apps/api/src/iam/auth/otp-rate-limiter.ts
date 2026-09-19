import { isIP } from "node:net";
import { HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import type Redis from "ioredis";
import { REDIS_CLIENT } from "../../redis/redis.config";
import {
  LOGIN_MAX_PER_IDENTIFIER_PER_HOUR,
  LOGIN_MAX_PER_IP_PER_HOUR,
  LOGIN_WINDOW_SECONDS,
  MFA_FAILURE_WINDOW_SECONDS,
  MFA_MAX_FAILURES_PER_WINDOW,
  OTP_COOLDOWN_SECONDS,
  OTP_MAX_PER_HOUR,
  OTP_WINDOW_SECONDS,
  REFRESH_MAX_PER_FAMILY_PER_HOUR,
  REFRESH_MAX_PER_IP_PER_HOUR,
  REFRESH_WINDOW_SECONDS
} from "./auth.constants";
import { AuthException, otpRateLimited, serviceUnavailable } from "./auth.errors";
import { resolveIdentifier } from "./namespace.resolver";

/**
 * INCR + EXPIRE trong MỘT lệnh. Tách hai lệnh thì lỗi/timeout đúng khe giữa chúng sẽ để lại
 * key KHÔNG TTL → bucket đó bị khoá vĩnh viễn (người dùng mất luôn kênh đăng nhập).
 */
const INCR_WITH_TTL = `
local c = redis.call('INCR', KEYS[1])
if c == 1 then redis.call('EXPIRE', KEYS[1], ARGV[1]) end
return c
`;

/**
 * Rate limit đường xác thực. Dùng Redis (ADR-015).
 * - OTP (SEC-OQ-07): cooldown 60s + ≤5 lần/giờ/email. Verify-attempt (3 lần/OTP) do Better Auth.
 * - Login credential (Security §11 "brute force login"): ≤10 lần/giờ/identifier và ≤30 lần/giờ/IP.
 */
@Injectable()
export class OtpRateLimiter {
  private readonly logger = new Logger(OtpRateLimiter.name);

  constructor(@Inject(REDIS_CLIENT) private readonly redis: Redis) {}

  async assertCanRequest(email: string): Promise<void> {
    const key = normalize(email);
    let acquired: string | null;
    try {
      // Atomic check-and-set: `SET NX EX` → null nghĩa là cooldown đang active (chống TOCTOU burst).
      acquired = await this.redis.set(
        `otp:cooldown:${key}`,
        "1",
        "EX",
        OTP_COOLDOWN_SECONDS,
        "NX"
      );
    } catch {
      throw serviceUnavailable();
    }
    if (acquired === null) {
      throw otpRateLimited();
    }

    if ((await this.bump(`otp:count:${key}`, OTP_WINDOW_SECONDS)) > OTP_MAX_PER_HOUR) {
      throw otpRateLimited();
    }
  }

  /**
   * Chặn brute-force / DoS trên 3 cổng login. Đếm theo CẢ identifier lẫn IP: chỉ theo identifier
   * thì đổi identifier là lách được (mỗi lần verify tốn 128 MiB scrypt); chỉ theo IP thì
   * botnet lách được.
   */
  async assertCanAttemptLogin(identifier: string, ip?: string): Promise<void> {
    const perIdentifier = await this.bump(`login:id:${loginBucket(identifier)}`, LOGIN_WINDOW_SECONDS);
    if (perIdentifier > LOGIN_MAX_PER_IDENTIFIER_PER_HOUR) {
      this.logger.warn({ event: "auth.login.rate_limited", dimension: "identifier" });
      throw loginRateLimited();
    }

    await this.assertLoginIp(ip);
  }

  /**
   * Re-auth (IAM-002, FR-IAM-10). Bucket chủ thể RIÊNG (`reauth-attempt:`), không dùng chung
   * `login:id:` — identifier login là chuỗi người dùng gõ, nên ai biết `sub` trong JWT cũng có thể
   * gõ đúng chuỗi đó vào cổng login 11 lần để khoá re-auth của nạn nhân. Bucket IP thì dùng CHUNG
   * với login: đổi cổng không cho thêm lượt đoán mật khẩu từ cùng một nguồn.
   */
  async assertCanReauth(userRef: string, ip?: string): Promise<void> {
    const perSubject = await this.bump(`reauth-attempt:${userRef}`, LOGIN_WINDOW_SECONDS);
    if (perSubject > LOGIN_MAX_PER_IDENTIFIER_PER_HOUR) {
      this.logger.warn({ event: "auth.reauth.rate_limited", dimension: "subject" });
      throw loginRateLimited();
    }
    await this.assertLoginIp(ip);
  }

  /** Chủ thể đã sai MFA quá trần → 429, kể cả khi mã lần này đúng (không cho "đoán tiếp chờ trúng"). */
  async assertMfaNotLocked(userRef: string): Promise<void> {
    let failures: string | null;
    try {
      failures = await this.redis.get(`mfa-fail:${userRef}`);
    } catch {
      throw serviceUnavailable();
    }
    if (Number(failures ?? 0) >= MFA_MAX_FAILURES_PER_WINDOW) {
      this.logger.warn({ event: "auth.mfa.rate_limited", dimension: "subject" });
      throw loginRateLimited();
    }
  }

  async recordMfaFailure(userRef: string): Promise<void> {
    await this.bump(`mfa-fail:${userRef}`, MFA_FAILURE_WINDOW_SECONDS);
  }

  /** Xác thực đúng → xoá bộ đếm (trần tính theo lần sai LIÊN TIẾP). Lỗi Redis ở đây không chặn login. */
  async clearMfaFailures(userRef: string): Promise<void> {
    await this.redis.del(`mfa-fail:${userRef}`).catch(() => undefined);
  }

  private async assertLoginIp(ip?: string): Promise<void> {
    if (!ip) {
      return;
    }
    const perIp = await this.bump(`login:ip:${ipBucket(ip)}`, LOGIN_WINDOW_SECONDS);
    if (perIp > LOGIN_MAX_PER_IP_PER_HOUR) {
      this.logger.warn({ event: "auth.login.rate_limited", dimension: "ip" });
      throw loginRateLimited();
    }
  }

  /**
   * `/auth/refresh` (IAM-002) theo IP. Refresh token là 256 bit ngẫu nhiên nên không dò được —
   * giới hạn này để hãm lũ request ghi Postgres + audit append-only, không phải chống brute-force.
   * Không có IP tin cậy thì bỏ qua ở đây; bucket theo family (`assertCanRotateFamily`) vẫn chặn.
   */
  async assertCanRefresh(ip?: string): Promise<void> {
    if (!ip) {
      return;
    }
    if ((await this.bump(`refresh:ip:${ipBucket(ip)}`, REFRESH_WINDOW_SECONDS)) > REFRESH_MAX_PER_IP_PER_HOUR) {
      this.logger.warn({ event: "auth.refresh.rate_limited", dimension: "ip" });
      throw refreshRateLimited();
    }
  }

  /**
   * Theo family — không phụ thuộc IP, nên gọi thẳng origin (bỏ Cloudflare) hay xoay địa chỉ IPv6
   * cũng không lách được. Mỗi lần rotate ghi một row Postgres + một bản ghi audit không xoá được.
   */
  async assertCanRotateFamily(familyId: string): Promise<void> {
    if ((await this.bump(`refresh:family:${familyId}`, REFRESH_WINDOW_SECONDS)) > REFRESH_MAX_PER_FAMILY_PER_HOUR) {
      this.logger.warn({ event: "auth.refresh.rate_limited", dimension: "family" });
      throw refreshRateLimited();
    }
  }

  private async bump(key: string, windowSeconds: number): Promise<number> {
    try {
      return Number(await this.redis.eval(INCR_WITH_TTL, 1, key, String(windowSeconds)));
    } catch {
      throw serviceUnavailable();
    }
  }
}

function normalize(value: string): string {
  return value.trim().toLowerCase();
}

/**
 * Bucket theo danh tính ĐÃ resolve, không theo chuỗi thô: resolver bỏ khoảng trắng quanh `/`, nên
 * `platform/khanh`, `platform /khanh`, `platform/	khanh`... cùng vào một account — đếm theo chuỗi
 * thô thì mỗi biến thể là một bucket mới và giới hạn 10/giờ vô nghĩa.
 */
function loginBucket(identifier: string): string {
  const resolved = resolveIdentifier(identifier);
  switch (resolved?.scope) {
    case "platform":
      return normalize(`platform/${resolved.username}`);
    case "operator":
      return normalize(`${resolved.operatorSlug}/${resolved.username}`);
    default:
      return normalize(identifier);
  }
}

/**
 * IPv6: một khách hàng thường được cấp nguyên dải /64 — đếm theo địa chỉ đầy đủ thì đổi 64 bit cuối
 * là có bucket mới vô hạn. Gom theo /64. IPv4 (kể cả dạng `::ffff:a.b.c.d`) giữ nguyên địa chỉ.
 */
export function ipBucket(ip: string): string {
  const mapped = /^::ffff:(\d{1,3}(?:\.\d{1,3}){3})$/i.exec(ip);
  if (mapped) {
    return mapped[1] as string;
  }
  if (isIP(ip) !== 6) {
    return ip;
  }
  const [head = "", tail] = ip.split("%")[0]!.split("::");
  const headParts = head ? head.split(":") : [];
  const tailParts = tail ? tail.split(":") : [];
  const groups =
    tail === undefined
      ? headParts
      : [...headParts, ...Array<string>(8 - headParts.length - tailParts.length).fill("0"), ...tailParts];
  return `${groups
    .slice(0, 4)
    .map((group) => group.toLowerCase().padStart(4, "0"))
    .join(":")}::/64`;
}

function refreshRateLimited(): AuthException {
  return new AuthException(
    HttpStatus.TOO_MANY_REQUESTS,
    "AUTH_REFRESH_RATE_LIMITED",
    "Làm mới phiên quá nhiều lần. Vui lòng thử lại sau."
  );
}

function loginRateLimited(): AuthException {
  return new AuthException(
    HttpStatus.TOO_MANY_REQUESTS,
    "AUTH_LOGIN_RATE_LIMITED",
    "Đăng nhập sai quá nhiều lần. Vui lòng thử lại sau."
  );
}
