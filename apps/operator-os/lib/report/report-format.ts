// Logic thuần của màn Báo cáo / Tổng quan (Figma "Nhà xe · Báo cáo"; TASK-RPT-001): phần trăm, khoảng ngày mặc định.
import { todayLocalDate } from "../trip/trip-format";

const PERCENT = new Intl.NumberFormat("vi-VN", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const COUNT = new Intl.NumberFormat("vi-VN");

/** `78,5%`; mẫu số 0 → `—`. */
export function percentLabel(part: number, whole: number): string {
  return whole === 0 ? "—" : `${PERCENT.format((part / whole) * 100)}%`;
}

/** `1.648`. */
export function countLabel(value: number): string {
  return COUNT.format(value);
}

/** Từ đầu tháng tới hôm nay (giờ VN) — khoảng mặc định của báo cáo nhà xe. */
export function monthToDate(now: Date = new Date()): { from: string; to: string } {
  const to = todayLocalDate(now);
  return { from: `${to.slice(0, 8)}01`, to };
}

/** Khoảng ngày hợp lệ: đúng định dạng, đầu ≤ cuối, tối đa 366 ngày (như máy chủ). */
export function validRange(from: string, to: string): boolean {
  const pattern = /^\d{4}-\d{2}-\d{2}$/;
  return pattern.test(from) && pattern.test(to) && from <= to && Date.parse(to) - Date.parse(from) <= 366 * 86_400_000;
}

/** Tỷ lệ hủy = vé hủy / (vé bán + vé hủy). */
export function cancelRate(totals: { ticketsSold: number; cancelledTickets: number }): string {
  return percentLabel(totals.cancelledTickets, totals.ticketsSold + totals.cancelledTickets);
}
