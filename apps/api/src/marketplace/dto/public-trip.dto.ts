import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RouteStopRole, SeatType, StopPointType, VehicleClass, VehicleForm } from "../../database/prisma.types";
import { AREA_ID } from "../../database/public-trips";

// API §7.2 `/trips/search`, `/trips/{tripId}` — tìm chuyến + chi tiết chuyến công khai (TASK-TRN-004; FR-MKT-01..05,
// FR-MKT-15, BR-22, BR-77, BR-80). Không cần đăng nhập. Giờ trong query (`departureFrom` / `departureTo`) theo giờ VN.

export const MAX_PASSENGERS = 10;
export const SEARCH_SORTS = ["departure", "price", "duration"] as const;
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
const id = z.string().trim().min(1).max(64);
const areaId = z.string().trim().max(120).regex(AREA_ID);

export const TripSearchQuerySchema = z
  .object({
    /**
     * Phía đi: đúng một trong tỉnh / thành, phường / xã (điểm đón nằm trong phường — chờ duyệt 27/10/2026), khu vực (đơn vị
     * hành chính cũ = nhóm phường mới, mã từ `GET /catalog/places` — chờ duyệt 29/10/2026) hoặc một điểm dùng chung (địa
     * danh — khớp trong bán kính, BR-80).
     */
    fromProvinceId: id.optional(),
    fromWardId: id.optional(),
    fromAreaId: areaId.optional(),
    fromStopPointId: z.uuid().optional(),
    toProvinceId: id.optional(),
    toWardId: id.optional(),
    toAreaId: areaId.optional(),
    toStopPointId: z.uuid().optional(),
    /** Ngày đi (giờ đón tại điểm đón khớp) theo giờ VN. */
    date: z.iso.date(),
    passengers: z.coerce.number().int().min(1).max(MAX_PASSENGERS).default(1),
    operatorId: z.uuid().optional(),
    vehicleForm: z.enum(VehicleForm).optional(),
    vehicleClass: z.enum(VehicleClass).optional(),
    /** Khung giờ đón `[departureFrom, departureTo]` (HH:mm giờ VN). */
    departureFrom: z.string().regex(TIME).optional(),
    departureTo: z.string().regex(TIME).optional(),
    priceMin: z.coerce.number().int().min(0).optional(),
    priceMax: z.coerce.number().int().min(0).optional(),
    /** Tiện ích (id, phân tách bằng dấu phẩy) — chuyến phải có đủ. */
    amenityIds: z
      .string()
      .max(1000)
      .optional()
      .transform((value) => (value ? value.split(",").map((item) => item.trim()).filter(Boolean) : [])),
    sort: z.enum(SEARCH_SORTS).default("departure"),
    page: z.coerce.number().int().min(1).max(100).default(1),
    limit: z.coerce.number().int().min(1).max(50).default(20),
  })
  .superRefine((query, ctx) => {
    const count = (...values: (string | undefined)[]) => values.filter(Boolean).length;
    if (count(query.fromProvinceId, query.fromWardId, query.fromAreaId, query.fromStopPointId) !== 1) {
      ctx.addIssue({ code: "custom", path: ["fromProvinceId"], message: "Chọn đúng một điểm đi: tỉnh / thành, phường / xã, khu vực hoặc địa danh." });
    }
    if (count(query.toProvinceId, query.toWardId, query.toAreaId, query.toStopPointId) !== 1) {
      ctx.addIssue({ code: "custom", path: ["toProvinceId"], message: "Chọn đúng một điểm đến: tỉnh / thành, phường / xã, khu vực hoặc địa danh." });
    }
    if (query.priceMin !== undefined && query.priceMax !== undefined && query.priceMin > query.priceMax) {
      ctx.addIssue({ code: "custom", path: ["priceMax"], message: "Giá tối đa phải từ giá tối thiểu trở lên." });
    }
  });
export type TripSearchQuery = z.infer<typeof TripSearchQuerySchema>;
export class TripSearchQueryDto extends createZodDto(TripSearchQuerySchema) {}

/** Điểm đánh giá công khai của nhà xe (như "Nhà xe nổi bật"): trung bình các đánh giá đang hiển thị, 1 chữ số thập phân. */
const OperatorRatingShape = {
  /** `null` = chưa có đánh giá nào đang hiển thị. */
  averageRating: z.number().nullable(),
  reviewCount: z.int(),
};

const PointSchema = z.object({
  /** Thứ tự điểm trong chuyến — dùng khi giữ chỗ / đặt vé. */
  sequence: z.int(),
  name: z.string(),
  address: z.string(),
  plannedAt: z.iso.datetime(),
});

