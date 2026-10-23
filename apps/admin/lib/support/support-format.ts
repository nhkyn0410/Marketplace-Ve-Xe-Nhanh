// Logic thuần của màn Khiếu nại & tranh chấp + Kiểm duyệt đánh giá (Figma ADM-09a–e, ADM-10a; TASK-TRUST-001): nhãn trạng thái,
// danh mục, mức ưu tiên, bên, tín hiệu đánh giá, câu lỗi.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

import type { CaseParty, DisputeEvent, DisputeStatus, ReviewSignal, ReviewStatus, SupportCategory, SupportHandler, SupportPriority, SupportStatus } from "./support-api";

export type Tone = "success" | "warning" | "danger" | "neutral";

export const TICKET_STATUS: Record<SupportStatus, { label: string; tone: Tone }> = {
  NEW: { label: "Mới", tone: "warning" },
  IN_PROGRESS: { label: "Đang xử lý", tone: "neutral" },
  WAITING_OPERATOR: { label: "Chờ nhà xe", tone: "warning" },
  WAITING_CUSTOMER: { label: "Chờ khách bổ sung", tone: "neutral" },
  ESCALATED: { label: "Đã chuyển tranh chấp", tone: "danger" },
  RESOLVED: { label: "Đã giải quyết", tone: "success" },
  CLOSED: { label: "Đã đóng", tone: "neutral" }
};
export const TICKET_STATUS_ORDER: SupportStatus[] = ["NEW", "IN_PROGRESS", "WAITING_OPERATOR", "WAITING_CUSTOMER", "ESCALATED", "RESOLVED", "CLOSED"];

export const CATEGORY_LABEL: Record<SupportCategory, string> = {
  PAYMENT_REFUND: "Thanh toán / hoàn tiền",
  SCHEDULE: "Giờ chạy / lịch trình",
  SERVICE_QUALITY: "Chất lượng dịch vụ",
  TICKET_CHANGE: "Đổi vé / thông tin vé",
  OTHER: "Khác"
};
export const CATEGORY_ORDER: SupportCategory[] = ["PAYMENT_REFUND", "SCHEDULE", "SERVICE_QUALITY", "TICKET_CHANGE", "OTHER"];

export const PRIORITY_LABEL: Record<SupportPriority, string> = { LOW: "Thấp", MEDIUM: "Trung bình", HIGH: "Cao", URGENT: "Khẩn cấp" };
export const PRIORITY_ORDER: SupportPriority[] = ["LOW", "MEDIUM", "HIGH", "URGENT"];

export const HANDLER_LABEL: Record<SupportHandler, string> = { PLATFORM: "Vé Xe Nhanh", OPERATOR: "Nhà xe" };

export const PARTY_LABEL: Record<CaseParty, string> = { PASSENGER: "Hành khách", GUEST: "Khách vãng lai", OPERATOR: "Nhà xe", PLATFORM: "Vé Xe Nhanh", SYSTEM: "Hệ thống" };

export const DISPUTE_STATUS: Record<DisputeStatus, { label: string; tone: Tone }> = {
  OPEN: { label: "Mở", tone: "warning" },
  WAITING_USER_EVIDENCE: { label: "Chờ minh chứng của khách", tone: "danger" },
  WAITING_OPERATOR_RESPONSE: { label: "Chờ nhà xe phản hồi", tone: "warning" },
  UNDER_REVIEW: { label: "Đang xem xét", tone: "neutral" },
  ESCALATED: { label: "Đã leo thang", tone: "danger" },
  RESOLVED_REFUND: { label: "Đã quyết định · hoàn tiền", tone: "success" },
  RESOLVED_NO_REFUND: { label: "Đã quyết định · không hoàn", tone: "success" },
  CLOSED: { label: "Đã đóng", tone: "neutral" }
};
export const DISPUTE_STATUS_ORDER: DisputeStatus[] = [
  "OPEN",
  "WAITING_USER_EVIDENCE",
  "WAITING_OPERATOR_RESPONSE",
  "UNDER_REVIEW",
  "ESCALATED",
  "RESOLVED_REFUND",
  "RESOLVED_NO_REFUND",
  "CLOSED"
];
/** Còn mở (chưa có quyết định) — mới được yêu cầu minh chứng / ra quyết định. */
export const OPEN_DISPUTE: DisputeStatus[] = ["OPEN", "WAITING_USER_EVIDENCE", "WAITING_OPERATOR_RESPONSE", "UNDER_REVIEW", "ESCALATED"];

