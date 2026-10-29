import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { TripStatus } from "../../database/prisma.types";
import { daysBetween, MAX_SCHEDULE_SPAN_DAYS, todayInVietnam } from "../trip-schedule-dates";
import { MAX_ONLINE_SALE_CUTOFF_MINUTES } from "./trip.dto";

// API §7.3 `/operator/trip-schedules*` — lịch chuyến lặp lại (TASK-TRN-007, FR-OPS-07, UC-14 bước 7; chờ Khanh duyệt).

const DateOnlySchema = z.iso.date();
const TimeOfDaySchema = z.string().regex(/^([01]\d|2[0-3]):[0-5]\d$/, "Giờ dạng HH:mm.");

const optionalText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

// Không `.default()`: POST và PUT (thay toàn bộ) phải gửi đủ trường (mẫu `TripInputSchema`).
export const TripScheduleInputSchema = z
  .object({
    routeId: z.uuid(),
    /** Để trống thì chuyến sinh ra chưa gắn xe (gắn sau ở từng chuyến). */
    vehicleId: z.uuid().nullable(),
    /** Giờ khởi hành theo giờ Việt Nam. Giờ đến = giờ khởi hành + thời gian chạy của tuyến (máy chủ tính). */
    departureTime: TimeOfDaySchema,
    /** Thứ chạy theo ISO: 1 = thứ Hai … 7 = Chủ nhật. */
    daysOfWeek: z.array(z.int().min(1).max(7)).min(1).max(7),
    startDate: DateOnlySchema,
    /** Gồm cả ngày này; tối đa 92 ngày sau ngày bắt đầu. */
    endDate: DateOnlySchema,
    onlineSaleCutoffMinutes: z.int().min(0).max(MAX_ONLINE_SALE_CUTOFF_MINUTES),
    note: optionalText(500),
    /**
     * Chặng mở bán (3.3): tuyến con ĐANG BẬT của đúng tuyến này mà chuyến sinh từ lịch bán thêm theo giá riêng. Thiếu = không bán theo chặng
     * (client cũ vẫn chạy).
     */
    subRouteIds: z.array(z.uuid()).max(50).default([]),
  })
  .superRefine((input, ctx) => {
    if (new Set(input.daysOfWeek).size !== input.daysOfWeek.length) {
      ctx.addIssue({ code: "custom", path: ["daysOfWeek"], message: "Trùng thứ." });
    }
    // Zod 4 vẫn chạy refine khi ngày sai định dạng — lỗi định dạng đã được báo, bỏ qua phần so sánh.
    if (!DateOnlySchema.safeParse(input.startDate).success || !DateOnlySchema.safeParse(input.endDate).success) {
      return;
    }
    const span = daysBetween(input.startDate, input.endDate);
    if (span < 0) {
      ctx.addIssue({ code: "custom", path: ["endDate"], message: "Ngày kết thúc phải từ ngày bắt đầu trở đi." });
    } else if (span > MAX_SCHEDULE_SPAN_DAYS) {
      ctx.addIssue({ code: "custom", path: ["endDate"], message: "Một lịch áp dụng tối đa 93 ngày." });
    }
    if (input.endDate < todayInVietnam(new Date())) {
      ctx.addIssue({ code: "custom", path: ["endDate"], message: "Ngày kết thúc đã qua." });
    }
  });
export type TripScheduleInput = z.infer<typeof TripScheduleInputSchema>;
/** Body tạo / thay toàn bộ lịch chuyến lặp lại. */
export class TripScheduleInputDto extends createZodDto(TripScheduleInputSchema) {}

export const TripScheduleResponseSchema = z.object({
  /** Tuyến con chép sang từng chuyến lịch sinh ra (3.3). */
  subRouteIds: z.array(z.uuid()),
  id: z.uuid(),
  routeId: z.uuid(),
  routeName: z.string(),
  vehicleId: z.uuid().nullable(),
  vehiclePlateNumber: z.string().nullable(),
  departureTime: z.string(),
  /** Thời gian chạy của tuyến lúc lưu lịch (phút) — chuyến sinh ra luôn tính giờ đến theo tuyến hiện tại. */
  durationMinutes: z.int(),
  daysOfWeek: z.array(z.int()),
  startDate: z.iso.date(),
  endDate: z.iso.date(),
  onlineSaleCutoffMinutes: z.int(),
  note: z.string().nullable(),
  /** Số chuyến đã sinh từ lịch (mọi trạng thái). */
  tripCount: z.int(),
  lastGeneratedAt: z.iso.datetime().nullable(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});
export type TripScheduleResponse = z.infer<typeof TripScheduleResponseSchema>;
/** Một lịch chuyến lặp lại. */
export class TripScheduleResponseDto extends createZodDto(TripScheduleResponseSchema) {}

export const TripScheduleListResponseSchema = z.object({ items: z.array(TripScheduleResponseSchema) });
export type TripScheduleListResponse = z.infer<typeof TripScheduleListResponseSchema>;
/** Các lịch của nhà xe — lịch còn hiệu lực trước. */
export class TripScheduleListResponseDto extends createZodDto(TripScheduleListResponseSchema) {}

export const TripScheduleGenerateInputSchema = z.object({
  /** Mở bán ngay các chuyến vừa sinh nếu đủ điều kiện (BR-39); chưa đủ thì giữ nháp và trả lý do. */
  openForSale: z.boolean(),
});
export type TripScheduleGenerateInput = z.infer<typeof TripScheduleGenerateInputSchema>;
/** Body sinh chuyến từ lịch. */
export class TripScheduleGenerateInputDto extends createZodDto(TripScheduleGenerateInputSchema) {}

/** Lý do một ngày không sinh chuyến: đã có chuyến của lịch / giờ khởi hành đã qua / xe trùng giờ chuyến khác. */
export const SKIP_REASONS = ["EXISTS", "PAST", "VEHICLE_CONFLICT"] as const;

export const TripScheduleGenerateResponseSchema = z.object({
  created: z.array(
    z.object({
      tripId: z.uuid(),
      serviceDate: z.iso.date(),
      departureAt: z.iso.datetime(),
      status: z.enum([TripStatus.DRAFT, TripStatus.OPEN_FOR_SALE]),
      /** Khi xin mở bán mà chưa mở được: mã lý do BR-39 (như `reasons` của `TRIP_NOT_READY_FOR_SALE`) hoặc mã lỗi. */
      notOpenedReasons: z.array(z.string()),
    }),
  ),
  skipped: z.array(z.object({ serviceDate: z.iso.date(), reason: z.enum(SKIP_REASONS) })),
});
export type TripScheduleGenerateResponse = z.infer<typeof TripScheduleGenerateResponseSchema>;
/** Kết quả sinh chuyến: chuyến đã tạo (kèm trạng thái) và ngày bỏ qua kèm lý do. */
export class TripScheduleGenerateResponseDto extends createZodDto(TripScheduleGenerateResponseSchema) {}
