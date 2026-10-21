import { cookies, headers } from "next/headers";
import { unstable_rethrow } from "next/navigation";
import { z } from "zod";
import type { components } from "@vexenhanh/api-client";
import { ACCESS_COOKIE, REFRESH_COOKIE } from "./api";
import { failed, ok, type DataResult } from "./result";

export type TokenPair = components["schemas"]["AuthTokenResponseDto_Output"];
const refreshes = new Map<string, { expiresAt: number; result: Promise<DataResult<TokenPair>> }>();

/** Lưu cặp token vào cookie riêng của web; chỉ gọi từ Server Action. */
export async function saveSession(tokens: TokenPair): Promise<void> {
  const store = await cookies();
  const options = { httpOnly: true, secure: process.env.NODE_ENV === "production", sameSite: "lax" as const, path: "/" };
  store.set(ACCESS_COOKIE, tokens.accessToken, { ...options, maxAge: tokens.expiresIn });
  store.set(REFRESH_COOKIE, tokens.refreshToken, { ...options, maxAge: tokens.refreshExpiresIn });
}

/** Xóa phiên phía web khi đăng xuất hoặc refresh token hết hiệu lực. */
export async function clearSession(): Promise<void> {
  const store = await cookies();
  store.delete(ACCESS_COOKIE);
  store.delete(REFRESH_COOKIE);
}

/** Xoay refresh token một lần; các request đồng thời trong cùng process dùng chung kết quả. */
export async function refreshSessionIfNeeded(): Promise<DataResult<{ rotated: boolean }>> {
  const store = await cookies();
  if (store.get(ACCESS_COOKIE)?.value) return ok({ rotated: false });
  const refreshToken = store.get(REFRESH_COOKIE)?.value;
  if (!refreshToken) return ok({ rotated: false });
  for (const [key, value] of refreshes) if (value.expiresAt < Date.now()) refreshes.delete(key);
  let pending = refreshes.get(refreshToken);
  if (!pending) {
    pending = { expiresAt: Date.now() + 30_000, result: rotate(refreshToken) };
    refreshes.set(refreshToken, pending);
  }
  const result = await pending.result;
  if (result.status !== "ok") {
    // Lỗi mạng có thể xảy ra sau khi backend đã xoay token: bỏ token cũ thay vì dùng lại.
    if (result.status === "error" && result.message !== "Chưa thể gia hạn phiên đăng nhập. Vui lòng thử lại sau.") await clearSession();
    return result;
  }
  await saveSession(result.data);
  return ok({ rotated: true });
}

async function rotate(refreshToken: string): Promise<DataResult<TokenPair>> {
  try {
    const incoming = await headers();
    const response = await fetch(`${(process.env.API_BASE_URL ?? "http://localhost:3000/v1").replace(/\/$/, "")}/auth/refresh`, {
      method: "POST", cache: "no-store", redirect: "error", signal: AbortSignal.timeout(15_000),
      headers: { "Content-Type": "application/json", "User-Agent": incoming.get("user-agent") ?? "Marketplace web" },
      body: JSON.stringify({ refreshToken })
    });
    if (!response.ok) return failed("POST /auth/refresh", response.status === 429 || response.status === 503
      ? "Chưa thể gia hạn phiên đăng nhập. Vui lòng thử lại sau."
      : "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.");
    const tokens = z.object({ accessToken: z.string().min(1), refreshToken: z.string().min(1), scope: z.literal("passenger"), role: z.string(), tokenType: z.literal("Bearer"), expiresIn: z.number().int().positive(), refreshExpiresIn: z.number().int().positive() }).safeParse(await response.json());
    if (!tokens.success) return failed("POST /auth/refresh", "Phiên đăng nhập không hợp lệ.");
    return ok(tokens.data);
  } catch (error) {
    unstable_rethrow(error);
    return failed("POST /auth/refresh", "Không thể gia hạn phiên đăng nhập. Vui lòng đăng nhập lại nếu lỗi tiếp diễn.");
  }
}