export const REVIEW_STATUS: Record<ReviewStatus, { label: string; tone: Tone }> = {
  VISIBLE: { label: "Đang hiển thị", tone: "neutral" },
  HELD: { label: "Giữ chờ", tone: "warning" },
  HIDDEN: { label: "Đã ẩn", tone: "danger" }
};

export const SIGNAL: Record<ReviewSignal, { label: string; tone: Tone }> = {
  SPAM: { label: "Nghi quảng cáo / spam", tone: "danger" },
  OPERATOR_REPORTED: { label: "Nhà xe báo cáo", tone: "warning" },
  DISPUTED: { label: "Đang có tranh chấp", tone: "warning" },
  REPEATED: { label: "Nội dung lặp", tone: "neutral" }
};

const VN_OFFSET_MS = 7 * 3_600_000;
const pad = (value: number) => String(value).padStart(2, "0");

/** `13/10 · 08:15` (giờ VN). */
export function shortMoment(iso: string): string {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return `${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)} · ${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())}`;
}

/** `08:15 · 13/10/2026` (giờ VN). */
export function fullMoment(iso: string): string {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return `${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())} · ${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)}/${at.getUTCFullYear()}`;
}

/** Mã đặt vé hiển thị `VXN-8F3K2Q`. */
export function displayBookingCode(code: string): string {
  return code.replace(/^VXN/, "VXN-");
}

/** Chính sách hủy lưu lúc đặt: `Trước 24 giờ: 90% · sau đó: 0%`. */
export function policyLabel(tiers: { minHoursBefore: number; refundPercent: number }[]): string {
  if (tiers.length === 0) {
    return "Không có";
  }
  return [...tiers]
    .sort((a, b) => b.minHoursBefore - a.minHoursBefore)
    .map((tier) => (tier.minHoursBefore > 0 ? `Trước ${tier.minHoursBefore} giờ: ${tier.refundPercent}%` : `sau đó: ${tier.refundPercent}%`))
    .join(" · ");
}

/** Dòng lịch sử tranh chấp: tiêu đề + mô tả (Figma ADM-09d "Lịch sử trạng thái"). */
export function eventLines(event: DisputeEvent): { title: string; detail: string } {
  if (event.kind === "REQUEST") {
    const target = event.target === "OPERATOR" ? "nhà xe" : "khách";
    return { title: `Yêu cầu minh chứng của ${target}`, detail: [event.body, event.dueAt ? `hạn ${shortMoment(event.dueAt)}` : null, event.actorName].filter(Boolean).join(" · ") };
  }
  if (event.kind === "EVIDENCE") {
    return { title: `${PARTY_LABEL[event.party]} gửi minh chứng`, detail: [event.body, event.actorName].filter(Boolean).join(" · ") };
  }
  return { title: event.toStatus ? DISPUTE_STATUS[event.toStatus].label : "Cập nhật", detail: [event.body, event.actorName].filter(Boolean).join(" · ") };
}

/** Giá trị mặc định ô hạn phản hồi: 48 giờ tới, dạng `datetime-local` theo giờ VN. */
export function defaultDue(now: number = Date.now()): string {
  return new Date(now + 48 * 3_600_000 + VN_OFFSET_MS).toISOString().slice(0, 16);
}

/** `datetime-local` (giờ VN) → ISO có múi giờ. */
export function dueToIso(local: string): string {
  return `${local}:00+07:00`;
}

export type CaseError = { message: string; field?: "identity"; refresh?: boolean };

/** Câu lỗi cho thao tác khiếu nại / tranh chấp / đánh giá. */
export function describeCaseError(error: unknown): CaseError {
  const identity = describeReauthError(error);
  if (identity) {
    return { message: identity, field: "identity" };
  }
  if (error instanceof ApiError) {
    switch (error.code) {
      case "SUPPORT_STATE_INVALID":
      case "DISPUTE_STATE_INVALID":
        return { message: `${error.message} Tải lại để xem trạng thái mới.`, refresh: true };
      case "DISPUTE_REFUND_INVALID":
      case "SUPPORT_ATTACHMENT_INVALID":
      case "SUPPORT_ASSIGNEE_INVALID":
        return { message: error.message };
      case "SUPPORT_TICKET_NOT_FOUND":
      case "DISPUTE_NOT_FOUND":
      case "REVIEW_NOT_FOUND":
        return { message: "Không tìm thấy hồ sơ. Tải lại trang.", refresh: true };
    }
    if (error.status === 400) {
      return { message: "Kiểm tra lại các ô đã nhập (lý do 3–500 ký tự)." };
    }
    if (error.status === 503) {
      return { message: "Chưa ghi được nhật ký / chưa xử lý được tệp nên chưa thực hiện. Vui lòng thử lại." };
    }
  }
  return { message: "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại." };
}
