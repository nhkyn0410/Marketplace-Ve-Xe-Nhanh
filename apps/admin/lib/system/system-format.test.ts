import { describe, expect, it } from "vitest";

import { isOverdue, jobState, scheduleLabel, type BackgroundJob } from "./system-format";

const job = (lastRun: BackgroundJob["lastRun"]): BackgroundJob => ({
  queue: "q",
  name: "session-cleanup",
  label: "Dọn phiên",
  schedule: "0 3 * * *",
  nextRunAt: null,
  lastRun,
  failedCount: 0
});

describe("tích hợp & hệ thống — định dạng", () => {
  it("lịch cron hằng ngày → chữ; dạng khác giữ nguyên; không lịch = theo yêu cầu", () => {
    expect(scheduleLabel("0 3 * * *")).toBe("Hằng ngày · 03:00");
    expect(scheduleLabel("45 3 * * *")).toBe("Hằng ngày · 03:45");
    expect(scheduleLabel("*/5 * * * *")).toBe("*/5 * * * *");
    expect(scheduleLabel(null)).toBe("Theo yêu cầu");
  });

  it("trạng thái lần chạy gần nhất", () => {
    expect(jobState(job(null))).toMatchObject({ label: "Chưa chạy" });
    expect(jobState(job({ state: "completed", at: "2026-10-16T20:00:00.000Z", processed: 3, error: null, attempts: 1 }))).toEqual({
      label: "Hoàn tất",
      tone: "success",
      note: null
    });
    expect(jobState(job({ state: "failed", at: "2026-10-16T20:00:00.000Z", processed: null, error: "timeout", attempts: 3 }))).toEqual({
      label: "Lỗi",
      tone: "danger",
      note: "timeout"
    });
  });
});

describe("lần chạy kế", () => {
  it("trễ hơn 5 phút so với lịch → trễ; chưa tới / không lịch → không", () => {
    const now = Date.UTC(2026, 9, 16, 12, 0);
    expect(isOverdue(new Date(now - 10 * 60_000).toISOString(), now)).toBe(true);
    expect(isOverdue(new Date(now - 60_000).toISOString(), now)).toBe(false);
    expect(isOverdue(new Date(now + 60_000).toISOString(), now)).toBe(false);
    expect(isOverdue(null, now)).toBe(false);
  });
});
