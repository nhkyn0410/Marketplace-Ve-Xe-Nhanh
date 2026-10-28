import { z } from "zod";

const phone = z.string().trim().regex(/^(0|\+84)\d{9}$/, "Số điện thoại không hợp lệ.");
const name = z.string().trim().min(1).max(100);
export const PassengerProfileUpdateSchema = z.object({
  name: name.optional(),
  phone: phone.nullable().optional(),
  dateOfBirth: z.iso.date().nullable().optional(),
}).strict().refine((value) => Object.keys(value).length > 0, "Cần ít nhất một trường cập nhật.");
export const PassengerProfileSchema = z.object({
  userId: z.string(), name: z.string().nullable(), email: z.email(), emailVerified: z.boolean(),
  phone: z.string().nullable(), dateOfBirth: z.iso.date().nullable(), image: z.string().nullable(),
});
export const SavedPassengerInputSchema = z.object({ fullName: name, phone: phone.nullable().default(null) }).strict();
export const SavedPassengerSchema = z.object({ passengerId: z.uuid(), fullName: z.string(), phone: z.string().nullable() });
export const SavedPassengerListSchema = z.object({ items: z.array(SavedPassengerSchema) });
export const PassengerPageQuerySchema = z.object({
  cursor: z.uuid().optional(), limit: z.coerce.number().int().min(1).max(100).default(20),
});
const bookingSummary = z.object({
  bookingId: z.uuid(), bookingCode: z.string(), operatorId: z.uuid(), operatorName: z.string(),
  tripId: z.uuid(), routeName: z.string(), departureAt: z.iso.datetime(), status: z.string(),
  total: z.string().regex(/^\d+$/), createdAt: z.iso.datetime(),
});
export const PassengerBookingPageSchema = z.object({ items: z.array(bookingSummary), nextCursor: z.uuid().nullable() });
export const PassengerTicketPageSchema = z.object({ items: z.array(z.object({
  ticketId: z.uuid(), ticketCode: z.string(), bookingId: z.uuid(), bookingCode: z.string(),
  operatorName: z.string(), routeName: z.string(), departureAt: z.iso.datetime(),
  seatCode: z.string(), passengerName: z.string(), status: z.string(), issuedAt: z.iso.datetime(),
})), nextCursor: z.uuid().nullable() });
export const PassengerSupportPageSchema = z.object({ items: z.array(z.object({
  ticketId: z.uuid(), ticketCode: z.string(), bookingId: z.uuid(), bookingCode: z.string(),
  subject: z.string(), status: z.string(), updatedAt: z.iso.datetime(),
})), nextCursor: z.uuid().nullable() });
export const PassengerDisputePageSchema = z.object({ items: z.array(z.object({
  disputeId: z.uuid(), disputeCode: z.string(), bookingId: z.uuid(), bookingCode: z.string(),
  title: z.string(), status: z.string(), responseDueAt: z.iso.datetime().nullable(), updatedAt: z.iso.datetime(),
})), nextCursor: z.uuid().nullable() });
const rate = z.number().min(0).max(1).nullable();
export const OperatorScorecardSchema = z.object({
  averageRating: z.number().min(1).max(5).nullable(), reviewCount: z.int().min(0),
  operatorCancellationRate: rate, refundBookingRate: rate, disputeBookingRate: rate,
  checkInRate: rate, noShowRate: rate,
});
export const PublicOperatorProfileSchema = z.object({
  operatorId: z.uuid(), operatorSlug: z.string(), displayName: z.string(),
  /** Logo ở kho công khai; `null` = chưa có logo (hiển thị chữ viết tắt). */
  logoUrl: z.url().nullable(), description: z.string().nullable(),
  hotline: z.string().nullable(), publicEmail: z.string().nullable(), address: z.string().nullable(),
  scorecard: OperatorScorecardSchema,
  routes: z.array(z.object({ routeId: z.uuid(), name: z.string() })),
  serviceTerms: z.object({ title: z.string(), contentMarkdown: z.string() }).nullable(),
  reviews: z.array(z.object({
    reviewId: z.uuid(), authorName: z.string(), rating: z.int().min(1).max(5), comment: z.string().nullable(),
    operatorReply: z.string().nullable(), operatorRepliedAt: z.iso.datetime().nullable(), createdAt: z.iso.datetime(),
  })),
  nextReviewCursor: z.uuid().nullable(),
});
export const DirectDisputeInputSchema = z.object({
  bookingId: z.uuid(), title: z.string().trim().min(3).max(200),
  customerRequest: z.string().trim().min(1).max(1000).nullable().default(null),
  reason: z.string().trim().min(3).max(500),
}).strict();
export type PassengerProfile = z.infer<typeof PassengerProfileSchema>;
export type PassengerProfileUpdate = z.infer<typeof PassengerProfileUpdateSchema>;
export type SavedPassengerInput = z.infer<typeof SavedPassengerInputSchema>;
export type SavedPassenger = z.infer<typeof SavedPassengerSchema>;
export type PassengerPageQuery = z.infer<typeof PassengerPageQuerySchema>;
export type PassengerBookingPage = z.infer<typeof PassengerBookingPageSchema>;
export type PassengerTicketPage = z.infer<typeof PassengerTicketPageSchema>;
export type PassengerSupportPage = z.infer<typeof PassengerSupportPageSchema>;
export type PassengerDisputePage = z.infer<typeof PassengerDisputePageSchema>;
export type PublicOperatorProfile = z.infer<typeof PublicOperatorProfileSchema>;
export type DirectDisputeInput = z.infer<typeof DirectDisputeInputSchema>;
