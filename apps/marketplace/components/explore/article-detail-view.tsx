"use client";

import Link from "next/link";
import { ArrowLeft, ChevronRight } from "lucide-react";
import type { ArticleDetail } from "../../lib/data/types";
import { MarkdownContent } from "./markdown-content";

/** Thuộc tính của trang đọc bài viết đã xuất bản. */
export interface ArticleDetailViewProps {
  readonly article: ArticleDetail;
  readonly isPreview?: boolean;
}

/** Bài viết với nội dung Markdown và các thông tin được cung cấp. */
export function ArticleDetailView({ article, isPreview = false }: ArticleDetailViewProps) {
  const categoryHref = `/explore?category=${encodeURIComponent(article.categorySlug)}`;
  return (
    <div className="min-h-viewport bg-[#f9f9ff] pb-16">
      <div className="border-b border-[#e5e9f0] bg-white">
        <nav aria-label="Breadcrumb" className="mx-auto w-full flex max-w-[1200px] flex-wrap items-center gap-1.5 px-4 py-3 text-xs text-[#64748b] sm:px-6 lg:px-14">
          <Link href="/">Trang chủ</Link><ChevronRight className="h-3 w-3" /><Link href="/explore">Khám phá</Link><ChevronRight className="h-3 w-3" /><Link href={categoryHref}>{article.category}</Link><ChevronRight className="h-3 w-3" /><span className="line-clamp-1 max-w-md font-medium text-[#1e293b]">{article.title}</span>
        </nav>
      </div>
      <main className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
        <Link href="/explore" className="mb-5 inline-flex items-center gap-1.5 text-sm text-primary hover:underline"><ArrowLeft className="h-4 w-4" />Tất cả bài viết</Link>
        <div className="grid grid-cols-1 items-start gap-8 lg:grid-cols-12">
          <article className="space-y-6 lg:col-span-8">
            <Link href={categoryHref} className="text-xs font-bold uppercase tracking-wider text-[#1068EB]">{article.category}</Link>
            <h1 className="text-2xl font-bold leading-snug tracking-tight text-[#0f172a] sm:text-3xl lg:text-[34px]">{article.title}</h1>
            <div className="flex flex-wrap items-center gap-2 text-xs text-[#64748b]">
              {article.authorName && <span className="font-semibold text-[#1e293b]">{article.authorName} ·</span>}
              <span>Xuất bản {article.publishedDateText}</span>
              {article.readingTimeMinutes && <span>· {article.readingTimeMinutes} phút đọc</span>}
              {article.viewsCountText && <span>· {article.viewsCountText}</span>}
            </div>
            {article.coverImageUrl && <img src={article.coverImageUrl} alt={article.title} className="aspect-[16/9] w-full rounded-2xl object-cover" />}
            <p className="text-base leading-relaxed text-[#334155]">{article.leadParagraph}</p>
            <div className="space-y-6 pt-2">
              {article.sections.map((section, index) => <section key={index} className="space-y-3">
                {section.heading && <h2 className="text-xl font-bold text-[#0f172a] sm:text-2xl">{section.heading}</h2>}
                <MarkdownContent>{section.content}</MarkdownContent>
                {section.tips?.length ? <ul className="list-disc space-y-2 pl-5 text-sm text-[#334155]">{section.tips.map((tip) => <li key={tip}>{tip}</li>)}</ul> : null}
              </section>)}
            </div>
          </article>
          <aside className="space-y-6 lg:col-span-4">
            <div className="space-y-4 rounded-2xl border border-[#e5e9f0] bg-white p-5 shadow-xs">
              <h2 className="text-base font-bold text-[#0f172a]">Cùng chuyên mục</h2>
              {article.relatedArticles.map((related) => <Link key={related.id} href={`/explore/${related.slug}${isPreview ? "?preview=ideal" : ""}`} className="block border-b border-[#f1f5f9] pb-3 text-sm font-semibold text-[#1e293b] hover:text-primary">{related.title}</Link>)}
              <Link href={categoryHref} className="inline-flex items-center gap-1 text-sm font-medium text-primary">Xem bài viết {article.category}<ChevronRight className="h-3.5 w-3.5" /></Link>
            </div>
          </aside>
        </div>
      </main>
    </div>
  );
}
