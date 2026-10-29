import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RouteStopRole, SeatType, StopPointType, TripSeatStatus, TripStatus } from "../../database/prisma.types";
import { MAX_ROUTE_STOPS } from "../../route/dto/route.dto";
import { MAX_SEATS, SeatCodeSchema } from "../../vehicle/dto/seat-map.dto";
import { OPERATOR_TARGET_STATUSES } from "../trip-sale";

/** Số phút ngừng bán online trước giờ khởi hành tối đa (một ngày) — AS-20. */
export const MAX_ONLINE_SALE_CUTOFF_MINUTES = 1440;

/**
 * Chuyến dài tối đa 7 ngày (= tổng thời gian tuyến tối đa, route service). Giờ đi phải cách năm 10000 ít nhất chừng đó để
 * giờ đến máy chủ tính ra vẫn trong 1970–9999.
 */
export const MAX_TRIP_DURATION_MS = 7 * 24 * 3_600_000;

/** Giờ đến tính theo tuyến có thể vượt năm 9999 — response schema sẽ từ chối (xem `InstantSchema`). */
export const arrivalYearOverflows = (departure: number) =>
  new Date(departure + MAX_TRIP_DURATION_MS).getUTCFullYear() > 9999;

const optionalText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

// Nhận ISO 8601 có múi giờ (vd `+07:00`) hoặc `Z`; lưu UTC. Chặn năm UTC ngoài 1970–9999 (vd `9999-12-31T23:00-07:00`
// hay `0000-01-01T00:00+01:00`): `toISOString()` khi đó ra `+010000-…` / `-000001-…`, response schema từ chối → GET/list
// của tenant trả 500. Fare là nơi đầu tiên nhận mốc quá khứ (khung giờ giá).
/** Giờ vào API: ISO 8601 có múi giờ → `Date` UTC, năm 1970–9999 (dùng chung cho trip và fare). */
export const InstantSchema = z.iso
  .datetime({ offset: true })
  .transform((value) => new Date(value))
  .refine((date) => date.getUTCFullYear() >= 1970 && date.getUTCFullYear() <= 9999, "Năm phải trong khoảng 1970–9999.");
const instant = InstantSchema;

