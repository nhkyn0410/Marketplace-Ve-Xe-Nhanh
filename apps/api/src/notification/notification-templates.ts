// Nội dung email thông báo (TASK-NSR-001, FR-NSR-01..05; TRN-008 FR-OPS-12). Hàm thuần: dữ liệu → tiêu đề + đoạn văn bản
// thuần (adapter tự escape). Giờ hiển thị theo giờ Việt Nam; tiền VND có dấu chấm ngăn cách.

/** Ảnh chụp lịch chạy của chuyến trong lịch sử đổi chuyến (TRN-008). */
export type TripScheduleSnapshot = {
  departureAt: string;
  arrivalAt: string;
  vehiclePlateNumber: string | null;
  stops: { sequence: number; name: string }[];
};

export type NotificationContent =
  | {
      kind: "BOOKING_CONFIRMED";
      bookingCode: string;
      routeName: string;
      departureAt: string;
      pickupName: string;
      dropoffName: string;
      tickets: { ticketCode: string; seatCode: string }[];
      total: number;
    }
  | { kind: "TICKETS_CANCELLED"; bookingCode: string; ticketCodes: string[]; refundAmount: number }
  | { kind: "REFUND_SUCCEEDED"; bookingCode: string; refundCode: string; amount: number; provider: string }
  | { kind: "TRIP_CHANGED"; bookingCode: string; routeName: string; before: TripScheduleSnapshot; after: TripScheduleSnapshot; reason: string }
  | { kind: "TRIP_CANCELLED"; bookingCode: string; routeName: string; departureAt: string; reason: string; refundAmount: number | null }
  | { kind: "MANUAL_REFUND"; operatorName: string; bookingCode: string; refundCode: string; amount: number; reference: string; reason: string };

export type RenderedNotification = { subject: string; title: string; lines: string[] };

const VND = new Intl.NumberFormat("vi-VN");
const money = (amount: number) => `${VND.format(amount)} ₫`;

/** `2026-10-16T15:30:00Z` → `22:30 ngày 16/10/2026` (giờ VN). */
export function vnMoment(iso: string): string {
  const [date, time] = new Date(Date.parse(iso) + 7 * 3_600_000).toISOString().split("T");
  return `${time!.slice(0, 5)} ngày ${date!.slice(8, 10)}/${date!.slice(5, 7)}/${date!.slice(0, 4)}`;
}

const LOOKUP = "Tra cứu đơn trên Vé Xe Nhanh bằng mã đặt vé và email / số điện thoại đã dùng khi đặt.";

/** Các dòng mô tả thay đổi lịch chạy (giờ, xe, điểm dừng). */
export function describeTripChange(before: TripScheduleSnapshot, after: TripScheduleSnapshot): string[] {
  const lines: string[] = [];
  if (before.departureAt !== after.departureAt) {
    lines.push(`Giờ khởi hành: ${vnMoment(before.departureAt)} → ${vnMoment(after.departureAt)}.`);
  }
  if (before.arrivalAt !== after.arrivalAt) {
    lines.push(`Giờ đến dự kiến: ${vnMoment(before.arrivalAt)} → ${vnMoment(after.arrivalAt)}.`);
  }
  if (before.vehiclePlateNumber !== after.vehiclePlateNumber) {
    lines.push(`Xe: ${before.vehiclePlateNumber ?? "chưa gắn"} → ${after.vehiclePlateNumber ?? "chưa gắn"}. Số ghế của bạn giữ nguyên.`);
  }
  for (const stop of after.stops) {
    const old = before.stops.find((item) => item.sequence === stop.sequence);
    if (old && old.name !== stop.name) {
      lines.push(`Điểm dừng số ${stop.sequence}: ${old.name} → ${stop.name}.`);
    }
  }
  return lines;
}

