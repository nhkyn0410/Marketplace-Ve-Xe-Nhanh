/**
 * Port gửi email (adapter pattern — ADR-006/020). Domain service chỉ phụ thuộc
 * interface này; KHÔNG import SDK vendor trực tiếp (LLD-PRIN-07).
 * Phạm vi IAM-001: gửi OTP. Notification đầy đủ (push/sms) = layer riêng sau.
 */
export const EMAIL_NOTIFIER = Symbol("EMAIL_NOTIFIER");

export type OtpEmailMessage = {
  email: string;
  otp: string;
  /** "sign-in" | "email-verification" | "forget-password" (Better Auth email-OTP type). */
  purpose: string;
};

export type TemporaryPasswordEmailMessage = {
  email: string;
  /** Plaintext secret chỉ tồn tại trong memory để gửi đúng một lần; caller không được log/lưu. */
  temporaryPassword: string;
  loginIdentifier: string;
  expiresAt: Date;
};

/** Link bảo mật của hồ sơ đăng ký nhà xe (BR-75, TASK-OPR-001). */
export type OperatorApplicationLinkEmailMessage = {
  email: string;
  applicationCode: string;
  operatorName: string;
  /** Link chứa token — chỉ tồn tại trong memory để gửi đúng một lần; caller không được log/lưu. */
  link: string;
  expiresAt: Date;
};

/** Kết quả duyệt hồ sơ đăng ký nhà xe gửi người nộp (NTF-15, UC-10 A4 / A5). Duyệt dùng email mật khẩu tạm. */
export type OperatorApplicationDecisionEmailMessage = {
  email: string;
  applicationCode: string;
  operatorName: string;
  decision: "NEEDS_INFO" | "REJECTED";
  /** Nội dung cần bổ sung / lý do từ chối do Admin nhập. */
  reason: string;
  /** Chỉ khi `NEEDS_INFO`: link mới để bổ sung hồ sơ — chỉ tồn tại trong memory, caller không được log/lưu. */
  link?: string;
  expiresAt?: Date;
};

/** Quyết định của Admin về điểm dừng của nhà xe, gửi chủ nhà xe (LLD §6.13 bước 3, 6; TASK-ADM-004). */
export type StopPointDecisionEmailMessage = {
  email: string;
  operatorName: string;
  /** Tên điểm như nhà xe biết (tên đề xuất / tên điểm riêng). */
  stopPointName: string;
  decision: "PROPOSAL_APPROVED" | "PROPOSAL_REJECTED" | "SUSPENDED" | "UNSUSPENDED";
  /** Lý do từ chối / khóa. */
  reason?: string;
  /** Tên điểm dùng chung Admin đặt khi duyệt (có thể khác tên đề xuất). */
  sharedName?: string;
};

export interface EmailNotifier {
  sendOtp(message: OtpEmailMessage): Promise<void>;
  /** Optional trong port để adapter/mocks OTP legacy không giả vờ hỗ trợ enrollment. */
  sendTemporaryPassword?(message: TemporaryPasswordEmailMessage): Promise<void>;
  sendOperatorApplicationLink?(message: OperatorApplicationLinkEmailMessage): Promise<void>;
  sendOperatorApplicationDecision?(message: OperatorApplicationDecisionEmailMessage): Promise<void>;
  sendStopPointDecision?(message: StopPointDecisionEmailMessage): Promise<void>;
}

/** Mask email cho log/audit — không lộ địa chỉ đầy đủ (Security §9). */
export function maskEmail(email: string): string {
  const [local, domain] = email.split("@");
  if (!domain || !local) {
    return "***";
  }
  const head = local.slice(0, 1);
  return `${head}***@${domain}`;
}
