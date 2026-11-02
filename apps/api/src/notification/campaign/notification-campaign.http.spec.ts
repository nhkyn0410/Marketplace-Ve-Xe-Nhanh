import { randomUUID } from "node:crypto";
import type { AddressInfo } from "node:net";
import { type INestApplication, Module } from "@nestjs/common";
import { NestFactory } from "@nestjs/core";
import { ZodValidationPipe } from "nestjs-zod";
import { afterAll, beforeAll, beforeEach, describe, expect, it, vi } from "vitest";
import { ProblemDetailsExceptionFilter } from "../../common/errors/problem-details.filter";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { type AccessTokenClaims, TokenService } from "../../iam/auth/token.service";
import { SessionService } from "../../iam/session/session.service";
import { configureApiRoutes } from "../../openapi/openapi";
import { InboxController } from "../inbox.controller";
import { InboxService } from "../inbox.service";
import { AdminNotificationCampaignController } from "./notification-campaign.controller";
import { NotificationCampaignService } from "./notification-campaign.service";

/** Chuỗi guard thật: chỉ Quản trị viên có quyền `notification:broadcast` mới gửi được chiến dịch. */
describe("Chiến dịch thông báo — HTTP", () => {
  const campaign = {
    id: randomUUID(),
    type: "SERVICE",
    title: "Bảo trì hệ thống",
    body: "Hệ thống bảo trì 23h tối nay.",
    audience: "ALL",
    tiers: [],
    promotionId: null,
    promotionLabel: null,
    articleId: null,
    articleLabel: null,
    status: "DRAFT",
    scheduledAt: null,
    startedAt: null,
    completedAt: null,
    cancelledAt: null,
    note: null,
    recipientCount: 0,
    cappedCount: 0,
    createdAt: "2026-11-02T00:00:00.000Z",
    updatedAt: "2026-11-02T00:00:00.000Z",
  };
  const service = {
    list: vi.fn(async () => ({ items: [campaign], total: 1, offset: 0, limit: 25 })),
    options: vi.fn(async () => ({ promotions: [], articles: [] })),
    estimate: vi.fn(async () => ({ recipients: 3, withPush: 1, optedOut: 0, capped: 0 })),
    create: vi.fn(async () => campaign),
    detail: vi.fn(async () => ({ ...campaign, stats: { read: 0, pushSent: 0, pushPending: 0, pushFailed: 0, pushSkipped: 0 } })),
    update: vi.fn(async () => campaign),
    test: vi.fn(async () => ({ pushDevices: 1 })),
    send: vi.fn(async () => ({ ...campaign, status: "SCHEDULED" })),
    cancel: vi.fn(async () => ({ ...campaign, status: "CANCELLED" })),
  };
  const inbox = {
    list: vi.fn(async () => ({ items: [], nextCursor: null, unreadCount: 0 })),
    unreadCount: vi.fn(async () => ({ unreadCount: 2 })),
    markRead: vi.fn(async () => undefined),
    markAllRead: vi.fn(async () => undefined),
  };
  let app: INestApplication;
  let base: string;
  let tokens: TokenService;

  @Module({
    controllers: [AdminNotificationCampaignController, InboxController],
    providers: [
      { provide: APP_CONFIG, useValue: { NODE_ENV: "test", JWT_ACCESS_TTL_SECONDS: 900, JWT_ISSUER: "vexenhanh-test" } as AppConfig },
      TokenService,
      { provide: NotificationCampaignService, useValue: service },
      { provide: InboxService, useValue: inbox },
      { provide: SessionService, useValue: { assertActive: async () => undefined, assertOperatorAccountCurrent: async () => undefined } },
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

  beforeEach(() => vi.clearAllMocks());

  async function token(role: AccessTokenClaims["role"], perms?: string[]): Promise<string> {
    const platform = role.startsWith("PLATFORM");
    const scope = role === "PASSENGER" ? "passenger" : platform ? "platform" : "operator";
    return (
      await tokens.mintAccessToken({ sub: "actor-from-token", sid: randomUUID(), scope, role, ...(perms ? { perms } : {}), ...(scope === "operator" ? { operatorId: randomUUID(), operatorSlug: "nhaxe" } : {}), ...(scope === "passenger" ? {} : { mfa: true }) })
    ).accessToken;
  }

  async function call(method: string, path: string, accessToken: string | null, body?: object) {
    const response = await fetch(`${base}${path}`, {
      method,
      headers: { ...(accessToken ? { authorization: `Bearer ${accessToken}` } : {}), ...(body ? { "content-type": "application/json" } : {}) },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, body: (await response.json().catch(() => ({}))) as Record<string, unknown> };
  }

  const input = { type: "SERVICE", title: "Bảo trì hệ thống", body: "Hệ thống bảo trì 23h tối nay.", tiers: [] };

  it("chỉ Quản trị viên có quyền: Hỗ trợ, nhà xe, hành khách, chưa đăng nhập đều bị chặn", async () => {
    const admin = await token("PLATFORM_ADMIN");
    expect((await call("GET", "/admin/notification-campaigns", admin)).status).toBe(200);
    expect((await call("POST", "/admin/notification-campaigns", admin, input)).status).toBe(201);
    for (const role of ["PLATFORM_SUPPORT", "OPERATOR_OWNER", "PASSENGER"] as const) {
      const denied = await token(role);
      expect((await call("GET", "/admin/notification-campaigns", denied)).status).toBe(403);
      expect((await call("POST", "/admin/notification-campaigns", denied, input)).status).toBe(403);
      expect((await call("POST", `/admin/notification-campaigns/${campaign.id}/send`, denied, {})).status).toBe(403);
    }
    expect((await call("GET", "/admin/notification-campaigns", null)).status).toBe(401);
    expect(service.send).not.toHaveBeenCalled();
  });

  it("tài khoản quản trị bị bỏ quyền này thì không gửi được, có quyền thì được (TASK-IAM-007)", async () => {
    const withoutPermission = await token("PLATFORM_ADMIN", ["support:manage"]);
    expect((await call("POST", `/admin/notification-campaigns/${campaign.id}/send`, withoutPermission, {})).status).toBe(403);
    const withPermission = await token("PLATFORM_ADMIN", ["notification:broadcast"]);
    expect((await call("POST", `/admin/notification-campaigns/${campaign.id}/send`, withPermission, {})).status).toBe(200);
    expect(service.send).toHaveBeenCalledTimes(1);
  });

  it("kiểm dữ liệu vào: khuyến mãi phải gắn khuyến mãi, tin tức phải gắn bài, dịch vụ không chọn hạng", async () => {
    const admin = await token("PLATFORM_ADMIN");
    const invalid = [
      { ...input, title: "ab" },
      { ...input, body: "" },
      { ...input, type: "PROMOTION" },
      { ...input, type: "NEWS" },
      { ...input, promotionId: randomUUID() },
      { ...input, audience: "LOYALTY_TIER", tiers: ["GOLD"] },
      { ...input, type: "PROMOTION", promotionId: randomUUID(), audience: "LOYALTY_TIER", tiers: [] },
      { ...input, channels: ["EMAIL"] },
    ];
    for (const body of invalid) {
      expect((await call("POST", "/admin/notification-campaigns", admin, body)).status, JSON.stringify(body)).toBe(400);
    }
    expect(service.create).not.toHaveBeenCalled();
    expect((await call("POST", "/admin/notification-campaigns", admin, { ...input, type: "PROMOTION", promotionId: randomUUID(), audience: "LOYALTY_TIER", tiers: ["GOLD"] })).status).toBe(201);
    expect((await call("POST", `/admin/notification-campaigns/${campaign.id}/send`, admin, { scheduledAt: "ngày mai" })).status).toBe(400);
    expect((await call("POST", `/admin/notification-campaigns/${campaign.id}/test`, admin, { email: "khong-phai-email" })).status).toBe(400);
  });

  it("hộp thư: phải đăng nhập, id tin phải hợp lệ", async () => {
    const passenger = await token("PASSENGER");
    expect((await call("GET", "/me/inbox", null)).status).toBe(401);
    expect((await call("GET", "/me/inbox", passenger)).status).toBe(200);
    expect((await call("GET", "/me/inbox/unread-count", passenger)).body).toEqual({ unreadCount: 2 });
    expect((await call("POST", "/me/inbox/khong-phai-uuid/read", passenger)).status).toBe(400);
    expect((await call("POST", `/me/inbox/${randomUUID()}/read`, passenger)).status).toBe(204);
    expect((await call("POST", "/me/inbox/read-all", passenger)).status).toBe(204);
    expect(inbox.markAllRead).toHaveBeenCalledTimes(1);
  });
});
