// Đăng ký nhà xe công khai (TASK-OPR-001, UC-10, BR-75, Figma "Đăng ký nhà xe" 01–06): dữ liệu form, mục còn
// thiếu, nhãn trạng thái và thông báo lỗi. Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { z } from "zod";

import { ApiError } from "../auth/api-client";

type Schemas = components["schemas"];

export type Application = Schemas["ApplicationResponseDto_Output"];
export type ApplicationStatus = Application["status"];
export type ApplicationDocument = Application["documents"][number];
export type DocumentType = ApplicationDocument["type"];
export type ApplicationUpdateInput = Schemas["ApplicationUpdateInputDto"];

export const MAX_DOCUMENT_BYTES = 10 * 1024 * 1024;
export const ACCEPTED_DOCUMENT_TYPES = ["application/pdf", "image/jpeg", "image/png"] as const;

/** Bộ giấy tờ bắt buộc v1 (OQ-19), theo thứ tự trên màn hình. */
export const DOCUMENT_TYPES: { type: DocumentType; label: string }[] = [
  { type: "BUSINESS_REGISTRATION", label: "Giấy chứng nhận đăng ký doanh nghiệp" },
  { type: "TRANSPORT_LICENSE", label: "Giấy phép kinh doanh vận tải" },
  { type: "REPRESENTATIVE_AUTHORIZATION", label: "Giấy tờ người đại diện hoặc giấy ủy quyền" }
];

/** Ngân hàng phổ biến cho ô chọn (tên hiển thị = giá trị lưu). Hồ sơ cũ lưu tên khác vẫn giữ được. */
export const BANKS = [
  "Vietcombank",
  "VietinBank",
  "BIDV",
  "Agribank",
  "Techcombank",
  "MB Bank",
  "ACB",
  "VPBank",
  "Sacombank",
  "TPBank",
  "HDBank",
  "VIB",
  "SHB",
  "SeABank",
  "OCB",
  "MSB",
  "Eximbank",
  "LPBank"
];

/** Bước của thanh tiến trình trên mọi trang đăng ký (Figma "Các bước"). */
export const REGISTER_STEPS = ["Đăng ký", "Xác minh email", "Hoàn thiện hồ sơ", "Chờ duyệt"] as const;

/** Form bước 1 (Figma 01). */
export const registerSchema = z.object({
  operatorName: z.string().trim().min(1, "Nhập tên nhà xe.").max(100, "Tên nhà xe tối đa 100 ký tự."),
  contactName: z.string().trim().min(1, "Nhập họ tên người liên hệ.").max(100, "Họ tên tối đa 100 ký tự."),
  contactEmail: z.string().trim().min(1, "Nhập email liên hệ.").pipe(z.email("Email liên hệ không hợp lệ.")),
  acceptTerms: z.boolean().refine((value) => value, "Cần đồng ý điều khoản để gửi đăng ký.")
});
export type RegisterValues = z.infer<typeof registerSchema>;

/** Form gửi lại link (Figma 04). */
export const resendSchema = z.object({
  contactEmail: z.string().trim().min(1, "Nhập email liên hệ.").pipe(z.email("Email liên hệ không hợp lệ.")),
  applicationCode: z
    .string()
    .trim()
    .transform((value) => value.toUpperCase())
    .pipe(z.string().regex(/^OA-\d{4}-\d{6}$/, "Mã hồ sơ có dạng OA-2026-043152."))
});
export type ResendValues = z.input<typeof resendSchema>;

const digits = (value: string) => value.replace(/[\s.-]/g, "");
const optionalDigits = (pattern: RegExp, message: string) =>
  z.string().refine((value) => value.trim() === "" || pattern.test(digits(value)), message);

/** Form hoàn thiện hồ sơ (Figma 03). Ô trống được phép khi lưu nháp; đủ hay chưa xét ở `missingFromForm`. */
export const applicationFormSchema = z.object({
  legalName: z.string().max(200, "Tên pháp nhân tối đa 200 ký tự."),
  taxCode: optionalDigits(/^(\d{10}|\d{13})$/, "Mã số thuế gồm 10 hoặc 13 chữ số."),
  hotline: optionalDigits(/^\+?\d{8,15}$/, "Hotline gồm 8–15 chữ số."),
  address: z.string().max(255, "Địa chỉ tối đa 255 ký tự."),
  displayName: z.string().max(100, "Tên hiển thị tối đa 100 ký tự."),
  description: z.string().max(1000, "Mô tả tối đa 1000 ký tự."),
  bankName: z.string(),
  /** Trống = giữ số đã lưu (API chỉ trả số đã che). */
  bankAccountNumber: optionalDigits(/^\d{6,20}$/, "Số tài khoản gồm 6–20 chữ số."),
  bankAccountHolder: z.string().max(100, "Tên chủ tài khoản tối đa 100 ký tự.")
});
export type ApplicationFormValues = z.infer<typeof applicationFormSchema>;

