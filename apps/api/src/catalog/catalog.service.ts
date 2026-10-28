import { Inject, Injectable } from "@nestjs/common";
import { searchTextContains } from "../common/search-text";
import { PrismaService } from "../database/prisma.service";
import { CatalogStatus, StopPointType } from "../database/prisma.types";
import {
  loadFeaturedOperators,
  loadPopularRoutes,
} from "../database/public-highlights";
import {
  PUBLIC_STORAGE,
  type StorageProvider,
} from "../external/storage/storage-provider";
import { vndToJson } from "../fare/fare-pricing";
import type {
  AmenityListResponse,
  FeaturedOperatorListResponse,
  PlaceSuggestionListResponse,
  PlaceSuggestionQuery,
  PopularRouteListResponse,
  ProvinceListResponse,
  StopPointListQuery,
  StopPointListResponse,
  VehicleTypeListResponse,
  WardListResponse,
} from "./dto/catalog.dto";

const ACTIVE = CatalogStatus.ACTIVE;
/** Số ứng viên mỗi loại trước khi xếp hạng gợi ý địa điểm. */
const PLACE_CANDIDATES = 20;
const PLACE_KIND_ORDER = { PROVINCE: 0, WARD: 1, STOP_POINT: 2, LEGACY: 3 } as const;

type Place = PlaceSuggestionListResponse["items"][number];
type LegacyPlaceRow = {
  legacyProvinceName: string;
  legacyDistrictName: string;
  legacyWardName: string;
  provinceId: string;
  provinceName: string;
  wardId: string;
  wardName: string;
  labelSearch: string;
};

/** Tên khớp từ khoá từ đầu (0), từ đầu một từ (1), hay ở giữa (2) — so trên chuỗi đã bỏ dấu. */
function placeRank(searchText: string, needle: string): number {
  if (searchText.startsWith(needle)) {
    return 0;
  }
  return searchText.includes(` ${needle}`) ? 1 : 2;
}

/**
 * Đọc catalog chuẩn Platform cho API công khai (TASK-CAT-001). Chỉ trả item `ACTIVE`.
 * Đọc không cần ngữ cảnh RLS: bảng catalog có policy `public_read`; ghi thuộc ADM-001 (scope platform).
 */
