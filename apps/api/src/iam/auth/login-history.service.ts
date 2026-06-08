import { Injectable, Logger } from "@nestjs/common";
import { AuditService } from "../../audit/audit.service";
import type { AuthScope } from "./token.service";

export type LoginHistoryInput = {
  scope: AuthScope;
  result: "success" | "failure";
  /** account id (success) hoặc identifier đã mask (failure). */
  targetId: string;
  accountId?: string;
  role?: string;
  operatorId?: string;
  ip?: string;
  userAgent?: string;
  reason?: string;
};

/**
 * Ghi lịch sử đăng nhập (FR-IAM-09) vào Mongo audit append-only (ADR-011).
 * Audit KHÔNG được làm hỏng login (Mongo down ≠ login fail).
 */
@Injectable()
export class LoginHistoryService {
  private readonly logger = new Logger(LoginHistoryService.name);

  constructor(private readonly audit: AuditService) {}

  async record(input: LoginHistoryInput): Promise<void> {
    try {
      await this.audit.recordAuditEvent({
        actorId: input.accountId,
        actorRole: input.role,
        action: input.result === "success" ? "auth.login.success" : "auth.login.failure",
        targetType: "auth_account",
        targetId: input.targetId,
        operatorId: input.operatorId,
        after: {
          scope: input.scope,
          result: input.result,
          ...(input.ip ? { ip: input.ip } : {}),
          ...(input.userAgent ? { userAgent: input.userAgent } : {}),
          ...(input.reason ? { reason: input.reason } : {})
        }
      });
    } catch (error) {
      this.logger.error(`Ghi login history thất bại: ${String(error)}`);
    }
  }
}
