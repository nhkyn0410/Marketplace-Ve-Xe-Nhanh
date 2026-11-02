// Xác nhận lại danh tính trước thao tác nhạy cảm (FR-IAM-10; TASK-IAM-005 Q8): máy chủ cấp bằng chứng có hiệu
// lực 5 phút gắn với phiên hiện tại. Giao diện nhớ mốc hết hạn để không hỏi lại mật khẩu cho mỗi thao tác; máy
// chủ vẫn là nơi quyết định — bằng chứng mất sớm (vd phiên vừa được làm mới) thì trả `AUTH_REAUTH_REQUIRED`.
import { ApiError, apiRequest } from "./api-client";

/** Coi bằng chứng hết hạn sớm hơn máy chủ 30 giây, để không gửi thao tác sát mốc 5 phút. */
const PROOF_TTL_MS = 5 * 60_000 - 30_000;

let provenUntilMs = 0;

/** Còn bằng chứng xác nhận lại danh tính (theo đồng hồ của giao diện) hay phải hỏi lại. */
export function hasRecentReauth(nowMs: number = Date.now()): boolean {
  return nowMs < provenUntilMs;
}

/** Quên bằng chứng: khi đăng xuất, hoặc khi máy chủ báo bằng chứng không còn. */
export function forgetReauth(): void {
  provenUntilMs = 0;
}

/**
 * Nội dung gửi `/auth/re-auth` từ một ô nhập chung "mật khẩu hoặc mã xác thực": đúng 6 chữ số (có thể gõ cách
 * đôi `123 456`) là mã của ứng dụng xác thực, còn lại là mật khẩu. Mật khẩu dài tối thiểu 12 ký tự nên không
 * trùng dạng mã.
 */
export function toReauthBody(secret: string): { mfaCode: string } | { password: string } {
  const compact = secret.replace(/\s/g, "");
  return /^\d{6}$/.test(compact) ? { mfaCode: compact } : { password: secret };
}

/** Gửi mật khẩu / mã để lấy bằng chứng 5 phút. Sai thì ném `ApiError` 401 `AUTH_INVALID_CREDENTIALS`. */
export async function reauthenticate(secret: string, nowMs: number = Date.now()): Promise<void> {
  await apiRequest("/auth/re-auth", { method: "POST", body: toReauthBody(secret) });
  provenUntilMs = nowMs + PROOF_TTL_MS;
}

/**
 * Chạy một thao tác nhạy cảm: có `secret` thì xác nhận lại danh tính trước. Máy chủ báo thiếu bằng chứng thì
 * quên mốc đã nhớ để lần sau màn hình hỏi lại.
 */
export async function withReauth<T>(secret: string | null, action: () => Promise<T>): Promise<T> {
  if (secret !== null) {
    await reauthenticate(secret);
  }
  try {
    return await action();
  } catch (error) {
    if (isReauthRequired(error)) {
      forgetReauth();
    }
    throw error;
  }
}

/** Máy chủ đòi xác nhận lại danh tính trước khi làm thao tác này. */
export function isReauthRequired(error: unknown): boolean {
  return error instanceof ApiError && error.code === "AUTH_REAUTH_REQUIRED";
}

/** Câu báo tại ô "mật khẩu hoặc mã xác thực"; `null` nếu lỗi không thuộc bước xác nhận lại danh tính. */
export function describeReauthError(error: unknown): string | null {
  if (!(error instanceof ApiError)) {
    return null;
  }
  switch (error.code) {
    case "AUTH_INVALID_CREDENTIALS":
      return "Mật khẩu hoặc mã xác thực không đúng.";
    case "AUTH_REAUTH_REQUIRED":
      return "Cần xác nhận lại danh tính để tiếp tục.";
    case "AUTH_OTP_RATE_LIMITED":
      return "Bạn đã thử quá nhiều lần. Vui lòng thử lại sau ít phút.";
    default:
      return null;
  }
}
