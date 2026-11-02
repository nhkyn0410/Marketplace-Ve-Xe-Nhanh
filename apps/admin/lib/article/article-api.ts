// Gọi API bài viết cho cổng Admin (05 API §7.5 `/admin/articles*`, `/admin/article-categories`; TASK-CNT-001).
import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "@vexenhanh/ui/lib/auth/api-client";

type Schemas = components["schemas"];

export type ArticlePage = Schemas["AdminArticlePageDto_Output"];
export type ArticleSummary = ArticlePage["items"][number];
export type Article = Schemas["AdminArticleDto_Output"];
export type ArticleInput = Schemas["AdminArticleInputDto"];
export type ArticleStatus = Article["status"];
export type ArticleCategory = Schemas["AdminArticleCategoryDto_Output"];
export type ArticleCategoryInput = Schemas["AdminArticleCategoryInputDto"];
export type ImageUpload = Schemas["AdminArticleImageUploadResponseDto_Output"];
export type ArticleFilters = { q?: string; status?: ArticleStatus; categoryId?: string };

const PAGE_SIZE = "20";

export function listArticles(filters: ArticleFilters, cursor: string | null): Promise<ArticlePage> {
  const search = new URLSearchParams({ limit: PAGE_SIZE });
  for (const [key, value] of Object.entries({ ...filters, cursor })) {
    if (value) {
      search.set(key, value);
    }
  }
  return apiRequest<ArticlePage>(`/admin/articles?${search.toString()}`);
}

export function getArticle(id: string): Promise<Article> {
  return apiRequest<Article>(`/admin/articles/${id}`);
}

export function createArticle(input: ArticleInput): Promise<Article> {
  return apiRequest<Article>("/admin/articles", { method: "POST", body: input });
}

export function updateArticle(id: string, input: ArticleInput): Promise<Article> {
  return apiRequest<Article>(`/admin/articles/${id}`, { method: "PUT", body: input });
}

export function publishArticle(id: string, publishedAt: string | null): Promise<Article> {
  return apiRequest<Article>(`/admin/articles/${id}/publish`, { method: "POST", body: { publishedAt } });
}

export function archiveArticle(id: string): Promise<Article> {
  return apiRequest<Article>(`/admin/articles/${id}/archive`, { method: "POST" });
}

export function requestImageUpload(contentType: "image/jpeg" | "image/png" | "image/webp", sizeBytes: number): Promise<ImageUpload> {
  return apiRequest<ImageUpload>("/admin/articles/images", { method: "POST", body: { contentType, sizeBytes } });
}

/** Tải file thẳng lên kho bằng URL vừa cấp (không kèm cookie); `Content-Type` phải đúng loại đã khai. */
export async function uploadImageFile(uploadUrl: string, file: Blob): Promise<void> {
  const response = await fetch(uploadUrl, {
    method: "PUT",
    headers: { "Content-Type": file.type },
    body: file,
    credentials: "omit"
  });
  if (!response.ok) {
    throw new Error(`Tải ảnh lên kho thất bại (${response.status}).`);
  }
}

export async function listArticleCategories(): Promise<ArticleCategory[]> {
  return (await apiRequest<{ items: ArticleCategory[] }>("/admin/article-categories")).items;
}

export function createArticleCategory(input: ArticleCategoryInput): Promise<ArticleCategory> {
  return apiRequest<ArticleCategory>("/admin/article-categories", { method: "POST", body: input });
}

export function updateArticleCategory(id: string, input: ArticleCategoryInput): Promise<ArticleCategory> {
  return apiRequest<ArticleCategory>(`/admin/article-categories/${id}`, { method: "PUT", body: input });
}
