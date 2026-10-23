import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { BookingStatus, SeatType, TicketStatus } from "../../database/prisma.types";
import { PhoneSchema } from "../../booking/dto/booking.dto";

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

export const TicketLookupInputSchema = z
  .object({
    bookingCode: z
      .string()
      .trim()
      .transform((value) => value.toUpperCase().replace(/-/g, ""))
      .pipe(z.string().regex(/^VXN[A-Z0-9]{6}$/, "Mã booking không hợp lệ.")),
    /** Số điện thoại HOẶC email liên hệ lúc đặt (đúng một). */
    phone: PhoneSchema.optional(),
    email: z.email().max(254).optional(),
  })
  .refine((input) => Boolean(input.phone) !== Boolean(input.email), { message: "Nhập số điện thoại hoặc email liên hệ." });
export type TicketLookupInput = z.infer<typeof TicketLookupInputSchema>;
/** Tra cứu vé bằng mã booking + liên hệ. */
export class TicketLookupInputDto extends createZodDto(TicketLookupInputSchema) {}
