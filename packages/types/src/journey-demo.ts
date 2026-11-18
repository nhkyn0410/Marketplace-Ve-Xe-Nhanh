import { z } from "zod";

/** Trạng thái trình bày của bản demo, không phải trạng thái chuyến/vé. */
export const JourneyDemoSnapshotSchema = z.object({
  type: z.literal("journey_demo"),
  // Numeric const enums are decoded as strings by the Dart generator; retain numeric wire format.
  schemaVersion: z.int().min(1).max(1),
  sessionId: z.uuid(),
  bookingId: z.uuid(),
  revision: z.number().int().min(0).max(7),
  stage: z.enum(["approaching", "travelling", "arrived", "stopped"]),
  routeLabel: z.string().min(1).max(300),
  provinceName: z.string().min(1).max(120),
  etaAt: z.iso.datetime(),
  progress: z.number().int().min(0).max(1000),
  updatedAt: z.iso.datetime(),
  expiresAt: z.iso.datetime(),
  ended: z.boolean(),
});
export const JourneyDemoStartSchema = z.object({ bookingId: z.uuid(), deviceId: z.uuid() }).strict();
export const JourneyDemoQuerySchema = z.object({ deviceId: z.uuid() }).strict();
export const JourneyDemoCurrentSchema = JourneyDemoSnapshotSchema.nullable();
export type JourneyDemoSnapshot = z.infer<typeof JourneyDemoSnapshotSchema>;
export type JourneyDemoStart = z.infer<typeof JourneyDemoStartSchema>;
