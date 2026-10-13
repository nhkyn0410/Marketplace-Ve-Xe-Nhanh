// Chữ hiển thị cho màn Bảng giá (Figma "Nhóm · Nhà xe · Bảng giá"). Hàm thuần để test được.
// Tiền là số nguyên đồng (API §4): ở đây chỉ định dạng và so sánh, không có phép tính.
import { seatTypeInfo } from "../seat-map/seat-map-editor";
import { formatDay, formatTime } from "../trip/trip-format";
import type { SeatType } from "../vehicle/vehicle-api";
import type { FareRevision, FareRule, FareStatus } from "./fare-api";

/** Nhãn + màu trạng thái bảng giá. */
export const FARE_STATUS: Record<FareStatus, { label: string; tone: "success" | "neutral" }> = {
  ACTIVE: { label: "Đang áp dụng", tone: "success" },
  INACTIVE: { label: "Ngừng áp dụng", tone: "neutral" }
};

/** Thứ tự trạng thái trong ô lọc và ô chọn. */
export const FARE_STATUS_ORDER: FareStatus[] = ["ACTIVE", "INACTIVE"];

const VND = new Intl.NumberFormat("vi-VN");

/** Số tiền dạng `250.000 ₫`. */
export function formatVnd(amount: number): string {
  return `${VND.format(amount)} ₫`;
}

/** Cột "Khoảng giá mỗi chỗ": `250.000 ₫ – 760.000 ₫`, một giá nếu hai đầu bằng nhau, `—` khi chưa có quy tắc. */
export function priceRangeLabel(minPrice: number | null, maxPrice: number | null): string {
  if (minPrice === null || maxPrice === null) {
    return "—";
  }
  return minPrice === maxPrice ? formatVnd(minPrice) : `${formatVnd(minPrice)} – ${formatVnd(maxPrice)}`;
}

/** Cột "Quy tắc giá". */
export function ruleCountLabel(count: number): string {
  return count === 0 ? "Chưa có quy tắc" : `${count} quy tắc`;
}

/** Nhãn loại chỗ của một quy tắc; `null` = áp cho mọi loại chỗ. */
export function ruleSeatTypeLabel(seatType: SeatType | null): string {
  return seatType === null ? "Mọi loại chỗ" : seatTypeInfo(seatType).label;
}

/**
 * Nhãn loại xe của một quy tắc; `null` = áp cho mọi loại xe. `names` là nhãn loại xe theo id trong danh mục.
 * `unknownLabel` thay cho nhãn mặc định khi danh mục chưa tải xong / tải lỗi — lúc đó chưa kết luận được là loại
 * xe đã ngừng dùng.
 */
export function ruleVehicleTypeLabel(
  names: ReadonlyMap<string, string>,
  vehicleTypeId: string | null,
  unknownLabel = "Loại xe đã ngừng dùng"
): string {
  if (vehicleTypeId === null) {
    return "Mọi loại xe";
  }
  return names.get(vehicleTypeId) ?? unknownLabel;
}

/** Ngày giờ theo giờ Việt Nam: `20/01/2031 00:00`. */
export function formatMoment(iso: string): string {
  return `${formatDay(iso)} ${formatTime(iso)}`;
}

/**
 * Cột "Khung giờ khởi hành": quy tắc không có khung giờ là giá thường, áp cho mọi ngày; có khung giờ thì áp cho
 * chuyến khởi hành trong `[validFrom, validTo)`.
 */
export function ruleWindowLabel(rule: Pick<FareRule, "validFrom" | "validTo">): string {
  if (rule.validFrom === null || rule.validTo === null) {
    return "Mọi ngày";
  }
  return `${formatMoment(rule.validFrom)} – ${formatMoment(rule.validTo)}`;
}

const ruleKey = (rule: FareRule) => [rule.vehicleTypeId, rule.seatType, rule.validFrom, rule.validTo].join("|");

/** Tên gọi ngắn của một quy tắc trong dòng lịch sử: `giường đơn · Giường nằm · Limousine, 20/01/2031 00:00 – …`. */
function ruleNoun(rule: FareRule, names: ReadonlyMap<string, string>, unknownLabel?: string): string {
  const seat = rule.seatType === null ? "mọi loại chỗ" : seatTypeInfo(rule.seatType).noun;
  const vehicle =
    rule.vehicleTypeId === null ? "" : ` · ${ruleVehicleTypeLabel(names, rule.vehicleTypeId, unknownLabel)}`;
  const window = rule.validFrom === null ? "" : `, ${ruleWindowLabel(rule)}`;
  return `${seat}${vehicle}${window}`;
}

/**
 * Tóm tắt một dòng lịch sử giá (BR-40) từ bản chụp trước / sau: thay đổi đơn lẻ thì nêu rõ quy tắc và giá cũ →
 * giá mới; nhiều thay đổi thì đếm số quy tắc thêm / xóa / đổi giá.
 */
export function describeRevision(
  revision: Pick<FareRevision, "action" | "before" | "after">,
  names: ReadonlyMap<string, string>,
  unknownLabel?: string
): { title: string; detail: string } {
  const { before, after } = revision;
  if (revision.action === "fare.create" || before === null) {
    return { title: "Tạo bảng giá", detail: ruleCountLabel(after.rules.length) };
  }
  const previous = new Map(before.rules.map((rule) => [ruleKey(rule), rule]));
  const current = new Map(after.rules.map((rule) => [ruleKey(rule), rule]));
  const added = after.rules.filter((rule) => !previous.has(ruleKey(rule)));
  const removed = before.rules.filter((rule) => !current.has(ruleKey(rule)));
  const repriced = after.rules.filter((rule) => {
    const old = previous.get(ruleKey(rule));
    return old !== undefined && old.price !== rule.price;
  });
  const status =
    before.status === after.status ? "" : `${FARE_STATUS[before.status].label} → ${FARE_STATUS[after.status].label}`;
  const withStatus = (detail: string) => [detail, status].filter(Boolean).join(" · ");
  const changes = added.length + removed.length + repriced.length;

  if (changes === 0) {
    if (status) {
      return { title: "Đổi trạng thái", detail: status };
    }
    return { title: before.note === after.note ? "Lưu bảng giá" : "Sửa ghi chú", detail: "" };
  }
  if (changes === 1) {
    const [rule] = [...repriced, ...added, ...removed] as [FareRule];
    if (repriced.length === 1) {
      const old = previous.get(ruleKey(rule))!;
      return {
        title: `Sửa giá ${ruleNoun(rule, names, unknownLabel)}`,
        detail: withStatus(`${formatVnd(old.price)} → ${formatVnd(rule.price)}`)
      };
    }
    return {
      title: `${added.length === 1 ? "Thêm" : "Xóa"} quy tắc ${ruleNoun(rule, names, unknownLabel)}`,
      detail: withStatus(formatVnd(rule.price))
    };
  }
  const parts = [
    added.length > 0 ? `thêm ${added.length}` : "",
    removed.length > 0 ? `xóa ${removed.length}` : "",
    repriced.length > 0 ? `đổi giá ${repriced.length}` : ""
  ].filter(Boolean);
  return { title: "Sửa quy tắc giá", detail: withStatus(`${parts.join(" · ")} quy tắc`) };
}
