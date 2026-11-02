import { NotificationCampaignType, NotificationKind } from "../../database/prisma.types";

// Quy tắc gửi chiến dịch (TASK-NSR-003, tự thiết kế, chờ duyệt). Hàm thuần để test không cần DB.

/** Thời gian "giờ yên tĩnh" theo giờ Việt Nam: khuyến mãi / tin tức không gửi 21h–8h. */
export const QUIET_START_HOUR = 21;
export const QUIET_END_HOUR = 8;
/** Trần tần suất khuyến mãi của một khách. */
export const PROMOTION_CAP_MS = 24 * 3_600_000;
/** Hẹn giờ gửi xa nhất. */
export const MAX_SCHEDULE_AHEAD_MS = 30 * 24 * 3_600_000;
const VIETNAM_OFFSET_HOURS = 7;

export const CAMPAIGN_KIND: Record<NotificationCampaignType, NotificationKind> = {
  [NotificationCampaignType.SERVICE]: NotificationKind.SERVICE_NOTICE,
  [NotificationCampaignType.PROMOTION]: NotificationKind.PROMOTION,
  [NotificationCampaignType.NEWS]: NotificationKind.NEWS,
};

/** Tin Admin tự soạn, không chứa dữ liệu riêng của khách nên push được mang nguyên nội dung (BR-53). */
export function pushCarriesMessage(kind: NotificationKind): boolean {
  return kind === NotificationKind.SERVICE_NOTICE || kind === NotificationKind.PROMOTION || kind === NotificationKind.NEWS;
}

/** Thông báo dịch vụ không chịu giờ yên tĩnh: bảo trì, sự cố có thể gấp. */
export function inQuietHours(type: NotificationCampaignType, at: Date): boolean {
  if (type === NotificationCampaignType.SERVICE) return false;
  const hour = (at.getUTCHours() + VIETNAM_OFFSET_HOURS) % 24;
  return hour >= QUIET_START_HOUR || hour < QUIET_END_HOUR;
}

export type RecipientPreference = { email: boolean; push: boolean } | null;
export type CampaignDelivery = { inbox: boolean; push: boolean };

/**
 * Một khách nhận gì theo tùy chọn (BR-52, FR-NSR-14):
 * - Dịch vụ: bắt buộc, luôn vào hộp thư; tắt push thì không đẩy.
 * - Khuyến mãi: mặc định nhận; tắt cả hai kênh là không nhận.
 * - Tin tức: mặc định không nhận; phải chủ động bật.
 */
export function campaignDelivery(type: NotificationCampaignType, preference: RecipientPreference, hasDevice: boolean): CampaignDelivery {
  switch (type) {
    case NotificationCampaignType.SERVICE:
      return { inbox: true, push: hasDevice && preference?.push !== false };
    case NotificationCampaignType.PROMOTION: {
      const optedIn = preference === null || preference.email || preference.push;
      return { inbox: optedIn, push: optedIn && hasDevice && preference?.push !== false };
    }
    case NotificationCampaignType.NEWS: {
      const optedIn = preference !== null && (preference.email || preference.push);
      return { inbox: optedIn, push: optedIn && hasDevice && preference.push };
    }
  }
}
