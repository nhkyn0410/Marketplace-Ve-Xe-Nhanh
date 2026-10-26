"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Info } from "lucide-react";
import type { LegalDocumentData } from "../../lib/data/types";
import { MarkdownContent } from "../explore/markdown-content";
import { PassengerTopBar } from "../passenger-topbar";

export interface LegalViewProps {
  readonly document: LegalDocumentData;
  readonly currentSlug: string;
  readonly isPreview?: boolean;
  readonly pageLinks?: readonly { readonly slug: string; readonly title: string }[];
}

/**
 * Giao diện xem văn bản pháp lý (SCR-PSG-06 - Figma 1449:22136).
 * Hỗ trợ 3 tab văn bản, mục lục cuộn mượt và hộp thông báo lưu ý bố cục.
 */
export function LegalView({
  document,
  currentSlug,
  isPreview = false,
  pageLinks = []
}: LegalViewProps): React.JSX.Element {
  const [activeSectionId, setActiveSectionId] = useState<string>(
    document.tableOfContents[0]?.id ?? "sec-01"
  );

  const tabs = isPreview ? [
    { name: "Điều khoản sử dụng", slug: "terms-of-service", fallbackSlugs: ["terms", "dieu-khoan-su-dung"] },
    { name: "Chính sách bảo mật", slug: "privacy-policy", fallbackSlugs: ["privacy", "chinh-sach-bao-mat"] },
    { name: "Chính sách hoàn tiền", slug: "refund-policy", fallbackSlugs: ["refund", "chinh-sach-hoan-tien"] }
  ] : pageLinks.map((page) => ({ name: page.title, slug: page.slug, fallbackSlugs: [] as string[] }));

  const handleScrollToSection = (id: string): void => {
    setActiveSectionId(id);
    if (typeof window !== "undefined") {
      const el = window.document.getElementById(id);
      if (el) {
        el.scrollIntoView({ behavior: "smooth", block: "start" });
      }
    }
  };

  return (
    <div className="bg-[#f9f9ff] min-h-viewport pb-16">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: document.title }]} />

      <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14 space-y-6">
        {/* Tabs chuyển đổi văn bản pháp lý */}
        {tabs.length > 0 && <div className="inline-flex flex-wrap p-1 bg-[#f1f5f9] rounded-xl gap-1 text-xs sm:text-sm font-medium">
          {tabs.map((tab) => {
            const isTabActive =
              currentSlug === tab.slug ||
              tab.fallbackSlugs.includes(currentSlug) ||
              (tab.slug === "terms-of-service" && (currentSlug === "terms" || currentSlug === "dieu-khoan-su-dung"));

            return (
              <Link
                key={tab.slug}
                href={`/legal/${tab.slug}${isPreview ? "?preview=ideal" : ""}`}
                className={`px-4 py-2 rounded-lg transition-all ${
                  isTabActive
                    ? "bg-white text-[#0f172a] shadow-xs font-semibold"
                    : "text-[#64748b] hover:text-[#0f172a]"
                }`}
              >
                {tab.name}
              </Link>
            );
          })}
        </div>}

        {/* Bố cục 2 cột: Mục lục (trái) và Nội dung điều khoản (phải) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Cột trái: Bảng mục lục */}
          {document.tableOfContents.length > 0 && <aside className="lg:col-span-4 rounded-2xl border border-[#e5e9f0] bg-white p-5 shadow-xs sticky top-20">
            <div className="text-[11px] font-bold uppercase tracking-wider text-[#94a3b8] mb-3">
              Mục lục
            </div>

            <nav className="space-y-1">
              {document.tableOfContents.map((toc) => {
                const isActive = toc.id === activeSectionId;
                return (
                  <button
                    key={toc.id}
                    type="button"
                    onClick={() => handleScrollToSection(toc.id)}
                    className={`w-full text-left px-3 py-2 rounded-lg text-xs sm:text-sm transition-colors ${
                      isActive
                        ? "bg-[#eaf4f2] text-[#005963] font-semibold"
                        : "text-[#475569] hover:bg-gray-50/80 hover:text-[#0f172a]"
                    }`}
                  >
                    {toc.title}
                  </button>
                );
              })}
            </nav>
          </aside>}

          {/* Cột phải: Khối nội dung văn bản */}
          <article className={`${document.tableOfContents.length ? "lg:col-span-8" : "lg:col-span-12"} rounded-2xl border border-[#e5e9f0] bg-white p-6 sm:p-8 shadow-xs space-y-6`}>
            {/* Tiêu đề & Thời gian */}
            <div className="space-y-1">
              <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
                {document.title}
              </h1>
              <p className="text-xs text-[#64748b]">
                {document.effectiveDateText && <>Hiệu lực từ {document.effectiveDateText} · </>}Cập nhật lần cuối {document.lastUpdatedText}
              </p>
            </div>

            {/* Box cảnh báo lưu ý */}
            {document.noteText && <div className="rounded-xl border border-amber-200/80 bg-amber-50/70 p-3.5 sm:p-4 flex items-start gap-2.5 text-xs text-amber-900 leading-relaxed">
              <Info className="h-4 w-4 text-amber-600 shrink-0 mt-0.5" />
              <span>{document.noteText}</span>
            </div>}

            {/* Danh sách các phần điều khoản */}
            <div className="space-y-8 pt-2">
              {document.sections.map((section) => (
                <section
                  key={section.id}
                  id={section.id}
                  className="space-y-3 scroll-mt-24"
                >
                  {section.title !== document.title && <h2 className="text-lg sm:text-xl font-bold text-[#0f172a] tracking-tight">
                    {section.title}
                  </h2>}
                  <div className="space-y-2.5 text-xs sm:text-sm text-[#334155] leading-relaxed">
                    {section.paragraphs.map((p, pIdx) => (
                      <MarkdownContent key={pIdx}>{p}</MarkdownContent>
                    ))}
                  </div>
                </section>
              ))}
            </div>
          </article>
        </div>
      </div>
    </div>
  );
}
