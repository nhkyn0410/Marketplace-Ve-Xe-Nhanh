import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import { describeRemoveError, formatPlateNumber, removeReasonError } from "./moderation-format";

describe("định dạng màn Kiểm duyệt ảnh phương tiện", () => {
  it("lý do gỡ 3–500 ký tự, tính sau khi bỏ khoảng trắng", () => {
    expect(removeReasonError("  ab ")).not.toBeNull();
    expect(removeReasonError("x".repeat(501))).not.toBeNull();
    expect(removeReasonError("Ảnh có giấy tờ xe")).toBeNull();
  });

  it("biển số chuẩn hoá → dạng hiển thị", () => {
    expect(formatPlateNumber("51B28912")).toBe("51B-289.12");
    expect(formatPlateNumber("29LD1234")).toBe("29LD-1234");
    expect(formatPlateNumber("lạ")).toBe("lạ");
  });

  it("lỗi gỡ ảnh: ảnh không còn → tải lại; 503 → thử lại sau; mất mạng", () => {
    expect(describeRemoveError(new ApiError(404, "VEHICLE_IMAGE_NOT_FOUND", "x"))).toMatchObject({ refresh: true });
    expect(describeRemoveError(new ApiError(503, "SERVICE_UNAVAILABLE", "x")).message).toContain("chưa được gỡ");
    expect(describeRemoveError(new TypeError("fetch failed")).message).toContain("Không kết nối");
  });
});
