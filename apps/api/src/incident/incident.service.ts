import { HttpStatus, Inject, Injectable, Logger } from "@nestjs/common";
import { IncidentSchema, type Incident, type IncidentInput, type IncidentPage, type OperationsQuery } from "@vexenhanh/types";
import { AuditService } from "../audit/audit.service";
import { PrismaService } from "../database/prisma.service";
import { NotificationKind, SubjectType } from "../database/prisma.types";
import type { Authorization } from "../iam/role/authorization";
import { requireAssignedTenant, requireTenant } from "../iam/role/require-tenant";
import { assignedActiveTrip, assignedTripIds, operationsError, operationsReadScope } from "../journey-log/operations-access";
import { NotificationDispatcher } from "../notification/notification-dispatcher";
import { queueNotification } from "../notification/notification-outbox";
import { SupportAttachmentService } from "../support/support-attachments";
import type { AttachmentUploadInput, AttachmentUploadResponse, DownloadUrlResponse } from "../support/dto/support.dto";

/** Sự cố trên chuyến được phân công, cảnh báo nhà xe và chuyển mức nghiêm trọng cho Admin (UC-22). */
@Injectable()
export class IncidentService {
  private readonly logger = new Logger(IncidentService.name);
  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(SupportAttachmentService) private readonly attachments: SupportAttachmentService,
    @Inject(NotificationDispatcher) private readonly notifications: NotificationDispatcher,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Cấp URL tải minh chứng riêng cho nhân viên của chuyến. */
  async upload(authz: Authorization, actor: { sub: string; role: string }, tripId: string, input: AttachmentUploadInput): Promise<AttachmentUploadResponse> {
    const { db, operatorId } = requireAssignedTenant(authz);
    this.requireReporter(actor);
    await this.prisma.withScope(db, (tx) => assignedActiveTrip(tx, operatorId, actor.sub, tripId));
    return this.attachments.createUpload({ operatorId, kind: "employee", employeeId: actor.sub }, input);
  }

  /** Lưu sự cố và cảnh báo bắt buộc trong cùng transaction. */
  async create(authz: Authorization, actor: { sub: string; role: string }, input: IncidentInput): Promise<Incident> {
    const { db, operatorId } = requireAssignedTenant(authz);
    this.requireReporter(actor);
    if (Date.parse(input.occurredAt) > Date.now() + 60_000) throw operationsError(HttpStatus.BAD_REQUEST, "VALIDATION_ERROR", "Giờ xảy ra sự cố không được ở tương lai.");
    await this.prisma.withScope(db, (tx) => assignedActiveTrip(tx, operatorId, actor.sub, input.tripId));
    const evidence = await this.attachments.inspectAll({ operatorId, kind: "employee", employeeId: actor.sub }, input.evidence);
    const result = await this.prisma.withScope(db, async (tx) => {
      await assignedActiveTrip(tx, operatorId, actor.sub, input.tripId);
      const row = await tx.incidentReport.create({ data: { ...input, occurredAt: new Date(input.occurredAt), operatorId, employeeId: actor.sub, evidence } });
      const owners = await tx.operatorAccount.findMany({ where: { operatorId, status: "ACTIVE", role: "OPERATOR_OWNER" }, select: { id: true, contactEmail: true } });
      const severe = input.severity === "HIGH" || input.severity === "CRITICAL";
      const admins = severe ? await tx.platformAccount.findMany({ where: { status: "ACTIVE", role: "PLATFORM_ADMIN" }, select: { id: true, contactEmail: true } }) : [];
      const keys: string[] = [];
      for (const recipient of [...owners.map((owner) => ({ ...owner, type: SubjectType.OPERATOR })), ...admins.map((admin) => ({ ...admin, type: SubjectType.PLATFORM }))]) {
        const key = `OPERATIONS_ALERT:${row.id}:${recipient.type}:${recipient.id}`;
        await queueNotification(tx, operatorId, {
          kind: NotificationKind.OPERATIONS_ALERT, dedupKey: key, tripId: input.tripId,
          recipientEmail: recipient.contactEmail, recipientType: recipient.type, recipientId: recipient.id,
          payload: { title: severe ? "Sự cố nghiêm trọng trên chuyến" : "Sự cố trên chuyến", message: input.description, incidentId: row.id, severity: input.severity, audience: recipient.type },
        });
        keys.push(key);
      }
      return { incident: serialize(row), keys };
    });
    await this.notifications.dispatch(result.keys);
    this.audit.recordAuditEvent({ actorId: actor.sub, actorRole: actor.role, action: "incident.report", targetType: "incident_report", targetId: result.incident.id, operatorId, after: { tripId: input.tripId, type: input.type, severity: input.severity } })
      .catch((error: unknown) => this.logger.error({ event: "audit.write_failed", action: "incident.report", error }));
    return result.incident;
  }

