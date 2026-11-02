import { z } from "zod";

export const TripDepartureInputSchema = z.object({
  note: z.string().trim().max(500).nullable().optional(),
});
export type TripDepartureInput = z.infer<typeof TripDepartureInputSchema>;

export const TripDepartureSchema = z.object({
  tripId: z.uuid(),
  departedAt: z.iso.datetime(),
});
export type TripDeparture = z.infer<typeof TripDepartureSchema>;
