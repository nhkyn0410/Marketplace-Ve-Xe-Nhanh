import { randomBytes } from "node:crypto";
import type { AuditService } from "../src/audit/audit.service";
import { maskEmail } from "../src/external/notification/email-notifier";
import type { PrismaClient } from "../src/generated/prisma/client";
import { CredentialService } from "../src/iam/auth/credential.service";
import { PlatformAccountCreateSchema } from "../src/iam/user/dto/admin-user.dto";

/** Như mật khẩu tạm khi Admin tạo tài khoản trên giao diện (`TEMPORARY_PASSWORD_TTL_MS`). */
export const FIRST_ADMIN_PASSWORD_TTL_MS = 24 * 60 * 60 * 1000;
const AUDIT_TIMEOUT_MS = 5_000;
const InputSchema = PlatformAccountCreateSchema.pick({ username: true, email: true });

export type FirstAdminResult = { id: string; username: string; temporaryPassword: string; expiresAt: Date; reissued: boolean };

/** Lý do từ chối có chủ đích (không phải lỗi hệ thống) — lệnh chạy in thông báo, không in stack. */
export class FirstAdminRefusedError extends Error {}

/**
 * Tạo tài khoản quản trị nền tảng ĐẦU TIÊN cho một DB chưa có quản trị viên dùng được (production mới dựng — `db:seed` bị
 * chặn ở production). Có quản trị viên dùng được → từ chối: thêm người qua Admin → Người dùng → Tài khoản quản trị.
 * "Dùng được" = PLATFORM_ADMIN đang hoạt động, trừ tài khoản chưa từng đổi mật khẩu tạm mà mật khẩu tạm đã hết hạn. Chạy lại
 * với đúng tên + email của tài khoản kẹt đó → cấp mật khẩu tạm mới (không ai khác cấp lại được); ngoài ra không sửa tài khoản
 * đã có. Mật khẩu tạm ngẫu nhiên, hết hạn 24 giờ, bắt đổi mật khẩu + bật TOTP ở lần đăng nhập đầu như tài khoản do Admin tạo.
 * Audit ghi trong cùng transaction — Mongo lỗi thì không đổi gì.
 */
export async function createFirstPlatformAdmin(
  prisma: Pick<PrismaClient, "$transaction">,
  audit: Pick<AuditService, "recordAuditEvent">,
  raw: { username: string; email: string },
  now: Date = new Date(),
): Promise<FirstAdminResult> {
  const parsed = InputSchema.safeParse(raw);
  if (!parsed.success) {
    throw new FirstAdminRefusedError(parsed.error.issues.map((issue) => `${issue.path.join(".")}: ${issue.message}`).join("; "));
  }
  const { username, email } = parsed.data;
  const expiresAt = new Date(now.getTime() + FIRST_ADMIN_PASSWORD_TTL_MS);
  return prisma.$transaction(
    async (tx) => {
      // Hai lần chạy cùng lúc: lần sau chờ khóa rồi thấy đã có quản trị viên.
      await tx.$executeRaw`SELECT pg_advisory_xact_lock(hashtext('vexenhanh:first-platform-admin'))`;
      const usable = await tx.platformAccount.count({
        where: {
          role: "PLATFORM_ADMIN",
          status: "ACTIVE",
          NOT: { passwordChangeRequired: true, temporaryPasswordExpiresAt: { lte: now } },
        },
      });
      if (usable > 0) {
        throw new FirstAdminRefusedError("Đã có quản trị viên dùng được — thêm tài khoản qua Admin → Người dùng → Tài khoản quản trị.");
      }
      const existing = await tx.platformAccount.findFirst({
        where: { OR: [{ username }, { contactEmail: email }] },
        select: { id: true, username: true, contactEmail: true, role: true, status: true, passwordChangeRequired: true },
      });
      if (existing) {
        const stuck =
          existing.username === username &&
          existing.contactEmail === email &&
          existing.role === "PLATFORM_ADMIN" &&
          existing.status === "ACTIVE" &&
          existing.passwordChangeRequired;
        if (!stuck) {
          throw new FirstAdminRefusedError("Tên đăng nhập hoặc email đã thuộc một tài khoản quản trị khác — script không sửa tài khoản đã có.");
        }
      }
      // Băm sau khi qua mọi điều kiện (scrypt tốn CPU): lần chạy bị từ chối không băm. Chỉ giữ khóa tư vấn, không khóa dòng.
      // Cùng độ mạnh với mật khẩu tạm do Admin cấp (192 bit, base64url).
      const temporaryPassword = randomBytes(24).toString("base64url");
      const passwordHash = await new CredentialService().hash(temporaryPassword);
      const row = existing
        ? await tx.platformAccount.update({
            where: { id: existing.id },
            data: { passwordHash, temporaryPasswordExpiresAt: expiresAt, authEpoch: { increment: 1 } },
            select: { id: true, username: true },
          })
        : await tx.platformAccount.create({
            data: { username, contactEmail: email, role: "PLATFORM_ADMIN", passwordHash, passwordChangeRequired: true, temporaryPasswordExpiresAt: expiresAt },
            select: { id: true, username: true },
          });
      await audit.recordAuditEvent(
        {
          actorRole: "SYSTEM",
          action: existing ? "iam.platform_account.bootstrap_reissue" : "iam.platform_account.bootstrap",
          targetType: "platform_account",
          targetId: row.id,
          after: { username: row.username, email: maskEmail(email), role: "PLATFORM_ADMIN" },
          reason: existing ? "Cấp lại mật khẩu tạm cho quản trị viên đầu tiên chưa kích hoạt (mật khẩu tạm đã hết hạn)." : "Tạo quản trị viên đầu tiên bằng script vận hành.",
        },
        { timeoutMs: AUDIT_TIMEOUT_MS },
      );
      return { id: row.id, username: row.username, temporaryPassword, expiresAt, reissued: Boolean(existing) };
    },
    { timeout: 20_000 },
  );
}
