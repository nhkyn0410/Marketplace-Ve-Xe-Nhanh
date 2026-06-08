/** DI token cho instance Better Auth (tạo qua factory ở IamModule). */
export const BETTER_AUTH = Symbol("BETTER_AUTH");

/** Role passenger (RBAC 8-role, ADR-017) — passenger không lưu ở bảng account riêng. */
export const PASSENGER_ROLE = "PASSENGER";

/** Rate limit OTP (SEC-OQ-07). */
export const OTP_COOLDOWN_SECONDS = 60;
export const OTP_MAX_PER_HOUR = 5;
export const OTP_WINDOW_SECONDS = 3600;
