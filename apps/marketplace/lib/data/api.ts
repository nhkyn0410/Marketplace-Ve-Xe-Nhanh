import { cookies, headers as requestHeaders } from "next/headers";
import { unstable_rethrow } from "next/navigation";
import { failed, ok, type DataResult } from "./result";

export const ACCESS_COOKIE = "vxn_marketplace_access";
export const REFRESH_COOKIE = "vxn_marketplace_refresh";

/** Gọi API từ máy chủ; phiên hành khách chỉ được gửi bằng Bearer, không đưa token ra trình duyệt. */
export async function apiRequest<T>(path: string, init: RequestInit = {}): Promise<DataResult<T>> {
  const endpoint = `${init.method ?? "GET"} ${path}`;
  if (!path.startsWith("/") || path.startsWith("//") || path.includes("\\")) {
    return failed(endpoint, "Đường dẫn API không hợp lệ.");
  }
  try {
    const cookieStore = await cookies();
    const incomingHeaders = await requestHeaders();
    const headers = new Headers(init.headers);
    headers.set("Accept", "application/json");
    if (init.body && !headers.has("Content-Type")) headers.set("Content-Type", "application/json");
    const accessToken = cookieStore.get(ACCESS_COOKIE)?.value;
    if (accessToken) headers.set("Authorization", `Bearer ${accessToken}`);
    const userAgent = incomingHeaders.get("user-agent");
    if (userAgent) headers.set("User-Agent", userAgent);
    const base = (process.env.API_BASE_URL ?? "http://localhost:3000/v1").replace(/\/$/, "");
    const response = await fetch(`${base}${path}`, { ...init, headers, cache: "no-store", redirect: "error", signal: init.signal ?? AbortSignal.timeout(15_000) });
    if (!response.ok) {
      const problem = await response.json().catch(() => null) as { detail?: string; title?: string } | null;
      return failed(endpoint, problem?.detail ?? problem?.title ?? `Không thể thực hiện yêu cầu (${response.status}).`, response.status);
    }
    return ok(response.status === 204 ? undefined as T : await response.json() as T);
  } catch (error) {
    unstable_rethrow(error);
    return failed(endpoint, "Không thể kết nối tới máy chủ. Vui lòng thử lại sau.");
  }
}
