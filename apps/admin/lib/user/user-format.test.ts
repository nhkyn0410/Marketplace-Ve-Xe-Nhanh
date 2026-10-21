import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import { describeAccountError, emailError, formatDateTime, lockReasonError, openSaleLabel, platformUsernameError } from "./user-format";

describe("định dạng màn Nhà xe + Người dùng", () => {
  it("lý do khóa 3–500 ký tự; tên đăng nhập quản trị; email", () => {
    expect(lockReasonError(" ab ")).not.toBeNull();
    expect(lockReasonError("Vi phạm chất lượng")).toBeNull();
    expect(platformUsernameError("ngoc.finance")).toBeNull();
    expect(platformUsernameError("Ngoc.Finance")).toBeNull();
    expect(platformUsernameError("ab")).not.toBeNull();
    expect(platformUsernameError("có dấu")).not.toBeNull();
    expect(emailError("ngoc@vexenhanh.vn")).toBeNull();
    expect(emailError("ngoc@")).not.toBeNull();
  });

  it("cột Đang mở bán của nhà xe", () => {
    expect(openSaleLabel({ status: "ACTIVE", routeCount: 3, openTripCount: 32 })).toBe("3 tuyến · 32 chuyến");
    expect(openSaleLabel({ status: "ACTIVE", routeCount: 0, openTripCount: 0 })).toBe("Chưa có chuyến");
    expect(openSaleLabel({ status: "SUSPENDED", routeCount: 3, openTripCount: 0 })).toBe("Không mở bán");
  });

  it("giờ Việt Nam; lỗi → ô xác nhận danh tính / tên đăng nhập / báo chung", () => {
    expect(formatDateTime("2026-10-13T00:58:00.000Z")).toBe("13/10/2026 · 07:58");
    expect(formatDateTime(null)).toBe("—");
    expect(describeAccountError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", "x")).field).toBe("identity");
    expect(describeAccountError(new ApiError(409, "PLATFORM_ACCOUNT_CONFLICT", "x")).field).toBe("username");
    expect(describeAccountError(new ApiError(409, "OPERATOR_STATE_INVALID", "x"))).toMatchObject({ field: "form", refresh: true });
    expect(describeAccountError(new ApiError(409, "PLATFORM_ACCOUNT_LAST_ADMIN", "x")).message).toContain("ít nhất một");
  });
});
