import type { components } from "@vexenhanh/api-client";
import { formatDateTimeVi } from "../format";
import type { ComplaintDetailData, ComplaintListItem, ComplaintMessage, MyComplaintsData } from "./types";

type Schemas = components["schemas"];
export type SupportDetailData = Omit<ComplaintDetailData, "messages"> & {
  readonly bookingId?: string;
  readonly closed?: boolean;
  readonly messages: readonly (Omit<ComplaintMessage, "attachments"> & {
    readonly attachments?: readonly { readonly attachmentId?: string; readonly fileName: string; readonly fileSizeText: string; readonly fileUrl?: string }[];
  })[];
};
export type SupportData = Omit<MyComplaintsData, "selectedComplaint"> & { readonly selectedComplaint: SupportDetailData | null };
export type SupportAttachment = { readonly objectKey: string; readonly fileName: string };
const categoryNames = { PAYMENT_REFUND: "Thanh toán / hoàn tiền", SCHEDULE: "Lịch trình", SERVICE_QUALITY: "Chất lượng dịch vụ", TICKET_CHANGE: "Đổi vé", OTHER: "Khác" };

/** Giữ trạng thái xử lý thực tế bằng nhãn hiển thị của API. */
export function supportStatus(status: string): Pick<ComplaintListItem, "status" | "statusLabel" | "statusTone"> {
  if (status === "CLOSED") return { status: "closed", statusLabel: "Đã đóng", statusTone: "neutral" };
  if (status === "RESOLVED") return { status: "resolved", statusLabel: "Đã giải quyết", statusTone: "success" };
  if (status === "WAITING_CUSTOMER") return { status: "needs_info", statusLabel: "Chờ bạn bổ sung", statusTone: "warning" };
  const labels: Record<string, string> = { NEW: "Mới tiếp nhận", IN_PROGRESS: "Đang xử lý", WAITING_OPERATOR: "Chờ nhà xe", ESCALATED: "Đã chuyển cấp" };
  return { status: "processing", statusLabel: labels[status] ?? status, statusTone: "neutral" };
}

/** Ánh xạ danh sách tổng hợp mà không dùng dữ liệu khiếu nại mẫu. */
export function mapSupportList(item: Schemas["PassengerSupportPageDto_Output"]["items"][number]): ComplaintListItem {
  return { id: item.ticketId, code: item.ticketCode, title: item.subject, bookingCode: item.bookingCode,
    updatedAtText: formatDateTimeVi(item.updatedAt), ...supportStatus(item.status) };
}

/** Ánh xạ chi tiết, trao đổi và định danh tệp để xin URL xem khi người dùng bấm. */
export function mapSupportDetail(item: Schemas["TicketDetailDto_Output"]): SupportDetailData {
  const status = supportStatus(item.status);
  return { id: item.ticketId, bookingId: item.bookingId, code: item.ticketCode, title: item.subject,
    createdAtText: formatDateTimeVi(item.createdAt), statusLabel: status.statusLabel, statusTone: status.statusTone,
    bookingCode: item.bookingCode, routeText: `${item.bookingCode} · ${item.trip.routeName}`, category: categoryNames[item.category],
    closed: item.status === "CLOSED", steps: [],
    ...(item.status === "WAITING_CUSTOMER" ? { noticeWarningText: "Yêu cầu đang chờ bạn bổ sung thông tin." } : {}),
    messages: item.messages.map((message) => ({ id: message.messageId, senderName: message.authorName,
      senderRole: message.party === "PASSENGER" || message.party === "GUEST" ? "passenger" : message.party === "OPERATOR" ? "operator" : "platform",
      createdAtText: formatDateTimeVi(message.createdAt), content: message.body,
      attachments: message.attachments.map((file) => ({ attachmentId: file.attachmentId,
        fileName: file.fileName, fileSizeText: `${Math.ceil(file.sizeBytes / 1024)} KB` })) })) };
}
