import { Module } from "@nestjs/common";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { ConsoleEmailNotifier } from "./console-email-notifier";
import { EMAIL_NOTIFIER, type EmailNotifier } from "./email-notifier";
import { ResendEmailNotifier } from "./resend-email-notifier";

/**
 * Chọn adapter EmailNotifier theo config: có RESEND_API_KEY → Resend; ngược lại → console (dev).
 */
@Module({
  providers: [
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
  exports: [EMAIL_NOTIFIER]
})
export class NotificationModule {}