export const TripSearchItemSchema = z.object({
  tripId: z.uuid(),
  operator: z.object({ id: z.uuid(), name: z.string(), slug: z.string(), ...OperatorRatingShape }),
  /** Tên tuyến của nhà xe — dòng phụ; tiêu đề cho khách là `segmentTitle`. */
  routeName: z.string(),
  /** Chặng khách đi theo nơi của điểm đón / trả (3.3), vd "TP.HCM → Gia Nghĩa"; hai điểm cùng nơi thì tên hai điểm. */
  segmentTitle: z.string(),
  vehicleType: z.object({ name: z.string(), form: z.enum(VehicleForm), class: z.enum(VehicleClass) }),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  pickup: PointSchema,
  dropoff: PointSchema,
  /** Phút từ điểm đón tới điểm trả. */
  durationMinutes: z.int(),
  availableSeats: z.int(),
  /** Giá thấp nhất (VND) trong các chỗ còn trống, theo chặng khách đi (giá tuyến con nếu có — 3.3). */
  minPrice: z.int(),
  /** Ảnh đại diện của xe (FR-MKT-15); `null` = giao diện hiện hình thay thế. */
  vehicleCoverImageUrl: z.string().nullable(),
  amenities: z.array(z.object({ id: z.string(), name: z.string() })),
  /** Sau mốc này không đặt online được nữa (AS-20) — tính theo giờ xe tới điểm đón (3.3). */
  onlineSaleClosesAt: z.iso.datetime(),
});
export type TripSearchItem = z.infer<typeof TripSearchItemSchema>;

export const TripSearchResponseSchema = z.object({
  items: z.array(TripSearchItemSchema),
  total: z.int(),
  page: z.int(),
  limit: z.int(),
  /** Gợi ý bộ lọc từ toàn bộ kết quả trước khi lọc thêm. */
  facets: z.object({
    operators: z.array(z.object({ id: z.uuid(), name: z.string(), count: z.int() })),
    priceMin: z.int().nullable(),
    priceMax: z.int().nullable(),
  }),
  /**
   * Phía tìm theo phường / xã hoặc khu vực mà không có chuyến nào khớp → kết quả đã nới ra cả tỉnh chứa phường / khu vực
   * đó (`true`); giao diện báo "không có điểm đón / trả tại nơi đã chọn". Phía tỉnh / địa danh luôn `false`.
   */
  widenedToProvince: z.object({ from: z.boolean(), to: z.boolean() }),
});
export type TripSearchResponse = z.infer<typeof TripSearchResponseSchema>;
export class TripSearchResponseDto extends createZodDto(TripSearchResponseSchema) {}

export const PublicTripSchema = z.object({
  tripId: z.uuid(),
  operator: z.object({ id: z.uuid(), name: z.string(), slug: z.string(), hotline: z.string().nullable(), ...OperatorRatingShape }),
  routeName: z.string(),
  /**
   * Chặng khách đi khi gọi kèm `pickupSequence` + `dropoffSequence` hợp lệ (3.3): tiêu đề theo nơi + giá ghế theo chặng;
   * không kèm (hoặc sai) → `null`, giá ghế theo cả tuyến.
   */
  segment: z.object({ pickupSequence: z.int(), dropoffSequence: z.int(), title: z.string() }).nullable(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  /** Hết giờ bán online của điểm đón đã chọn; không chọn thì của điểm đón muộn nhất còn bán. */
  onlineSaleClosesAt: z.iso.datetime(),
  note: z.string().nullable(),
  vehicleType: z.object({ name: z.string(), form: z.enum(VehicleForm), class: z.enum(VehicleClass) }),
  amenities: z.array(z.object({ id: z.string(), name: z.string() })),
  /** Bộ ảnh xe theo thứ tự (FR-MKT-15); mảng rỗng = chưa có ảnh. */
  vehicleImages: z.array(z.object({ url: z.string(), caption: z.string().nullable() })),
  stops: z.array(
    z.object({
      sequence: z.int(),
      role: z.enum(RouteStopRole),
      name: z.string(),
      address: z.string(),
      type: z.enum(StopPointType),
      latitude: z.number(),
      longitude: z.number(),
      plannedAt: z.iso.datetime(),
      pickupWindowStart: z.iso.datetime().nullable(),
      pickupWindowEnd: z.iso.datetime().nullable(),
      allowPickup: z.boolean(),
      allowDropoff: z.boolean(),
      /** Điểm đón còn bán online (chưa qua giờ ngừng bán tính theo giờ xe tới điểm này — 3.3); điểm không cho đón `false`. */
      pickupOpen: z.boolean(),
      note: z.string().nullable(),
    }),
  ),
  seats: z.array(
    z.object({
      code: z.string(),
      deck: z.int(),
      row: z.int(),
      column: z.int(),
      type: z.enum(SeatType),
      /** `AVAILABLE` = đặt được; còn lại (đã bán, đang giữ, khóa) gộp `UNAVAILABLE`. */
      status: z.enum(["AVAILABLE", "UNAVAILABLE"]),
      /** VND; `null` = chỗ chưa có giá (không đặt được). */
      price: z.int().nullable(),
    }),
  ),
  /** Mốc hủy / hoàn đang áp dụng cho nhà xe (BR-07, OQ-13): hủy khi còn ≥ `minHoursBefore` giờ thì hoàn `refundPercent`%. */
  cancellationPolicy: z.object({ tiers: z.array(z.object({ minHoursBefore: z.int(), refundPercent: z.int() })) }),
});
export type PublicTrip = z.infer<typeof PublicTripSchema>;
export class PublicTripDto extends createZodDto(PublicTripSchema) {}

/** Query chi tiết chuyến công khai: chặng khách đi (tùy chọn) để tính giá ghế theo chặng (3.3). */
export const PublicTripQuerySchema = z.object({
  pickupSequence: z.coerce.number().int().min(1).optional(),
  dropoffSequence: z.coerce.number().int().min(1).optional(),
});
export type PublicTripQuery = z.infer<typeof PublicTripQuerySchema>;
export class PublicTripQueryDto extends createZodDto(PublicTripQuerySchema) {}