export function toFormValues(application: Application): ApplicationFormValues {
  return {
    legalName: application.legalName ?? "",
    taxCode: application.taxCode ?? "",
    hotline: application.hotline ?? "",
    address: application.address ?? "",
    displayName: application.displayName ?? "",
    description: application.description ?? "",
    bankName: application.bankName ?? "",
    bankAccountNumber: "",
    bankAccountHolder: application.bankAccountHolder ?? ""
  };
}

/** Giấy tờ ở form: đã gắn vào hồ sơ, hoặc vừa tải lên kho nhưng chưa lưu. */
export type FormDocument = { type: DocumentType; objectKey: string; fileName: string; uploadedAt: string | null };

export function toFormDocuments(application: Application): FormDocument[] {
  return application.documents.map((document) => ({
    type: document.type,
    objectKey: document.objectKey,
    fileName: document.fileName,
    uploadedAt: document.uploadedAt
  }));
}

/** Body `PUT …/current`. Số tài khoản để trống thì không gửi — API giữ số đã lưu. */
export function toUpdateInput(values: ApplicationFormValues, documents: readonly FormDocument[]): ApplicationUpdateInput {
  const text = (value: string) => value.trim() || null;
  const account = digits(values.bankAccountNumber);
  return {
    legalName: text(values.legalName),
    taxCode: text(values.taxCode),
    hotline: text(values.hotline),
    address: text(values.address),
    displayName: text(values.displayName),
    description: text(values.description),
    bankName: text(values.bankName),
    ...(account ? { bankAccountNumber: account } : {}),
    bankAccountHolder: text(values.bankAccountHolder),
    documents: documents.map(({ type, objectKey, fileName }) => ({ type, objectKey, fileName }))
  };
}

/** Bốn nhóm của khối "Tiến độ hồ sơ" (Figma 03). */
export type ProgressGroup = { label: string; done: boolean };

/**
 * Mục còn thiếu tính trên chính form (cập nhật ngay khi gõ). Số tài khoản trống mà hồ sơ đã có số thì coi là đủ.
 * Trả về mã giống API (`taxCode`, `document:TRANSPORT_LICENSE`…).
 */
export function missingFromForm(
  values: ApplicationFormValues,
  documents: readonly FormDocument[],
  hasSavedAccount: boolean
): string[] {
  const missing: string[] = [];
  for (const field of ["legalName", "taxCode", "hotline", "address", "displayName"] as const) {
    if (!values[field].trim()) {
      missing.push(field);
    }
  }
  const types = new Set(documents.map((document) => document.type));
  for (const { type } of DOCUMENT_TYPES) {
    if (!types.has(type)) {
      missing.push(`document:${type}`);
    }
  }
  if (!values.bankName.trim()) {
    missing.push("bankName");
  }
  if (!values.bankAccountNumber.trim() && !hasSavedAccount) {
    missing.push("bankAccountNumber");
  }
  if (!values.bankAccountHolder.trim()) {
    missing.push("bankAccountHolder");
  }
  return missing;
}

const MISSING_LABELS: Record<string, string> = {
  legalName: "tên pháp nhân",
  taxCode: "mã số thuế",
  hotline: "hotline",
  address: "địa chỉ trụ sở",
  displayName: "tên hiển thị",
  "document:BUSINESS_REGISTRATION": "giấy chứng nhận đăng ký doanh nghiệp",
  "document:TRANSPORT_LICENSE": "giấy phép kinh doanh vận tải",
  "document:REPRESENTATIVE_AUTHORIZATION": "giấy tờ người đại diện",
  bankName: "ngân hàng",
  bankAccountNumber: "số tài khoản",
  bankAccountHolder: "tên chủ tài khoản"
};

