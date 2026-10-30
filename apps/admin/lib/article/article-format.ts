// Định dạng màn Bài viết (Figma ADM-13a…13c; TASK-CNT-001, BR-74). Hàm thuần.
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";

import type { ArticleStatus } from "./article-api";

export const ARTICLE_STATUS: Record<ArticleStatus, { label: string; tone: "success" | "neutral" | "warning" }> = {
  DRAFT: { label: "Nháp", tone: "neutral" },
  PUBLISHED: { label: "Đã xuất bản", tone: "success" },
  ARCHIVED: { label: "Đã gỡ", tone: "neutral" }
};
export const STATUS_ORDER: ArticleStatus[] = ["PUBLISHED", "DRAFT", "ARCHIVED"];

export const TITLE_MAX = 200;
export const SUMMARY_MAX = 300;
export const CONTENT_MAX = 50_000;

/** Slug từ tiêu đề: bỏ dấu tiếng Việt (cả đ / Đ), chữ thường, nối bằng gạch ngang, tối đa 120 ký tự. */
export function slugify(title: string, max = 120): string {
  return title
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .replace(/[đĐ]/g, "d")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, max)
    .replace(/-+$/g, "");
}

export function slugError(value: string, max = 120): string | null {
  if (value.trim() === "") {
    return "Nhập slug.";
  }
  if (value.length > max || !/^[a-z0-9]+(-[a-z0-9]+)*$/.test(value)) {
    return "Slug gồm chữ thường không dấu, số và gạch ngang.";
  }
  return null;
}

export type ArticleFormValues = {
  title: string;
  slug: string;
  summary: string;
  contentMarkdown: string;
  categoryId: string;
  coverImageKey: string | null;
  featured: boolean;
};
export type ArticleField = "title" | "slug" | "summary" | "contentMarkdown" | "categoryId" | "coverImageKey";

/** Lỗi tại ô của form bài viết (lưu nháp); `publish` = thêm điều kiện có nội dung. */
export function articleErrors(values: ArticleFormValues, publish = false): Partial<Record<ArticleField, string>> {
  const errors: Partial<Record<ArticleField, string>> = {};
  if (values.title.trim() === "") {
    errors.title = "Nhập tiêu đề.";
  } else if (values.title.trim().length > TITLE_MAX) {
    errors.title = `Tiêu đề tối đa ${TITLE_MAX} ký tự.`;
  }
  const slug = slugError(values.slug);
  if (slug) {
    errors.slug = slug;
  }
  if (values.summary.trim() === "") {
    errors.summary = "Nhập tóm tắt.";
  } else if (values.summary.trim().length > SUMMARY_MAX) {
    errors.summary = `Tóm tắt tối đa ${SUMMARY_MAX} ký tự.`;
  }
  if (!values.categoryId) {
    errors.categoryId = "Chọn chuyên mục.";
  }
  if (values.contentMarkdown.length > CONTENT_MAX) {
    errors.contentMarkdown = "Nội dung quá dài.";
  } else if (publish && values.contentMarkdown.trim() === "") {
    errors.contentMarkdown = "Bài viết cần có nội dung trước khi xuất bản.";
  }
  return errors;
}

/** Lỗi API → ô tương ứng hoặc báo chung; `refresh` = dữ liệu trên màn có thể đã cũ. */
export function describeArticleError(error: unknown): { field: ArticleField | "form"; message: string; refresh?: boolean } {
  if (!(error instanceof ApiError)) {
    return { field: "form", message: "Không kết nối được máy chủ. Kiểm tra mạng rồi thử lại." };
  }
  switch (error.code) {
    case "ARTICLE_SLUG_CONFLICT":
      return { field: "slug", message: "Slug này đã được dùng cho bài khác." };
    case "ARTICLE_CATEGORY_UNAVAILABLE":
      return { field: "categoryId", message: "Chuyên mục đã ngừng dùng. Chọn chuyên mục khác.", refresh: true };
    case "ARTICLE_IMAGE_INVALID":
      return { field: "coverImageKey", message: "Ảnh bìa không hợp lệ. Vui lòng tải lại ảnh." };
    case "ARTICLE_INCOMPLETE":
      return { field: "contentMarkdown", message: "Bài viết cần có nội dung trước khi xuất bản." };
    case "ARTICLE_STATE_INVALID":
      return { field: "form", message: "Trạng thái bài viết vừa thay đổi. Đã tải lại bài.", refresh: true };
    case "ARTICLE_NOT_FOUND":
      return { field: "form", message: "Không còn tìm thấy bài viết này." };
    default:
      return error.status === 503
        ? { field: "form", message: "Hệ thống tạm thời không phản hồi nên chưa lưu được. Vui lòng thử lại sau." }
        : { field: "form", message: error.message || "Không thực hiện được thao tác. Vui lòng thử lại." };
  }
}

/** `datetime-local` (giờ máy, coi là giờ Việt Nam) ↔ ISO. Chuỗi rỗng = xuất bản ngay. */
export function localInputToIso(value: string): string | null {
  if (!value) {
    return null;
  }
  const date = new Date(value);
  return Number.isNaN(date.getTime()) ? null : date.toISOString();
}

/** Dòng phụ "Lưu lần cuối 09:14 · 13/10/2026 bởi platform/khanh" (giờ Việt Nam). */
export function savedLine(updatedAt: string, by: string | null): string {
  const shifted = new Date(new Date(updatedAt).getTime() + 7 * 3_600_000);
  const pad = (value: number) => String(value).padStart(2, "0");
  const when = `${pad(shifted.getUTCHours())}:${pad(shifted.getUTCMinutes())} · ${pad(shifted.getUTCDate())}/${pad(
    shifted.getUTCMonth() + 1
  )}/${shifted.getUTCFullYear()}`;
  return by ? `Lưu lần cuối ${when} bởi ${by}` : `Lưu lần cuối ${when}`;
}

/** `02/10/2026` (giờ Việt Nam) — cột Xuất bản. */
export function formatDate(iso: string | null): string {
  if (!iso) {
    return "—";
  }
  const shifted = new Date(new Date(iso).getTime() + 7 * 3_600_000);
  const pad = (value: number) => String(value).padStart(2, "0");
  return `${pad(shifted.getUTCDate())}/${pad(shifted.getUTCMonth() + 1)}/${shifted.getUTCFullYear()}`;
}

/** Chèn `snippet` vào vị trí con trỏ của ô Markdown; trả nội dung mới + vị trí con trỏ sau đoạn chèn. */
export function insertAt(text: string, start: number, end: number, snippet: string): { text: string; cursor: number } {
  const before = text.slice(0, start);
  const after = text.slice(end);
  const lead = before === "" || before.endsWith("\n\n") ? "" : before.endsWith("\n") ? "\n" : "\n\n";
  const inserted = `${lead}${snippet}\n`;
  return { text: `${before}${inserted}${after}`, cursor: before.length + inserted.length };
}

/** Thời gian đọc ước tính như app hành khách (`ArticleDetail.readingMinutes`): ~200 từ/phút, tối thiểu 1. */
export function readingMinutes(markdown: string): number {
  const words = markdown.split(/\s+/).filter((word) => word !== "").length;
  return Math.max(1, Math.ceil(words / 200));
}