  /** Xem sự cố trong đúng tenant hoặc các chuyến nhân viên được giao. */
  async list(authz: Authorization, actor: { sub: string }, query: OperationsQuery): Promise<IncidentPage> {
    const { db, operatorId } = operationsReadScope(authz);
    return this.prisma.withScope(db, async (tx) => {
      const assigned = authz.scope === "assigned" ? await assignedTripIds(tx, operatorId!, actor.sub, query.tripId) : null;
      const where = { ...(operatorId ? { operatorId } : {}), ...(assigned ? { tripId: { in: assigned } } : query.tripId ? { tripId: query.tripId } : {}) };
      const cursor = query.cursor ? await tx.incidentReport.findFirst({ where: { ...where, id: query.cursor }, select: { id: true } }) : null;
      if (query.cursor && !cursor) return { items: [], nextCursor: null };
      const rows = await tx.incidentReport.findMany({ where, orderBy: [{ createdAt: "desc" }, { id: "desc" }], take: query.limit + 1, ...(cursor ? { cursor: { id: cursor.id }, skip: 1 } : {}) });
      return { items: rows.slice(0, query.limit).map(serialize), nextCursor: rows.length > query.limit ? rows[query.limit - 1]!.id : null };
    });
  }

  /** Nhà xe ghi nhận đã xử lý sự cố. */
  async resolve(authz: Authorization, actor: { sub: string }, id: string, resolution: string): Promise<Incident> {
    const { db, operatorId } = requireTenant(authz);
    return this.prisma.withScope(db, async (tx) => {
      const found = await tx.incidentReport.findFirst({ where: { id, operatorId }, select: { id: true } });
      if (!found) throw operationsError(HttpStatus.NOT_FOUND, "INCIDENT_NOT_FOUND", "Không tìm thấy sự cố.");
      await tx.incidentReport.updateMany({ where: { id, operatorId, resolvedAt: null }, data: { resolvedAt: new Date(), resolvedBy: actor.sub, resolution } });
      return serialize(await tx.incidentReport.findFirstOrThrow({ where: { id, operatorId } }));
    });
  }

  /** Cấp URL xem minh chứng sự cố, có kiểm phạm vi và ghi audit. */
  async download(authz: Authorization, actor: { sub: string; role: string }, id: string, index: number): Promise<DownloadUrlResponse> {
    const { db, operatorId } = operationsReadScope(authz);
    const found = await this.prisma.withScope(db, async (tx) => {
      const row = await tx.incidentReport.findFirst({ where: { id, ...(operatorId ? { operatorId } : {}) } });
      if (!row) return null;
      if (authz.scope === "assigned" && !(await assignedTripIds(tx, operatorId!, actor.sub, row.tripId)).length) return null;
      const file = serialize(row).evidence[index];
      return file ? { id: row.id, operatorId: row.operatorId, objectKey: file.objectKey, fileName: file.fileName } : null;
    });
    return this.attachments.createDownload(found, { id: actor.sub, role: actor.role });
  }

  private requireReporter(actor: { role: string }): void {
    if (!["DRIVER", "SUPPORT_STAFF"].includes(actor.role)) throw operationsError(HttpStatus.FORBIDDEN, "PERMISSION_DENIED", "Chỉ tài xế hoặc nhân viên hỗ trợ báo sự cố.");
  }
}

function serialize(row: { id: string; operatorId: string; tripId: string; employeeId: string; type: string; severity: string; description: string; location: string | null; occurredAt: Date; evidence: unknown; resolvedAt: Date | null; resolvedBy: string | null; resolution: string | null; createdAt: Date }): Incident {
  return IncidentSchema.parse({ ...row, occurredAt: row.occurredAt.toISOString(), createdAt: row.createdAt.toISOString(), resolvedAt: row.resolvedAt?.toISOString() ?? null });
}
