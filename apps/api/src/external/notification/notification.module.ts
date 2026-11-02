import { Module } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { ConsoleEmailNotifier } from "./console-email-notifier";
import { EMAIL_NOTIFIER, type EmailNotifier } from "./email-notifier";
import { ResendEmailNotifier } from "./resend-email-notifier";
import { PUSH_NOTIFIER, ServerPushNotifier } from "./push/push-notifier";
import { JOURNEY_DEMO_PUSH, FcmJourneyDemoPush } from "./push/journey-demo-push";

/**
 * Chọn adapter EmailNotifier theo config: có RESEND_API_KEY → Resend; ngược lại → dev fallback không gửi OTP.
 */
@Module({
  providers: [
    { provide: JOURNEY_DEMO_PUSH, inject: [APP_CONFIG], useFactory: (config: AppConfig) => new FcmJourneyDemoPush(config) },
    { provide: PUSH_NOTIFIER, inject: [APP_CONFIG], useFactory: (config: AppConfig) => new ServerPushNotifier(config) },
    ConsoleEmailNotifier,
    {
      provide: EMAIL_NOTIFIER,
      inject: [APP_CONFIG, ConsoleEmailNotifier],
      useFactory: (config: AppConfig, consoleNotifier: ConsoleEmailNotifier): EmailNotifier => {
        if (config.RESEND_API_KEY) {
          return new ResendEmailNotifier(config.RESEND_API_KEY, config.RESEND_FROM_EMAIL);
        }
        return consoleNotifier;
      }
    }
  ],
  exports: [EMAIL_NOTIFIER, PUSH_NOTIFIER, JOURNEY_DEMO_PUSH]
})
export class NotificationModule {}
