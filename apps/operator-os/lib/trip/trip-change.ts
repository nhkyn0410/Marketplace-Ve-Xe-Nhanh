// Logic thuần của đổi / hủy chuyến đã bán vé (TASK-TRN-008, FR-OPS-11..12, BR-10/12/20): dựng body đổi chuyến, nhãn lịch sử,
// câu tóm tắt khi hủy, đọc lỗi của máy chủ.
import { ApiError } from "../auth/api-client";
import { formatVnd } from "../fare/fare-format";
import type { Trip, TripChange, TripChangeInput, TripSales } from "./trip-api";
import { formatDay, formatTime } from "./trip-format";

export const CHANGE_REASON_MAX = 500;

/** Điểm thay thế cho một thứ tự dừng (đã chọn trong bảng chọn điểm). */
export type StopReplacement = { catalogStopPointId: string | null; stopPointId: string | null; name: string };

/** Body đổi chuyến từ giá trị đang nhập: giờ (ISO có múi giờ), xe, điểm từng thứ tự (thay hoặc giữ), lý do. */
export function toChangeInput(
  trip: Pick<Trip, "stops">,
  values: { departureAt: string; arrivalAt: string; vehicleId: string; reason: string },
  replacements: ReadonlyMap<number, StopReplacement>
): TripChangeInput {
  return {
    departureAt: values.departureAt,
    arrivalAt: values.arrivalAt,
    stopTimes: null,
    vehicleId: values.vehicleId,
    stops: trip.stops.map((stop) => {
      const next = replacements.get(stop.sequence);
      return {
        sequence: stop.sequence,
        catalogStopPointId: next ? next.catalogStopPointId : stop.catalogStopPointId,
        stopPointId: next ? next.stopPointId : stop.stopPointId
      };
    }),
    reason: values.reason.trim()
  };
}

const KIND_LABEL: Record<TripChange["kinds"][number], string> = {
  SCHEDULE: "Đổi giờ",
  VEHICLE: "Đổi xe",
  STOP: "Đổi điểm dừng",
  CANCEL: "Hủy chuyến"
};

/** `["SCHEDULE", "VEHICLE"]` → `Đổi giờ · Đổi xe`. */
export function changeKindLabel(kinds: TripChange["kinds"]): string {
  return kinds.map((kind) => KIND_LABEL[kind]).join(" · ");
}

const moment = (iso: string) => `${formatTime(iso)} ${formatDay(iso)}`;

/** Các dòng mô tả một lần đổi (giờ, xe, điểm) cho mục Lịch sử thay đổi. */
export function changeLines(change: Pick<TripChange, "kinds" | "before" | "after">): string[] {
  const { before, after } = change;
  if (change.kinds.includes("CANCEL")) {
    return [`Chuyến ${moment(before.departureAt)} đã hủy.`];
  }
  const lines: string[] = [];
  if (before.departureAt !== after.departureAt) lines.push(`Khởi hành: ${moment(before.departureAt)} → ${moment(after.departureAt)}`);
  if (before.arrivalAt !== after.arrivalAt) lines.push(`Đến: ${moment(before.arrivalAt)} → ${moment(after.arrivalAt)}`);
  if (before.vehiclePlateNumber !== after.vehiclePlateNumber) lines.push(`Xe: ${before.vehiclePlateNumber ?? "chưa gắn"} → ${after.vehiclePlateNumber ?? "chưa gắn"}`);
  for (const stop of after.stops) {
    const old = before.stops.find((item) => item.sequence === stop.sequence);
    if (old && old.name !== stop.name) lines.push(`Điểm ${stop.sequence}: ${old.name} → ${stop.name}`);
  }
  return lines;
}

/** Câu ảnh hưởng hiện trên form đổi chuyến / hộp thoại hủy. */
export function impactLabel(sales: Pick<TripSales, "activeBookings" | "soldSeats">): string {
  return sales.activeBookings === 0
    ? "Chuyến chưa có vé — không khách nào bị ảnh hưởng."
    : `${sales.activeBookings} đơn (${sales.soldSeats} vé) sẽ nhận thông báo thay đổi qua email.`;
}

/** Tóm tắt khi hủy chuyến: có vé thì nêu số hoàn 100% và số đơn chờ thanh toán bị hủy. */
export function cancelSummary(sales: Pick<TripSales, "activeBookings" | "soldSeats" | "pendingBookings" | "refundOnCancel">): string | null {
  if (sales.activeBookings === 0 && sales.pendingBookings === 0) {
    return null;
  }
  const parts: string[] = [];
  if (sales.activeBookings > 0) {
    parts.push(`${sales.soldSeats} vé của ${sales.activeBookings} đơn sẽ bị hủy và hoàn toàn bộ ${formatVnd(sales.refundOnCancel)} cho khách`);
  }
  if (sales.pendingBookings > 0) {
    parts.push(`${sales.pendingBookings} đơn đang chờ thanh toán sẽ bị hủy (khách không bị trừ tiền)`);
  }
  return `${parts.join("; ")}. Mọi khách bị ảnh hưởng nhận thông báo kèm lý do.`;
}

/** Lỗi khi lưu thay đổi chuyến → câu báo (kèm mã chỗ khi xe mới thiếu chỗ đã bán). */
export function describeTripChangeError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "TRIP_CHANGE_EMPTY":
        return "Chưa có thay đổi nào so với lịch chạy hiện tại.";
      case "TRIP_CHANGE_NOT_ALLOWED":
        return error.message || "Chuyến không đổi được ở trạng thái hiện tại.";
      case "TRIP_SEATS_UNMAPPABLE":
        return `Xe mới không có đúng chỗ (cùng mã, cùng loại) cho ${error.reasons.join(", ")}. Chọn xe khác.`;
      case "TRIP_STOPS_INVALID":
        return error.message || "Điểm dừng mới không dùng được.";
      case "VEHICLE_SCHEDULE_CONFLICT":
        return "Xe này đã có chuyến khác chồng giờ. Chọn xe khác hoặc đổi giờ.";
      case "VEHICLE_UNAVAILABLE":
        return "Xe không dùng được (ngừng hoạt động hoặc chưa có sơ đồ ghế).";
      case "TRIP_NOT_FOUND":
        return "Chuyến không còn tồn tại. Vui lòng quay lại danh sách.";
      case "SERVICE_UNAVAILABLE":
        return "Máy chủ đang bận nên chuyến chưa đổi. Vui lòng thử lại.";
    }
    if (error.status === 400) {
      return "Thông tin chưa hợp lệ: kiểm tra giờ khởi hành ở tương lai, giờ đến sau giờ đi và lý do 3–500 ký tự.";
    }
  }
  return "Chưa lưu được thay đổi. Vui lòng kiểm tra kết nối và thử lại.";
}
