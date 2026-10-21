// Gọi API Nội dung công khai cho Admin (05 API §7.5 `/admin/content-pages*`, TASK-ADM-003). Kiểu lấy từ client sinh
// tự OpenAPI.
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type ContentPagePage = Schemas["ContentPagePageDto_Output"];
export type ContentPageSummary = ContentPagePage["items"][number];
export type ContentPage = Schemas["ContentPageDetailDto_Output"];
export type ContentPageInput = Schemas["ContentPageInputDto"];
export type ContentPageType = ContentPage["type"];
export type ContentPlacement = ContentPage["placement"];
export type ContentPageStatus = ContentPage["status"];
export type ContentImageUpload = Schemas["ContentImageUploadResponseDto_Output"];
export type ContentPageFilters = { q?: string; type?: ContentPageType; status?: ContentPageStatus };

export function listContentPages(filters: ContentPageFilters, cursor: string | null): Promise<ContentPagePage> {
  const query = new URLSearchParams({ limit: "20" });
  for (const [key, value] of Object.entries({ ...filters, cursor })) {
    if (value) {
      query.set(key, value);
    }
  }
  return apiRequest<ContentPagePage>(`/admin/content-pages?${query}`);
}

export function getContentPage(id: string): Promise<ContentPage> {
  return apiRequest<ContentPage>(`/admin/content-pages/${id}`);
}

export function createContentPage(input: ContentPageInput): Promise<ContentPage> {
  return apiRequest<ContentPage>("/admin/content-pages", { method: "POST", body: input });
}

export function updateContentPage(id: string, input: ContentPageInput): Promise<ContentPage> {
  return apiRequest<ContentPage>(`/admin/content-pages/${id}`, { method: "PUT", body: input });
}

/** Hiển thị (`PUBLISHED`) / ẩn về bản nháp (`DRAFT`). */
export function setContentPageStatus(id: string, status: ContentPageStatus): Promise<ContentPage> {
  return apiRequest<ContentPage>(`/admin/content-pages/${id}/status`, { method: "PUT", body: { status } });
}

export function requestContentImageUpload(contentType: "image/jpeg" | "image/png" | "image/webp", sizeBytes: number): Promise<ContentImageUpload> {
  return apiRequest<ContentImageUpload>("/admin/content-pages/image-upload-url", { method: "POST", body: { contentType, sizeBytes } });
}
