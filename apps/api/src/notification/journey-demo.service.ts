import { randomUUID } from "node:crypto";
import { Inject, Injectable, NotFoundException, ServiceUnavailableException } from "@nestjs/common";
import { InjectQueue } from "@nestjs/bullmq";
import type { Queue } from "bullmq";
import type Redis from "ioredis";
import type { JourneyDemoSnapshot, JourneyDemoStart } from "@vexenhanh/types";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import { withPassengerData } from "../database/passenger-scope";
import { withNotificationSubject } from "../database/preference-scope";
import { JOURNEY_DEMO_PUSH, type JourneyDemoPush } from "../external/notification/push/journey-demo-push";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { permissionDenied } from "../iam/role/authorization.errors";
import { REDIS_CLIENT } from "../redis/redis.config";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { journeyDemoSnapshot, JOURNEY_DEMO_JOB, JOURNEY_DEMO_STEP_MS, JOURNEY_DEMO_TTL_SECONDS, type JourneyDemoJob, type JourneyDemoSession } from "./journey-demo-snapshot";

const sessionKey = (id: string) => `journey-demo:session:${id}`;
const deviceKey = (id: string) => `journey-demo:device:${id}`;
const missing = () => new NotFoundException({ code: "JOURNEY_DEMO_NOT_FOUND", detail: "Không tìm thấy bản mô phỏng hành trình." });

/** Phiên demo giới hạn sandbox; đọc dữ liệu sở hữu, tuyệt đối không đổi trạng thái chuyến/vé. */
@Injectable()
export class JourneyDemoService {
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(REDIS_CLIENT) private readonly redis: Redis,
    @InjectQueue(QUEUE_NAMES.notifications) private readonly queue: Queue,
    @Inject(JOURNEY_DEMO_PUSH) private readonly push: JourneyDemoPush,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  private enabled(): void {
    if (this.config.NODE_ENV === "production" || this.config.JOURNEY_DEMO_ENABLED !== "true") throw missing();
  }

  private passenger(actor: VerifiedAccessToken): string {
    this.enabled();
    if (actor.scope !== "passenger" || actor.role !== "PASSENGER") throw permissionDenied();
    return actor.sub;
  }

  private async device(userId: string, deviceId: string) {
    const device = await withNotificationSubject(this.prisma, (tx) => tx.pushDevice.findFirst({ where: { id: deviceId, subjectType: "PASSENGER", subjectId: userId, operatorId: null, provider: "FCM", active: true }, select: { token: true } }));
    if (!device) throw missing();
    return device;
  }

  private async session(id: string): Promise<JourneyDemoSession | null> {
    const value = await this.redis.get(sessionKey(id));
    return value ? JSON.parse(value) as JourneyDemoSession : null;
  }

  private async save(session: JourneyDemoSession): Promise<void> {
    await this.redis.set(sessionKey(session.snapshot.sessionId), JSON.stringify(session), "EX", JOURNEY_DEMO_TTL_SECONDS);
  }

  /** Cùng thiết bị phải tuần tự giữa start/stop/worker; khóa có hạn để không giữ kẹt khi process chết. */
  private async locked<T>(deviceId: string, work: () => Promise<T>): Promise<T> {
    const key = `journey-demo:lock:${deviceId}`;
    const token = randomUUID();
    if (!(await this.redis.set(key, token, "EX", 30, "NX"))) throw new ServiceUnavailableException({ code: "JOURNEY_DEMO_BUSY", detail: "Bản mô phỏng đang cập nhật, vui lòng thử lại." });
    try { return await work(); }
    finally { await this.redis.eval("if redis.call('get', KEYS[1]) == ARGV[1] then return redis.call('del', KEYS[1]) end return 0", 1, key, token); }
  }

