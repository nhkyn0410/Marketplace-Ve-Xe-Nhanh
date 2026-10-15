import { randomUUID } from "node:crypto";
import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExecutionContext } from "@nestjs/common";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import type { AuditEventInput, AuditHistoryItem, AuditService } from "../audit/audit.service";
import { AuditWriteError } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import type {
  EmailNotifier,
  OperatorApplicationDecisionEmailMessage,
  OperatorApplicationLinkEmailMessage,
  TemporaryPasswordEmailMessage,
} from "../external/notification/email-notifier";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import { CredentialService } from "../iam/auth/credential.service";
import { type Applicant, ApplicationPublicGuard, ApplicationTokenGuard } from "../iam/role/application-access";
import type { Authorization } from "../iam/role/authorization";
import type { SessionService } from "../iam/session/session.service";
import { AccountProvisioningService } from "../iam/user/account-provisioning.service";
import type { AccountActor } from "../iam/user/account.types";
import type { TemporaryCredentialEmailLimiter } from "../iam/user/temporary-credential-email-limiter";
import { AdminApplicationListQuerySchema } from "./dto/operator-application-review.dto";
import { ApplicationCreateInputSchema, ApplicationUpdateInputSchema } from "./dto/operator-application.dto";
import type { OperatorApplicationRateLimiter } from "./operator-application-rate-limiter";
import { OperatorApplicationReviewService } from "./operator-application-review.service";
import { OperatorApplicationService } from "./operator-application.service";

