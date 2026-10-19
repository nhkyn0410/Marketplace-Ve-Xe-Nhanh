import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { EmployeeRole, PaymentProvider, TripStatus } from "../../database/prisma.types";

// Báo cáo nhà xe (TASK-RPT-001, FR-NSR-12, UC-17; Figma "Nhà xe · Báo cáo / Tổng hợp") + báo cáo / tổng quan Admin (TASK-RPT-002,
// FR-NSR-13, FR-ADM-17, UC-29; Figma ADM-14a, ADM-01). Số liệu tính trực tiếp từ Postgres (CTE). Shape AI tự đề xuất, chờ Khanh
// duyệt (`doc/task-propreties/RPT-todo.md`).

const DateRange = {
  /** Ngày theo giờ VN (`YYYY-MM-DD`), gồm cả hai đầu; tối đa 366 ngày. */
  from: z.iso.date(),
  to: z.iso.date(),
};
const rangeOk = (query: { from: string; to: string }) => query.from <= query.to && Date.parse(query.to) - Date.parse(query.from) <= 366 * 86_400_000;
const rangeIssue = { message: "Khoảng ngày không hợp lệ (tối đa 366 ngày).", path: ["to"] };

export const OperatorReportQuerySchema = z
  .object({ ...DateRange, routeId: z.uuid().optional(), vehicleId: z.uuid().optional(), status: z.enum(TripStatus).optional() })
  .refine(rangeOk, rangeIssue);
export type OperatorReportQuery = z.infer<typeof OperatorReportQuerySchema>;
export class OperatorReportQueryDto extends createZodDto(OperatorReportQuerySchema) {}

const RouteRowSchema = z.object({
  routeId: z.uuid(),
  routeName: z.string(),
  trips: z.int(),
  completedTrips: z.int(),
  seats: z.int(),
  ticketsSold: z.int(),
  /** VND — giá vé của vé còn đi chuyến (không gồm vé đã hủy / hoàn). */
  grossRevenue: z.int(),
});

export const OperatorReportSchema = z.object({
  totals: z.object({
    grossRevenue: z.int(),
    trips: z.int(),
    completedTrips: z.int(),
    ticketsSold: z.int(),
    bookings: z.int(),
    seats: z.int(),
    /** Vé đã hủy (gồm đã hoàn) / (vé bán + vé hủy). */
    cancelledTickets: z.int(),
    refundedTickets: z.int(),
  }),
  byRoute: z.array(RouteRowSchema),
  employees: z.array(
    z.object({
      employeeId: z.uuid(),
      /** `{slug}/nv.xxx`. */
      loginName: z.string(),
      role: z.enum(EmployeeRole),
      assignedTrips: z.int(),
      completedTrips: z.int(),
      /** Vé đã soát lên xe trong kỳ. */
      ticketsChecked: z.int(),
    }),
  ),
});
export type OperatorReport = z.infer<typeof OperatorReportSchema>;
/** Báo cáo vận hành + doanh thu của nhà xe trong kỳ. */
export class OperatorReportDto extends createZodDto(OperatorReportSchema) {}

export const OperatorOverviewSchema = z.object({
  today: z.object({ trips: z.int(), running: z.int(), ticketsSold: z.int(), seats: z.int() }),
  /** 7 ngày tới (không gồm hôm nay). */
  nextWeek: z.object({ trips: z.int(), ticketsSold: z.int(), seats: z.int() }),
  /** Tháng này (giờ VN), theo giờ khởi hành. */
  month: z.object({ grossRevenue: z.int(), ticketsSold: z.int(), completedTrips: z.int() }),
  attention: z.object({
    /** Chuyến đang bán trong 48 giờ tới chưa phân công tài xế. */
    tripsWithoutDriver: z.int(),
    /** Chuyến nháp khởi hành trong 7 ngày tới. */
    draftTrips: z.int(),
    /** Đơn đang chờ hoàn tiền / hoàn lỗi. */
    pendingRefunds: z.int(),
  }),
  upcoming: z.array(
    z.object({
      tripId: z.uuid(),
      routeName: z.string(),
      departureAt: z.iso.datetime(),
      status: z.enum(TripStatus),
      vehiclePlateNumber: z.string().nullable(),
      ticketsSold: z.int(),
      seats: z.int(),
      driverName: z.string().nullable(),
    }),
  ),
});
export type OperatorOverview = z.infer<typeof OperatorOverviewSchema>;
/** Tổng quan vận hành của nhà xe (trang chủ Operator OS). */
export class OperatorOverviewDto extends createZodDto(OperatorOverviewSchema) {}

export const AdminReportQuerySchema = z
  .object({ ...DateRange, operatorId: z.uuid().optional(), provider: z.enum(PaymentProvider).optional() })
  .refine(rangeOk, rangeIssue);
export type AdminReportQuery = z.infer<typeof AdminReportQuerySchema>;
export class AdminReportQueryDto extends createZodDto(AdminReportQuerySchema) {}

export const AdminReportSchema = z.object({
  totals: z.object({
    /** VND — thanh toán thành công trong kỳ (theo giờ trả). */
    gmv: z.int(),
    bookings: z.int(),
    tickets: z.int(),
    /** VND — GMV trừ tiền đã hoàn trong kỳ. Tạm tính khi còn thanh toán cần đối soát. */
    netRevenue: z.int(),
    reconcileOpen: z.int(),
    trips: z.int(),
    completedTrips: z.int(),
    seats: z.int(),
    ticketsSold: z.int(),
    /** Chuyến có vé bị nhà xe hủy (theo giờ khởi hành trong kỳ). */
    operatorCancelledTrips: z.int(),
    tripsWithSales: z.int(),
  }),
  byOperator: z.array(
    z.object({
      operatorId: z.uuid(),
      operatorName: z.string(),
      trips: z.int(),
      ticketsSold: z.int(),
      seats: z.int(),
      gmv: z.int(),
      refunded: z.int(),
    }),
  ),
  paymentMethods: z.array(z.object({ provider: z.enum(PaymentProvider), amount: z.int(), count: z.int() })),
});
export type AdminReport = z.infer<typeof AdminReportSchema>;
/** Báo cáo toàn hệ thống trong kỳ. */
export class AdminReportDto extends createZodDto(AdminReportSchema) {}

export const AdminOverviewSchema = z.object({
  gmv: z.int(),
  /** GMV kỳ liền trước cùng độ dài — so sánh tăng / giảm. */
  previousGmv: z.int(),
  bookings: z.object({ total: z.int(), confirmed: z.int(), cancelledOrExpired: z.int() }),
  tickets: z.object({ issued: z.int(), refunded: z.int() }),
  escrow: z.object({
    /** Số dư sổ giữ hộ hiện tại. */
    held: z.int(),
    /** Đã tới mốc chi trả, chưa vào kỳ chi trả nào. */
    eligible: z.int(),
    /** Chưa tới mốc chi trả (BR-32). */
    pending: z.int(),
    /** Booking đang có yêu cầu hoàn tiền mở. */
    onHold: z.int(),
    /** Hoa hồng ghi nhận trong kỳ (trừ phần trả lại khi hoàn). */
    commissionInRange: z.int(),
  }),
  daily: z.array(z.object({ date: z.iso.date(), gmv: z.int() })),
  queues: z.object({ payoutsPendingReview: z.int(), refundsFailed: z.int(), reconcileOpen: z.int() }),
});
export type AdminOverview = z.infer<typeof AdminOverviewSchema>;
/** Số liệu trang Tổng quan nền tảng (Figma ADM-01). */
export class AdminOverviewDto extends createZodDto(AdminOverviewSchema) {}
