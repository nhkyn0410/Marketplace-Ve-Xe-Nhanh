import { describe, expect, it } from "vitest";

import { actionLabel, actorLines, diffRows, formatAuditDateTime, formatAuditTime, periodStart } from "./audit-format";

describe("định dạng màn Nhật ký audit", () => {
  it("nhãn hành động: bảng có sẵn, danh mục ghép từ mã, chưa biết thì giữ mã", () => {
    expect(actionLabel("operator_application.approve")).toBe("Duyệt hồ sơ, cấp tài khoản chủ nhà xe");
    expect(actionLabel("catalog.vehicle_type.deactivate")).toBe("Ngừng dùng loại xe");
    expect(actionLabel("payout.confirm")).toBe("payout.confirm");
  });

  it("người thực hiện: tác vụ nền, tên đăng nhập + vai trò, tài khoản không còn", () => {
    expect(actorLines({ actorType: "SYSTEM", actorName: null, actorRole: null, actorId: null })).toEqual({
      name: "Hệ thống",
      role: "Tác vụ nền"
    });
    expect(actorLines({ actorType: "PLATFORM", actorName: "platform/khanh", actorRole: "PLATFORM_ADMIN", actorId: "a" })).toEqual({
      name: "platform/khanh",
      role: "Quản trị viên"
    });
    expect(actorLines({ actorType: "OPERATOR", actorName: null, actorRole: "OPERATOR", actorId: "b" }).name).toBe(
      "Tài khoản không còn"
    );
  });

  it("giờ Việt Nam có giây; khoảng thời gian tính tới hiện tại", () => {
    expect(formatAuditTime("2026-10-13T02:43:12.000Z")).toBe("13/10 · 09:43:12");
    expect(formatAuditDateTime("2026-10-12T17:05:00.000Z")).toBe("13/10/2026 · 00:05:00");
    const now = Date.UTC(2026, 9, 13);
    expect(periodStart(7, now)).toBe(new Date(now - 7 * 86_400_000).toISOString());
  });

  it("bảng trước và sau: hợp các trường, đánh dấu trường đổi", () => {
    expect(diffRows({ status: "ACTIVE", name: "A" }, { status: "INACTIVE", name: "A", reason: null })).toEqual([
      { field: "status", before: "ACTIVE", after: "INACTIVE", changed: true },
      { field: "name", before: "A", after: "A", changed: false },
      { field: "reason", before: "—", after: "—", changed: false }
    ]);
    expect(diffRows(null, null)).toEqual([]);
  });
});
