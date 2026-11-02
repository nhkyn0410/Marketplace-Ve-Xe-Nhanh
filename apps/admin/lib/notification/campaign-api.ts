// Gọi API Chiến dịch thông báo cho Admin (`/admin/notification-campaigns*`; TASK-NSR-003). Kiểu lấy từ client sinh.
import type { components } from "@vexenhanh/api-client";
import { ApiError, apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type CampaignPage = Schemas["CampaignPageDto_Output"];
export type Campaign = CampaignPage["items"][number];
export type CampaignDetail = Schemas["CampaignDetailDto_Output"];
export type CampaignOptions = Schemas["CampaignOptionsDto_Output"];
export type AudienceEstimate = Schemas["AudienceEstimateDto_Output"];
export type CampaignType = Campaign["type"];
export type CampaignStatus = Campaign["status"];
export type CampaignAudience = Campaign["audience"];
export type CampaignTier = Campaign["tiers"][number];

export type CampaignFormValues = {
  type: CampaignType;
  title: string;
  body: string;
  audience: CampaignAudience;
  tiers: CampaignTier[];
  promotionId: string | null;
  articleId: string | null;
};

export const CAMPAIGN_PAGE_SIZE = 25;

export const CAMPAIGN_TYPE: Record<CampaignType, { label: string; description: string }> = {
  SERVICE: { label: "Dịch vụ", description: "Bảo trì, sự cố. Bắt buộc, gửi tới mọi tài khoản, khách không tắt được." },
  PROMOTION: { label: "Khuyến mãi", description: "Gắn với một khuyến mãi đang chạy. Khách tắt được; tối đa 1 tin mỗi 24 giờ." },
  NEWS: { label: "Tin tức", description: "Gắn với một bài viết đã đăng. Chỉ gửi tới khách đã bật nhận tin." }
};
export const CAMPAIGN_TYPES = Object.keys(CAMPAIGN_TYPE) as CampaignType[];

export const CAMPAIGN_STATUS: Record<CampaignStatus, { label: string; tone: "neutral" | "success" | "warning" }> = {
  DRAFT: { label: "Bản nháp", tone: "neutral" },
  SCHEDULED: { label: "Đã hẹn giờ", tone: "warning" },
  SENDING: { label: "Đang gửi", tone: "warning" },
  COMPLETED: { label: "Đã gửi", tone: "success" },
  CANCELLED: { label: "Đã hủy", tone: "neutral" }
};
export const CAMPAIGN_STATUS_ORDER = Object.keys(CAMPAIGN_STATUS) as CampaignStatus[];

export const CAMPAIGN_TIER: Record<CampaignTier, string> = { BRONZE: "Đồng", SILVER: "Bạc", GOLD: "Vàng", PLATINUM: "Bạch kim" };
export const CAMPAIGN_TIERS = Object.keys(CAMPAIGN_TIER) as CampaignTier[];

/** Đối tượng hiển thị ở danh sách và màn xác nhận. */
export function audienceLabel(campaign: Pick<Campaign, "audience" | "tiers">): string {
  if (campaign.audience === "ALL") return "Tất cả hành khách";
  return `Hạng ${campaign.tiers.map((tier) => CAMPAIGN_TIER[tier]).join(", ")}`;
}

/** Quy tắc giống máy chủ: khuyến mãi / tin tức không gửi 21h–8h giờ Việt Nam. */
export function inQuietHours(type: CampaignType, at: Date): boolean {
  if (type === "SERVICE") return false;
  const hour = (at.getUTCHours() + 7) % 24;
  return hour >= 21 || hour < 8;
}

export function listCampaigns(params: { status?: CampaignStatus; offset: number }): Promise<CampaignPage> {
  const search = new URLSearchParams({ offset: String(params.offset), limit: String(CAMPAIGN_PAGE_SIZE) });
  if (params.status) search.set("status", params.status);
  return apiRequest<CampaignPage>(`/admin/notification-campaigns?${search.toString()}`);
}

export function getCampaign(campaignId: string): Promise<CampaignDetail> {
  return apiRequest<CampaignDetail>(`/admin/notification-campaigns/${campaignId}`);
}

export function getCampaignOptions(): Promise<CampaignOptions> {
  return apiRequest<CampaignOptions>("/admin/notification-campaigns/options");
}

export function estimateAudience(input: Pick<CampaignFormValues, "type" | "audience" | "tiers">): Promise<AudienceEstimate> {
  return apiRequest<AudienceEstimate>("/admin/notification-campaigns/estimate", { method: "POST", body: input });
}

export function createCampaign(input: CampaignFormValues): Promise<Campaign> {
  return apiRequest<Campaign>("/admin/notification-campaigns", { method: "POST", body: input });
}

export function updateCampaign(campaignId: string, input: CampaignFormValues): Promise<Campaign> {
  return apiRequest<Campaign>(`/admin/notification-campaigns/${campaignId}`, { method: "PUT", body: input });
}

export function testCampaign(campaignId: string, email: string): Promise<{ pushDevices: number }> {
  return apiRequest(`/admin/notification-campaigns/${campaignId}/test`, { method: "POST", body: { email } });
}

/** `scheduledAt` `null` = gửi ngay. */
export function sendCampaign(campaignId: string, scheduledAt: string | null): Promise<Campaign> {
  return apiRequest<Campaign>(`/admin/notification-campaigns/${campaignId}/send`, { method: "POST", body: { scheduledAt } });
}

export function cancelCampaign(campaignId: string): Promise<Campaign> {
  return apiRequest<Campaign>(`/admin/notification-campaigns/${campaignId}/cancel`, { method: "POST" });
}

/** Câu lỗi cho thao tác chiến dịch. */
export function describeCampaignError(error: unknown): string {
  if (error instanceof ApiError) {
    if (error.code.startsWith("CAMPAIGN_")) return error.message;
    if (error.status === 400) return "Kiểm tra lại các ô đã nhập.";
    if (error.status === 403) return "Tài khoản không có quyền gửi thông báo.";
    if (error.status === 503) return "Chưa ghi được nhật ký nên chưa lưu. Vui lòng thử lại.";
  }
  return "Chưa lưu được. Vui lòng kiểm tra kết nối và thử lại.";
}
