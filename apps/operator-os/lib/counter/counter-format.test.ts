import { describe, expect, it } from "vitest";

import { counterBookingLabel, counterExceptionLabel, counterMoney, counterTicketLabel, counterToday, isDoubleSeat, receiptInputError, selectedCounterTotal } from "./counter-format";

describe("tiền và xác nhận thu quầy", () => {
  it("không mất đồng khi tổng và định dạng lớn hơn giới hạn số nguyên number", () => {
    const seats = [{ code: "A1", price: "9007199254740993" }, { code: "A2", price: "2" }];
    expect(selectedCounterTotal(seats, ["A1", "A2"])).toBe("9007199254740995");
    expect(counterMoney("9007199254740995")).toBe("9.007.199.254.740.995 ₫");
  });

  it("lọc ngày theo Việt Nam dù máy bán vé ở múi giờ khác", () => {
    expect(counterToday(new Date("2026-10-26T18:30:00Z"))).toBe("2026-10-27");
  });

  it("yêu cầu tiền nguyên dương và tham chiếu ngân hàng, vẫn ghi số tiền lệch để xử lý ngoại lệ", () => {
    expect(receiptInputError("CASH", "300000", "")).toBeNull();
    expect(receiptInputError("BANK_TRANSFER", "299999", " BANK-REF ")).toBeNull();
    expect(receiptInputError("BANK_TRANSFER", "300000", "  ")).not.toBeNull();
    for (const amount of ["0", "-1", "1.5", "300.000", "1e6"]) expect(receiptInputError("CASH", amount, "")).not.toBeNull();
  });

  it("người bán thấy kết quả nghiệp vụ thay cho mã ngoại lệ nội bộ", () => {
    expect(counterExceptionLabel("AMOUNT_MISMATCH")).toContain("Số tiền thực nhận khác số phải thu");
    expect(counterExceptionLabel("TRIP_CLOSED")).toContain("Chuyến đã khởi hành hoặc đã dừng bán");
    expect(counterExceptionLabel("ISSUANCE_FAILED")).toContain("Đã ghi nhận tiền");
    expect(counterExceptionLabel("FUTURE_INTERNAL_CODE")).not.toContain("FUTURE_INTERNAL_CODE");
    expect(counterBookingLabel("EXPIRED")).toBe("Hết hạn giữ chỗ");
    expect(counterTicketLabel("CANCELLED")).toBe("Đã hủy");
  });
});

describe("người đi cùng trên chỗ đôi (BR-78 bổ sung)", () => {
  it("chỉ giường đôi / cabin đôi có ô người đi cùng", () => {
    expect(["SEAT", "BED", "BED_DOUBLE", "CABIN", "CABIN_DOUBLE"].filter(isDoubleSeat)).toEqual(["BED_DOUBLE", "CABIN_DOUBLE"]);
  });
});
