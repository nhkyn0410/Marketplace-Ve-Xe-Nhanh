import { mkdtemp, rm } from "node:fs/promises";
import type { AddressInfo } from "node:net";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import type { NestExpressApplication } from "@nestjs/platform-express";
import { afterAll, beforeAll, describe, expect, it } from "vitest";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { configureSecurityHeaders } from "../../common/security-headers";
import { configureApiRoutes } from "../../openapi/openapi";
import { LocalStorageController } from "./local-storage.controller";
import { LocalStorageProvider } from "./local-storage-provider";
import { PUBLIC_STORAGE, type StorageProvider } from "./storage-provider";

const JPEG = Uint8Array.from([0xff, 0xd8, 0xff, 0xe0, 0, 0x10, 0x4a, 0x46, 0x49, 0x46, 0, 1]);

async function start(storage: unknown): Promise<{ app: INestApplication; base: string }> {
  @Module({ controllers: [LocalStorageController], providers: [{ provide: PUBLIC_STORAGE, useValue: storage }] })
  class HttpTestModule {}
  // Dựng như `main.ts`: tắt body parser mặc định rồi bật JSON, có helmet — để chắc luồng ảnh còn nguyên.
  const app = await NestFactory.create<NestExpressApplication>(HttpTestModule, {
    logger: false,
    abortOnError: false,
    bodyParser: false,
  });
  configureSecurityHeaders(app, "test");
  app.useBodyParser("json");
  app.useBodyParser("urlencoded", { extended: true });
  app.useGlobalFilters(new ProblemDetailsExceptionFilter());
  configureApiRoutes(app);
  await app.listen(0, "127.0.0.1");
  return { app, base: `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}` };
}

describe("Route kho ổ đĩa của dev — HTTP", () => {
  let rootDir: string;
  let app: INestApplication;
  let base: string;
  let storage: LocalStorageProvider;

  beforeAll(async () => {
    rootDir = await mkdtemp(join(tmpdir(), "vxn-storage-http-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    ({ app, base } = await start(storage));
  }, 30_000);

  afterAll(async () => {
    await app?.close();
    await rm(rootDir, { recursive: true, force: true });
  });

  /** Cổng test chỉ biết sau khi `listen`, nên kho dựng với origin giả; đổi origin của URL nó sinh sang cổng thật. */
  const local = (url: string) => `${base}${new URL(url).pathname}${new URL(url).search}`;

  async function grant(key: string, sizeBytes = JPEG.length, contentType = "image/jpeg") {
    return local((await storage.createUploadUrl({ key, contentType, sizeBytes, expiresInSeconds: 300 })).uploadUrl);
  }

  const put = (url: string, body: Uint8Array<ArrayBuffer>, contentType = "image/jpeg") =>
    fetch(url, { method: "PUT", headers: { "content-type": contentType }, body });

  it("tải lên bằng URL hợp lệ rồi đọc lại công khai, nhúng được từ origin khác", async () => {
    const key = "vehicles/op/veh/ok.jpg";
    expect((await put(await grant(key), JPEG)).status).toBe(200);

    const response = await fetch(local(storage.publicUrl(key)));
    expect(response.status).toBe(200);
    expect(response.headers.get("content-type")).toContain("image/jpeg");
    expect(response.headers.get("x-content-type-options")).toBe("nosniff");
    // helmet mặc định `same-origin` sẽ chặn thẻ <img> của Operator OS (khác cổng).
    expect(response.headers.get("cross-origin-resource-policy")).toBe("cross-origin");
    expect([...new Uint8Array(await response.arrayBuffer())]).toEqual([...JPEG]);
  });

  it("thiếu token, token sai, sai Content-Type → 403 và không ghi gì", async () => {
    const key = "vehicles/op/veh/denied.jpg";
    const url = await grant(key);
    expect((await put(`${base}/v1/dev-storage/upload`, JPEG)).status).toBe(403);
    expect((await put(`${url}x`, JPEG)).status).toBe(403);
    expect((await put(url, JPEG, "image/png")).status).toBe(403);
    expect((await put(url, JPEG, "text/html")).status).toBe(403);
    expect(await storage.head(key)).toBeNull();
  });

  it("file lớn hơn hoặc nhỏ hơn dung lượng đã khai → từ chối, không ghi gì", async () => {
    const key = "vehicles/op/veh/size.jpg";
    expect((await put(await grant(key, JPEG.length - 1), JPEG)).status).toBe(413);
    expect((await put(await grant(key, JPEG.length + 1), JPEG)).status).toBe(403);
    expect(await storage.head(key)).toBeNull();
  });

  it("đọc object không có hoặc khóa đi ngược thư mục → 404", async () => {
    expect((await fetch(`${base}/v1/dev-storage/public/vehicles/op/veh/khong-co.jpg`)).status).toBe(404);
    expect((await fetch(`${base}/v1/dev-storage/public/..%2F..%2Fpackage.json`)).status).toBe(404);
  });

  it("kho không phải ổ đĩa local (R2 ở production) → cả hai route trả 404", async () => {
    const notLocal: Partial<StorageProvider> = { publicUrl: (key) => `https://cdn.example.com/${key}` };
    const other = await start(notLocal);
    try {
      const token = new URL(await grant("vehicles/op/veh/r2.jpg")).searchParams.get("token");
      expect((await put(`${other.base}/v1/dev-storage/upload?token=${token}`, JPEG)).status).toBe(404);
      expect((await fetch(`${other.base}/v1/dev-storage/public/vehicles/op/veh/ok.jpg`)).status).toBe(404);
    } finally {
      await other.app.close();
    }
  });
});
