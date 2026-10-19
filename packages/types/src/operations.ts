import { z } from "zod";

/** Loại sự cố vận hành dùng chung giữa API và giao diện (UC-22). */
export const INCIDENT_TYPES = ["VEHICLE", "TRAFFIC", "PASSENGER", "SAFETY", "OTHER"] as const;
/** Mức ảnh hưởng sự cố do nhân viên khai báo. */
export const INCIDENT_SEVERITIES = ["LOW", "MEDIUM", "HIGH", "CRITICAL"] as const;

const text = (max: number) => z.string().trim().min(1).max(max);
const instant = z.iso.datetime({ offset: true });

/** Dữ liệu nhân viên báo sự cố trên chuyến được phân công. */
export const IncidentInputSchema = z.object({
  tripId: z.uuid(),
  type: z.enum(INCIDENT_TYPES),
  severity: z.enum(INCIDENT_SEVERITIES),
  description: text(3000),
  location: text(500).nullable().default(null),
  occurredAt: instant,
  evidence: z.array(z.object({ objectKey: text(500), fileName: text(200) })).max(5).default([]),
});
export type IncidentInput = z.infer<typeof IncidentInputSchema>;

/** Nhật trình tại một điểm hoặc ghi nhận tình trạng xe / ghi chú vận hành. */
export const JourneyLogInputSchema = z.object({
  tripId: z.uuid(),
  stopSequence: z.int().positive().nullable().default(null),
  actualAt: instant,
  vehicleStatus: text(200).nullable().default(null),
  note: text(3000).nullable().default(null),
}).refine((value) => value.stopSequence !== null || value.vehicleStatus !== null || value.note !== null, { message: "Cần điểm dừng, tình trạng xe hoặc ghi chú." });
export type JourneyLogInput = z.infer<typeof JourneyLogInputSchema>;

/** Bộ lọc nhật trình / sự cố theo chuyến, có phân trang bằng con trỏ. */
export const OperationsQuerySchema = z.object({
  tripId: z.uuid().optional(),
  cursor: z.uuid().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
});
export type OperationsQuery = z.infer<typeof OperationsQuerySchema>;

/** Một sự cố kèm tình trạng xử lý của nhà xe. */
export const IncidentSchema = z.object({
  id: z.uuid(), operatorId: z.uuid(), tripId: z.uuid(), employeeId: z.uuid(),
  type: z.enum(INCIDENT_TYPES), severity: z.enum(INCIDENT_SEVERITIES), description: z.string(), location: z.string().nullable(),
  occurredAt: instant, createdAt: instant, resolvedAt: instant.nullable(), resolvedBy: z.string().nullable(), resolution: z.string().nullable(),
  evidence: z.array(z.object({ objectKey: z.string(), fileName: z.string(), contentType: z.string(), sizeBytes: z.int() })),
});
export type Incident = z.infer<typeof IncidentSchema>;
/** Một trang sự cố theo thời điểm ghi nhận mới nhất. */
export const IncidentPageSchema = z.object({ items: z.array(IncidentSchema), nextCursor: z.uuid().nullable() });
export type IncidentPage = z.infer<typeof IncidentPageSchema>;

/** Một bản ghi nhật trình và độ trễ tính so với giờ dự kiến tại điểm. */
export const JourneyLogSchema = z.object({
  id: z.uuid(), operatorId: z.uuid(), tripId: z.uuid(), employeeId: z.uuid(), stopSequence: z.int().nullable(),
  actualAt: instant, createdAt: instant, vehicleStatus: z.string().nullable(), note: z.string().nullable(), delayMinutes: z.int(),
});
export type JourneyLog = z.infer<typeof JourneyLogSchema>;
/** Một trang nhật trình mới nhất. */
export const JourneyLogPageSchema = z.object({ items: z.array(JourneyLogSchema), nextCursor: z.uuid().nullable() });
export type JourneyLogPage = z.infer<typeof JourneyLogPageSchema>;

/** Cửa sổ đón tuyệt đối của một điểm trên chuyến. */
export const PickupWindowInputSchema = z.object({ start: instant.nullable(), end: instant.nullable() })
  .refine((value) => (value.start === null && value.end === null) || (value.start !== null && value.end !== null && Date.parse(value.start) <= Date.parse(value.end)), { message: "Cần đủ hai mốc và giờ kết thúc phải từ giờ bắt đầu trở đi." });
export type PickupWindowInput = z.infer<typeof PickupWindowInputSchema>;
