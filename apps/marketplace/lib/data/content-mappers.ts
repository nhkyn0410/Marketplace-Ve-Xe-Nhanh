import type { components } from "@vexenhanh/api-client";
import type { ArticleDetail, ArticleSummary, LegalDocumentData } from "./types";
import { formatDateVi } from "../format";

/** Chuyển tóm tắt bài viết, không tự tạo lượt xem hoặc thời gian đọc. */
export function mapArticle(article: components["schemas"]["ArticlePageDto_Output"]["items"][number]): ArticleSummary {
  return { id: article.slug, slug: article.slug, title: article.title, excerpt: article.summary,
    category: article.category.name, categorySlug: article.category.slug,
    publishedDateText: formatDateVi(article.publishedAt), viewsCountText: "",
    coverImageUrl: article.coverImageUrl ?? "", isFeatured: article.featured };
}

/** Chuyển nội dung Markdown thật sang phần nội dung bài viết an toàn. */
export function mapArticleDetail(article: components["schemas"]["ArticleDto_Output"]): ArticleDetail {
  return { ...mapArticle(article), authorName: "", leadParagraph: article.summary,
    sections: [{ heading: "", content: article.contentMarkdown }], relatedArticles: [] };
}

/** Chuyển trang tĩnh, chỉ hiển thị ngày cập nhật có trong API. */
export function mapLegalDocument(slug: string, item: components["schemas"]["PublicContentItemDto_Output"]): LegalDocumentData {
  return { slug, title: item.title, effectiveDateText: "", lastUpdatedText: formatDateVi(item.updatedAt),
    noteText: "", tableOfContents: [], sections: [{ id: item.id, title: item.title, paragraphs: [item.bodyMarkdown] }] };
}
