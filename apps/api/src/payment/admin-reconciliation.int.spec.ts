import { randomUUID } from "node:crypto";
import type { Queue } from "bullmq";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminReconciliationService } from "./admin-reconciliation.service";

describe.skipIf(!process.env.DATABASE_URL && process.env.REQUIRE_DB_TESTS !== "1")("Chạy lại đối soát — idempotency và audit trên Postgres thật", () => {
  const ids = [randomUUID(), randomUUID()];
  const authz: Authorization = { permission: "system:run", scope: "any", db: platformScope() };
  const actor = { sub: randomUUID(), sid: randomUUID(), scope: "platform", role: "PLATFORM_ADMIN" } as VerifiedAccessToken;
  let prisma: PrismaService;
  beforeAll(() => { prisma = new PrismaService(parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL })); });
  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem((tx) => tx.reconciliationRecord.deleteMany({ where: { id: { in: ids } } }));
    await prisma.$disconnect();
  });
  it("hai yêu cầu đồng thời cùng khóa chỉ tạo một record/audit và dùng cùng jobId", async () => {
    const recordAuditEvent = vi.fn().mockResolvedValue(undefined);
    const add = vi.fn(async (_name: string, _data: unknown, _options: { jobId: string }) => undefined);
    const service = new AdminReconciliationService(prisma, { recordAuditEvent } as unknown as AuditService, { add } as unknown as Pick<Queue, "add">);
    const input = { requestId: ids[0]!, reason: "Chạy lại đối soát sau bảo trì" };
    const results = await Promise.all([service.run(authz, actor, input), service.run(authz, actor, input)]);
    expect(results.map((row) => row.runId)).toEqual([input.requestId, input.requestId]);
    expect(recordAuditEvent).toHaveBeenCalledOnce();
    expect(new Set(add.mock.calls.map((call) => call[2].jobId)).size).toBe(1);
    expect(await prisma.withSystem((tx) => tx.reconciliationRecord.count({ where: { id: input.requestId } }))).toBe(1);
    await expect(service.run(authz, actor, { ...input, reason: "Lý do khác cho cùng khóa" })).rejects.toThrow();
  });
  it("không ghi audit được thì không tạo record và không xếp hàng", async () => {
    const add = vi.fn();
    const service = new AdminReconciliationService(prisma, { recordAuditEvent: vi.fn().mockRejectedValue(new AuditWriteError(new Error("offline"))) } as unknown as AuditService, { add } as unknown as Pick<Queue, "add">);
    await expect(service.run(authz, actor, { requestId: ids[1]!, reason: "Kiểm tra audit trước khi chạy" })).rejects.toMatchObject({ status: 503 });
    expect(add).not.toHaveBeenCalled();
    expect(await prisma.withSystem((tx) => tx.reconciliationRecord.count({ where: { id: ids[1] } }))).toBe(0);
  });
});
