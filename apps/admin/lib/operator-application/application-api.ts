// Gọi API duyệt hồ sơ đăng ký nhà xe cho cổng Admin (05 API §7.5; TASK-ADM-001 phần hồ sơ). Kiểu lấy từ client
// sinh tự OpenAPI nên DTO backend đổi mà chưa sửa ở đây thì typecheck đỏ. Duyệt / từ chối / gửi lại mật khẩu tạm
// cần xác nhận lại danh tính trong 5 phút gần nhất (`withReauth`).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type ApplicationPage = Schemas["AdminApplicationListResponseDto_Output"];
export type ApplicationSummary = ApplicationPage["items"][number];
export type ApplicationDetail = Schemas["AdminApplicationDetailDto_Output"];
export type ApplicationStatus = ApplicationDetail["status"];
export type DocumentType = ApplicationDetail["documents"][number]["type"];
export type DuplicateField = ApplicationSummary["duplicates"][number];
export type HistoryEvent = NonNullable<ApplicationDetail["history"]>[number];
export type ApprovalInput = Schemas["ApprovalInputDto"];
export type ApprovalResult = Schemas["ApprovalResponseDto_Output"];
export type DecisionResult = Schemas["DecisionResponseDto_Output"];

/** Bộ lọc hàng đợi; bỏ trống = không lọc. */
export type ApplicationFilters = {
  status?: ApplicationStatus;
  q?: string;
  submittedSince?: string;
  duplicatesOnly?: boolean;
};

/** Một trang hàng đợi hồ sơ, mới gửi trước. */
export function listApplications(filters: ApplicationFilters, cursor: string | null): Promise<ApplicationPage> {
  const query = new URLSearchParams({ limit: "20" });
  if (filters.status) {
    query.set("status", filters.status);
  }
  if (filters.q) {
    query.set("q", filters.q);
  }
  if (filters.submittedSince) {
    query.set("submittedSince", filters.submittedSince);
  }
  if (filters.duplicatesOnly) {
    query.set("duplicatesOnly", "true");
  }
  if (cursor) {
    query.set("cursor", cursor);
  }
  return apiRequest<ApplicationPage>(`/admin/operator-applications?${query}`);
}

export function getApplication(applicationId: string): Promise<ApplicationDetail> {
  return apiRequest<ApplicationDetail>(`/admin/operator-applications/${applicationId}`);
}

/** URL xem một giấy tờ (hạn 5 phút; máy chủ ghi audit mỗi lần cấp). */
export function documentDownloadUrl(applicationId: string, type: DocumentType): Promise<{ url: string }> {
  return apiRequest<{ url: string }>(`/admin/operator-applications/${applicationId}/documents/${type}/download-url`, {
    method: "POST"
  });
}

/**
 * Duyệt hồ sơ. `idempotencyKey` sinh một lần cho mỗi lần mở hộp thoại: bấm lại / mạng chập chờn gửi lặp vẫn chỉ
 * tạo một nhà xe, máy chủ trả lại kết quả lần đầu.
 */
export function approveApplication(
  applicationId: string,
  input: ApprovalInput,
  idempotencyKey: string
): Promise<ApprovalResult> {
  return apiRequest<ApprovalResult>(`/admin/operator-applications/${applicationId}/approve`, {
    method: "POST",
    body: input,
    headers: { "Idempotency-Key": idempotencyKey }
  });
}

export function requestApplicationInfo(applicationId: string, reason: string): Promise<DecisionResult> {
  return apiRequest<DecisionResult>(`/admin/operator-applications/${applicationId}/request-info`, {
    method: "POST",
    body: { reason }
  });
}

export function rejectApplication(applicationId: string, reason: string): Promise<DecisionResult> {
  return apiRequest<DecisionResult>(`/admin/operator-applications/${applicationId}/reject`, {
    method: "POST",
    body: { reason }
  });
}

/** Gửi lại mật khẩu tạm khi lần gửi lúc duyệt chưa tới được chủ nhà xe. */
export function resendOwnerCredentials(applicationId: string): Promise<ApprovalResult> {
  return apiRequest<ApprovalResult>(`/admin/operator-applications/${applicationId}/resend-owner-credentials`, {
    method: "POST"
  });
}
