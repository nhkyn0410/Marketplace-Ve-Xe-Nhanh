import { z } from "zod";

/** Số đồng VND nguyên biểu diễn bằng chuỗi, tránh mất chính xác trong JSON. */
export const CounterMoneySchema = z.string().regex(/^(0|[1-9]\d{0,18})$/).refine((value) => !/^(0|[1-9]\d{0,18})$/.test(value) || BigInt(value) <= 9_223_372_036_854_775_807n, "Số tiền vượt phạm vi lưu trữ.");
const phone = z.string().transform((value) => value.replace(/[\s.-]/g, "")).pipe(z.string().regex(/^(0|\+84)\d{9}$/));
const name = z.string().trim().min(1).max(100);
const seatCode = z.string().trim().toUpperCase().regex(/^[A-Z0-9-]{1,10}$/);
const stop = z.object({ sequence: z.int(), name: z.string(), plannedAt: z.iso.datetime() });
const contact = z.object({ fullName: name, phone, email: z.email().max(254).nullable() });

export const CounterTripsQuerySchema = z.object({ officeId: z.uuid(), date: z.iso.date() });
export type CounterTripsQuery = z.infer<typeof CounterTripsQuerySchema>;
export const CounterTripSchema = z.object({
  tripId: z.uuid(), routeName: z.string(), departureAt: z.iso.datetime(), arrivalAt: z.iso.datetime(), status: z.enum(["OPEN_FOR_SALE", "BOARDING"]), vehiclePlateNumber: z.string().nullable(),
  stops: z.array(stop.extend({ allowPickup: z.boolean(), allowDropoff: z.boolean() })),
  seats: z.array(z.object({ code: z.string(), type: z.enum(["SEAT", "BED", "BED_DOUBLE", "CABIN", "CABIN_DOUBLE"]), status: z.string(), price: CounterMoneySchema.nullable() })),
});
export type CounterTrip = z.infer<typeof CounterTripSchema>;
export const CounterTripListSchema = z.object({ items: z.array(CounterTripSchema) });

export const CounterHoldInputSchema = z.object({
  officeId: z.uuid(), tripId: z.uuid(), seatCodes: z.array(seatCode).min(1).max(10), pickupSequence: z.int().positive(), dropoffSequence: z.int().positive(),
}).refine((value) => new Set(value.seatCodes).size === value.seatCodes.length && value.pickupSequence < value.dropoffSequence, "Chỗ và điểm đón trả không hợp lệ.");
export type CounterHoldInput = z.infer<typeof CounterHoldInputSchema>;
export const CounterHoldSchema = z.object({
  holdId: z.uuid(), officeId: z.uuid(), tripId: z.uuid(), pickup: stop, dropoff: stop,
  seats: z.array(z.object({ code: z.string(), type: z.enum(["SEAT", "BED", "BED_DOUBLE", "CABIN", "CABIN_DOUBLE"]), price: CounterMoneySchema })), subtotal: CounterMoneySchema, expiresAt: z.iso.datetime(),
});
export type CounterHold = z.infer<typeof CounterHoldSchema>;

export const CounterBookingInputSchema = z.object({
  holdId: z.uuid(), contact,
  passengers: z.array(z.object({ seatCode, fullName: name, phone: phone.nullable() })).min(1).max(10),
  note: z.string().trim().max(500).nullable(), expectedTotal: CounterMoneySchema,
}).refine((value) => new Set(value.passengers.map((passenger) => passenger.seatCode)).size === value.passengers.length, "Mỗi chỗ một hành khách.");
export type CounterBookingInput = z.infer<typeof CounterBookingInputSchema>;
export const CounterReceiptInputSchema = z.object({
  idempotencyKey: z.uuid(), method: z.enum(["CASH", "BANK_TRANSFER"]),
  amount: CounterMoneySchema.refine((value) => !/^(0|[1-9]\d{0,18})$/.test(value) || BigInt(value) > 0n, "Số tiền phải lớn hơn không."),
  reference: z.string().trim().toUpperCase().min(3).max(100).nullable(),
}).superRefine((value, ctx) => {
  if (value.method === "BANK_TRANSFER" && !value.reference) ctx.addIssue({ code: "custom", path: ["reference"], message: "Cần mã giao dịch đã đối chiếu." });
  if (value.method === "CASH" && value.reference !== null) ctx.addIssue({ code: "custom", path: ["reference"], message: "Thu tiền mặt không dùng tham chiếu chuyển khoản." });
});
export type CounterReceiptInput = z.infer<typeof CounterReceiptInputSchema>;
export const CounterReceiptSchema = z.object({ id: z.uuid(), method: z.enum(["CASH", "BANK_TRANSFER"]), amount: CounterMoneySchema, reference: z.string().nullable(), status: z.enum(["COMPLETED", "EXCEPTION"]), exceptionReason: z.string().nullable(), createdAt: z.iso.datetime() });
export const CounterBookingSchema = z.object({
  bookingId: z.uuid(), bookingCode: z.string(), officeId: z.uuid(), seller: z.string(), status: z.string(), tripId: z.uuid(),
  trip: z.object({ routeName: z.string(), departureAt: z.iso.datetime(), arrivalAt: z.iso.datetime() }),
  contact, passengers: z.array(z.object({ seatCode: z.string(), fullName: z.string(), price: CounterMoneySchema })),
  total: CounterMoneySchema, expiresAt: z.iso.datetime(), createdAt: z.iso.datetime(),
  tickets: z.array(z.object({ ticketId: z.uuid(), ticketCode: z.string(), seatCode: z.string(), passengerName: z.string(), status: z.string(), qrToken: z.string() })),
  receipts: z.array(CounterReceiptSchema),
});
export type CounterBooking = z.infer<typeof CounterBookingSchema>;
export const CounterBookingListQuerySchema = z.object({ officeId: z.uuid(), cursor: z.uuid().optional(), limit: z.coerce.number().int().min(1).max(100).default(50) });
export const CounterBookingListSchema = z.object({ items: z.array(CounterBookingSchema), nextCursor: z.uuid().nullable() });
export const CounterReceiptResultSchema = z.object({ receiptId: z.uuid(), status: z.enum(["COMPLETED", "EXCEPTION"]), exceptionReason: z.string().nullable(), booking: CounterBookingSchema });
export type CounterReceiptResult = z.infer<typeof CounterReceiptResultSchema>;

const reportAmounts = { cash: CounterMoneySchema, bankTransfer: CounterMoneySchema, exceptions: CounterMoneySchema, commission: CounterMoneySchema };
export const CounterReportSchema = z.object({ ...reportAmounts, receipts: z.int().nonnegative(), sellers: z.array(z.object({ seller: z.string(), ...reportAmounts })) });
export type CounterReport = z.infer<typeof CounterReportSchema>;
