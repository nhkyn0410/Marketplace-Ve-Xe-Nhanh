// Chữ hiển thị cho màn Nhà xe & KYC (Figma ADM-02a…02d). Hàm thuần để test được. Giờ hiển thị theo giờ Việt
// Nam (UTC+7, không đổi giờ mùa); API trả ISO 8601.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { ApplicationStatus, DocumentType, DuplicateField, HistoryEvent } from "./application-api";

type Tone = "success" | "warning" | "neutral" | "danger";

export const APPLICATION_STATUS: Record<ApplicationStatus, { label: string; tone: Tone }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  SUBMITTED: { label: "Chờ duyệt", tone: "warning" },
  NEEDS_INFO: { label: "Cần bổ sung", tone: "neutral" },
  APPROVED: { label: "Đã duyệt", tone: "success" },
  REJECTED: { label: "Bị từ chối", tone: "danger" }
};

/** Trạng thái trong ô lọc hàng đợi (nháp chưa gửi không hiện với Admin). */
export const STATUS_FILTER_ORDER: ApplicationStatus[] = ["SUBMITTED", "NEEDS_INFO", "APPROVED", "REJECTED"];

export const DOCUMENT_LABELS: Record<DocumentType, string> = {
  BUSINESS_REGISTRATION: "Giấy chứng nhận đăng ký doanh nghiệp",
  TRANSPORT_LICENSE: "Giấy phép kinh doanh vận tải",
  REPRESENTATIVE_AUTHORIZATION: "Giấy tờ người đại diện"
};

/** Nhãn cảnh báo ở cột "Cảnh báo" của hàng đợi. */
export const DUPLICATE_LABELS: Record<DuplicateField, string> = {
  CONTACT_EMAIL: "Trùng email liên hệ",
  TAX_CODE: "Trùng mã số thuế",
  BANK_ACCOUNT: "Trùng tài khoản nhận tiền"
};

/** Mốc lịch sử hồ sơ: tiêu đề + người làm (Figma "Lịch sử hồ sơ"). */
export const HISTORY_LABELS: Record<HistoryEvent["event"], { title: string; actor: string }> = {
  CREATED: { title: "Tạo hồ sơ nháp", actor: "Người nộp hồ sơ" },
  EMAIL_VERIFIED: { title: "Xác minh email", actor: "Mở link bảo mật lần đầu" },
  SUBMITTED: { title: "Gửi duyệt", actor: "Người nộp hồ sơ" },
  NEEDS_INFO: { title: "Yêu cầu bổ sung", actor: "Quản trị viên nền tảng" },
  REJECTED: { title: "Từ chối hồ sơ", actor: "Quản trị viên nền tảng" },
  APPROVED: { title: "Duyệt hồ sơ", actor: "Quản trị viên nền tảng" }
};

/** Khoảng "Thời điểm gửi" (Figma ADM-02a); giá trị = số ngày, `ALL` = mọi lúc. */
export const SUBMITTED_WINDOWS = [
  { value: "7", label: "7 ngày gần nhất" },
  { value: "30", label: "30 ngày gần nhất" },
  { value: "90", label: "90 ngày gần nhất" }
] as const;

/** Mốc bắt đầu của khoảng `days` ngày tính tới `now` (ISO, gửi lên `submittedSince`). */
export function submittedSince(days: number, now: number = Date.now()): string {
  return new Date(now - days * 86_400_000).toISOString();
}

const VN_OFFSET_MS = 7 * 3_600_000;

function vnParts(iso: string) {
  const shifted = new Date(new Date(iso).getTime() + VN_OFFSET_MS);
  const pad = (value: number) => String(value).padStart(2, "0");
  return {
    day: pad(shifted.getUTCDate()),
    month: pad(shifted.getUTCMonth() + 1),
    year: shifted.getUTCFullYear(),
    time: `${pad(shifted.getUTCHours())}:${pad(shifted.getUTCMinutes())}`
  };
}

/** `13/10 · 10:40` — cột "Gửi duyệt", lịch sử, giấy tờ. */
export function formatShortDateTime(iso: string): string {
  const { day, month, time } = vnParts(iso);
  return `${day}/${month} · ${time}`;
}

