// Gọi API VXN Plus cho Admin (05 API §7.5 `/admin/loyalty/*`; TASK-LOY-001). Tham số chương trình dùng API chính sách chung
// (`/admin/policies/LOYALTY`, xem `lib/policy/policy-api.ts`). Kiểu lấy từ client sinh tự OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { ApiError, apiRequest } from "@vexenhanh/ui/lib/auth/api-client";
import { describeReauthError } from "@vexenhanh/ui/lib/auth/reauth";

type Schemas = components["schemas"];

export type LoyaltyMember = Schemas["LoyaltyMemberDto_Output"];
export type LoyaltyTier = LoyaltyMember["tier"];
export type LoyaltyTransactionPage = Schemas["LoyaltyTransactionPageDto_Output"];
export type LoyaltyTransaction = LoyaltyTransactionPage["items"][number];
export type LoyaltyPointType = LoyaltyTransaction["type"];
export type LoyaltyReport = Schemas["LoyaltyReportDto_Output"];
export type PointAdjustInput = Schemas["PointAdjustInputDto"];

export const TRANSACTION_PAGE = 20;

export function getMember(email: string): Promise<LoyaltyMember> {
  return apiRequest<LoyaltyMember>(`/admin/loyalty/accounts?${new URLSearchParams({ email })}`);
}

export function listTransactions(userId: string, offset: number): Promise<LoyaltyTransactionPage> {
  return apiRequest<LoyaltyTransactionPage>(`/admin/loyalty/accounts/${encodeURIComponent(userId)}/transactions?offset=${offset}&limit=${TRANSACTION_PAGE}`);
}

/** Điều chỉnh điểm. `idempotencyKey` sinh một lần cho mỗi lần mở hộp thoại: bấm lại / mạng chập chờn không ghi hai lần. */
export function adjustPoints(userId: string, input: PointAdjustInput, idempotencyKey: string): Promise<LoyaltyMember> {
  return apiRequest<LoyaltyMember>(`/admin/loyalty/accounts/${encodeURIComponent(userId)}/adjustments`, {
    method: "POST",
    body: input,
    headers: { "Idempotency-Key": idempotencyKey }
  });
}

export function getLoyaltyReport(year: number, quarter: number, tier: LoyaltyTier | null): Promise<LoyaltyReport> {
  const search = new URLSearchParams({ year: String(year), quarter: String(quarter) });
  if (tier) {
    search.set("tier", tier);
  }
  return apiRequest<LoyaltyReport>(`/admin/loyalty/reports?${search}`);
}

/** Lỗi cho người dùng: thiếu / sai xác nhận danh tính → hiện ô mã; còn lại → thông báo trong form. */
export function describeLoyaltyError(error: unknown): { field: "identity" | "form"; message: string } {
  const identity = describeReauthError(error);
  if (identity) {
    return { field: "identity", message: identity };
  }
  if (error instanceof ApiError) {
    if (["LOYALTY_INSUFFICIENT_POINTS", "LOYALTY_REQUEST_CONFLICT", "LOYALTY_MEMBER_NOT_FOUND"].includes(error.code)) {
      return { field: "form", message: error.message };
    }
    if (error.status === 400) return { field: "form", message: "Kiểm tra lại các ô đã nhập." };
    if (error.status === 503) return { field: "form", message: "Chưa ghi được nhật ký nên chưa lưu. Vui lòng thử lại." };
  }
  return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
}
