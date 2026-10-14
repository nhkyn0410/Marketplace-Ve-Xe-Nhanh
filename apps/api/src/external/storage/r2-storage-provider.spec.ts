import {
  DeleteObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  ListObjectsV2Command,
  type S3Client,
} from "@aws-sdk/client-s3";
import { describe, expect, it, vi } from "vitest";
import { R2StorageProvider } from "./r2-storage-provider";

const config = {
  accountId: "acc123",
  accessKeyId: "key-id",
  secretAccessKey: "secret",
  bucket: "vexenhanh-public",
  publicBaseUrl: "https://cdn.example.com",
};

/** Client giả: test không gọi mạng, chỉ kiểm lệnh S3 gửi đi và cách đọc kết quả. */
function withClient(send: (command: unknown) => unknown) {
  const spy = vi.fn(async (command: unknown) => send(command));
  return { storage: new R2StorageProvider(config, { send: spy } as unknown as S3Client), send: spy };
}

describe("R2StorageProvider", () => {
  it("URL tải lên: trỏ đúng endpoint R2 + bucket + khóa, ký kèm Content-Type, hạn đúng TTL", async () => {
    // Ký URL là tính toán tại chỗ nên dùng client thật, không có lệnh nào đi ra mạng.
    const storage = new R2StorageProvider(config);
    const before = Date.now();
    const target = await storage.createUploadUrl({
      key: "vehicles/op/veh/a.jpg",
      contentType: "image/jpeg",
      sizeBytes: 1234,
      expiresInSeconds: 300,
    });
    const url = new URL(target.uploadUrl);
    expect(url.host).toContain("acc123.r2.cloudflarestorage.com");
    expect(`${url.host}${url.pathname}`).toContain("vexenhanh-public");
    expect(url.pathname.endsWith("/vehicles/op/veh/a.jpg")).toBe(true);
    expect(url.searchParams.get("X-Amz-Expires")).toBe("300");
    // Content-Type nằm trong chữ ký: tải lên bằng loại khác thì R2 từ chối.
    expect(url.searchParams.get("X-Amz-SignedHeaders")?.split(";")).toContain("content-type");
    expect(url.searchParams.get("X-Amz-Signature")).toMatch(/^[0-9a-f]{64}$/);
    expect(target.expiresAt.getTime()).toBeGreaterThanOrEqual(before + 300_000);
    // Khóa bí mật không lọt vào URL.
    expect(target.uploadUrl).not.toContain("secret");
  });

  it("head: trả dung lượng / loại / thời điểm; object không có → null; lỗi khác ném ra", async () => {
    const lastModified = new Date("2026-10-14T00:00:00.000Z");
    const found = withClient(() => ({ ContentLength: 42, ContentType: "image/png", LastModified: lastModified }));
    expect(await found.storage.head("vehicles/a.png")).toEqual({
      sizeBytes: 42,
      contentType: "image/png",
      lastModified,
    });
    const command = found.send.mock.calls[0]![0] as HeadObjectCommand;
    expect(command).toBeInstanceOf(HeadObjectCommand);
    expect(command.input).toEqual({ Bucket: "vexenhanh-public", Key: "vehicles/a.png" });

    const missing = withClient(() => {
      throw Object.assign(new Error("NotFound"), { name: "NotFound", $metadata: { httpStatusCode: 404 } });
    });
    expect(await missing.storage.head("vehicles/a.png")).toBeNull();

    const broken = withClient(() => {
      throw Object.assign(new Error("boom"), { name: "InternalError", $metadata: { httpStatusCode: 500 } });
    });
    await expect(broken.storage.head("vehicles/a.png")).rejects.toThrow("boom");
  });

  it("readStart: chỉ xin đúng khoảng byte đầu", async () => {
    const { storage, send } = withClient(() => ({
      Body: { transformToByteArray: async () => Uint8Array.from([1, 2, 3]) },
    }));
    expect([...(await storage.readStart("vehicles/a.png", 12))]).toEqual([1, 2, 3]);
    const command = send.mock.calls[0]![0] as GetObjectCommand;
    expect(command).toBeInstanceOf(GetObjectCommand);
    expect(command.input.Range).toBe("bytes=0-11");
  });

  it("delete gửi đúng khóa; list đi hết các trang", async () => {
    const removed = withClient(() => ({}));
    await removed.storage.delete("vehicles/a.png");
    const deleteCommand = removed.send.mock.calls[0]![0] as DeleteObjectCommand;
    expect(deleteCommand).toBeInstanceOf(DeleteObjectCommand);
    expect(deleteCommand.input).toEqual({ Bucket: "vexenhanh-public", Key: "vehicles/a.png" });

    const when = new Date("2026-10-13T00:00:00.000Z");
    const pages = [
      { Contents: [{ Key: "vehicles/1.jpg", LastModified: when }], IsTruncated: true, NextContinuationToken: "next" },
      { Contents: [{ Key: "vehicles/2.jpg", LastModified: when }, {}], IsTruncated: false },
    ];
    const listed = withClient(() => pages.shift());
    const keys: string[] = [];
    for await (const object of listed.storage.list("vehicles/")) {
      keys.push(object.key);
    }
    expect(keys).toEqual(["vehicles/1.jpg", "vehicles/2.jpg"]);
    const [first, second] = listed.send.mock.calls.map((call) => call[0] as ListObjectsV2Command);
    expect(first).toBeInstanceOf(ListObjectsV2Command);
    expect(first!.input).toMatchObject({ Bucket: "vexenhanh-public", Prefix: "vehicles/" });
    expect(second!.input.ContinuationToken).toBe("next");
  });

  it("địa chỉ công khai ghép từ gốc CDN", () => {
    expect(new R2StorageProvider(config).publicUrl("vehicles/op/veh/a.jpg")).toBe(
      "https://cdn.example.com/vehicles/op/veh/a.jpg",
    );
  });
});
