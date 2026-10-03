import { beforeAll, describe, expect, it } from "vitest";
import type { AppConfig } from "../../config/env.config";
import type { PrismaService } from "../../database/prisma.service";
import type { EmailNotifier } from "../../external/notification/email-notifier";
import { createAuth } from "./auth.config";

const notifier: EmailNotifier = { sendOtp: async () => undefined };

function makeConfig(overrides: Partial<AppConfig> = {}): AppConfig {
  return {
    NODE_ENV: "test",
    BETTER_AUTH_SECRET: "test-secret-do-not-use",
    BETTER_AUTH_URL: "http://localhost:3000",
    AUTH_ALLOWED_CALLBACK_ORIGINS: ["http://localhost:3000", "vexenhanh://"],
    ...overrides,
  } as AppConfig;
}

/**
 * SEC-OQ-08 + ADR-020 sống dưới dạng **cấu hình**, không có code path riêng để test — nghĩa là
 * sửa nhầm một dòng ở đây không làm test nào đỏ. Các assert dưới đây khoá chính sách đã chốt.
 */
describe("createAuth (SEC-OQ-08 account linking + provider v1)", () => {
  let auth: Awaited<ReturnType<typeof createAuth>>;

  // better-auth là ESM-only → lần `import()` đầu tiên tốn vài giây; trả một lần ở đây.
  beforeAll(async () => {
    auth = await createAuth({} as PrismaService, makeConfig(), notifier);
  }, 30_000);

  it("chỉ link account khi email trùng và provider đáng tin - không cho email khác nhau", () => {
    expect(auth.options.account?.accountLinking).toMatchObject({
      enabled: true,
      trustedProviders: ["google"],
      allowDifferentEmails: false,
    });
  });

  it("v1 chỉ bật Google — Facebook/Apple không được wire dù có credential trong env", async () => {
    const auth = await createAuth(
      {} as PrismaService,
      makeConfig({
        GOOGLE_CLIENT_ID: "gid",
        GOOGLE_CLIENT_SECRET: "gsecret",
        FACEBOOK_CLIENT_ID: "fid",
        FACEBOOK_CLIENT_SECRET: "fsecret",
        APPLE_CLIENT_ID: "aid",
        APPLE_CLIENT_SECRET: "asecret",
      }),
      notifier,
    );

    expect(Object.keys(auth.options.socialProviders ?? {})).toEqual(["google"]);
  });

  it("truyền allowlist callback xuống trustedOrigins (lớp phòng thủ thứ hai chống open redirect)", () => {
    expect(auth.options.trustedOrigins).toEqual([
      "http://localhost:3000",
      "vexenhanh://",
    ]);
  });

  it("plugin email-OTP được nạp (SEC-OQ-07)", () => {
    const otpPlugin = auth.options.plugins?.find(
      (plugin) => plugin.id === "email-otp",
    );

    expect(otpPlugin).toBeDefined();
  });
});
