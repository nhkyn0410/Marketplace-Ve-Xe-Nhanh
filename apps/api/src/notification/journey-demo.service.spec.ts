import { randomUUID } from "node:crypto";
import { afterEach, describe, expect, it, vi } from "vitest";
import type Redis from "ioredis";
import type { Queue } from "bullmq";
import { parseAppConfig } from "../config/env.config";
import type { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { JourneyDemoService } from "./journey-demo.service";

const userId = randomUUID();
const deviceId = randomUUID();
const bookingId = randomUUID();
const actor = { sub: userId, sid: randomUUID(), scope: "passenger", role: "PASSENGER" } as VerifiedAccessToken;

function harness(enabled = true) {
  const values = new Map<string, string>();
  const redis = {
    get: vi.fn(async (key: string) => values.get(key) ?? null),
    set: vi.fn(async (key: string, value: string, ...options: unknown[]) => {
      if (options.includes("NX") && values.has(key)) return null;
      values.set(key, value); return "OK";
    }),
    eval: vi.fn(async (_script: string, _count: number, key: string, token: string) => { if (values.get(key) === token) values.delete(key); return 1; }),
  };
  let active = true;
  const tx = {
    pushDevice: { findFirst: vi.fn(async ({ where }: { where: { id: string; subjectId: string } }) => active && where.id === deviceId && where.subjectId === userId ? { token: "secret-token" } : null) },
    booking: { findFirst: vi.fn(async ({ where }: { where: { id: string; userId: string } }) => where.id === bookingId && where.userId === userId ? { operatorId: "operator-a", tripId: "trip-a", pickupSequence: 1, dropoffSequence: 3, trip: { route: { name: "TP. HCM → Đà Lạt" } } } : null) },
    tripStop: { findMany: vi.fn(async () => ["TP. Hồ Chí Minh", "Đồng Nai", "Lâm Đồng"].map((name) => ({ catalogStopPoint: { ward: { province: { name } } }, stopPoint: null }))) },
  };
  const prisma = { withSystem: async (work: (transaction: typeof tx) => unknown) => work(tx) };
  const queue = { add: vi.fn(async () => ({})), addBulk: vi.fn(async () => []) };
  const push = { send: vi.fn(async () => "SENT" as const) };
  const config = parseAppConfig({ JOURNEY_DEMO_ENABLED: enabled ? "true" : "false" });
  const service = new JourneyDemoService(prisma as unknown as PrismaService, redis as unknown as Redis, queue as unknown as Queue, push, config);
  return { service, values, tx, queue, push, config, disableDevice: () => { active = false; } };
}

afterEach(() => vi.useRealTimers());

describe("Android journey demo sandbox", () => {
  it("cờ tắt và production luôn 404, dù bật cờ trong production", async () => {
    const h = harness(false);
    await expect(h.service.start(actor, { bookingId, deviceId })).rejects.toMatchObject({ status: 404 });
    h.config.JOURNEY_DEMO_ENABLED = "true"; h.config.NODE_ENV = "production";
    await expect(h.service.current(actor, deviceId)).rejects.toMatchObject({ status: 404 });
    expect(h.tx.booking.findFirst).not.toHaveBeenCalled();
  });

  it("chặn namespace khác, thiết bị và booking của người khác trước khi tạo session", async () => {
    const h = harness();
    await expect(h.service.start({ ...actor, scope: "operator", role: "OPERATOR_OWNER" }, { bookingId, deviceId })).rejects.toMatchObject({ status: 403 });
    await expect(h.service.start({ ...actor, sub: randomUUID() }, { bookingId, deviceId })).rejects.toMatchObject({ status: 404 });
    await expect(h.service.start(actor, { bookingId: randomUUID(), deviceId })).rejects.toMatchObject({ status: 404 });
    expect(h.queue.addBulk).not.toHaveBeenCalled();
  });

  it("start lặp lại cùng booking/thiết bị tái dùng session, lịch và dữ liệu tenant đúng phạm vi", async () => {
    const h = harness();
    const first = await h.service.start(actor, { bookingId, deviceId });
    const second = await h.service.start(actor, { bookingId, deviceId });
    expect(second).toEqual(first);
    expect(h.queue.addBulk).toHaveBeenCalledTimes(1);
    expect(h.tx.tripStop.findMany).toHaveBeenCalledWith(expect.objectContaining({ where: { tripId: "trip-a", operatorId: "operator-a", sequence: { gte: 1, lte: 3 } } }));
    expect(first.provinceName).toBe("TP. Hồ Chí Minh");
    expect(await h.service.current(actor, deviceId)).toEqual(first);
  });

  it("worker gửi tiến độ và tỉnh mô phỏng, bỏ snapshot đã gửi hoặc revision cũ", async () => {
    const h = harness(); const start = await h.service.start(actor, { bookingId, deviceId });
    const job = { sessionId: start.sessionId, deviceId, revision: 3 };
    await h.service.tick(job); await h.service.tick(job); await h.service.tick({ ...job, revision: 2 });
    expect(h.push.send).toHaveBeenCalledTimes(1);
    expect(h.push.send).toHaveBeenCalledWith("secret-token", expect.objectContaining({ revision: 3, progress: 500, provinceName: "Đồng Nai", stage: "travelling" }));
    expect(h.queue.addBulk).toHaveBeenCalledTimes(1);
  });

  it("retry push lỗi dùng cùng revision; stop ghi trước khi job kết thúc gửi và không hồi sinh", async () => {
    const h = harness(); const start = await h.service.start(actor, { bookingId, deviceId });
    const tick = { sessionId: start.sessionId, deviceId, revision: 2 };
    h.push.send.mockRejectedValueOnce(new Error("network"));
    await expect(h.service.tick(tick)).rejects.toThrow("network");
    await h.service.tick(tick);
    await h.service.stop(actor, start.sessionId);
    await h.service.tick({ ...tick, revision: 5 });
    expect(h.push.send).toHaveBeenCalledTimes(2);
    h.push.send.mockRejectedValueOnce(new Error("network"));
    await expect(h.service.tick({ ...tick, revision: 7 })).rejects.toThrow("network");
    await h.service.tick({ ...tick, revision: 7 });
    expect(h.push.send).toHaveBeenLastCalledWith("secret-token", expect.objectContaining({ revision: 7, ended: true, stage: "stopped" }));
  });

  it("người khác không đọc/dừng session và thiết bị đăng xuất không nhận thêm push", async () => {
    const h = harness(); const start = await h.service.start(actor, { bookingId, deviceId });
    await expect(h.service.stop({ ...actor, sub: randomUUID() }, start.sessionId)).rejects.toMatchObject({ status: 404 });
    await expect(h.service.current({ ...actor, sub: randomUUID() }, deviceId)).rejects.toMatchObject({ status: 404 });
    h.disableDevice();
    await h.service.tick({ sessionId: start.sessionId, deviceId, revision: 3 });
    expect(h.push.send).not.toHaveBeenCalled();
  });

  it("session quá hạn không gửi và GET trả null", async () => {
    vi.useFakeTimers(); const h = harness(); const start = await h.service.start(actor, { bookingId, deviceId });
    vi.setSystemTime(Date.now() + 241_000);
    await h.service.tick({ sessionId: start.sessionId, deviceId, revision: 4 });
    expect(h.push.send).not.toHaveBeenCalled();
    expect(await h.service.current(actor, deviceId)).toBeNull();
  });
});
