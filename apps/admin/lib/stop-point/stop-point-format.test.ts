import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import {
  approvalFormSchema,
  describeStopPointError,
  EMPTY_SHARED_FORM,
  formatCount,
  nearbyWarning,
  reasonError,
  sharedFormSchema,
  toApprovalInput,
  toSharedInput
} from "./stop-point-format";

const filled = {
  ...EMPTY_SHARED_FORM,
  name: " Bến xe Miền Đông ",
  type: "BUS_STATION",
  address: "501 Hoàng Hữu Nam",
  provinceId: "p",
  wardId: "w",
  latitude: "10,8787",
  longitude: "106.8164",
  legalBasis: " QĐ 2816/QĐ-SGTVT "
};

describe("form điểm dừng của Admin", () => {
  it("bến xe / điểm dừng đón trả bắt buộc căn cứ; trạm dừng nghỉ không; căn cứ trống gửi null", () => {
    const missing = sharedFormSchema.safeParse({ ...filled, legalBasis: "  " });
    expect(missing.success).toBe(false);
    expect(missing.error?.issues[0]?.path).toEqual(["legalBasis"]);
    const restStop = sharedFormSchema.parse({ ...filled, type: "REST_STOP", legalBasis: "" });
    expect(toSharedInput(restStop).legalBasis).toBeNull();
    expect(toSharedInput(sharedFormSchema.parse(filled))).toMatchObject({
      name: "Bến xe Miền Đông",
      latitude: 10.8787,
      legalBasis: "QĐ 2816/QĐ-SGTVT",
      description: null,
      status: "ACTIVE"
    });
  });

  it("form duyệt đề xuất chỉ nhận bến xe / điểm dừng đón trả, căn cứ bắt buộc", () => {
    expect(approvalFormSchema.safeParse({ ...filled, type: "REST_STOP" }).success).toBe(false);
    expect(approvalFormSchema.safeParse({ ...filled, legalBasis: "" }).success).toBe(false);
    expect(toApprovalInput(approvalFormSchema.parse({ ...filled, type: "PICKUP_POINT" }))).toMatchObject({
      type: "PICKUP_POINT",
      legalBasis: "QĐ 2816/QĐ-SGTVT"
    });
  });

  it("lý do 1–500 ký tự; số đếm có dấu chấm nghìn; cảnh báo điểm gần nhất", () => {
    expect(reasonError("  ")).not.toBeNull();
    expect(reasonError("Sai tọa độ")).toBeNull();
    expect(reasonError("x".repeat(501))).not.toBeNull();
    expect(formatCount(1284)).toBe("1.284");
    expect(nearbyWarning({ nearby: [] })).toBeNull();
    expect(nearbyWarning({ nearby: [{ id: "a", name: "A", latitude: 10, longitude: 106, distanceMeters: 120, routeCount: 0 }] })).toBe(
      "Điểm cùng loại cách 120 m"
    );
  });

  it("lỗi API → ô báo lỗi và có tải lại không", () => {
    expect(describeStopPointError(new ApiError(422, "CATALOG_ITEM_UNAVAILABLE", "x")).field).toBe("wardId");
    expect(describeStopPointError(new ApiError(409, "STOP_POINT_PROPOSAL_STATE_INVALID", "x"))).toMatchObject({ refresh: true });
    expect(describeStopPointError(new TypeError("fetch failed")).field).toBe("form");
  });
});
