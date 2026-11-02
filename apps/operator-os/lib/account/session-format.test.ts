import { describe, expect, it } from "vitest";

import type { Session } from "./session-api";
import { lastUsedLabel, otherSessions, sortSessions } from "./session-format";

const NOW = new Date("2026-10-14T09:00:00+07:00").getTime();
const ago = (ms: number) => new Date(NOW - ms).toISOString();
const MINUTE = 60_000;
const HOUR = 60 * MINUTE;
const DAY = 24 * HOUR;

function session(sessionId: string, lastUsedMsAgo: number, current = false): Session {
  return {
    sessionId,
    current,
    deviceLabel: "Chrome trên Windows",
    ipAddress: "113.161.***.***",
    createdAt: ago(10 * DAY),
    lastUsedAt: ago(lastUsedMsAgo),
    expiresAt: ago(-20 * DAY)
  };
}

describe("lastUsedLabel", () => {
  it.each([
    [0, "Vừa xong"],
    [59_000, "Vừa xong"],
    [MINUTE, "1 phút trước"],
    [59 * MINUTE, "59 phút trước"],
    [HOUR, "1 giờ trước"],
    [23 * HOUR + 59 * MINUTE, "23 giờ trước"],
    [DAY, "1 ngày trước"],
    [8 * DAY + HOUR, "8 ngày trước"]
  ])("%i ms trước → %s", (elapsed, label) => {
    expect(lastUsedLabel(ago(elapsed), NOW)).toBe(label);
  });

  it("đồng hồ máy khách chậm hơn máy chủ (mốc ở tương lai) vẫn ghi Vừa xong", () => {
    expect(lastUsedLabel(ago(-5 * MINUTE), NOW)).toBe("Vừa xong");
  });
});

describe("sắp xếp phiên", () => {
  const sessions = [session("cũ", 8 * DAY), session("đang dùng", 2 * HOUR, true), session("mới", 5 * MINUTE)];

  it("phiên đang dùng đứng đầu dù không phải phiên dùng gần nhất, còn lại theo lần dùng gần nhất", () => {
    expect(sortSessions(sessions).map((item) => item.sessionId)).toEqual(["đang dùng", "mới", "cũ"]);
    expect(sessions.map((item) => item.sessionId)).toEqual(["cũ", "đang dùng", "mới"]);
  });

  it("các phiên khác không gồm phiên đang dùng", () => {
    expect(otherSessions(sessions).map((item) => item.sessionId)).toEqual(["cũ", "mới"]);
    expect(otherSessions([session("đang dùng", 0, true)])).toEqual([]);
  });
});
