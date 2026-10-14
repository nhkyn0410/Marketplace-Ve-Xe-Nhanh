import { randomUUID } from "node:crypto";
import { mkdtemp, rm, utimes } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import type { ExecutionContext } from "@nestjs/common";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { AuditWriteError, type AuditService } from "../audit/audit.service";
import { parseAppConfig } from "../config/env.config";
import { systemScope, tenantScope } from "../database/db-scope";
import { PrismaService } from "../database/prisma.service";
import type { EmailNotifier, OperatorApplicationLinkEmailMessage } from "../external/notification/email-notifier";
import { LocalStorageProvider } from "../external/storage/local-storage-provider";
import {
  type Applicant,
  ApplicationPublicGuard,
  ApplicationTokenGuard,
  hashApplicationToken,
} from "../iam/role/application-access";
import type { Authorization } from "../iam/role/authorization";
import {
  ApplicationAccessLinkInputSchema,
  ApplicationCreateInputSchema,
  ApplicationUpdateInputSchema,
  type ApplicationUpdateInput,
} from "./dto/operator-application.dto";
import { deleteOrphanApplicationDocuments, DOCUMENT_ORPHAN_MIN_AGE_MS } from "./application-document-cleanup";
import { APPLICATION_CODE_PATTERN, documentPrefix, MAX_DOCUMENT_BYTES } from "./operator-application-format";
import type { OperatorApplicationRateLimiter } from "./operator-application-rate-limiter";
import { ATTACHABLE_MAX_AGE_MS, OperatorApplicationService } from "./operator-application.service";

/**
 * TASK-OPR-001 — hồ sơ đăng ký nhà xe trên Postgres THẬT bằng role APP + kho ổ đĩa thật (TC-OPR-001, TC-OPR-003).
 * Guard link bảo mật chạy thật trên DB; email và audit là bản giả để đọc lại link / sự kiện.
 */
const url = process.env.DATABASE_URL;
const requireDb = process.env.REQUIRE_DB_TESTS === "1";

const PDF = Uint8Array.from([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37, 0x0a, 1, 2, 3]);
const PNG = Uint8Array.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 0, 0, 0, 0x0d]);

async function rejectionOf(promise: Promise<unknown>): Promise<{ status?: number; code?: string; reasons?: string[]; text: string }> {
  try {
    await promise;
    return { text: "" };
  } catch (error) {
    const response = (error as { getResponse?: () => { code?: string; reasons?: string[] } }).getResponse?.();
    return {
      status: (error as { getStatus?: () => number }).getStatus?.(),
      code: response?.code,
      reasons: response?.reasons,
      text: JSON.stringify(error, Object.getOwnPropertyNames(error)) + String(error),
    };
  }
}

function contextOf(request: object): ExecutionContext {
  return { switchToHttp: () => ({ getRequest: () => request }) } as unknown as ExecutionContext;
}

