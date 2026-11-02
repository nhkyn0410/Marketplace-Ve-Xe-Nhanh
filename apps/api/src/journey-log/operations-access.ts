import { HttpException, HttpStatus } from "@nestjs/common";
import type { DbScope } from "../database/db-scope";
import type { DbTransaction } from "../database/prisma.service";
import type { Authorization } from "../iam/role/authorization";
import { requireAssignedTenant, requireTenant } from "../iam/role/require-tenant";

/** Lỗi vận hành theo RFC 7807. */
export function operationsError(status: HttpStatus, code: string, detail: string): HttpException {
  return new HttpException({ title: "Operations error", code, detail }, status);
}

/** Đòi chuyến đang vận hành và phân công còn hiệu lực cho người gửi. */
export async function assignedActiveTrip(tx: DbTransaction, operatorId: string, employeeId: string, tripId: string): Promise<void> {
  const [trip] = await tx.$queryRaw<{ status: string }[]>`SELECT status::text AS status FROM trips WHERE id = ${tripId} AND operator_id = ${operatorId} FOR SHARE`;
  const assignment = await tx.employeeAssignment.findFirst({ where: { tripId, operatorId, employeeId }, select: { id: true } });
  if (!trip || !assignment) throw operationsError(HttpStatus.NOT_FOUND, "ASSIGNMENT_NOT_FOUND", "Không tìm thấy chuyến được phân công cho bạn.");
  if (!["BOARDING", "DEPARTED", "IN_PROGRESS", "INCIDENT"].includes(trip.status)) throw operationsError(HttpStatus.CONFLICT, "TRIP_OPERATION_INVALID", "Chỉ ghi nhận trên chuyến đang vận hành.");
}

/** Ngữ cảnh đọc: nhân viên xem chuyến được giao, nhà xe xem tenant, nền tảng giám sát toàn hệ thống. */
export function operationsReadScope(authz: Authorization): { db: DbScope; operatorId?: string } {
  if (authz.scope === "assigned") return requireAssignedTenant(authz);
  if (authz.scope === "tenant") return requireTenant(authz);
  if (authz.db?.kind === "platform") return { db: authz.db };
  throw operationsError(HttpStatus.FORBIDDEN, "PERMISSION_DENIED", "Bạn không có quyền xem dữ liệu vận hành.");
}

/** Danh sách chuyến nhân viên được phép xem trong bộ lọc hiện tại. */
export async function assignedTripIds(tx: DbTransaction, operatorId: string, employeeId: string, tripId?: string): Promise<string[]> {
  const rows = await tx.employeeAssignment.findMany({ where: { operatorId, employeeId, ...(tripId ? { tripId } : {}) }, select: { tripId: true } });
  return rows.map((row) => row.tripId);
}
