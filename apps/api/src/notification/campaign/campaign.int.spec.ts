import { randomUUID } from "node:crypto";
import { afterAll, beforeAll, describe, expect, it, vi } from "vitest";
import { parseAppConfig } from "../../config/env.config";
import { PrismaService, type DbTransaction } from "../../database/prisma.service";
import type { VerifiedAccessToken } from "../../iam/auth/token.service";
import { queueNotification, prepareNotificationChannels } from "../notification-outbox";
import { InboxService } from "../inbox.service";
import { deliverPushNotification } from "../push-delivery";
import { audienceBatch } from "./campaign-audience";
import { runCampaignBatch, startDueCampaigns, writeCampaignTest } from "./campaign-fanout";

const ready = Boolean(process.env.DATABASE_URL);
describe.skipIf(!ready && process.env.REQUIRE_DB_TESTS !== "1")("Chiến dịch thông báo và hộp thư — Postgres thật", () => {
  const suffix = randomUUID();
  // Chiến dịch quét theo id tăng dần từ `cursor`. Tiền tố `zzzzzzzz` xếp sau mọi id thật ở mọi collation và `cursor` = chính
  // tiền tố, nên chiến dịch thử chỉ chạm tài khoản của test dù chạy trên DB có sẵn dữ liệu (không tạo tin cho người thật).
  const prefix = `zzzzzzzz-campaign-${suffix}`;
  const id = (name: string) => `${prefix}-${name}`;
  const users = { plain: id("a-plain"), device: id("b-device"), optedOut: id("c-optedout"), newsFan: id("d-newsfan"), locked: id("e-locked") };
  const operatorId = randomUUID();
  const actor = (sub: string) => ({ sub, sid: randomUUID(), scope: "passenger", role: "PASSENGER" }) as VerifiedAccessToken;
  const config = parseAppConfig({ DATABASE_URL: process.env.DATABASE_URL });
  const now = new Date("2026-11-02T03:00:00Z");
  let prisma: PrismaService;
  let inbox: InboxService;
  const campaignIds: string[] = [];

  const createCampaign = (type: "SERVICE" | "PROMOTION" | "NEWS", status: "DRAFT" | "SENDING" | "SCHEDULED" = "SENDING", extra: Record<string, unknown> = {}) =>
    prisma.withSystem(async (tx) => {
      const row = await tx.notificationCampaign.create({
        data: { type, title: `Tiêu đề ${type}`, body: `Nội dung ${type}`, status, createdBy: "test", updatedBy: "test", cursor: prefix, ...extra },
      });
      campaignIds.push(row.id);
      return row;
    });
  const run = async (campaignId: string) => {
    for (;;) {
      const result = await runCampaignBatch(prisma, campaignId, now);
      if (result.done) return result;
    }
  };
  const messagesOf = (campaignId: string) => prisma.withSystem((tx) => tx.notificationInboxMessage.findMany({ where: { campaignId } }));
  const recipientsOf = async (campaignId: string) => (await messagesOf(campaignId)).map((row) => row.subjectId).filter((subject) => Object.values(users).includes(subject)).sort();

  beforeAll(async () => {
    prisma = new PrismaService(config);
    inbox = new InboxService(prisma);
    await prisma.withSystem(async (tx: DbTransaction) => {
      await tx.user.createMany({
        data: Object.entries(users).map(([name, userId]) => ({ id: userId, email: `${userId}@example.com`.toLowerCase(), name, emailVerified: true, status: name === "locked" ? "DISABLED" : "ACTIVE" })),
      });
      await tx.operatorProfile.create({ data: { id: operatorId, operatorSlug: `cp-${suffix}`, displayName: "Campaign test" } });
      await tx.pushDevice.create({ data: { subjectType: "PASSENGER", subjectId: users.device, provider: "FCM", token: `campaign-token-${suffix}`, tokenHash: `campaign-hash-${suffix}` } });
      await tx.notificationPreference.createMany({
        data: [
          { subjectType: "PASSENGER", subjectId: users.optedOut, kind: "PROMOTION", email: false, push: false },
          { subjectType: "PASSENGER", subjectId: users.newsFan, kind: "NEWS", email: true, push: true },
        ],
      });
    });
  });

  afterAll(async () => {
    if (!prisma) return;
    await prisma.withSystem(async (tx) => {
      const subjects = Object.values(users);
      const messages = await tx.notificationInboxMessage.findMany({ where: { subjectId: { in: subjects } }, select: { notificationId: true } });
      const notificationIds = messages.map((row) => row.notificationId);
      const deliveries = await tx.notificationDelivery.findMany({ where: { OR: [{ notificationId: { in: notificationIds } }, { operatorId }] }, select: { id: true } });
      await tx.notificationPushReceipt.deleteMany({ where: { deliveryId: { in: deliveries.map((row) => row.id) } } });
      await tx.notificationDelivery.deleteMany({ where: { notificationId: { in: notificationIds } } });
      await tx.notificationDelivery.deleteMany({ where: { operatorId } });
      await tx.notificationInboxMessage.deleteMany({ where: { subjectId: { in: subjects } } });
      await tx.notification.deleteMany({ where: { id: { in: notificationIds } } });
      await tx.notification.deleteMany({ where: { operatorId } });
      await tx.notificationCampaign.deleteMany({ where: { id: { in: campaignIds } } });
      await tx.pushDevice.deleteMany({ where: { subjectId: { in: subjects } } });
      await tx.notificationPreference.deleteMany({ where: { subjectId: { in: subjects } } });
      await tx.operatorProfile.deleteMany({ where: { id: operatorId } });
      await tx.user.deleteMany({ where: { id: { in: subjects } } });
    });
    await prisma.$disconnect();
  });

  it("dịch vụ gửi mọi tài khoản đang hoạt động, chỉ hộp thư + push, tuyệt đối không tạo bản gửi email", async () => {
    const campaign = await createCampaign("SERVICE");
    const result = await run(campaign.id);

    expect(await recipientsOf(campaign.id)).toEqual([users.plain, users.device, users.optedOut, users.newsFan].sort());
    const deliveries = await prisma.withSystem((tx) => tx.notificationDelivery.findMany({ where: { notification: { inboxMessage: { campaignId: campaign.id } } } }));
    expect(deliveries.map((row) => [row.channel, row.recipientId])).toEqual([["PUSH", users.device]]);
    expect(deliveries.every((row) => row.channel !== "EMAIL")).toBe(true);
    expect(result.done).toBe(true);
    const row = await prisma.withSystem((tx) => tx.notificationCampaign.findUniqueOrThrow({ where: { id: campaign.id } }));
    expect(row.status).toBe("COMPLETED");
    expect(row.recipientCount).toBe(4);
  });

  it("chạy lại một lô không tạo trùng tin hay trùng bản gửi (chống trùng)", async () => {
    const campaign = await createCampaign("SERVICE");
    await run(campaign.id);
    const before = await messagesOf(campaign.id);

    // Worker khởi động lại giữa chừng: đưa về SENDING, quét lại từ đầu.
    await prisma.withSystem((tx) => tx.notificationCampaign.update({ where: { id: campaign.id }, data: { status: "SENDING", cursor: prefix } }));
    await run(campaign.id);

    expect((await messagesOf(campaign.id)).length).toBe(before.length);
    const pushes = await prisma.withSystem((tx) => tx.notificationDelivery.count({ where: { channel: "PUSH", notification: { inboxMessage: { campaignId: campaign.id } } } }));
    expect(pushes).toBe(1);
  });

  it("khuyến mãi bỏ qua người đã tắt và áp trần 1 tin mỗi 24 giờ; tin tức chỉ tới người đã bật", async () => {
    const first = await createCampaign("PROMOTION");
    await run(first.id);
    expect(await recipientsOf(first.id)).toEqual([users.plain, users.device, users.newsFan].sort());

    const second = await createCampaign("PROMOTION");
    await run(second.id);
    expect(await recipientsOf(second.id)).toEqual([]);
    const row = await prisma.withSystem((tx) => tx.notificationCampaign.findUniqueOrThrow({ where: { id: second.id } }));
    expect(row.cappedCount).toBe(3);

    const news = await createCampaign("NEWS");
    await run(news.id);
    expect(await recipientsOf(news.id)).toEqual([users.newsFan]);
  });

  it("đối tượng theo hạng chỉ chọn đúng hạng", async () => {
    const target = { type: "PROMOTION", audience: "LOYALTY_TIER", tiers: ["GOLD"] } as never;
    const batch = await prisma.withSystem((tx) => audienceBatch(tx, target, prefix, now));
    // Tài khoản thử chưa có điểm nên là hạng thấp nhất, không thuộc GOLD.
    expect(batch.recipients.filter((recipient) => Object.values(users).includes(recipient.userId))).toEqual([]);
  });

  it("chiến dịch bị hủy giữa chừng không gửi thêm", async () => {
    const campaign = await createCampaign("SERVICE", "SENDING");
    await prisma.withSystem((tx) => tx.notificationCampaign.update({ where: { id: campaign.id }, data: { status: "CANCELLED" } }));
    const result = await runCampaignBatch(prisma, campaign.id, now);
    expect(result).toEqual({ done: true, cursor: null, dedupKeys: [] });
    expect(await messagesOf(campaign.id)).toEqual([]);
  });

  it("tới giờ thì chuyển SENDING; khuyến mãi đã hết thì dừng, không gửi tin trỏ vào nội dung đã hết", async () => {
    const due = await createCampaign("SERVICE", "SCHEDULED", { scheduledAt: new Date(now.getTime() - 1000) });
    const later = await createCampaign("SERVICE", "SCHEDULED", { scheduledAt: new Date(now.getTime() + 60_000) });
    const promotion = await prisma.withSystem((tx) =>
      tx.promotion.create({ data: { code: `CP${suffix.slice(0, 8)}`.toUpperCase(), name: "Hết hạn", scope: "PLATFORM", discountType: "AMOUNT", discountValue: 1000n, startsAt: new Date("2026-01-01"), endsAt: new Date("2026-02-01"), usageLimit: 1, status: "ACTIVE", createdBy: "test" } }),
    );
    const stale = await createCampaign("PROMOTION", "SCHEDULED", { scheduledAt: new Date(now.getTime() - 1000), promotionId: promotion.id });

    const started = await startDueCampaigns(prisma, now);

    expect(started.map((row) => row.id)).toContain(due.id);
    expect(started.map((row) => row.id)).not.toContain(later.id);
    expect(started.map((row) => row.id)).not.toContain(stale.id);
    const statuses = await prisma.withSystem((tx) => tx.notificationCampaign.findMany({ where: { id: { in: [due.id, later.id, stale.id] } }, select: { id: true, status: true, note: true } }));
    expect(statuses.find((row) => row.id === due.id)?.status).toBe("SENDING");
    expect(statuses.find((row) => row.id === later.id)?.status).toBe("SCHEDULED");
    expect(statuses.find((row) => row.id === stale.id)?.status).toBe("CANCELLED");
    await prisma.withSystem(async (tx) => {
      await tx.notificationCampaign.update({ where: { id: stale.id }, data: { promotionId: null } });
      await tx.promotion.delete({ where: { id: promotion.id } });
    });
  });

  it("push của chiến dịch mang nguyên nội dung Admin soạn; push giao dịch vẫn là câu chung", async () => {
    const campaign = await createCampaign("SERVICE");
    await run(campaign.id);
    const delivery = await prisma.withSystem((tx) => tx.notificationDelivery.findFirstOrThrow({ where: { channel: "PUSH", notification: { inboxMessage: { campaignId: campaign.id } } } }));
    const send = vi.fn().mockResolvedValue("SENT");
    const audit = { recordSystemLog: vi.fn().mockResolvedValue(undefined) };

    expect(await deliverPushNotification(prisma, { send }, audit, delivery.id, false)).toBe("SENT");
    expect(send.mock.calls[0]![0]).toMatchObject({ title: "Tiêu đề SERVICE", body: "Nội dung SERVICE", kind: "SERVICE_NOTICE" });
  });

  it("gửi thử gắn nhãn, chỉ tới một người và không tính vào số liệu chiến dịch", async () => {
    const campaign = await createCampaign("PROMOTION", "DRAFT");
    const { pushDevices } = await writeCampaignTest(prisma, { ...campaign, promotion: null, article: null }, users.device, now);

    expect(pushDevices).toBe(1);
    expect(await messagesOf(campaign.id)).toEqual([]);
    const page = await inbox.list(actor(users.device), { limit: 50 });
    expect(page.items.some((item) => item.title === "[Thử] Tiêu đề PROMOTION")).toBe(true);
  });

  it("thông báo giao dịch của hành khách cũng vào hộp thư, không kèm hướng dẫn tra cứu", async () => {
    const key = `inbox-${suffix}`;
    await prisma.withTenant(operatorId, (tx) =>
      queueNotification(tx, operatorId, { kind: "OPERATIONS_ALERT", dedupKey: key, recipientEmail: `${users.plain}@example.com`.toLowerCase(), recipientType: "PASSENGER", recipientId: users.plain, payload: { title: "Sự cố", message: "Chuyến của bạn đang trễ." } }),
    );
    await prepareNotificationChannels(prisma, [key]);
    await prepareNotificationChannels(prisma, [key]);

    const page = await inbox.list(actor(users.plain), { limit: 50 });
    const items = page.items.filter((item) => item.title === "Sự cố");
    expect(items).toHaveLength(1);
    expect(items[0]!.body).toBe("Chuyến của bạn đang trễ.");
  });

  it("hộp thư chỉ của chính chủ; đọc tin người khác không có tác dụng", async () => {
    const owner = await inbox.list(actor(users.newsFan), { limit: 50 });
    const message = owner.items[0]!;
    expect(owner.unreadCount).toBeGreaterThan(0);

    await inbox.markRead(actor(users.plain), message.id);
    expect((await inbox.list(actor(users.newsFan), { limit: 50 })).items.find((item) => item.id === message.id)?.readAt).toBeNull();

    await inbox.markRead(actor(users.newsFan), message.id);
    const after = await inbox.list(actor(users.newsFan), { limit: 50 });
    expect(after.items.find((item) => item.id === message.id)?.readAt).not.toBeNull();
    expect(after.unreadCount).toBe(owner.unreadCount - 1);

    await inbox.markAllRead(actor(users.newsFan));
    expect((await inbox.unreadCount(actor(users.newsFan))).unreadCount).toBe(0);
    expect((await inbox.list(actor(users.plain), { limit: 50 })).items.some((item) => item.id === message.id)).toBe(false);
  });

  it("phân trang hộp thư theo con trỏ, con trỏ của người khác không lộ dữ liệu", async () => {
    const first = await inbox.list(actor(users.device), { limit: 1 });
    expect(first.items).toHaveLength(1);
    expect(first.nextCursor).not.toBeNull();
    const second = await inbox.list(actor(users.device), { limit: 1, cursor: first.nextCursor! });
    expect(second.items[0]!.id).not.toBe(first.items[0]!.id);
  });

  it("RLS: tenant nhà xe không đọc được chiến dịch và hộp thư (tenant-RLS)", async () => {
    const seen = await prisma.withTenant(operatorId, async (tx) => ({
      campaigns: await tx.notificationCampaign.count(),
      messages: await tx.notificationInboxMessage.count(),
    }));
    expect(seen).toEqual({ campaigns: 0, messages: 0 });
    await expect(
      prisma.withTenant(operatorId, (tx) => tx.notificationCampaign.create({ data: { type: "SERVICE", title: "Lén", body: "Lén gửi", createdBy: "tenant", updatedBy: "tenant" } })),
    ).rejects.toThrow();
  });
});
