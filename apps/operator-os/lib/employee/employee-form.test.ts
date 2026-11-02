import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import {
  CREATE_REASON,
  describeEmployeeError,
  EMPTY_EMPLOYEE_FORM,
  reasonError,
  toCreateInput,
  toEmployeeForm,
  toUpdateInput,
  validateEmployeeForm,
  type EmployeeFormValues
} from "./employee-form";

const values: EmployeeFormValues = {
  suffix: "tai.khoa",
  contactEmail: " Khoa.Tai@saoviet.vn ",
  role: "DRIVER",
  reason: "Đổi ca làm việc"
};
const saved = { username: "nv.tai.khoa", contactEmail: "khoa.tai@saoviet.vn", role: "DRIVER" } as const;

describe("validateEmployeeForm", () => {
  it("form hợp lệ không có lỗi; thêm mới không cần lý do", () => {
    expect(validateEmployeeForm(values, "edit")).toEqual({});
    expect(validateEmployeeForm({ ...values, reason: "" }, "create")).toEqual({});
  });

  it("form trống: báo cả ba ô, sửa thì thêm ô lý do", () => {
    expect(Object.keys(validateEmployeeForm(EMPTY_EMPLOYEE_FORM, "create"))).toEqual(["suffix", "contactEmail", "role"]);
    expect(Object.keys(validateEmployeeForm(EMPTY_EMPLOYEE_FORM, "edit"))).toEqual([
      "suffix",
      "contactEmail",
      "role",
      "reason"
    ]);
  });

  it.each(["a", "Tai.Khoa", "tài.khoa", "tai khoa", "tai@khoa", "x".repeat(62)])("từ chối phần tên đăng nhập %j", (suffix) => {
    expect(validateEmployeeForm({ ...values, suffix }, "create").suffix).toBeDefined();
  });

  it.each(["ab", "tai_khoa-01", "x".repeat(61)])("nhận phần tên đăng nhập %j", (suffix) => {
    expect(validateEmployeeForm({ ...values, suffix }, "create").suffix).toBeUndefined();
  });

  it.each(["", "khoa", "khoa@", "khoa@saoviet", "kh oa@saoviet.vn"])("từ chối email %j", (contactEmail) => {
    expect(validateEmployeeForm({ ...values, contactEmail }, "create").contactEmail).toBeDefined();
  });
});

describe("reasonError", () => {
  it("3–500 ký tự sau khi bỏ khoảng trắng hai đầu", () => {
    expect(reasonError("  ab  ")).toMatch(/ít nhất 3/);
    expect(reasonError("abc")).toBeNull();
    expect(reasonError("x".repeat(500))).toBeNull();
    expect(reasonError("x".repeat(501))).toMatch(/tối đa 500/);
  });
});

describe("dựng body API", () => {
  it("tạo: thêm tiền tố nv., email chữ thường, lý do có sẵn", () => {
    expect(toCreateInput(values)).toEqual({
      username: "nv.tai.khoa",
      contactEmail: "khoa.tai@saoviet.vn",
      role: "DRIVER",
      reason: CREATE_REASON
    });
  });

  it("form của nhân viên đang sửa: bỏ tiền tố nv., email trống nếu chưa có", () => {
    expect(toEmployeeForm(saved)).toEqual({ ...values, contactEmail: "khoa.tai@saoviet.vn", reason: "" });
    expect(toEmployeeForm({ ...saved, contactEmail: null }).contactEmail).toBe("");
  });

  it("sửa: chỉ gửi trường thật sự đổi, luôn kèm lý do", () => {
    expect(toUpdateInput(saved, { ...values, role: "TICKET_STAFF" })).toEqual({
      role: "TICKET_STAFF",
      reason: "Đổi ca làm việc"
    });
    expect(toUpdateInput(saved, { ...values, suffix: "tai.khoa2", contactEmail: "moi@saoviet.vn" })).toEqual({
      username: "nv.tai.khoa2",
      contactEmail: "moi@saoviet.vn",
      reason: "Đổi ca làm việc"
    });
  });

  it("sửa: không đổi gì (kể cả email chỉ khác hoa thường) thì không gửi", () => {
    expect(toUpdateInput(saved, values)).toBeNull();
  });
});

describe("describeEmployeeError", () => {
  it.each([
    ["AUTH_INVALID_CREDENTIALS", 401, "identity", /không đúng/],
    ["AUTH_REAUTH_REQUIRED", 401, "identity", /xác nhận lại danh tính/],
    ["AUTH_OTP_RATE_LIMITED", 429, "identity", /quá nhiều lần/],
    ["ACCOUNT_USERNAME_CONFLICT", 409, "suffix", /đã có trong nhà xe/],
    ["ACCOUNT_NOT_FOUND", 404, null, /không còn tồn tại/],
    ["ACCOUNT_STATE_CONFLICT", 409, null, /vừa thay đổi/],
    ["AUTH_ACCOUNT_LOCKED", 403, null, /đã bị khóa/],
    ["VALIDATION_ERROR", 400, null, /chưa hợp lệ/]
  ] as const)("%s → ô %s", (code, status, field, message) => {
    const described = describeEmployeeError(new ApiError(status, code, "x"), "update");
    expect(described.field).toBe(field);
    expect(described.message).toMatch(message);
  });

  it("tạo tài khoản mà gửi email lỗi: dặn không tạo lại và yêu cầu tải lại danh sách", () => {
    const described = describeEmployeeError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"), "create");
    expect(described.message).toMatch(/không tạo lại tài khoản/);
    expect(described.refresh).toBe(true);
  });

  it("cấp lại mà gửi email lỗi: nói rõ mật khẩu cũ có thể đã hết hiệu lực và phải chờ một giờ", () => {
    const failed = new ApiError(503, "SERVICE_UNAVAILABLE", "x");
    expect(describeEmployeeError(failed, "reset")).toMatchObject({
      message: expect.stringMatching(/mật khẩu cũ đã hết hiệu lực.*sau ít nhất một giờ/),
      refresh: true
    });
    expect(describeEmployeeError(failed, "update").message).toMatch(/Máy chủ đang bận/);
  });

  it("giới hạn gửi mật khẩu tạm: cấp lại thì nhắc mốc một lần mỗi giờ", () => {
    const limited = new ApiError(429, "ACCOUNT_TEMP_EMAIL_RATE_LIMITED", "x");
    expect(describeEmployeeError(limited, "reset").message).toMatch(/một lần mỗi giờ/);
    expect(describeEmployeeError(limited, "create").message).not.toMatch(/mỗi giờ/);
  });

  it("lỗi mạng → câu chung, không tải lại danh sách", () => {
    expect(describeEmployeeError(new TypeError("Failed to fetch"), "update")).toEqual({
      field: null,
      message: "Chưa thực hiện được. Vui lòng kiểm tra kết nối và thử lại.",
      refresh: false
    });
  });
});
