import { describe, expect, it } from "vitest";

import { formatDateVi, formatDateTimeVi, formatTimeVi, formatTripDateVi, formatVnd, vnDayOffset } from "./index";

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

describe("formatTripDateVi", () => {
  it("thêm thứ viết tắt và đổi sang dd/mm/yyyy", () => {
    expect(formatTripDateVi("2026-10-16")).toBe("T6, 16/10/2026");
    expect(formatTripDateVi("2026-10-18")).toBe("CN, 18/10/2026");
  });

  it("giữ nguyên chuỗi không đúng dạng YYYY-MM-DD", () => {
    expect(formatTripDateVi("")).toBe("");
    expect(formatTripDateVi("16/10/2026")).toBe("16/10/2026");
  });
});

describe("vnDayOffset", () => {
  it("tính chênh ngày theo giờ Việt Nam, kể cả khi giờ UTC cùng ngày", () => {
    // 22:30 VN ngày 16 = 15:30 UTC ngày 16; 05:30 VN ngày 17 = 22:30 UTC ngày 16
    expect(vnDayOffset("2026-10-16T15:30:00Z", "2026-10-16T22:30:00Z")).toBe(1);
    expect(vnDayOffset("2026-10-16T01:00:00Z", "2026-10-16T08:00:00Z")).toBe(0);
  });

  it("trả 0 khi thiếu hoặc sai dữ liệu", () => {
    expect(vnDayOffset(undefined, "2026-10-16T22:30:00Z")).toBe(0);
    expect(vnDayOffset("abc", "2026-10-16T22:30:00Z")).toBe(0);
  });
});
