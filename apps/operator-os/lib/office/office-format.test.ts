import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import { describeOfficeError, officeAssignmentOptions } from "./office-format";

describe("phân công văn phòng bán vé", () => {
  it("giữ phân công cũ của tài khoản đã khóa để chủ nhà xe nhìn thấy và có thể gỡ", () => {
    const options = officeAssignmentOptions(
      [{ id: "new", username: "banve", status: "ACTIVE", role: "SALES_STAFF" }, { id: "hidden", username: "unused", status: "DISABLED", role: "SALES_STAFF" }],
      [{ employeeId: "old", username: "ketoan", status: "LOCKED" }]
    );
    expect(options).toEqual([
      { employeeId: "new", username: "banve", status: "ACTIVE", assigned: false },
      { employeeId: "old", username: "ketoan", status: "LOCKED", assigned: true }
    ]);
  });

  it("dùng trạng thái tài khoản hiện tại và chỉ hiện một lựa chọn cho mỗi tài khoản", () => {
    const options = officeAssignmentOptions(
      [{ id: "account", username: "dieuphoi", status: "LOCKED", role: "SALES_STAFF" }],
      [{ employeeId: "account", username: "dieuphoi", status: "ACTIVE" }]
    );
    expect(options).toEqual([{ employeeId: "account", username: "dieuphoi", status: "LOCKED", assigned: true }]);
  });

  it("không phân công nhầm tài xế, và hiển thị phân công cũ đã đổi vai trò để gỡ", () => {
    const options = officeAssignmentOptions(
      [{ id: "driver", username: "nv.driver", status: "ACTIVE", role: "DRIVER" }, { id: "old", username: "nv.changed", status: "ACTIVE", role: "TICKET_STAFF" }],
      [{ employeeId: "old", username: "nv.changed", status: "ACTIVE" }]
    );
    expect(options).toEqual([{ employeeId: "old", username: "nv.changed", status: "DISABLED", assigned: true }]);
  });

  it("xung đột phiên bản hoặc mất quyền yêu cầu tải lại, trùng mã cho phép sửa và gửi lại", () => {
    expect(describeOfficeError(new ApiError(409, "OFFICE_VERSION_CONFLICT", "x"))).toMatchObject({ stale: true });
    expect(describeOfficeError(new ApiError(403, "AUTH_FORBIDDEN", "x"))).toMatchObject({ stale: true });
    expect(describeOfficeError(new ApiError(409, "OFFICE_CODE_CONFLICT", "x"))).toMatchObject({ stale: false });
    expect(describeOfficeError(new Error("offline"))).toMatchObject({ stale: false });
  });
});
