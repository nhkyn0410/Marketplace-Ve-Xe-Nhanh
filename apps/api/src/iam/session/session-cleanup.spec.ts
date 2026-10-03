import { describe, expect, it, vi } from "vitest";
import type { PrismaService } from "../../database/prisma.service";
import {
  deleteExpiredSessions,
  SESSION_CLEANUP_SCHEDULE,
} from "./session-cleanup";

describe("deleteExpiredSessions", () => {
  it("chỉ xoá row hết hạn quá 30 ngày", async () => {
    const deleteMany = vi.fn().mockResolvedValue({ count: 3 });
    const withSystem = vi.fn((work: (tx: unknown) => Promise<unknown>) =>
      work({ authSession: { deleteMany } }),
    );
    const prisma = { withSystem } as unknown as PrismaService;
    const now = new Date("2026-09-17T03:00:00.000Z");

    expect(await deleteExpiredSessions(prisma, now)).toBe(3);
    // Bảng có RLS: chạy ngoài ngữ cảnh system thì cron xoá 0 row mà không báo lỗi.
    expect(withSystem).toHaveBeenCalledOnce();
    expect(deleteMany).toHaveBeenCalledWith({
      where: { expiresAt: { lt: new Date("2026-08-18T03:00:00.000Z") } },
    });
  });

  it("lịch chạy 03:00 giờ VN mỗi ngày", () => {
    expect(SESSION_CLEANUP_SCHEDULE).toEqual({
      pattern: "0 3 * * *",
      tz: "Asia/Ho_Chi_Minh",
    });
  });
});
