import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import { codeError, describeCatalogError, impactRows, nameError, reasonError } from "./catalog-format";

const base = { id: "x", code: "79", name: "TP. Hồ Chí Minh", status: "ACTIVE" as const, createdAt: "", updatedAt: "" };

describe("định dạng màn Danh mục chuẩn", () => {
  it("mã theo loại danh mục: tỉnh 2 số, phường 5 số, loại xe / tiện ích chữ hoa không dấu (tự viết hoa)", () => {
    expect(codeError("provinces", "79")).toBeNull();
    expect(codeError("provinces", "7")).not.toBeNull();
    expect(codeError("wards", "26734")).toBeNull();
    expect(codeError("wards", "2673a")).not.toBeNull();
    expect(codeError("vehicle-types", "sleeper_limousine")).toBeNull();
    expect(codeError("amenities", "wi-fi")).not.toBeNull();
    expect(codeError("amenities", "có")).not.toBeNull();
  });

  it("tên 1–100 ký tự; lý do ngừng dùng 3–500 ký tự", () => {
    expect(nameError("  ")).not.toBeNull();
    expect(nameError("x".repeat(101))).not.toBeNull();
    expect(nameError("Giường nằm")).toBeNull();
    expect(reasonError("ab")).not.toBeNull();
    expect(reasonError("Gộp loại xe")).toBeNull();
  });

  it("mức ảnh hưởng theo loại danh mục (Figma ADM-04c)", () => {
    expect(impactRows("provinces", { ...base, wardCount: 168, stopPointCount: 142 })).toEqual([
      { label: "Phường / xã thuộc tỉnh", value: "168 phường / xã" },
      { label: "Điểm dừng dùng chung trong tỉnh", value: "142 điểm" }
    ]);
    expect(
      impactRows("vehicle-types", {
        ...base,
        description: null,
        form: "CABIN",
        class: "STANDARD",
        vehicleCount: 38,
        operatorCount: 9,
        fareRuleCount: 12
      })
    ).toEqual([
      { label: "Xe đang dùng loại này", value: "38 xe của 9 nhà xe" },
      { label: "Quy tắc giá tham chiếu", value: "12 quy tắc" }
    ]);
    expect(impactRows("amenities", { ...base, vehicleCount: 4 })).toEqual([{ label: "Xe đang khai tiện ích này", value: "4 xe" }]);
  });

  it("lỗi API → ô mã / báo chung, có tải lại không", () => {
    expect(describeCatalogError(new ApiError(409, "CATALOG_CODE_CONFLICT", "x")).field).toBe("code");
    expect(describeCatalogError(new ApiError(409, "CATALOG_STATE_INVALID", "x"))).toMatchObject({ field: "form", refresh: true });
    expect(describeCatalogError(new TypeError("fetch failed")).field).toBe("form");
  });
});
