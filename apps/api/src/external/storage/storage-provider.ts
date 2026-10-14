/** DI token của kho object CÔNG KHAI (ảnh xe, logo… — ADR-018 bucket `public`). Kho riêng tư (KYC) thêm sau. */
export const PUBLIC_STORAGE = Symbol("PUBLIC_STORAGE");

export type UploadUrlInput = {
  /** Khóa object do server sinh — không bao giờ là tên file của người dùng. */
  key: string;
  contentType: string;
  sizeBytes: number;
  expiresInSeconds: number;
};

export type UploadTarget = { uploadUrl: string; expiresAt: Date };

export type StoredObject = { sizeBytes: number; contentType: string | null; lastModified: Date };

/**
 * Cổng lưu object (ADR-006 / ADR-018): domain service chỉ biết interface này, không gọi SDK của nhà cung cấp.
 * Trình duyệt tải file THẲNG lên kho bằng URL có chữ ký; API không nhận byte của file.
 */
export interface StorageProvider {
  /** URL để `PUT` đúng một object, có hạn, ràng kèm `Content-Type`. */
  createUploadUrl(input: UploadUrlInput): Promise<UploadTarget>;
  /** Thông tin object; `null` nếu chưa tồn tại. */
  head(key: string): Promise<StoredObject | null>;
  /** `length` byte đầu của object — để kiểm chữ ký định dạng file. */
  readStart(key: string, length: number): Promise<Uint8Array>;
  /** Xóa object; object không tồn tại coi như đã xóa. */
  delete(key: string): Promise<void>;
  /** Liệt kê object theo tiền tố (job dọn object mồ côi). */
  list(prefix: string): AsyncIterable<{ key: string; lastModified: Date }>;
  /** Địa chỉ công khai của object (CDN). */
  publicUrl(key: string): string;
}
