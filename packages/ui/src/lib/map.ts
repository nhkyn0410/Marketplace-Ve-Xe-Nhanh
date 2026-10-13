// Phần thuần của bản đồ web (ADR-027): địa chỉ bản đồ nền Goong và phép tính khung nhìn. Không phụ thuộc
// thư viện vẽ nên test được và dùng lại ở mọi app.

/** Một vị trí trên bản đồ, độ thập phân (WGS84). */
export type MapPoint = { latitude: number; longitude: number };

/** Khung chữ nhật theo kinh / vĩ độ. */
export type MapBounds = { west: number; south: number; east: number; north: number };

/**
 * Khung nhìn mặc định: toàn lãnh thổ Việt Nam, gồm cả quần đảo Hoàng Sa và Trường Sa (ADR-027 — bản đồ phải
 * hiển thị đủ hai quần đảo).
 */
export const VIETNAM_BOUNDS: MapBounds = { west: 102.1, south: 6.0, east: 117.9, north: 23.5 };

/**
 * Địa chỉ bản đồ nền của Goong với khóa Maptiles. Đây là nguồn bản đồ nền DUY NHẤT của sản phẩm: không có
 * khóa thì không vẽ bản đồ, không thay bằng nguồn khác (ADR-027, chủ quyền Hoàng Sa / Trường Sa).
 */
export function goongStyleUrl(mapKey: string): string {
  return `https://tiles.goong.io/assets/goong_map_web.json?api_key=${encodeURIComponent(mapKey)}`;
}

/** Tọa độ có nằm trong khoảng hợp lệ không (vĩ độ ±90, kinh độ ±180). */
export function isValidPoint(point: MapPoint): boolean {
  return (
    Number.isFinite(point.latitude) &&
    Number.isFinite(point.longitude) &&
    Math.abs(point.latitude) <= 90 &&
    Math.abs(point.longitude) <= 180
  );
}

/** Khung nhỏ nhất bao mọi điểm hợp lệ; `null` khi không có điểm nào. */
export function boundsOf(points: readonly MapPoint[]): MapBounds | null {
  const valid = points.filter(isValidPoint);
  if (valid.length === 0) {
    return null;
  }
  return {
    west: Math.min(...valid.map((point) => point.longitude)),
    south: Math.min(...valid.map((point) => point.latitude)),
    east: Math.max(...valid.map((point) => point.longitude)),
    north: Math.max(...valid.map((point) => point.latitude))
  };
}

/** Chuỗi nhận diện một dãy điểm theo đúng thứ tự — để biết dãy có đổi không mà không so từng phần tử. */
export function pointsKey(points: readonly MapPoint[]): string {
  return points.map((point) => `${point.latitude},${point.longitude}`).join(";");
}
