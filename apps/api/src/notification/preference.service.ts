import { createHash } from "node:crypto";
import { Inject, Injectable, UnprocessableEntityException } from "@nestjs/common";
import { NotificationKinds, type NotificationPreferenceInput, type PushDeviceInput } from "@vexenhanh/types";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { withNotificationSubject } from "../database/preference-scope";
import { PrismaService } from "../database/prisma.service";
import { SubjectType } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { isOperatorAccountRole } from "../iam/role/role";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";

/** Các thông báo nghiệp vụ bắt buộc còn ít nhất một kênh nhận (BR-52). */
export function mandatoryNotification(kind: string): boolean { return kind !== "PROMOTION" && kind !== "LOYALTY_UPDATED"; }

/** Xác định chủ thể nhận thông báo từ phiên đã xác thực. */
export function notificationSubject(user: VerifiedAccessToken): { subjectType: SubjectType; subjectId: string; operatorId: string | null } {
  const subjectType = user.scope === "passenger" ? SubjectType.PASSENGER : user.scope === "platform" ? SubjectType.PLATFORM : isOperatorAccountRole(user.role) ? SubjectType.OPERATOR : SubjectType.EMPLOYEE;
  return { subjectType, subjectId: user.sub, operatorId: user.operatorId ?? null };
}

/** Quản lý tùy chọn và thiết bị của chính tài khoản đang đăng nhập. */
@Injectable()
export class PreferenceService {
  constructor(@Inject(PrismaService) private readonly prisma: PrismaService, @Inject(APP_CONFIG) private readonly config: AppConfig) {}

  /** Lấy từng loại thông báo với mặc định nhận qua email và push. */
  async preferences(user: VerifiedAccessToken) {
    const subject = notificationSubject(user);
    const rows = await withNotificationSubject(this.prisma, (tx) => tx.notificationPreference.findMany({ where: subject }));
    return { items: NotificationKinds.map((kind) => { const row = rows.find((item) => item.kind === kind); return { kind, email: row?.email ?? true, push: row?.push ?? true, mandatory: mandatoryNotification(kind) }; }) };
  }

  /** Lưu tùy chọn một loại, bảo vệ kênh bắt buộc và kiểm kênh push trước khi bật. */
  async save(user: VerifiedAccessToken, input: NotificationPreferenceInput) {
    if (mandatoryNotification(input.kind) && !input.email && !input.push) throw new UnprocessableEntityException({ code: "NOTIFICATION_REQUIRED", detail: "Thông báo bắt buộc phải còn ít nhất một kênh nhận." });
    const subject = notificationSubject(user);
    await withNotificationSubject(this.prisma, async (tx) => {
      if (input.push) {
        const providers = [this.config.FCM_PROJECT_ID && this.config.FCM_CLIENT_EMAIL && this.config.FCM_PRIVATE_KEY ? "FCM" : null, this.config.APNS_TEAM_ID && this.config.APNS_KEY_ID && this.config.APNS_PRIVATE_KEY && this.config.APNS_TOPIC ? "APNS" : null].filter((provider): provider is string => provider !== null);
        if (!(await tx.pushDevice.count({ where: { ...subject, active: true, provider: { in: providers } } }))) throw new UnprocessableEntityException({ code: "PUSH_DEVICE_REQUIRED", detail: "Cần thiết bị và kênh push đã cấu hình trước khi bật thông báo đẩy." });
      }
      await tx.notificationPreference.upsert({ where: { subjectType_subjectId_kind: { subjectType: subject.subjectType, subjectId: subject.subjectId, kind: input.kind } }, create: { ...subject, ...input }, update: { email: input.email, push: input.push } });
    });
    return this.preferences(user);
  }

  /** Đăng ký token cho chủ thể hiện tại; token đã gắn tài khoản khác được chuyển an toàn sang phiên mới. */
  async registerDevice(user: VerifiedAccessToken, input: PushDeviceInput) {
    const configured = input.provider === "FCM" ? this.config.FCM_PROJECT_ID && this.config.FCM_CLIENT_EMAIL && this.config.FCM_PRIVATE_KEY : this.config.APNS_TEAM_ID && this.config.APNS_KEY_ID && this.config.APNS_PRIVATE_KEY && this.config.APNS_TOPIC;
    if (!configured) throw new UnprocessableEntityException({ code: "PUSH_NOT_CONFIGURED", detail: "Kênh push chưa được cấu hình." });
    if (input.provider === "APNS" && !/^[0-9a-fA-F]{64}$/.test(input.token)) throw new UnprocessableEntityException({ code: "PUSH_TOKEN_INVALID", detail: "Token APNs không hợp lệ." });
    const tokenHash = createHash("sha256").update(`${input.provider}:${input.token}`).digest("hex");
    const subject = notificationSubject(user);
    return withNotificationSubject(this.prisma, (tx) => tx.pushDevice.upsert({ where: { tokenHash }, create: { ...subject, ...input, tokenHash }, update: { ...subject, ...input, active: true }, select: { id: true, provider: true, active: true } }));
  }

  /** Hủy thiết bị thuộc chính tài khoản, không tiết lộ token hay thiết bị của người khác. */
  async removeDevice(user: VerifiedAccessToken, id: string): Promise<void> {
    await withNotificationSubject(this.prisma, (tx) => tx.pushDevice.updateMany({ where: { id, ...notificationSubject(user) }, data: { active: false } }));
  }

  /** Tra cứu lịch sử gửi của chính chủ thể, chỉ trả địa chỉ đã che. */
  async history(user: VerifiedAccessToken, query: { offset: number; limit: number }) {
    const subject = notificationSubject(user);
    return withNotificationSubject(this.prisma, async (tx) => {
      const where = { recipientType: subject.subjectType, recipientId: subject.subjectId, ...(subject.operatorId ? { operatorId: subject.operatorId } : {}) };
      const [items, total] = await Promise.all([tx.notificationDelivery.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], skip: query.offset, take: query.limit, include: { notification: { select: { kind: true } } } }), tx.notificationDelivery.count({ where })]);
      return { items: items.map((item) => ({ id: item.id, notificationId: item.notificationId, kind: item.notification.kind, channel: item.channel, recipientMasked: item.recipientMasked, status: item.status, attempts: item.attempts, lastError: item.lastError, createdAt: item.createdAt.toISOString(), sentAt: item.sentAt?.toISOString() ?? null })), total, ...query };
    });
  }

  /** Cho Admin tra cứu nhật ký giao nhận, luôn chỉ trả địa chỉ đã che và trạng thái gửi. */
  async adminHistory(authz: Authorization, query: { offset: number; limit: number }) {
    if (authz.scope !== "any" || !authz.db || authz.db.kind !== "platform") throw permissionDenied();
    return this.prisma.withScope(authz.db, async (tx) => {
      const [items, total] = await Promise.all([tx.notificationDelivery.findMany({ orderBy: [{ createdAt: "desc" }, { id: "desc" }], skip: query.offset, take: query.limit, include: { notification: { select: { kind: true } } } }), tx.notificationDelivery.count()]);
      return { items: items.map((item) => ({ id: item.id, notificationId: item.notificationId, kind: item.notification.kind, channel: item.channel, recipientMasked: item.recipientMasked, status: item.status, attempts: item.attempts, lastError: item.lastError, createdAt: item.createdAt.toISOString(), sentAt: item.sentAt?.toISOString() ?? null })), total, ...query };
    });
  }
}
