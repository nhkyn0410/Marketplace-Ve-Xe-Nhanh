import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RouteStatus, StopPointType } from "../../database/prisma.types";

// API §7.5 `/admin/routes` — Admin xem tuyến của mọi nhà xe kèm hiệu suất theo kỳ (FR-NSR-13 "theo tuyến", SRS ma trận
// quyền "Trip / fare / inventory — Giám sát"; tự thiết kế 28/10/2026, chờ duyệt). Chỉ xem. Quyền `user:manage`; số tiền
// chỉ trả khi người xem có thêm `payment:monitor`.

const MAX_DAYS = 366;
const DAY_MS = 86_400_000;

/** Kỳ thống kê `[from, to]` (ngày VN, gồm hai đầu); bỏ trống = 30 ngày gần nhất. */
export const PeriodFields = {
  from: z.iso.date().optional(),
  to: z.iso.date().optional(),
};
export const periodOk = (query: { from?: string; to?: string }) =>
  (query.from === undefined) === (query.to === undefined) &&
  (query.from === undefined || (query.from <= query.to! && Date.parse(query.to!) - Date.parse(query.from) <= MAX_DAYS * DAY_MS));
export const periodIssue = { message: "Nhập cả hai ngày, ngày bắt đầu không sau ngày kết thúc, tối đa 366 ngày.", path: ["to"] };

/** Cách xếp danh sách tuyến. `revenue` khi người xem không có `payment:monitor` thì xếp như `sold`. */
export const ROUTE_SORTS = ["sold", "revenue", "trips", "fill", "name"] as const;

export const AdminRouteListQuerySchema = z
  .object({
    /** Tên tuyến. */
    q: z
      .string()
      .trim()
      .max(100)
      .transform((value) => value || undefined)
      .optional(),
    operatorId: z.uuid().optional(),
    status: z.enum(RouteStatus).optional(),
    originProvinceId: z.uuid().optional(),
    destinationProvinceId: z.uuid().optional(),
    ...PeriodFields,
    sort: z.enum(ROUTE_SORTS).default("sold"),
    /** Vị trí bắt đầu (số dòng đã tải) — danh sách xếp theo số liệu nên dùng vị trí thay cho cursor thời gian. */
    cursor: z.string().regex(/^\d{1,6}$/).optional(),
    limit: z.coerce.number().int().min(1).max(50).default(20),
  })
  .refine(periodOk, periodIssue);
export type AdminRouteListQuery = z.infer<typeof AdminRouteListQuerySchema>;
export class AdminRouteListQueryDto extends createZodDto(AdminRouteListQuerySchema) {}

const MoneyOrHidden = z.int().nonnegative().nullable();

/** Số liệu một tuyến trong kỳ (chuyến khởi hành trong kỳ, trừ nháp). */
export const RouteMetricsSchema = z.object({
  trips: z.int(),
  completedTrips: z.int(),
  cancelledTrips: z.int(),
  seats: z.int(),
  ticketsSold: z.int(),
  /** Tổng giá vé đã bán. */
  ticketRevenue: MoneyOrHidden,
});

const ProvinceRefSchema = z.object({ id: z.uuid(), name: z.string() }).nullable();

const AdminRouteSchema = RouteMetricsSchema.extend({
  id: z.uuid(),
  name: z.string(),
  status: z.enum(RouteStatus),
  operatorId: z.uuid(),
  operatorName: z.string(),
  /** Tỉnh của điểm đầu / điểm cuối. */
  origin: ProvinceRefSchema,
  destination: ProvinceRefSchema,
  stopCount: z.int(),
  distanceMeters: z.int(),
  durationSeconds: z.int(),
  /** Chuyến chưa khởi hành đang mở bán / hết chỗ. */
  upcomingTrips: z.int(),
  /** Đánh giá đang hiển thị của các chuyến thuộc tuyến (mọi thời điểm). */
  averageRating: z.number().nullable(),
  reviewCount: z.int(),
});
export type AdminRoute = z.infer<typeof AdminRouteSchema>;

export const AdminRoutePageSchema = z.object({
  items: z.array(AdminRouteSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
  period: z.object({ from: z.iso.date(), to: z.iso.date() }),
});
export type AdminRoutePage = z.infer<typeof AdminRoutePageSchema>;
export class AdminRoutePageDto extends createZodDto(AdminRoutePageSchema) {}

export const AdminRouteDetailQuerySchema = z.object({ ...PeriodFields }).refine(periodOk, periodIssue);
export type AdminRouteDetailQuery = z.infer<typeof AdminRouteDetailQuerySchema>;
export class AdminRouteDetailQueryDto extends createZodDto(AdminRouteDetailQuerySchema) {}

export const AdminRouteDetailSchema = AdminRouteSchema.extend({
  note: z.string().nullable(),
  period: z.object({ from: z.iso.date(), to: z.iso.date() }),
  stops: z.array(
    z.object({
      sequence: z.int(),
      name: z.string(),
      address: z.string(),
      type: z.enum(StopPointType),
      /** Điểm dùng chung của nền tảng hay điểm riêng của nhà xe. */
      shared: z.boolean(),
      provinceName: z.string().nullable(),
      latitude: z.number(),
      longitude: z.number(),
      allowPickup: z.boolean(),
      allowDropoff: z.boolean(),
      distanceMetersFromPrevious: z.int().nullable(),
      durationSecondsFromPrevious: z.int().nullable(),
    }),
  ),
  /** Tối đa 10 chuyến sắp chạy gần nhất. */
  nextTrips: z.array(
    z.object({ id: z.uuid(), departureAt: z.iso.datetime(), status: z.string(), vehiclePlate: z.string().nullable(), seats: z.int(), ticketsSold: z.int() }),
  ),
});
export type AdminRouteDetail = z.infer<typeof AdminRouteDetailSchema>;
export class AdminRouteDetailDto extends createZodDto(AdminRouteDetailSchema) {}

export class AdminRouteIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}
