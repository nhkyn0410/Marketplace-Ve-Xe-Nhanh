// Gọi API nhật ký audit cho cổng Admin (05 API §7.5 `/admin/audit-logs`; UC-30, FR-ADM-16).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type AuditLogPage = Schemas["AdminAuditLogListDto_Output"];
export type AuditLogItem = AuditLogPage["items"][number];
export type AuditLogDetail = Schemas["AdminAuditLogDetailDto_Output"];
export type AuditModule = AuditLogItem["module"];
export type AuditActorType = AuditLogItem["actorType"];
export type AuditLogFilters = {
  from?: string;
  to?: string;
  actorType?: Exclude<AuditActorType, "UNKNOWN">;
  module?: AuditModule;
  result?: AuditLogItem["result"];
  q?: string;
};

const PAGE_SIZE = "20";

export function listAuditLogs(filters: AuditLogFilters, cursor: string | null): Promise<AuditLogPage> {
  const search = new URLSearchParams({ limit: PAGE_SIZE });
  for (const [key, value] of Object.entries({ ...filters, cursor })) {
    if (value) {
      search.set(key, value);
    }
  }
  return apiRequest<AuditLogPage>(`/admin/audit-logs?${search.toString()}`);
}

export function getAuditLog(id: string): Promise<AuditLogDetail> {
  return apiRequest<AuditLogDetail>(`/admin/audit-logs/${encodeURIComponent(id)}`);
}
