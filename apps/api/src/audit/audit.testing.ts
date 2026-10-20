import type { AuditService } from "./audit.service";
import { connectAudit } from "./audit-connect";

/** Dựng `AuditService` nối Mongo THẬT cho test tích hợp ở module khác. Trả kèm hàm đóng kết nối. */
export async function connectAuditForTest(uri: string): Promise<{ audit: AuditService; close: () => Promise<void> }> {
  return connectAudit(uri);
}