// Không `.default()`: POST và PUT (thay toàn bộ) phải gửi đủ trường — PUT thiếu trường không được âm thầm đưa về mặc
// định. Trạng thái không nằm trong body: chỉ tạo/sửa chuyến `DRAFT`; đổi trạng thái qua `PUT …/status` (TRN-006).
// Giờ đến KHÔNG nằm trong body (Khanh 27/10/2026, chờ duyệt): máy chủ tính = giờ đi + thời gian chạy của tuyến
// (`routeArrival`); body cũ còn gửi `arrivalAt` thì trường đó bị bỏ qua.
export const TripInputSchema = z
  .object({
    routeId: z.uuid(),
    /** Để trống khi chưa gắn xe (Q3); bắt buộc lúc mở bán (TRN-006). */
    vehicleId: z.uuid().nullable(),
    departureAt: instant,
    /**
     * Giờ dự kiến tại từng điểm theo thứ tự route. `null` = theo thời gian từng chặng của route. Nếu gửi: điểm đầu =
     * giờ đi, điểm cuối = giờ đến tính theo tuyến (kiểm ở service), không giảm dần.
     */
    stopTimes: z.array(instant).min(2).max(MAX_ROUTE_STOPS).nullable(),
    /** Số phút trước giờ khởi hành thì ngừng bán online (AS-20, 0–1440; UI gợi ý 60). */
    onlineSaleCutoffMinutes: z.int().min(0).max(MAX_ONLINE_SALE_CUTOFF_MINUTES),
    note: optionalText(500),
    /**
     * Chặng mở bán (3.3): tuyến con ĐANG BẬT của đúng tuyến này mà chuyến bán thêm theo giá riêng. Thiếu = không bán theo chặng
     * (client cũ vẫn chạy).
     */
    subRouteIds: z.array(z.uuid()).max(50).default([]),
  })
  .superRefine((input, ctx) => {
    if (new Set(input.subRouteIds).size !== input.subRouteIds.length) {
      ctx.addIssue({ code: "custom", path: ["subRouteIds"], message: "Tuyến con bị lặp." });
    }
    // Zod 4 vẫn chạy refine khi một field datetime sai định dạng (giá trị còn là chuỗi, chưa transform) —
    // lỗi định dạng đã được báo, bỏ qua phần so sánh giờ.
    const times = input.stopTimes;
    if (!(input.departureAt instanceof Date)) {
      return;
    }
    const departure = input.departureAt.getTime();
    if (departure <= Date.now()) {
      ctx.addIssue({ code: "custom", path: ["departureAt"], message: "Giờ khởi hành phải ở tương lai." });
    } else if (arrivalYearOverflows(departure)) {
      ctx.addIssue({ code: "custom", path: ["departureAt"], message: "Năm phải trong khoảng 1970–9999." });
    }
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
export type TripInput = z.infer<typeof TripInputSchema>;
/** Body tạo/thay toàn bộ chuyến `DRAFT`: route, xe (tuỳ chọn), giờ đi/đến, giờ từng điểm (tuỳ chọn). */
export class TripInputDto extends createZodDto(TripInputSchema) {}

export const TripStatusInputSchema = z
  .object({
    status: z.enum(OPERATOR_TARGET_STATUSES),
    /** Lý do (hủy bắt buộc — SRS §17.3); lưu `statusReason` + audit. */
    reason: optionalText(500),
  })
  .superRefine((input, ctx) => {
    // Lý do hủy gửi cho khách bị ảnh hưởng + lưu lịch sử đổi / hủy chuyến (TRN-008, CHECK 3–500 ký tự).
    if (input.status === TripStatus.CANCELLED && (!input.reason || input.reason.length < 3)) {
      ctx.addIssue({ code: "custom", path: ["reason"], message: "Hủy chuyến phải có lý do (tối thiểu 3 ký tự)." });
    }
  });
export type TripStatusInput = z.infer<typeof TripStatusInputSchema>;
/** Body đổi trạng thái bán của chuyến: mở bán / khóa / thu hồi nháp / hủy (TRN-006). */
export class TripStatusInputDto extends createZodDto(TripStatusInputSchema) {}

export const TripSeatStatusInputSchema = z
  .object({
    seatCodes: z.array(SeatCodeSchema).min(1).max(MAX_SEATS),
    status: z.enum([TripSeatStatus.BLOCKED, TripSeatStatus.AVAILABLE]),
    /** Ghi chú (vd "bán tại quầy") — chỉ lưu trong audit. */
    note: optionalText(500),
  })
  .superRefine((input, ctx) => {
    if (new Set(input.seatCodes).size !== input.seatCodes.length) {
      ctx.addIssue({ code: "custom", path: ["seatCodes"], message: "Trùng mã ghế." });
    }
  });
export type TripSeatStatusInput = z.infer<typeof TripSeatStatusInputSchema>;
/** Body khóa / mở ghế thủ công theo lô (bán ngoài Platform — BR-42). */
export class TripSeatStatusInputDto extends createZodDto(TripSeatStatusInputSchema) {}

/** Query list chuyến: lọc route/xe/trạng thái/khoảng giờ đi, sắp theo giờ đi, cursor = id chuyến cuối trang. */
export class TripListQueryDto extends createZodDto(
  z.object({
    routeId: z.uuid().optional(),
    vehicleId: z.uuid().optional(),
    status: z.enum(TripStatus).optional(),
    departureFrom: instant.optional(),
    departureTo: instant.optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

const TripSummaryFields = {
  id: z.uuid(),
  routeId: z.uuid(),
  routeName: z.string(),
  vehicleId: z.uuid().nullable(),
  vehiclePlateNumber: z.string().nullable(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  status: z.enum(TripStatus),
  seatCount: z.int(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
};

export const TripListResponseSchema = z.object({
  items: z.array(z.object(TripSummaryFields)),
  nextCursor: z.uuid().nullable(),
});
export type TripListResponse = z.infer<typeof TripListResponseSchema>;
/** Một trang chuyến (không kèm điểm dừng và ghế). */
export class TripListResponseDto extends createZodDto(TripListResponseSchema) {}

export const TripResponseSchema = z.object({
  ...TripSummaryFields,
  onlineSaleCutoffMinutes: z.int(),
  /** Tuyến con chuyến bán thêm theo chặng (3.3). */
  subRouteIds: z.array(z.uuid()),
  /** Lý do lần đổi trạng thái gần nhất (chuyến hủy luôn có). */
  statusReason: z.string().nullable(),
  /** Giờ khởi hành / hoàn thành thực tế do tài xế cập nhật (TASK-EMP-002). */
  departedAt: z.iso.datetime().nullable(),
  completedAt: z.iso.datetime().nullable(),
  note: z.string().nullable(),
  stops: z.array(
    z.object({
      sequence: z.int(),
      role: z.enum(RouteStopRole),
      catalogStopPointId: z.uuid().nullable(),
      stopPointId: z.uuid().nullable(),
      name: z.string(),
      address: z.string(),
      // Loại điểm hiện tại (như route detail): giao diện ghi "Bến xe", "Trạm dừng nghỉ"… cạnh từng điểm.
      type: z.enum(StopPointType),
      plannedAt: z.iso.datetime(),
      pickupWindowStart: z.iso.datetime().nullable(),
      pickupWindowEnd: z.iso.datetime().nullable(),
      // BR-79: chép từ route lúc tạo/sửa chuyến.
      allowPickup: z.boolean(),
      allowDropoff: z.boolean(),
      note: z.string().nullable(),
    }),
  ),
  seats: z.array(
    z.object({
      code: z.string(),
      deck: z.int(),
      row: z.int(),
      column: z.int(),
      type: z.enum(SeatType),
      status: z.enum(TripSeatStatus),
      /** Giá (VND, số nguyên đồng) theo bảng giá của tuyến + loại xe đang gắn; `null` khi chưa xác định (TRN-005). */
      price: z.int().nullable(),
    }),
  ),
});
export type TripResponse = z.infer<typeof TripResponseSchema>;
/** Chi tiết chuyến kèm điểm dừng (giờ dự kiến) và ghế theo chuyến. */
export class TripResponseDto extends createZodDto(TripResponseSchema) {}
