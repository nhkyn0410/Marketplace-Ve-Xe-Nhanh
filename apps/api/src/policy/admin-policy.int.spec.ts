import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { AdminPolicyService } from "./admin-policy.service";
import { FareBandInputSchema, PolicyDraftCreateSchema, PolicyDraftInputSchema } from "./dto/policy.dto";

/**
 * Chính sách nền tảng có phiên bản + khung giá (FR-ADM-06/08/09, UC-25, AS-23) trên Postgres THẬT bằng role APP. Phiên bản
 * hủy / hoàn tiền thử ở phạm vi RIÊNG của một nhà xe tạo trong test (không đụng chính sách mặc định đang dùng chung).
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";
const DAY = 24 * 3_600_000;

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Chính sách nền tảng — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let policies: AdminPolicyService;
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const adminId = randomUUID();
  const actor = { sub: adminId, role: "PLATFORM_ADMIN" };
  const authz: Authorization = { permission: "finance:configure", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const bandIds: string[] = [];
  const tiers = [
    { minHoursBefore: 4, refundPercent: 50 },
    { minHoursBefore: 24, refundPercent: 90 },
    { minHoursBefore: 0, refundPercent: 0 },
  ];
  const draft = (overrides: Record<string, unknown> = {}) =>
    PolicyDraftCreateSchema.parse({ operatorId, rules: { tiers }, description: null, effectiveFrom: null, ...overrides });
  const future = (days: number) => new Date(Date.now() + days * DAY).toISOString();

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    policies = new AdminPolicyService(prisma, { recordAuditEvent } as unknown as AuditService);
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `pol-${tag}`, displayName: `Nhà xe chính sách ${tag}` } });
      await tx.platformAccount.create({ data: { id: adminId, username: `pol-${tag}`, passwordHash: "x", role: "PLATFORM_ADMIN" } });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      await tx.policyVersion.deleteMany({ where: { operatorId } });
      await tx.policyVersion.deleteMany({ where: { createdBy: adminId } });
      await tx.fareBand.deleteMany({ where: { id: { in: bandIds } } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
      await tx.platformAccount.deleteMany({ where: { id: adminId } });
    });
    await prisma.$disconnect();
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
  });

  it("dữ liệu nền: giữ chỗ 10 phút, chi trả T+3 chuyển khoản + xác nhận thủ công đang áp dụng; giữ chỗ không có phạm vi nhà xe", async () => {
    const seatHold = await policies.overview(authz, "SEAT_HOLD", undefined);
    expect(seatHold.versions.find((version) => version.state === "ACTIVE")?.rules).toEqual({ holdMinutes: 10 });
    const payout = await policies.overview(authz, "PAYOUT", undefined);
    expect(payout.versions.find((version) => version.state === "ACTIVE")?.rules).toEqual({
      delayDays: 3,
      channel: "BANK_TRANSFER",
      manualConfirmation: true,
      minimumAmount: null,
    });
    expect(await rejectionOf(policies.overview(authz, "SEAT_HOLD", operatorId))).toEqual({ status: 400, code: "POLICY_RULES_INVALID" });
    expect(await rejectionOf(policies.createDraft(authz, actor, "SEAT_HOLD", draft({ rules: { holdMinutes: 15 } })))).toEqual({
      status: 400,
      code: "POLICY_RULES_INVALID",
    });
    // v1 không có ngưỡng tối thiểu chi trả (BR-32): bị chặn ngay ở DTO.
    const payoutRules = { delayDays: 3, channel: "BANK_TRANSFER", manualConfirmation: true, minimumAmount: 500_000 };
    expect(() => draft({ operatorId: null, rules: payoutRules })).toThrow(/ngưỡng tối thiểu/);
    expect(draft({ operatorId: null, rules: { ...payoutRules, minimumAmount: null } }).rules).toMatchObject({ minimumAmount: null });
  });

  it("nháp hủy / hoàn tiền: mốc sắp giảm dần; thiếu mốc 0 giờ / sát giờ hoàn cao hơn → 400; sai loại nội dung → 400; sửa nháp + audit", async () => {
    const created = await policies.createDraft(authz, actor, "CANCELLATION", draft());
    expect(created).toMatchObject({ version: 1, status: "DRAFT", state: "DRAFT", operatorName: `Nhà xe chính sách ${tag}`, createdBy: `platform/pol-${tag}` });
    expect(created.rules).toEqual({ tiers: [tiers[1], tiers[0], tiers[2]] });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "policy.create", targetType: "policy_version", operatorId }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    for (const rules of [
      { tiers: [{ minHoursBefore: 24, refundPercent: 90 }] },
      { tiers: [{ minHoursBefore: 24, refundPercent: 50 }, { minHoursBefore: 0, refundPercent: 80 }] },
      { holdMinutes: 10 },
    ]) {
      expect(await rejectionOf(policies.createDraft(authz, actor, "CANCELLATION", draft({ rules })))).toEqual({
        status: 400,
        code: "POLICY_RULES_INVALID",
      });
    }
    const updated = await policies.updateDraft(
      authz,
      actor,
      created.id,
      PolicyDraftInputSchema.parse({ rules: { tiers: [{ minHoursBefore: 0, refundPercent: 10 }] }, description: "Thử", effectiveFrom: future(2) }),
    );
    expect(updated).toMatchObject({ description: "Thử", rules: { tiers: [{ minHoursBefore: 0, refundPercent: 10 }] } });
    expect(recordAuditEvent).toHaveBeenLastCalledWith(expect.objectContaining({ action: "policy.update" }), expect.anything());
  });

  it("kích hoạt: hiệu lực ở quá khứ → 422; tương lai → Đã lên lịch + lý do + audit; bản lên lịch thứ hai cùng phạm vi → 409; hủy lịch rồi kích hoạt được", async () => {
    const first = await policies.createDraft(authz, actor, "CANCELLATION", draft({ effectiveFrom: new Date(Date.now() - 60_000).toISOString() }));
    expect(await rejectionOf(policies.publish(authz, actor, first.id, "Áp dụng dịp lễ"))).toEqual({ status: 422, code: "POLICY_EFFECTIVE_INVALID" });
    await policies.updateDraft(authz, actor, first.id, PolicyDraftInputSchema.parse({ rules: { tiers }, description: null, effectiveFrom: future(10) }));
    const scheduled = await policies.publish(authz, actor, first.id, "Áp dụng dịp lễ");
    expect(scheduled).toMatchObject({ status: "PUBLISHED", state: "SCHEDULED", changeReason: "Áp dụng dịp lễ" });
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "policy.publish", reason: "Áp dụng dịp lễ", after: expect.objectContaining({ status: "PUBLISHED" }) }),
      expect.anything(),
    );
    // Đã kích hoạt: không sửa được.
    expect(
      await rejectionOf(policies.updateDraft(authz, actor, first.id, PolicyDraftInputSchema.parse({ rules: { tiers }, description: null, effectiveFrom: future(11) }))),
    ).toEqual({ status: 409, code: "POLICY_VERSION_LOCKED" });

    const second = await policies.createDraft(authz, actor, "CANCELLATION", draft({ effectiveFrom: future(20) }));
    expect(await rejectionOf(policies.publish(authz, actor, second.id, "Bản khác"))).toEqual({ status: 409, code: "POLICY_SCHEDULE_CONFLICT" });

    const cancelled = await policies.cancel(authz, actor, first.id, "Đổi kế hoạch");
    expect(cancelled.state).toBe("CANCELLED");
    expect((await policies.publish(authz, actor, second.id, "Bản khác")).state).toBe("SCHEDULED");

    const overview = await policies.overview(authz, "CANCELLATION", undefined);
    expect(overview.overrides).toContainEqual({ operatorId, operatorName: `Nhà xe chính sách ${tag}`, operatorSlug: `pol-${tag}`, state: "SCHEDULED" });
    const scope = await policies.overview(authz, "CANCELLATION", operatorId);
    expect(scope.versions.map((version) => version.version)).toEqual([...scope.versions.map((version) => version.version)].sort((a, b) => b - a));
  });

  it("bản đã có hiệu lực: Đang áp dụng, bản trước Hết hiệu lực; không hủy được (409)", async () => {
    // Bản đã có hiệu lực chỉ tạo được bằng đường ghi thẳng (API không cho kích hoạt ở quá khứ).
    const [older, current] = await prisma.withSystem(async (tx) => {
      const base = { type: "CANCELLATION" as const, operatorId, status: "PUBLISHED" as const, rules: { tiers: [{ minHoursBefore: 0, refundPercent: 0 }] }, changeReason: "test", publishedAt: new Date() };
      return [
        await tx.policyVersion.create({ data: { ...base, version: 90, effectiveFrom: new Date(Date.now() - 20 * DAY) } }),
        await tx.policyVersion.create({ data: { ...base, version: 91, effectiveFrom: new Date(Date.now() - 2 * DAY) } }),
      ];
    });
    const scope = await policies.overview(authz, "CANCELLATION", operatorId);
    expect(scope.versions.find((version) => version.id === current.id)?.state).toBe("ACTIVE");
    expect(scope.versions.find((version) => version.id === older.id)?.state).toBe("EXPIRED");
    expect((await policies.get(authz, current.id)).state).toBe("ACTIVE");
    expect(await rejectionOf(policies.cancel(authz, actor, current.id, "Không được"))).toEqual({ status: 409, code: "POLICY_VERSION_LOCKED" });
    expect(await rejectionOf(policies.get(authz, randomUUID()))).toEqual({ status: 404, code: "POLICY_VERSION_NOT_FOUND" });
  });

  it("RLS: ai cũng đọc chính sách / khung giá; ngữ cảnh tenant không ghi được", async () => {
    const tenant = tenantScope(operatorId);
    expect(await prisma.withScope(tenant, (tx) => tx.policyVersion.count({ where: { type: "SEAT_HOLD" } }))).toBeGreaterThan(0);
    await expect(
      prisma.withScope(tenant, (tx) =>
        tx.policyVersion.create({ data: { type: "CANCELLATION", operatorId, version: 99, rules: { tiers: [] } } }),
      ),
    ).rejects.toThrow();
    const changed = await prisma.withScope(tenant, (tx) =>
      tx.policyVersion.updateMany({ where: { type: "SEAT_HOLD" }, data: { description: "Chiếm quyền" } }),
    );
    expect(changed.count).toBe(0);
  });

  it("khung giá: kết thúc ở quá khứ → 422; tạo → Đã lên lịch + audit; hủy (lý do) → Đã hủy; hủy lần nữa → 409", async () => {
    const input = (overrides: Record<string, unknown> = {}) =>
      FareBandInputSchema.parse({
        name: `Tết ${tag}`,
        minPrice: null,
        maxPrice: 99_000_000,
        effectiveFrom: future(300),
        effectiveTo: future(310),
        message: "Giá vượt trần dịp Tết.",
        reason: "Theo văn bản Sở GTVT",
        ...overrides,
      });
    expect(
      await rejectionOf(policies.createFareBand(authz, actor, input({ effectiveFrom: future(-10), effectiveTo: future(-5) }))),
    ).toEqual({ status: 422, code: "POLICY_EFFECTIVE_INVALID" });
    const band = await policies.createFareBand(authz, actor, input());
    bandIds.push(band.id);
    expect(band).toMatchObject({ state: "SCHEDULED", maxPrice: 99_000_000, minPrice: null, createdBy: `platform/pol-${tag}` });
    expect(recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "fare_band.create", targetId: band.id }), expect.anything());
    expect((await policies.listFareBands(authz)).items.map((item) => item.id)).toContain(band.id);
    const cancelled = await policies.cancelFareBand(authz, actor, band.id, "Văn bản bị thu hồi");
    expect(cancelled).toMatchObject({ state: "CANCELLED", cancelReason: "Văn bản bị thu hồi" });
    expect(await rejectionOf(policies.cancelFareBand(authz, actor, band.id, "Lần nữa"))).toEqual({ status: 409, code: "FARE_BAND_CLOSED" });
    expect(await rejectionOf(policies.cancelFareBand(authz, actor, randomUUID(), "Lạ"))).toEqual({ status: 404, code: "FARE_BAND_NOT_FOUND" });
  });

  it("audit lỗi → 503, không tạo nháp / không kích hoạt", async () => {
    const pending = await policies.createDraft(authz, actor, "CANCELLATION", draft({ effectiveFrom: future(40) }));
    recordAuditEvent.mockRejectedValue(new AuditWriteError("mongo down"));
    const before = (await policies.overview(authz, "CANCELLATION", operatorId)).versions.length;
    expect(await rejectionOf(policies.createDraft(authz, actor, "CANCELLATION", draft()))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect(await rejectionOf(policies.cancel(authz, actor, pending.id, "Thử lỗi"))).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    recordAuditEvent.mockResolvedValue(undefined);
    expect((await policies.overview(authz, "CANCELLATION", operatorId)).versions.length).toBe(before);
    expect((await policies.get(authz, pending.id)).state).toBe("DRAFT");
  });
});
