import { z } from "zod";

export const NotificationKinds = ["BOOKING_CONFIRMED", "TICKETS_CANCELLED", "REFUND_SUCCEEDED", "TRIP_CHANGED", "TRIP_CANCELLED", "MANUAL_REFUND", "CASE_UPDATED", "OPERATIONS_ALERT", "LOYALTY_UPDATED", "PROMOTION", "SERVICE_NOTICE", "NEWS"] as const;
export const NotificationPreferenceInputSchema = z.object({ kind: z.enum(NotificationKinds), email: z.boolean(), push: z.boolean() });
export const NotificationPreferencesSchema = z.object({ items: z.array(NotificationPreferenceInputSchema.extend({ mandatory: z.boolean() })) });
export const PushDeviceInputSchema = z.object({ provider: z.enum(["FCM", "APNS"]), token: z.string().trim().min(16).max(4096).regex(/^[A-Za-z0-9_:.-]+$/) });
export const NotificationLogQuerySchema = z.object({ offset: z.coerce.number().int().min(0).max(100000).default(0), limit: z.coerce.number().int().min(1).max(100).default(25) });
export const NotificationLogSchema = z.object({ items: z.array(z.object({ id: z.string(), notificationId: z.string(), kind: z.enum(NotificationKinds), channel: z.enum(["EMAIL", "PUSH", "SMS"]), recipientMasked: z.string(), status: z.enum(["PENDING", "SENT", "FAILED", "SKIPPED"]), attempts: z.number().int(), lastError: z.string().nullable(), createdAt: z.iso.datetime(), sentAt: z.iso.datetime().nullable() })), total: z.number().int(), offset: z.number().int(), limit: z.number().int() });

export type NotificationPreferenceInput = z.infer<typeof NotificationPreferenceInputSchema>;
export type PushDeviceInput = z.infer<typeof PushDeviceInputSchema>;

// ------------------------------------------------------------------ Hộp thư trong app (TASK-NSR-003)

export const NotificationLinkTypes = ["PROMOTION", "ARTICLE", "BOOKING"] as const;
export const NotificationInboxQuerySchema = z.object({
  cursor: z.uuid().optional(),
  limit: z.coerce.number().int().min(1).max(50).default(20),
});
export const NotificationInboxItemSchema = z.object({
  id: z.uuid(),
  kind: z.enum(NotificationKinds),
  title: z.string(),
  body: z.string(),
  /** Đích khi mở tin; `linkTarget` là mã khuyến mãi / slug bài viết / id đơn. */
  linkType: z.enum(NotificationLinkTypes).nullable(),
  linkTarget: z.string().nullable(),
  createdAt: z.iso.datetime(),
  readAt: z.iso.datetime().nullable(),
});
export const NotificationInboxPageSchema = z.object({
  items: z.array(NotificationInboxItemSchema),
  nextCursor: z.uuid().nullable(),
  unreadCount: z.number().int(),
});
export const NotificationUnreadCountSchema = z.object({ unreadCount: z.number().int() });

export type NotificationInboxQuery = z.infer<typeof NotificationInboxQuerySchema>;
export type NotificationInboxItem = z.infer<typeof NotificationInboxItemSchema>;
export type NotificationInboxPage = z.infer<typeof NotificationInboxPageSchema>;

// ------------------------------------------------------------------ Chiến dịch thông báo của Admin (TASK-NSR-003)

export const NotificationCampaignTypes = ["SERVICE", "PROMOTION", "NEWS"] as const;
export const NotificationCampaignStatuses = ["DRAFT", "SCHEDULED", "SENDING", "COMPLETED", "CANCELLED"] as const;
export const NotificationAudiences = ["ALL", "LOYALTY_TIER"] as const;
export const NotificationCampaignTiers = ["BRONZE", "SILVER", "GOLD", "PLATINUM"] as const;

/** Người nhận theo dạng: thông báo dịch vụ đến mọi tài khoản, không chọn hạng. */
export const NotificationAudienceInputSchema = z
  .object({
    type: z.enum(NotificationCampaignTypes),
    audience: z.enum(NotificationAudiences).default("ALL"),
    tiers: z.array(z.enum(NotificationCampaignTiers)).max(4),
  })
  .strict()
  .superRefine((input, context) => {
    if (input.audience === "LOYALTY_TIER" && input.tiers.length === 0) {
      context.addIssue({ code: "custom", path: ["tiers"], message: "Chọn ít nhất một hạng thành viên." });
    }
    if (input.audience === "ALL" && input.tiers.length > 0) {
      context.addIssue({ code: "custom", path: ["tiers"], message: "Gửi tất cả thì không chọn hạng." });
    }
    if (input.type === "SERVICE" && input.audience !== "ALL") {
      context.addIssue({ code: "custom", path: ["audience"], message: "Thông báo dịch vụ gửi tới mọi tài khoản." });
    }
  });

