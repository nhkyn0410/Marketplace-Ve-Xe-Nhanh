// Logic thuần của màn Báo cáo / Tổng quan Admin (Figma ADM-14a, ADM-01; TASK-RPT-002): khoảng ngày, phần trăm, so sánh kỳ trước,
// cột GMV theo ngày.
const DAY_MS = 86_400_000;
const VN_OFFSET_MS = 7 * 3_600_000;
const PERCENT = new Intl.NumberFormat("vi-VN", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const COUNT = new Intl.NumberFormat("vi-VN");
const MILLION = new Intl.NumberFormat("vi-VN", { maximumFractionDigits: 1 });

/** Ngày theo giờ VN (`2026-10-13`). */
export function vnDate(at: Date): string {
  return new Date(at.getTime() + VN_OFFSET_MS).toISOString().slice(0, 10);
}

/** `days` ngày gần nhất tính cả hôm nay (giờ VN) — mặc định 7 ngày như Figma. */
export function lastDays(days: number, now: Date = new Date()): { from: string; to: string } {
  return { from: vnDate(new Date(now.getTime() - (days - 1) * DAY_MS)), to: vnDate(now) };
}

/** Khoảng ngày hợp lệ: đúng định dạng, đầu ≤ cuối, tối đa 366 ngày (như máy chủ). */
export function validRange(from: string, to: string): boolean {
  const pattern = /^\d{4}-\d{2}-\d{2}$/;
  return pattern.test(from) && pattern.test(to) && from <= to && Date.parse(to) - Date.parse(from) <= 366 * DAY_MS;
}

/** `78,5%`; mẫu số 0 → `—`. */
export function percentLabel(part: number, whole: number): string {
  return whole === 0 ? "—" : `${PERCENT.format((part / whole) * 100)}%`;
}

export function countLabel(value: number): string {
  return COUNT.format(value);
}

/** "Tăng 8,2% so với 7 ngày trước" / "Giảm …" / "Chưa có giao dịch kỳ trước". */
export function compareLabel(current: number, previous: number, days: number): string {
  if (previous === 0) {
    return `Chưa có giao dịch ${days} ngày trước đó`;
  }
  const change = ((current - previous) / previous) * 100;
  if (change === 0) {
    return `Bằng ${days} ngày trước đó`;
  }
  return `${change > 0 ? "Tăng" : "Giảm"} ${PERCENT.format(Math.abs(change))}% so với ${days} ngày trước đó`;
}

/** Số ngày của khoảng (gồm hai đầu). */
export function rangeDays(from: string, to: string): number {
  return Math.round((Date.parse(to) - Date.parse(from)) / DAY_MS) + 1;
}

/** Cột biểu đồ: nhãn `07/10`, giá trị triệu đồng (`612` / `0,5`), chiều cao % so với ngày lớn nhất (tối thiểu 2% khi > 0). */
export function dailyBars(daily: { date: string; gmv: number }[]): { label: string; value: string; height: number; date: string }[] {
  const max = Math.max(0, ...daily.map((day) => day.gmv));
  return daily.map((day) => ({
    date: day.date,
    label: `${day.date.slice(8, 10)}/${day.date.slice(5, 7)}`,
    value: MILLION.format(day.gmv / 1_000_000),
    height: max === 0 || day.gmv === 0 ? 0 : Math.max(2, Math.round((day.gmv / max) * 100))
  }));
}
