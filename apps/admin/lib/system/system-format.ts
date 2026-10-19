// Trang Tích hợp & hệ thống (Figma ADM-16a / 16b) — chỉ đọc. Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type SystemIntegrations = Schemas["SystemIntegrationsDto_Output"];
export type Integration = SystemIntegrations["items"][number];
export type IntegrationStatus = Integration["status"];
export type BackgroundJobs = Schemas["BackgroundJobsDto_Output"];
export type BackgroundJob = BackgroundJobs["jobs"][number];

export function getIntegrations(): Promise<SystemIntegrations> {
  return apiRequest<SystemIntegrations>("/admin/system/integrations");
}

export function getBackgroundJobs(): Promise<BackgroundJobs> {
  return apiRequest<BackgroundJobs>("/admin/system/jobs");
}

export const INTEGRATION_STATUS: Record<IntegrationStatus, { label: string; tone: "success" | "warning" | "neutral" | "danger" }> = {
  UP: { label: "Hoạt động", tone: "success" },
  DOWN: { label: "Lỗi", tone: "danger" },
  CONFIGURED: { label: "Đã cấu hình", tone: "success" },
  LOCAL: { label: "Bản dev", tone: "warning" },
  NOT_CONFIGURED: { label: "Chưa cấu hình", tone: "warning" },
  NOT_INTEGRATED: { label: "Chưa tích hợp", tone: "neutral" },
  DISABLED: { label: "Tắt", tone: "neutral" }
};

/** Lịch cron theo giờ VN → chữ: `0 3 * * *` → "Hằng ngày · 03:00"; dạng khác giữ nguyên; `null` → "Theo yêu cầu". */
export function scheduleLabel(pattern: string | null): string {
  if (!pattern) {
    return "Theo yêu cầu";
  }
  const match = /^(\d{1,2}) (\d{1,2}) \* \* \*$/.exec(pattern.trim());
  if (!match) {
    return pattern;
  }
  return `Hằng ngày · ${match[2]!.padStart(2, "0")}:${match[1]!.padStart(2, "0")}`;
}

/** Trạng thái lần chạy gần nhất của một tác vụ. */
export function jobState(job: BackgroundJob): { label: string; tone: "success" | "warning" | "neutral" | "danger"; note: string | null } {
  if (!job.lastRun) {
    return { label: "Chưa chạy", tone: "neutral", note: "Chưa có lần chạy trong thời gian lưu (24 giờ / lỗi 7 ngày)." };
  }
  switch (job.lastRun.state) {
    case "completed":
      return { label: "Hoàn tất", tone: "success", note: null };
    case "active":
      return { label: "Đang chạy", tone: "neutral", note: null };
    case "failed":
      return { label: "Lỗi", tone: "danger", note: job.lastRun.error };
  }
}

/** Lần chạy kế đã qua mà tác vụ chưa chạy → worker có thể đang dừng (ADR-024). */
export function isOverdue(nextRunAt: string | null, nowMs: number = Date.now()): boolean {
  return nextRunAt !== null && new Date(nextRunAt).getTime() < nowMs - 5 * 60_000;
}
