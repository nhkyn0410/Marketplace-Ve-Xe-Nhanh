import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { AdminReportingController, OperatorReportingController } from "./reporting.controller";
import { ReportingService } from "./reporting.service";

/** Chuỗi guard thật của báo cáo (TASK-RPT-001 / 002): nhà xe = Owner (tenant từ JWT); Admin = PlatformAdmin + PlatformSupport. */
describe("Báo cáo — HTTP", () => {
  const operatorId = randomUUID();
  const emptyReport = { totals: {}, byRoute: [], employees: [] };
  const service = {
    operatorOverview: vi.fn(),
    operatorReport: vi.fn(async () => emptyReport),
    operatorReportCsv: vi.fn(async () => ({ filename: "bao-cao-2031-01-01-2031-01-31.csv", csv: "﻿\"Tuyến\"\r\n" })),
    adminOverview: vi.fn(),
    adminReport: vi.fn(async () => ({ totals: {}, byOperator: [], paymentMethods: [] })),
    adminReportCsv: vi.fn(async () => ({ filename: "bao-cao-he-thong.csv", csv: "﻿\"Nhà xe\"\r\n" })),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [OperatorReportingController, AdminReportingController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: ReportingService, useValue: service },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => false } },
    ],
  })
  class HttpTestModule {}

  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe());
    app.useGlobalFilters(new ProblemDetailsExceptionFilter());
    configureApiRoutes(app);
    await app.listen(0, "127.0.0.1");
    base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`;
    tokens = app.get(TokenService);
  }, 15_000);

  afterAll(async () => {
    await app?.close();
  });

  beforeEach(() => {
    vi.clearAllMocks();
  });

  async function token(role: AccessTokenClaims["role"]): Promise<string> {
    const platform = role.startsWith("PLATFORM");
    return (
      await tokens.mintAccessToken({
        sub: randomUUID(),
        sid: randomUUID(),
        scope: platform ? "platform" : "operator",
        role,
        ...(platform ? {} : { operatorId, operatorSlug: "nhaxe" }),
        mfa: true,
      })
    ).accessToken;
  }

  async function call(path: string, accessToken: string | null) {
    const response = await fetch(`${base}${path}`, { headers: accessToken ? { authorization: `Bearer ${accessToken}` } : {} });
    return { status: response.status, headers: response.headers, text: await response.text() };
  }

  it("nhà xe: chỉ Owner; nhân viên 403 (Admin bị `requireTenant` chặn ở service — xem int spec); không token 401; tenant lấy từ token; khoảng ngày sai / quá 366 ngày → 400", async () => {
    const owner = await token("OPERATOR_OWNER");
    expect((await call("/operator/reports/summary?from=2031-01-01&to=2031-01-31", owner)).status).toBe(200);
    const [authz, query] = service.operatorReport.mock.calls[0] as unknown as [{ scope: string; db: { operatorId: string } }, Record<string, unknown>];
    expect([authz.scope, authz.db.operatorId]).toEqual(["tenant", operatorId]);
    expect(query).toEqual({ from: "2031-01-01", to: "2031-01-31" });
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF"] as const) {
      expect((await call("/operator/reports/summary?from=2031-01-01&to=2031-01-31", await token(role))).status).toBe(403);
    }
    expect((await call("/operator/overview", null)).status).toBe(401);
    expect((await call("/operator/reports/summary?from=2031-02-01&to=2031-01-01", owner)).status).toBe(400);
    expect((await call("/operator/reports/summary?from=2030-01-01&to=2031-06-01", owner)).status).toBe(400);
    expect((await call("/operator/reports/summary?from=2031-01-01&to=2031-01-31&status=XYZ", owner)).status).toBe(400);
    expect(service.operatorReport).toHaveBeenCalledTimes(1);
  });

  it("xuất CSV: tải tệp đính kèm, không cache; Admin + Hỗ trợ xem báo cáo hệ thống; nhà xe 403", async () => {
    const csv = await call("/operator/reports/export?from=2031-01-01&to=2031-01-31", await token("OPERATOR_OWNER"));
    expect(csv.status).toBe(200);
    expect(csv.headers.get("content-type")).toContain("text/csv");
    expect(csv.headers.get("content-disposition")).toBe('attachment; filename="bao-cao-2031-01-01-2031-01-31.csv"');
    expect(csv.headers.get("cache-control")).toBe("no-store");
    expect((service.operatorReportCsv.mock.calls[0] as unknown as [unknown, { role: string }])[1].role).toBe("OPERATOR_OWNER");

    for (const role of ["PLATFORM_ADMIN", "PLATFORM_SUPPORT"] as const) {
      expect((await call("/admin/reports/summary?from=2031-01-01&to=2031-01-07", await token(role))).status).toBe(200);
    }
    expect((service.adminReport.mock.calls[0] as unknown as [{ scope: string }])[0].scope).toBe("any");
    expect((await call("/admin/reports/summary?from=2031-01-01&to=2031-01-07", await token("OPERATOR_OWNER"))).status).toBe(403);
    expect((await call("/admin/reports/export?from=2031-01-01&to=2031-01-07&provider=PAYPAL", await token("PLATFORM_ADMIN"))).status).toBe(400);
    expect((await call("/admin/reports/export?from=2031-01-01&to=2031-01-07", await token("PLATFORM_ADMIN"))).headers.get("content-disposition")).toBe(
      'attachment; filename="bao-cao-he-thong.csv"',
    );
  });
});
