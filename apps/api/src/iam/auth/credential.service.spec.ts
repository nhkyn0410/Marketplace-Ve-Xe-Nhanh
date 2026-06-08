import { describe, expect, it } from "vitest";
import { CredentialService } from "./credential.service";

describe("CredentialService", () => {
  const service = new CredentialService();

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
