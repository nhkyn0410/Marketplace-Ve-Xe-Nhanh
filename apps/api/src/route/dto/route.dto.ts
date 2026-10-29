import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { RouteNameSource, RouteStatus, RouteStopRole, RoutingMetricsSource, StopPointType } from "../../database/prisma.types";

/** Giới hạn điểm/route: đủ cho tuyến liên tỉnh, chặn payload và số lần gọi Goong (mỗi chặng một lần). */
export const MAX_ROUTE_STOPS = 25;
/** Một chặng chỉnh tay dài tối đa 24 giờ. */
export const MAX_LEG_MINUTES = 1440;

const optionalText = (max: number) =>
  z
    .string()
    .trim()
    .max(max)
    .nullable()
    .transform((value) => value || null);

const RouteStopInputSchema = z
  .object({
    catalogStopPointId: z.uuid().nullable(),
    stopPointId: z.uuid().nullable(),
    note: optionalText(300),
    // BR-79: cho đón / cho trả tại điểm này. Quy tắc theo vị trí và loại điểm kiểm ở service (cần loại
    // điểm) và trả 422 `ROUTE_STOP_PICKUP_DROPOFF_INVALID`.
    allowPickup: z.boolean(),
    allowDropoff: z.boolean(),
    /**
     * Thời gian xe khách chạy thật của chặng TỚI điểm này (phút) — nhà xe chỉnh khi số hệ thống tính (Goong / ước lượng)
     * lệch thực tế. `null` / bỏ trống = dùng số hệ thống. Điểm đầu không có chặng (chờ duyệt 27/10/2026).
     */
    durationMinutesFromPrevious: z.int().min(1).max(MAX_LEG_MINUTES).nullable().optional(),
  })
  .refine(
    (stop) => (stop.catalogStopPointId === null) !== (stop.stopPointId === null),
    "Mỗi điểm chọn đúng một nguồn: catalog hoặc điểm riêng.",
  );

// Không `.default()`: POST và PUT (thay toàn bộ) phải gửi đủ trường. Vai trò điểm suy từ vị trí (Q3). Ngoại lệ duy nhất:
// `nameSource` mặc định `MANUAL` để client cũ (chỉ gửi `name`) vẫn chạy như trước.
export const RouteInputSchema = z
  .object({
    /** Bắt buộc khi `nameSource = MANUAL`; `AUTO` thì máy chủ tự ghép tên từ nơi của các điểm dừng, bỏ qua trường này. */
    name: z.string().trim().max(150),
    nameSource: z.enum(RouteNameSource).default(RouteNameSource.MANUAL),
    status: z.enum(RouteStatus),
    note: optionalText(500),
    stops: z.array(RouteStopInputSchema).min(2).max(MAX_ROUTE_STOPS),
  })
  .superRefine((input, ctx) => {
    if (input.nameSource === RouteNameSource.MANUAL && input.name === "") {
      ctx.addIssue({ code: "custom", path: ["name"], message: "Nhập tên tuyến hoặc bật tự đặt tên." });
    }
    if (input.stops[0]?.durationMinutesFromPrevious) {
      ctx.addIssue({ code: "custom", path: ["stops", 0, "durationMinutesFromPrevious"], message: "Điểm đầu không có chặng trước." });
    }
    // UC-13 bước 5: không vòng lặp — một điểm không xuất hiện hai lần (kéo theo đầu ≠ cuối).
    const seen = new Set<string>();
    input.stops.forEach((stop, index) => {
      const key = stop.catalogStopPointId ? `catalog:${stop.catalogStopPointId}` : `private:${stop.stopPointId}`;
      if (seen.has(key)) {
        ctx.addIssue({ code: "custom", path: ["stops", index], message: "Điểm bị lặp trong route." });
      }
      seen.add(key);
    });
  });
export type RouteInput = z.infer<typeof RouteInputSchema>;
/** Body tạo/thay toàn bộ route: danh sách điểm theo thứ tự hành trình. */
export class RouteInputDto extends createZodDto(RouteInputSchema) {}

