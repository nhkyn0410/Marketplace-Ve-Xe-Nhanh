import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { SearchQueryField } from "../../common/search-text";
import {
  StopPointType,
  VehicleClass,
  VehicleForm,
} from "../../database/prisma.types";

/** Query `GET /catalog/wards`: phường/xã phải thuộc một tỉnh cụ thể. */
export class WardListQueryDto extends createZodDto(
  z.object({ provinceId: z.uuid() }),
) {}

export const StopPointListQuerySchema = z.object({
  provinceId: z.uuid().optional(),
  wardId: z.uuid().optional(),
  type: z.enum(StopPointType).optional(),
  q: SearchQueryField,
  cursor: z.uuid().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});
export type StopPointListQuery = z.infer<typeof StopPointListQuerySchema>;
/** Query `GET /catalog/stop-points`: lọc theo tỉnh/phường/loại, tìm không dấu theo tên hoặc địa chỉ, phân trang cursor theo `id`. */
export class StopPointListQueryDto extends createZodDto(
  StopPointListQuerySchema,
) {}

// Response chỉ chứa field công khai (Security §6 "Public catalog"): không status, không timestamp.
// ZodSerializerInterceptor cắt field thừa nếu service lỡ trả thêm.

export const ProvinceListResponseSchema = z.object({
  items: z.array(
    z.object({ id: z.uuid(), code: z.string(), name: z.string() }),
  ),
});
export type ProvinceListResponse = z.infer<typeof ProvinceListResponseSchema>;
/** Danh sách tỉnh/thành công khai. */
export class ProvinceListResponseDto extends createZodDto(
  ProvinceListResponseSchema,
) {}

export const WardListResponseSchema = z.object({
  items: z.array(
    z.object({
      id: z.uuid(),
      code: z.string(),
      name: z.string(),
      provinceId: z.uuid(),
    }),
  ),
});
export type WardListResponse = z.infer<typeof WardListResponseSchema>;
/** Danh sách phường/xã công khai của một tỉnh. */
export class WardListResponseDto extends createZodDto(WardListResponseSchema) {}

export const StopPointListResponseSchema = z.object({
  items: z.array(
    z.object({
      id: z.uuid(),
      name: z.string(),
      type: z.enum(StopPointType),
      address: z.string(),
      provinceId: z.uuid(),
      wardId: z.uuid(),
      latitude: z.number(),
      longitude: z.number(),
      description: z.string().nullable(),
    }),
  ),
  nextCursor: z.uuid().nullable(),
});
export type StopPointListResponse = z.infer<typeof StopPointListResponseSchema>;
/** Một trang điểm đón/trả chuẩn công khai. */
export class StopPointListResponseDto extends createZodDto(
  StopPointListResponseSchema,
) {}

export const VehicleTypeListResponseSchema = z.object({
  items: z.array(
    z.object({
      id: z.uuid(),
      code: z.string(),
      name: z.string(),
      description: z.string().nullable(),
      // BR-77: hai thuộc tính độc lập — dạng chỗ và hạng xe.
      form: z.enum(VehicleForm),
      class: z.enum(VehicleClass),
    }),
  ),
});
export type VehicleTypeListResponse = z.infer<
  typeof VehicleTypeListResponseSchema
>;
/** Danh sách loại phương tiện chuẩn công khai. */
export class VehicleTypeListResponseDto extends createZodDto(
  VehicleTypeListResponseSchema,
) {}

export const AmenityListResponseSchema = z.object({
  items: z.array(
    z.object({ id: z.uuid(), code: z.string(), name: z.string() }),
  ),
});
export type AmenityListResponse = z.infer<typeof AmenityListResponseSchema>;
/** Danh sách tiện ích chuẩn công khai. */
export class AmenityListResponseDto extends createZodDto(
  AmenityListResponseSchema,
) {}

/** Query `GET /catalog/popular-routes` và `GET /catalog/featured-operators`: số mục tối đa. */
const highlightLimit = (fallback: number) =>
  z.object({ limit: z.coerce.number().int().min(1).max(20).default(fallback) });
export class PopularRouteListQueryDto extends createZodDto(highlightLimit(7)) {}
export class FeaturedOperatorListQueryDto extends createZodDto(
  highlightLimit(5),
) {}

