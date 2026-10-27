import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RouteStopRole, SeatType, StopPointType, VehicleClass, VehicleForm } from "../../database/prisma.types";

// API §7.2 `/trips/search`, `/trips/{tripId}` — tìm chuyến + chi tiết chuyến công khai (TASK-TRN-004; FR-MKT-01..05,
// FR-MKT-15, BR-22, BR-77, BR-80). Không cần đăng nhập. Giờ trong query (`departureFrom` / `departureTo`) theo giờ VN.

export const MAX_PASSENGERS = 10;
export const SEARCH_SORTS = ["departure", "price", "duration"] as const;
const TIME = /^([01]\d|2[0-3]):[0-5]\d$/;
const id = z.string().trim().min(1).max(64);

export const TripSearchQuerySchema = z
  .object({
    /** Phía đi: tỉnh / thành HOẶC một điểm dùng chung (địa danh — khớp trong bán kính, BR-80). */
    fromProvinceId: id.optional(),
    fromStopPointId: z.uuid().optional(),
    toProvinceId: id.optional(),
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
    if (Boolean(query.fromProvinceId) === Boolean(query.fromStopPointId)) {
      ctx.addIssue({ code: "custom", path: ["fromProvinceId"], message: "Chọn đúng một điểm đi: tỉnh / thành hoặc địa danh." });
    }
    if (Boolean(query.toProvinceId) === Boolean(query.toStopPointId)) {
      ctx.addIssue({ code: "custom", path: ["toProvinceId"], message: "Chọn đúng một điểm đến: tỉnh / thành hoặc địa danh." });
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
  routeName: z.string(),
  vehicleType: z.object({ name: z.string(), form: z.enum(VehicleForm), class: z.enum(VehicleClass) }),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  pickup: PointSchema,
  dropoff: PointSchema,
  /** Phút từ điểm đón tới điểm trả. */
  durationMinutes: z.int(),
  availableSeats: z.int(),
  /** Giá thấp nhất (VND) trong các chỗ còn trống. */
  minPrice: z.int(),
  /** Ảnh đại diện của xe (FR-MKT-15); `null` = giao diện hiện hình thay thế. */
  vehicleCoverImageUrl: z.string().nullable(),
  amenities: z.array(z.object({ id: z.string(), name: z.string() })),
  /** Sau mốc này không đặt online được nữa (AS-20). */
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
});
export type TripSearchResponse = z.infer<typeof TripSearchResponseSchema>;
export class TripSearchResponseDto extends createZodDto(TripSearchResponseSchema) {}

export const PublicTripSchema = z.object({
  tripId: z.uuid(),
  operator: z.object({ id: z.uuid(), name: z.string(), slug: z.string(), hotline: z.string().nullable(), ...OperatorRatingShape }),
  routeName: z.string(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
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
