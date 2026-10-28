import type { DbTransaction } from "../database/prisma.service";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { permissionDenied } from "../iam/role/authorization.errors";
import { officeNotFound } from "./sales-office.errors";

/** Kiểm văn phòng còn hoạt động và phân công của người bán trong giao dịch tenant hiện tại. */
export async function requireCounterOffice(tx: DbTransaction, operatorId: string, actor: Pick<VerifiedAccessToken, "sub" | "role">, officeId: string, history = false): Promise<void> {
  const [office] = await tx.$queryRaw<{ id: string; active: boolean }[]>`
    SELECT id, active FROM sales_offices WHERE id = ${officeId} AND operator_id = ${operatorId} FOR SHARE`;
  if (!office || (!office.active && !(history && actor.role === "OPERATOR_OWNER"))) throw officeNotFound();
  if (actor.role === "OPERATOR_OWNER") return;
  if (actor.role !== "SALES_STAFF") throw permissionDenied();
  const [employee] = await tx.$queryRaw<{ id: string }[]>`
    SELECT e.id FROM employee_accounts e
    JOIN sales_office_assignments a ON a.employee_id = e.id AND a.operator_id = e.operator_id
    WHERE e.id = ${actor.sub} AND e.operator_id = ${operatorId} AND e.role::text = 'SALES_STAFF'
      AND e.status::text = 'ACTIVE' AND a.office_id = ${officeId} FOR SHARE OF e`;
  if (!employee) throw officeNotFound();
}