const ProvincePairSchema = z.object({
  originProvinceId: z.uuid(),
  /** Tên ngắn ("TP. Hồ Chí Minh", "Lâm Đồng"). */
  originName: z.string(),
  destinationProvinceId: z.uuid(),
  destinationName: z.string(),
});

export const PopularRouteListResponseSchema = z.object({
  items: z.array(
    ProvincePairSchema.extend({
      distanceMeters: z.int(),
      durationSeconds: z.int(),
      /** VND, giá thấp nhất của các bảng giá đang áp dụng; null khi chưa có. */
      minPrice: z.int().nullable(),
      vehicleTypeNames: z.array(z.string()),
      nextDepartureAt: z.iso.datetime().nullable(),
      operatorCount: z.int(),
      averageRating: z.number().nullable(),
      reviewCount: z.int(),
    }),
  ),
});
export type PopularRouteListResponse = z.infer<
  typeof PopularRouteListResponseSchema
>;
/** Tuyến phổ biến: cặp tỉnh có chuyến mở bán, gộp mọi nhà xe. */
export class PopularRouteListResponseDto extends createZodDto(
  PopularRouteListResponseSchema,
) {}

export const FeaturedOperatorListResponseSchema = z.object({
  items: z.array(
    z.object({
      operatorId: z.uuid(),
      displayName: z.string(),
      /** Logo ở kho công khai; `null` = chưa có logo (hiển thị chữ viết tắt). */
      logoUrl: z.url().nullable(),
      averageRating: z.number().nullable(),
      reviewCount: z.int(),
      routes: z.array(ProvincePairSchema),
    }),
  ),
});
export type FeaturedOperatorListResponse = z.infer<
  typeof FeaturedOperatorListResponseSchema
>;
/** Nhà xe tiêu biểu đang mở bán, kèm các tuyến (cặp tỉnh). */
export class FeaturedOperatorListResponseDto extends createZodDto(
  FeaturedOperatorListResponseSchema,
) {}

/** Query `GET /catalog/places`: từ khoá (gõ không dấu được) + số gợi ý tối đa. */
export const PlaceSuggestionQuerySchema = z.object({
  q: z.string().trim().min(2).max(100),
  limit: z.coerce.number().int().min(1).max(20).default(8),
});
export type PlaceSuggestionQuery = z.infer<typeof PlaceSuggestionQuerySchema>;
export class PlaceSuggestionQueryDto extends createZodDto(
  PlaceSuggestionQuerySchema,
) {}

export const PLACE_KINDS = ["PROVINCE", "AREA", "WARD", "STOP_POINT", "LEGACY"] as const;

export const PlaceSuggestionListResponseSchema = z.object({
  items: z.array(
    z.object({
      /**
       * Loại gợi ý; `AREA` = khu vực — tỉnh cũ hoặc quận / huyện / thị xã / thành phố cũ trước sáp nhập 2025, ứng với
       * nhóm phường mới (vd "Đà Lạt", "Vũng Tàu", "Bình Thuận"); `LEGACY` = tên phường / xã cũ dẫn tới phường mới.
       */
      kind: z.enum(PLACE_KINDS),
      /** Tên hiển thị (tên cũ với `LEGACY`, tên khu vực bỏ chữ "Thành phố" / "Thị xã" / "Tỉnh" với `AREA`). */
      label: z.string(),
      /** Dòng phụ: tỉnh của phường, địa chỉ của địa danh, đơn vị mới của tên cũ / khu vực. */
      detail: z.string().nullable(),
      /**
       * Gửi vào `GET /trips/search`: `province` → `fromProvinceId`, `ward` → `fromWardId`, `area` → `fromAreaId`,
       * `stopPoint` → `fromStopPointId`. Mã khu vực không phải uuid (vd `77-thanh-pho-vung-tau`).
       */
      target: z.object({
        type: z.enum(["province", "ward", "area", "stopPoint"]),
        id: z.string(),
      }),
    }),
  ),
});
export type PlaceSuggestionListResponse = z.infer<
  typeof PlaceSuggestionListResponseSchema
>;
/** Gợi ý điểm đi / điểm đến cho ô tìm chuyến. */
export class PlaceSuggestionListResponseDto extends createZodDto(
  PlaceSuggestionListResponseSchema,
) {}
