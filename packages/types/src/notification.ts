import { z } from "zod";

export const NotificationKinds = ["BOOKING_CONFIRMED", "TICKETS_CANCELLED", "REFUND_SUCCEEDED", "TRIP_CHANGED", "TRIP_CANCELLED", "MANUAL_REFUND", "CASE_UPDATED", "OPERATIONS_ALERT", "LOYALTY_UPDATED", "PROMOTION"] as const;
export const NotificationPreferenceInputSchema = z.object({ kind: z.enum(NotificationKinds), email: z.boolean(), push: z.boolean() });
export const NotificationPreferencesSchema = z.object({ items: z.array(NotificationPreferenceInputSchema.extend({ mandatory: z.boolean() })) });
export const PushDeviceInputSchema = z.object({ provider: z.enum(["FCM", "APNS"]), token: z.string().trim().min(16).max(4096).regex(/^[A-Za-z0-9_:.-]+$/) });
export const NotificationLogQuerySchema = z.object({ offset: z.coerce.number().int().min(0).max(100000).default(0), limit: z.coerce.number().int().min(1).max(100).default(25) });
export const NotificationLogSchema = z.object({ items: z.array(z.object({ id: z.string(), notificationId: z.string(), kind: z.enum(NotificationKinds), channel: z.enum(["EMAIL", "PUSH", "SMS"]), recipientMasked: z.string(), status: z.enum(["PENDING", "SENT", "FAILED", "SKIPPED"]), attempts: z.number().int(), lastError: z.string().nullable(), createdAt: z.iso.datetime(), sentAt: z.iso.datetime().nullable() })), total: z.number().int(), offset: z.number().int(), limit: z.number().int() });

export type NotificationPreferenceInput = z.infer<typeof NotificationPreferenceInputSchema>;
export type PushDeviceInput = z.infer<typeof PushDeviceInputSchema>;
