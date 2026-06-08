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

  const socialProviders: {
    google?: { clientId: string; clientSecret: string };
    facebook?: { clientId: string; clientSecret: string };
    apple?: { clientId: string; clientSecret: string };
  } = {};
  if (config.GOOGLE_CLIENT_ID && config.GOOGLE_CLIENT_SECRET) {
    socialProviders.google = {
      clientId: config.GOOGLE_CLIENT_ID,
      clientSecret: config.GOOGLE_CLIENT_SECRET
    };
  }
  if (config.FACEBOOK_CLIENT_ID && config.FACEBOOK_CLIENT_SECRET) {
    socialProviders.facebook = {
      clientId: config.FACEBOOK_CLIENT_ID,
      clientSecret: config.FACEBOOK_CLIENT_SECRET
    };
  }
  if (config.APPLE_CLIENT_ID && config.APPLE_CLIENT_SECRET) {
    socialProviders.apple = {
      clientId: config.APPLE_CLIENT_ID,
      clientSecret: config.APPLE_CLIENT_SECRET
    };
  }

  return betterAuth({
    secret: config.BETTER_AUTH_SECRET ?? "dev-insecure-better-auth-secret-change-me",
    baseURL: config.BETTER_AUTH_URL,
    database: prismaAdapter(prisma, { provider: "postgresql" }),
    account: {
      accountLinking: {
        enabled: true,
        trustedProviders: ["google", "apple"],
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
