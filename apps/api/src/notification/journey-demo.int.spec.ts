import { createHash, randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import Redis from "ioredis";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { createRequestRedisClientOptions } from "../redis/redis.config";
import { JourneyDemoService } from "./journey-demo.service";

const ready = Boolean(process.env.DATABASE_URL && process.env.REDIS_URL);
describe.skipIf(!ready && process.env.REQUIRE_DB_TESTS !== "1")("Journey demo — Postgres app role + Redis thật", () => {
  const tag = randomUUID().slice(0, 8);
  const users = [`journey-owner-${tag}`, `journey-other-${tag}`];
  const operators = [randomUUID(), randomUUID()];
  const routes = [randomUUID(), randomUUID()];
  const trips = [randomUUID(), randomUUID()];
  const bookings = [randomUUID(), randomUUID()];
  const devices = [randomUUID(), randomUUID()];
  const provinces = Array.from({ length: 4 }, () => randomUUID());
  const wards = Array.from({ length: 4 }, () => randomUUID());
  const points = Array.from({ length: 4 }, () => randomUUID());
  const sessions = new Set<string>();
  const actor = { sub: users[0]!, sid: randomUUID(), scope: "passenger", role: "PASSENGER" } as VerifiedAccessToken;
  const other = { ...actor, sub: users[1]! };
  let prisma: PrismaService;
  let redis: Redis;
  let service: JourneyDemoService;
  const push = { send: vi.fn(async () => "SENT" as const) };
  const queue = { add: vi.fn(async () => ({})), addBulk: vi.fn(async () => []) };

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ NODE_ENV: "test", DATABASE_URL: process.env.DATABASE_URL }));
    // Đây là kiểm thử RLS thực: không cho phép chạy bằng owner/superuser rồi báo pass giả.
    expect(await prisma.rlsProblems()).toEqual([]);
    redis = new Redis(process.env.REDIS_URL!, createRequestRedisClientOptions(`journey-integration-${tag}`));
    expect(await redis.ping()).toBe("PONG");
    service = new JourneyDemoService(prisma, redis, queue as unknown as Queue, push, parseAppConfig({ JOURNEY_DEMO_ENABLED: "true" }));
    await prisma.withSystem(async (tx) => {
      for (let i = 0; i < users.length; i++) {
        await tx.user.create({ data: { id: users[i]!, email: `${users[i]}@example.com`, name: "Journey integration" } });
        await tx.operatorProfile.create({ data: { id: operators[i]!, operatorSlug: `jd-${tag}-${i}`, displayName: `Journey operator ${i}` } });
        await tx.route.create({ data: { id: routes[i]!, operatorId: operators[i]!, name: i === 0 ? "TP. HCM → Đà Lạt" : "Tuyến nhà xe khác", totalDistanceMeters: 100000, totalDurationSeconds: 3600, metricsSource: "ESTIMATE" } });
        await tx.trip.create({ data: { id: trips[i]!, operatorId: operators[i]!, routeId: routes[i]!, departureAt: new Date("2032-01-01T01:00:00Z"), arrivalAt: new Date("2032-01-01T03:00:00Z") } });
        await tx.booking.create({ data: { id: bookings[i]!, bookingCode: `VXN${tag.slice(0, 5).toUpperCase()}${i}`, operatorId: operators[i]!, tripId: trips[i]!, userId: users[i]!, holdId: randomUUID(), status: "CONFIRMED", contactName: "Test", contactPhone: "0901234567", contactEmail: `${users[i]}@example.com`, pickupSequence: 1, dropoffSequence: 3, subtotal: 100000n, total: 100000n, snapshot: {}, accessTokenHash: "test", expiresAt: new Date("2032-01-01T00:00:00Z") } });
        const token = `journey-fcm-${tag}-${i}`;
        await tx.pushDevice.create({ data: { id: devices[i]!, subjectId: users[i]!, subjectType: "PASSENGER", provider: "FCM", token, tokenHash: createHash("sha256").update(token).digest("hex") } });
      }
      for (let i = 0; i < provinces.length; i++) {
        await tx.province.create({ data: { id: provinces[i]!, code: `jp-${tag}-${i}`, name: ["TP. Hồ Chí Minh", "Đồng Nai", "Lâm Đồng", "Tỉnh bí mật nhà xe khác"][i]! } });
        await tx.ward.create({ data: { id: wards[i]!, provinceId: provinces[i]!, code: `jw-${tag}-${i}`, name: "Phường kiểm thử" } });
        const operatorIndex = i === 3 ? 1 : 0;
        await tx.stopPoint.create({ data: { id: points[i]!, operatorId: operators[operatorIndex]!, name: `Journey point ${i} ${tag}`, type: "OFFICE", address: "Địa chỉ kiểm thử", provinceId: provinces[i]!, wardId: wards[i]!, latitude: 10 + i, longitude: 106 } });
        await tx.tripStop.create({ data: { operatorId: operators[operatorIndex]!, tripId: trips[operatorIndex]!, sequence: i === 3 ? 1 : i + 1, role: i === 0 || i === 3 ? "ORIGIN" : i === 2 ? "DESTINATION" : "INTERMEDIATE", stopPointId: points[i]!, allowPickup: i === 0 || i === 3, allowDropoff: i === 2, plannedAt: new Date(`2032-01-01T0${i + 1}:00:00Z`) } });
      }
    });
  }, 60_000);

  afterAll(async () => {
    if (redis) {
      // Chỉ dọn UUID của ca kiểm thử, tuyệt đối không FLUSHDB hay quét/xóa khóa chung.
      const keys = [...sessions].map((id) => `journey-demo:session:${id}`).concat(devices.flatMap((id) => [`journey-demo:device:${id}`, `journey-demo:lock:${id}`]));
      if (keys.length) await redis.del(...keys);
      redis.disconnect();
    }
    if (prisma) {
      await prisma.withSystem(async (tx) => {
        await tx.pushDevice.deleteMany({ where: { id: { in: devices } } });
        await tx.booking.deleteMany({ where: { id: { in: bookings } } });
        await tx.tripStop.deleteMany({ where: { tripId: { in: trips }, operatorId: { in: operators } } });
        await tx.trip.deleteMany({ where: { id: { in: trips }, operatorId: { in: operators } } });
        await tx.route.deleteMany({ where: { id: { in: routes }, operatorId: { in: operators } } });
        await tx.stopPoint.deleteMany({ where: { id: { in: points }, operatorId: { in: operators } } });
        await tx.ward.deleteMany({ where: { id: { in: wards } } });
        await tx.province.deleteMany({ where: { id: { in: provinces } } });
        await tx.operatorProfile.deleteMany({ where: { id: { in: operators } } });
        await tx.user.deleteMany({ where: { id: { in: users } } });
      });
      await prisma.$disconnect();
    }
  }, 60_000);

  it("RLS tenant không đọc đơn/điểm dừng của nhà xe khác", async () => {
    expect(await prisma.withTenant(operators[1]!, (tx) => tx.booking.findMany({ where: { id: bookings[0]! } }))).toEqual([]);
    expect(await prisma.withTenant(operators[1]!, (tx) => tx.tripStop.findMany({ where: { tripId: trips[0]! } }))).toEqual([]);
    expect(await prisma.withTenant(operators[1]!, (tx) => tx.pushDevice.findMany({ where: { id: devices[0]! } }))).toEqual([]);
  });

  it("chặn thiết bị/booking khác chủ thể trên dữ liệu thật", async () => {
    await expect(service.start(actor, { bookingId: bookings[0]!, deviceId: devices[1]! })).rejects.toMatchObject({ status: 404 });
    await expect(service.start(actor, { bookingId: bookings[1]!, deviceId: devices[0]! })).rejects.toMatchObject({ status: 404 });
    await expect(service.start(other, { bookingId: bookings[0]!, deviceId: devices[1]! })).rejects.toMatchObject({ status: 404 });
    expect(queue.addBulk).not.toHaveBeenCalled();
  });

  it("chủ sở hữu demo: tỉnh đúng tenant, retry không trùng, dừng không hồi sinh, dữ liệu nghiệp vụ giữ nguyên", async () => {
    const before = await prisma.withSystem(async (tx) => ({ booking: await tx.booking.findUniqueOrThrow({ where: { id: bookings[0]! } }), trip: await tx.trip.findUniqueOrThrow({ where: { id: trips[0]! } }), tickets: await tx.ticket.count({ where: { bookingId: bookings[0]! } }) }));
    const first = await service.start(actor, { bookingId: bookings[0]!, deviceId: devices[0]! }); sessions.add(first.sessionId);
    const same = await service.start(actor, { bookingId: bookings[0]!, deviceId: devices[0]! });
    expect(same.sessionId).toBe(first.sessionId);
    expect(queue.addBulk).toHaveBeenCalledTimes(1);
    expect(first.provinceName).toBe("TP. Hồ Chí Minh");
    await expect(service.current(other, devices[0]!)).rejects.toMatchObject({ status: 404 });
    await expect(service.stop(other, first.sessionId)).rejects.toMatchObject({ status: 404 });
    await service.tick({ sessionId: first.sessionId, deviceId: devices[0]!, revision: 3 });
    await service.tick({ sessionId: first.sessionId, deviceId: devices[0]!, revision: 3 });
    expect(push.send).toHaveBeenCalledTimes(1);
    expect(push.send).toHaveBeenLastCalledWith(expect.any(String), expect.objectContaining({ provinceName: "Đồng Nai", progress: 500 }));
    const stored = JSON.parse((await redis.get(`journey-demo:session:${first.sessionId}`))!) as { provinces: string[] };
    expect(stored.provinces).toEqual(["TP. Hồ Chí Minh", "Đồng Nai", "Lâm Đồng"]);
    await service.stop(actor, first.sessionId);
    await service.tick({ sessionId: first.sessionId, deviceId: devices[0]!, revision: 5 });
    expect(push.send).toHaveBeenCalledTimes(1);
    await service.tick({ sessionId: first.sessionId, deviceId: devices[0]!, revision: 7 });
    expect(push.send).toHaveBeenLastCalledWith(expect.any(String), expect.objectContaining({ ended: true, stage: "stopped" }));
    const after = await prisma.withSystem(async (tx) => ({ booking: await tx.booking.findUniqueOrThrow({ where: { id: bookings[0]! } }), trip: await tx.trip.findUniqueOrThrow({ where: { id: trips[0]! } }), tickets: await tx.ticket.count({ where: { bookingId: bookings[0]! } }) }));
    expect(after).toEqual(before);
  });

  it("thiết bị bị thu hồi không nhận tiến độ nữa", async () => {
    const session = await service.start(other, { bookingId: bookings[1]!, deviceId: devices[1]! }); sessions.add(session.sessionId);
    await prisma.withSystem((tx) => tx.pushDevice.update({ where: { id: devices[1]! }, data: { active: false } }));
    push.send.mockClear();
    await service.tick({ sessionId: session.sessionId, deviceId: devices[1]!, revision: 2 });
    expect(push.send).not.toHaveBeenCalled();
  });
});
