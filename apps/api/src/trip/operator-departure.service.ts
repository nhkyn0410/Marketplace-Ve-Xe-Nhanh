import { Inject, Injectable, Logger } from "@nestjs/common";
import type { TripDeparture, TripDepartureInput } from "@vexenhanh/types";
import { AuditService } from "../audit/audit.service";
import { PrismaService } from "../database/prisma.service";
import { TripStatus } from "../database/prisma.types";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { can } from "../iam/role/access-policy";
import type { Authorization } from "../iam/role/authorization";
import { permissionDenied } from "../iam/role/authorization.errors";
import { requireTenant } from "../iam/role/require-tenant";
import { tripNotFound, tripStatusTransitionInvalid } from "./trip.errors";

const BEFORE_DEPARTURE: TripStatus[] = [TripStatus.OPEN_FOR_SALE, TripStatus.LOCKED, TripStatus.SOLD_OUT, TripStatus.BOARDING];
const AFTER_DEPARTURE: TripStatus[] = [TripStatus.DEPARTED, TripStatus.IN_PROGRESS, TripStatus.COMPLETED];

/** Điều phối ghi mốc khởi hành thực tế dùng chung với tài xế và giao dịch bán quầy. */
@Injectable()
export class OperatorDepartureService {
  private readonly logger = new Logger(OperatorDepartureService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
  ) {}

  /** Xác nhận xe đã khởi hành, giữ nguyên mốc đã ghi khi gửi lại yêu cầu. */
  async depart(actor: Pick<VerifiedAccessToken, "sub" | "role" | "perms">, authz: Authorization, tripId: string, input: TripDepartureInput): Promise<TripDeparture> {
    if (authz.permission !== "trip:dispatch" || !can(actor, "trip:dispatch").allowed) {
      throw permissionDenied();
    }
    const { db, operatorId } = requireTenant(authz);
    const result = await this.prisma.withScope(db, async (tx) => {
      // Cùng khóa dòng với EmployeeOperationsService. Bán quầy phải lấy khóa chuyến trước khóa đơn / ghế.
      const [trip] = await tx.$queryRaw<{ status: TripStatus; departedAt: Date | null }[]>`
        SELECT status::text AS "status", departed_at AS "departedAt"
        FROM trips WHERE id = ${tripId} AND operator_id = ${operatorId} FOR NO KEY UPDATE`;
      if (!trip) {
        throw tripNotFound();
      }
      if (trip.departedAt && AFTER_DEPARTURE.includes(trip.status)) {
        return { departedAt: trip.departedAt, from: trip.status, changed: false };
      }
      if (trip.departedAt || !BEFORE_DEPARTURE.includes(trip.status)) {
        throw tripStatusTransitionInvalid("Chỉ xác nhận khởi hành cho chuyến đang bán hoặc đang đón khách, chưa khởi hành.");
      }
      const departedAt = new Date();
      await tx.trip.updateMany({
        where: { id: tripId, operatorId, status: trip.status, departedAt: null },
        data: { status: TripStatus.DEPARTED, departedAt },
      });
      return { departedAt, from: trip.status, changed: true };
    });
    if (result.changed) {
      this.audit.recordAuditEvent({
        actorId: actor.sub,
        actorRole: actor.role,
        action: "trip.departure_confirmed",
        targetType: "trip",
        targetId: tripId,
        operatorId,
        before: { status: result.from, departedAt: null },
        after: { status: TripStatus.DEPARTED, departedAt: result.departedAt.toISOString() },
        ...(input.note ? { reason: input.note } : {}),
      }).catch((error: unknown) => this.logger.error({ event: "audit.write_failed", action: "trip.departure_confirmed", tripId, error }));
    }
    return { tripId, departedAt: result.departedAt.toISOString() };
  }
}
