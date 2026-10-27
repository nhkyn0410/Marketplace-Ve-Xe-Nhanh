import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { BookingStatus, SeatType, TicketStatus } from "../../database/prisma.types";

// API §7.2 `/tickets/{ticketId}` + `/guest/ticket-lookup` (TASK-BTP-004, FR-BTP-11, UC-07).

const StopSchema = z.object({ sequence: z.int(), name: z.string(), address: z.string(), plannedAt: z.iso.datetime() });

export const TicketResponseSchema = z.object({
  ticketId: z.uuid(),
  ticketCode: z.string(),
  status: z.enum(TicketStatus),
  seatCode: z.string(),
  seatType: z.enum(SeatType),
  passengerName: z.string(),
  bookingId: z.uuid(),
  bookingCode: z.string(),
  bookingStatus: z.enum(BookingStatus),
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
  /** Nội dung mã QR (không chứa dữ liệu vé; xác thực ở server khi soát vé — BR-29). */
  qrToken: z.string(),
  issuedAt: z.iso.datetime(),
  checkedInAt: z.iso.datetime().nullable(),
});
export type TicketResponse = z.infer<typeof TicketResponseSchema>;
/** Vé điện tử. */
export class TicketResponseDto extends createZodDto(TicketResponseSchema) {}

/** Mã đặt vé, hoặc mã vé (mã đặt vé + "-01") như ô nhập của Figma B1 — mã vé quy về đơn chứa nó. */
const BookingCodeField = z
  .string()
  .trim()
  .transform((value) => value.toUpperCase().replace(/-\d{2,3}$/, "").replace(/-/g, ""))
  .pipe(z.string().regex(/^VXN[A-Z0-9]{6}$/, "Mã booking không hợp lệ."));

// Tra cứu vé khách vãng lai bắt buộc OTP (UX-OQ-09, Khanh 26/10/2026): email liên hệ (+ mã đặt vé nếu có — không bắt
// buộc từ 27/10/2026) → mã 6 số gửi về email đó → phiên tra cứu 15 phút. Chỉ email (SMS hoãn v1 — ADR-020).

export const TicketLookupOtpInputSchema = z.object({ bookingCode: BookingCodeField.optional(), email: z.email().max(254) });
export type TicketLookupOtpInput = z.infer<typeof TicketLookupOtpInputSchema>;
/** Gửi mã xác minh tra cứu vé. */
export class TicketLookupOtpInputDto extends createZodDto(TicketLookupOtpInputSchema) {}

export const TicketLookupOtpResponseSchema = z.object({
  /** Email đã nhập, che bớt — trả như nhau dù email / mã đặt vé có đơn hay không. */
  maskedEmail: z.string(),
  expiresInSeconds: z.int(),
  resendAfterSeconds: z.int(),
  maxAttempts: z.int(),
});
export type TicketLookupOtpResponse = z.infer<typeof TicketLookupOtpResponseSchema>;
/** Phản hồi trung tính của bước gửi mã. */
export class TicketLookupOtpResponseDto extends createZodDto(TicketLookupOtpResponseSchema) {}

export const TicketLookupVerifyInputSchema = TicketLookupOtpInputSchema.extend({ otp: z.string().regex(/^\d{6}$/, "Mã xác minh gồm 6 chữ số.") });
export type TicketLookupVerifyInput = z.infer<typeof TicketLookupVerifyInputSchema>;
/** Xác minh mã tra cứu vé. */
export class TicketLookupVerifyInputDto extends createZodDto(TicketLookupVerifyInputSchema) {}

export const TicketLookupSessionSchema = z.object({
  /** Bí mật của phiên tra cứu — chỉ giữ ở máy chủ web (cookie httpOnly), không đưa vào URL. */
  lookupToken: z.string(),
  expiresAt: z.iso.datetime(),
});
export type TicketLookupSession = z.infer<typeof TicketLookupSessionSchema>;
/** Phiên tra cứu sau khi xác minh mã. */
export class TicketLookupSessionDto extends createZodDto(TicketLookupSessionSchema) {}

const LookupTokenField = z.string().min(20).max(100);

export const TicketLookupSessionInputSchema = z.object({ lookupToken: LookupTokenField });
export type TicketLookupSessionInput = z.infer<typeof TicketLookupSessionInputSchema>;
/** Phiên tra cứu đã xác minh. */
export class TicketLookupSessionInputDto extends createZodDto(TicketLookupSessionInputSchema) {}

export const TicketLookupInputSchema = z.object({
  lookupToken: LookupTokenField,
  /** Bắt buộc khi phiên mở bằng email (không mã đặt vé): đơn phải thuộc danh sách của phiên. */
  bookingId: z.uuid().optional(),
});
export type TicketLookupInput = z.infer<typeof TicketLookupInputSchema>;
/** Đọc booking + vé bằng phiên tra cứu đã xác minh. */
export class TicketLookupInputDto extends createZodDto(TicketLookupInputSchema) {}

export const TicketLookupAccessSchema = z.object({
  bookingId: z.uuid(),
  /** Mã truy cập phụ — gửi ở header `X-Booking-Token` để xem đơn / vé, hủy vé, gửi khiếu nại; trả MỘT lần. */
  accessToken: z.string(),
  /** Hết hạn cùng phiên tra cứu. */
  expiresAt: z.iso.datetime(),
});
export type TicketLookupAccess = z.infer<typeof TicketLookupAccessSchema>;
/** Quyền thao tác một đơn sau khi xác minh OTP tra cứu vé. */
export class TicketLookupAccessDto extends createZodDto(TicketLookupAccessSchema) {}

export const TicketLookupBookingListSchema = z.object({
  maskedEmail: z.string(),
  /** `BOOKING`: phiên mở bằng mã đặt vé — chỉ đơn đó; `EMAIL`: các đơn của email trong 12 tháng gần nhất. */
  scope: z.enum(["BOOKING", "EMAIL"]),
  /** Email đã có tài khoản hành khách đang hoạt động — chỉ trả sau khi xác minh email, để gợi ý đăng nhập. */
  hasAccount: z.boolean(),
  items: z.array(
    z.object({
      bookingId: z.uuid(),
      bookingCode: z.string(),
      status: z.enum(BookingStatus),
      routeName: z.string(),
      operatorName: z.string(),
      departureAt: z.iso.datetime(),
      ticketCount: z.int(),
      /** VND. */
      total: z.int(),
      /** Đơn đặt khi đã đăng nhập tài khoản. */
      bookedWithAccount: z.boolean(),
      createdAt: z.iso.datetime(),
    }),
  ),
});
export type TicketLookupBookingList = z.infer<typeof TicketLookupBookingListSchema>;
/** Danh sách đơn của phiên tra cứu. */
export class TicketLookupBookingListDto extends createZodDto(TicketLookupBookingListSchema) {}
