import { describe, expect, it } from "vitest";
import { SalesOfficeAssignmentsInputSchema, SalesOfficeInputSchema, SalesOfficeUpdateSchema } from "./sales-office";

describe("Văn phòng bán vé — dữ liệu dùng chung", () => {
  const office = { code: " vp_01 ", name: " Bến xe Miền Đông ", address: " 501 Hoàng Hữu Nam " };

  it("chuẩn hóa mã, bỏ khoảng trắng và mặc định hoạt động", () => {
    expect(SalesOfficeInputSchema.parse(office)).toEqual({ code: "VP_01", name: "Bến xe Miền Đông", address: "501 Hoàng Hữu Nam", active: true });
  });

  it("không nhận mã có dấu / khoảng trắng, nội dung rỗng, tên quá dài", () => {
    for (const value of [{ ...office, code: "VĂN PHÒNG" }, { ...office, name: " " }, { ...office, address: " " }, { ...office, name: "a".repeat(101) }]) {
      expect(SalesOfficeInputSchema.safeParse(value).success).toBe(false);
    }
  });

  it("cập nhật cần active và phiên bản không âm; phân công không trùng tài khoản", () => {
    expect(SalesOfficeUpdateSchema.safeParse({ ...office, version: 0 }).success).toBe(false);
    expect(SalesOfficeUpdateSchema.safeParse({ ...office, active: false, version: -1 }).success).toBe(false);
    const id = "f7689be4-12ed-4488-9b31-149bb444e307";
    expect(SalesOfficeAssignmentsInputSchema.safeParse({ version: 0, employeeIds: [id, id] }).success).toBe(false);
    expect(SalesOfficeAssignmentsInputSchema.parse({ version: 0, employeeIds: [] }).employeeIds).toEqual([]);
  });
});
