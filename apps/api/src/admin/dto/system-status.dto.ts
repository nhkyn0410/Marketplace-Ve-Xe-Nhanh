import { createZodDto } from "nestjs-zod";
import { z } from "zod";

// API §7.5 `/admin/system/*` — trang Tích hợp & hệ thống CHỈ ĐỌC (Figma ADM-16a / 16b; Khanh 16/10/2026: không làm chế
// độ bảo trì, không chạy lại tác vụ).

export const INTEGRATION_STATUSES = [
  /** Kiểm tra kết nối thật vừa thành công. */
  "UP",
  /** Kiểm tra kết nối thật thất bại / quá thời gian. */
  "DOWN",
  /** Có cấu hình nhưng không gọi thử (tránh gửi email / gọi dịch vụ trả phí khi xem trang). */
  "CONFIGURED",
  /** Bản dev dùng bộ chuyển đổi cục bộ (ổ đĩa / ghi log), chưa nối dịch vụ thật. */
  "LOCAL",
  "NOT_CONFIGURED",
  /** Dịch vụ có trong thiết kế nhưng chưa xây ở phiên bản này. */
  "NOT_INTEGRATED",
  /** Tắt theo quyết định v1 (SMS — ADR-020). */
  "DISABLED",
] as const;

const IntegrationSchema = z.object({
  key: z.string(),
  name: z.string(),
  category: z.string(),
  status: z.enum(INTEGRATION_STATUSES),
  /** Thời gian phản hồi của lần kiểm tra (ms); `null` khi không gọi thử. */
  latencyMs: z.int().nullable(),
  detail: z.string(),
});

export const SystemIntegrationsSchema = z.object({
  checkedAt: z.iso.datetime(),
  environment: z.string(),
  items: z.array(IntegrationSchema),
});
export type SystemIntegrations = z.infer<typeof SystemIntegrationsSchema>;
export class SystemIntegrationsDto extends createZodDto(SystemIntegrationsSchema) {}

const JobRunSchema = z.object({
  state: z.enum(["completed", "failed", "active"]),
  /** Lúc xong (hoặc bắt đầu, nếu đang chạy). */
  at: z.iso.datetime(),
  /** Số bản ghi xử lý nếu tác vụ trả về (`{ deleted: n }`…). */
  processed: z.int().nullable(),
  /** Lý do lỗi (đã rút gọn), chỉ khi `failed`. */
  error: z.string().nullable(),
  attempts: z.int(),
});

const BackgroundJobSchema = z.object({
  queue: z.string(),
  name: z.string(),
  label: z.string(),
  /** Lịch cron theo giờ VN; `null` = chạy theo yêu cầu. */
  schedule: z.string().nullable(),
  nextRunAt: z.iso.datetime().nullable(),
  lastRun: JobRunSchema.nullable(),
  /** Số lần lỗi trong cửa sổ lưu (7 ngày theo cấu hình hàng đợi). */
  failedCount: z.int(),
});

export const BackgroundJobsSchema = z.object({
  checkedAt: z.iso.datetime(),
  /** `false` = không đọc được Redis / BullMQ. */
  available: z.boolean(),
  jobs: z.array(BackgroundJobSchema),
  queues: z.array(
    z.object({
      name: z.string(),
      waiting: z.int(),
      active: z.int(),
      delayed: z.int(),
      failed: z.int(),
    }),
  ),
});
export type BackgroundJobs = z.infer<typeof BackgroundJobsSchema>;
export class BackgroundJobsDto extends createZodDto(BackgroundJobsSchema) {}
