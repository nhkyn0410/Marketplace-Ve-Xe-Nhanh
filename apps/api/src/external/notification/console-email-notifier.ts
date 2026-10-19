import { Injectable, Logger } from "@nestjs/common";
import {
  type BankAccountChangeEmailMessage,
  type EmailNotifier,
  maskEmail,
  type OperatorApplicationDecisionEmailMessage,
  type OperatorApplicationLinkEmailMessage,
  type OperatorStatusEmailMessage,
  type OtpEmailMessage,
  type StopPointDecisionEmailMessage,
  type TemporaryPasswordEmailMessage,
  type VehicleImageRemovedEmailMessage,
} from "./email-notifier";

/** Dev fallback: never print OTP; configure Resend to test email delivery. */
@Injectable()
export class ConsoleEmailNotifier implements EmailNotifier {
  private readonly logger = new Logger("EmailNotifier");

  async sendOtp(message: OtpEmailMessage): Promise<void> {
    // Production requires Resend at config validation; keep a guard for direct use.
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({
      event: "auth.otp.delivery_unavailable",
      purpose: message.purpose,
      email: maskEmail(message.email)
    });
    throw new Error("OTP delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendTemporaryPassword(message: TemporaryPasswordEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({
      event: "auth.temporary_password.delivery_unavailable",
      email: maskEmail(message.email),
    });
    throw new Error("Temporary password delivery unavailable: configure RESEND_API_KEY.");
  }

  // Không in link ra log: link là chìa khóa mở hồ sơ (BR-75). E2E cấp token thẳng trong DB test.
  async sendOperatorApplicationLink(message: OperatorApplicationLinkEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({
      event: "operator_application.link.delivery_unavailable",
      email: maskEmail(message.email),
    });
    throw new Error("Operator application link delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendOperatorApplicationDecision(message: OperatorApplicationDecisionEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({
      event: "operator_application.decision.delivery_unavailable",
      decision: message.decision,
      email: maskEmail(message.email),
    });
    throw new Error("Operator application decision delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendStopPointDecision(message: StopPointDecisionEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({
      event: "stop_point.decision.delivery_unavailable",
      decision: message.decision,
      email: maskEmail(message.email),
    });
    throw new Error("Stop point decision delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendVehicleImageRemoved(message: VehicleImageRemovedEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({ event: "vehicle.image.removed.delivery_unavailable", email: maskEmail(message.email) });
    throw new Error("Vehicle image removal delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendOperatorStatusChanged(message: OperatorStatusEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({ event: "operator.status.delivery_unavailable", suspended: message.suspended, email: maskEmail(message.email) });
    throw new Error("Operator status delivery unavailable: configure RESEND_API_KEY.");
  }

  async sendBankAccountChangeDecision(message: BankAccountChangeEmailMessage): Promise<void> {
    if (process.env.NODE_ENV === "production") {
      throw new Error("ConsoleEmailNotifier is not available in production.");
    }
    this.logger.warn({ event: "operator.bank_account.delivery_unavailable", approved: message.approved, email: maskEmail(message.email) });
    throw new Error("Bank account decision delivery unavailable: configure RESEND_API_KEY.");
  }
}