  async start(actor: VerifiedAccessToken, input: JourneyDemoStart): Promise<JourneyDemoSnapshot> {
    const userId = this.passenger(actor);
    await this.device(userId, input.deviceId);
    const booking = await withPassengerData(this.prisma, userId, async (tx, ownerId) => {
      const row = await tx.booking.findFirst({ where: { id: input.bookingId, userId: ownerId, status: "CONFIRMED" }, select: { operatorId: true, tripId: true, pickupSequence: true, dropoffSequence: true, trip: { select: { route: { select: { name: true } } } } } });
      if (!row) throw missing();
      const stops = await tx.tripStop.findMany({ where: { tripId: row.tripId, operatorId: row.operatorId, sequence: { gte: row.pickupSequence, lte: row.dropoffSequence } }, orderBy: { sequence: "asc" }, select: { catalogStopPoint: { select: { ward: { select: { province: { select: { name: true } } } } } }, stopPoint: { select: { ward: { select: { province: { select: { name: true } } } } } } } });
      const provinces = stops.map((stop) => stop.catalogStopPoint?.ward.province.name ?? stop.stopPoint?.ward.province.name)
        .filter((name): name is string => !!name)
        .filter((name, index, names) => index === 0 || name !== names[index - 1]);
      return { ...row, provinces: provinces.length ? provinces : ["Mô phỏng"] };
    });
    return this.locked(input.deviceId, async () => {
      const currentId = await this.redis.get(deviceKey(input.deviceId));
      const current = currentId ? await this.session(currentId) : null;
      if (current && current.userId === userId && current.snapshot.bookingId === input.bookingId && !current.snapshot.ended && Date.parse(current.snapshot.expiresAt) > Date.now()) return current.snapshot;
      if (current) { current.snapshot = { ...journeyDemoSnapshot(current, 7), updatedAt: new Date().toISOString() }; await this.save(current); }
      const now = Date.now();
      const snapshot: JourneyDemoSnapshot = { type: "journey_demo", schemaVersion: 1, sessionId: randomUUID(), bookingId: input.bookingId, revision: 0, stage: "approaching", routeLabel: booking.trip.route.name, provinceName: booking.provinces[0]!, etaAt: new Date(now + 180_000).toISOString(), progress: 0, updatedAt: new Date(now).toISOString(), expiresAt: new Date(now + 240_000).toISOString(), ended: false };
      const session: JourneyDemoSession = { userId, deviceId: input.deviceId, operatorId: booking.operatorId, startedAt: now, provinces: booking.provinces, snapshot };
      await this.save(session);
      await this.redis.set(deviceKey(input.deviceId), snapshot.sessionId, "EX", JOURNEY_DEMO_TTL_SECONDS);
      try {
        await this.queue.addBulk(Array.from({ length: 7 }, (_, index) => ({ name: JOURNEY_DEMO_JOB, data: { sessionId: snapshot.sessionId, deviceId: input.deviceId, revision: index + 1 }, opts: { jobId: `journey-demo-${snapshot.sessionId}-${index + 1}`, delay: JOURNEY_DEMO_STEP_MS * (index + 1), attempts: 3, backoff: { type: "exponential", delay: 2000 }, removeOnComplete: { age: 600 }, removeOnFail: { age: 3600 } } })));
      } catch (error) { session.snapshot = journeyDemoSnapshot(session, 7); await this.save(session); throw error; }
      return snapshot;
    });
  }

  async current(actor: VerifiedAccessToken, deviceId: string): Promise<JourneyDemoSnapshot | null> {
    const userId = this.passenger(actor);
    await this.device(userId, deviceId);
    const id = await this.redis.get(deviceKey(deviceId));
    const session = id ? await this.session(id) : null;
    return session && session.userId === userId && Date.parse(session.snapshot.expiresAt) > Date.now() ? session.snapshot : null;
  }

  async stop(actor: VerifiedAccessToken, sessionId: string): Promise<void> {
    const userId = this.passenger(actor);
    const existing = await this.session(sessionId);
    if (!existing || existing.userId !== userId) throw missing();
    await this.locked(existing.deviceId, async () => {
      const session = await this.session(sessionId);
      if (!session) return;
      if (!session.snapshot.ended) {
        session.snapshot = { ...journeyDemoSnapshot(session, 7), updatedAt: new Date().toISOString() };
        await this.save(session);
      }
      await this.queue.add(JOURNEY_DEMO_JOB, { sessionId, deviceId: session.deviceId, revision: 7 }, { jobId: `journey-demo-${sessionId}-stop`, attempts: 3, backoff: { type: "exponential", delay: 2000 }, removeOnComplete: { age: 600 }, removeOnFail: { age: 3600 } });
    });
  }

  /** Gọi từ worker, kể cả khi Flutter không chạy. Thiết bị bị gỡ/chuyển tài khoản thì không gửi tiếp. */
  async tick(job: JourneyDemoJob): Promise<void> {
    this.enabled();
    await this.locked(job.deviceId, async () => {
      const currentId = await this.redis.get(deviceKey(job.deviceId));
      const session = await this.session(job.sessionId);
      if (!session || currentId !== job.sessionId || session.deviceId !== job.deviceId || (session.snapshot.ended && job.revision !== 7) || job.revision < session.snapshot.revision || (session.deliveredRevision ?? -1) >= job.revision || Date.parse(session.snapshot.expiresAt) <= Date.now()) return;
      const device = await this.device(session.userId, session.deviceId).catch(() => null);
      if (!device) { session.snapshot = journeyDemoSnapshot(session, 7); await this.save(session); return; }
      if (!session.snapshot.ended) session.snapshot = journeyDemoSnapshot(session, job.revision);
      await this.save(session);
      const outcome = await this.push.send(device.token, session.snapshot);
      if (outcome === "UNAVAILABLE") throw new ServiceUnavailableException("Journey demo push unavailable.");
      if (outcome === "SENT") { session.deliveredRevision = job.revision; await this.save(session); }
      if (outcome === "UNREGISTERED") { session.snapshot = journeyDemoSnapshot(session, 7); await this.save(session); }
    });
  }
}
