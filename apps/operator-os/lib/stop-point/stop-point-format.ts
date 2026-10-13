// Chữ hiển thị cho màn Điểm dừng (Figma "Nhà xe · Điểm dừng · TRN-013"). Hàm thuần để test được.
import type { StopPointProposalStatus, StopPointStatus, StopPointType } from "./stop-point-api";

type Tone = "success" | "warning" | "neutral" | "danger";

/** Tên loại điểm theo SRS BR-38. */
export const STOP_POINT_TYPE_LABELS: Record<StopPointType, string> = {
  BUS_STATION: "Bến xe",
  PICKUP_POINT: "Điểm dừng đón trả khách",
  OFFICE: "Văn phòng trung chuyển",
  REST_STOP: "Trạm dừng nghỉ"
};

/** Loại điểm nhà xe tự tạo được (BR-38). */
export const OWN_STOP_POINT_TYPES = ["OFFICE", "REST_STOP"] as const satisfies readonly StopPointType[];
/** Loại điểm có trong danh mục dùng chung, theo thứ tự ô lọc. */
export const SHARED_STOP_POINT_TYPES = ["BUS_STATION", "PICKUP_POINT", "REST_STOP"] as const satisfies readonly StopPointType[];
/** Loại điểm nhà xe được đề xuất bổ sung vào danh mục (BR-38). */
export const PROPOSAL_STOP_POINT_TYPES = ["BUS_STATION", "PICKUP_POINT"] as const satisfies readonly StopPointType[];

/** Nhãn + màu trạng thái điểm riêng; `SUSPENDED` do Platform đặt (BR-81). */
export const STOP_POINT_STATUS: Record<StopPointStatus, { label: string; tone: Tone }> = {
  ACTIVE: { label: "Hoạt động", tone: "success" },
  INACTIVE: { label: "Ngừng dùng", tone: "neutral" },
  SUSPENDED: { label: "Bị khóa", tone: "danger" }
};

/** Thứ tự trạng thái trong ô lọc của tab "Của nhà xe". */
export const STOP_POINT_STATUS_ORDER: StopPointStatus[] = ["ACTIVE", "INACTIVE", "SUSPENDED"];

/** Nhãn + màu trạng thái đề xuất. */
export const PROPOSAL_STATUS: Record<StopPointProposalStatus, { label: string; tone: Tone; hint: string }> = {
  PENDING: { label: "Chờ duyệt", tone: "warning", hint: "Đang chờ Platform" },
  APPROVED: { label: "Đã duyệt", tone: "success", hint: "Đã vào danh mục" },
  REJECTED: { label: "Bị từ chối", tone: "danger", hint: "" }
};

/** Thứ tự trạng thái trong ô lọc đề xuất. */
export const PROPOSAL_STATUS_ORDER: StopPointProposalStatus[] = ["PENDING", "APPROVED", "REJECTED"];

/** Cột "Tuyến đang dùng": `0` → "Chưa dùng". */
export function routeCountLabel(routeCount: number): string {
  return routeCount > 0 ? `${routeCount} tuyến` : "Chưa dùng";
}

const DATE_FORMAT = new Intl.DateTimeFormat("vi-VN", {
  timeZone: "Asia/Ho_Chi_Minh",
  day: "2-digit",
  month: "2-digit",
  year: "numeric"
});

/** Ngày theo giờ Việt Nam, dạng `02/10/2026`. */
export function formatDate(iso: string): string {
  return DATE_FORMAT.format(new Date(iso));
}

/** Tên tỉnh / thành của một điểm; tỉnh đã bị ngừng trong danh mục thì không còn tên để hiện. */
export function provinceLabel(names: ReadonlyMap<string, string>, provinceId: string): string {
  return names.get(provinceId) ?? "Tỉnh / thành đã ngừng dùng";
}
