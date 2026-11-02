// Gọi API đăng ký nhà xe (05 API §7.3, TASK-OPR-001). Người nộp hồ sơ chưa có tài khoản: không cookie phiên, không
// CSRF; hồ sơ xác định bằng token của link bảo mật gửi qua header `X-Application-Token`.
import { API_BASE_URL, ApiError } from "../auth/api-client";
import type { Application, ApplicationUpdateInput, DocumentType } from "./application";

type Method = "GET" | "POST" | "PUT";

async function request<T>(path: string, options: { method?: Method; body?: unknown; token?: string } = {}): Promise<T> {
  const headers: Record<string, string> = {};
  if (options.body !== undefined) {
    headers["Content-Type"] = "application/json";
  }
  if (options.token !== undefined) {
    headers["X-Application-Token"] = options.token;
  }
  const response = await fetch(`${API_BASE_URL}/operator-applications${path}`, {
    method: options.method ?? "GET",
    headers,
    body: options.body === undefined ? undefined : JSON.stringify(options.body),
    credentials: "omit",
    cache: "no-store"
  });
  const text = await response.text();
  let body: { code?: unknown; detail?: unknown; reasons?: unknown } | undefined;
  try {
    body = text ? (JSON.parse(text) as typeof body) : undefined;
  } catch {
    body = undefined;
  }
  if (response.ok) {
    return body as T;
  }
  throw new ApiError(
    response.status,
    typeof body?.code === "string" ? body.code : "UNKNOWN_ERROR",
    typeof body?.detail === "string" ? body.detail : "Đã có lỗi xảy ra. Vui lòng thử lại.",
    Array.isArray(body?.reasons) ? body.reasons.filter((reason): reason is string => typeof reason === "string") : []
  );
}

/** Tạo hồ sơ nháp; API luôn trả 202 — link được gửi tới email liên hệ. */
export function createApplication(input: {
  operatorName: string;
  contactName: string;
  contactEmail: string;
  acceptTerms: true;
}): Promise<void> {
  return request("", { method: "POST", body: input });
}

/** Xin lại link bằng email liên hệ + mã hồ sơ; link cũ hết hiệu lực. Luôn 202. */
export function requestAccessLink(input: { contactEmail: string; applicationCode: string }): Promise<void> {
  return request("/access-link", { method: "POST", body: input });
}

export function getApplication(token: string): Promise<Application> {
  return request("/current", { token });
}

export function saveApplication(token: string, input: ApplicationUpdateInput): Promise<Application> {
  return request("/current", { method: "PUT", body: input, token });
}

export function submitApplication(token: string): Promise<Application> {
  return request("/current/submit", { method: "POST", token });
}

/** Xin URL tải một giấy tờ lên kho riêng tư, rồi `PUT` thẳng file lên đó; trả khóa object để gắn vào hồ sơ. */
export async function uploadDocument(token: string, type: DocumentType, file: File): Promise<string> {
  const grant = await request<{ uploadUrl: string; objectKey: string }>("/current/documents", {
    method: "POST",
    token,
    body: { type, contentType: file.type, sizeBytes: file.size, fileName: file.name }
  });
  const response = await fetch(grant.uploadUrl, {
    method: "PUT",
    headers: { "Content-Type": file.type },
    body: file,
    credentials: "omit"
  });
  if (!response.ok) {
    throw new Error(`Tải giấy tờ lên kho thất bại (${response.status}).`);
  }
  return grant.objectKey;
}

/** URL xem một giấy tờ đã lưu (hạn 5 phút). */
export async function documentViewUrl(token: string, type: DocumentType): Promise<string> {
  return (await request<{ url: string }>(`/current/documents/${type}/download-url`, { method: "POST", token })).url;
}
