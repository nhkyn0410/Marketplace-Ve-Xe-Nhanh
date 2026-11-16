/**
 * Liên hệ hỗ trợ của sàn — một nguồn duy nhất cho mọi màn của hành khách.
 *
 * Số tổng đài mặc định là số chung của sàn (`DEFAULT_SUPPORT_HOTLINE`, giống app); đổi bằng
 * `NEXT_PUBLIC_SUPPORT_HOTLINE`. Đặt biến rỗng thì giao diện ẩn số và hướng khách sang email hỗ trợ
 * (AS-16 cho phép email / ticket thay hotline).
 */
export interface SupportHotline {
  /** Số hiển thị đúng như cấu hình. */
  readonly label: string;
  /** Liên kết gọi, chỉ giữ chữ số và dấu "+". */
  readonly telHref: string;
}

export function parseSupportHotline(raw: string | undefined): SupportHotline | null {
  const label = (raw ?? "").trim();
  const digits = label.replace(/[^\d+]/g, "");
  return digits.length >= 3 ? { label, telHref: `tel:${digits}` } : null;
}

/**
 * Số tổng đài chung của sàn — web và app dùng cùng một số (PASSENGER-PARITY Q1, Khanh chốt 16/11/2026;
 * lấy từ thiết kế app). App: `defaultSupportHotline` ở `apps/passenger_mobile/lib/features/common/support_contact.dart`.
 */
export const DEFAULT_SUPPORT_HOTLINE = "1900 636 707";

export const SUPPORT_HOTLINE = parseSupportHotline(process.env.NEXT_PUBLIC_SUPPORT_HOTLINE ?? DEFAULT_SUPPORT_HOTLINE);
export const SUPPORT_EMAIL = "support@vexenhanh.vn";
export const SUPPORT_EMAIL_HREF = `mailto:${SUPPORT_EMAIL}`;
