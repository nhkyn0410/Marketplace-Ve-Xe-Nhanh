import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { APP_INTERCEPTOR, NestFactory } from "@nestjs/core";
import { ZodSerializerInterceptor, ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { PrismaService } from "../database/prisma.service";
import {
  ApplicationPublicGuard,
  ApplicationTokenGuard,
  hashApplicationToken,
  newApplicationToken,
} from "../iam/role/application-access";
import { configureApiRoutes } from "../openapi/openapi";
import { OperatorApplicationController } from "./operator-application.controller";
import { OperatorApplicationService } from "./operator-application.service";

/** Route thật + guard link bảo mật thật (Prisma giả); nghiệp vụ kiểm ở test tích hợp. */
describe("Hồ sơ đăng ký nhà xe — HTTP", () => {
  const applicationId = randomUUID();
  const { token, tokenHash } = newApplicationToken();
  const now = new Date().toISOString();
  const application = {
    applicationCode: "OA-2026-043152",
    status: "DRAFT",
    operatorName: "Sao Việt Express",
    contactName: "Nguyễn Thanh Sao",
    contactEmail: "lienhe@saoviet.vn",
    contactEmailVerifiedAt: now,
    legalName: null,
    taxCode: null,
    hotline: null,
    address: null,
    displayName: "Sao Việt Express",
    description: null,
    bankName: null,
    bankAccountNumberMasked: null,
    bankAccountHolder: null,
    documents: [],
    missing: ["legalName"],
    reviewNote: null,
    createdAt: now,
    submittedAt: null,
    updatedAt: now,
    linkExpiresAt: now,
  };
  const service = {
    create: vi.fn(async () => undefined),
    requestAccessLink: vi.fn(async () => undefined),
    get: vi.fn(async () => application),
    update: vi.fn(async () => application),
    createDocumentUpload: vi.fn(async () => ({ uploadUrl: "https://upload.test/x", objectKey: "k", expiresAt: now })),
    createDocumentDownload: vi.fn(async () => ({ url: "https://download.test/x", expiresAt: now })),
    submit: vi.fn(async () => ({ ...application, status: "SUBMITTED", submittedAt: now })),
  };
  // Prisma giả cho guard: chỉ biết đúng một token còn hạn của `applicationId`.
  const findUnique = vi.fn(async ({ where }: { where: { tokenHash: string } }) =>
    where.tokenHash === tokenHash
      ? {
          applicationId,
          expiresAt: new Date(Date.now() + 3_600_000),
          revokedAt: null,
          application: { status: "DRAFT", contactEmailVerifiedAt: new Date() },
        }
      : null,
  );
  const prisma = {
    withSystem: (work: (tx: unknown) => Promise<unknown>) =>
      work({ operatorApplicationAccessToken: { findUnique }, operatorApplication: { updateMany: vi.fn() } }),
  };
  let app: INestApplication;
  let base: string;

  @Module({
    controllers: [OperatorApplicationController],
    providers: [
      { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test" } as AppConfig },
      { provide: OperatorApplicationService, useValue: service },
      { provide: PrismaService, useValue: prisma },
      ApplicationTokenGuard,
      ApplicationPublicGuard,
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1/operator-applications`;
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function call(method: string, path: string, body?: object, applicationToken?: string) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: {
        "content-type": "application/json",
        ...(applicationToken === undefined ? {} : { "x-application-token": applicationToken }),
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });
    const text = await response.text();
    return { status: response.status, body: text ? (JSON.parse(text) as Record<string, unknown>) : null };
  }

  const createBody = {
    operatorName: "Sao Việt Express",
    contactName: "Nguyễn Thanh Sao",
    contactEmail: "LienHe@SaoViet.vn",
    acceptTerms: true,
  };

  it("tạo hồ sơ: 202 không có nội dung; email chuẩn hóa chữ thường; không cần token", async () => {
    const response = await call("POST", "", createBody);
    expect(response).toEqual({ status: 202, body: null });
    expect(service.create).toHaveBeenCalledWith(
      expect.objectContaining({ db: expect.objectContaining({ kind: "system" }) }),
      expect.objectContaining({ contactEmail: "lienhe@saoviet.vn" }),
      "127.0.0.1",
    );
  });

  it("gửi lại link: 202; mã hồ sơ chuẩn hóa chữ hoa", async () => {
    const response = await call("POST", "/access-link", { contactEmail: "lienhe@saoviet.vn", applicationCode: "oa-2026-043152" });
    expect(response).toEqual({ status: 202, body: null });
    expect(service.requestAccessLink).toHaveBeenCalledWith(
      expect.anything(),
      { contactEmail: "lienhe@saoviet.vn", applicationCode: "OA-2026-043152" },
      "127.0.0.1",
    );
  });

  it.each([
    ["", { ...createBody, acceptTerms: false }],
    ["", { ...createBody, contactEmail: "khong-phai-email" }],
    ["", { ...createBody, operatorName: "   " }],
    ["/access-link", { contactEmail: "a@b.vn", applicationCode: "2026-1" }],
  ])("POST %s dữ liệu sai → 400, service không bị gọi", async (path, body) => {
    expect((await call("POST", path, body)).status).toBe(400);
    expect(service.create).not.toHaveBeenCalled();
    expect(service.requestAccessLink).not.toHaveBeenCalled();
  });

  const linkRoutes: [string, string, object | undefined][] = [
    ["GET", "/current", undefined],
    ["PUT", "/current", { legalName: null, taxCode: null, hotline: null, address: null, displayName: null, description: null, bankName: null, bankAccountHolder: null, documents: [] }],
    ["POST", "/current/documents", { type: "TRANSPORT_LICENSE", contentType: "application/pdf", sizeBytes: 100, fileName: "a.pdf" }],
    ["POST", "/current/documents/TRANSPORT_LICENSE/download-url", undefined],
    ["POST", "/current/submit", undefined],
  ];

  it.each(linkRoutes)("%s %s: thiếu / sai token → 401 LINK_INVALID; đúng token → 200, hồ sơ lấy từ token", async (method, path, body) => {
    for (const bad of [undefined, "", "sai", newApplicationToken().token]) {
      const denied = await call(method, path, body, bad);
      expect(denied.status, String(bad)).toBe(401);
      expect(denied.body?.code).toBe("OPERATOR_APPLICATION_LINK_INVALID");
    }
    const allowed = await call(method, path, body, token);
    expect(allowed.status).toBe(200);
    expect(findUnique).toHaveBeenLastCalledWith(expect.objectContaining({ where: { tokenHash: hashApplicationToken(token) } }));
  });

  it("id hồ sơ chỉ lấy từ token: `applicationId` / `status` trong body bị bỏ qua", async () => {
    const other = randomUUID();
    await call(
      "PUT",
      "/current",
      {
        applicationId: other,
        status: "APPROVED",
        legalName: "Công ty A",
        taxCode: "0312 345 678",
        hotline: "1900 6868",
        address: null,
        displayName: null,
        description: null,
        bankName: null,
        bankAccountHolder: null,
        documents: [],
      },
      token,
    );
    const [, applicant, input] = service.update.mock.calls[0] as unknown as [unknown, { applicationId: string }, Record<string, unknown>];
    expect(applicant.applicationId).toBe(applicationId);
    expect(input).not.toHaveProperty("applicationId");
    expect(input).not.toHaveProperty("status");
    expect(input).toMatchObject({ taxCode: "0312345678", hotline: "19006868" });
    // Không gửi số tài khoản = giữ số cũ (không thành null).
    expect(input).not.toHaveProperty("bankAccountNumber");
  });

  it.each([
    ["PUT", "/current", { taxCode: "123", legalName: null, hotline: null, address: null, displayName: null, description: null, bankName: null, bankAccountHolder: null, documents: [] }],
    ["PUT", "/current", { legalName: null, taxCode: null, hotline: null, address: null, displayName: null, description: null, bankName: null, bankAccountHolder: null, bankAccountNumber: "12ab", documents: [] }],
    [
      "PUT",
      "/current",
      {
        legalName: null, taxCode: null, hotline: null, address: null, displayName: null, description: null, bankName: null, bankAccountHolder: null,
        documents: [
          { type: "TRANSPORT_LICENSE", objectKey: "a", fileName: "a.pdf" },
          { type: "TRANSPORT_LICENSE", objectKey: "b", fileName: "b.pdf" },
        ],
      },
    ],
    ["POST", "/current/documents", { type: "TRANSPORT_LICENSE", contentType: "text/html", sizeBytes: 10, fileName: "a.html" }],
    ["POST", "/current/documents", { type: "TRANSPORT_LICENSE", contentType: "application/pdf", sizeBytes: 10 * 1024 * 1024 + 1, fileName: "a.pdf" }],
    ["POST", "/current/documents", { type: "KHAC", contentType: "application/pdf", sizeBytes: 10, fileName: "a.pdf" }],
    ["POST", "/current/documents/KHAC/download-url", undefined],
  ])("%s %s dữ liệu sai → 400, service không bị gọi", async (method, path, body) => {
    expect((await call(method, path, body, token)).status).toBe(400);
    expect(service.update).not.toHaveBeenCalled();
    expect(service.createDocumentUpload).not.toHaveBeenCalled();
    expect(service.createDocumentDownload).not.toHaveBeenCalled();
  });
});
