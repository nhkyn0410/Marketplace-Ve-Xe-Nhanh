/** DI token của kho object CÔNG KHAI (ảnh xe, logo… — ADR-018 bucket `public`). */
export const PUBLIC_STORAGE = Symbol("PUBLIC_STORAGE");
/**
 * DI token của kho object RIÊNG TƯ (giấy tờ KYC — ADR-018 bucket `private`). Giá trị `null` = chưa cấu hình (production
 * khi chưa chốt nơi lưu KYC, OQ-21): nơi dùng trả 503 thay vì lưu giấy tờ sai chỗ.
 */
export const PRIVATE_STORAGE = Symbol("PRIVATE_STORAGE");

export type UploadUrlInput = {
  /** Khóa object do server sinh — không bao giờ là tên file của người dùng. */
  key: string;
  contentType: string;
  sizeBytes: number;
  expiresInSeconds: number;
};

export type UploadTarget = { uploadUrl: string; expiresAt: Date };

export type StoredObject = { sizeBytes: number; contentType: string | null; lastModified: Date };

export type DownloadUrlInput = {
  key: string;
  expiresInSeconds: number;
  /** Tên file gợi ý cho trình duyệt khi lưu về; chỉ để hiển thị. */
  fileName: string;
};

export type DownloadTarget = { url: string; expiresAt: Date };

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
  /** Địa chỉ công khai của object (CDN). Chỉ có nghĩa với kho công khai. */
  publicUrl(key: string): string;
  /** URL có hạn để đọc một object của kho riêng tư (presigned `GET`). */
  createDownloadUrl(input: DownloadUrlInput): Promise<DownloadTarget>;
}
