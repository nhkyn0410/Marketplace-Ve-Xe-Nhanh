import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import {
  bpsToPercentInput,
  describePolicyError,
  formatRate,
  fromVnDateInput,
  fromVnLocalInput,
  parseVnd,
  percentToBps,
  tierLabels,
  tiersError,
  toVnDateInput,
  toVnLocalInput
} from "./policy-format";

describe("chính sách — định dạng", () => {
  it("nhãn bậc hoàn tiền theo Figma 06b, không phụ thuộc thứ tự nhập", () => {
    expect(
      tierLabels([
        { minHoursBefore: 4, refundPercent: 50 },
        { minHoursBefore: 48, refundPercent: 95 },
        { minHoursBefore: 0, refundPercent: 0 },
        { minHoursBefore: 24, refundPercent: 90 }
      ])
    ).toEqual(["Từ 48 giờ trở lên", "Từ 24 giờ đến dưới 48 giờ", "Từ 4 giờ đến dưới 24 giờ", "Dưới 4 giờ"]);
    expect(tierLabels([{ minHoursBefore: 0, refundPercent: 0 }])).toEqual(["Mọi thời điểm"]);
  });

  it("kiểm bậc: thiếu mốc 0 giờ, trùng mốc, sát giờ hoàn cao hơn, ngoài 0–100", () => {
    expect(tiersError([{ minHoursBefore: 24, refundPercent: 90 }])).toMatch(/mốc 0 giờ/);
    expect(tiersError([{ minHoursBefore: 0, refundPercent: 0 }, { minHoursBefore: 0, refundPercent: 10 }])).toMatch(/trùng/);
    expect(tiersError([{ minHoursBefore: 24, refundPercent: 50 }, { minHoursBefore: 0, refundPercent: 80 }])).toMatch(/không được cao hơn/);
    expect(tiersError([{ minHoursBefore: 0, refundPercent: 120 }])).toMatch(/0 đến 100/);
    expect(tiersError([{ minHoursBefore: 24, refundPercent: 90 }, { minHoursBefore: 0, refundPercent: 0 }])).toBeNull();
  });

  it("tỷ lệ phần vạn ↔ phần trăm không qua số thực", () => {
    expect(percentToBps("4,5")).toBe(450);
    expect(percentToBps("4.05")).toBe(405);
    expect(percentToBps("100")).toBe(10_000);
    expect(percentToBps("100,5")).toBeNull();
    expect(percentToBps("4,555")).toBeNull();
    expect(percentToBps("-1")).toBeNull();
    expect(bpsToPercentInput(450)).toBe("4,5");
    expect(bpsToPercentInput(405)).toBe("4,05");
    expect(bpsToPercentInput(500)).toBe("5");
    expect(formatRate(450)).toBe("4,5%");
  });

  it("ngày giờ Việt Nam ↔ ISO; ngày kết thúc hiển thị là ngày cuối còn hiệu lực", () => {
    expect(fromVnLocalInput("2026-11-01T00:00")).toBe("2026-11-01T00:00:00+07:00");
    expect(toVnLocalInput("2026-10-31T17:00:00.000Z")).toBe("2026-11-01T00:00");
    expect(fromVnDateInput("2026-12-31", true)).toBe("2026-12-31T17:00:00.000Z");
    expect(toVnDateInput("2026-12-31T17:00:00.000Z", true)).toBe("2026-12-31");
    expect(fromVnDateInput("2026-10-01")).toBe("2026-09-30T17:00:00.000Z");
    expect(fromVnLocalInput("")).toBeNull();
  });

  it("giá: bỏ dấu chấm / khoảng trắng; trống → null; sai → NaN", () => {
    expect(parseVnd("1.200.000")).toBe(1_200_000);
    expect(parseVnd("")).toBeNull();
    expect(parseVnd("12a")).toBeNaN();
  });

  it("lỗi: ô mã xác thực, xung đột cần tải lại, 503", () => {
    expect(describePolicyError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", ""))).toMatchObject({ field: "identity" });
    expect(describePolicyError(new ApiError(409, "POLICY_SCHEDULE_CONFLICT", "Đã có phiên bản khác."))).toEqual({
      field: "form",
      message: "Đã có phiên bản khác.",
      refresh: true
    });
    expect(describePolicyError(new ApiError(503, "SERVICE_UNAVAILABLE", "")).message).toMatch(/chưa đổi gì/);
  });
});
