import type { DocumentContentType } from "../operator-kyc/operator-application-format";

/** Tiền tố của mọi giấy tờ KYC nhà xe tải lên SAU khi được duyệt (kho private, ADR-018). */
export const KYC_DOCUMENT_ROOT = "operator-kyc/";

const EXTENSIONS: Record<DocumentContentType, string> = {
  "application/pdf": "pdf",
  "image/jpeg": "jpg",
  "image/png": "png",
};
const UUID = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

/** Khóa object của một giấy tờ mới — do server sinh dưới tiền tố của đúng nhà xe, không chứa tên file gốc. */
export function kycDocumentKey(operatorId: string, id: string, contentType: DocumentContentType): string {
  return `${KYC_DOCUMENT_ROOT}${operatorId}/${id}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy ra từ khóa nếu khóa đúng dạng server sinh cho đúng nhà xe này; khóa lạ / nhà xe khác → `null`. */
export function contentTypeOfKycKey(operatorId: string, objectKey: string): DocumentContentType | null {
  const prefix = `${KYC_DOCUMENT_ROOT}${operatorId}/`;
  if (!objectKey.startsWith(prefix)) {
    return null;
  }
  const match = new RegExp(`^${UUID}\\.(pdf|jpg|png)$`).exec(objectKey.slice(prefix.length));
  const entry = match && Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as DocumentContentType | undefined) ?? null;
}

/**
 * Tên chủ tài khoản theo cách ngân hàng in: viết hoa, không dấu, gộp khoảng trắng (Figma 1667:27586 "Viết hoa,
 * không dấu"). Người dùng gõ có dấu vẫn được — server tự bỏ dấu.
 */
export function normalizeAccountHolder(value: string): string {
  return value
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[đĐ]/g, "D")
    .toUpperCase()
    .replace(/\s+/g, " ")
    .trim();
}
