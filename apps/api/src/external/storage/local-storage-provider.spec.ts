import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { LocalStorageProvider } from "./local-storage-provider";

describe("LocalStorageProvider", () => {
  let rootDir: string;
  let storage: LocalStorageProvider;
  const grant = { key: "vehicles/op/veh/a.jpg", contentType: "image/jpeg", sizeBytes: 3, expiresInSeconds: 300 };

  beforeAll(async () => {
    rootDir = await mkdtemp(join(tmpdir(), "vxn-storage-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://localhost:3000" });
  });

  afterAll(async () => {
    await rm(rootDir, { recursive: true, force: true });
  });

  const tokenOf = (uploadUrl: string) => new URL(uploadUrl).searchParams.get("token")!;

  it("URL tải lên mang token ràng đúng khóa, loại, dung lượng và có hạn", async () => {
    const before = Date.now();
    const target = await storage.createUploadUrl(grant);
    expect(target.uploadUrl.startsWith("http://localhost:3000/v1/dev-storage/upload?token=")).toBe(true);
    expect(target.expiresAt.getTime()).toBeGreaterThanOrEqual(before + 300_000);
    expect(storage.verifyUploadToken(tokenOf(target.uploadUrl))).toEqual({
      key: grant.key,
      contentType: "image/jpeg",
      sizeBytes: 3,
    });
  });

  it("token hết hạn, bị sửa, sai dạng hoặc ký bằng khóa khác → null", async () => {
    const token = tokenOf((await storage.createUploadUrl(grant)).uploadUrl);
    expect(storage.verifyUploadToken(token, Date.now() + 301_000)).toBeNull();
    const [payload, signature] = token.split(".") as [string, string];
    const forged = Buffer.from(
      JSON.stringify({ k: "vehicles/other/veh/a.jpg", t: "image/jpeg", s: 3, e: Date.now() + 60_000 }),
    ).toString("base64url");
    expect(storage.verifyUploadToken(`${forged}.${signature}`)).toBeNull();
    expect(storage.verifyUploadToken(`${payload}.${signature}x`)).toBeNull();
    expect(storage.verifyUploadToken(`${payload}.${signature}.extra`)).toBeNull();
    expect(storage.verifyUploadToken(payload)).toBeNull();
    expect(storage.verifyUploadToken("")).toBeNull();
    const other = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://localhost:3000" });
    expect(other.verifyUploadToken(token)).toBeNull();
  });

  it("ghi → head / readStart / read / list → xóa", async () => {
    const body = Uint8Array.from([0xff, 0xd8, 0xff, 0xe0, 1, 2, 3]);
    await storage.write("vehicles/op/veh/b.jpg", "image/jpeg", body);
    const info = await storage.head("vehicles/op/veh/b.jpg");
    expect(info).toMatchObject({ sizeBytes: 7, contentType: "image/jpeg" });
    expect(Date.now() - info!.lastModified.getTime()).toBeLessThan(60_000);
    expect([...(await storage.readStart("vehicles/op/veh/b.jpg", 3))]).toEqual([0xff, 0xd8, 0xff]);
    // Xin nhiều byte hơn file có: trả phần có thật, không độn 0.
    expect((await storage.readStart("vehicles/op/veh/b.jpg", 100)).length).toBe(7);
    expect((await storage.read("vehicles/op/veh/b.jpg"))?.contentType).toBe("image/jpeg");

    await storage.write("avatars/x.png", "image/png", Uint8Array.from([1]));
    const listed: string[] = [];
    for await (const object of storage.list("vehicles/")) {
      listed.push(object.key);
    }
    // File mô tả `.meta.json` không lộ ra như một object; tiền tố khác không lẫn vào.
    expect(listed).toEqual(["vehicles/op/veh/b.jpg"]);

    await storage.delete("vehicles/op/veh/b.jpg");
    expect(await storage.head("vehicles/op/veh/b.jpg")).toBeNull();
    expect(await storage.read("vehicles/op/veh/b.jpg")).toBeNull();
    // Xóa object không còn: không lỗi (job dọn và xóa sau commit có thể trùng nhau).
    await expect(storage.delete("vehicles/op/veh/b.jpg")).resolves.toBeUndefined();
  });

  it("khóa đi ngược thư mục hoặc tuyệt đối không ghi / đọc / xóa được", async () => {
    for (const key of ["../outside.jpg", "vehicles/../../outside.jpg", "/etc/passwd", "C:/Windows/win.ini", "a//b", ""]) {
      await expect(storage.write(key, "image/jpeg", Uint8Array.from([1])), key).rejects.toThrow();
      await expect(storage.delete(key), key).rejects.toThrow();
      expect(await storage.head(key), key).toBeNull();
      expect(await storage.read(key), key).toBeNull();
    }
  });

  it("kho chưa có thư mục gốc: list rỗng, không lỗi", async () => {
    const empty = new LocalStorageProvider({ rootDir: join(rootDir, "chua-co"), apiBaseUrl: "http://localhost:3000" });
    const listed: string[] = [];
    for await (const object of empty.list("vehicles/")) {
      listed.push(object.key);
    }
    expect(listed).toEqual([]);
  });

  it("URL tải về (kho riêng tư): token có hạn, ràng đúng khóa + tên file, không dùng thay token tải lên", async () => {
    const target = await storage.createDownloadUrl({ key: "operator-applications/a/doc.pdf", expiresInSeconds: 300, fileName: "doc.pdf" });
    expect(target.url.startsWith("http://localhost:3000/v1/dev-storage/download?token=")).toBe(true);
    const token = tokenOf(target.url);
    expect(storage.verifyDownloadToken(token)).toEqual({ key: "operator-applications/a/doc.pdf", fileName: "doc.pdf" });
    expect(storage.verifyDownloadToken(token, Date.now() + 301_000)).toBeNull();
    // Token đọc và token ghi không đổi chỗ cho nhau được.
    expect(storage.verifyUploadToken(token)).toBeNull();
    expect(storage.verifyDownloadToken(tokenOf((await storage.createUploadUrl(grant)).uploadUrl))).toBeNull();
  });

  it("địa chỉ công khai trỏ về route đọc của API", () => {
    expect(storage.publicUrl("vehicles/op/veh/a.jpg")).toBe(
      "http://localhost:3000/v1/dev-storage/public/vehicles/op/veh/a.jpg",
    );
  });
});