describe.skipIf(!url && !requireDb)("Hồ sơ đăng ký nhà xe — Postgres thật, role app", () => {
  let prisma: PrismaService;
  let rootDir: string;
  let storage: LocalStorageProvider;
  let service: OperatorApplicationService;
  let guard: ApplicationTokenGuard;
  const tag = randomUUID().slice(0, 8);
  const emails: OperatorApplicationLinkEmailMessage[] = [];
  const notifier: EmailNotifier = {
    sendOtp: async () => undefined,
    sendOperatorApplicationLink: async (message) => {
      emails.push(message);
    },
  };
  const limiter = { assertPublicRequest: vi.fn(async () => undefined), assertDocumentUpload: vi.fn(async () => undefined) };
  const audit = { recordAuditEvent: vi.fn(async () => undefined) };
  const config = parseAppConfig({ DATABASE_URL: url });

  const emailOf = (name: string) => `${name}@${tag}.test`;
  const publicAuthz = (): Authorization => {
    const request: { authz?: Authorization } = {};
    new ApplicationPublicGuard().canActivate(contextOf(request));
    return request.authz!;
  };

  /** Mở link như trình duyệt gửi header `X-Application-Token`: chạy guard thật trên DB. */
  async function open(token: string): Promise<{ authz: Authorization; applicant: Applicant }> {
    const request: { headers: Record<string, string>; authz?: Authorization; applicant?: Applicant } = {
      headers: { "x-application-token": token },
    };
    await guard.canActivate(contextOf(request));
    return { authz: request.authz!, applicant: request.applicant! };
  }

  const tokenOf = (message: OperatorApplicationLinkEmailMessage) => new URL(message.link).hash.replace("#token=", "");

  /** Tạo hồ sơ qua API công khai, trả token trong email và mã hồ sơ. */
  async function register(name = randomUUID().slice(0, 6)) {
    const before = emails.length;
    await service.create(
      publicAuthz(),
      ApplicationCreateInputSchema.parse({
        operatorName: `Nhà xe ${name}`,
        contactName: "Nguyễn Văn A",
        contactEmail: emailOf(name).toUpperCase(),
        acceptTerms: true,
      }),
      "203.0.113.7",
    );
    expect(emails.length).toBe(before + 1);
    const message = emails.at(-1)!;
    return { token: tokenOf(message), code: message.applicationCode, email: emailOf(name) };
  }

  async function upload(session: { authz: Authorization; applicant: Applicant }, type: string, body = PDF, contentType = "application/pdf") {
    const granted = await service.createDocumentUpload(session.authz, session.applicant, {
      type: type as never,
      contentType: contentType as never,
      sizeBytes: body.length,
      fileName: `${type.toLowerCase()}.pdf`,
    });
    await storage.write(granted.objectKey, contentType, body);
    return granted.objectKey;
  }

  const fullDraft = (documents: ApplicationUpdateInput["documents"]): ApplicationUpdateInput =>
    ApplicationUpdateInputSchema.parse({
      legalName: "Công ty TNHH Sao Việt",
      taxCode: "0312 345 678",
      hotline: "1900.6868",
      address: "266 Đồng Đen, TP. Hồ Chí Minh",
      displayName: "Sao Việt Express",
      description: null,
      bankName: "Vietcombank",
      bankAccountNumber: "0071 0045 21",
      bankAccountHolder: "CTY TNHH SAO VIET",
      documents,
    });

  async function completeDocuments(session: { authz: Authorization; applicant: Applicant }) {
    return [
      { type: "BUSINESS_REGISTRATION", objectKey: await upload(session, "BUSINESS_REGISTRATION"), fileName: "dkkd.pdf" },
      { type: "TRANSPORT_LICENSE", objectKey: await upload(session, "TRANSPORT_LICENSE"), fileName: "gpkd.pdf" },
      {
        type: "REPRESENTATIVE_AUTHORIZATION",
        objectKey: await upload(session, "REPRESENTATIVE_AUTHORIZATION", PNG, "image/png"),
        fileName: "cccd.png",
      },
    ] as ApplicationUpdateInput["documents"];
  }

  beforeAll(async () => {
    prisma = new PrismaService(parseAppConfig({ DATABASE_URL: url }));
    const [role] = await prisma.$queryRaw<{ rolsuper: boolean; rolbypassrls: boolean }[]>`
      SELECT rolsuper, rolbypassrls FROM pg_roles WHERE rolname = current_user`;
    if (!role || role.rolsuper || role.rolbypassrls) {
      throw new Error("DATABASE_URL đang là superuser/BYPASSRLS — dùng role app (TRN-001-guide.md §0).");
    }
    rootDir = await mkdtemp(join(tmpdir(), "vxn-operator-application-"));
    storage = new LocalStorageProvider({ rootDir, apiBaseUrl: "http://storage.test" });
    guard = new ApplicationTokenGuard(prisma);
    service = new OperatorApplicationService(
      prisma,
      storage,
      notifier,
      limiter as unknown as OperatorApplicationRateLimiter,
      audit as unknown as AuditService,
      config,
    );
  }, 30_000);

  afterAll(async () => {
    if (!prisma) {
      return;
    }
    await prisma.withSystem(async (tx) => {
      const applications = { contactEmail: { endsWith: `@${tag}.test` } };
      await tx.operatorApplicationDocument.deleteMany({ where: { application: applications } });
      await tx.operatorApplicationAccessToken.deleteMany({ where: { application: applications } });
      await tx.operatorApplication.deleteMany({ where: applications });
    });
    await prisma.$disconnect();
    await rm(rootDir, { recursive: true, force: true });
  });

  beforeEach(() => {
    limiter.assertPublicRequest.mockClear();
    limiter.assertDocumentUpload.mockClear();
    audit.recordAuditEvent.mockClear();
  });

  describe("RLS", () => {
    it("ba bảng ENABLE + FORCE RLS với policy platform_only; rlsProblems() rỗng", async () => {
      const rows = await prisma.$queryRaw<{ relname: string }[]>`
        SELECT c.relname FROM pg_class c JOIN pg_policies p ON p.tablename = c.relname
        WHERE c.relname IN ('operator_applications', 'operator_application_documents', 'operator_application_access_tokens')
          AND c.relrowsecurity AND c.relforcerowsecurity AND p.policyname = 'platform_only'
          AND p.cmd = 'ALL' AND p.qual LIKE '%app_rls_allows(NULL%' AND p.with_check LIKE '%app_rls_allows(NULL%'`;
      expect(rows.map((row) => row.relname).sort()).toEqual([
        "operator_application_access_tokens",
        "operator_application_documents",
        "operator_applications",
      ]);
      expect(await prisma.rlsProblems()).toEqual([]);
    });

    it("tenant bất kỳ không đọc / ghi được hồ sơ đăng ký; không ngữ cảnh → 0 dòng", async () => {
      const { code } = await register();
      const asTenant = await prisma.withScope(tenantScope(randomUUID()), async (tx) => ({
        applications: await tx.operatorApplication.count({ where: { applicationCode: code } }),
        tokens: await tx.operatorApplicationAccessToken.count(),
        documents: await tx.operatorApplicationDocument.count(),
      }));
      expect(asTenant).toEqual({ applications: 0, tokens: 0, documents: 0 });
      const inserted = await rejectionOf(
        prisma.withScope(tenantScope(randomUUID()), (tx) =>
          tx.operatorApplication.create({
            data: {
              applicationCode: `OA-2026-${String(Date.now()).slice(-6)}`,
              operatorName: "x",
              contactName: "x",
              contactEmail: emailOf("tenant"),
              termsAcceptedAt: new Date(),
            },
          }),
        ),
      );
      expect(inserted.text).toMatch(/row-level security|42501/i);
      expect(await prisma.operatorApplication.count({ where: { applicationCode: code } })).toBe(0);
      expect(await prisma.withScope(systemScope(), (tx) => tx.operatorApplication.count({ where: { applicationCode: code } }))).toBe(1);
    });
  });

  describe("Tạo hồ sơ và link bảo mật (TC-OPR-001, TC-OPR-003)", () => {
    it("tạo DRAFT: mã OA-năm-6 số, email chữ thường, tên hiển thị gợi ý sẵn, token chỉ lưu hash, link hạn 72 giờ", async () => {
      const before = Date.now();
      const { token, code, email } = await register("taohoso");
      expect(code).toMatch(APPLICATION_CODE_PATTERN);
      const message = emails.at(-1)!;
      expect(message.email).toBe(email);
      expect(message.link).toBe(`http://localhost:3002/register/application#token=${token}`);
      expect(message.expiresAt.getTime() - before).toBeGreaterThanOrEqual(72 * 3_600_000 - 1_000);
      expect(message.expiresAt.getTime() - before).toBeLessThanOrEqual(72 * 3_600_000 + 60_000);
      expect(limiter.assertPublicRequest).toHaveBeenCalledWith("create", email, "203.0.113.7");

      const stored = await prisma.withSystem((tx) =>
        tx.operatorApplication.findUniqueOrThrow({
          where: { applicationCode: code },
          select: {
            status: true,
            contactEmail: true,
            displayName: true,
            contactEmailVerifiedAt: true,
            operatorId: true,
            accessTokens: { select: { tokenHash: true } },
          },
        }),
      );
      expect(stored).toMatchObject({
        status: "DRAFT",
        contactEmail: email,
        displayName: "Nhà xe taohoso",
        contactEmailVerifiedAt: null,
        operatorId: null,
      });
      expect(stored.accessTokens).toEqual([{ tokenHash: hashApplicationToken(token) }]);
      expect(stored.accessTokens[0]!.tokenHash).not.toContain(token);
    });

    it("cùng một email đăng ký hai lần: hai hồ sơ riêng, phản hồi như nhau (không lộ email đã có hồ sơ)", async () => {
      const first = await register("trungemail");
      const second = await register("trungemail");
      expect(first.code).not.toBe(second.code);
      expect(first.token).not.toBe(second.token);
    });

    it("mở link lần đầu xác minh email; token của hồ sơ A chỉ mở đúng hồ sơ A", async () => {
      const a = await register();
      const b = await register();
      const sessionA = await open(a.token);
      const viewA = await service.get(sessionA.authz, sessionA.applicant);
      expect(viewA.applicationCode).toBe(a.code);
      expect(viewA.contactEmailVerifiedAt).not.toBeNull();
      expect(viewA.status).toBe("DRAFT");
      expect((await service.get((await open(b.token)).authz, (await open(b.token)).applicant)).applicationCode).toBe(b.code);
      // Lần mở sau không đổi thời điểm xác minh.
      const again = await service.get(sessionA.authz, (await open(a.token)).applicant);
      expect(again.contactEmailVerifiedAt).toBe(viewA.contactEmailVerifiedAt);
    });

    it("token sai dạng / không tồn tại / hết hạn / đã thu hồi / hồ sơ đã có kết quả → OPERATOR_APPLICATION_LINK_INVALID", async () => {
      const invalid = { status: 401, code: "OPERATOR_APPLICATION_LINK_INVALID" };
      expect(await rejectionOf(open(""))).toMatchObject(invalid);
      expect(await rejectionOf(open("ngan-qua"))).toMatchObject(invalid);
      expect(await rejectionOf(open("A".repeat(43)))).toMatchObject(invalid);

      const expired = await register();
      await prisma.withSystem((tx) =>
        tx.operatorApplicationAccessToken.updateMany({
          where: { tokenHash: hashApplicationToken(expired.token) },
          data: { expiresAt: new Date(Date.now() - 1_000), createdAt: new Date(Date.now() - 3_600_000) },
        }),
      );
      expect(await rejectionOf(open(expired.token))).toMatchObject(invalid);

      for (const status of ["APPROVED", "REJECTED"] as const) {
        const closed = await register();
        await prisma.withSystem(async (tx) => {
          if (status === "APPROVED") {
            const operator = await tx.operatorProfile.create({
              data: { operatorSlug: `opr-${randomUUID().slice(0, 8)}`, displayName: "Đã duyệt" },
            });
            await tx.operatorApplication.update({
              where: { applicationCode: closed.code },
              data: { status, submittedAt: new Date(), operatorId: operator.id },
            });
          } else {
            await tx.operatorApplication.update({
              where: { applicationCode: closed.code },
              data: { status, submittedAt: new Date() },
            });
          }
        });
        expect(await rejectionOf(open(closed.token)), status).toMatchObject(invalid);
      }
      await prisma.withSystem(async (tx) => {
        const approved = await tx.operatorApplication.findMany({
          where: { contactEmail: { endsWith: `@${tag}.test` }, status: "APPROVED" },
          select: { id: true, operatorId: true },
        });
        // Dọn Operator thử ngay: afterAll xóa hồ sơ trước, Operator không còn ai tham chiếu thì xóa được.
        await tx.operatorApplicationAccessToken.deleteMany({ where: { applicationId: { in: approved.map((row) => row.id) } } });
        await tx.operatorApplication.deleteMany({ where: { id: { in: approved.map((row) => row.id) } } });
        await tx.operatorProfile.deleteMany({ where: { id: { in: approved.map((row) => row.operatorId!) } } });
      });
    });

    it("gửi lại link: đúng email + mã → link mới, link cũ hết hiệu lực; sai cặp → không gửi gì, phản hồi như nhau", async () => {
      const { token, code, email } = await register();
      const before = emails.length;
      await service.requestAccessLink(
        publicAuthz(),
        ApplicationAccessLinkInputSchema.parse({ contactEmail: email.toUpperCase(), applicationCode: code.toLowerCase() }),
        undefined,
      );
      expect(emails.length).toBe(before + 1);
      const fresh = tokenOf(emails.at(-1)!);
      expect(fresh).not.toBe(token);
      expect(await rejectionOf(open(token))).toMatchObject({ code: "OPERATOR_APPLICATION_LINK_INVALID" });
      expect((await open(fresh)).applicant).toBeTruthy();
      expect(limiter.assertPublicRequest).toHaveBeenCalledWith("access-link", email, undefined);

      for (const input of [
        { contactEmail: emailOf("khac"), applicationCode: code },
        { contactEmail: email, applicationCode: "OA-2026-000000" },
      ]) {
        await expect(
          service.requestAccessLink(publicAuthz(), ApplicationAccessLinkInputSchema.parse(input), undefined),
        ).resolves.toBeUndefined();
      }
      expect(emails.length).toBe(before + 1);
      // Link mới nhất vẫn dùng được: yêu cầu sai cặp không thu hồi link của người khác.
      expect((await open(fresh)).applicant).toBeTruthy();
    });

    it("email gửi lỗi: hồ sơ vẫn tạo, API không báo lỗi (người nộp dùng gửi lại link)", async () => {
      const failing = new OperatorApplicationService(
        prisma,
        storage,
        { sendOtp: async () => undefined, sendOperatorApplicationLink: async () => Promise.reject(new Error("Resend down")) },
        limiter as unknown as OperatorApplicationRateLimiter,
        audit as unknown as AuditService,
        config,
      );
      await expect(
        failing.create(
          publicAuthz(),
          ApplicationCreateInputSchema.parse({
            operatorName: "Lỗi email",
            contactName: "B",
            contactEmail: emailOf("loiemail"),
            acceptTerms: true,
          }),
          undefined,
        ),
      ).resolves.toBeUndefined();
      expect(
        await prisma.withSystem((tx) => tx.operatorApplication.count({ where: { contactEmail: emailOf("loiemail") } })),
      ).toBe(1);
    });
  });

  describe("Lưu nháp, giấy tờ, gửi duyệt", () => {
    it("lưu nháp: chuẩn hóa mã số thuế / hotline / số tài khoản, số tài khoản chỉ trả bản che, bỏ trường = giữ số cũ", async () => {
      const session = await open((await register()).token);
      const saved = await service.update(session.authz, session.applicant, fullDraft([]));
      expect(saved).toMatchObject({
        taxCode: "0312345678",
        hotline: "19006868",
        bankAccountNumberMasked: "•••• 4521",
        bankName: "Vietcombank",
      });
      expect(saved).not.toHaveProperty("bankAccountNumber");
      expect(saved.missing).toEqual([
        "document:BUSINESS_REGISTRATION",
        "document:TRANSPORT_LICENSE",
        "document:REPRESENTATIVE_AUTHORIZATION",
      ]);
      const { bankAccountNumber: _omit, ...withoutAccount } = fullDraft([]);
      const kept = await service.update(session.authz, session.applicant, { ...withoutAccount, legalName: "Tên mới" });
      expect(kept).toMatchObject({ legalName: "Tên mới", bankAccountNumberMasked: "•••• 4521" });
      const cleared = await service.update(session.authz, session.applicant, { ...fullDraft([]), bankAccountNumber: null });
      expect(cleared.bankAccountNumberMasked).toBeNull();
      expect(cleared.missing).toContain("bankAccountNumber");
    });

    it("giấy tờ: tải lên kho riêng tư rồi gắn; thay giấy tờ xóa file cũ sau commit; URL xem ghi audit", async () => {
      const session = await open((await register()).token);
      const documents = await completeDocuments(session);
      expect(documents.every((document) => document.objectKey.startsWith(documentPrefix(session.applicant.applicationId)))).toBe(true);
      const saved = await service.update(session.authz, session.applicant, fullDraft(documents));
      expect(saved.documents.map((document) => [document.type, document.contentType, document.fileName])).toEqual([
        ["BUSINESS_REGISTRATION", "application/pdf", "dkkd.pdf"],
        ["TRANSPORT_LICENSE", "application/pdf", "gpkd.pdf"],
        ["REPRESENTATIVE_AUTHORIZATION", "image/png", "cccd.png"],
      ]);
      expect(saved.missing).toEqual([]);

      const replacement = await upload(session, "TRANSPORT_LICENSE");
      const replaced = await service.update(
        session.authz,
        session.applicant,
        fullDraft(documents.map((document) => (document.type === "TRANSPORT_LICENSE" ? { ...document, objectKey: replacement } : document))),
      );
      expect(replaced.documents.find((document) => document.type === "TRANSPORT_LICENSE")?.objectKey).toBe(replacement);
      expect(await storage.head(documents[1]!.objectKey)).toBeNull();
      expect(await storage.head(replacement)).not.toBeNull();

      const view = await service.createDocumentDownload(session.authz, session.applicant, "BUSINESS_REGISTRATION");
      expect(storage.verifyDownloadToken(new URL(view.url).searchParams.get("token")!)).toEqual({
        key: documents[0]!.objectKey,
        fileName: "dkkd.pdf",
      });
      expect(audit.recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({
          action: "operator_application.document.view",
          actorRole: "APPLICANT",
          targetType: "operator_application",
          targetId: session.applicant.applicationId,
        }),
        expect.anything(),
      );
      // Audit lỗi → không cấp URL (ADR-018: mỗi lần xem phải có audit).
      audit.recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
      expect(
        await rejectionOf(service.createDocumentDownload(session.authz, session.applicant, "BUSINESS_REGISTRATION")),
      ).toMatchObject({ status: 503 });
    });

    it("giấy tờ không hợp lệ (khóa hồ sơ khác / chưa tải / sai loại / HTML đổi đuôi / quá 10 MB / quá cũ) → 422, hồ sơ giữ nguyên", async () => {
      const other = await open((await register()).token);
      const session = await open((await register()).token);
      const good = await upload(session, "BUSINESS_REGISTRATION");
      await service.update(session.authz, session.applicant, fullDraft([{ type: "BUSINESS_REGISTRATION", objectKey: good, fileName: "a.pdf" }]));

      const foreign = await upload(other, "TRANSPORT_LICENSE");
      const notUploaded = (
        await service.createDocumentUpload(session.authz, session.applicant, {
          type: "TRANSPORT_LICENSE",
          contentType: "application/pdf",
          sizeBytes: 10,
          fileName: "x.pdf",
        })
      ).objectKey;
      const wrongType = await upload(session, "TRANSPORT_LICENSE", PDF, "application/pdf");
      await storage.write(wrongType, "image/png", PDF);
      const html = await upload(session, "TRANSPORT_LICENSE", new TextEncoder().encode("<!doctype html><script>x</script>"));
      const big = await upload(session, "TRANSPORT_LICENSE");
      const bigBody = new Uint8Array(MAX_DOCUMENT_BYTES + 1);
      bigBody.set(PDF);
      await storage.write(big, "application/pdf", bigBody);
      const stale = await upload(session, "TRANSPORT_LICENSE");
      const old = new Date(Date.now() - ATTACHABLE_MAX_AGE_MS - 60_000);
      await utimes(join(rootDir, stale), old, old);

      for (const [name, key] of Object.entries({ foreign, notUploaded, wrongType, html, big, stale })) {
        const result = await rejectionOf(
          service.update(
            session.authz,
            session.applicant,
            fullDraft([
              { type: "BUSINESS_REGISTRATION", objectKey: good, fileName: "a.pdf" },
              { type: "TRANSPORT_LICENSE", objectKey: key, fileName: "b.pdf" },
            ]),
          ),
        );
        expect(result, name).toMatchObject({ status: 422, code: "OPERATOR_APPLICATION_DOCUMENT_INVALID" });
        const current = await service.get(session.authz, session.applicant);
        expect(current.documents.map((document) => document.objectKey), name).toEqual([good]);
      }
      expect(await storage.head(foreign)).not.toBeNull();
    });

    it("gửi duyệt: thiếu → 422 kèm mọi mục còn thiếu; đủ → SUBMITTED + audit; sau đó không sửa / gửi lại được (409)", async () => {
      const session = await open((await register()).token);
      const empty = await rejectionOf(service.submit(session.authz, session.applicant));
      expect(empty).toMatchObject({ status: 422, code: "OPERATOR_APPLICATION_INCOMPLETE" });
      expect(empty.reasons).toEqual([
        "legalName",
        "taxCode",
        "hotline",
        "address",
        "document:BUSINESS_REGISTRATION",
        "document:TRANSPORT_LICENSE",
        "document:REPRESENTATIVE_AUTHORIZATION",
        "bankName",
        "bankAccountNumber",
        "bankAccountHolder",
      ]);

      await service.update(session.authz, session.applicant, fullDraft(await completeDocuments(session)));
      const submitted = await service.submit(session.authz, session.applicant);
      expect(submitted.status).toBe("SUBMITTED");
      expect(submitted.submittedAt).not.toBeNull();
      expect(audit.recordAuditEvent).toHaveBeenCalledWith(
        expect.objectContaining({
          action: "operator_application.submit",
          before: { status: "DRAFT" },
          after: expect.objectContaining({ status: "SUBMITTED" }),
        }),
        expect.anything(),
      );

      const notEditable = { status: 409, code: "OPERATOR_APPLICATION_INVALID_STATE" };
      expect(await rejectionOf(service.submit(session.authz, session.applicant))).toMatchObject(notEditable);
      expect(await rejectionOf(service.update(session.authz, session.applicant, fullDraft([])))).toMatchObject(notEditable);
      expect(
        await rejectionOf(
          service.createDocumentUpload(session.authz, session.applicant, {
            type: "TRANSPORT_LICENSE",
            contentType: "application/pdf",
            sizeBytes: 10,
            fileName: "x.pdf",
          }),
        ),
      ).toMatchObject(notEditable);
      // Hồ sơ chờ duyệt vẫn xem được qua link (UC-10 bước 8).
      expect((await service.get(session.authz, session.applicant)).status).toBe("SUBMITTED");
    });

    it("audit lỗi khi gửi duyệt → 503, hồ sơ vẫn là DRAFT (chuyển trạng thái và audit cùng transaction)", async () => {
      const session = await open((await register()).token);
      await service.update(session.authz, session.applicant, fullDraft(await completeDocuments(session)));
      audit.recordAuditEvent.mockRejectedValueOnce(new AuditWriteError(new Error("mongo down")));
      expect(await rejectionOf(service.submit(session.authz, session.applicant))).toMatchObject({ status: 503 });
      expect((await service.get(session.authz, session.applicant)).status).toBe("DRAFT");
    });

    it("hai lần lưu đồng thời: bộ giấy tờ cuối là trọn một trong hai lần lưu", async () => {
      const session = await open((await register()).token);
      const one = await upload(session, "BUSINESS_REGISTRATION");
      const two = await upload(session, "BUSINESS_REGISTRATION");
      await Promise.all([
        service.update(session.authz, session.applicant, fullDraft([{ type: "BUSINESS_REGISTRATION", objectKey: one, fileName: "1.pdf" }])),
        service.update(session.authz, session.applicant, fullDraft([{ type: "BUSINESS_REGISTRATION", objectKey: two, fileName: "2.pdf" }])),
      ]).catch(() => undefined);
      const final = await service.get(session.authz, session.applicant);
      expect(final.documents).toHaveLength(1);
      expect([one, two]).toContain(final.documents[0]!.objectKey);
    });

    it("job dọn: giấy tờ tải lên mà không gắn, quá 24 giờ thì bị xóa; giấy tờ đang gắn giữ nguyên", async () => {
      expect(ATTACHABLE_MAX_AGE_MS).toBeLessThan(DOCUMENT_ORPHAN_MIN_AGE_MS);
      const session = await open((await register()).token);
      const attached = await upload(session, "BUSINESS_REGISTRATION");
      await service.update(session.authz, session.applicant, fullDraft([{ type: "BUSINESS_REGISTRATION", objectKey: attached, fileName: "a.pdf" }]));
      const orphan = await upload(session, "TRANSPORT_LICENSE");
      const fresh = await upload(session, "REPRESENTATIVE_AUTHORIZATION");
      const old = new Date(Date.now() - DOCUMENT_ORPHAN_MIN_AGE_MS - 60_000);
      await utimes(join(rootDir, orphan), old, old);
      await utimes(join(rootDir, attached), old, old);

      expect(await deleteOrphanApplicationDocuments(storage, prisma)).toBeGreaterThanOrEqual(1);
      expect(await storage.head(orphan)).toBeNull();
      expect(await storage.head(attached)).not.toBeNull();
      // Vừa tải lên, người nộp chưa kịp lưu.
      expect(await storage.head(fresh)).not.toBeNull();
    });

    it("kho riêng tư chưa cấu hình (production, OQ-21) → tải / xem giấy tờ trả 503; lưu thông tin khác vẫn được", async () => {
      const noStorage = new OperatorApplicationService(
        prisma,
        null,
        notifier,
        limiter as unknown as OperatorApplicationRateLimiter,
        audit as unknown as AuditService,
        config,
      );
      const session = await open((await register()).token);
      const unavailable = { status: 503, code: "SERVICE_UNAVAILABLE" };
      expect(
        await rejectionOf(
          noStorage.createDocumentUpload(session.authz, session.applicant, {
            type: "TRANSPORT_LICENSE",
            contentType: "application/pdf",
            sizeBytes: 10,
            fileName: "x.pdf",
          }),
        ),
      ).toMatchObject(unavailable);
      expect(await rejectionOf(noStorage.createDocumentDownload(session.authz, session.applicant, "TRANSPORT_LICENSE"))).toMatchObject(
        unavailable,
      );
      expect((await noStorage.update(session.authz, session.applicant, fullDraft([]))).legalName).toBe("Công ty TNHH Sao Việt");
    });
  });
});
