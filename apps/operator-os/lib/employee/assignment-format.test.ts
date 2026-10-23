import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { Employee } from "./employee-api";
import { assignmentState, conflictNote, describeAssignError, driverOptions } from "./assignment-format";

const employee = (username: string, role: Employee["role"], status: Employee["status"] = "ACTIVE") =>
  ({ id: username, username, role, status }) as unknown as Employee;

describe("màn Phân công chuyến (EMP-001)", () => {
  it("tình trạng: trùng lịch > đã phân công > chưa phân công", () => {
    const driver = { employeeId: "e", username: "nv.tai", status: "ACTIVE" as const };
    const conflict = { tripId: "t", departureAt: "2026-10-15T23:00:00.000Z", arrivalAt: "2026-10-16T04:30:00.000Z" };
    expect(assignmentState({ driver, conflict: null }, false)).toEqual({ label: "Đã phân công", tone: "success" });
    expect(assignmentState({ driver: null, conflict: null }, false)).toEqual({ label: "Chưa phân công", tone: "warning" });
    expect(assignmentState({ driver, conflict }, false).label).toBe("Trùng lịch");
    expect(assignmentState({ driver: null, conflict: null }, true).label).toBe("Trùng lịch");
    expect(conflictNote(conflict)).toBe("Trùng giờ chạy với chuyến 06:00 – 11:30");
  });

  it("chỉ tài xế đang hoạt động, sắp theo tên đăng nhập", () => {
    const options = driverOptions([
      employee("nv.tai.minh", "DRIVER"),
      employee("nv.ve.lan", "TICKET_STAFF"),
      employee("nv.tai.an", "DRIVER"),
      employee("nv.tai.khoa", "DRIVER", "LOCKED")
    ]);
    expect(options.map((option) => option.username)).toEqual(["nv.tai.an", "nv.tai.minh"]);
  });

  it("lỗi phân công: trùng giờ giữ câu máy chủ, mã khác có câu riêng, lỗi mạng câu chung", () => {
    const clash = "Tài xế đã chạy chuyến 06:00 16/10 – 11:30 16/10 trùng giờ với chuyến này.";
    expect(describeAssignError(new ApiError(409, "DRIVER_SCHEDULE_CONFLICT", clash))).toBe(clash);
    expect(describeAssignError(new ApiError(422, "ASSIGNMENT_REASON_REQUIRED", "x"))).toContain("lý do");
    expect(describeAssignError(new ApiError(503, "SERVICE_UNAVAILABLE", "x"))).toContain("thử lại");
    expect(describeAssignError(new Error("mạng"))).toContain("kết nối");
  });
});
