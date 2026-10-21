"use server";

import type { components } from "@vexenhanh/api-client";
import { apiRequest } from "./api";
import { ok, type DataResult } from "./result";
import { mapArticle, mapArticleDetail, mapLegalDocument } from "./content-mappers";
import type { ArticleCategory, ArticleDetail, ArticleSummary, FaqGroup, LegalDocumentData } from "./types";

/** Lấy bài viết và chuyên mục công khai, giữ con trỏ phân trang của API. */
export async function getArticles(category?: string, cursor?: string): Promise<DataResult<{
  readonly categories: readonly ArticleCategory[]; readonly articles: readonly ArticleSummary[];
  readonly nextCursor: string | null;
}>> {
  const query = new URLSearchParams({ limit: "24" });
  if (category && category !== "all") query.set("category", category);
  if (cursor) query.set("cursor", cursor);
  const [articles, categories] = await Promise.all([
    apiRequest<components["schemas"]["ArticlePageDto_Output"]>(`/articles?${query}`), getArticleCategories()
  ]);
  if (articles.status !== "ok") return articles;
  if (categories.status !== "ok") return categories;
  return ok({ categories: categories.data, articles: articles.data.items.map(mapArticle), nextCursor: articles.data.nextCursor });
}

/** Lấy nội dung bài viết theo slug công khai. */
export async function getArticleBySlug(slug: string): Promise<DataResult<ArticleDetail>> {
  const result = await apiRequest<components["schemas"]["ArticleDto_Output"]>(`/articles/${encodeURIComponent(slug)}`);
  return result.status === "ok" ? ok(mapArticleDetail(result.data)) : result;
}

/** Lấy chuyên mục kèm số bài viết thật. */
export async function getArticleCategories(): Promise<DataResult<readonly ArticleCategory[]>> {
  const result = await apiRequest<components["schemas"]["ArticleCategoryListDto_Output"]>("/article-categories");
  return result.status === "ok" ? ok([
    { id: "all", slug: "all", name: "Tất cả", count: result.data.items.reduce((sum, c) => sum + c.articleCount, 0) },
    ...result.data.items.map((c) => ({ id: c.slug, slug: c.slug, name: c.name, count: c.articleCount }))
  ]) : result;
}

/** Lấy câu hỏi thường gặp từ danh sách nội dung FAQ đã xuất bản. */
export async function getFaqData(): Promise<DataResult<readonly FaqGroup[]>> {
  const result = await apiRequest<components["schemas"]["PublicContentListDto_Output"]>("/content-pages?type=FAQ");
  return result.status === "ok" ? ok([{ id: "faq", title: "Câu hỏi thường gặp", count: result.data.items.length,
    questions: result.data.items.map((c) => ({ id: c.id, question: c.title, answer: c.bodyMarkdown })) }]) : result;
}

/** Lấy trang chính sách từ nội dung tĩnh đã xuất bản. */
export async function getLegalDocument(slug: string): Promise<DataResult<LegalDocumentData>> {
  const result = await apiRequest<components["schemas"]["PublicContentItemDto_Output"]>(`/content-pages/${encodeURIComponent(slug)}`);
  return result.status === "ok" ? ok(mapLegalDocument(slug, result.data)) : result;
}

/** Lấy liên kết tới các trang thông tin đã xuất bản. */
export async function getPublishedPageLinks(): Promise<readonly { readonly slug: string; readonly title: string }[]> {
  const result = await apiRequest<components["schemas"]["PublicContentListDto_Output"]>("/content-pages?type=PAGE");
  return result.status === "ok" ? result.data.items.flatMap((item) => item.slug ? [{ slug: item.slug, title: item.title }] : []) : [];
}
