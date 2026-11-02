import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { IncidentInputSchema, JourneyLogInputSchema, PickupWindowInputSchema } from "@vexenhanh/types";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { type AccessTokenClaims, TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { EmployeeJourneyLogController } from "../journey-log/journey-log.controller";
import { JourneyLogService } from "../journey-log/journey-log.service";
import { configureApiRoutes } from "../openapi/openapi";
import { contentTypeOfSupportKey, supportAttachmentKey } from "../support/support-attachments";
import { AdminIncidentController, EmployeeIncidentController, OperatorIncidentController } from "./incident.controller";
import { IncidentService } from "./incident.service";

describe("UC-22 — HTTP guard và Zod", () => {
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;
  const operatorId = randomUUID();
  const tripId = randomUUID();
  const incident = { create: vi.fn(async () => ({})), list: vi.fn(async () => ({ items: [], nextCursor: null })) };
  const journal = { create: vi.fn(async () => ({})), list: vi.fn(async () => ({ items: [], nextCursor: null })) };
  @Module({ controllers: [EmployeeIncidentController, OperatorIncidentController, AdminIncidentController, EmployeeJourneyLogController], providers: [
    { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig }, TokenService,
    { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined, hasRecentReauth: async () => false } },
    { provide: IncidentService, useValue: incident }, { provide: JourneyLogService, useValue: journal },
  ] }) class HttpTestModule {}
  beforeAll(async () => {
    app = await NestFactory.create(HttpTestModule, { logger: false, abortOnError: false });
    app.useGlobalPipes(new ZodValidationPipe()); app.useGlobalFilters(new ProblemDetailsExceptionFilter()); configureApiRoutes(app);
    await app.listen(0, "127.0.0.1"); base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`; tokens = app.get(TokenService);
  }, 15_000);
  afterAll(async () => { await app?.close(); });
  async function token(role: AccessTokenClaims["role"]) {
    const platform = role.startsWith("PLATFORM");
    return (await tokens.mintAccessToken({ sub: randomUUID(), sid: randomUUID(), scope: platform ? "platform" : "operator", role, mfa: true, ...(platform ? {} : { operatorId, operatorSlug: "nhaxe" }) })).accessToken;
  }
  async function call(method: string, path: string, role: AccessTokenClaims["role"], body?: object) {
    return fetch(`${base}${path}`, { method, headers: { authorization: `Bearer ${await token(role)}`, ...(body ? { "content-type": "application/json" } : {}) }, body: body ? JSON.stringify(body) : undefined });
  }
  it("DRIVER và SUPPORT_STAFF báo sự cố; nhân viên vé / Owner / Admin bị chặn; tenant lấy từ token", async () => {
    const input = { tripId, type: "SAFETY", severity: "HIGH", description: "Đã dừng xe kiểm tra.", occurredAt: new Date().toISOString(), operatorId: randomUUID() };
    expect((await call("POST", "/employee/incidents", "DRIVER", input)).status).toBe(201);
    expect((await call("POST", "/employee/incidents", "SUPPORT_STAFF", input)).status).toBe(201);
    for (const role of ["TICKET_STAFF", "OPERATOR_OWNER", "PLATFORM_ADMIN"] as const) expect((await call("POST", "/employee/incidents", role, input)).status).toBe(403);
    const [authz, , parsed] = incident.create.mock.calls[0] as unknown as [{ db: { operatorId: string } }, unknown, object];
    expect(authz.db.operatorId).toBe(operatorId); expect(parsed).not.toHaveProperty("operatorId");
    expect((await call("POST", "/employee/incidents", "DRIVER", { ...input, severity: "INVALID" })).status).toBe(400);
  });
  it("chỉ tài xế ghi nhật trình; Owner đọc sự cố tenant, Admin đọc giám sát, hành khách bị chặn", async () => {
    const input = { tripId, note: "Kiểm tra tình trạng xe.", actualAt: new Date().toISOString() };
    expect((await call("POST", "/employee/journey-logs", "DRIVER", input)).status).toBe(201);
    expect((await call("POST", "/employee/journey-logs", "SUPPORT_STAFF", input)).status).toBe(403);
    expect((await call("GET", "/operator/incidents", "OPERATOR_OWNER")).status).toBe(200);
    expect((await call("GET", "/admin/incidents", "PLATFORM_ADMIN")).status).toBe(200);
    expect((await call("GET", "/admin/incidents", "OPERATOR_OWNER")).status).toBe(403);
  });
});

describe("Vận hành — kiểm dữ liệu và minh chứng", () => {
  it("cửa sổ cần hai mốc có thứ tự, nhật trình cần nội dung, sự cố giới hạn ảnh", () => {
    expect(PickupWindowInputSchema.safeParse({ start: "2026-10-19T10:00:00+07:00", end: "2026-10-19T09:00:00+07:00" }).success).toBe(false);
    expect(PickupWindowInputSchema.safeParse({ start: null, end: null }).success).toBe(true);
    expect(PickupWindowInputSchema.safeParse({ start: new Date().toISOString(), end: null }).success).toBe(false);
    expect(JourneyLogInputSchema.safeParse({ tripId: randomUUID(), actualAt: new Date().toISOString() }).success).toBe(false);
    expect(IncidentInputSchema.safeParse({ tripId: randomUUID(), type: "VEHICLE", severity: "LOW", description: "Xe cần kiểm tra.", occurredAt: new Date().toISOString(), evidence: Array.from({ length: 6 }, () => ({ objectKey: "a", fileName: "a.jpg" })) }).success).toBe(false);
  });
  it("minh chứng nhân viên không gắn được khóa của nhân viên khác / của Owner", () => {
    const employee = { operatorId: randomUUID(), kind: "employee" as const, employeeId: randomUUID() };
    const key = supportAttachmentKey(employee, randomUUID(), "image/jpeg");
    expect(contentTypeOfSupportKey(employee, key)).toBe("image/jpeg");
    expect(contentTypeOfSupportKey({ ...employee, employeeId: randomUUID() }, key)).toBeNull();
    expect(contentTypeOfSupportKey({ operatorId: employee.operatorId, kind: "operator" }, key)).toBeNull();
  });
});
