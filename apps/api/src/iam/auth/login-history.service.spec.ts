import { describe, expect, it, vi } from "vitest";
import type { AuditService } from "../../audit/audit.service";
import { LoginHistoryService } from "./login-history.service";

function setup() {
  const recordAuditEvent = vi.fn().mockResolvedValue(undefined);
  const audit = { recordAuditEvent } as unknown as AuditService;
  return { recordAuditEvent, service: new LoginHistoryService(audit) };
}

/** FR-IAM-09 — login history ghi vào Mongo audit append-only (ADR-011). */
describe("LoginHistoryService", () => {
  it("ghi sự kiện đăng nhập thành công kèm actor, tenant và ngữ cảnh request", async () => {
    const { recordAuditEvent, service } = setup();

    await service.record({
      scope: "operator",
      result: "success",
      targetId: "acc-1",
      accountId: "acc-1",
      role: "OPERATOR_OWNER",
      operatorId: "op-1",
      ip: "1.2.3.4",
      userAgent: "vitest"
    });

    expect(recordAuditEvent).toHaveBeenCalledWith({
      actorId: "acc-1",
      actorRole: "OPERATOR_OWNER",
      action: "auth.login.success",
      targetType: "auth_account",
      targetId: "acc-1",
      operatorId: "op-1",
      after: { scope: "operator", result: "success", ip: "1.2.3.4", userAgent: "vitest" }
    });
  });

  it("dùng action riêng cho lần đăng nhập thất bại và giữ lý do", async () => {
    const { recordAuditEvent, service } = setup();

    await service.record({
      scope: "platform",
      result: "failure",
      targetId: "platform/kh***",
      reason: "invalid_password"
    });

    expect(recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "auth.login.failure",
        targetId: "platform/kh***",
        after: expect.objectContaining({ result: "failure", reason: "invalid_password" })
      })
    );
  });

  it("không gắn field ngữ cảnh rỗng vào bản ghi audit", async () => {
    const { recordAuditEvent, service } = setup();

    await service.record({ scope: "passenger", result: "success", targetId: "u-1" });

    const event = recordAuditEvent.mock.calls[0][0] as { after: Record<string, unknown> };
    expect(event.after).toEqual({ scope: "passenger", result: "success" });
    expect(event.after).not.toHaveProperty("ip");
    expect(event.after).not.toHaveProperty("userAgent");
    expect(event.after).not.toHaveProperty("reason");
  });

  it("audit hỏng KHÔNG được làm hỏng login — nuốt lỗi thay vì ném ra", async () => {
    const recordAuditEvent = vi.fn().mockRejectedValue(new Error("Mongo down"));
    const audit = { recordAuditEvent } as unknown as AuditService;
    const service = new LoginHistoryService(audit);

    await expect(
      service.record({ scope: "passenger", result: "success", targetId: "u-1" })
    ).resolves.toBeUndefined();
    expect(recordAuditEvent).toHaveBeenCalledOnce();
  });
});
