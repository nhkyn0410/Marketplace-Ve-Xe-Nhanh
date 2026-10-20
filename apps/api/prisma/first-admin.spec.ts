import { describe, expect, it, vi } from "vitest";
import { CredentialService } from "../src/iam/auth/credential.service";
import { createFirstPlatformAdmin, FIRST_ADMIN_PASSWORD_TTL_MS, FirstAdminRefusedError } from "./first-admin";

/** DB giả: `$transaction` chạy callback với `tx` giả; ghi lại thứ tự lệnh. */
type Existing = { id: string; username: string; contactEmail: string; role: string; status: string; passwordChangeRequired: boolean } | null;

function fakeDb(state: { activeAdmins: number; existing: Existing }) {
  const calls: string[] = [];
  const tx = {
    $executeRaw: vi.fn(async () => void calls.push("lock")),
    platformAccount: {
      count: vi.fn(async () => (calls.push("count"), state.activeAdmins)),
      findFirst: vi.fn(async () => (calls.push("findFirst"), state.existing)),
      create: vi.fn(async ({ data }: { data: { username: string } }) => (calls.push("create"), { id: "acc-1", username: data.username })),
      update: vi.fn(async () => (calls.push("update"), { id: state.existing!.id, username: state.existing!.username })),
    },
  };
  const prisma = { $transaction: vi.fn(async (fn: (t: typeof tx) => unknown) => fn(tx)) };
  return { prisma: prisma as never, tx, calls };
}

