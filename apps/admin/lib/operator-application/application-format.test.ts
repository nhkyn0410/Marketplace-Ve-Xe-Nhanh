import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import {
  describeReviewError,
  formatLongDateTime,
  formatShortDateTime,
  formatTaxCode,
  reasonError,
  slugError,
  submittedSince,
  suggestSlug,
  usernameError
} from "./application-format";

describe("định dạng màn Nhà xe & KYC", () => {
  it("giờ hiển thị theo giờ Việt Nam", () => {
    expect(formatShortDateTime("2026-10-13T03:40:00.000Z")).toBe("13/10 · 10:40");
    expect(formatLongDateTime("2026-10-13T17:05:00.000Z")).toBe("00:05 · 14/10/2026");
  });

  it("mã số thuế tách nhóm, chi nhánh giữ đuôi", () => {
    expect(formatTaxCode("0312345678")).toBe("0312 345 678");
    expect(formatTaxCode("0312345678001")).toBe("0312 345 678-001");
  });

  it("khoảng thời điểm gửi tính lùi từ hiện tại", () => {
    expect(submittedSince(7, Date.parse("2026-10-15T00:00:00.000Z"))).toBe("2026-10-08T00:00:00.000Z");
  });

  it("slug gợi ý bỏ dấu, chữ thường; kiểm slug / tên đăng nhập như máy chủ", () => {
    expect(suggestSlug("Sao Việt Express")).toBe("saovietexpress");
    expect(suggestSlug("Đồng Tâm")).toBe("dongtam");
    expect(slugError("saoviet")).toBeNull();
    expect(slugError("platform")).not.toBeNull();
    expect(slugError("-sao")).not.toBeNull();
    expect(slugError("SaoViet")).not.toBeNull();
    expect(slugError("ab")).not.toBeNull();
    expect(usernameError("owner01")).toBeNull();
    expect(usernameError("nv.owner")).not.toBeNull();
    expect(usernameError("chủ")).not.toBeNull();
  });

  it("lý do 3–500 ký tự", () => {
    expect(reasonError("  ab ")).not.toBeNull();
    expect(reasonError("Thiếu giấy phép")).toBeNull();
    expect(reasonError("x".repeat(501))).not.toBeNull();
  });

  it("lỗi máy chủ → ô báo lỗi và có tải lại hồ sơ hay không", () => {
    expect(describeReviewError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", "x")).field).toBe("identity");
    expect(describeReviewError(new ApiError(409, "OPERATOR_SLUG_CONFLICT", "x")).field).toBe("slug");
    expect(describeReviewError(new ApiError(409, "OPERATOR_APPLICATION_INVALID_STATE", "x"))).toMatchObject({
      field: "form",
      refresh: true
    });
    expect(describeReviewError(new TypeError("fetch failed")).field).toBe("form");
  });
});
