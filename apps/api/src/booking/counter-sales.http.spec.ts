import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { APP_CONFIG, parseAppConfig } from "../config/env.config";
import { ProblemDetailsExceptionFilter } from "../common/errors/problem-details.filter";
import { TokenService } from "../iam/auth/token.service";
import { SessionService } from "../iam/session/session.service";
import { configureApiRoutes } from "../openapi/openapi";
import { SalesOfficeController } from "../operator/sales-office.controller";
import { SalesOfficeService } from "../operator/sales-office.service";
import { CounterSalesController } from "./counter-sales.controller";
import { CounterSalesService } from "./counter-sales.service";

describe("Counter + office routes — HTTP RBAC và Zod thật", () => {
  const operatorId = randomUUID(); const actorId = randomUUID(); const officeId = randomUUID(); const tripId = randomUUID(); const bookingId = randomUUID(); const holdId = randomUUID();
  const sales = { trips: vi.fn(async () => ({ items: [] })), hold: vi.fn(async () => ({ holdId })), getHold: vi.fn(async () => ({ holdId })), release: vi.fn(async () => undefined), create: vi.fn(async () => ({ bookingId })), list: vi.fn(async () => ({ items: [], nextCursor: null })), get: vi.fn(async () => ({ bookingId })), collect: vi.fn(async () => ({ receiptId: randomUUID() })), report: vi.fn(async () => ({ cash: "0", bankTransfer: "0", exceptions: "0", commission: "0", receipts: 0, sellers: [] })) };
  const offices = { list: vi.fn(async () => ({ items: [] })), get: vi.fn(async () => ({ id: officeId })), create: vi.fn(async () => ({ id: officeId })), update: vi.fn(async () => ({ id: officeId })), assignments: vi.fn(async () => ({ items: [] })), replaceAssignments: vi.fn(async () => ({ id: officeId })) };
  let app: INestApplication; let base: string; let tokens: TokenService;
  @Module({ controllers: [CounterSalesController, SalesOfficeController], providers: [{ provide: APP_CONFIG, useValue: parseAppConfig({ NODE_ENV: "test" }) }, TokenService, { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined } }, { provide: CounterSalesService, useValue: sales }, { provide: SalesOfficeService, useValue: offices }] })
  class TestModule {}
  beforeAll(async () => {
    app = await NestFactory.create(TestModule, { logger: false, abortOnError: false }); app.useGlobalPipes(new ZodValidationPipe()); app.useGlobalFilters(new ProblemDetailsExceptionFilter()); configureApiRoutes(app); await app.listen(0, "127.0.0.1"); base = `http://127.0.0.1:${(app.getHttpServer().address() as AddressInfo).port}/v1`; tokens = app.get(TokenService);
  });
  afterAll(async () => { await app?.close(); }); beforeEach(() => { vi.clearAllMocks(); });
  async function token(role: string) {
    const platform = role.startsWith("PLATFORM_");
    return (await tokens.mintAccessToken({ sub: actorId, sid: randomUUID(), scope: platform ? "platform" : "operator", role, ...(platform ? {} : { operatorId, operatorSlug: "counter-test" }), ...(role === "OPERATOR_OWNER" || role === "OPERATOR_MANAGER" || platform ? { mfa: true } : {}), ...(role === "OPERATOR_MANAGER" ? { perms: ["booking:read", "trip:manage"] } : {}) })).accessToken;
  }
  async function call(method: string, path: string, accessToken?: string, body?: unknown) {
    const response = await fetch(`${base}${path}`, { method, headers: { "content-type": "application/json", ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}) }, ...(body === undefined ? {} : { body: JSON.stringify(body) }) });
    return { status: response.status, body: response.status === 204 ? null : await response.json() as Record<string, unknown> };
  }
  const counter = "/operator/counter";
  const hold = { officeId, tripId, seatCodes: ["A1"], pickupSequence: 1, dropoffSequence: 2 };
  const booking = { holdId, contact: { fullName: "Khách", phone: "0901234567", email: null }, passengers: [{ seatCode: "A1", fullName: "Khách", phone: null }], expectedTotal: "300001", note: null };
  const receipt = { idempotencyKey: randomUUID(), method: "BANK_TRANSFER", amount: "300001", reference: "BANK-001" };
  it.each([
    ["GET", `${counter}/trips?officeId=${officeId}&date=2026-10-27`, undefined, 200], ["POST", `${counter}/holds`, hold, 201], ["GET", `${counter}/holds/${holdId}`, undefined, 200], ["DELETE", `${counter}/holds/${holdId}`, undefined, 204],
    ["POST", `${counter}/bookings`, booking, 201], ["GET", `${counter}/bookings?officeId=${officeId}`, undefined, 200], ["GET", `${counter}/bookings/${bookingId}`, undefined, 200], ["POST", `${counter}/bookings/${bookingId}/receipts`, receipt, 200], ["GET", `${counter}/report?officeId=${officeId}&date=2026-10-27`, undefined, 200],
  ] as [string, string, unknown, number][])("%s %s: owner/sales được, role khác không được", async (method, path, body, expected) => {
    for (const role of ["OPERATOR_OWNER", "SALES_STAFF"]) expect((await call(method, path, await token(role), body)).status, role).toBe(expected);
    expect((await call(method, path, undefined, body)).status).toBe(401);
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "OPERATOR_MANAGER", "PLATFORM_ADMIN"]) expect((await call(method, path, await token(role), body)).status, role).toBe(403);
  });

  it("văn phòng cho owner/staff đọc, chỉ owner quản lý và phân công", async () => {
    const staff = await token("SALES_STAFF"); const owner = await token("OPERATOR_OWNER");
    expect((await call("GET", "/operator/offices", staff)).status).toBe(200);
    const body = { code: "vp1", name: "Văn phòng", address: "Địa chỉ", active: true };
    expect((await call("POST", "/operator/offices", staff, body)).status).toBe(403);
    expect((await call("POST", "/operator/offices", owner, body)).status).toBe(201);
    expect((await call("PUT", `/operator/offices/${officeId}/assignments`, staff, { version: 0, employeeIds: [randomUUID()] })).status).toBe(403);
    expect((await call("PUT", `/operator/offices/${officeId}/assignments`, owner, { version: 0, employeeIds: [randomUUID()] })).status).toBe(200);
    expect((await call("PATCH", `/operator/offices/${officeId}`, owner, { ...body, version: 0 })).status).toBe(200);
  });

  it("Zod strip tenant/seller/channel giả và money không nhận số thực hoặc reference thiếu", async () => {
    const staff = await token("SALES_STAFF");
    expect((await call("POST", `${counter}/bookings`, staff, { ...booking, operatorId: randomUUID(), channel: "ONLINE", soldBy: "operator:fake" })).status).toBe(201);
    const [actor, authz, input] = sales.create.mock.calls[0] as unknown as [{ sub: string }, { db: { operatorId: string } }, Record<string, unknown>];
    expect(actor.sub).toBe(actorId); expect(authz.db.operatorId).toBe(operatorId); expect(input).not.toHaveProperty("operatorId"); expect(input).not.toHaveProperty("soldBy"); expect(input).not.toHaveProperty("channel");
    for (const amount of [12.5, "12.5", "-1", "NaN", "9223372036854775808"]) expect((await call("POST", `${counter}/bookings/${bookingId}/receipts`, staff, { ...receipt, amount })).status).toBe(400);
    expect((await call("POST", `${counter}/bookings/${bookingId}/receipts`, staff, { ...receipt, reference: null })).status).toBe(400);
    expect(sales.collect).not.toHaveBeenCalled();
  });
});
