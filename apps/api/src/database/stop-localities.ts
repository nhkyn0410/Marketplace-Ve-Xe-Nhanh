import type { PrismaService } from "./prisma.service";

/** Đơn vị hành chính cũ chủ yếu đã nhập vào một phường mới (dòng nhiều nhất trong bảng tên cũ). */
export type WardLegacySource = {
  provinceName: string;
  legacyProvinceName: string | null;
  legacyDistrictName: string | null;
};

const CITY_PREFIX = "Thành phố ";

/** Tên tỉnh / thành mới gọn: "Thành phố Hồ Chí Minh" → "TP.HCM", "Tỉnh Lâm Đồng" → "Lâm Đồng". */
function shortProvince(name: string): string {
  const short = name.replace(/^(Thành phố|Tỉnh) /, "");
  return short === "Hồ Chí Minh" ? "TP.HCM" : short;
}

/**
 * Tên nơi quen thuộc của một điểm dừng (tự thiết kế 29/10/2026, chờ duyệt) — dùng ghép tên tuyến tự động và tên chặng:
 * - phường thuộc thành phố trực thuộc trung ương cũ (TP.HCM, Hà Nội, Đà Nẵng, Hải Phòng, Cần Thơ, Huế) → tên thành phố,
 *   không tách từng quận ("TP.HCM", kể cả TP Thủ Đức cũ);
 * - phường thuộc thành phố / thị xã / huyện cũ của tỉnh khác → tên đơn vị đó bỏ cấp hành chính ("Vũng Tàu", "Đà Lạt",
 *   "Gia Nghĩa", "Di Linh");
 * - không có dữ liệu tên cũ → tên tỉnh mới gọn.
 */
export function localityName(source: WardLegacySource): string {
  if (source.legacyProvinceName?.startsWith(CITY_PREFIX)) {
    return shortProvince(source.legacyProvinceName);
  }
  if (source.legacyDistrictName) {
    return source.legacyDistrictName.replace(/^(Thành phố|Thị xã|Huyện|Quận) /, "");
  }
  return shortProvince(source.provinceName);
}

/**
 * Tên nơi của các phường mới, theo đơn vị hành chính cũ đã nhập vào phường nhiều nhất (`legacy_administrative_mappings`;
 * ưu tiên dòng có quận / huyện). Đọc danh mục công khai nên chạy ở ngữ cảnh `system`. Phường không có → không có trong Map.
 */
export async function loadWardLocalities(
  prisma: Pick<PrismaService, "withSystem">,
  wardIds: readonly string[],
): Promise<Map<string, string>> {
  const ids = [...new Set(wardIds)];
  if (ids.length === 0) {
    return new Map();
  }
  const rows = await prisma.withSystem((tx) =>
    tx.$queryRaw<(WardLegacySource & { wardId: string })[]>`
      SELECT w.id AS "wardId", p.name AS "provinceName",
             best.legacy_province_name AS "legacyProvinceName", NULLIF(best.legacy_district_name, '') AS "legacyDistrictName"
      FROM wards w
      JOIN provinces p ON p.id = w.province_id
      LEFT JOIN LATERAL (
        SELECT m.legacy_province_name, m.legacy_district_name
        FROM legacy_administrative_mappings m
        WHERE m.ward_id = w.id
        GROUP BY m.legacy_province_name, m.legacy_district_name
        ORDER BY (m.legacy_district_name = ''), count(*) DESC, m.legacy_district_name
        LIMIT 1
      ) best ON TRUE
      WHERE w.id = ANY(${ids}::text[])`,
  );
  return new Map(rows.map(({ wardId, ...source }) => [wardId, localityName(source)]));
}
