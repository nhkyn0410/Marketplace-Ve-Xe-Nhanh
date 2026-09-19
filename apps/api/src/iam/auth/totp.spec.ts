import { randomBytes } from "node:crypto";
import { describe, expect, it } from "vitest";
import {
  createOtpAuthUri,
  generateTotp,
  generateTotpSecret,
  openMfaValue,
  sealMfaValue,
  verifyTotp,
} from "./totp";

describe("TOTP RFC 6238", () => {
  const rfcSecret = "GEZDGNBVGY3TQOJQGEZDGNBVGY3TQOJQ";

  it.each([
    [59, "94287082"],
    [1_111_111_109, "07081804"],
    [1_111_111_111, "14050471"],
    [1_234_567_890, "89005924"],
    [2_000_000_000, "69279037"],
    [20_000_000_000, "65353130"],
  ])("matches the SHA-1 vector at %s seconds", (seconds, expected) => {
    expect(
      generateTotp(rfcSecret, {
        timestampMs: seconds * 1000,
        digits: 8,
      }),
    ).toBe(expected);
  });

  it("accepts only the configured ±1 time-step and returns the accepted counter", () => {
    const secret = generateTotpSecret();
    const now = 1_800_000_000_000;
    const current = BigInt(Math.floor(now / 1000 / 30));
    const at = (offsetSteps: number) => generateTotp(secret, { timestampMs: now + offsetSteps * 30_000 });

    expect(verifyTotp(secret, at(-1), { timestampMs: now })).toBe(current - 1n);
    expect(verifyTotp(secret, at(0), { timestampMs: now })).toBe(current);
    expect(verifyTotp(secret, at(1), { timestampMs: now })).toBe(current + 1n);
    expect(verifyTotp(secret, at(-2), { timestampMs: now })).toBeNull();
    expect(verifyTotp(secret, at(2), { timestampMs: now })).toBeNull();
  });

  it("rejects a counter that was already accepted", () => {
    const secret = generateTotpSecret();
    const now = 1_800_000_000_000;
    const code = generateTotp(secret, { timestampMs: now });
    const counter = verifyTotp(secret, code, { timestampMs: now });

    expect(counter).not.toBeNull();
    expect(
      verifyTotp(secret, code, {
        timestampMs: now,
        lastCounter: counter,
      }),
    ).toBeNull();
  });
});

describe("TOTP secret protection", () => {
  it("encrypts with a randomized authenticated AES-256-GCM envelope", () => {
    const key = randomBytes(32);
    const secret = generateTotpSecret();
    const first = sealMfaValue(secret, key, "mfa-secret:PLATFORM:a");
    const second = sealMfaValue(secret, key, "mfa-secret:PLATFORM:a");

    expect(first).not.toBe(second);
    expect(first).not.toContain(secret);
    expect(openMfaValue(first, key, "mfa-secret:PLATFORM:a")).toBe(secret);
    expect(openMfaValue(second, key, "mfa-secret:PLATFORM:a")).toBe(secret);
  });

  it("context nằm trong AAD: đúng key nhưng sai ngữ cảnh (chủ thể khác) → không mở được", () => {
    const key = randomBytes(32);
    const sealed = sealMfaValue("secret", key, "mfa-secret:PLATFORM:a");

    expect(() => openMfaValue(sealed, key, "mfa-secret:PLATFORM:b")).toThrow();
  });

  it("rejects a tampered ciphertext or tag, and a wrong key (GCM authentication)", () => {
    const key = randomBytes(32);
    const context = "mfa-secret:PLATFORM:a";
    const encrypted = sealMfaValue(generateTotpSecret(), key, context);
    const [version, iv, tag, ciphertext] = encrypted.split(".") as [string, string, string, string];
    // Lật một byte THẬT: đổi ký tự base64 cuối có thể chỉ chạm bit đệm → test xanh/đỏ ngẫu nhiên.
    const flip = (field: string) => {
      const bytes = Buffer.from(field, "base64url");
      bytes[0] = bytes[0]! ^ 0x01;
      return bytes.toString("base64url");
    };

    expect(() => openMfaValue([version, iv, tag, flip(ciphertext)].join("."), key, context)).toThrow();
    expect(() => openMfaValue([version, iv, flip(tag), ciphertext].join("."), key, context)).toThrow();
    expect(() => openMfaValue(encrypted, randomBytes(32), context)).toThrow();
    expect(() => openMfaValue(`v2.${iv}.${tag}.${ciphertext}`, key, context)).toThrow();
  });

  it("builds a standards-compatible enrollment URI without leaking the label into query fields", () => {
    const raw = createOtpAuthUri("ABC234", "owner@example.com");
    const uri = new URL(raw);
    // RFC 3986: `%20`, không `+` — `searchParams.get` giải mã cả hai nên phải kiểm chuỗi thô.
    expect(raw).toContain("issuer=Ve%20Xe%20Nhanh");
    expect(raw).not.toContain("+");

    expect(uri.protocol).toBe("otpauth:");
    expect(decodeURIComponent(uri.pathname)).toBe("/Ve Xe Nhanh:owner@example.com");
    expect(uri.searchParams.get("secret")).toBe("ABC234");
    expect(uri.searchParams.get("algorithm")).toBe("SHA1");
    expect(uri.searchParams.get("digits")).toBe("6");
    expect(uri.searchParams.get("period")).toBe("30");
  });
});
