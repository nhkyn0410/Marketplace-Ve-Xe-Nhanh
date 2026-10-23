import { describe, expect, it } from "vitest";

import { formatDateVi, formatDateTimeVi, formatTimeVi, formatVnd } from "./index";

describe("formatVnd", () => {
  it("định dạng số 0 thành 0đ", () => {
    expect(formatVnd(0n)).toBe("0đ");
    expect(formatVnd("0")).toBe("0đ");
  });

  it("định dạng các giá trị VND thông thường", () => {
    expect(formatVnd("280000")).toBe("280.000đ");
    expect(formatVnd("1500000")).toBe("1.500.000đ");
    expect(formatVnd(280000n)).toBe("280.000đ");
  });

  it("định dạng chính xác các số lớn hơn 2^53 mà không mất độ chính xác", () => {
    // 2^53 = 9007199254740992
    const bigNumStr = "9007199254740993"; // 2^53 + 1
    expect(formatVnd(bigNumStr)).toBe("9.007.199.254.740.993đ");
    expect(formatVnd(BigInt(bigNumStr))).toBe("9.007.199.254.740.993đ");

    const veryLarge = "10000000000000000000";
    expect(formatVnd(veryLarge)).toBe("10.000.000.000.000.000.000đ");
  });

  it("ném lỗi khi truyền vào chuỗi không hợp lệ", () => {
    expect(() => formatVnd("")).toThrow("Chuỗi tiền VND không hợp lệ");
    expect(() => formatVnd("abc")).toThrow("Chuỗi tiền VND không hợp lệ");
    expect(() => formatVnd("12.5")).toThrow("Chuỗi tiền VND không hợp lệ");
    expect(() => formatVnd("280,000")).toThrow("Chuỗi tiền VND không hợp lệ");
    expect(() => formatVnd("100k")).toThrow("Chuỗi tiền VND không hợp lệ");
    expect(() => formatVnd("   ")).toThrow("Chuỗi tiền VND không hợp lệ");
  });
});

describe("datetime helpers", () => {
  it("định dạng ngày tháng và giờ theo định dạng Việt Nam", () => {
    const iso = "2026-10-14T14:30:00.000Z";
    expect(formatDateVi(iso)).toBe("14/10/2026");
    expect(formatTimeVi(iso)).toBe("21:30");
    expect(formatDateTimeVi(iso)).toBe("21:30 14/10/2026");
    expect(formatDateVi("2026-10-14T18:00:00Z")).toBe("15/10/2026");
  });
});
