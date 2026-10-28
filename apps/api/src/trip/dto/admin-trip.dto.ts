import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TimeCursorField } from "../../common/time-cursor";
import { EmployeeRole, SalesChannel, TicketStatus, TripStatus } from "../../database/prisma.types";

// API §7.5 `/admin/trips` — Admin giám sát chuyến của mọi nhà xe (SRS ma trận quyền "Xem chi tiết chuyến — Xem / giám sát
// toàn hệ thống", "Trip / fare / inventory — Giám sát"; tự thiết kế 28/10/2026, chờ duyệt). Chỉ xem, quyền `user:manage`;
// tiền chỉ trả khi có thêm `payment:monitor`. Chi tiết chuyến có danh sách người đi → mỗi lượt xem ghi audit.

const MAX_DAYS = 92;
const DAY_MS = 86_400_000;

export const AdminTripListQuerySchema = z
  .object({
    /** Ngày khởi hành `[from, to]` theo giờ VN; bỏ trống = hôm nay + 6 ngày tới. */
    from: z.iso.date().optional(),
    to: z.iso.date().optional(),
    operatorId: z.uuid().optional(),
    routeId: z.uuid().optional(),
    status: z.enum(TripStatus).optional(),
    /** Biển số xe hoặc tên tuyến. */
    q: z
      .string()
      .trim()
      .max(100)
      .transform((value) => value || undefined)
      .optional(),
    /** `{departureAt}_{id}` của dòng cuối trang trước — khởi hành sớm trước. */
    cursor: TimeCursorField,
    limit: z.coerce.number().int().min(1).max(50).default(20),
  })
  .refine(
    (query) =>
      (query.from === undefined) === (query.to === undefined) &&
      (query.from === undefined || (query.from <= query.to! && Date.parse(query.to!) - Date.parse(query.from) <= MAX_DAYS * DAY_MS)),
    { message: "Nhập cả hai ngày, ngày bắt đầu không sau ngày kết thúc, tối đa 92 ngày.", path: ["to"] },
  );
export type AdminTripListQuery = z.infer<typeof AdminTripListQuerySchema>;
export class AdminTripListQueryDto extends createZodDto(AdminTripListQuerySchema) {}

const AdminTripSchema = z.object({
  id: z.uuid(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  status: z.enum(TripStatus),
  operatorId: z.uuid(),
  operatorName: z.string(),
  routeId: z.uuid(),
  routeName: z.string(),
  vehiclePlate: z.string().nullable(),
  seats: z.int(),
  /** Vé còn đi chuyến (đã bán, chưa hủy / hoàn). */
  ticketsSold: z.int(),
});
export type AdminTrip = z.infer<typeof AdminTripSchema>;

export const AdminTripPageSchema = z.object({
  items: z.array(AdminTripSchema),
  nextCursor: z.string().nullable(),
  total: z.int(),
  period: z.object({ from: z.iso.date(), to: z.iso.date() }),
});
export type AdminTripPage = z.infer<typeof AdminTripPageSchema>;
export class AdminTripPageDto extends createZodDto(AdminTripPageSchema) {}

export const AdminTripDetailSchema = AdminTripSchema.extend({
  statusReason: z.string().nullable(),
  departedAt: z.iso.datetime().nullable(),
  completedAt: z.iso.datetime().nullable(),
  onlineSaleCutoffMinutes: z.int(),
  vehicleTypeName: z.string().nullable(),
  stops: z.array(
    z.object({
      sequence: z.int(),
      name: z.string(),
      address: z.string(),
      plannedAt: z.iso.datetime(),
      allowPickup: z.boolean(),
      allowDropoff: z.boolean(),
    }),
  ),
  /** Số chỗ theo trạng thái. */
  seatSummary: z.object({ available: z.int(), holding: z.int(), booked: z.int(), checkedIn: z.int(), blocked: z.int() }),
  staff: z.array(z.object({ username: z.string(), role: z.enum(EmployeeRole) })),
  bookingCount: z.int(),
  /** Tổng giá vé đã bán. */
  ticketRevenue: z.int().nonnegative().nullable(),
  /**
   * Danh sách người đi (mỗi vé một chỗ; chỗ đôi có thể thêm người đi cùng — BR-78), gồm cả khách vãng lai và
   * khách mua tại quầy. SĐT đã che.
   */
  manifest: z.array(
    z.object({
      ticketCode: z.string(),
      seatCode: z.string(),
      fullName: z.string(),
      /** Người đi cùng trên chỗ đôi (chung vé). */
      companionName: z.string().nullable(),
      phone: z.string().nullable(),
      status: z.enum(TicketStatus),
      bookingCode: z.string(),
      channel: z.enum(SalesChannel),
      /** Đơn không gắn tài khoản (khách vãng lai / mua tại quầy). */
      guest: z.boolean(),
      /** Tài khoản hành khách đặt đơn — mở chi tiết hành khách. */
      userId: z.string().nullable(),
    }),
  ),
});
export type AdminTripDetail = z.infer<typeof AdminTripDetailSchema>;
export class AdminTripDetailDto extends createZodDto(AdminTripDetailSchema) {}

export class AdminTripIdParamDto extends createZodDto(z.object({ id: z.uuid() })) {}
