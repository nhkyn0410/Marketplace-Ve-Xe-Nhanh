import { createZodDto } from "nestjs-zod";
import { z } from "zod";
import { EmployeeRole, TicketStatus, TripStatus } from "../../database/prisma.types";

// API §7.4 `/employee/*` — thao tác của nhân viên trên chuyến được phân công (TASK-EMP-002 phần backend, FR-EMP-07..09/13,
// UC-20/21, BR-05/29/44). App `employee_mobile` gọi bằng Bearer. Shape AI tự đề xuất, chờ Khanh duyệt.

const PointSchema = z.object({ sequence: z.int(), name: z.string(), pickupWindowStart: z.iso.datetime().nullable(), pickupWindowEnd: z.iso.datetime().nullable() });

export const EmployeeAssignmentsQuerySchema = z
  .object({
    /** Khoảng ngày khởi hành theo giờ VN (mặc định hôm qua → 7 ngày tới). */
    from: z.iso.date().optional(),
    to: z.iso.date().optional(),
  })
  .refine((query) => !query.from || !query.to || query.from <= query.to, { message: "Khoảng ngày không hợp lệ.", path: ["to"] });
export class EmployeeAssignmentsQueryDto extends createZodDto(EmployeeAssignmentsQuerySchema) {}

export const EmployeeAssignmentSchema = z.object({
  tripId: z.uuid(),
  role: z.enum(EmployeeRole),
  routeName: z.string(),
  departureAt: z.iso.datetime(),
  arrivalAt: z.iso.datetime(),
  status: z.enum(TripStatus),
  vehiclePlateNumber: z.string().nullable(),
  origin: z.string(),
  destination: z.string(),
  /** Vé còn đi chuyến (chưa hủy / hoàn). */
  ticketCount: z.int(),
  checkedInCount: z.int(),
});
/** Một chuyến được phân công (cũng là kết quả sau khi tài xế đổi trạng thái vận hành). */
export class EmployeeAssignmentDto extends createZodDto(EmployeeAssignmentSchema) {}

export const EmployeeAssignmentListSchema = z.object({ items: z.array(EmployeeAssignmentSchema) });
export type EmployeeAssignmentList = z.infer<typeof EmployeeAssignmentListSchema>;
/** Chuyến được phân công, sắp theo giờ khởi hành. */
export class EmployeeAssignmentListDto extends createZodDto(EmployeeAssignmentListSchema) {}

export const ManifestTicketSchema = z.object({
  ticketId: z.uuid(),
  ticketCode: z.string(),
  seatCode: z.string(),
  passengerName: z.string(),
  /** Số điện thoại hành khách / người liên hệ đã che (`0*** *** 567`). */
  phoneMasked: z.string(),
  pickup: PointSchema,
  dropoff: PointSchema,
  status: z.enum(TicketStatus),
  checkedInAt: z.iso.datetime().nullable(),
});
export type ManifestTicket = z.infer<typeof ManifestTicketSchema>;

export const TripManifestSchema = z.object({
  trip: EmployeeAssignmentSchema,
  /** Theo thứ tự điểm đón rồi mã chỗ. Không gồm vé đã hủy / đã hoàn. */
  passengers: z.array(ManifestTicketSchema),
});
export type TripManifest = z.infer<typeof TripManifestSchema>;
/** Danh sách hành khách của chuyến được phân công. */
export class TripManifestDto extends createZodDto(TripManifestSchema) {}

const CodeSchema = z.string().trim().min(6).max(128);

export const TicketVerifyInputSchema = z.object({
  tripId: z.uuid(),
  /** Nội dung QR (token) hoặc mã vé gõ tay (`VXNABC123-01`). */
  code: CodeSchema,
});
export type TicketVerifyInput = z.infer<typeof TicketVerifyInputSchema>;
export class TicketVerifyInputDto extends createZodDto(TicketVerifyInputSchema) {}

/** Kết quả soát: `OK` = lên xe được; còn lại là lý do từ chối (UC-20 A1–A3). */
export const VERIFY_RESULTS = ["OK", "WRONG_TRIP", "ALREADY_CHECKED_IN", "CANCELLED", "REFUNDED", "NO_SHOW", "USED"] as const;

export const TicketVerifyResultSchema = z.object({
  result: z.enum(VERIFY_RESULTS),
  /** Vé sai chuyến chỉ trả mã vé + chuyến của vé, không trả thông tin khách. */
  ticket: ManifestTicketSchema.nullable(),
  ticketCode: z.string(),
  ticketTrip: z.object({ routeName: z.string(), departureAt: z.iso.datetime() }).nullable(),
});
export type TicketVerifyResult = z.infer<typeof TicketVerifyResultSchema>;
export class TicketVerifyResultDto extends createZodDto(TicketVerifyResultSchema) {}

export const CheckInInputSchema = TicketVerifyInputSchema.extend({
  /** `CHECKED_IN` = cho lên xe; `NO_SHOW` = ghi nhận vắng mặt (FR-EMP-08). */
  status: z.enum([TicketStatus.CHECKED_IN, TicketStatus.NO_SHOW]),
});
export type CheckInInput = z.infer<typeof CheckInInputSchema>;
export class CheckInInputDto extends createZodDto(CheckInInputSchema) {}

export const CheckInResultSchema = z.object({ ticket: ManifestTicketSchema, checkedInCount: z.int(), ticketCount: z.int() });
export type CheckInResult = z.infer<typeof CheckInResultSchema>;
export class CheckInResultDto extends createZodDto(CheckInResultSchema) {}

/** Trạng thái vận hành tài xế chuyển tới (UC-21). */
export const OPERATION_STATUSES = [TripStatus.BOARDING, TripStatus.DEPARTED, TripStatus.IN_PROGRESS, TripStatus.COMPLETED] as const;

export const TripOperationInputSchema = z.object({
  status: z.enum(OPERATION_STATUSES),
  note: z.string().trim().max(500).nullable().transform((value) => value || null),
});
export type TripOperationInput = z.infer<typeof TripOperationInputSchema>;
export class TripOperationInputDto extends createZodDto(TripOperationInputSchema) {}
