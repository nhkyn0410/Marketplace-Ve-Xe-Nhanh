import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TripChangeKind } from "../../database/prisma.types";
import { MAX_ROUTE_STOPS } from "../../route/dto/route.dto";
import { arrivalYearOverflows, InstantSchema } from "./trip.dto";

// Đổi / hủy chuyến đã bán vé (TASK-TRN-008, FR-OPS-11..12, BR-10/12/20, BF-06, UC-14 A4). Bảng / API AI tự đề xuất, chờ
// Khanh duyệt (`doc/task-propreties/TRN-008-todo.md`).

const ReasonSchema = z.string().trim().min(3).max(500);

/**
 * Lịch chạy MỚI của chuyến đang bán (gửi đủ như PUT chuyến nháp): giờ đi, giờ từng điểm (tuỳ chọn), xe, điểm của từng thứ
 * tự dừng (đổi điểm đón / trả — giữ nguyên vai trò, quyền đón / trả). Giờ đến máy chủ tính = giờ đi + thời gian chạy của
 * tuyến (27/10/2026, chờ duyệt). Máy chủ so với hiện tại để biết đổi gì; không đổi gì → 422. Tuyến không đổi được (vé gắn
 * theo thứ tự điểm của tuyến).
 */
export const TripChangeInputSchema = z
  .object({
    departureAt: InstantSchema,
    stopTimes: z.array(InstantSchema).min(2).max(MAX_ROUTE_STOPS).nullable(),
    vehicleId: z.uuid(),
    stops: z
      .array(z.object({ sequence: z.int().min(1), catalogStopPointId: z.uuid().nullable(), stopPointId: z.uuid().nullable() }))
      .min(2)
      .max(MAX_ROUTE_STOPS),
    /** Lý do (BR-10) — gửi hành khách bị ảnh hưởng + lưu lịch sử + audit. */
    reason: ReasonSchema,
  })
  .superRefine((input, ctx) => {
    input.stops.forEach((stop, index) => {
      if ((stop.catalogStopPointId === null) === (stop.stopPointId === null)) {
        ctx.addIssue({ code: "custom", path: ["stops", index], message: "Chọn đúng một điểm (dùng chung hoặc của nhà xe)." });
      }
    });
    if (!(input.departureAt instanceof Date)) {
      return;
    }
    const departure = input.departureAt.getTime();
    if (departure <= Date.now()) {
      ctx.addIssue({ code: "custom", path: ["departureAt"], message: "Giờ khởi hành phải ở tương lai." });
    } else if (arrivalYearOverflows(departure)) {
      ctx.addIssue({ code: "custom", path: ["departureAt"], message: "Năm phải trong khoảng 1970–9999." });
    }
    const times = input.stopTimes;
    if (times && times.every((time) => time instanceof Date)) {
      if (times[0]!.getTime() !== departure) {
        ctx.addIssue({ code: "custom", path: ["stopTimes"], message: "Điểm đầu/cuối phải trùng giờ đi/giờ đến." });
      }
      times.forEach((time, index) => {
        if (index > 0 && time.getTime() < times[index - 1]!.getTime()) {
          ctx.addIssue({ code: "custom", path: ["stopTimes", index], message: "Giờ tại các điểm không được giảm dần." });
        }
      });
    }
  });
export type TripChangeInput = z.infer<typeof TripChangeInputSchema>;
/** Body đổi chuyến đang bán / đã bán vé. */
export class TripChangeInputDto extends createZodDto(TripChangeInputSchema) {}

export const TripCancelInputSchema = z.object({ reason: ReasonSchema });
/** Body hủy chuyến (có vé thì hoàn 100% cho khách). */
export class TripCancelInputDto extends createZodDto(TripCancelInputSchema) {}

const ScheduleSchema = z.object({
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  vehiclePlateNumber: z.string().nullable(),
  stops: z.array(z.object({ sequence: z.int(), name: z.string() })),
});

export const TripSalesSchema = z.object({
  /** Chỗ đã bán (đã thanh toán / đã check-in). */
  soldSeats: z.int(),
  /** Chỗ đang giữ cho đơn chờ thanh toán. */
  holdingSeats: z.int(),
  /** Đơn có vé còn hiệu lực — bị ảnh hưởng khi đổi / hủy chuyến. */
  activeBookings: z.int(),
  /** Đơn chờ thanh toán — hủy chuyến thì đơn bị hủy, không trừ tiền. */
  pendingBookings: z.int(),
  /** VND — phần khách thực trả của vé còn hiệu lực, trừ các khoản hoàn trước (số hoàn nếu hủy chuyến). */
  refundOnCancel: z.int(),
  /** Lịch sử đổi / hủy chuyến, mới trước. `actor`: tên đăng nhập người đổi. */
  changes: z.array(
    z.object({
      id: z.uuid(),
      kinds: z.array(z.enum(TripChangeKind)),
      before: ScheduleSchema,
      after: ScheduleSchema,
      reason: z.string(),
      affectedBookings: z.int(),
      actor: z.string().nullable(),
      createdAt: z.iso.datetime(),
    }),
  ),
});
export type TripSales = z.infer<typeof TripSalesSchema>;
/** Tình hình bán của chuyến + lịch sử đổi / hủy (Operator OS hiện trước khi đổi / hủy). */
export class TripSalesDto extends createZodDto(TripSalesSchema) {}
