import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { DatabaseModule } from "../database/database.module";
import { PrismaService } from "../database/prisma.service";
import { EMAIL_NOTIFIER, type EmailNotifier } from "../external/notification/email-notifier";
import { NotificationModule } from "../external/notification/notification.module";
import { RedisModule } from "../redis/redis.module";
import { createAuth } from "./auth/auth.config";
import { BETTER_AUTH } from "./auth/auth.constants";
import { AuthController } from "./auth/auth.controller";
import { AuthService } from "./auth/auth.service";
import { CredentialService } from "./auth/credential.service";
import { LoginHistoryService } from "./auth/login-history.service";
import { OtpRateLimiter } from "./auth/otp-rate-limiter";
import { TokenService } from "./auth/token.service";

/** TASK-IAM-001 — Better Auth + login 3-namespace (DOMAIN-MAP `iam/auth`). */
@Module({
  imports: [DatabaseModule, AuditModule, RedisModule, NotificationModule],
  controllers: [AuthController],
  providers: [
    {
      provide: BETTER_AUTH,
      inject: [PrismaService, APP_CONFIG, EMAIL_NOTIFIER],
      useFactory: (prisma: PrismaService, config: AppConfig, notifier: EmailNotifier) =>
        createAuth(prisma, config, notifier)
    },
    TokenService,
    CredentialService,
    OtpRateLimiter,
    LoginHistoryService,
    AuthService
  ],
  exports: [BETTER_AUTH, TokenService]
})
export class IamModule {}
