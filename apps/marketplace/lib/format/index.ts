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
