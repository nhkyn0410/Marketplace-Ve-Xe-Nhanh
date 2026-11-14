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

/**
 * Link pháp lý cố định trên web (chân trang, form đăng ký, ô đồng ý khi thanh toán) → slug trang tĩnh do quản trị tạo ở
 * CMS. Bộ nội dung mẫu dùng slug tiếng Việt (`chinh-sach-bao-mat`, `quy-che-hoat-dong`) nên link cố định trả 404.
 * Ánh xạ "Điều khoản sử dụng" → "Quy chế hoạt động" là đề xuất, chờ Khanh duyệt (12/11/2026).
 */
const LEGAL_SLUG_ALIASES: Readonly<Record<string, readonly string[]>> = {
  "terms-of-service": ["dieu-khoan-su-dung", "quy-che-hoat-dong"],
  terms: ["terms-of-service", "dieu-khoan-su-dung", "quy-che-hoat-dong"],
  "privacy-policy": ["chinh-sach-bao-mat"],
  privacy: ["privacy-policy", "chinh-sach-bao-mat"],
  "refund-policy": ["chinh-sach-hoan-tien"],
  refund: ["refund-policy", "chinh-sach-hoan-tien"]
};

/** Slug trang tĩnh đã xuất bản dùng thay cho link cố định chưa có trong CMS; không có trang tương ứng thì `null`. */
export function resolveLegalAlias(slug: string, publishedSlugs: readonly string[]): string | null {
  return LEGAL_SLUG_ALIASES[slug]?.find((candidate) => publishedSlugs.includes(candidate)) ?? null;
}
