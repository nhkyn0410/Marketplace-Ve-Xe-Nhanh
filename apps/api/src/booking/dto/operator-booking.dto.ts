import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { BookingStatus, PaymentProvider, PaymentStatus, SeatType, TicketStatus } from "../../database/prisma.types";

// API §7.3 `/operator/bookings*`, `/operator/trips/{tripId}/passengers*` — màn Đặt vé của nhà xe (TASK-OPR-003, FR-OPS-14/15,
// UC-15; Figma "Nhà xe · Đặt vé" 01–03). Số điện thoại / email che mặc định; xem đầy đủ / xuất danh sách ghi audit.

export class OperatorBookingListQueryDto extends createZodDto(
  z.object({
    /** Ngày khởi hành của chuyến theo giờ Việt Nam. */
    date: z.iso.date(),
    tripId: z.uuid().optional(),
    status: z.enum(BookingStatus).optional(),
    /** Mã đặt vé, mã vé, số điện thoại (chữ số) hoặc tên người liên hệ. */
    q: z.string().trim().min(1).max(100).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

const TripRefSchema = z.object({
  tripId: z.uuid(),
  departureAt: z.iso.datetime(),
  routeName: z.string(),
  vehiclePlateNumber: z.string().nullable(),
});
const PaymentSummarySchema = z.object({ provider: z.enum(PaymentProvider), status: z.enum(PaymentStatus), paidAt: z.iso.datetime().nullable() });

export const OperatorBookingSummarySchema = z.object({
  bookingId: z.uuid(),
  bookingCode: z.string(),
  status: z.enum(BookingStatus),
  createdAt: z.iso.datetime(),
  contactName: z.string(),
  /** Số điện thoại đã che (`0*** *** 567`). */
  contactPhoneMasked: z.string(),
  /** Khách vãng lai (không đăng nhập). */
  guest: z.boolean(),
  trip: TripRefSchema,
  seatCodes: z.array(z.string()),
  cancelledTicketCount: z.int(),
  /** VND — tổng khách phải trả. */
  total: z.int(),
  /** Payment thành công, không có thì lần gần nhất; `null` = chưa thanh toán. */
  payment: PaymentSummarySchema.nullable(),
});
export type OperatorBookingSummary = z.infer<typeof OperatorBookingSummarySchema>;
/** Một đơn đặt vé trong danh sách của nhà xe. */
export class OperatorBookingSummaryDto extends createZodDto(OperatorBookingSummarySchema) {}

export const OperatorBookingPageSchema = z.object({ items: z.array(OperatorBookingSummarySchema), nextCursor: z.uuid().nullable() });
export type OperatorBookingPage = z.infer<typeof OperatorBookingPageSchema>;
/** Một trang đơn đặt vé, mới đặt trước. */
export class OperatorBookingPageDto extends createZodDto(OperatorBookingPageSchema) {}

const StopSchema = z.object({ sequence: z.int(), name: z.string(), address: z.string(), plannedAt: z.iso.datetime() });

export const OperatorBookingDetailSchema = OperatorBookingSummarySchema.extend({
  contactEmailMasked: z.string().nullable(),
  note: z.string().nullable(),
  pickup: StopSchema,
  dropoff: StopSchema,
  /** Mỗi chỗ một dòng; `ticketCode` / `ticketStatus` = `null` khi chưa phát hành vé (chưa thanh toán). */
  seats: z.array(
    z.object({
      seatCode: z.string(),
      seatType: z.enum(SeatType),
      passengerName: z.string(),
      phoneMasked: z.string().nullable(),
      ticketCode: z.string().nullable(),
      ticketStatus: z.enum(TicketStatus).nullable(),
    }),
  ),
  subtotal: z.int(),
  serviceFee: z.int(),
  discount: z.int(),
  /** Bên chịu ưu đãi được chụp lúc đặt. */
  discountFunding: z.enum(["OPERATOR", "PLATFORM"]).nullable().default(null),
  cancellationPolicy: z.object({ tiers: z.array(z.object({ minHoursBefore: z.int(), refundPercent: z.int() })) }),
  /** Lịch sử trạng thái, cũ trước. `actor`: `PASSENGER` / `GUEST` / `SYSTEM` / `PROVIDER` / `PLATFORM`. */
  histories: z.array(
    z.object({ fromStatus: z.enum(BookingStatus).nullable(), toStatus: z.enum(BookingStatus), reason: z.string().nullable(), actor: z.string(), createdAt: z.iso.datetime() }),
  ),
});
export type OperatorBookingDetail = z.infer<typeof OperatorBookingDetailSchema>;
/** Chi tiết đơn đặt vé (liên hệ đã che). */
export class OperatorBookingDetailDto extends createZodDto(OperatorBookingDetailSchema) {}

export const BookingContactSchema = z.object({
  fullName: z.string(),
  phone: z.string(),
  email: z.string().nullable(),
  passengers: z.array(z.object({ seatCode: z.string(), phone: z.string().nullable() })),
});
export type BookingContact = z.infer<typeof BookingContactSchema>;
/** Liên hệ đầy đủ của đơn (mỗi lần xem ghi audit). */
export class BookingContactDto extends createZodDto(BookingContactSchema) {}

export class TripPassengerQueryDto extends createZodDto(
  z.object({
    pickupSequence: z.coerce.number().int().min(1).optional(),
    ticketStatus: z.enum(TicketStatus).optional(),
    /** Tên hành khách, mã vé hoặc số điện thoại (chữ số). */
    q: z.string().trim().min(1).max(100).optional(),
  }),
) {}

export const TripPassengerListSchema = z.object({
  trip: TripRefSchema.extend({ seatCount: z.int() }),
  /** Đếm trên cả chuyến (không theo bộ lọc). */
  summary: z.object({ sold: z.int(), checkedIn: z.int(), notBoarded: z.int(), noShow: z.int() }),
  /** Điểm đón của chuyến (cho ô lọc). */
  pickups: z.array(z.object({ sequence: z.int(), name: z.string() })),
  items: z.array(
    z.object({
      seatCode: z.string(),
      passengerName: z.string(),
      phoneMasked: z.string().nullable(),
      bookingId: z.uuid(),
      bookingCode: z.string(),
      guest: z.boolean(),
      pickup: z.object({ sequence: z.int(), name: z.string() }),
      dropoff: z.object({ sequence: z.int(), name: z.string() }),
      ticketCode: z.string(),
      ticketStatus: z.enum(TicketStatus),
    }),
  ),
});
export type TripPassengerList = z.infer<typeof TripPassengerListSchema>;
/** Hành khách đã có vé của một chuyến, theo mã chỗ. */
export class TripPassengerListDto extends createZodDto(TripPassengerListSchema) {}
