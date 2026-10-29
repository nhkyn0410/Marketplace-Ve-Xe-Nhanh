// Logic thuần của các màn giám sát Admin (tuyến, chuyến, chi tiết nhà xe / hành khách; tự thiết kế 28/10/2026, chờ duyệt):
// nhãn trạng thái, giờ VN, quãng đường, lấp đầy. Hàm thuần để test được.

type Tone = "success" | "warning" | "danger" | "neutral";

/** Trạng thái chuyến — cùng nhãn với Operator OS. */
export const TRIP_STATUS: Record<string, { label: string; tone: Tone }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  OPEN_FOR_SALE: { label: "Đang mở bán", tone: "success" },
  LOCKED: { label: "Tạm dừng bán", tone: "warning" },
  SOLD_OUT: { label: "Hết chỗ", tone: "neutral" },
  BOARDING: { label: "Đang đón khách", tone: "success" },
  DEPARTED: { label: "Đã khởi hành", tone: "neutral" },
  IN_PROGRESS: { label: "Đang chạy", tone: "success" },
  COMPLETED: { label: "Hoàn thành", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  INCIDENT: { label: "Có sự cố", tone: "danger" }
};

/** Thứ tự trong ô lọc trạng thái chuyến (vòng đời). */
export const TRIP_STATUS_ORDER = ["DRAFT", "OPEN_FOR_SALE", "LOCKED", "SOLD_OUT", "BOARDING", "DEPARTED", "IN_PROGRESS", "COMPLETED", "CANCELLED", "INCIDENT"];

export const ROUTE_STATUS: Record<string, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Đang dùng", tone: "success" },
  DRAFT: { label: "Nháp", tone: "warning" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

export const BOOKING_STATUS: Record<string, { label: string; tone: Tone }> = {
  PENDING_PAYMENT: { label: "Chờ thanh toán", tone: "warning" },
  PENDING_CONFIRMATION: { label: "Chờ xác nhận", tone: "warning" },
  PAID: { label: "Đã thanh toán", tone: "success" },
  CONFIRMED: { label: "Đã xác nhận", tone: "success" },
  PARTIALLY_CANCELLED: { label: "Hủy một phần", tone: "neutral" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  EXPIRED: { label: "Hết hạn", tone: "neutral" },
  REFUND_PENDING: { label: "Chờ hoàn tiền", tone: "warning" },
  REFUNDED: { label: "Đã hoàn tiền", tone: "neutral" },
  REFUND_FAILED: { label: "Hoàn tiền lỗi", tone: "danger" }
};

export const TICKET_STATUS: Record<string, { label: string; tone: Tone }> = {
  VALID: { label: "Hợp lệ", tone: "success" },
  CANCELLED: { label: "Đã hủy", tone: "danger" },
  CHECKED_IN: { label: "Đã lên xe", tone: "success" },
  NO_SHOW: { label: "Vắng mặt", tone: "warning" },
  USED: { label: "Đã đi", tone: "neutral" },
  REFUNDED: { label: "Đã hoàn", tone: "neutral" }
};

export const VEHICLE_STATUS: Record<string, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  MAINTENANCE: { label: "Bảo dưỡng", tone: "warning" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" }
};

export const STAFF_ROLE: Record<string, string> = {
  DRIVER: "Tài xế",
  TICKET_STAFF: "Soát vé",
  SUPPORT_STAFF: "Hỗ trợ",
  SALES_STAFF: "Bán vé"
};

export const CHANNEL_LABEL: Record<string, string> = { ONLINE: "Trực tuyến", COUNTER: "Tại quầy" };

/** Cách xếp danh sách tuyến; `revenue` chỉ hiện khi có quyền xem tiền. */
export const ROUTE_SORT_LABEL: Record<string, string> = {
  sold: "Vé bán nhiều nhất",
  revenue: "Doanh thu vé cao nhất",
  trips: "Nhiều chuyến nhất",
  fill: "Lấp đầy cao nhất",
  name: "Tên tuyến A–Z"
};

const VN_OFFSET_MS = 7 * 3_600_000;
const pad = (value: number) => String(value).padStart(2, "0");
const COUNT = new Intl.NumberFormat("vi-VN");
const PERCENT = new Intl.NumberFormat("vi-VN", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const KM = new Intl.NumberFormat("vi-VN", { maximumFractionDigits: 0 });

/** `06:30 · 28/10/2026` theo giờ Việt Nam. */
export function tripTime(iso: string): string {
  const at = new Date(new Date(iso).getTime() + VN_OFFSET_MS);
  return `${pad(at.getUTCHours())}:${pad(at.getUTCMinutes())} · ${pad(at.getUTCDate())}/${pad(at.getUTCMonth() + 1)}/${at.getUTCFullYear()}`;
}

/** `28/10/2026` cho chuỗi ngày `YYYY-MM-DD`. */
export function dayLabel(date: string): string {
  return `${date.slice(8, 10)}/${date.slice(5, 7)}/${date.slice(0, 4)}`;
}

/** `312 km`; dưới 1 km → `850 m`. */
export function distanceLabel(meters: number): string {
  return meters < 1000 ? `${meters} m` : `${KM.format(meters / 1000)} km`;
}

/** `7 giờ 30 phút` / `45 phút`. */
export function durationLabel(seconds: number): string {
  const minutes = Math.round(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const rest = minutes % 60;
  if (hours === 0) {
    return `${rest} phút`;
  }
  return rest === 0 ? `${hours} giờ` : `${hours} giờ ${rest} phút`;
}

/** `12 / 40` kèm phần trăm lấp đầy (`30,0%`); không có chỗ → `—`. */
export function fillLabel(sold: number, seats: number): string {
  return seats === 0 ? "—" : `${PERCENT.format((sold / seats) * 100)}%`;
}

export function count(value: number): string {
  return COUNT.format(value);
}

/** Điểm đánh giá `4,6 (12)`; chưa có → `Chưa có`. */
export function ratingLabel(average: number | null, reviews: number): string {
  return average === null ? "Chưa có" : `${average.toLocaleString("vi-VN", { minimumFractionDigits: 1, maximumFractionDigits: 1 })} (${COUNT.format(reviews)})`;
}

/** Tỉnh đầu → tỉnh cuối của tuyến; thiếu tỉnh → `—`. */
export function provincePair(origin: { name: string } | null, destination: { name: string } | null): string {
  return origin && destination ? `${shortProvince(origin.name)} → ${shortProvince(destination.name)}` : "—";
}

/** "Thành phố Hồ Chí Minh" → "TP. Hồ Chí Minh", "Tỉnh Lâm Đồng" → "Lâm Đồng". */
export function shortProvince(name: string): string {
  if (name.startsWith("Thành phố ")) {
    return `TP. ${name.slice("Thành phố ".length)}`;
  }
  return name.startsWith("Tỉnh ") ? name.slice("Tỉnh ".length) : name;
}
