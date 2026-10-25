const INTEGER_REGEX = /^-?\d+$/;

/**
 * Định dạng chuỗi số nguyên VND sang chuỗi tiền tệ hiển thị với dấu chấm phân cách hàng nghìn.
 * Tuyệt đối không sử dụng kiểu number hay ép kiểu float để tránh sai lệch số học.
 */
export function formatVnd(amountVnd: string | bigint): string {
  const strValue = typeof amountVnd === "bigint" ? amountVnd.toString() : amountVnd;

  if (typeof amountVnd !== "bigint") {
    if (typeof amountVnd !== "string" || !INTEGER_REGEX.test(amountVnd)) {
      throw new Error(`Chuỗi tiền VND không hợp lệ: "${String(amountVnd)}"`);
    }
  }

  const bigIntValue = BigInt(strValue);
  const isNegative = bigIntValue < 0n;
  const absBigInt = isNegative ? -bigIntValue : bigIntValue;
  const absString = absBigInt.toString();

  // Thêm dấu chấm phân cách mỗi 3 chữ số từ phải qua trái
  const formatted = absString.replace(/\B(?=(\d{3})+(?!\d))/g, ".");
  return `${isNegative ? "-" : ""}${formatted}đ`;
}

/**
 * Định dạng chuỗi ngày tháng ISO sang định dạng ngày Việt Nam (dd/mm/yyyy).
 */
export function formatDateVi(isoString: string): string {
  const date = new Date(isoString);
  if (Number.isNaN(date.getTime())) {
    return isoString;
  }
  return new Intl.DateTimeFormat("en-GB", { timeZone: "Asia/Ho_Chi_Minh", day: "2-digit", month: "2-digit", year: "numeric" }).format(date);
}

/**
 * Định dạng chuỗi ngày tháng ISO sang định dạng giờ Việt Nam (HH:mm).
 */
export function formatTimeVi(isoString: string): string {
  const date = new Date(isoString);
  if (Number.isNaN(date.getTime())) {
    return isoString;
  }
  return new Intl.DateTimeFormat("en-GB", { timeZone: "Asia/Ho_Chi_Minh", hour: "2-digit", minute: "2-digit", hourCycle: "h23" }).format(date);
}

/**
 * Định dạng chuỗi ngày tháng ISO sang định dạng ngày và giờ Việt Nam (HH:mm dd/mm/yyyy).
 */
export function formatDateTimeVi(isoString: string): string {
  return `${formatTimeVi(isoString)} ${formatDateVi(isoString)}`;
}

const WEEKDAYS_SHORT = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];

/**
 * Định dạng ngày đi `YYYY-MM-DD` thành "T6, 16/10/2026" như ô Ngày đi trong Figma; chuỗi khác giữ nguyên.
 */
export function formatTripDateVi(isoDate: string): string {
  const match = /^(\d{4})-(\d{2})-(\d{2})$/.exec(isoDate);
  if (!match) {
    return isoDate;
  }
  const [, year, month, day] = match;
  const weekday = new Date(Date.UTC(Number(year), Number(month) - 1, Number(day))).getUTCDay();
  return `${WEEKDAYS_SHORT[weekday]}, ${day}/${month}/${year}`;
}

/**
 * Số ngày lịch (giờ Việt Nam) từ `fromIso` tới `toIso`, vd đón 22:30 hôm nay, trả 05:30 hôm sau → 1.
 * Thiếu hoặc sai định dạng thì trả 0 để giao diện không hiện "+N ngày".
 */
export function vnDayOffset(fromIso?: string, toIso?: string): number {
  if (!fromIso || !toIso) {
    return 0;
  }
  const day = (iso: string): number | null => {
    const date = new Date(iso);
    if (Number.isNaN(date.getTime())) {
      return null;
    }
    const [year, month, dayOfMonth] = new Intl.DateTimeFormat("en-CA", { timeZone: "Asia/Ho_Chi_Minh", year: "numeric", month: "2-digit", day: "2-digit" }).format(date).split("-").map(Number);
    return Date.UTC(year, month - 1, dayOfMonth) / 86_400_000;
  };
  const from = day(fromIso);
  const to = day(toIso);
  return from === null || to === null ? 0 : Math.max(0, to - from);
}
