import { Logger } from "@nestjs/common";
import { type EmailNotifier, maskEmail, type OtpEmailMessage } from "./email-notifier";

const RESEND_ENDPOINT = "https://api.resend.com/emails";

/**
 * Production adapter — gọi Resend REST API qua `fetch` (KHÔNG cần SDK → distroless-safe).
 * Chỉ dùng khi có `RESEND_API_KEY` (ADR-020 — free tier).
 */
export class ResendEmailNotifier implements EmailNotifier {
  private readonly logger = new Logger("EmailNotifier");

  constructor(
    private readonly apiKey: string,
    private readonly fromEmail: string
  ) {}

  async sendOtp(message: OtpEmailMessage): Promise<void> {
    const response = await fetch(RESEND_ENDPOINT, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${this.apiKey}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        from: this.fromEmail,
        to: message.email,
        subject: "Mã OTP đăng nhập Vé Xe Nhanh",
        html: `<p>Mã OTP của bạn: <strong>${message.otp}</strong></p><p>Mã hết hạn sau 5 phút. Không chia sẻ mã cho bất kỳ ai.</p>`
      })
    });

    if (!response.ok) {
      this.logger.error(
        `Resend gửi OTP thất bại cho ${maskEmail(message.email)}: HTTP ${response.status}`
      );
      throw new Error(`Resend email failed with status ${response.status}`);
    }
  }
}
