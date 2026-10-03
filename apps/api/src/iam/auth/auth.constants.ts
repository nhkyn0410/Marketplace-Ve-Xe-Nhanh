import { Role } from "../role/role";

/** DI token cho instance Better Auth (tạo qua factory ở IamModule). */
export const BETTER_AUTH = Symbol("BETTER_AUTH");

/**
 * basePath mặc định của Better Auth. Handler mount ở đây trong `main.ts`, NGOÀI prefix `/v1`:
 * thư viện tự sinh `redirectURI = {BETTER_AUTH_URL}/api/auth/callback/{provider}` cho OAuth,
 * đổi path này thì callback của provider sẽ 404. Express 5 → wildcard phải đặt tên (`{*splat}`).
 */
export const BETTER_AUTH_BASE_PATH = "/api/auth/{*splat}";

/** Role passenger (RBAC 8-role, ADR-017) — passenger không lưu ở bảng account riêng. */
export const PASSENGER_ROLE = Role.PASSENGER;

/** Rate limit OTP (SEC-OQ-07). */
export const OTP_COOLDOWN_SECONDS = 60;
export const OTP_MAX_PER_HOUR = 5;
export const OTP_WINDOW_SECONDS = 3600;

/**
 * Rate limit login credential (Security §11 "brute force login/OTP"). Mỗi lần verify chạy scrypt
 * 128 MiB kể cả khi account không tồn tại (dummy verify chống enumeration) → không giới hạn thì
 * đây vừa là kênh brute-force vừa là kênh DoS không cần xác thực.
 */
export const LOGIN_MAX_PER_IDENTIFIER_PER_HOUR = 10;
export const LOGIN_MAX_PER_IP_PER_HOUR = 30;
export const LOGIN_WINDOW_SECONDS = 3600;

/**
 * Trần số lần sai MFA của MỘT chủ thể, cộng dồn qua mọi challenge + re-auth (TASK-IAM-004, Security §11).
 * 5 lần/challenge (Q9) chưa đủ: người đã có mật khẩu login được 10 lần/giờ → 50 lần đoán TOTP/giờ, vô
 * thời hạn (~73%/năm trúng với cửa sổ ±1). Trần 20/24h → ~2%/năm. Reset khi xác thực đúng (NIST
 * 800-63B §5.2.2 "consecutive failed attempts"). Con số giả định v1 — Khanh xác nhận.
 */
export const MFA_MAX_FAILURES_PER_WINDOW = 20;
export const MFA_FAILURE_WINDOW_SECONDS = 24 * 60 * 60;

/**
 * Rate limit `/auth/refresh` theo IP (IAM-002). Client hợp lệ refresh ~4 lần/giờ/thiết bị (access 15
 * phút), nên 600/giờ chừa chỗ cho ~150 thiết bị sau cùng một NAT nhà mạng. Con số giả định v1 —
 * chỉnh khi đo được tải thật.
 */
export const REFRESH_MAX_PER_IP_PER_HOUR = 600;
/** Một family = một thiết bị đăng nhập; hợp lệ ~4 lần/giờ + vài lần mở lại app. */
export const REFRESH_MAX_PER_FAMILY_PER_HOUR = 30;
export const REFRESH_WINDOW_SECONDS = 3600;
