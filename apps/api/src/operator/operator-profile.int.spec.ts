import { randomUUID } from "node:crypto";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditEventInput, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { platformScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { BankAccountChangeEmailMessage, EmailNotifier } from "../external/notification/email-notifier";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import type { Authorization } from "../iam/role/authorization";
import type { SessionService } from "../iam/session/session.service";
import { AdminOperatorService } from "./admin-operator.service";
import { OperatorListQuerySchema } from "./dto/admin-operator.dto";
import { BankChangeInputSchema, ProfileUpdateInputSchema } from "./dto/operator-profile.dto";
import { OperatorProfileService } from "./operator-profile.service";

/**
 * TASK-OPR-001b — hồ sơ nhà xe phía Operator OS + Admin xác minh đổi tài khoản nhận tiền, trên Postgres THẬT bằng role
 * APP (RLS tenant / platform) và kho local thật. Audit / email là bản giả để đọc lại / gây lỗi.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const PDF = Uint8Array.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37, 0x0a, 1, 2, 3]);
const NOT_PDF = Uint8Array.from([0x3c, 0x68, 0x74, 0x6d, 0x6c, 0x3e, 0x0a, 1, 2, 3]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

describe.skipIf(!url && !requireDb)("Hồ sơ & KYC nhà xe — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let profiles: OperatorProfileService;
  let admin: AdminOperatorService;
  const tag = randomUUID().slice(0, 8);
  const operatorId = randomUUID();
  const otherId = randomUUID();
  const ownerId = randomUUID();
  const slug = `opr1b-${tag}`;
  const owner = { sub: ownerId, role: "OPERATOR_OWNER" };
  const reviewer = { sub: randomUUID(), role: "PLATFORM_ADMIN" };
  const tenant: Authorization = { permission: "kyc:submit", scope: "tenant", db: tenantScope(operatorId) };
  const platform: Authorization = { permission: "kyc:review", scope: "any", db: platformScope() };
  const recordAuditEvent = vi.fn(async (_event: AuditEventInput, _options?: unknown) => undefined);
  const sendBankAccountChangeDecision = vi.fn(async (_message: BankAccountChangeEmailMessage) => undefined);
  const audit = { recordAuditEvent } as unknown as AuditService;
  const bank = (overrides: Record<string, unknown> = {}) =>
    BankChangeInputSchema.parse({
      bankName: "Techcombank",
      accountNumber: "1903 6688 0011",
      accountHolder: "Công ty TNHH Sao Việt",
      reason: "Đổi sang tài khoản công ty mới",
      ...overrides,
    });

  async function uploaded(bytes: Uint8Array = PDF): Promise<string> {
    const target = await profiles.createDocumentUpload(tenant, { contentType: "application/pdf", sizeBytes: bytes.length });
    await storage.write(target.objectKey, "application/pdf", bytes);
    return target.objectKey;
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-opr1b-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    profiles = new OperatorProfileService(prisma, storage, audit);
    admin = new AdminOperatorService(
      prisma,
      audit,
      { revokeAllForSubject: vi.fn() } as unknown as SessionService,
      { sendOtp: async () => undefined, sendBankAccountChangeDecision } as EmailNotifier,
    );
    await prisma.withSystem(async (tx) => {
      await tx.operatorProfile.createMany({
        data: [
          {
            id: operatorId,
            operatorSlug: slug,
            displayName: `Sao Việt ${tag}`,
            legalName: "Công ty TNHH Sao Việt",
            taxCode: "0312345678",
            hotline: "19006868",
            publicEmail: `lienhe@${tag}.test`,
            address: "266 Đồng Đen, TP. Hồ Chí Minh",
            approvedAt: new Date("2026-08-12T03:00:00Z"),
          },
          { id: otherId, operatorSlug: `opr1b-o-${tag}`, displayName: `Nhà xe khác ${tag}` },
        ],
      });
      await tx.operatorAccount.create({
        data: { id: ownerId, operatorId, operatorSlug: slug, username: "owner01", passwordHash: "x", contactEmail: `owner@${tag}.test` },
      });
      await tx.bankAccount.create({
        data: {
          operatorId,
          bankName: "Vietcombank",
          accountNumber: "0071000124521",
          accountHolder: "CTY TNHH SAO VIET EXPRESS",
          status: "VERIFIED",
          reviewedAt: new Date("2026-08-12T03:00:00Z"),
        },
      });
    });
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const ids = { in: [operatorId, otherId] };
      await tx.kycDocument.deleteMany({ where: { operatorId: ids } });
      await tx.bankAccount.deleteMany({ where: { operatorId: ids } });
      await tx.operatorAccount.deleteMany({ where: { operatorId: ids } });
      await tx.operatorProfile.deleteMany({ where: { id: ids } });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    recordAuditEvent.mockReset();
    recordAuditEvent.mockResolvedValue(undefined);
    sendBankAccountChangeDecision.mockReset();
    sendBankAccountChangeDecision.mockResolvedValue(undefined);
  });

  it("xem hồ sơ: thông tin công khai + pháp lý, tài khoản nhận tiền chỉ 4 số cuối, chưa có yêu cầu đổi", async () => {
    const profile = await profiles.get(tenant);
    expect(profile).toMatchObject({
      id: operatorId,
      slug,
      legalName: "Công ty TNHH Sao Việt",
      taxCode: "0312345678",
      status: "ACTIVE",
      approvedAt: "2026-08-12T03:00:00.000Z",
      documents: [],
      bankAccount: { bankName: "Vietcombank", accountNumberMasked: "•••• 4521", accountHolder: "CTY TNHH SAO VIET EXPRESS" },
      bankChange: null,
    });
    expect(JSON.stringify(profile)).not.toContain("0071000124521");
  });

  it("sửa thông tin công khai: audit chỉ trường đổi, gửi lại y nguyên không ghi audit; RLS chặn tenant đổi trạng thái / sửa nhà xe khác", async () => {
    const input = ProfileUpdateInputSchema.parse({
      displayName: `Sao Việt Express ${tag}`,
      hotline: "1900 6868",
      publicEmail: `LIENHE@${tag}.test`,
      address: "266 Đồng Đen, Phường 10, TP. Hồ Chí Minh",
      description: "Tuyến TP. Hồ Chí Minh – Đà Lạt.",
    });
    const updated = await profiles.update(tenant, owner, input);
    expect(updated).toMatchObject({ displayName: `Sao Việt Express ${tag}`, hotline: "19006868", publicEmail: `lienhe@${tag}.test` });
    expect(recordAuditEvent).toHaveBeenCalledTimes(1);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "operator.profile.update",
        operatorId,
        before: { displayName: `Sao Việt ${tag}`, address: "266 Đồng Đen, TP. Hồ Chí Minh", description: null },
        after: {
          displayName: `Sao Việt Express ${tag}`,
          address: "266 Đồng Đen, Phường 10, TP. Hồ Chí Minh",
          description: "Tuyến TP. Hồ Chí Minh – Đà Lạt.",
        },
      }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    await profiles.update(tenant, owner, input);
    expect(recordAuditEvent).toHaveBeenCalledTimes(1);

    // Trigger `operator_profiles_tenant_columns`: tenant không tự đổi trạng thái / tên pháp lý.
    await expect(
      prisma.withScope(tenantScope(operatorId), (tx) =>
        tx.operatorProfile.update({ where: { id: operatorId }, data: { legalName: "Đổi tên pháp lý" } }),
      ),
    ).rejects.toThrow();
    const other = await prisma.withScope(tenantScope(otherId), (tx) =>
      tx.operatorProfile.updateMany({ where: { id: operatorId }, data: { displayName: "Chiếm quyền" } }),
    );
    expect(other.count).toBe(0);
    expect((await profiles.get(tenant)).legalName).toBe("Công ty TNHH Sao Việt");
  });

  it("giấy tờ: tải bản mới (kiểm chữ ký file, khóa đúng nhà xe) → thay + audit, bản cũ tự tải bị xóa; xem → URL 5 phút + audit", async () => {
    const first = await uploaded();
    expect(first.startsWith(`operator-kyc/${operatorId}/`)).toBe(true);
    const afterFirst = await profiles.replaceDocument(tenant, owner, "TRANSPORT_LICENSE", { objectKey: first, fileName: "gpkd-van-tai.pdf" });
    expect(afterFirst.documents).toEqual([
      expect.objectContaining({ type: "TRANSPORT_LICENSE", fileName: "gpkd-van-tai.pdf", contentType: "application/pdf", sizeBytes: PDF.length }),
    ]);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "operator.kyc_document.replace", before: null, after: expect.objectContaining({ type: "TRANSPORT_LICENSE" }) }),
      expect.anything(),
    );

    const second = await uploaded();
    await profiles.replaceDocument(tenant, owner, "TRANSPORT_LICENSE", { objectKey: second, fileName: "gpkd-moi.pdf" });
    expect(await storage.head(first)).toBeNull();
    expect(await storage.head(second)).not.toBeNull();

    const download = await profiles.createDocumentDownload(tenant, owner, "TRANSPORT_LICENSE");
    expect(download.url).toMatch(/^http:\/\/storage\.test\//);
    expect(recordAuditEvent).toHaveBeenLastCalledWith(
      expect.objectContaining({ action: "operator.kyc_document.view", operatorId, after: expect.objectContaining({ type: "TRANSPORT_LICENSE" }) }),
      expect.anything(),
    );
    expect(await rejectionOf(profiles.createDocumentDownload(tenant, owner, "BUSINESS_REGISTRATION"))).toEqual({
      status: 404,
      code: "KYC_DOCUMENT_NOT_FOUND",
    });

    // Khóa của nhà xe khác, file không phải PDF, object chưa tải lên → 422, giấy tờ giữ nguyên.
    const foreign = `operator-kyc/${otherId}/${randomUUID()}.pdf`;
    await storage.write(foreign, "application/pdf", PDF);
    const fake = await uploaded(NOT_PDF);
    const missing = `operator-kyc/${operatorId}/${randomUUID()}.pdf`;
    for (const objectKey of [foreign, fake, missing]) {
      expect(await rejectionOf(profiles.replaceDocument(tenant, owner, "TRANSPORT_LICENSE", { objectKey, fileName: "x.pdf" }))).toEqual({
        status: 422,
        code: "KYC_DOCUMENT_INVALID",
      });
    }
    expect((await profiles.get(tenant)).documents).toEqual([expect.objectContaining({ fileName: "gpkd-moi.pdf" })]);
  });

  it("đổi tài khoản: trùng tài khoản đang dùng → 422; gửi → chờ xác minh (tài khoản cũ vẫn dùng), gửi lần nữa → 409; RLS chặn tenant tự xác minh", async () => {
    expect(
      await rejectionOf(profiles.requestBankChange(tenant, owner, bank({ bankName: "Vietcombank", accountNumber: "0071000124521" }))),
    ).toEqual({ status: 422, code: "BANK_ACCOUNT_UNCHANGED" });

    const pending = await profiles.requestBankChange(tenant, owner, bank());
    expect(pending.bankAccount).toMatchObject({ bankName: "Vietcombank", accountNumberMasked: "•••• 4521" });
    expect(pending.bankChange).toMatchObject({
      status: "PENDING",
      bankName: "Techcombank",
      accountNumberMasked: "•••• 0011",
      accountHolder: "CONG TY TNHH SAO VIET",
      reason: "Đổi sang tài khoản công ty mới",
    });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "operator.bank_account.request",
        before: { bankName: "Vietcombank", accountNumber: "•••• 4521" },
        after: expect.objectContaining({ bankName: "Techcombank", accountNumber: "•••• 0011" }),
        reason: "Đổi sang tài khoản công ty mới",
      }),
      expect.anything(),
    );
    expect(JSON.stringify(recordAuditEvent.mock.calls)).not.toContain("190366880011");
    expect(await rejectionOf(profiles.requestBankChange(tenant, owner, bank({ accountNumber: "222233334444" })))).toEqual({
      status: 409,
      code: "BANK_ACCOUNT_CHANGE_PENDING",
    });

    const tenantDb = tenantScope(operatorId);
    const verifiedByTenant = await prisma.withScope(tenantDb, (tx) =>
      tx.bankAccount.updateMany({ where: { operatorId, status: "PENDING" }, data: { status: "VERIFIED" } }),
    );
    expect(verifiedByTenant.count).toBe(0);
    await expect(
      prisma.withScope(tenantDb, (tx) =>
        tx.bankAccount.create({
          data: { operatorId, bankName: "ACB", accountNumber: "99998888", accountHolder: "X", status: "VERIFIED" },
        }),
      ),
    ).rejects.toThrow();
  });

  it("Admin: lọc nhà xe chờ xác minh; xem số đầy đủ (audit); từ chối → giữ tài khoản cũ + lý do; gửi lại rồi duyệt → tài khoản mới, cũ thôi dùng", async () => {
    const listed = await admin.list(platform, OperatorListQuerySchema.parse({ q: tag, bankChange: "PENDING" }));
    expect(listed.items).toEqual([expect.objectContaining({ id: operatorId, bankChangePending: true })]);

    const view = await admin.getBankChange(platform, reviewer, operatorId);
    expect(view).toMatchObject({
      legalName: "Công ty TNHH Sao Việt",
      current: { bankName: "Vietcombank", accountNumber: "0071000124521" },
      requested: { bankName: "Techcombank", accountNumber: "190366880011", requestedBy: `${slug}/owner01` },
    });
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "operator.bank_account.view", operatorId, after: { changeId: view.changeId } }),
      expect.anything(),
    );
    expect(await rejectionOf(admin.rejectBankChange(platform, reviewer, operatorId, randomUUID(), "Sai chủ tài khoản"))).toEqual({
      status: 404,
      code: "BANK_ACCOUNT_CHANGE_NOT_FOUND",
    });

    await admin.rejectBankChange(platform, reviewer, operatorId, view.changeId, "Chủ tài khoản không khớp tên pháp lý");
    const rejected = await profiles.get(tenant);
    expect(rejected.bankAccount).toMatchObject({ bankName: "Vietcombank" });
    expect(rejected.bankChange).toMatchObject({ status: "REJECTED", reviewNote: "Chủ tài khoản không khớp tên pháp lý" });
    expect(sendBankAccountChangeDecision).toHaveBeenCalledWith({
      email: `owner@${tag}.test`,
      operatorName: expect.any(String),
      approved: false,
      bankName: "Techcombank",
      accountNumberMasked: "•••• 0011",
      reason: "Chủ tài khoản không khớp tên pháp lý",
    });
    expect(await rejectionOf(admin.approveBankChange(platform, reviewer, operatorId, view.changeId))).toEqual({
      status: 404,
      code: "BANK_ACCOUNT_CHANGE_NOT_FOUND",
    });

    await profiles.requestBankChange(tenant, owner, bank({ accountHolder: "CTY TNHH SAO VIET EXPRESS" }));
    const again = await admin.getBankChange(platform, reviewer, operatorId);
    await admin.approveBankChange(platform, reviewer, operatorId, again.changeId);
    const approved = await profiles.get(tenant);
    expect(approved.bankAccount).toMatchObject({ bankName: "Techcombank", accountNumberMasked: "•••• 0011" });
    expect(approved.bankChange).toBeNull();
    const rows = await prisma.withSystem((tx) =>
      tx.bankAccount.findMany({ where: { operatorId }, orderBy: { createdAt: "asc" }, select: { status: true, reviewedBy: true } }),
    );
    expect(rows.map((row) => row.status)).toEqual(["REPLACED", "REJECTED", "VERIFIED"]);
    expect(rows[2]?.reviewedBy).toBe(reviewer.sub);
    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "operator.bank_account.approve", before: { bankName: "Vietcombank", accountNumber: "•••• 4521" } }),
      expect.objectContaining({ deadline: expect.any(Number) }),
    );
    expect(sendBankAccountChangeDecision).toHaveBeenLastCalledWith(expect.objectContaining({ approved: true }));
    expect((await admin.list(platform, OperatorListQuerySchema.parse({ q: tag, bankChange: "PENDING" }))).items).toEqual([]);
    expect(await rejectionOf(admin.getBankChange(platform, reviewer, operatorId))).toEqual({
      status: 404,
      code: "BANK_ACCOUNT_CHANGE_NOT_FOUND",
    });
  });

  it("audit lỗi → 503 và không đổi gì (sửa hồ sơ, gửi yêu cầu đổi tài khoản)", async () => {
    recordAuditEvent.mockRejectedValue(new AuditWriteError("mongo down"));
    const before = await profiles.get(tenant);
    expect(
      await rejectionOf(profiles.update(tenant, owner, ProfileUpdateInputSchema.parse({ ...before, displayName: "Tên khác" }))),
    ).toEqual({ status: 503, code: "SERVICE_UNAVAILABLE" });
    expect(await rejectionOf(profiles.requestBankChange(tenant, owner, bank({ accountNumber: "555566667777" })))).toEqual({
      status: 503,
      code: "SERVICE_UNAVAILABLE",
    });
    const after = await profiles.get(tenant);
    expect(after.displayName).toBe(before.displayName);
    expect(after.bankChange).toBeNull();
  });
});
