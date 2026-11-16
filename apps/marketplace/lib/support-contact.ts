/**
 * Liên hệ hỗ trợ của sàn — một nguồn duy nhất cho mọi màn của hành khách.
 *
 * Số tổng đài lấy từ `NEXT_PUBLIC_SUPPORT_HOTLINE` (vd "1900 1234"). Để trống thì giao diện ẩn số
 * và hướng khách sang email hỗ trợ (AS-16 cho phép email / ticket thay hotline).
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

export const SUPPORT_HOTLINE = parseSupportHotline(process.env.NEXT_PUBLIC_SUPPORT_HOTLINE);
export const SUPPORT_EMAIL = "support@vexenhanh.vn";
export const SUPPORT_EMAIL_HREF = `mailto:${SUPPORT_EMAIL}`;
