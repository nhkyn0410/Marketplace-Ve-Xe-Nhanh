import { unavailable, type DataResult } from "./result";
import type {
  ArticleCategory,
  ArticleDetail,
  ArticleSummary,
  FaqGroup,
  LegalDocumentData
} from "./types";

/**
 * Lấy danh sách bài viết cẩm nang / khám phá (SCR-PSG-02).
 * Endpoint: GET /articles
 */
export async function getArticles(
  _category?: string
): Promise<DataResult<{ readonly categories: readonly ArticleCategory[]; readonly articles: readonly ArticleSummary[] }>> {
  return unavailable("GET /articles");
}

/**
 * Lấy chi tiết một bài viết cẩm nang theo slug (SCR-PSG-37).
 * Endpoint: GET /articles/{slug}
 */
export async function getArticleBySlug(
  slug: string
): Promise<DataResult<ArticleDetail>> {
  return unavailable(`GET /articles/${slug}`);
}

/**
 * Lấy danh sách các chuyên mục bài viết (SCR-PSG-02).
 * Endpoint: GET /article-categories
 */
export async function getArticleCategories(): Promise<DataResult<readonly ArticleCategory[]>> {
  return unavailable("GET /article-categories");
}

/**
 * Lấy dữ liệu các câu hỏi thường gặp FAQ (SCR-PSG-03).
 * Endpoint: GET /content/faq
 */
export async function getFaqData(): Promise<DataResult<readonly FaqGroup[]>> {
  return unavailable("GET /content/faq");
}

/**
 * Lấy văn bản điều khoản pháp lý theo slug (SCR-PSG-06).
 * Endpoint: GET /content/legal/{slug}
 */
export async function getLegalDocument(
  slug: string
): Promise<DataResult<LegalDocumentData>> {
  return unavailable(`GET /content/legal/${slug}`);
}