export function renderNotification(content: NotificationContent): RenderedNotification {
  switch (content.kind) {
    case "BOOKING_CONFIRMED":
      return {
        subject: `Vé xe ${content.bookingCode} — ${content.routeName}`,
        title: "Đặt vé thành công",
        lines: [
          `Mã đặt vé: ${content.bookingCode}. Tổng thanh toán: ${money(content.total)}.`,
          `Chuyến ${content.routeName}, khởi hành ${vnMoment(content.departureAt)}.`,
          `Điểm đón: ${content.pickupName}. Điểm trả: ${content.dropoffName}.`,
          `Vé: ${content.tickets.map((ticket) => `${ticket.ticketCode} (chỗ ${ticket.seatCode})`).join(", ")}.`,
          "Xuất trình mã QR của từng vé khi lên xe. " + LOOKUP,
        ],
      };
    case "TICKETS_CANCELLED":
      return {
        subject: `Đã hủy vé — đơn ${content.bookingCode}`,
        title: "Đã hủy vé",
        lines: [
          `Đã hủy ${content.ticketCodes.length} vé của đơn ${content.bookingCode}: ${content.ticketCodes.join(", ")}.`,
          content.refundAmount > 0
            ? `Số tiền hoàn theo chính sách lúc đặt: ${money(content.refundAmount)}. Tiền về tài khoản thanh toán sau khi cổng xử lý xong.`
            : "Theo chính sách lúc đặt, lần hủy này không được hoàn tiền.",
          LOOKUP,
        ],
      };
    case "REFUND_SUCCEEDED":
      return {
        subject: `Đã hoàn tiền — đơn ${content.bookingCode}`,
        title: "Hoàn tiền thành công",
        lines: [
          `Đã hoàn ${money(content.amount)} cho đơn ${content.bookingCode} (mã hoàn ${content.refundCode}) qua ${content.provider}.`,
          "Thời gian tiền về tài khoản tùy ngân hàng / ví của bạn.",
        ],
      };
    case "TRIP_CHANGED":
      return {
        subject: `Chuyến của đơn ${content.bookingCode} đã thay đổi`,
        title: "Nhà xe đã thay đổi chuyến của bạn",
        lines: [
          `Chuyến ${content.routeName} của đơn ${content.bookingCode} có thay đổi:`,
          ...describeTripChange(content.before, content.after),
          `Lý do của nhà xe: ${content.reason}`,
          "Không đồng ý với thay đổi, bạn có thể hủy vé theo chính sách hoặc gửi yêu cầu hỗ trợ. " + LOOKUP,
        ],
      };
    case "TRIP_CANCELLED":
      return {
        subject: `Chuyến của đơn ${content.bookingCode} đã bị hủy`,
        title: "Nhà xe đã hủy chuyến",
        lines: [
          `Chuyến ${content.routeName} khởi hành ${vnMoment(content.departureAt)} của đơn ${content.bookingCode} đã bị nhà xe hủy.`,
          `Lý do của nhà xe: ${content.reason}`,
          content.refundAmount === null
            ? "Đơn chưa thanh toán nên đã được hủy, bạn không bị trừ tiền."
            : `Bạn được hoàn toàn bộ ${money(content.refundAmount)}; tiền về tài khoản thanh toán sau khi cổng xử lý xong.`,
          LOOKUP,
        ],
      };
    case "MANUAL_REFUND":
      return {
        subject: `Vé Xe Nhanh đã hoàn tiền thủ công — đơn ${content.bookingCode}`,
        title: "Hoàn tiền thủ công cho khách",
        lines: [
          `Vé Xe Nhanh đã ghi nhận hoàn ${money(content.amount)} cho đơn ${content.bookingCode} (mã hoàn ${content.refundCode}) của ${content.operatorName}.`,
          `Mã tham chiếu: ${content.reference}. Lý do: ${content.reason}`,
          "Khoản hoàn được trừ khỏi số tiền chi trả cho nhà xe ở kỳ liên quan (xem mục Tài chính).",
        ],
      };
  }
}
