import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { BookingStatus, PaymentProvider, PaymentStatus, RefundStatus, SeatType, TicketStatus } from "../../database/prisma.types";
import { MAX_PASSENGERS } from "../../marketplace/dto/public-trip.dto";
import { SeatCodeSchema } from "../../vehicle/dto/seat-map.dto";

// API §7.2 `/bookings*` — tạo + xem booking (TASK-BTP-002, LLD §6.2, FR-BTP-05/06). Khách vãng lai hoặc hành khách.

/** Số điện thoại VN: `0xxxxxxxxx` hoặc `+84xxxxxxxxx` (lưu như người dùng nhập sau khi bỏ khoảng trắng). */
export const PhoneSchema = z
  .string()
  .transform((value) => value.replace(/[\s.-]/g, ""))
  .pipe(z.string().regex(/^(0|\+84)\d{9}$/, "Số điện thoại không hợp lệ."));
const NameSchema = z.string().trim().min(1).max(100);

export const BookingInputSchema = z
  .object({
    holdId: z.uuid(),
    contact: z.object({ fullName: NameSchema, phone: PhoneSchema, email: z.email().max(254) }),
    /** Mỗi chỗ đã giữ đúng một hành khách. */
    passengers: z
      .array(z.object({ seatCode: SeatCodeSchema, fullName: NameSchema, phone: PhoneSchema.nullable() }))
      .min(1)
      .max(MAX_PASSENGERS),
    /** Ghi chú cho nhà xe (đón dọc đường, hành lý…). */
    note: z
      .string()
      .trim()
      .max(500)
      .nullable()
      .transform((value) => value || null),
    /**
     * Tổng tiền khách đã thấy (VND). Giá lúc đặt khác số này (bảng giá vừa đổi) → 409 `BOOKING_SNAPSHOT_CHANGED`; khách xem
     * giá mới (`GET /seat-holds/{holdId}`) rồi gửi lại — không tự thu khác số khách đã đồng ý.
     */
    expectedTotal: z.int().min(0),
  })
  .superRefine((input, ctx) => {
    const codes = input.passengers.map((passenger) => passenger.seatCode);
    if (new Set(codes).size !== codes.length) {
      ctx.addIssue({ code: "custom", path: ["passengers"], message: "Mỗi chỗ một hành khách." });
    }
  });
export type BookingInput = z.infer<typeof BookingInputSchema>;
/** Body tạo booking từ phiên giữ chỗ. */
export class BookingInputDto extends createZodDto(BookingInputSchema) {}

const StopSchema = z.object({ sequence: z.int(), name: z.string(), address: z.string(), plannedAt: z.iso.datetime() });

export const BookingResponseSchema = z.object({
  bookingId: z.uuid(),
  bookingCode: z.string(),
  status: z.enum(BookingStatus),
  tripId: z.uuid(),
  trip: z.object({
    routeName: z.string(),
    operatorName: z.string(),
    operatorHotline: z.string().nullable(),
    vehicleTypeName: z.string(),
    departureAt: z.iso.datetime(),
    arrivalAt: z.iso.datetime(),
  }),
  pickup: StopSchema,
  dropoff: StopSchema,
  contact: z.object({ fullName: z.string(), phone: z.string(), email: z.string() }),
  passengers: z.array(z.object({ seatCode: z.string(), seatType: z.enum(SeatType), fullName: z.string(), phone: z.string().nullable(), price: z.int() })),
  note: z.string().nullable(),
  /** VND: tổng giá vé, phí dịch vụ (v1 = 0, vẫn tách dòng — CO-12), giảm giá, số phải trả. */
  subtotal: z.int(),
  serviceFee: z.int(),
  discount: z.int(),
  total: z.int(),
  /** Mốc hủy / hoàn chụp lúc đặt (BR-07) — áp cho booking này dù chính sách đổi sau. */
  cancellationPolicy: z.object({ tiers: z.array(z.object({ minHoursBefore: z.int(), refundPercent: z.int() })) }),
  /** Hạn thanh toán (= hạn giữ chỗ còn lại lúc đặt); quá hạn booking thành `EXPIRED`, chỗ được trả lại. */
  expiresAt: z.iso.datetime(),
  /** Payment thành công, không có thì lần gần nhất (BTP-003) — trang kết quả thanh toán đọc ở đây; `null` = chưa thanh toán. */
  payment: z
    .object({
      paymentCode: z.string(),
      provider: z.enum(PaymentProvider),
      status: z.enum(PaymentStatus),
      amount: z.int(),
      paidAt: z.iso.datetime().nullable(),
    })
    .nullable(),
  /**
   * Vé điện tử (BTP-004) — có sau khi thanh toán thành công (`CONFIRMED`), mỗi chỗ một vé. `qrToken` = nội dung mã QR
   * (không chứa dữ liệu vé; nhân viên soát vé xác thực ở server).
   */
  tickets: z.array(
    z.object({
      ticketId: z.uuid(),
      ticketCode: z.string(),
      seatCode: z.string(),
      passengerName: z.string(),
      status: z.enum(TicketStatus),
      qrToken: z.string(),
    }),
  ),
  /** Các lần hoàn tiền (BTP-005), cũ trước. */
  refunds: z.array(z.object({ refundCode: z.string(), amount: z.int(), status: z.enum(RefundStatus), createdAt: z.iso.datetime() })),
  createdAt: z.iso.datetime(),
});
export type BookingResponse = z.infer<typeof BookingResponseSchema>;
/** Booking. */
export class BookingResponseDto extends createZodDto(BookingResponseSchema) {}

export const CreatedBookingSchema = BookingResponseSchema.extend({
  /**
   * Mã truy cập booking — trả MỘT lần; khách vãng lai gửi ở header `X-Booking-Token` để xem / thanh toán (hành khách đăng
   * nhập dùng token đăng nhập). Không lưu nguyên văn ở server.
   */
  accessToken: z.string(),
});
export type CreatedBooking = z.infer<typeof CreatedBookingSchema>;
/** Booking vừa tạo kèm mã truy cập. */
export class CreatedBookingDto extends createZodDto(CreatedBookingSchema) {}
