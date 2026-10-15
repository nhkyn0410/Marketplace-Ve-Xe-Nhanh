import { OperatorApplicationDocumentType, OperatorApplicationStatus } from "../database/prisma.types";

/** Loại file giấy tờ KYC được nhận — bản scan PDF hoặc ảnh chụp. */
export const DOCUMENT_CONTENT_TYPES = ["application/pdf", "image/jpeg", "image/png"] as const;
export type DocumentContentType = (typeof DOCUMENT_CONTENT_TYPES)[number];
export const MAX_DOCUMENT_BYTES = 10 * 1024 * 1024;
/** Đủ byte đầu để nhận ra PDF / JPEG / PNG. */
export const DOCUMENT_SIGNATURE_BYTES = 8;

/** Bộ giấy tờ bắt buộc v1 (OQ-19), theo thứ tự hiển thị. */
export const REQUIRED_DOCUMENTS = [
  OperatorApplicationDocumentType.BUSINESS_REGISTRATION,
  OperatorApplicationDocumentType.TRANSPORT_LICENSE,
  OperatorApplicationDocumentType.REPRESENTATIVE_AUTHORIZATION,
] as const;

/** Chỉ hồ sơ nháp hoặc đang cần bổ sung mới sửa / gửi duyệt được (LLD §6.11 bước 3). */
export const EDITABLE_STATUSES: ReadonlySet<OperatorApplicationStatus> = new Set([
  OperatorApplicationStatus.DRAFT,
  OperatorApplicationStatus.NEEDS_INFO,
]);
/** Hồ sơ chưa có kết quả — còn xin lại link được. */
export const OPEN_STATUSES = [
  OperatorApplicationStatus.DRAFT,
  OperatorApplicationStatus.SUBMITTED,
  OperatorApplicationStatus.NEEDS_INFO,
] as const;

/** Hồ sơ Admin thấy ở hàng đợi duyệt: đã gửi duyệt ít nhất một lần (nháp chưa gửi không hiện). */
export const REVIEWABLE_STATUSES = [
  OperatorApplicationStatus.SUBMITTED,
  OperatorApplicationStatus.NEEDS_INFO,
  OperatorApplicationStatus.APPROVED,
  OperatorApplicationStatus.REJECTED,
] as const;

const EXTENSIONS: Record<DocumentContentType, string> = {
  "application/pdf": "pdf",
  "image/jpeg": "jpg",
  "image/png": "png",
};
const UUID = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}";

/** Mã hồ sơ người dùng thấy trong email và dùng để xin lại link: `OA-2026-043152`. */
export const APPLICATION_CODE_PATTERN = /^OA-\d{4}-\d{6}$/;

export function newApplicationCode(now: Date, random: () => number = Math.random): string {
  const digits = String(Math.floor(random() * 1_000_000)).padStart(6, "0");
  return `OA-${now.getUTCFullYear()}-${digits}`;
}

const startsWith = (bytes: Uint8Array, signature: number[]) =>
  signature.every((value, index) => bytes[index] === value);

/** Định dạng thật theo chữ ký file, không tin `Content-Type` hay đuôi file. `null` = không phải PDF / JPEG / PNG. */
export function detectDocumentType(bytes: Uint8Array): DocumentContentType | null {
  if (startsWith(bytes, [0x25, 0x50, 0x44, 0x46, 0x2d])) {
    return "application/pdf"; // %PDF-
  }
  if (startsWith(bytes, [0xff, 0xd8, 0xff])) {
    return "image/jpeg";
  }
  if (startsWith(bytes, [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a])) {
    return "image/png";
  }
  return null;
}

/** Tiền tố khóa của mọi giấy tờ thuộc một hồ sơ (kho private). */
export function documentPrefix(applicationId: string): string {
  return `operator-applications/${applicationId}/`;
}

/** Khóa object của một giấy tờ mới — do server sinh, không chứa tên file gốc. */
export function documentKey(applicationId: string, id: string, contentType: DocumentContentType): string {
  return `${documentPrefix(applicationId)}${id}.${EXTENSIONS[contentType]}`;
}

/** Loại file suy ra từ khóa nếu khóa đúng dạng server sinh cho đúng hồ sơ này; khóa lạ / hồ sơ khác → `null`. */
export function contentTypeOfDocumentKey(applicationId: string, objectKey: string): DocumentContentType | null {
  const prefix = documentPrefix(applicationId);
  if (!objectKey.startsWith(prefix)) {
    return null;
  }
  const match = new RegExp(`^${UUID}\\.(pdf|jpg|png)$`).exec(objectKey.slice(prefix.length));
  const entry = match && Object.entries(EXTENSIONS).find(([, extension]) => extension === match[1]);
  return (entry?.[0] as DocumentContentType | undefined) ?? null;
}

/** Số tài khoản chỉ hiện 4 số cuối (Security §9: tài khoản nhận tiền mask khi hiển thị). */
export function maskAccountNumber(accountNumber: string | null): string | null {
  return accountNumber ? `•••• ${accountNumber.slice(-4)}` : null;
}

/** Mục còn thiếu để gửi duyệt (UC-10 A1), theo thứ tự các khối trên màn hình. */
export type MissingItem =
  | "legalName"
  | "taxCode"
  | "hotline"
  | "address"
  | "displayName"
  | `document:${OperatorApplicationDocumentType}`
  | "bankName"
  | "bankAccountNumber"
  | "bankAccountHolder";

type CompletenessInput = {
  legalName: string | null;
  taxCode: string | null;
  hotline: string | null;
  address: string | null;
  displayName: string | null;
  bankName: string | null;
  bankAccountNumber: string | null;
  bankAccountHolder: string | null;
  documents: readonly { type: OperatorApplicationDocumentType }[];
};

export function missingItems(application: CompletenessInput): MissingItem[] {
  const missing: MissingItem[] = [];
  for (const field of ["legalName", "taxCode", "hotline", "address", "displayName"] as const) {
    if (!application[field]) {
      missing.push(field);
    }
  }
  const types = new Set(application.documents.map((document) => document.type));
  for (const type of REQUIRED_DOCUMENTS) {
    if (!types.has(type)) {
      missing.push(`document:${type}`);
    }
  }
  for (const field of ["bankName", "bankAccountNumber", "bankAccountHolder"] as const) {
    if (!application[field]) {
      missing.push(field);
    }
  }
  return missing;
}
