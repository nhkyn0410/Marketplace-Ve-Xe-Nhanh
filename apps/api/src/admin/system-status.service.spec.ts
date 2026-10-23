import type { Queue } from "bullmq";
import { describe, expect, it, vi } from "vitest";
import type { AppConfig } from "../config/env.config";
import type { DatabaseHealthService } from "../database/database-health.service";
import type { MongoHealthService } from "../database/mongo-health.service";
import type { StorageProvider } from "../external/storage/storage-provider";
import type { RedisHealthService } from "../redis/redis-health.service";
import { SystemStatusService } from "./system-status.service";

/** Trang Tích hợp & hệ thống chỉ đọc (Figma ADM-16a / 16b) — phụ thuộc giả để gây lỗi / dựng dữ liệu BullMQ. */
type JobLike = { name: string; finishedOn?: number; processedOn?: number; timestamp: number; returnvalue?: unknown; failedReason?: string; attemptsMade: number };

function queue(name: string, jobs: { active?: JobLike[]; completed?: JobLike[]; failed?: JobLike[] } = {}, schedulers: object[] = []): Queue {
  return {
    name,
    getJobCounts: vi.fn(async () => ({ waiting: 1, active: (jobs.active ?? []).length, delayed: 0, failed: (jobs.failed ?? []).length })),
    getJobSchedulers: vi.fn(async () => schedulers),
    getJobs: vi.fn(async ([state]: string[]) => (jobs as Record<string, JobLike[] | undefined>)[state] ?? []),
  } as unknown as Queue;
}

function service(overrides: { config?: Partial<AppConfig>; postgres?: () => Promise<unknown>; privateStorage?: StorageProvider | null; queues?: Queue[] } = {}) {
  const ok = async () => ({ status: "ok" });
  const storage = { head: vi.fn(async () => null) } as unknown as StorageProvider;
  const [sessions, files, kyc, foundation, bookings] = overrides.queues ?? [queue("session-maintenance"), queue("storage-maintenance"), queue("kyc-maintenance"), queue("foundation"), queue("booking-maintenance")];
  return new SystemStatusService(
    { NODE_ENV: "development", ...overrides.config } as AppConfig,
    { check: overrides.postgres ?? ok } as unknown as DatabaseHealthService,
    { check: ok } as unknown as MongoHealthService,
    { check: ok } as unknown as RedisHealthService,
    storage,
    overrides.privateStorage === undefined ? storage : overrides.privateStorage,
    foundation!,
    sessions!,
    files!,
    kyc!,
    bookings ?? queue("booking-maintenance"),
    queue("payment-callbacks"),
    queue("refund-processing"),
    queue("payout-maintenance"),
    queue("notifications"),
    queue("payment-reconciliation"),
    queue("dispute-maintenance"),
    queue("loyalty-maintenance"),
  );
}

describe("Tích hợp & hệ thống — chỉ đọc", () => {
  it("kiểm tra thật: Postgres lỗi → DOWN, phần còn lại UP / LOCAL; dịch vụ chưa xây → NOT_INTEGRATED; SMS tắt", async () => {
    const result = await service({ postgres: async () => Promise.reject(new Error("down")) }).integrations();
    const byKey = Object.fromEntries(result.items.map((item) => [item.key, item]));
    expect(byKey.postgres).toMatchObject({ status: "DOWN" });
    expect(byKey.redis).toMatchObject({ status: "UP" });
    expect(byKey.mongo).toMatchObject({ status: "UP" });
    expect(byKey.queues).toMatchObject({ status: "UP" });
    expect(byKey["storage-public"]).toMatchObject({ status: "LOCAL", name: "Kho công khai (ổ đĩa)" });
    expect(byKey.vnpay?.status).toBe("LOCAL");
    expect(byKey.push?.status).toBe("NOT_CONFIGURED");
    expect(byKey.sms?.status).toBe("DISABLED");
    expect(byKey.email).toMatchObject({ status: "LOCAL" });
  });

  it("cấu hình: có khóa → CONFIGURED (không gọi thử, không trả khóa); production thiếu khóa / thiếu kho riêng tư → NOT_CONFIGURED", async () => {
    const configured = await service({ config: { RESEND_API_KEY: "re_secret_value", GOONG_API_KEY: "goong-secret" } }).integrations();
    expect(configured.items.find((item) => item.key === "email")?.status).toBe("CONFIGURED");
    expect(JSON.stringify(configured)).not.toMatch(/re_secret_value|goong-secret/);
    const production = await service({ config: { NODE_ENV: "production" }, privateStorage: null }).integrations();
    expect(production.items.find((item) => item.key === "goong")?.status).toBe("NOT_CONFIGURED");
    expect(production.items.find((item) => item.key === "storage-private")).toMatchObject({ status: "NOT_CONFIGURED", detail: expect.stringMatching(/OQ-21/) });
  });

  it("tác vụ nền: nhãn tiếng Việt, lịch + lần chạy kế, lần chạy gần nhất (số bản ghi / lỗi), số lần lỗi; hàng đợi đọc lỗi → không khả dụng", async () => {
    const day = Date.UTC(2026, 9, 16, 20, 0);
    const sessions = queue(
      "session-maintenance",
      {
        completed: [{ name: "session-cleanup", finishedOn: day, timestamp: day - 1_000, returnvalue: { deleted: 42 }, attemptsMade: 1 }],
        failed: [{ name: "session-cleanup", finishedOn: day - 86_400_000, timestamp: day - 86_400_000, failedReason: "connection reset", attemptsMade: 3 }],
      },
      [{ name: "session-cleanup", pattern: "0 3 * * *", next: day + 86_400_000 }],
    );
    const kyc = queue("kyc-maintenance", { failed: [{ name: "application-document-cleanup", finishedOn: day, timestamp: day, failedReason: "x".repeat(300), attemptsMade: 3 }] });
    const result = await service({ queues: [sessions, queue("storage-maintenance"), kyc, queue("foundation")] }).backgroundJobs();
    expect(result.available).toBe(true);
    expect(result.jobs.find((job) => job.name === "session-cleanup")).toEqual({
      queue: "session-maintenance",
      name: "session-cleanup",
      label: "Dọn phiên đăng nhập hết hạn",
      schedule: "0 3 * * *",
      nextRunAt: new Date(day + 86_400_000).toISOString(),
      lastRun: { state: "completed", at: new Date(day).toISOString(), processed: 42, error: null, attempts: 1 },
      failedCount: 1,
    });
    const failed = result.jobs.find((job) => job.name === "application-document-cleanup")!;
    expect(failed.lastRun).toMatchObject({ state: "failed", processed: null });
    expect(failed.lastRun!.error).toHaveLength(200);
    expect(result.queues.find((item) => item.name === "kyc-maintenance")).toMatchObject({ failed: 1 });

    const broken = queue("session-maintenance");
    (broken.getJobCounts as ReturnType<typeof vi.fn>).mockRejectedValue(new Error("redis down"));
    const unavailable = await service({ queues: [broken, queue("storage-maintenance"), queue("kyc-maintenance"), queue("foundation")] }).backgroundJobs();
    expect(unavailable).toMatchObject({ available: false, jobs: [], queues: [] });
  });
});
