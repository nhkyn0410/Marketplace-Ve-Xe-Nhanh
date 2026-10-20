"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { ArrowRight, Clock, Eye, Search, Sparkles } from "lucide-react";
import type { ArticleCategory, ArticleSummary } from "../../lib/data/types";

/**
 * Thuộc tính của component trang Khám phá (SCR-PSG-02).
 */
export interface ExploreViewProps {
  readonly categories: readonly ArticleCategory[];
  readonly featuredArticle: ArticleSummary;
  readonly articles: readonly ArticleSummary[];
}

/**
 * Component hiển thị trang Khám phá & Cẩm nang (SCR-PSG-02 - Figma 1449:20595).
 */
export function ExploreView({
  categories,
  featuredArticle,
  articles
}: ExploreViewProps) {
  const [activeCategorySlug, setActiveCategorySlug] = useState<string>("all");
  const [searchKeyword, setSearchKeyword] = useState<string>("");

  // Lọc bài viết theo category và search keyword
  const filteredArticles = useMemo(() => {
    return articles.filter((art) => {
      const matchCat =
        activeCategorySlug === "all" || art.categorySlug === activeCategorySlug;
      const matchSearch =
        !searchKeyword.trim() ||
        art.title.toLowerCase().includes(searchKeyword.toLowerCase()) ||
        art.excerpt.toLowerCase().includes(searchKeyword.toLowerCase());
      return matchCat && matchSearch;
    });
  }, [articles, activeCategorySlug, searchKeyword]);

  return (
    <div className="space-y-10">
      {/* 1. Header Trang & Tìm kiếm */}
      <div className="flex flex-col gap-6 md:flex-row md:items-end md:justify-between">
        <div>
          <h1 className="text-2xl font-black text-vxn-ink sm:text-3xl lg:text-4xl">
            Khám phá
          </h1>
          <p className="mt-2 text-xs text-vxn-fg-4 sm:text-sm">
            Cẩm nang, tin tức và kinh nghiệm đi xe khách do Vé Xe Nhanh biên soạn.
          </p>
        </div>

        {/* Thanh tìm kiếm */}
        <div className="relative w-full md:w-80">
          <input
            type="text"
            placeholder="Tìm bài viết theo từ khóa"
            value={searchKeyword}
            onChange={(e) => setSearchKeyword(e.target.value)}
            className="w-full rounded-xl border border-vxn-border bg-white px-4 py-2.5 pl-10 text-xs font-semibold text-vxn-ink placeholder:font-normal placeholder:text-vxn-fg-4 focus:border-vxn-teal-600 focus:outline-hidden focus:ring-2 focus:ring-vxn-teal-500/20"
          />
          <Search className="pointer-events-none absolute top-1/2 left-3 -translate-y-1/2 h-4 w-4 text-vxn-fg-4" />
        </div>
      </div>

      {/* 2. Tabs Chuyên mục */}
      <div className="flex flex-wrap items-center gap-2 border-b border-vxn-border/60 pb-3">
        {categories.map((cat) => (
          <button
            key={cat.id}
            type="button"
            onClick={() => setActiveCategorySlug(cat.slug)}
            className={`rounded-xl px-4 py-2 text-xs font-bold transition ${
              activeCategorySlug === cat.slug
                ? "bg-[#00506a] text-white shadow-xs"
                : "bg-white text-vxn-fg-3 border border-vxn-border hover:bg-vxn-bg-soft"
            }`}
          >
            {cat.name} ({cat.count})
          </button>
        ))}
      </div>

      {/* 3. Bài viết Nổi bật (Featured Article Hero Card) */}
      {activeCategorySlug === "all" && !searchKeyword && (
        <div className="group relative overflow-hidden rounded-3xl border border-vxn-border bg-white shadow-md transition hover:shadow-xl lg:flex">
          {/* Ảnh bìa */}
          <div
            className="h-64 w-full bg-cover bg-center transition duration-500 group-hover:scale-102 lg:h-auto lg:w-1/2"
            style={{ backgroundImage: `url('${featuredArticle.coverImageUrl}')` }}
          />

          {/* Nội dung bên phải */}
          <div className="flex flex-1 flex-col justify-between p-6 sm:p-8 lg:p-10">
            <div className="space-y-3">
              <div className="flex items-center gap-2">
                <span className="inline-flex items-center gap-1 rounded-full bg-red-500 px-2.5 py-0.5 text-2xs font-bold text-white uppercase">
                  <Sparkles className="h-3 w-3" />
                  Nổi bật
                </span>
                <span className="text-2xs font-black tracking-wider text-vxn-teal-700 uppercase">
                  {featuredArticle.category}
                </span>
              </div>

              <h2 className="text-xl font-black text-vxn-ink transition group-hover:text-vxn-teal-800 sm:text-2xl">
                <Link href={`/explore/${featuredArticle.slug}`}>
                  {featuredArticle.title}
                </Link>
              </h2>

              <p className="text-xs leading-relaxed text-vxn-fg-3 sm:text-sm">
                {featuredArticle.excerpt}
              </p>
            </div>

            <div className="mt-6 flex flex-wrap items-center justify-between gap-4 border-t border-vxn-border/60 pt-4 text-xs text-vxn-fg-4">
              <div className="flex items-center gap-3">
                <span>{featuredArticle.publishedDateText}</span>
                <span>•</span>
                <span className="flex items-center gap-1">
                  <Clock className="h-3.5 w-3.5" />
                  {featuredArticle.readingTimeMinutes} phút đọc
                </span>
                <span>•</span>
                <span className="flex items-center gap-1">
                  <Eye className="h-3.5 w-3.5" />
                  {featuredArticle.viewsCountText}
                </span>
              </div>

              <Link
                href={`/explore/${featuredArticle.slug}`}
                className="inline-flex items-center gap-1.5 font-bold text-vxn-teal-700 hover:text-vxn-teal-800"
              >
                <span>Đọc bài viết</span>
                <ArrowRight className="h-4 w-4" />
              </Link>
            </div>
          </div>
        </div>
      )}

      {/* 4. Lưới danh sách bài viết */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {filteredArticles.map((art) => (
          <div
            key={art.id}
            className="group flex flex-col overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs transition hover:shadow-md"
          >
            {/* Ảnh thumbnail */}
            <Link href={`/explore/${art.slug}`} className="block overflow-hidden">
              <div
                className="h-48 w-full bg-cover bg-center transition duration-500 group-hover:scale-105"
                style={{ backgroundImage: `url('${art.coverImageUrl}')` }}
              />
            </Link>

            {/* Nội dung bài */}
            <div className="flex flex-1 flex-col justify-between p-5">
              <div className="space-y-2">
                <span className="text-2xs font-bold text-vxn-teal-700 uppercase tracking-wider">
                  {art.category}
                </span>

                <h3 className="text-base font-bold text-vxn-ink transition group-hover:text-vxn-teal-800 line-clamp-2">
                  <Link href={`/explore/${art.slug}`}>{art.title}</Link>
                </h3>

                <p className="text-xs leading-relaxed text-vxn-fg-3 line-clamp-2">
                  {art.excerpt}
                </p>
              </div>

              <div className="mt-4 flex items-center justify-between border-t border-vxn-border/60 pt-3 text-2xs text-vxn-fg-4">
                <span>{art.publishedDateText}</span>
                <span className="flex items-center gap-1">
                  <Eye className="h-3 w-3" />
                  {art.viewsCountText}
                </span>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Nút Xem thêm */}
      <div className="flex justify-center pt-4">
        <button
          type="button"
          className="rounded-xl border border-vxn-border bg-white px-6 py-3 text-xs font-bold text-vxn-fg-2 shadow-2xs transition hover:bg-vxn-bg-soft"
        >
          Xem thêm bài viết
        </button>
      </div>
    </div>
  );
}