export const NotificationCampaignInputSchema = z
  .object({
    type: z.enum(NotificationCampaignTypes),
    title: z.string().trim().min(3).max(80),
    body: z.string().trim().min(3).max(500),
    audience: z.enum(NotificationAudiences).default("ALL"),
    tiers: z.array(z.enum(NotificationCampaignTiers)).max(4),
    promotionId: z.uuid().nullable().default(null),
    articleId: z.uuid().nullable().default(null),
  })
  .strict()
  .superRefine((input, context) => {
    const audience = NotificationAudienceInputSchema.safeParse({ type: input.type, audience: input.audience, tiers: input.tiers });
    if (!audience.success) {
      for (const issue of audience.error.issues) context.addIssue({ code: "custom", path: issue.path, message: issue.message });
    }
    if (input.type === "PROMOTION" && !input.promotionId) {
      context.addIssue({ code: "custom", path: ["promotionId"], message: "Chọn khuyến mãi đang chạy để gắn vào thông báo." });
    }
    if (input.type === "NEWS" && !input.articleId) {
      context.addIssue({ code: "custom", path: ["articleId"], message: "Chọn bài viết đã đăng để gắn vào thông báo." });
    }
    if (input.type !== "PROMOTION" && input.promotionId) {
      context.addIssue({ code: "custom", path: ["promotionId"], message: "Chỉ thông báo khuyến mãi mới gắn khuyến mãi." });
    }
    if (input.type !== "NEWS" && input.articleId) {
      context.addIssue({ code: "custom", path: ["articleId"], message: "Chỉ thông báo tin tức mới gắn bài viết." });
    }
  });

export const NotificationCampaignQuerySchema = z.object({
  status: z.enum(NotificationCampaignStatuses).optional(),
  offset: z.coerce.number().int().min(0).max(100000).default(0),
  limit: z.coerce.number().int().min(1).max(100).default(25),
});

/** Hẹn giờ gửi; `null` = gửi ngay. */
export const NotificationCampaignSendInputSchema = z.object({ scheduledAt: z.iso.datetime().nullable().default(null) }).strict();
export const NotificationCampaignTestInputSchema = z.object({ email: z.email().max(254) }).strict();
export const NotificationCampaignTestResultSchema = z.object({ pushDevices: z.number().int() });

export const NotificationAudienceEstimateSchema = z.object({
  /** Tin sẽ vào hộp thư. */
  recipients: z.number().int(),
  /** Trong đó có thiết bị nhận push. */
  withPush: z.number().int(),
  /** Khách đã tắt loại thông báo này. */
  optedOut: z.number().int(),
  /** Bỏ qua do đã nhận khuyến mãi trong 24 giờ qua. */
  capped: z.number().int(),
});

export const NotificationCampaignSchema = z.object({
  id: z.uuid(),
  type: z.enum(NotificationCampaignTypes),
  title: z.string(),
  body: z.string(),
  audience: z.enum(NotificationAudiences),
  tiers: z.array(z.enum(NotificationCampaignTiers)),
  promotionId: z.uuid().nullable(),
  promotionLabel: z.string().nullable(),
  articleId: z.uuid().nullable(),
  articleLabel: z.string().nullable(),
  status: z.enum(NotificationCampaignStatuses),
  scheduledAt: z.iso.datetime().nullable(),
  startedAt: z.iso.datetime().nullable(),
  completedAt: z.iso.datetime().nullable(),
  cancelledAt: z.iso.datetime().nullable(),
  note: z.string().nullable(),
  recipientCount: z.number().int(),
  cappedCount: z.number().int(),
  createdAt: z.iso.datetime(),
  updatedAt: z.iso.datetime(),
});

export const NotificationCampaignDetailSchema = NotificationCampaignSchema.extend({
  stats: z.object({
    read: z.number().int(),
    pushSent: z.number().int(),
    pushPending: z.number().int(),
    pushFailed: z.number().int(),
    pushSkipped: z.number().int(),
  }),
});

export const NotificationCampaignPageSchema = z.object({
  items: z.array(NotificationCampaignSchema),
  total: z.number().int(),
  offset: z.number().int(),
  limit: z.number().int(),
});

/** Khuyến mãi đang chạy và bài viết đã đăng để gắn vào chiến dịch. */
export const NotificationCampaignOptionsSchema = z.object({
  promotions: z.array(z.object({ id: z.uuid(), code: z.string(), name: z.string(), endsAt: z.iso.datetime() })),
  articles: z.array(z.object({ id: z.uuid(), title: z.string(), slug: z.string(), publishedAt: z.iso.datetime().nullable() })),
});

export type NotificationCampaignType = (typeof NotificationCampaignTypes)[number];
export type NotificationAudienceInput = z.infer<typeof NotificationAudienceInputSchema>;
export type NotificationCampaignInput = z.infer<typeof NotificationCampaignInputSchema>;
export type NotificationCampaignQuery = z.infer<typeof NotificationCampaignQuerySchema>;
export type NotificationCampaignSendInput = z.infer<typeof NotificationCampaignSendInputSchema>;
export type NotificationCampaignTestInput = z.infer<typeof NotificationCampaignTestInputSchema>;
export type NotificationCampaignTestResult = z.infer<typeof NotificationCampaignTestResultSchema>;
export type NotificationAudienceEstimate = z.infer<typeof NotificationAudienceEstimateSchema>;
export type NotificationCampaign = z.infer<typeof NotificationCampaignSchema>;
export type NotificationCampaignDetail = z.infer<typeof NotificationCampaignDetailSchema>;
export type NotificationCampaignPage = z.infer<typeof NotificationCampaignPageSchema>;
export type NotificationCampaignOptions = z.infer<typeof NotificationCampaignOptionsSchema>;
