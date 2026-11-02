import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import {
  articleErrors,
  describeArticleError,
  formatDate,
  insertAt,
  readingMinutes,
  savedLine,
  slugError,
  slugify
} from "./article-format";

const valid = {
  title: "Đà Lạt mùa dã quỳ",
  slug: "da-lat-mua-da-quy",
  summary: "Tóm tắt",
  contentMarkdown: "## Mở đầu",
  categoryId: "c1",
  coverImageKey: null,
  featured: false
};

describe("định dạng màn Bài viết", () => {
  it("slug từ tiêu đề: bỏ dấu (cả đ), chữ thường, gạch ngang, cắt độ dài", () => {
    expect(slugify("Đà Lạt mùa dã quỳ: lịch trình 2 ngày!")).toBe("da-lat-mua-da-quy-lich-trinh-2-ngay");
    expect(slugify("  --Đường Hồ Chí Minh--  ")).toBe("duong-ho-chi-minh");
    expect(slugify("a ".repeat(100), 20)).toBe("a-a-a-a-a-a-a-a-a-a");
    expect(slugError("Bai-Moi")).not.toBeNull();
    expect(slugError("bai--moi")).not.toBeNull();
    expect(slugError("bai-moi-2026")).toBeNull();
  });

  it("lỗi tại ô; xuất bản cần nội dung", () => {
    expect(articleErrors(valid)).toEqual({});
    expect(articleErrors({ ...valid, title: " ", summary: "", categoryId: "" })).toMatchObject({
      title: expect.any(String),
      summary: expect.any(String),
      categoryId: expect.any(String)
    });
    expect(articleErrors({ ...valid, contentMarkdown: "  " })).toEqual({});
    expect(articleErrors({ ...valid, contentMarkdown: "  " }, true)).toHaveProperty("contentMarkdown");
  });

  it("lỗi API → ô slug / chuyên mục / ảnh bìa / nội dung, hay báo chung", () => {
    expect(describeArticleError(new ApiError(409, "ARTICLE_SLUG_CONFLICT", "x")).field).toBe("slug");
    expect(describeArticleError(new ApiError(422, "ARTICLE_CATEGORY_UNAVAILABLE", "x"))).toMatchObject({
      field: "categoryId",
      refresh: true
    });
    expect(describeArticleError(new ApiError(422, "ARTICLE_INCOMPLETE", "x")).field).toBe("contentMarkdown");
    expect(describeArticleError(new ApiError(409, "ARTICLE_STATE_INVALID", "x"))).toMatchObject({ field: "form", refresh: true });
    expect(describeArticleError(new TypeError("fetch failed")).field).toBe("form");
  });

  it("giờ Việt Nam ở dòng lưu lần cuối và cột xuất bản", () => {
    expect(savedLine("2026-10-13T02:14:00.000Z", "platform/khanh")).toBe("Lưu lần cuối 09:14 · 13/10/2026 bởi platform/khanh");
    expect(formatDate("2026-10-01T18:00:00.000Z")).toBe("02/10/2026");
    expect(formatDate(null)).toBe("—");
  });

  it("chèn ảnh vào Markdown thành một đoạn riêng tại con trỏ", () => {
    expect(insertAt("Đoạn 1", 6, 6, "![](u)")).toEqual({ text: "Đoạn 1\n\n![](u)\n", cursor: 15 });
    expect(insertAt("", 0, 0, "![](u)")).toEqual({ text: "![](u)\n", cursor: 7 });
  });

  it("thời gian đọc như app: 200 từ/phút, làm tròn lên, tối thiểu 1 phút", () => {
    expect(readingMinutes("")).toBe(1);
    expect(readingMinutes("  ## Tiêu đề\n\n  nội   dung  ")).toBe(1);
    expect(readingMinutes(Array.from({ length: 201 }, () => "từ").join(" "))).toBe(2);
  });
});
