// Chữ hiển thị cho màn Phương tiện (Figma "Nhà xe · Phương tiện"). Hàm thuần để test được.
import type { SeatMapSummary, VehicleStatus, VehicleType } from "./vehicle-api";

const FORM_LABELS: Record<VehicleType["form"], string> = {
  SEATER: "Ghế ngồi",
  SLEEPER: "Giường nằm",
  CABIN: "Cabin"
};

const CLASS_LABELS: Record<VehicleType["class"], string> = {
  STANDARD: "Thường",
  LIMOUSINE: "Limousine"
};

const FORM_ORDER: VehicleType["form"][] = ["SEATER", "SLEEPER", "CABIN"];
const CLASS_ORDER: VehicleType["class"][] = ["STANDARD", "LIMOUSINE"];

/** Nhãn + màu của từng trạng thái vận hành; `INACTIVE` là "Ngừng dùng" (TRN-001 Q2). */
export const VEHICLE_STATUS: Record<VehicleStatus, { label: string; tone: "success" | "warning" | "neutral" }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  MAINTENANCE: { label: "Bảo dưỡng", tone: "warning" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

/** Thứ tự trạng thái trong ô lọc và ô chọn. */
export const VEHICLE_STATUS_ORDER: VehicleStatus[] = ["ACTIVE", "MAINTENANCE", "INACTIVE"];

/** Hiện biển số đã chuẩn hoá theo cách viết quen thuộc: `51B28912` → `51B-289.12`, `29B1234` → `29B-1234`. */
export function formatPlateNumber(plateNumber: string): string {
  const match = /^(\d{2}[A-Z]{1,2})(\d{4,5})$/.exec(plateNumber);
  if (!match) {
    return plateNumber;
  }
  const [, series, digits] = match as unknown as [string, string, string];
  return digits.length === 5 ? `${series}-${digits.slice(0, 3)}.${digits.slice(3)}` : `${series}-${digits}`;
}

/** Nhãn loại xe "Dạng chỗ · Hạng xe" (BR-77), vd `Giường nằm · Limousine`. */
export function vehicleTypeLabel(type: Pick<VehicleType, "form" | "class">): string {
  return `${FORM_LABELS[type.form]} · ${CLASS_LABELS[type.class]}`;
}

/** Sắp loại xe theo thiết kế: hạng thường trước, trong mỗi hạng là ghế ngồi → giường nằm → cabin. */
export function sortVehicleTypes<T extends Pick<VehicleType, "form" | "class">>(types: T[]): T[] {
  return [...types].sort(
    (a, b) =>
      CLASS_ORDER.indexOf(a.class) - CLASS_ORDER.indexOf(b.class) ||
      FORM_ORDER.indexOf(a.form) - FORM_ORDER.indexOf(b.form)
  );
}

/** Dòng tóm tắt sơ đồ ghế: số chỗ · sức chứa · số tầng (BR-78). */
export function seatMapSummaryLine(
  seatMap: Pick<SeatMapSummary, "seatCount" | "passengerCapacity" | "deckCount">
): string {
  return `${seatMap.seatCount} chỗ · ${seatMap.passengerCapacity} người · ${seatMap.deckCount} tầng`;
}

/**
 * Gói danh sách tiện ích vào hai dòng của cột "Tiện ích": dòng đầu tối đa hai tên, dòng sau là phần còn
 * lại. Từ tên thứ năm trở đi gộp thành số `more` ("+N tiện ích") — tách riêng để giao diện cắt bớt tên
 * dài mà không làm mất con số.
 */
export function amenitySummary(names: string[]): { first: string; second: string; more: number } {
  const [first, second, third, fourth] = names;
  if (first === undefined) {
    return { first: "Chưa có tiện ích", second: "", more: 0 };
  }
  if (second === undefined) {
    return { first, second: "Chưa có tiện ích khác", more: 0 };
  }
  if (third === undefined) {
    return { first, second, more: 0 };
  }
  const head = `${first} · ${second}`;
  if (fourth === undefined) {
    return { first: head, second: third, more: 0 };
  }
  return names.length === 4
    ? { first: head, second: `${third} · ${fourth}`, more: 0 }
    : { first: head, second: third, more: names.length - 3 };
}
