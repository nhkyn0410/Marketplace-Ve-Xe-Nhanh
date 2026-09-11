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
    // Chặn tuyệt đối ở production: adapter này in OTP nguyên văn ra log → ai đọc được log là
    // chiếm được tài khoản. NotificationModule đã fail-fast khi thiếu RESEND_API_KEY, đây là
    // lớp phòng thủ thứ hai phòng khi có đường khởi tạo khác.
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier không được phép chạy ở production (OTP sẽ lộ ra log).");
    }
    // OTP nằm ở field object riêng, KHÔNG nội suy vào message: redact của Pino lọc theo path
    // trường, chuỗi đã nội suy thì không cứu được (Security §9 "không log OTP plaintext").
    this.logger.log(
      { otp: message.otp, purpose: message.purpose, email: maskEmail(message.email) },
      "[DEV] OTP sign-in"
    );
  }
}
