// Logic thuần của màn Hỗ trợ (Figma "Nhà xe · Hỗ trợ" 01–03; TASK-TRUST-001): nhãn trạng thái, danh mục, dòng lịch sử, yêu cầu
// đang chờ nhà xe.
import type { DisputeDetail, DisputeEvent, DisputeStatus, SupportCategory, SupportStatus } from "./support-api";

type Tone = "success" | "warning" | "neutral" | "danger";

export const TICKET_STATUS: Record<SupportStatus, { label: string; tone: Tone }> = {
  NEW: { label: "Mới", tone: "warning" },
  IN_PROGRESS: { label: "Đang xử lý", tone: "neutral" },
  WAITING_OPERATOR: { label: "Chờ nhà xe phản hồi", tone: "warning" },
  WAITING_CUSTOMER: { label: "Chờ khách bổ sung", tone: "neutral" },
  ESCALATED: { label: "Đã chuyển tranh chấp", tone: "danger" },
  RESOLVED: { label: "Đã giải quyết", tone: "success" },
  CLOSED: { label: "Đã đóng", tone: "neutral" }
};

export const DISPUTE_STATUS: Record<DisputeStatus, { label: string; tone: Tone }> = {
  OPEN: { label: "Mở", tone: "warning" },
  WAITING_USER_EVIDENCE: { label: "Chờ minh chứng của khách", tone: "neutral" },
  WAITING_OPERATOR_RESPONSE: { label: "Chờ nhà xe phản hồi", tone: "danger" },
  UNDER_REVIEW: { label: "Đang xem xét", tone: "neutral" },
  ESCALATED: { label: "Đã leo thang", tone: "danger" },
  RESOLVED_REFUND: { label: "Đã quyết định · hoàn tiền", tone: "success" },
  RESOLVED_NO_REFUND: { label: "Đã quyết định · không hoàn", tone: "success" },
  CLOSED: { label: "Đã đóng", tone: "neutral" }
};

export const OPEN_DISPUTE: DisputeStatus[] = ["OPEN", "WAITING_USER_EVIDENCE", "WAITING_OPERATOR_RESPONSE", "UNDER_REVIEW", "ESCALATED"];

export const CATEGORY_LABEL: Record<SupportCategory, string> = {
  PAYMENT_REFUND: "Thanh toán / hoàn tiền",
  SCHEDULE: "Giờ chạy / lịch trình",
  SERVICE_QUALITY: "Chất lượng dịch vụ",
  TICKET_CHANGE: "Đổi vé / thông tin vé",
  OTHER: "Khác"
};

const VN_OFFSET_MS = 7 * 3_600_000;
const pad = (value: number) => String(value).padStart(2, "0");

/** `09:12 · 05/10/2026` (giờ VN). */
export function fullMoment(iso: string): string {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return `${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())} · ${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)}/${at.getUTCFullYear()}`;
}

/** `05/10/2026` (giờ VN). */
export function dayOf(iso: string): string {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return `${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)}/${at.getUTCFullYear()}`;
}

/** `06/10 · 14:30` (giờ VN). */
export function shortMoment(iso: string): string {
  const at = new Date(Date.parse(iso) + VN_OFFSET_MS);
  return `${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)} · ${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())}`;
}

export function displayBookingCode(code: string): string {
  return code.replace(/^VXN/, "VXN-");
}

/** Yêu cầu minh chứng đang chờ nhà xe (sự kiện yêu cầu gần nhất khi tranh chấp còn "Chờ nhà xe phản hồi"). */
export function pendingRequest(detail: Pick<DisputeDetail, "status" | "events">): DisputeEvent | null {
  if (detail.status !== "WAITING_OPERATOR_RESPONSE") {
    return null;
  }
  return [...detail.events].reverse().find((event) => event.kind === "REQUEST" && event.target === "OPERATOR") ?? null;
}

/** Dòng lịch sử tranh chấp phía nhà xe. */
export function eventLines(event: DisputeEvent): { title: string; detail: string } {
  if (event.kind === "REQUEST") {
    return { title: "Vé Xe Nhanh yêu cầu minh chứng", detail: [event.body, event.dueAt ? `hạn ${shortMoment(event.dueAt)}` : null].filter(Boolean).join(" · ") };
  }
  if (event.kind === "EVIDENCE") {
    return { title: "Nhà xe gửi giải trình", detail: event.body ?? "" };
  }
  return { title: event.toStatus ? DISPUTE_STATUS[event.toStatus].label : "Cập nhật", detail: event.body ?? "" };
}
