import { Injectable, Logger } from "@nestjs/common";
import { type EmailNotifier, maskEmail, type OtpEmailMessage } from "./email-notifier";

/**
 * Dev adapter — log OTP ra console (KHÔNG gửi email thật). Cho phép test luồng
 * OTP end-to-end mà chưa cần Resend credential.
 */
@Injectable()
export class ConsoleEmailNotifier implements EmailNotifier {
  private readonly logger = new Logger("EmailNotifier");

  async sendOtp(message: OtpEmailMessage): Promise<void> {
    this.logger.log(
      `[DEV] OTP ${message.purpose} cho ${maskEmail(message.email)}: ${message.otp}`
    );
  }
}
