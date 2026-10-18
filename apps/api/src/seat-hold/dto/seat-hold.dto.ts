import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { SeatType } from "../../database/prisma.types";
import { MAX_PASSENGERS } from "../../marketplace/dto/public-trip.dto";
import { SeatCodeSchema } from "../../vehicle/dto/seat-map.dto";

// API §7.2 `/seat-holds*` — giữ chỗ (TASK-BTP-001, LLD §6.1, ADR-015). Khách vãng lai hoặc hành khách đã đăng nhập.

export const SeatHoldInputSchema = z
  .object({
    tripId: z.uuid(),
    seatCodes: z.array(SeatCodeSchema).min(1).max(MAX_PASSENGERS),
    /** `sequence` của điểm đón / trả trong chuyến (từ chi tiết chuyến). */
    pickupSequence: z.int().min(1),
    dropoffSequence: z.int().min(1),
  })
  .superRefine((input, ctx) => {
    if (new Set(input.seatCodes).size !== input.seatCodes.length) {
      ctx.addIssue({ code: "custom", path: ["seatCodes"], message: "Trùng mã chỗ." });
    }
  });
export type SeatHoldInput = z.infer<typeof SeatHoldInputSchema>;
/** Body giữ chỗ: chuyến, các chỗ, điểm đón / trả. */
export class SeatHoldInputDto extends createZodDto(SeatHoldInputSchema) {}

const StopSchema = z.object({ sequence: z.int(), name: z.string(), plannedAt: z.iso.datetime() });

export const SeatHoldResponseSchema = z.object({
  holdId: z.uuid(),
  tripId: z.uuid(),
  pickup: StopSchema,
  dropoff: StopSchema,
  /** Giá lúc giữ chỗ (VND); đặt vé tính lại và báo nếu giá đã đổi. */
  seats: z.array(z.object({ code: z.string(), type: z.enum(SeatType), price: z.int() })),
  subtotal: z.int(),
  /** Hết hạn giữ chỗ — giao diện đếm ngược theo mốc này (giữ chỗ 10 phút theo chính sách, không quá giờ ngừng bán online). */
  expiresAt: z.iso.datetime(),
});
export type SeatHoldResponse = z.infer<typeof SeatHoldResponseSchema>;
/** Giữ chỗ đang hiệu lực. */
export class SeatHoldResponseDto extends createZodDto(SeatHoldResponseSchema) {}