/**
 * TASK-ADM-001 phần duyệt hồ sơ đăng ký nhà xe trên Postgres THẬT bằng role APP (TC-OPR-002): người nộp đi hết
 * luồng thật tới `SUBMITTED`, Admin duyệt / yêu cầu bổ sung / từ chối qua service thật + `provisionOperatorOwner`
 * thật. Email, audit, re-auth và hạn mức email là bản giả để đọc lại / gây lỗi.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const PDF = Uint8Array.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37, 0x0a, 1, 2, 3]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string }> {
  try {
    await promise;
    return {};
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string } }).getResponse?.();
    return { status: (error as { getStatus?: () => number }).getStatus?.(), code: response?.code };
  }
}

function contextOf(request: object): ExecutionContext {
  return { switchToHttp: () => ({ getRequest: () => request }) } as unknown as ExecutionContext;
}

describe.skipIf(!url && !requireDb)("Admin duyệt hồ sơ đăng ký nhà xe — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let applications: OperatorApplicationService;
  let reviews: OperatorApplicationReviewService;
  let guard: ApplicationTokenGuard;
  const tag = randomUUID().slice(0, 8);
  const links: OperatorApplicationLinkEmailMessage[] = [];
  const decisions: OperatorApplicationDecisionEmailMessage[] = [];
  const passwords: TemporaryPasswordEmailMessage[] = [];
  const sendTemporaryPassword = vi.fn(async (message: TemporaryPasswordEmailMessage) => {
    passwords.push(message);
  });
  const sendOperatorApplicationDecision = vi.fn(async (message: OperatorApplicationDecisionEmailMessage) => {
    decisions.push(message);
  });
  const notifier: EmailNotifier = {
    sendOtp: async () => undefined,
    sendOperatorApplicationLink: async (message) => {
      links.push(message);
    },
    sendTemporaryPassword,
    sendOperatorApplicationDecision,
  };
  const events: (AuditEventInput & { createdAt: Date })[] = [];
  const recordAuditEvent = vi.fn(async (input: AuditEventInput) => {
    events.push({ ...input, createdAt: new Date() });
  });
  const audit = {
    recordAuditEvent,
    listAuditEvents: vi.fn(async (query: { targetType: string; targetId: string; actions: readonly string[] }) =>
      events
        .filter((event) => event.targetType === query.targetType && event.targetId === query.targetId)
        .filter((event) => query.actions.includes(event.action))
        .reverse()
        .map((event): AuditHistoryItem => ({ ...event, before: event.before ?? null, after: event.after ?? null })),
    ),
  };
  const sessions = { hasRecentReauth: vi.fn(async () => true) };
  const emailLimiter = { reserve: vi.fn(async () => undefined) };
  const limiter = { assertPublicRequest: vi.fn(async () => undefined), assertDocumentUpload: vi.fn(async () => undefined) };
  const config = parseAppConfig({ DATABASE_URL: url });
  const admin: AccountActor = { sub: randomUUID(), sid: randomUUID(), scope: "platform", role: "PLATFORM_ADMIN" };
  const platformAuthz = { db: { kind: "platform" } } as Authorization;
  const context = { ip: "203.0.113.9", userAgent: "vitest" };
  let slugCounter = 0;
  const newSlug = () => `adm-${tag}-${(slugCounter += 1)}`;

  const publicAuthz = (): Authorization => {
    const request: { authz?: Authorization } = {};
    new ApplicationPublicGuard().canActivate(contextOf(request));
    return request.authz!;
  };

  async function open(token: string): Promise<{ authz: Authorization; applicant: Applicant }> {
    const request: { headers: Record<string, string>; authz?: Authorization; applicant?: Applicant } = {
      headers: { "x-application-token": token },
    };
    await guard.canActivate(contextOf(request));
    return { authz: request.authz!, applicant: request.applicant! };
  }

  const tokenOf = (link: string) => new URL(link).hash.replace("#token=", "");

  async function upload(session: { authz: Authorization; applicant: Applicant }, type: string) {
    const granted = await applications.createDocumentUpload(session.authz, session.applicant, {
      type: type as never,
      contentType: "application/pdf",
      sizeBytes: PDF.length,
      fileName: `${type.toLowerCase()}.pdf`,
    });
    await storage.write(granted.objectKey, "application/pdf", PDF);
    return { type, objectKey: granted.objectKey, fileName: `${type.toLowerCase()}.pdf` };
  }

  /** Người nộp đi hết luồng thật: tạo → mở link → lưu đủ thông tin + giấy tờ → gửi duyệt. */
  async function submitted(overrides: { email?: string; taxCode?: string; bankAccountNumber?: string } = {}) {
    const name = randomUUID().slice(0, 6);
    await applications.create(
      publicAuthz(),
      ApplicationCreateInputSchema.parse({
        operatorName: `Nhà xe ${tag} ${name}`,
        contactName: "Nguyễn Văn A",
        contactEmail: overrides.email ?? `${name}@${tag}.test`,
        acceptTerms: true,
      }),
      "203.0.113.7",
    );
    const message = links.at(-1)!;
    const token = tokenOf(message.link);
    const session = await open(token);
    const documents = [
      await upload(session, "BUSINESS_REGISTRATION"),
      await upload(session, "TRANSPORT_LICENSE"),
      await upload(session, "REPRESENTATIVE_AUTHORIZATION"),
    ];
    await applications.update(
      session.authz,
      session.applicant,
      ApplicationUpdateInputSchema.parse({
        legalName: `Công ty TNHH ${name}`,
        taxCode: overrides.taxCode ?? String(Math.floor(1e9 + Math.random() * 8e9)),
        hotline: "19006868",
        address: "266 Đồng Đen, TP. Hồ Chí Minh",
        displayName: `Xe ${name}`,
        description: null,
        bankName: "Vietcombank",
        bankAccountNumber: overrides.bankAccountNumber ?? String(Math.floor(1e11 + Math.random() * 8e11)),
        bankAccountHolder: "CTY TNHH",
        documents,
      }),
    );
    await applications.submit(session.authz, session.applicant);
    return { id: session.applicant.applicationId, code: message.applicationCode, email: message.email, token };
  }

  const stateOf = (applicationId: string) =>
    prisma.withSystem((tx) =>
      tx.operatorApplication.findUniqueOrThrow({
        where: { id: applicationId },
        select: {
          status: true,
          operatorId: true,
          reviewNote: true,
          reviewedAt: true,
          reviewedBy: true,
          approvalIdempotencyKey: true,
          accessTokens: { select: { revokedAt: true } },
        },
      }),
    );
  const operatorsWithSlug = (operatorSlug: string) =>
    prisma.withSystem(async (tx) => ({
      profiles: await tx.operatorProfile.count({ where: { operatorSlug } }),
      owners: await tx.operatorAccount.count({ where: { operatorSlug } }),
    }));

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-application-review-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    guard = new ApplicationTokenGuard(prisma);
    applications = new OperatorApplicationService(
      prisma,
      storage,
      notifier,
      limiter as unknown as OperatorApplicationRateLimiter,
      audit as unknown as AuditService,
      config,
    );
    const provisioning = new AccountProvisioningService(
      prisma,
      new CredentialService(),
      notifier,
      audit as unknown as AuditService,
      sessions as unknown as SessionService,
      emailLimiter as unknown as TemporaryCredentialEmailLimiter,
    );
    reviews = new OperatorApplicationReviewService(
      prisma,
      storage,
      notifier,
      audit as unknown as AuditService,
      config,
      provisioning,
    );
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const mine = { contactEmail: { endsWith: `@${tag}.test` } };
      await tx.operatorApplicationDocument.deleteMany({ where: { application: mine } });
      await tx.operatorApplicationAccessToken.deleteMany({ where: { application: mine } });
      await tx.operatorApplication.deleteMany({ where: mine });
      const slugs = { operatorSlug: { startsWith: `adm-${tag}-` } };
      await tx.operatorAccount.deleteMany({ where: slugs });
      await tx.operatorProfile.deleteMany({ where: slugs });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    recordAuditEvent.mockClear();
    sendTemporaryPassword.mockClear();
    sendOperatorApplicationDecision.mockClear();
  });

  describe("Hàng đợi và chi tiết (UC-23 bước 1–2)", () => {
    it("chỉ hồ sơ đã gửi duyệt; lọc trạng thái, tìm theo mã / tên; trang sau theo cursor, mới gửi trước", async () => {
      await applications.create(
        publicAuthz(),
        ApplicationCreateInputSchema.parse({
          operatorName: `Nhà xe ${tag} nhap`,
          contactName: "B",
          contactEmail: `nhap@${tag}.test`,
          acceptTerms: true,
        }),
        undefined,
      );
      const first = await submitted();
      const second = await submitted();
      const query = (input: object) => AdminApplicationListQuerySchema.parse({ q: tag, ...input });

      const all = await reviews.list(platformAuthz, query({}));
      expect(all.items.map((item) => item.id)).toEqual([second.id, first.id]);
      expect(all.items.every((item) => item.status === "SUBMITTED")).toBe(true);
      expect(JSON.stringify(all)).not.toContain("bankAccountNumber");

      const page1 = await reviews.list(platformAuthz, query({ limit: 1 }));
      expect(page1.items.map((item) => item.id)).toEqual([second.id]);
      const page2 = await reviews.list(platformAuthz, query({ limit: 1, cursor: page1.nextCursor }));
      expect(page2.items.map((item) => item.id)).toEqual([first.id]);

      const byCode = await reviews.list(platformAuthz, AdminApplicationListQuerySchema.parse({ q: first.code.toLowerCase() }));
      expect(byCode.items.map((item) => item.id)).toEqual([first.id]);
      expect((await reviews.list(platformAuthz, query({ status: "REJECTED" }))).items).toEqual([]);
    });

    it("trùng email / mã số thuế / tài khoản nhận tiền với hồ sơ khác → cảnh báo ở hàng đợi và chi tiết (UC-10 A2)", async () => {
      // Số ngẫu nhiên: DB dùng chung với test / E2E khác, số cố định có thể trùng hồ sơ của lần chạy trước.
      const email = `trung@${tag}.test`;
      const taxCode = String(Math.floor(1e9 + Math.random() * 8e9));
      const bankAccountNumber = `9${String(Math.floor(1e10 + Math.random() * 8e10))}`;
      const a = await submitted({ email, taxCode, bankAccountNumber });
      const b = await submitted({ email, taxCode, bankAccountNumber });
      const clean = await submitted();

      const list = await reviews.list(platformAuthz, AdminApplicationListQuerySchema.parse({ q: tag, limit: 50 }));
      const flags = new Map(list.items.map((item) => [item.id, item.duplicates]));
      expect(flags.get(a.id)).toEqual(["CONTACT_EMAIL", "TAX_CODE", "BANK_ACCOUNT"]);
      expect(flags.get(clean.id)).toEqual([]);
      const flaggedOnly = await reviews.list(
        platformAuthz,
        AdminApplicationListQuerySchema.parse({ q: tag, limit: 50, duplicatesOnly: "true" }),
      );
      expect(flaggedOnly.items.map((item) => item.id)).toEqual(expect.arrayContaining([a.id, b.id]));
      expect(flaggedOnly.items.map((item) => item.id)).not.toContain(clean.id);
      const recent = await reviews.list(
        platformAuthz,
        AdminApplicationListQuerySchema.parse({ q: tag, submittedSince: new Date(Date.now() + 60_000).toISOString() }),
      );
      expect(recent.items).toEqual([]);

      const detail = await reviews.get(platformAuthz, b.id);
      expect(detail.duplicates.taxCode.map((row) => row.applicationCode)).toEqual([a.code]);
      expect(detail.duplicates.bankAccount.map((row) => row.applicationCode)).toEqual([a.code]);
      expect(detail.bankAccountNumberMasked).toBe(`•••• ${bankAccountNumber.slice(-4)}`);
      expect(JSON.stringify(detail)).not.toContain(bankAccountNumber);
    });

    it("chi tiết: giấy tờ chỉ metadata, lịch sử tạo → xác minh email → gửi duyệt; nháp / id lạ → 404", async () => {
      const application = await submitted();
      const detail = await reviews.get(platformAuthz, application.id);
      expect(detail.documents.map((document) => document.type)).toEqual([
        "BUSINESS_REGISTRATION",
        "TRANSPORT_LICENSE",
        "REPRESENTATIVE_AUTHORIZATION",
      ]);
      expect(JSON.stringify(detail.documents)).not.toContain("operator-applications/");
      expect(detail.history?.map((item) => item.event)).toEqual(["SUBMITTED", "EMAIL_VERIFIED", "CREATED"]);
      expect(detail.operator).toBeNull();

      const notFound = { status: 404, code: "OPERATOR_APPLICATION_NOT_FOUND" };
      expect(await rejectionOf(reviews.get(platformAuthz, randomUUID()))).toMatchObject(notFound);
      const draft = await prisma.withSystem((tx) =>
        tx.operatorApplication.findFirstOrThrow({ where: { contactEmail: `nhap@${tag}.test` }, select: { id: true } }),
      );
      expect(await rejectionOf(reviews.get(platformAuthz, draft.id))).toMatchObject(notFound);

      // Audit không đọc được → vẫn xem được hồ sơ, lịch sử `null`.
      audit.listAuditEvents.mockRejectedValueOnce(new Error("mongo down"));
      expect((await reviews.get(platformAuthz, application.id)).history).toBeNull();
    });

    it("xem giấy tờ: URL có hạn + audit ghi Admin xem; loại chưa có / hồ sơ nháp → 404", async () => {
      const application = await submitted();
      const granted = await reviews.createDocumentDownload(platformAuthz, admin, application.id, "TRANSPORT_LICENSE");
      expect(granted.url).toContain("http://storage.test/");
      expect(recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({
          action: "operator_application.document.view",
          actorId: admin.sub,
          actorRole: "PLATFORM_ADMIN",
          targetId: application.id,
          after: expect.objectContaining({ type: "TRANSPORT_LICENSE", viewer: "platform" }),
        }),
        expect.anything(),
      );
      expect(
        await rejectionOf(reviews.createDocumentDownload(platformAuthz, admin, randomUUID(), "TRANSPORT_LICENSE")),
      ).toMatchObject({ status: 404, code: "OPERATOR_APPLICATION_DOCUMENT_NOT_FOUND" });
    });
  });

  describe("Duyệt (TC-OPR-002)", () => {
    it("tạo đúng một Operator ACTIVE + một Owner mật khẩu tạm; hồ sơ APPROVED, link hết hiệu lực, ghi người duyệt + audit", async () => {
      const application = await submitted();
      const operatorSlug = newSlug();
      const result = await reviews.approve(
        platformAuthz,
        admin,
        application.id,
        { operatorSlug, ownerUsername: "owner01" },
        `key-${randomUUID()}`,
        context,
      );
      expect(result).toMatchObject({
        applicationCode: application.code,
        status: "APPROVED",
        operatorSlug,
        ownerUsername: "owner01",
        credentialDeliveryPending: false,
      });
      expect(passwords.at(-1)).toMatchObject({ email: application.email, loginIdentifier: `${operatorSlug}/owner01` });

      const state = await stateOf(application.id);
      expect(state).toMatchObject({ status: "APPROVED", operatorId: result.operatorId, reviewedBy: admin.sub });
      expect(state.reviewedAt).not.toBeNull();
      expect(state.accessTokens.every((token) => token.revokedAt !== null)).toBe(true);
      expect(await operatorsWithSlug(operatorSlug)).toEqual({ profiles: 1, owners: 1 });
      const profile = await prisma.withSystem((tx) =>
        tx.operatorProfile.findUniqueOrThrow({ where: { id: result.operatorId }, select: { status: true, displayName: true } }),
      );
      expect(profile.status).toBe("ACTIVE");
      expect(profile.displayName).toMatch(/^Xe /);
      expect(await rejectionOf(open(application.token))).toMatchObject({ status: 401 });
      expect(recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({
          action: "operator_application.approve",
          actorId: admin.sub,
          before: { status: "SUBMITTED" },
          after: expect.objectContaining({ status: "APPROVED", operatorId: result.operatorId, operatorSlug }),
        }),
        expect.anything(),
      );
      const detail = await reviews.get(platformAuthz, application.id);
      expect(detail.operator).toEqual({
        operatorId: result.operatorId,
        operatorSlug,
        ownerUsername: "owner01",
        credentialDeliveryPending: false,
      });
      expect(detail.history?.[0]?.event).toBe("APPROVED");
    });

    it("gửi lặp cùng khóa → cùng kết quả, không tạo thêm; khác khóa → 409; gửi đồng thời cùng khóa → một Operator", async () => {
      const application = await submitted();
      const operatorSlug = newSlug();
      const key = `key-${randomUUID()}`;
      const input = { operatorSlug, ownerUsername: "owner01" };

      const [first, second] = await Promise.all([
        reviews.approve(platformAuthz, admin, application.id, input, key, context),
        reviews.approve(platformAuthz, admin, application.id, input, key, context),
      ]);
      // Lần về sau có thể đọc lúc email mật khẩu tạm của lần kia chưa gửi xong → cờ chờ giao là ảnh chụp lúc đọc.
      const { credentialDeliveryPending: _pending, ...firstResult } = first;
      expect(second).toMatchObject(firstResult);
      const replay = await reviews.approve(platformAuthz, admin, application.id, input, key, context);
      expect(replay).toEqual({ ...firstResult, credentialDeliveryPending: false });
      expect(
        await rejectionOf(reviews.approve(platformAuthz, admin, application.id, input, `key-${randomUUID()}`, context)),
      ).toMatchObject({ status: 409, code: "OPERATOR_APPLICATION_INVALID_STATE" });
      expect(await operatorsWithSlug(operatorSlug)).toEqual({ profiles: 1, owners: 1 });
    });

    it("hai Admin duyệt cùng lúc với hai slug khác nhau → đúng một Operator, lần kia 409 và không để lại gì", async () => {
      const application = await submitted();
      const [slugA, slugB] = [newSlug(), newSlug()];
      const results = await Promise.allSettled([
        reviews.approve(platformAuthz, admin, application.id, { operatorSlug: slugA, ownerUsername: "owner01" }, `a-${randomUUID()}`, context),
        reviews.approve(platformAuthz, admin, application.id, { operatorSlug: slugB, ownerUsername: "owner01" }, `b-${randomUUID()}`, context),
      ]);
      expect(results.filter((result) => result.status === "fulfilled")).toHaveLength(1);
      const failed = results.find((result) => result.status === "rejected") as PromiseRejectedResult;
      expect(await rejectionOf(Promise.reject(failed.reason))).toMatchObject({ status: 409 });
      const counts = [await operatorsWithSlug(slugA), await operatorsWithSlug(slugB)];
      expect(counts.map((count) => count.profiles).sort()).toEqual([0, 1]);
      expect(counts.map((count) => count.owners).sort()).toEqual([0, 1]);
    });

    it("slug đã thuộc nhà xe khác → OPERATOR_SLUG_CONFLICT, không tạo gì, hồ sơ vẫn SUBMITTED", async () => {
      const taken = newSlug();
      await reviews.approve(platformAuthz, admin, (await submitted()).id, { operatorSlug: taken, ownerUsername: "owner01" }, `k-${randomUUID()}`, context);
      const application = await submitted();
      expect(
        await rejectionOf(
          reviews.approve(platformAuthz, admin, application.id, { operatorSlug: taken, ownerUsername: "khac" }, `k-${randomUUID()}`, context),
        ),
      ).toMatchObject({ status: 409, code: "OPERATOR_SLUG_CONFLICT" });
      expect((await stateOf(application.id)).status).toBe("SUBMITTED");
      expect(await operatorsWithSlug(taken)).toEqual({ profiles: 1, owners: 1 });
    });

    it("audit duyệt lỗi → 503, không tạo Operator / Owner, hồ sơ vẫn SUBMITTED", async () => {
      const application = await submitted();
      const operatorSlug = newSlug();
      recordAuditEvent.mockImplementation(async (input: AuditEventInput) => {
        if (input.action === "operator_application.approve") {
          throw new AuditWriteError(new Error("mongo down"));
        }
        events.push({ ...input, createdAt: new Date() });
      });
      try {
        expect(
          await rejectionOf(
            reviews.approve(platformAuthz, admin, application.id, { operatorSlug, ownerUsername: "owner01" }, `k-${randomUUID()}`, context),
          ),
        ).toMatchObject({ status: 503 });
      } finally {
        recordAuditEvent.mockImplementation(async (input: AuditEventInput) => {
          events.push({ ...input, createdAt: new Date() });
        });
      }
      expect((await stateOf(application.id)).status).toBe("SUBMITTED");
      expect(await operatorsWithSlug(operatorSlug)).toEqual({ profiles: 0, owners: 0 });
    });

    it("email mật khẩu tạm lỗi → vẫn duyệt, báo chờ giao; gửi lại thành công thì hết cờ; gửi lại lần nữa → 409", async () => {
      const application = await submitted();
      const operatorSlug = newSlug();
      sendTemporaryPassword.mockRejectedValueOnce(new Error("provider down"));
      const key = `k-${randomUUID()}`;
      const result = await reviews.approve(platformAuthz, admin, application.id, { operatorSlug, ownerUsername: "owner01" }, key, context);
      expect(result).toMatchObject({ status: "APPROVED", credentialDeliveryPending: true });
      expect((await stateOf(application.id)).status).toBe("APPROVED");

      const resent = await reviews.resendOwnerCredentials(platformAuthz, admin, application.id, context);
      expect(resent).toMatchObject({ operatorId: result.operatorId, credentialDeliveryPending: false });
      expect(passwords.at(-1)).toMatchObject({ loginIdentifier: `${operatorSlug}/owner01` });
      expect(await rejectionOf(reviews.resendOwnerCredentials(platformAuthz, admin, application.id, context))).toMatchObject({
        status: 409,
        code: "ACCOUNT_STATE_CONFLICT",
      });
    });
  });

  describe("Yêu cầu bổ sung / từ chối (UC-23 bước 3, UC-10 A4 / A5)", () => {
    it("yêu cầu bổ sung → NEEDS_INFO + lý do + link mới (link cũ hết hiệu lực); người nộp sửa rồi gửi duyệt lại", async () => {
      const application = await submitted();
      const reason = "Bổ sung giấy phép kinh doanh vận tải còn hạn.";
      const result = await reviews.requestInfo(platformAuthz, admin, application.id, reason);
      expect(result).toEqual({ applicationCode: application.code, status: "NEEDS_INFO", emailDelivered: true });

      const state = await stateOf(application.id);
      expect(state).toMatchObject({ status: "NEEDS_INFO", reviewNote: reason, reviewedBy: admin.sub });
      const message = decisions.at(-1)!;
      expect(message).toMatchObject({ email: application.email, decision: "NEEDS_INFO", reason });
      expect(await rejectionOf(open(application.token))).toMatchObject({ status: 401 });

      const session = await open(tokenOf(message.link!));
      const view = await applications.get(session.authz, session.applicant);
      expect(view).toMatchObject({ status: "NEEDS_INFO", reviewNote: reason });
      await applications.submit(session.authz, session.applicant);
      expect((await stateOf(application.id)).status).toBe("SUBMITTED");
      const history = (await reviews.get(platformAuthz, application.id)).history!;
      expect(history.slice(0, 3).map((item) => [item.event, item.note])).toEqual([
        ["SUBMITTED", null],
        ["NEEDS_INFO", reason],
        ["SUBMITTED", null],
      ]);
    });

    it("từ chối → REJECTED + lý do, mọi link hết hiệu lực; không duyệt / bổ sung / từ chối lại được", async () => {
      const application = await submitted();
      const result = await reviews.reject(platformAuthz, admin, application.id, "Giấy tờ không khớp pháp nhân.");
      expect(result).toMatchObject({ status: "REJECTED", emailDelivered: true });
      expect(decisions.at(-1)).toMatchObject({ decision: "REJECTED", reason: "Giấy tờ không khớp pháp nhân." });
      expect(decisions.at(-1)!.link).toBeUndefined();
      const state = await stateOf(application.id);
      expect(state.status).toBe("REJECTED");
      expect(state.accessTokens.every((token) => token.revokedAt !== null)).toBe(true);

      const invalid = { status: 409, code: "OPERATOR_APPLICATION_INVALID_STATE" };
      expect(await rejectionOf(reviews.reject(platformAuthz, admin, application.id, "Lần nữa"))).toMatchObject(invalid);
      expect(await rejectionOf(reviews.requestInfo(platformAuthz, admin, application.id, "Bổ sung"))).toMatchObject(invalid);
      expect(
        await rejectionOf(
          reviews.approve(platformAuthz, admin, application.id, { operatorSlug: newSlug(), ownerUsername: "owner01" }, `k-${randomUUID()}`, context),
        ),
      ).toMatchObject(invalid);
    });

    it("email báo kết quả lỗi → quyết định vẫn lưu, phản hồi emailDelivered = false; hồ sơ lạ → 404", async () => {
      const application = await submitted();
      sendOperatorApplicationDecision.mockRejectedValueOnce(new Error("provider down"));
      expect(await reviews.reject(platformAuthz, admin, application.id, "Không đủ điều kiện.")).toMatchObject({
        status: "REJECTED",
        emailDelivered: false,
      });
      expect((await stateOf(application.id)).status).toBe("REJECTED");
      expect(await rejectionOf(reviews.reject(platformAuthz, admin, randomUUID(), "Không đủ điều kiện."))).toMatchObject({
        status: 404,
        code: "OPERATOR_APPLICATION_NOT_FOUND",
      });
    });

    it("audit quyết định lỗi → 503, hồ sơ giữ SUBMITTED và link cũ vẫn mở được", async () => {
      const application = await submitted();
      recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
      expect(await rejectionOf(reviews.requestInfo(platformAuthz, admin, application.id, "Bổ sung"))).toMatchObject({
        status: 503,
      });
      expect((await stateOf(application.id)).status).toBe("SUBMITTED");
      expect(decisions.filter((message) => message.applicationCode === application.code)).toEqual([]);
      await expect(open(application.token)).resolves.toBeDefined();
    });
  });
});