/** Các nhóm tiến độ và câu cảnh báo "Chưa gửi duyệt được: còn thiếu …" (Figma 03). */
export function progressOf(missing: readonly string[]): { groups: ProgressGroup[]; warning: string | null } {
  const has = (keys: string[]) => keys.some((key) => missing.includes(key));
  const documentGaps = missing.filter((key) => key.startsWith("document:")).length;
  const groups = [
    { label: "Thông tin doanh nghiệp", done: !has(["legalName", "taxCode", "hotline", "address"]) },
    { label: "Thông tin công khai", done: !has(["displayName"]) },
    {
      label: documentGaps > 0 ? `Giấy tờ KYC · thiếu ${documentGaps} giấy tờ` : "Giấy tờ KYC",
      done: documentGaps === 0
    },
    { label: "Tài khoản nhận tiền", done: !has(["bankName", "bankAccountNumber", "bankAccountHolder"]) }
  ];
  const labels = missing.map((key) => MISSING_LABELS[key] ?? key);
  return {
    groups,
    warning: labels.length > 0 ? `Chưa gửi duyệt được: còn thiếu ${labels.join(", ")}.` : null
  };
}

/** Lỗi tại tệp khi chọn giấy tờ; `null` = nhận được. */
export function documentFileProblem(file: { type: string; size: number }): string | null {
  if (!(ACCEPTED_DOCUMENT_TYPES as readonly string[]).includes(file.type)) {
    return "Định dạng không được hỗ trợ. Chọn PDF, JPEG hoặc PNG.";
  }
  if (file.size < 1 || file.size > MAX_DOCUMENT_BYTES) {
    return "Tệp vượt quá 10 MB. Hãy chọn tệp nhỏ hơn.";
  }
  return null;
}

/** `13/10 · 09:58` theo giờ Việt Nam (Figma dòng giấy tờ). */
export function formatShortDateTime(iso: string): string {
  const parts = new Intl.DateTimeFormat("vi-VN", {
    timeZone: "Asia/Ho_Chi_Minh",
    day: "2-digit",
    month: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false
  }).formatToParts(new Date(iso));
  const get = (type: Intl.DateTimeFormatPartTypes) => parts.find((part) => part.type === type)?.value ?? "";
  return `${get("day")}/${get("month")} · ${get("hour")}:${get("minute")}`;
}

/** `10:15 · 16/10/2026` theo giờ Việt Nam. */
export function formatTimeDate(iso: string): string {
  const parts = new Intl.DateTimeFormat("vi-VN", {
    timeZone: "Asia/Ho_Chi_Minh",
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false
  }).formatToParts(new Date(iso));
  const get = (type: Intl.DateTimeFormatPartTypes) => parts.find((part) => part.type === type)?.value ?? "";
  return `${get("hour")}:${get("minute")} · ${get("day")}/${get("month")}/${get("year")}`;
}

export const STATUS_LABELS: Record<ApplicationStatus, string> = {
  DRAFT: "Nháp",
  SUBMITTED: "Chờ duyệt",
  NEEDS_INFO: "Cần bổ sung",
  APPROVED: "Được duyệt",
  REJECTED: "Bị từ chối"
};

/** Link sai / hết hạn / bị thay / hồ sơ đã có kết quả — trang chuyển sang "Gửi lại link" (Figma 04). */
export function isLinkInvalid(error: unknown): boolean {
  return error instanceof ApiError && error.code === "OPERATOR_APPLICATION_LINK_INVALID";
}

/** Thông báo lỗi khi lưu / gửi duyệt / tải giấy tờ (mã lỗi API §7.3). */
export function describeApplicationError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "OPERATOR_APPLICATION_INVALID_STATE":
        return "Hồ sơ đã gửi duyệt hoặc đã có kết quả nên không sửa được nữa. Tải lại trang để xem trạng thái.";
      case "OPERATOR_APPLICATION_INCOMPLETE":
        return progressOf(error.reasons).warning ?? "Hồ sơ còn thiếu thông tin hoặc giấy tờ bắt buộc.";
      case "OPERATOR_APPLICATION_DOCUMENT_INVALID":
        return "Có giấy tờ không hợp lệ hoặc chưa tải lên xong. Hãy tải lại giấy tờ đó.";
      case "OPERATOR_APPLICATION_RATE_LIMITED":
        return "Bạn thao tác quá nhanh. Vui lòng thử lại sau ít phút.";
    }
    if (error.status === 503) {
      return "Hệ thống tạm thời chưa xử lý được. Vui lòng thử lại sau.";
    }
    if (error.status === 400) {
      return "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các ô đã nhập.";
    }
  }
  return "Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại.";
}
