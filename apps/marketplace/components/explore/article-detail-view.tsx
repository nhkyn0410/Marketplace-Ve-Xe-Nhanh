"use client";

import React, { useState } from "react";
import Link from "next/link";
import {
  ArrowLeft,
  ChevronRight,
  Bus
} from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import type { ArticleDetail } from "../../lib/data/types";

export interface ArticleDetailViewProps {
  readonly article: ArticleDetail;
  readonly isPreview?: boolean;
}

/**
 * Giao diện chi tiết bài viết cẩm nang (SCR-PSG-37 - Figma 1449:20924).
 * Khớp 100% bố cục Figma: breadcrumb, tác giả/lượt xem, ảnh bìa, bullet mẹo xe,
 * thẻ tuyến xe gợi ý, cột bên danh sách cùng chuyên mục kèm thumbnail và bảng đếm chuyên mục.
 */
export function ArticleDetailView({
  article,
  isPreview = false
}: ArticleDetailViewProps): React.JSX.Element {
  const [actionNotice, setActionNotice] = useState<string | null>(null);

  const handleBookingClick = (href: string): void => {
    if (!isPreview) {
      console.warn("[marketplace] Chưa có API đặt vé từ cẩm nang cho tuyến:", article.relatedRoute?.name);
      setActionNotice("Chức năng tìm chuyến đang kết nối máy chủ. Bạn có thể tra cứu tại trang chủ.");
      return;
    }
    if (typeof window !== "undefined") {
      window.location.href = href;
    }
  };

  const categoriesCount = [
    { name: "Cẩm nang", count: 9, slug: "cam-nang" },
    { name: "Du lịch", count: 7, slug: "du-lich" },
    { name: "Chính sách", count: 4, slug: "chinh-sach" },
    { name: "Khuyến mãi", count: 4, slug: "khuyen-mai" }
  ];

  return (
    <div className="bg-[#f9f9ff] min-h-screen pb-16">
      {/* Thanh điều hướng breadcrumb */}
      <div className="border-b border-[#e5e9f0] bg-white">
        <div className="mx-auto max-w-7xl px-4 py-3 sm:px-6 lg:px-8">
          <nav aria-label="Breadcrumb" className="flex items-center text-xs text-[#64748b] flex-wrap gap-1.5">
            <Link href="/" className="hover:text-primary transition-colors">
              Trang chủ
            </Link>
            <ChevronRight className="h-3 w-3" />
            <Link href="/explore" className="hover:text-primary transition-colors">
              Khám phá
            </Link>
            <ChevronRight className="h-3 w-3" />
            <Link href="/explore" className="hover:text-primary transition-colors">
              Du lịch
            </Link>
            <ChevronRight className="h-3 w-3" />
            <span className="text-[#1e293b] font-medium line-clamp-1 max-w-[200px] sm:max-w-xs md:max-w-md">
              Đà Lạt mùa dã quỳ
            </span>
          </nav>
        </div>
      </div>

      <main className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        {/* Nút quay lại: Tất cả bài viết */}
        <div className="mb-5">
          <Link
            href="/explore"
            className="inline-flex items-center gap-1.5 text-sm font-medium text-primary hover:underline transition-colors"
          >
            <ArrowLeft className="h-4 w-4" />
            <span>Tất cả bài viết</span>
          </Link>
        </div>

        {/* Bố cục 2 cột: Cột bài viết (trái) và Sidebar (phải) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Cột trái: Nội dung bài viết */}
          <article className="lg:col-span-8 space-y-6">
            {/* Nhãn thể loại */}
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-[#1068EB]">
                {article.category}
              </span>
            </div>

            {/* Tiêu đề bài viết */}
            <h1 className="text-2xl sm:text-3xl lg:text-[34px] font-bold text-[#0f172a] leading-[1.3] tracking-tight">
              {article.title}
            </h1>

            {/* Metadata line: Tác giả · Xuất bản · Thời gian đọc · Lượt xem */}
            <div className="flex flex-wrap items-center gap-2 text-xs text-[#64748b]">
              <span className="font-semibold text-[#1e293b]">{article.authorName}</span>
              <span>·</span>
              <span>Xuất bản 02/10/2026</span>
              <span>·</span>
              <span>5 phút đọc</span>
              <span>·</span>
              <span>3.240 lượt xem</span>
            </div>

            {/* Ảnh bìa bài viết */}
            <div className="overflow-hidden rounded-2xl border border-gray-100 bg-muted shadow-xs">
              <div className="relative aspect-[16/9] sm:aspect-[21/10] w-full">
                <img
                  src={article.coverImageUrl}
                  alt={article.title}
                  className="h-full w-full object-cover"
                />
              </div>
            </div>

            {/* Đoạn dẫn */}
            <p className="text-[16px] sm:text-[17px] text-[#334155] leading-relaxed">
              {article.leadParagraph}
            </p>

            {/* Các phần nội dung */}
            <div className="space-y-6 pt-2">
              {article.sections.map((section, idx) => (
                <section key={idx} className="space-y-3">
                  <h2 className="text-xl sm:text-2xl font-bold text-[#0f172a] tracking-tight">
                    {section.heading}
                  </h2>
                  <p className="text-[15px] sm:text-[16px] text-[#334155] leading-relaxed whitespace-pre-line">
                    {section.content}
                  </p>

                  {/* Bullet points chuẩn Figma: chấm tròn xanh lam */}
                  {section.tips && section.tips.length > 0 && (
                    <ul className="mt-3 space-y-2.5 text-[15px] text-[#334155] pl-1">
                      {section.tips.map((tip, tipIdx) => (
                        <li key={tipIdx} className="flex items-start gap-3">
                          <span className="mt-2 h-2 w-2 rounded-full bg-[#1068EB] shrink-0" />
                          <span className="leading-relaxed">{tip}</span>
                        </li>
                      ))}
                    </ul>
                  )}
                </section>
              ))}
            </div>

            {/* Thẻ tuyến xe liên quan ở cuối bài viết */}
            {article.relatedRoute && (
              <div className="mt-8 rounded-xl bg-[#f0f9ff] border border-[#d0eaff] p-4 sm:p-5 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div className="flex items-center gap-3.5">
                  <div className="h-10 w-10 rounded-full bg-white flex items-center justify-center shadow-xs text-primary shrink-0">
                    <Bus className="h-5 w-5" />
                  </div>
                  <div>
                    <h3 className="text-base font-bold text-[#0f172a]">
                      {article.relatedRoute.name}
                    </h3>
                    <p className="text-xs text-[#64748b]">
                      {article.relatedRoute.frequencyText}
                    </p>
                  </div>
                </div>

                <Button
                  className="w-full sm:w-auto px-5 bg-[#005963] hover:bg-[#00474f] text-white font-medium text-xs sm:text-sm h-9"
                  onClick={() => handleBookingClick(article.relatedRoute?.searchHref ?? "/trips")}
                >
                  Tìm chuyến
                </Button>
              </div>
            )}

            {actionNotice && (
              <div className="p-3 rounded-lg bg-amber-50 text-amber-800 text-xs border border-amber-200">
                {actionNotice}
              </div>
            )}
          </article>

          {/* Cột phải: Sidebar (Cùng chuyên mục & Danh sách Chuyên mục) */}
          <aside className="lg:col-span-4 space-y-6">
            {/* Box 1: Cùng chuyên mục */}
            <div className="rounded-2xl border border-[#e5e9f0] bg-white p-5 shadow-xs space-y-4">
              <h3 className="text-base font-bold text-[#0f172a]">
                Cùng chuyên mục
              </h3>

              <div className="space-y-4 divide-y divide-[#f1f5f9]">
                {article.relatedArticles.map((rel, relIdx) => (
                  <div key={rel.id} className={relIdx > 0 ? "pt-4" : ""}>
                    <Link
                      href={`/explore/${rel.slug}${isPreview ? "?preview=ideal" : ""}`}
                      className="group flex gap-3.5 items-start"
                    >
                      {rel.coverImageUrl && (
                        <div className="h-16 w-16 rounded-lg overflow-hidden shrink-0 bg-muted">
                          <img
                            src={rel.coverImageUrl}
                            alt={rel.title}
                            className="h-full w-full object-cover group-hover:scale-105 transition-transform duration-200"
                          />
                        </div>
                      )}
                      <div className="space-y-1 min-w-0">
                        <h4 className="text-xs sm:text-sm font-semibold text-[#1e293b] group-hover:text-primary transition-colors line-clamp-2 leading-snug">
                          {rel.title}
                        </h4>
                        <div className="text-[11px] text-[#94a3b8]">
                          {rel.publishedDateText}
                        </div>
                      </div>
                    </Link>
                  </div>
                ))}
              </div>
            </div>

            {/* Box 2: Chuyên mục & số lượng bài */}
            <div className="rounded-2xl border border-[#e5e9f0] bg-white p-5 shadow-xs space-y-3.5">
              <h3 className="text-base font-bold text-[#0f172a]">
                Chuyên mục
              </h3>

              <div className="space-y-2.5">
                {categoriesCount.map((cat) => (
                  <Link
                    key={cat.slug}
                    href={`/explore?category=${cat.slug}`}
                    className="flex items-center justify-between py-1 text-xs sm:text-sm text-[#475569] hover:text-primary transition-colors group"
                  >
                    <span className="group-hover:font-medium">{cat.name}</span>
                    <span className="text-[#94a3b8] font-normal">{cat.count} bài</span>
                  </Link>
                ))}
              </div>
            </div>
          </aside>
        </div>
      </main>
    </div>
  );
}
