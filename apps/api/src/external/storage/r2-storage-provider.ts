import {
  DeleteObjectCommand,
  GetObjectCommand,
  HeadObjectCommand,
  ListObjectsV2Command,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import type { StorageProvider, StoredObject, UploadTarget, UploadUrlInput } from "./storage-provider";

export type R2StorageConfig = {
  accountId: string;
  accessKeyId: string;
  secretAccessKey: string;
  bucket: string;
  /** Gốc địa chỉ công khai của bucket (CDN / custom domain), không có `/` cuối. */
  publicBaseUrl: string;
};

/**
 * Cloudflare R2 qua S3 API (ADR-018) — chỉ dùng lệnh S3 chuẩn để đổi sang S3 / B2 không phải sửa domain.
 * `client` truyền vào được để test không gọi mạng.
 */
export class R2StorageProvider implements StorageProvider {
  private readonly client: S3Client;

  constructor(
    private readonly config: R2StorageConfig,
    client?: S3Client,
  ) {
    this.client =
      client ??
      new S3Client({
        region: "auto",
        endpoint: `https://${config.accountId}.r2.cloudflarestorage.com`,
        credentials: { accessKeyId: config.accessKeyId, secretAccessKey: config.secretAccessKey },
      });
  }

  async createUploadUrl(input: UploadUrlInput): Promise<UploadTarget> {
    const expiresAt = new Date(Date.now() + input.expiresInSeconds * 1000);
    // `Content-Type` nằm trong chữ ký: tải lên bằng loại khác thì kho từ chối. Dung lượng không ký được
    // bằng presigned PUT nên service kiểm lại bằng `head` trước khi gắn ảnh vào xe.
    const uploadUrl = await getSignedUrl(
      this.client,
      new PutObjectCommand({ Bucket: this.config.bucket, Key: input.key, ContentType: input.contentType }),
      { expiresIn: input.expiresInSeconds, signableHeaders: new Set(["content-type"]) },
    );
    return { uploadUrl, expiresAt };
  }

  async head(key: string): Promise<StoredObject | null> {
    try {
      const result = await this.client.send(new HeadObjectCommand({ Bucket: this.config.bucket, Key: key }));
      return {
        sizeBytes: result.ContentLength ?? 0,
        contentType: result.ContentType ?? null,
        lastModified: result.LastModified ?? new Date(0),
      };
    } catch (error) {
      if (isNotFound(error)) {
        return null;
      }
      throw error;
    }
  }

  async readStart(key: string, length: number): Promise<Uint8Array> {
    const result = await this.client.send(
      new GetObjectCommand({ Bucket: this.config.bucket, Key: key, Range: `bytes=0-${length - 1}` }),
    );
    return result.Body ? result.Body.transformToByteArray() : new Uint8Array();
  }

  async delete(key: string): Promise<void> {
    await this.client.send(new DeleteObjectCommand({ Bucket: this.config.bucket, Key: key }));
  }

  async *list(prefix: string): AsyncIterable<{ key: string; lastModified: Date }> {
    let continuationToken: string | undefined;
    do {
      const page = await this.client.send(
        new ListObjectsV2Command({ Bucket: this.config.bucket, Prefix: prefix, ContinuationToken: continuationToken }),
      );
      for (const object of page.Contents ?? []) {
        if (object.Key) {
          yield { key: object.Key, lastModified: object.LastModified ?? new Date(0) };
        }
      }
      continuationToken = page.IsTruncated ? page.NextContinuationToken : undefined;
    } while (continuationToken);
  }

  publicUrl(key: string): string {
    return `${this.config.publicBaseUrl}/${key}`;
  }
}

function isNotFound(error: unknown): boolean {
  const candidate = error as { name?: string; $metadata?: { httpStatusCode?: number } } | null;
  return candidate?.name === "NotFound" || candidate?.$metadata?.httpStatusCode === 404;
}
