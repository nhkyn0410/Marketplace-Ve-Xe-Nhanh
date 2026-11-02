import { describe, expect, it } from "vitest";

import { eventLines, fullMoment, pendingRequest } from "./support-format";

const event = (overrides: Record<string, unknown>) =>
  ({ eventId: "e", kind: "STATUS", party: "PLATFORM", actorName: "CSKH Vé Xe Nhanh", fromStatus: null, toStatus: null, body: null, target: null, dueAt: null, createdAt: "2026-10-06T07:30:00Z", attachments: [], ...overrides }) as never;

describe("support-format nhà xe (TRUST-001)", () => {
  it("giờ VN", () => {
    expect(fullMoment("2026-10-05T02:12:00Z")).toBe("09:12 · 05/10/2026");
  });

  it("yêu cầu đang chờ nhà xe: chỉ khi tranh chấp đang chờ nhà xe, lấy yêu cầu gần nhất gửi nhà xe", () => {
    const request = event({ eventId: "r2", kind: "REQUEST", target: "OPERATOR", body: "Gửi nhật trình", dueAt: "2026-10-15T10:00:00Z" });
    const events = [event({ eventId: "r1", kind: "REQUEST", target: "OPERATOR" }), request];
    expect(pendingRequest({ status: "WAITING_OPERATOR_RESPONSE", events })).toBe(request);
    expect(pendingRequest({ status: "UNDER_REVIEW", events })).toBeNull();
    expect(eventLines(request)).toEqual({ title: "Vé Xe Nhanh yêu cầu minh chứng", detail: "Gửi nhật trình · hạn 15/10 · 17:00" });
    expect(eventLines(event({ toStatus: "OPEN", body: "Từ khiếu nại KN-1" })).title).toBe("Mở");
  });
});
