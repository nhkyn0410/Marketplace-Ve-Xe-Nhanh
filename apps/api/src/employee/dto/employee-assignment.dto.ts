import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { AccountStatus, TripStatus } from "../../database/prisma.types";

// API §7.3 `/operator/trip-assignments`, `/operator/trips/{tripId}/driver` — phân công tài xế cho chuyến (TASK-EMP-001,
// UC-16 bước 4–6; Figma "05 · Nhân viên / Phân công chuyến" — thiết kế chờ Khanh duyệt).

/** Lọc theo tình trạng phân công tài xế. */
export const ASSIGNMENT_STATES = ["ASSIGNED", "UNASSIGNED"] as const;

export class TripAssignmentListQueryDto extends createZodDto(
  z.object({
    /** Ngày khởi hành theo giờ Việt Nam. */
    date: z.iso.date(),
    routeId: z.uuid().optional(),
    state: z.enum(ASSIGNMENT_STATES).optional(),
    cursor: z.uuid().optional(),
    limit: z.coerce.number().int().min(1).max(100).default(20),
  }),
) {}

const SlotSchema = z.object({ tripId: z.uuid(), departureAt: z.iso.datetime(), arrivalAt: z.iso.datetime() });

export const TripAssignmentSchema = z.object({
  tripId: z.uuid(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  status: z.enum(TripStatus),
  routeName: z.string(),
  vehiclePlateNumber: z.string().nullable(),
  /** Tài xế đang được phân công; `null` = chưa phân công. */
  driver: z
    .object({ employeeId: z.uuid(), username: z.string(), status: z.enum(AccountStatus) })
    .nullable(),
  /**
   * Chuyến khác (chưa hủy) của cùng tài xế chồng giờ với chuyến này — chỉ xảy ra khi giờ chuyến bị sửa SAU khi phân
   * công (lúc phân công máy chủ đã chặn).
   */
  conflict: SlotSchema.nullable(),
  /** Đổi phân công cần lý do: chuyến đang chạy hoặc còn dưới 2 giờ là khởi hành. */
  reasonRequired: z.boolean(),
  /** Chuyến đã hủy / hoàn thành thì không đổi phân công. */
  editable: z.boolean(),
});
export type TripAssignment = z.infer<typeof TripAssignmentSchema>;
/** Một chuyến kèm tình trạng phân công tài xế. */
export class TripAssignmentDto extends createZodDto(TripAssignmentSchema) {}

export const TripAssignmentPageSchema = z.object({
  items: z.array(TripAssignmentSchema),
  nextCursor: z.uuid().nullable(),
});
export type TripAssignmentPage = z.infer<typeof TripAssignmentPageSchema>;
/** Một trang chuyến (chưa hủy) khởi hành trong ngày, theo giờ khởi hành. */
export class TripAssignmentPageDto extends createZodDto(TripAssignmentPageSchema) {}

export const DriverAssignmentInputSchema = z.object({
  /** Tài xế (nhân viên vai trò `DRIVER` đang hoạt động); `null` = bỏ phân công. */
  employeeId: z.uuid().nullable(),
  /** Bắt buộc khi chuyến đang chạy hoặc còn dưới 2 giờ là khởi hành (UC-16 A4); lưu ở audit. */
  reason: z
    .string()
    .trim()
    .max(500)
    .nullable()
    .transform((value) => value || null),
});
export type DriverAssignmentInput = z.infer<typeof DriverAssignmentInputSchema>;
/** Body phân công / bỏ phân công tài xế cho một chuyến. */
export class DriverAssignmentInputDto extends createZodDto(DriverAssignmentInputSchema) {}
