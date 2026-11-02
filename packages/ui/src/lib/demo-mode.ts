// Môi trường demo (OQ-21, Khanh 20/10/2026): production hiện chỉ dùng dữ liệu mẫu — giấy tờ / minh chứng lưu kho riêng tư
// đặt ngoài Việt Nam. Mỗi app web tự khai `NEXT_PUBLIC_DEMO_MODE=true`; bỏ trống / khác `true` → không phải demo.

/** Đọc lúc gọi (Next thay `process.env.NEXT_PUBLIC_*` khi build; test đổi được bằng `vi.stubEnv`). */
export function isDemoMode(): boolean {
  return process.env.NEXT_PUBLIC_DEMO_MODE?.trim() === "true";
}
