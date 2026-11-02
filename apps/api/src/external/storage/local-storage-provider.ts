import { createHmac, randomBytes, timingSafeEqual } from "node:crypto";
import { mkdir, open, readdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import { dirname, resolve, sep } from "node:path";
import type {
  DownloadTarget,
  DownloadUrlInput,
  StorageProvider,
  StoredObject,
  UploadTarget,
  UploadUrlInput,
} from "./storage-provider";

/** Đường dẫn (sau prefix `/v1`) của hai route dev phục vụ adapter này — xem `LocalStorageController`. */
export const LOCAL_STORAGE_ROUTE = "dev-storage";

// Chỉ nhận khóa do server sinh: chữ, số, `/ _ . -`, không có đoạn `..` — chặn thoát khỏi thư mục gốc.
const SAFE_KEY = /^[A-Za-z0-9_-]+(?:[./][A-Za-z0-9_-]+)*$/;
const META_SUFFIX = ".meta.json";

export type UploadGrant = { key: string; contentType: string; sizeBytes: number };
export type DownloadGrant = { key: string; fileName: string };

export type LocalStorageOptions = {
  /** Thư mục gốc chứa object. */
  rootDir: string;
  /** Origin công khai của API, không có `/` cuối — URL tải lên và URL đọc trỏ về chính API. */
  apiBaseUrl: string;
  /** Khóa ký URL tải lên; bỏ trống thì sinh ngẫu nhiên cho mỗi tiến trình. */
  secret?: Buffer;
};

/**
 * Kho object trên ổ đĩa cho dev / test (ADR-018: "dev-local"), thay R2 khi chưa có cấu hình R2. Bắt chước
 * presigned URL bằng một token HMAC có hạn, ràng đúng khóa + loại + dung lượng; file được tải lên và đọc qua
 * hai route dev của API. KHÔNG dùng ở production — cấu hình env đã bắt buộc R2 ở đó.
 */
export class LocalStorageProvider implements StorageProvider {
  private readonly rootDir: string;
  private readonly secret: Buffer;

  constructor(private readonly options: LocalStorageOptions) {
    this.rootDir = resolve(options.rootDir);
    this.secret = options.secret ?? randomBytes(32);
  }

  async createUploadUrl(input: UploadUrlInput): Promise<UploadTarget> {
    const expiresAt = new Date(Date.now() + input.expiresInSeconds * 1000);
    const token = this.signToken({ a: "put", k: input.key, t: input.contentType, s: input.sizeBytes, e: expiresAt.getTime() });
    return { uploadUrl: `${this.options.apiBaseUrl}/v1/${LOCAL_STORAGE_ROUTE}/upload?token=${token}`, expiresAt };
  }

  /** Quyền tải lên ghi trong token; `null` nếu token sai chữ ký, sai dạng, sai loại hoặc hết hạn. */
  verifyUploadToken(token: string, nowMs: number = Date.now()): UploadGrant | null {
    const data = this.readToken(token, nowMs);
    if (!data || data.a !== "put" || typeof data.k !== "string" || typeof data.t !== "string" || typeof data.s !== "number") {
      return null;
    }
    return { key: data.k, contentType: data.t, sizeBytes: data.s };
  }

  async createDownloadUrl(input: DownloadUrlInput): Promise<DownloadTarget> {
    const expiresAt = new Date(Date.now() + input.expiresInSeconds * 1000);
    const token = this.signToken({ a: "get", k: input.key, n: input.fileName, e: expiresAt.getTime() });
    return { url: `${this.options.apiBaseUrl}/v1/${LOCAL_STORAGE_ROUTE}/download?token=${token}`, expiresAt };
  }

  /** Quyền đọc ghi trong token của URL tải về; `null` nếu token sai hoặc hết hạn. */
  verifyDownloadToken(token: string, nowMs: number = Date.now()): DownloadGrant | null {
    const data = this.readToken(token, nowMs);
    if (!data || data.a !== "get" || typeof data.k !== "string" || typeof data.n !== "string") {
      return null;
    }
    return { key: data.k, fileName: data.n };
  }

  /** Ghi một object (route tải lên của dev và test dùng). */
  async write(key: string, contentType: string, body: Uint8Array): Promise<void> {
    const path = this.pathOf(key);
    await mkdir(dirname(path), { recursive: true });
    await writeFile(path, body);
    await writeFile(`${path}${META_SUFFIX}`, JSON.stringify({ contentType }));
  }

  /** Nội dung + loại của object (route đọc công khai của dev); `null` nếu không có. */
  async read(key: string): Promise<{ body: Buffer; contentType: string | null } | null> {
    const info = await this.head(key);
    if (!info) {
      return null;
    }
    return { body: await readFile(this.pathOf(key)), contentType: info.contentType };
  }

  async head(key: string): Promise<StoredObject | null> {
    if (!SAFE_KEY.test(key)) {
      return null;
    }
    const path = this.pathOf(key);
    try {
      const file = await stat(path);
      if (!file.isFile()) {
        return null;
      }
      let contentType: string | null = null;
      try {
        const meta = JSON.parse(await readFile(`${path}${META_SUFFIX}`, "utf8")) as { contentType?: unknown };
        contentType = typeof meta.contentType === "string" ? meta.contentType : null;
      } catch {
        // Thiếu file mô tả: coi như không rõ loại.
      }
      return { sizeBytes: file.size, contentType, lastModified: file.mtime };
    } catch (error) {
      if (isMissing(error)) {
        return null;
      }
      throw error;
    }
  }

  async readStart(key: string, length: number): Promise<Uint8Array> {
    const handle = await open(this.pathOf(key), "r");
    try {
      const buffer = Buffer.alloc(length);
      const { bytesRead } = await handle.read(buffer, 0, length, 0);
      return buffer.subarray(0, bytesRead);
    } finally {
      await handle.close();
    }
  }

  async delete(key: string): Promise<void> {
    const path = this.pathOf(key);
    await rm(path, { force: true });
    await rm(`${path}${META_SUFFIX}`, { force: true });
  }

  async *list(prefix: string): AsyncIterable<{ key: string; lastModified: Date }> {
    let entries: string[];
    try {
      entries = await readdir(this.rootDir, { recursive: true });
    } catch (error) {
      if (isMissing(error)) {
        return;
      }
      throw error;
    }
    for (const entry of entries) {
      const key = entry.split(sep).join("/");
      if (!key.startsWith(prefix) || key.endsWith(META_SUFFIX)) {
        continue;
      }
      const info = await this.head(key);
      if (info) {
        yield { key, lastModified: info.lastModified };
      }
    }
  }

  publicUrl(key: string): string {
    return `${this.options.apiBaseUrl}/v1/${LOCAL_STORAGE_ROUTE}/public/${key}`;
  }

  private sign(payload: string): string {
    return createHmac("sha256", this.secret).update(payload).digest("base64url");
  }

  // Token = base64url(JSON) + "." + HMAC. Trường `a` phân biệt quyền ghi (`put`) với quyền đọc (`get`): URL tải
  // về không dùng được để ghi đè file và ngược lại.
  private signToken(data: Record<string, unknown>): string {
    const payload = Buffer.from(JSON.stringify(data)).toString("base64url");
    return `${payload}.${this.sign(payload)}`;
  }

  private readToken(token: string, nowMs: number): Record<string, unknown> | null {
    const [payload, signature, ...rest] = token.split(".");
    if (!payload || !signature || rest.length > 0) {
      return null;
    }
    const expected = Buffer.from(this.sign(payload));
    const given = Buffer.from(signature);
    if (expected.length !== given.length || !timingSafeEqual(expected, given)) {
      return null;
    }
    try {
      const data = JSON.parse(Buffer.from(payload, "base64url").toString("utf8")) as Record<string, unknown>;
      return typeof data.e === "number" && data.e > nowMs ? data : null;
    } catch {
      return null;
    }
  }

  private pathOf(key: string): string {
    if (!SAFE_KEY.test(key)) {
      throw new Error("Khóa object không hợp lệ.");
    }
    const path = resolve(this.rootDir, key);
    if (!path.startsWith(this.rootDir + sep)) {
      throw new Error("Khóa object nằm ngoài thư mục lưu trữ.");
    }
    return path;
  }
}

function isMissing(error: unknown): boolean {
  return (error as { code?: unknown } | null)?.code === "ENOENT";
}
