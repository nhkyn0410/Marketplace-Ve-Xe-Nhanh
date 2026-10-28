import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { OperatorProfile } from "./profile-api";
import {
  bankChangeFormSchema,
  describeProfileError,
  formatDate,
  initialsOf,
  profileFormSchema,
  toAccountHolder,
  toProfileForm,
  toProfileInput
} from "./profile-format";

const profile = {
  displayName: "Sao Việt Express",
  hotline: null,
  publicEmail: "lienhe@saoviet.vn",
  address: "266 Đồng Đen",
  description: null
} as OperatorProfile;

describe("hồ sơ nhà xe — form", () => {
  it("chuyển hồ sơ ↔ form: trường trống thành chuỗi rỗng; gửi đi bỏ dấu cách / chấm ở hotline, mô tả rỗng thành null", () => {
    const values = toProfileForm(profile);
    expect(values).toEqual({ displayName: "Sao Việt Express", hotline: "", publicEmail: "lienhe@saoviet.vn", address: "266 Đồng Đen", description: "" });
    expect(toProfileInput({ ...values, hotline: "1900.6868", description: "  " })).toEqual({
      displayName: "Sao Việt Express",
      hotline: "19006868",
      publicEmail: "lienhe@saoviet.vn",
      address: "266 Đồng Đen",
      description: null
    });
  });

  it("kiểm form sửa hồ sơ: tên trống, hotline ngắn, email sai", () => {
    const result = profileFormSchema.safeParse({ displayName: " ", hotline: "123", publicEmail: "x", address: "A", description: "" });
    expect(result.success).toBe(false);
    expect(result.error?.issues.map((issue) => issue.path[0])).toEqual(["displayName", "hotline", "publicEmail"]);
  });

  it("đổi tài khoản: chủ tài khoản bỏ dấu + viết hoa; số tài khoản 6–20 chữ số; lý do 3–500 ký tự", () => {
    expect(toAccountHolder("Công ty Đông Á")).toBe("CONG TY DONG A");
    expect(
      bankChangeFormSchema.safeParse({ bankName: "ACB", accountNumber: "1903 6688 0011", accountHolder: "Sao Việt", reason: "Đổi tài khoản" })
        .success
    ).toBe(true);
    const bad = bankChangeFormSchema.safeParse({ bankName: "", accountNumber: "12ab", accountHolder: "Ω", reason: "ab" });
    expect(bad.error?.issues.map((issue) => issue.path[0])).toEqual(["bankName", "accountNumber", "accountHolder", "reason"]);
  });

  it("chữ viết tắt logo và ngày theo giờ Việt Nam", () => {
    expect(initialsOf("Sao Việt Express")).toBe("SV");
    expect(initialsOf("phuongtrang")).toBe("PH");
    expect(formatDate("2026-08-11T18:00:00Z")).toBe("12/08/2026");
  });

  it("thông báo lỗi: ô xác nhận danh tính, yêu cầu đang chờ, 503, mạng", () => {
    expect(describeProfileError(new ApiError(401, "AUTH_INVALID_CREDENTIALS", ""))).toEqual({
      field: "identity",
      message: "Mật khẩu hoặc mã xác thực không đúng."
    });
    expect(describeProfileError(new ApiError(409, "BANK_ACCOUNT_CHANGE_PENDING", "")).message).toMatch(/đang chờ xác minh/);
    expect(describeProfileError(new ApiError(422, "OPERATOR_LOGO_INVALID", "")).message).toMatch(/Logo không hợp lệ/);
    expect(describeProfileError(new ApiError(503, "SERVICE_UNAVAILABLE", "")).message).toMatch(/chưa đổi gì/);
    expect(describeProfileError(new TypeError("fetch failed")).message).toMatch(/Không kết nối được/);
  });
});