/** `10:40 · 13/10/2026` — dòng phụ dưới tiêu đề chi tiết hồ sơ. */
export function formatLongDateTime(iso: string): string {
  const { day, month, year, time } = vnParts(iso);
  return `${time} · ${day}/${month}/${year}`;
}

/** Mã số thuế dễ đọc: `0312 345 678`, chi nhánh `0312 345 678-001`. */
export function formatTaxCode(taxCode: string): string {
  const head = `${taxCode.slice(0, 4)} ${taxCode.slice(4, 7)} ${taxCode.slice(7, 10)}`;
  return taxCode.length > 10 ? `${head}-${taxCode.slice(10)}` : head;
}

/** Slug gợi ý từ tên hiển thị: bỏ dấu, chữ thường, chỉ chữ / số liền nhau (`Sao Việt Express` → `saovietexpress`). */
export function suggestSlug(name: string): string {
  return name
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/đ/gi, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]/g, "")
    .slice(0, 64);
}

/** Luật slug / tên đăng nhập như máy chủ (05 API §7.5) — báo tại ô trước khi gửi. */
export function slugError(slug: string): string | null {
  if (slug.length < 3 || slug.length > 64) {
    return "Mã nhà xe dài 3–64 ký tự.";
  }
  if (!/^[a-z0-9][a-z0-9-]*$/.test(slug)) {
    return "Chỉ dùng chữ thường không dấu, số, gạch ngang; bắt đầu bằng chữ hoặc số.";
  }
  if (slug === "platform") {
    return "Mã này đã được dành riêng, hãy chọn mã khác.";
  }
  return null;
}

export function usernameError(username: string): string | null {
  if (username.length < 3 || username.length > 64) {
    return "Tên đăng nhập dài 3–64 ký tự.";
  }
  if (!/^[A-Za-z0-9._-]+$/.test(username)) {
    return "Chỉ dùng chữ không dấu, số, dấu chấm, gạch dưới, gạch ngang.";
  }
  if (username.toLowerCase().startsWith("nv.")) {
    return "Tên đăng nhập chủ nhà xe không bắt đầu bằng “nv.” (dành cho nhân viên).";
  }
  return null;
}

export const REASON_MAX_LENGTH = 500;

export function reasonError(reason: string): string | null {
  const length = reason.trim().length;
  if (length < 3) {
    return "Nhập lý do (ít nhất 3 ký tự).";
  }
  return length > REASON_MAX_LENGTH ? `Lý do tối đa ${REASON_MAX_LENGTH} ký tự.` : null;
}

/** Lỗi của một thao tác duyệt: ô nào báo (`field`), có cần tải lại hồ sơ (`refresh`). */
export type DescribedError = {
  field: "identity" | "slug" | "form";
  message: string;
  refresh?: boolean;
};

export function describeReviewError(error: unknown): DescribedError {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity };
  }
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "OPERATOR_SLUG_CONFLICT":
      return { field: "slug", message: "Mã nhà xe đã được dùng. Hãy chọn mã khác." };
    case "OPERATOR_APPLICATION_INVALID_STATE":
      return {
        field: "form",
        message: "Hồ sơ không còn ở trạng thái Chờ duyệt (có thể vừa được xử lý). Đã tải lại hồ sơ.",
        refresh: true
      };
    case "OPERATOR_APPLICATION_NOT_FOUND":
      return { field: "form", message: "Không tìm thấy hồ sơ.", refresh: true };
    case "ACCOUNT_STATE_CONFLICT":
      return { field: "form", message: "Thông tin đăng nhập đã được gửi rồi. Đã tải lại hồ sơ.", refresh: true };
    case "ACCOUNT_TEMP_EMAIL_RATE_LIMITED":
      return { field: "form", message: "Đã gửi quá nhiều mật khẩu tạm. Vui lòng thử lại sau." };
    case "VALIDATION_FAILED":
      return { field: "form", message: "Thông tin chưa hợp lệ. Kiểm tra lại các ô rồi thử lại." };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}
