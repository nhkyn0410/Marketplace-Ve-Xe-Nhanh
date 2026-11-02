import { Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { EMAIL_NOTIFIER, type EmailNotifier, maskEmail } from "../external/notification/email-notifier";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import type { AdminVehicleImageList, AdminVehicleImageListQuery } from "./dto/admin-vehicle-image.dto";
import { vehicleImageAuditUnavailable, vehicleImageNotFound } from "./vehicle.errors";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;
const ROW_SELECT = {
  id: true,
  objectKey: true,
  position: true,
  caption: true,
  createdAt: true,
  operatorId: true,
  vehicleId: true,
  vehicle: { select: { plateNumber: true, operator: { select: { displayName: true } } } },
} as const;

/**
 * Admin rà soát / gỡ ảnh phương tiện vi phạm (TASK-ADM-003 phần ảnh xe; FR-ADM-20, BR-76, UC-28 A6, LLD §6.12 bước 7).
 * Ảnh không qua duyệt trước; gỡ = xóa dòng + object, lý do bắt buộc, audit TRONG transaction (lỗi → 503, ảnh còn
 * nguyên), rồi báo chủ nhà xe qua email. Scope DB `platform` (đọc / xóa ảnh mọi nhà xe qua `app_rls_allows`).
 */
@Injectable()
export class AdminVehicleImageService {
  private readonly logger = new Logger(AdminVehicleImageService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @Inject(EMAIL_NOTIFIER) private readonly email: EmailNotifier,
  ) {}

  /** Ảnh của mọi nhà xe, mới tải lên trước; kèm nhà xe đang có ảnh cho ô lọc. */
  async list(authz: Authorization, query: AdminVehicleImageListQuery): Promise<AdminVehicleImageList> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const where = {
        operatorId: query.operatorId,
        ...(query.uploadedSince ? { createdAt: { gte: new Date(query.uploadedSince) } } : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      const rows = await tx.vehicleImage.findMany({
        where: {
          AND: [
            where,
            after ? { OR: [{ createdAt: { lt: after.at } }, { createdAt: after.at, id: { lt: after.id } }] } : {},
          ],
        },
        orderBy: [{ createdAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: ROW_SELECT,
      });
      const kept = rows.slice(0, query.limit);
      const covers = await tx.vehicleImage.groupBy({
        by: ["vehicleId"],
        where: { vehicleId: { in: [...new Set(kept.map((row) => row.vehicleId))] } },
        _min: { position: true },
      });
      const coverPosition = new Map(covers.map((group) => [group.vehicleId, group._min.position]));
      const total = await tx.vehicleImage.count({ where });
      const operatorIds = await tx.vehicleImage.groupBy({ by: ["operatorId"] });
      const operators = await tx.operatorProfile.findMany({
        where: { id: { in: operatorIds.map((group) => group.operatorId) } },
        orderBy: { displayName: "asc" },
        select: { id: true, displayName: true },
      });
      const last = kept.at(-1);
      return {
        items: kept.map((row) => ({
          id: row.id,
          url: this.storage.publicUrl(row.objectKey),
          caption: row.caption,
          position: row.position,
          isCover: coverPosition.get(row.vehicleId) === row.position,
          vehicleId: row.vehicleId,
          plateNumber: row.vehicle.plateNumber,
          operatorId: row.operatorId,
          operatorName: row.vehicle.operator.displayName,
          createdAt: row.createdAt.toISOString(),
        })),
        nextCursor: rows.length > query.limit && last ? encodeTimeCursor(last.createdAt, last.id) : null,
        total,
        operators: operators.map((operator) => ({ id: operator.id, name: operator.displayName })),
      };
    });
  }

  /**
   * Gỡ một ảnh. Khóa dòng xe như lần nhà xe thay bộ ảnh (`VehicleImageService.replace`) để hai việc xếp hàng: nhà
   * xe đang giữ ảnh này trong danh sách gửi lên sẽ nhận 422 thay vì gắn lại ảnh vừa bị gỡ. Object bị xóa SAU commit
   * (lỗi để job dọn object mồ côi xử lý); email báo chủ nhà xe lỗi chỉ ghi log.
   */
  async remove(authz: Authorization, actor: Actor, imageId: string, reason: string): Promise<void> {
    const removed = await this.inTransaction(authz, async (tx, deadline) => {
      const image = await tx.vehicleImage.findUnique({ where: { id: imageId }, select: ROW_SELECT });
      if (!image) {
        throw vehicleImageNotFound();
      }
      await tx.$queryRaw`
        SELECT 1 FROM vehicles WHERE id = ${image.vehicleId} AND operator_id = ${image.operatorId} FOR NO KEY UPDATE`;
      const deleted = await tx.vehicleImage.deleteMany({ where: { id: imageId } });
      if (deleted.count === 0) {
        throw vehicleImageNotFound();
      }
      await this.audit.recordAuditEvent(
        {
          actorId: actor.sub,
          actorRole: actor.role,
          action: "vehicle_image.remove",
          targetType: "vehicle_image",
          targetId: image.id,
          operatorId: image.operatorId,
          before: {
            vehicleId: image.vehicleId,
            plateNumber: image.vehicle.plateNumber,
            objectKey: image.objectKey,
            position: image.position,
            caption: image.caption,
          },
          after: null,
          reason,
        },
        { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
      );
      return image;
    });

    await this.storage.delete(removed.objectKey).catch((error: unknown) => {
      this.logger.warn({ event: "vehicle.image.delete_failed", key: removed.objectKey, error });
    });
    await this.notifyOwners(authz, removed.operatorId, {
      operatorName: removed.vehicle.operator.displayName,
      plateNumber: removed.vehicle.plateNumber,
      caption: removed.caption,
      reason,
    });
  }

  private async notifyOwners(
    authz: Authorization,
    operatorId: string,
    message: { operatorName: string; plateNumber: string; caption: string | null; reason: string },
  ): Promise<void> {
    try {
      const owners = await this.prisma.withScope(platformDb(authz), (tx) =>
        tx.operatorAccount.findMany({
          where: { operatorId, role: "OPERATOR_OWNER", status: "ACTIVE", contactEmail: { not: null } },
          select: { contactEmail: true },
        }),
      );
      for (const owner of owners) {
        const email = owner.contactEmail!;
        try {
          if (!this.email.sendVehicleImageRemoved) {
            throw new Error("Email adapter does not support vehicle image removal.");
          }
          await this.email.sendVehicleImageRemoved({ ...message, email });
        } catch (error) {
          this.logger.warn({ event: "vehicle.image.removed.delivery_failed", email: maskEmail(email), error });
        }
      }
    } catch (error) {
      this.logger.warn({ event: "vehicle.image.removed.recipients_failed", error });
    }
  }

  /** Transaction scope platform; audit lỗi / transaction hết hạn → 503, không gỡ gì. */
  private async inTransaction<T>(
    authz: Authorization,
    work: (tx: DbTransaction, deadline: number) => Promise<T>,
  ): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw vehicleImageAuditUnavailable();
      }
      throw error;
    }
  }
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin ảnh phương tiện cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
