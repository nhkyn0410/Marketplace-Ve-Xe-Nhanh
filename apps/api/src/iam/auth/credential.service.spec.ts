import { describe, expect, it } from "vitest";
import { CredentialService, DUMMY_PASSWORD_HASH } from "./credential.service";

describe("CredentialService", () => {
  const service = new CredentialService();

  it("không lưu plaintext password trong chuỗi hash", async () => {
    const stored = await service.hash("s3cret-pass");
    expect(stored).not.toContain("s3cret-pass");
  });

  it("dummy hash dùng ĐÚNG tham số cost của hash thật (chống timing oracle)", async () => {
    // Nếu hai bên lệch cost, nhánh "account không tồn tại" sẽ nhanh/chậm hơn nhánh "sai mật khẩu"
    // → enumeration bằng timing quay lại. Test này khoá hai bên vào cùng một nguồn tham số.
    const real = await service.hash("bất kỳ");
    const [, realN, realR, realP] = real.split("$");
    const [, dummyN, dummyR, dummyP] = DUMMY_PASSWORD_HASH.split("$");

    expect([dummyN, dummyR, dummyP]).toEqual([realN, realR, realP]);
    expect(await service.verify("bất kỳ", DUMMY_PASSWORD_HASH)).toBe(false);
  });

  it("verify hash cost cũ vẫn chạy (params nhúng → nâng cost không vỡ format)", async () => {
    // Dựng hash bằng N nhỏ hơn mặc định rồi verify: chứng minh forward-compat thật sự hoạt động,
    // không chỉ là lời hứa trong comment.
    const { randomBytes, scryptSync } = await import("node:crypto");
    const salt = randomBytes(16);
    const derived = scryptSync("old-pass", salt, 64, { N: 1 << 14, r: 8, p: 1 });
    const legacy = `scrypt$${1 << 14}$8$1$${salt.toString("base64")}$${derived.toString("base64")}`;

    expect(await service.verify("old-pass", legacy)).toBe(true);
    expect(await service.verify("wrong", legacy)).toBe(false);
  });

  it("hash hỏng/bị sửa trả false thay vì ném lỗi (500 là kênh phân biệt account)", async () => {
    for (const bad of [
      "scrypt$99999$8$1$AAAA$AAAA", // N không phải luỹ thừa 2
      `scrypt$${1 << 21}$8$1$AAAA$AAAA`, // N vượt biên → vượt maxmem
      "scrypt$131072$8$1$$", // salt + hash rỗng
      "scrypt$131072$999$1$AAAA$AAAA" // r phi lý
    ]) {
      expect(await service.verify("any", bad)).toBe(false);
    }
  });

  it("hashes with scrypt format and verifies the correct password", async () => {
    const stored = await service.hash("s3cret-pass");
    expect(stored.startsWith("scrypt$")).toBe(true);
    expect(await service.verify("s3cret-pass", stored)).toBe(true);
  });

  it("rejects a wrong password", async () => {
    const stored = await service.hash("s3cret-pass");
    expect(await service.verify("wrong-pass", stored)).toBe(false);
  });

  it("rejects a malformed stored hash", async () => {
    expect(await service.verify("any", "not-a-valid-hash")).toBe(false);
    expect(await service.verify("any", "bcrypt$x$y")).toBe(false);
  });

  it("uses a unique salt per hash", async () => {
    const a = await service.hash("same");
    const b = await service.hash("same");
    expect(a).not.toBe(b);
  });
});
