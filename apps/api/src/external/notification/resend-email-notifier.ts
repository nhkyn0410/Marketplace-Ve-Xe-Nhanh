import { Logger } from "@nestjs/common";
import {
  type EmailNotifier,
  maskEmail,
  type OperatorApplicationDecisionEmailMessage,
  type OperatorApplicationLinkEmailMessage,
  type OtpEmailMessage,
  type StopPointDecisionEmailMessage,
  type TemporaryPasswordEmailMessage,
} from "./email-notifier";

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
    await this.send(
      message.email,
      "Mã OTP đăng nhập Vé Xe Nhanh",
      `<p>Mã OTP của bạn: <strong>${escapeHtml(message.otp)}</strong></p><p>Mã hết hạn sau 5 phút. Không chia sẻ mã cho bất kỳ ai.</p>`,
      "OTP",
    );
  }

  async sendTemporaryPassword(message: TemporaryPasswordEmailMessage): Promise<void> {
    await this.send(
      message.email,
      "Tài khoản Vé Xe Nhanh của bạn",
      `<p>Tài khoản: <strong>${escapeHtml(message.loginIdentifier)}</strong></p>` +
        `<p>Mật khẩu tạm: <strong>${escapeHtml(message.temporaryPassword)}</strong></p>` +
        `<p>Mật khẩu tạm hết hạn lúc ${escapeHtml(message.expiresAt.toISOString())}. ` +
        "Bạn phải đổi mật khẩu trong lần đăng nhập đầu tiên.</p>",
      "temporary password",
    );
  }

  async sendOperatorApplicationLink(message: OperatorApplicationLinkEmailMessage): Promise<void> {
    await this.send(
      message.email,
      `Hồ sơ đăng ký nhà xe ${message.applicationCode} — Vé Xe Nhanh`,
      `<p>Hồ sơ đăng ký của nhà xe <strong>${escapeHtml(message.operatorName)}</strong> ` +
        `có mã <strong>${escapeHtml(message.applicationCode)}</strong>.</p>` +
        `<p><a href="${escapeHtml(message.link)}">Mở hồ sơ để hoàn thiện và gửi duyệt</a></p>` +
        `<p>Link chỉ mở đúng hồ sơ này và hết hạn lúc ${escapeHtml(message.expiresAt.toISOString())}. ` +
        "Không chuyển tiếp email này. Cần link mới, hãy dùng mục “Gửi lại link” với email này và mã hồ sơ.</p>",
      "operator application link",
    );
  }

  async sendOperatorApplicationDecision(message: OperatorApplicationDecisionEmailMessage): Promise<void> {
    const intro =
      `<p>Hồ sơ đăng ký của nhà xe <strong>${escapeHtml(message.operatorName)}</strong> ` +
      `(mã <strong>${escapeHtml(message.applicationCode)}</strong>)`;
    const reason = `<blockquote>${escapeHtml(message.reason)}</blockquote>`;
    if (message.decision === "NEEDS_INFO") {
      await this.send(
        message.email,
        `Hồ sơ ${message.applicationCode} cần bổ sung — Vé Xe Nhanh`,
        `${intro} cần bổ sung trước khi được duyệt:</p>${reason}` +
          (message.link
            ? `<p><a href="${escapeHtml(message.link)}">Mở hồ sơ để bổ sung và gửi duyệt lại</a></p>` +
              `<p>Link chỉ mở đúng hồ sơ này và hết hạn lúc ${escapeHtml(message.expiresAt?.toISOString() ?? "")}. ` +
              "Link cũ không còn dùng được. Không chuyển tiếp email này.</p>"
            : ""),
        "operator application needs info",
      );
      return;
    }
    await this.send(
      message.email,
      `Hồ sơ ${message.applicationCode} không được duyệt — Vé Xe Nhanh`,
      `${intro} không được duyệt. Lý do:</p>${reason}` +
        "<p>Link hồ sơ không còn dùng được. Muốn tham gia lại, hãy nộp hồ sơ mới.</p>",
      "operator application rejected",
    );
  }

  async sendStopPointDecision(message: StopPointDecisionEmailMessage): Promise<void> {
    const point = `<strong>${escapeHtml(message.stopPointName)}</strong>`;
    const reason = message.reason ? `<p>Lý do:</p><blockquote>${escapeHtml(message.reason)}</blockquote>` : "";
    const content: Record<StopPointDecisionEmailMessage["decision"], { subject: string; html: string }> = {
      PROPOSAL_APPROVED: {
        subject: `Đề xuất điểm dừng “${message.stopPointName}” đã được duyệt`,
        html:
          `<p>Đề xuất ${point} của nhà xe ${escapeHtml(message.operatorName)} đã được duyệt.</p>` +
          `<p>Điểm <strong>${escapeHtml(message.sharedName ?? message.stopPointName)}</strong> đã có trong danh mục ` +
          "dùng chung — nhà xe chọn được khi lập tuyến.</p>",
      },
      PROPOSAL_REJECTED: {
        subject: `Đề xuất điểm dừng “${message.stopPointName}” chưa được duyệt`,
        html:
          `<p>Đề xuất ${point} của nhà xe ${escapeHtml(message.operatorName)} chưa được duyệt.</p>${reason}` +
          "<p>Sửa đề xuất theo lý do trên rồi gửi lại ở mục Điểm dừng của trang quản lý nhà xe.</p>",
      },
      SUSPENDED: {
        subject: `Điểm dừng “${message.stopPointName}” bị khóa`,
        html:
          `<p>Điểm dừng ${point} của nhà xe ${escapeHtml(message.operatorName)} đã bị quản trị viên khóa.</p>${reason}` +
          "<p>Điểm bị khóa không gắn mới vào tuyến và chuyến dùng điểm này không mở bán mới. Liên hệ quản trị " +
          "nền tảng nếu cần mở lại.</p>",
      },
      UNSUSPENDED: {
        subject: `Điểm dừng “${message.stopPointName}” đã được mở khóa`,
        html:
          `<p>Điểm dừng ${point} của nhà xe ${escapeHtml(message.operatorName)} đã được mở khóa và dùng lại ` +
          "được như trước.</p>",
      },
    };
    const { subject, html } = content[message.decision];
    await this.send(message.email, `${subject} — Vé Xe Nhanh`, html, `stop point ${message.decision}`);
  }

  private async send(
    email: string,
    subject: string,
    html: string,
    kind: string,
  ): Promise<void> {
    const response = await fetch(RESEND_ENDPOINT, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${this.apiKey}`,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        from: this.fromEmail,
        to: email,
        subject,
        html,
      }),
      signal: AbortSignal.timeout(10_000)
    });

    if (!response.ok) {
      this.logger.error(
        `Resend gửi ${kind} thất bại cho ${maskEmail(email)}: HTTP ${response.status}`
      );
      throw new Error(`Resend email failed with status ${response.status}`);
    }
  }
}

function escapeHtml(value: string): string {
  return value
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");
}