@Injectable()
export class CatalogService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PUBLIC_STORAGE)
    private readonly storage: Pick<StorageProvider, "publicUrl">,
  ) {}

  /** Liệt kê tỉnh/thành đang hoạt động, theo mã. */
  async listProvinces(): Promise<ProvinceListResponse> {
    const items = await this.prisma.province.findMany({
      where: { status: ACTIVE },
      orderBy: { code: "asc" },
      select: { id: true, code: true, name: true },
    });
    return { items };
  }

  /** Liệt kê phường/xã đang hoạt động của một tỉnh, theo mã. */
  async listWards(provinceId: string): Promise<WardListResponse> {
    const items = await this.prisma.ward.findMany({
      // Tỉnh bị vô hiệu hoá thì ẩn luôn phường của nó (UC-24 bước 6).
      where: { provinceId, status: ACTIVE, province: { status: ACTIVE } },
      orderBy: { code: "asc" },
      select: { id: true, code: true, name: true, provinceId: true },
    });
    return { items };
  }

  /**
   * Một trang điểm đón/trả chuẩn đang hoạt động. Cursor = `id` cuối trang trước, lọc `id > cursor`
   * thay vì `cursor`+`skip` của Prisma: `skip: 1` bỏ nhầm một item thật nếu dòng cursor đã bị vô
   * hiệu hoá giữa hai lần gọi.
   */
  async listStopPoints(
    query: StopPointListQuery,
  ): Promise<StopPointListResponse> {
    const rows = await this.prisma.stopPointCatalog.findMany({
      where: {
        status: ACTIVE,
        // Phường/tỉnh bị vô hiệu hoá thì ẩn luôn điểm thuộc nó (UC-24 bước 6).
        ward: { status: ACTIVE, province: { status: ACTIVE } },
        provinceId: query.provinceId,
        wardId: query.wardId,
        type: query.type,
        // `search_text` do database sinh (chữ thường, bỏ dấu): gõ "ben xe" vẫn ra "Bến xe…".
        ...(query.q
          ? {
              searchText: {
                contains: await searchTextContains(this.prisma, query.q),
              },
            }
          : {}),
        ...(query.cursor ? { id: { gt: query.cursor } } : {}),
      },
      orderBy: { id: "asc" },
      take: query.limit + 1,
      select: {
        id: true,
        name: true,
        type: true,
        address: true,
        provinceId: true,
        wardId: true,
        latitude: true,
        longitude: true,
        description: true,
      },
    });
    const items = rows.slice(0, query.limit);
    const nextCursor =
      rows.length > query.limit ? (items.at(-1)?.id ?? null) : null;
    return { items, nextCursor };
  }

  /** Liệt kê loại phương tiện đang hoạt động, theo mã. */
  async listVehicleTypes(): Promise<VehicleTypeListResponse> {
    const items = await this.prisma.vehicleType.findMany({
      where: { status: ACTIVE },
      orderBy: { code: "asc" },
      select: {
        id: true,
        code: true,
        name: true,
        description: true,
        form: true,
        class: true,
      },
    });
    return { items };
  }

  /** Liệt kê tiện ích đang hoạt động, theo mã. */
  async listAmenities(): Promise<AmenityListResponse> {
    const items = await this.prisma.amenity.findMany({
      where: { status: ACTIVE },
      orderBy: { code: "asc" },
      select: { id: true, code: true, name: true },
    });
    return { items };
  }

  /** Tuyến phổ biến (cặp tỉnh) cho trang chủ, bán chạy trước. */
  async listPopularRoutes(
    limit: number,
    now = new Date(),
  ): Promise<PopularRouteListResponse> {
    const routes = await loadPopularRoutes(this.prisma, limit, now);
    return {
      items: routes.map((route) => ({
        ...route,
        minPrice: route.minPrice === null ? null : vndToJson(route.minPrice),
        nextDepartureAt: route.nextDepartureAt?.toISOString() ?? null,
      })),
    };
  }

  /** Nhà xe tiêu biểu cho trang chủ và tab "Theo nhà xe". */
  async listFeaturedOperators(
    limit: number,
    now = new Date(),
  ): Promise<FeaturedOperatorListResponse> {
    const operators = await loadFeaturedOperators(this.prisma, limit, now);
    return {
      items: operators.map(({ logoObjectKey, ...operator }) => ({
        ...operator,
        logoUrl: logoObjectKey ? this.storage.publicUrl(logoObjectKey) : null,
      })),
    };
  }

  /**
   * Gợi ý điểm đi / điểm đến cho ô tìm chuyến (tự thiết kế 27/10/2026, chờ duyệt): tỉnh, phường / xã mới, địa danh
   * dùng chung đang dùng và tên hành chính trước sáp nhập 2025 (`legacy_administrative_mappings`). So không dấu trên
   * `search_text`; tên cũ chỉ so với tên cấp nhỏ nhất của dòng (phường, không có thì huyện, rồi tỉnh) để gõ tên tỉnh
   * không kéo ra mọi phường cũ. Tên cũ cấp phường dẫn tới phường mới; cấp huyện / tỉnh dẫn tới tỉnh mới. Tên cũ trùng
   * hệt tên mới thì bỏ (đã có gợi ý mới).
   */
  async listPlaces(query: PlaceSuggestionQuery): Promise<PlaceSuggestionListResponse> {
    const contains = await searchTextContains(this.prisma, query.q);
    // Bỏ ký tự thoát LIKE để xếp hạng trên chuỗi thật.
    const needle = contains.replace(/\\(.)/g, "$1");
    if (!needle) {
      return { items: [] };
    }
    const activeWard = { status: ACTIVE, province: { status: ACTIVE } };
    const like = `%${contains}%`;
    const [provinces, wards, stopPoints, legacy] = await Promise.all([
      this.prisma.province.findMany({
        where: { status: ACTIVE, searchText: { contains } },
        orderBy: { name: "asc" },
        take: PLACE_CANDIDATES,
        select: { id: true, name: true, searchText: true },
      }),
      this.prisma.ward.findMany({
        where: { ...activeWard, searchText: { contains } },
        orderBy: { name: "asc" },
        take: PLACE_CANDIDATES,
        select: { id: true, name: true, searchText: true, province: { select: { name: true } } },
      }),
      this.prisma.stopPointCatalog.findMany({
        // Trạm dừng nghỉ không cho đón / trả (BR-79) — chọn làm điểm đi / đến không bao giờ ra chuyến.
        where: { status: ACTIVE, type: { not: StopPointType.REST_STOP }, ward: activeWard, searchText: { contains } },
        orderBy: { name: "asc" },
        take: PLACE_CANDIDATES,
        select: { id: true, name: true, address: true, searchText: true },
      }),
      this.prisma.$queryRaw<LegacyPlaceRow[]>`
        SELECT * FROM (
          SELECT m.legacy_province_name AS "legacyProvinceName", m.legacy_district_name AS "legacyDistrictName",
                 m.legacy_ward_name AS "legacyWardName", p.id AS "provinceId", p.name AS "provinceName",
                 w.id AS "wardId", w.name AS "wardName",
                 vxn_search_text(COALESCE(NULLIF(m.legacy_ward_name, ''), NULLIF(m.legacy_district_name, ''),
                                          m.legacy_province_name)) AS "labelSearch"
          FROM legacy_administrative_mappings m
          JOIN wards w ON w.id = m.ward_id AND w.status = 'ACTIVE'
          JOIN provinces p ON p.id = m.province_id AND p.status = 'ACTIVE'
          WHERE m.search_text LIKE ${like}
        ) candidate
        WHERE candidate."labelSearch" LIKE ${like}
        ORDER BY length(candidate."labelSearch"), candidate."labelSearch"
        LIMIT ${PLACE_CANDIDATES}`,
    ]);

    const ranked: { place: Place; rank: number }[] = [
      ...provinces.map((row) => ({
        rank: placeRank(row.searchText ?? "", needle),
        place: { kind: "PROVINCE" as const, label: row.name, detail: null, target: { type: "province" as const, id: row.id } },
      })),
      ...wards.map((row) => ({
        rank: placeRank(row.searchText ?? "", needle),
        place: { kind: "WARD" as const, label: row.name, detail: row.province.name, target: { type: "ward" as const, id: row.id } },
      })),
      ...stopPoints.map((row) => ({
        rank: placeRank(row.searchText ?? "", needle),
        place: { kind: "STOP_POINT" as const, label: row.name, detail: row.address, target: { type: "stopPoint" as const, id: row.id } },
      })),
      ...legacy.flatMap((row) => {
        const place = legacyPlace(row);
        return place ? [{ rank: placeRank(row.labelSearch, needle), place }] : [];
      }),
    ];
    // Cùng hạng: tên khớp đúng cả dấu như người dùng gõ lên trước ("cờ đỏ" → "Xã Cờ Đỏ" trước "Xã Cổ Đô").
    const typed = query.q.toLocaleLowerCase("vi");
    const accentMiss = (place: Place) => (place.label.toLocaleLowerCase("vi").includes(typed) ? 0 : 1);
    ranked.sort(
      (a, b) =>
        a.rank - b.rank ||
        accentMiss(a.place) - accentMiss(b.place) ||
        PLACE_KIND_ORDER[a.place.kind] - PLACE_KIND_ORDER[b.place.kind] ||
        a.place.label.length - b.place.label.length ||
        a.place.label.localeCompare(b.place.label, "vi"),
    );
    return { items: ranked.slice(0, query.limit).map(({ place }) => place) };
  }
}

/** Gợi ý cho một dòng ánh xạ cũ; `null` khi tên cũ trùng hệt tên đơn vị mới (gợi ý mới đã đủ). */
function legacyPlace(row: LegacyPlaceRow): Place | null {
  if (row.legacyWardName) {
    if (row.legacyWardName === row.wardName) {
      return null;
    }
    return {
      kind: "LEGACY",
      label: row.legacyWardName,
      detail: `Cũ: ${row.legacyDistrictName ? `${row.legacyDistrictName}, ` : ""}${row.legacyProvinceName} · Nay: ${row.wardName}, ${row.provinceName}`,
      target: { type: "ward", id: row.wardId },
    };
  }
  const label = row.legacyDistrictName || row.legacyProvinceName;
  if (label === row.provinceName) {
    return null;
  }
  return {
    kind: "LEGACY",
    label,
    detail: `${row.legacyDistrictName ? `Cũ: ${row.legacyProvinceName} · ` : ""}Nay thuộc ${row.provinceName}`,
    target: { type: "province", id: row.provinceId },
  };
}

