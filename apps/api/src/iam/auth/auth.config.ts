import type { AppConfig } from "../../config/env.config";
import type { PrismaService } from "../../database/prisma.service";
import type { EmailNotifier } from "../../external/notification/email-notifier";

/**
 * Tạo instance Better Auth (ADR-017). Better Auth là ESM-only → phải dynamic `import()`
 * (module=Node16 giữ import động ở runtime). Quản lý Passenger: email-OTP + OAuth + account-linking.
 * Operator/Platform KHÔNG qua Better Auth (custom, Account-separate). Token = ta tự mint
 * (TokenService) → KHÔNG dùng JWT-plugin/`jwks` của Better Auth (headless).
 */
export async function createAuth(
  prisma: PrismaService,
  config: AppConfig,
  emailNotifier: EmailNotifier
) {
  const { betterAuth } = await import("better-auth");
  const { prismaAdapter } = await import("better-auth/adapters/prisma");
  const { emailOTP } = await import("better-auth/plugins");

  // v1 chỉ wire Google (Khanh chốt 09/09/2026): v1 không phát hành store nên App Store Guideline
  // 4.8 không ép Apple Sign-In nữa; Facebook cần app review, Apple cần cert — chi phí thuần cho
  // một sản phẩm phục vụ môn học. Facebook + Apple defer v1.x (ADR-020 giữ nguyên định hướng).
  const socialProviders: { google?: { clientId: string; clientSecret: string } } = {};
  if (config.GOOGLE_CLIENT_ID && config.GOOGLE_CLIENT_SECRET) {
    socialProviders.google = {
      clientId: config.GOOGLE_CLIENT_ID,
      clientSecret: config.GOOGLE_CLIENT_SECRET
    };
  }

  return betterAuth({
    secret: config.BETTER_AUTH_SECRET ?? "dev-insecure-better-auth-secret-change-me",
    baseURL: config.BETTER_AUTH_URL,
    database: prismaAdapter(prisma, { provider: "postgresql" }),
    // Lớp phòng thủ thứ hai chống open redirect sau xác thực. KHÔNG đủ một mình: middleware
    // origin-check của Better Auth thoát sớm khi không có `ctx.request` (gọi server-side qua
    // `auth.api.*`) → allowlist ở AuthService mới là lớp thực sự chặn.
    trustedOrigins: config.AUTH_ALLOWED_CALLBACK_ORIGINS,
    account: {
      accountLinking: {
        enabled: true,
        trustedProviders: ["google"],
        allowDifferentEmails: false
      }
    },
    socialProviders,
    plugins: [
      emailOTP({
        otpLength: 6,
        expiresIn: 300,
        allowedAttempts: 3,
        overrideDefaultEmailVerification: true,
        async sendVerificationOTP({ email, otp, type }) {
          await emailNotifier.sendOtp({ email, otp, purpose: type });
        }
      })
    ]
  });
}

export type Auth = Awaited<ReturnType<typeof createAuth>>;
