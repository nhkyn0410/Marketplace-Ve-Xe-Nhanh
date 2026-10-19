import { describe, expect, it } from "vitest";

import { defaultDue, displayBookingCode, dueToIso, eventLines, policyLabel, shortMoment } from "./support-format";

describe("support-format (TRUST-001)", () => {
  it("giờ VN, mã đơn", () => {
    expect(shortMoment("2026-10-13T01:15:00Z")).toBe("13/10 · 08:15");
    expect(displayBookingCode("VXN8F3K2Q")).toBe("VXN-8F3K2Q");
  });

  it("chính sách hủy lưu lúc đặt theo mốc giảm dần", () => {
    expect(policyLabel([{ minHoursBefore: 0, refundPercent: 0 }, { minHoursBefore: 24, refundPercent: 90 }])).toBe("Trước 24 giờ: 90% · sau đó: 0%");
    expect(policyLabel([])).toBe("Không có");
  });

  it("hạn phản hồi mặc định 48 giờ tới theo giờ VN; đổi sang ISO có múi giờ", () => {
    expect(defaultDue(Date.parse("2026-10-13T01:00:00Z"))).toBe("2026-10-15T08:00");
    expect(dueToIso("2026-10-15T17:00")).toBe("2026-10-15T17:00:00+07:00");
  });

  it("dòng lịch sử: yêu cầu minh chứng kèm hạn, minh chứng theo bên, đổi trạng thái", () => {
    const base = { eventId: "e", party: "PLATFORM" as const, actorName: "platform/thu", fromStatus: null, toStatus: null, body: null, target: null, dueAt: null, createdAt: "2026-10-06T07:30:00Z", attachments: [] };
    expect(eventLines({ ...base, kind: "REQUEST", target: "OPERATOR", body: "Gửi nhật trình", dueAt: "2026-10-15T10:00:00Z", toStatus: "WAITING_OPERATOR_RESPONSE" })).toEqual({
      title: "Yêu cầu minh chứng của nhà xe",
      detail: "Gửi nhật trình · hạn 15/10 · 17:00 · platform/thu"
    });
    expect(eventLines({ ...base, kind: "EVIDENCE", party: "OPERATOR", actorName: "Sao Việt", body: "Kẹt xe" }).title).toBe("Nhà xe gửi minh chứng");
    expect(eventLines({ ...base, kind: "STATUS", toStatus: "UNDER_REVIEW", body: "Nhà xe đã phản hồi" })).toEqual({ title: "Đang xem xét", detail: "Nhà xe đã phản hồi · platform/thu" });
  });
});