/** Query list route: lọc trạng thái, phân trang cursor theo `id`. */
export class RouteListQueryDto extends createZodDto(
  z.object({
    status: z.enum(RouteStatus).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

/** Xem trước tên tuyến tự động khi đang sửa điểm dừng (form Operator OS); `routeId` = tuyến đang sửa, không tính trùng tên. */
export const RouteNamePreviewInputSchema = z.object({
  stops: z.array(RouteStopInputSchema).min(2).max(MAX_ROUTE_STOPS),
  routeId: z.uuid().nullable().optional(),
});
export type RouteNamePreviewInput = z.infer<typeof RouteNamePreviewInputSchema>;
/** Body xem trước tên tuyến tự động. */
export class RouteNamePreviewInputDto extends createZodDto(RouteNamePreviewInputSchema) {}

export const RouteNamePreviewSchema = z.object({ name: z.string() });
export type RouteNamePreview = z.infer<typeof RouteNamePreviewSchema>;
/** Tên tuyến tự động (đã tránh trùng tên tuyến khác của nhà xe). */
export class RouteNamePreviewDto extends createZodDto(RouteNamePreviewSchema) {}

const RouteSummaryFields = {
  id: z.uuid(),
  name: z.string(),
  nameSource: z.enum(RouteNameSource),
  status: z.enum(RouteStatus),
  totalDistanceMeters: z.int(),
  totalDurationSeconds: z.int(),
  metricsSource: z.enum(RoutingMetricsSource),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
};

export const RouteListResponseSchema = z.object({
  items: z.array(
    z.object({
      ...RouteSummaryFields,
      stopCount: z.int(),
      // Tên điểm đầu / điểm cuối cho cột "Điểm đầu → Điểm cuối" của màn danh sách (TASK-TRN-013).
      originName: z.string(),
      destinationName: z.string(),
    }),
  ),
  nextCursor: z.uuid().nullable(),
});
export type RouteListResponse = z.infer<typeof RouteListResponseSchema>;
/** Một trang route (không kèm danh sách điểm dừng, chỉ tên điểm đầu / điểm cuối). */
export class RouteListResponseDto extends createZodDto(RouteListResponseSchema) {}

export const RouteResponseSchema = z.object({
  ...RouteSummaryFields,
  /** Tuyến đặt tên tay mà tên tự động khác tên đang dùng → gợi ý để nhà xe bấm áp dụng; còn lại `null`. */
  suggestedName: z.string().nullable(),
  note: z.string().nullable(),
  stops: z.array(
    z.object({
      sequence: z.int(),
      role: z.enum(RouteStopRole),
      catalogStopPointId: z.uuid().nullable(),
      stopPointId: z.uuid().nullable(),
      name: z.string(),
      // Loại điểm: giao diện tự cảnh báo khi hai đầu route không phải bến xe (OQ-24).
      type: z.enum(StopPointType),
      address: z.string(),
      latitude: z.number(),
      longitude: z.number(),
      note: z.string().nullable(),
      allowPickup: z.boolean(),
      allowDropoff: z.boolean(),
      distanceMetersFromPrevious: z.int().nullable(),
      /** Thời gian chặng đang dùng (nhà xe chỉnh, hoặc số hệ thống); tổng = `totalDurationSeconds`. */
      durationSecondsFromPrevious: z.int().nullable(),
      /** Số hệ thống tính cho chặng; khác `durationSecondsFromPrevious` nghĩa là nhà xe đã chỉnh tay. */
      measuredDurationSecondsFromPrevious: z.int().nullable(),
    }),
  ),
});
export type RouteResponse = z.infer<typeof RouteResponseSchema>;
/** Chi tiết route kèm điểm dừng theo thứ tự và số liệu từng chặng. */
export class RouteResponseDto extends createZodDto(RouteResponseSchema) {}