describe("Tạo quản trị viên đầu tiên", () => {
  const now = new Date("2026-10-20T03:00:00Z");

  it("DB chưa có quản trị viên → tạo PLATFORM_ADMIN bắt đổi mật khẩu, mật khẩu tạm khớp hash, hết hạn 24 giờ, audit trong transaction", async () => {
    const { prisma, tx, calls } = fakeDb({ activeAdmins: 0, existing: null });
    const audit = { recordAuditEvent: vi.fn(async () => undefined) };
    const result = await createFirstPlatformAdmin(prisma, audit, { username: " Khanh ", email: "Khanh@VeXeNhanh.id.vn" }, now);

    expect(calls).toEqual(["lock", "count", "findFirst", "create"]);
    expect(tx.platformAccount.count).toHaveBeenCalledWith({
      where: { role: "PLATFORM_ADMIN", status: "ACTIVE", NOT: { passwordChangeRequired: true, temporaryPasswordExpiresAt: { lte: now } } },
    });
    const data = (tx.platformAccount.create.mock.calls[0] as unknown as [{ data: Record<string, unknown> }])[0].data;
    expect(data).toMatchObject({ username: "khanh", contactEmail: "khanh@vexenhanh.id.vn", role: "PLATFORM_ADMIN", passwordChangeRequired: true });
    expect(data.temporaryPasswordExpiresAt).toEqual(new Date(now.getTime() + FIRST_ADMIN_PASSWORD_TTL_MS));
    expect(await new CredentialService().verify(result.temporaryPassword, data.passwordHash as string)).toBe(true);
    expect(result.temporaryPassword).toMatch(/^[A-Za-z0-9_-]{32}$/);
    expect(result).toMatchObject({ id: "acc-1", username: "khanh", reissued: false });
    expect(audit.recordAuditEvent).toHaveBeenCalledWith(
      expect.objectContaining({ action: "iam.platform_account.bootstrap", targetType: "platform_account", targetId: "acc-1", after: { username: "khanh", email: "k***@vexenhanh.id.vn", role: "PLATFORM_ADMIN" } }),
      { timeoutMs: 5_000 },
    );
    // Không lộ mật khẩu tạm vào audit.
    expect(JSON.stringify(audit.recordAuditEvent.mock.calls)).not.toContain(result.temporaryPassword);
  }, 30_000);

  it("đã có quản trị viên dùng được / trùng tên hoặc email của tài khoản khác → từ chối, không tạo, không audit", async () => {
    const other = { id: "x", username: "khanh", contactEmail: "khac@vexenhanh.id.vn", role: "PLATFORM_ADMIN", status: "ACTIVE", passwordChangeRequired: true };
    for (const state of [
      { activeAdmins: 1, existing: null },
      { activeAdmins: 0, existing: other },
      { activeAdmins: 0, existing: { ...other, contactEmail: "k@vexenhanh.id.vn", passwordChangeRequired: false } },
      { activeAdmins: 0, existing: { ...other, contactEmail: "k@vexenhanh.id.vn", status: "LOCKED" } },
    ]) {
      const { prisma, tx } = fakeDb(state);
      const audit = { recordAuditEvent: vi.fn(async () => undefined) };
      await expect(createFirstPlatformAdmin(prisma, audit, { username: "khanh", email: "k@vexenhanh.id.vn" }, now)).rejects.toBeInstanceOf(FirstAdminRefusedError);
      expect(tx.platformAccount.create).not.toHaveBeenCalled();
      expect(tx.platformAccount.update).not.toHaveBeenCalled();
      expect(audit.recordAuditEvent).not.toHaveBeenCalled();
    }
  }, 30_000);

  it("quản trị viên đầu tiên chưa kích hoạt, mật khẩu tạm hết hạn → chạy lại đúng tên + email cấp mật khẩu tạm mới", async () => {
    const stuck = { id: "acc-1", username: "khanh", contactEmail: "k@vexenhanh.id.vn", role: "PLATFORM_ADMIN", status: "ACTIVE", passwordChangeRequired: true };
    const { prisma, tx, calls } = fakeDb({ activeAdmins: 0, existing: stuck });
    const audit = { recordAuditEvent: vi.fn(async () => undefined) };
    const result = await createFirstPlatformAdmin(prisma, audit, { username: "khanh", email: "k@vexenhanh.id.vn" }, now);
    expect(calls).toEqual(["lock", "count", "findFirst", "update"]);
    expect(result).toMatchObject({ id: "acc-1", reissued: true });
    const data = (tx.platformAccount.update.mock.calls[0] as unknown as [{ data: Record<string, unknown> }])[0].data;
    expect(data.temporaryPasswordExpiresAt).toEqual(new Date(now.getTime() + FIRST_ADMIN_PASSWORD_TTL_MS));
    expect(await new CredentialService().verify(result.temporaryPassword, data.passwordHash as string)).toBe(true);
    expect(audit.recordAuditEvent).toHaveBeenCalledWith(expect.objectContaining({ action: "iam.platform_account.bootstrap_reissue", targetId: "acc-1" }), { timeoutMs: 5_000 });
  }, 30_000);

  it("tên đăng nhập / email sai → từ chối trước khi đụng DB; audit lỗi → lỗi lan ra (transaction thật rollback)", async () => {
    const { prisma } = fakeDb({ activeAdmins: 0, existing: null });
    const audit = { recordAuditEvent: vi.fn(async () => undefined) };
    for (const input of [
      { username: "kh", email: "k@vexenhanh.id.vn" },
      { username: "khanh!", email: "k@vexenhanh.id.vn" },
      { username: "khanh", email: "khong-phai-email" },
    ]) {
      await expect(createFirstPlatformAdmin(prisma, audit, input, now)).rejects.toBeInstanceOf(FirstAdminRefusedError);
    }
    expect((prisma as unknown as { $transaction: ReturnType<typeof vi.fn> }).$transaction).not.toHaveBeenCalled();

    const failing = { recordAuditEvent: vi.fn(async () => Promise.reject(new Error("Mongo down"))) };
    await expect(createFirstPlatformAdmin(fakeDb({ activeAdmins: 0, existing: null }).prisma, failing, { username: "khanh", email: "k@vexenhanh.id.vn" }, now)).rejects.toThrow(
      "Mongo down",
    );
  }, 30_000);
});
