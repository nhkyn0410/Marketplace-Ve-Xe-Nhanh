"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import {
  Search,
  Plus,
  Minus,
  Headphones,
  MessageSquare,
  ChevronRight
} from "lucide-react";
import { MarkdownContent } from "../explore/markdown-content";
import type { FaqGroup } from "../../lib/data/types";

export interface FaqViewProps {
  readonly faqGroups: readonly FaqGroup[];
  readonly isPreview?: boolean;
}

/**
 * Giao diện Câu hỏi thường gặp FAQ (SCR-PSG-03 - Figma 1449:21249).
 * Hỗ trợ tìm kiếm từ khóa kèm gợi ý nhanh, chia chuyên mục và accordion tương tác.
 */
export function FaqView({
  faqGroups,
  isPreview: _isPreview = false
}: FaqViewProps): React.JSX.Element {
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [activeGroupId, setActiveGroupId] = useState<string>(
    faqGroups[0]?.id ?? "booking-payment"
  );
  // Quản lý các câu hỏi đang mở accordion (mặc định mở câu đầu tiên)
  const [openQuestionIds, setOpenQuestionIds] = useState<Record<string, boolean>>(() => {
    const first = faqGroups[0]?.questions[0];
    return first ? { [first.id]: true } : {};
  });

  const toggleQuestion = (questionId: string): void => {
    setOpenQuestionIds((prev) => ({
      ...prev,
      [questionId]: !prev[questionId]
    }));
  };

  const currentGroup = useMemo(() => {
    return faqGroups.find((g) => g.id === activeGroupId) ?? faqGroups[0];
  }, [faqGroups, activeGroupId]);

  // Tìm kiếm theo từ khóa nếu có query
  const searchResults = useMemo(() => {
    const q = searchQuery.trim().toLowerCase();
    if (!q) return null;

    const matchedQuestions: { groupTitle: string; question: string; answer: string; id: string }[] = [];
    for (const group of faqGroups) {
      for (const item of group.questions) {
        if (
          item.question.toLowerCase().includes(q) ||
          item.answer.toLowerCase().includes(q)
        ) {
          matchedQuestions.push({
            groupTitle: group.title,
            question: item.question,
            answer: item.answer,
            id: item.id
          });
        }
      }
    }
    return matchedQuestions;
  }, [faqGroups, searchQuery]);

  const quickKeywords = ["Hủy vé", "Hoàn tiền", "Tra cứu vé", "Điểm VXN Plus"];

  return (
    <div className="bg-[#f9f9ff] min-h-viewport pb-16">
      {/* Thanh điều hướng breadcrumb */}
      <div className="border-b border-[#e5e9f0] bg-white">
        <div className="mx-auto max-w-7xl px-4 py-3 sm:px-6 lg:px-8">
          <nav aria-label="Breadcrumb" className="flex items-center text-xs text-[#64748b] flex-wrap gap-1.5">
            <Link href="/" className="hover:text-primary transition-colors">
              Trang chủ
            </Link>
            <ChevronRight className="h-3 w-3" />
            <span className="text-[#1e293b] font-medium">Câu hỏi thường gặp</span>
          </nav>
        </div>
      </div>

      <main className="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8 space-y-8">
        {/* Banner Hero tìm kiếm câu hỏi */}
        <div className="rounded-2xl bg-[#edf5ff] p-6 sm:p-10 text-center space-y-5">
          <h1 className="text-2xl sm:text-3xl lg:text-[32px] font-bold text-[#0f172a] tracking-tight">
            Chúng tôi có thể giúp gì cho bạn?
          </h1>

          <div className="max-w-2xl mx-auto relative">
            <div className="relative flex items-center">
              <Search className="absolute left-4 h-5 w-5 text-[#94a3b8] pointer-events-none" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm câu hỏi, ví dụ: hủy vé, hoàn tiền, giữ chỗ"
                className="w-full h-12 pl-12 pr-4 rounded-xl border border-[#cbd5e1] bg-white text-sm text-[#0f172a] shadow-xs focus:outline-none focus:ring-2 focus:ring-primary focus:border-transparent transition"
              />
            </div>

            {/* Gợi ý từ khóa nhanh */}
            <div className="mt-3.5 flex flex-wrap items-center justify-center gap-2 text-xs text-[#64748b]">
              <span>Gợi ý:</span>
              {quickKeywords.map((kw) => (
                <button
                  key={kw}
                  type="button"
                  onClick={() => setSearchQuery(kw)}
                  className="rounded-full bg-white border border-[#e2e8f0] px-3 py-1 text-xs text-[#334155] hover:border-primary hover:text-primary transition-colors shadow-2xs"
                >
                  {kw}
                </button>
              ))}
              {searchQuery && (
                <button
                  type="button"
                  onClick={() => setSearchQuery("")}
                  className="text-xs text-rose-600 underline ml-1 hover:text-rose-700"
                >
                  Xóa tìm kiếm
                </button>
              )}
            </div>
          </div>
        </div>

        {/* Kết quả tìm kiếm (nếu đang search) */}
        {searchResults !== null ? (
          <div className="rounded-2xl border border-[#e5e9f0] bg-white p-6 shadow-xs space-y-4">
            <div className="border-b border-[#f1f5f9] pb-3">
              <h2 className="text-lg font-bold text-[#0f172a]">
                Kết quả tìm kiếm cho &ldquo;{searchQuery}&rdquo;
              </h2>
              <p className="text-xs text-[#64748b]">
                Tìm thấy {searchResults.length} câu trả lời phù hợp
              </p>
            </div>

            {searchResults.length === 0 ? (
              <div className="py-8 text-center text-sm text-[#64748b] space-y-2">
                <p>Không tìm thấy câu trả lời phù hợp với từ khóa.</p>
                <p className="text-xs">
                  Bạn có thể thử từ khóa khác hoặc gửi yêu cầu tại trung tâm hỗ trợ.
                </p>
              </div>
            ) : (
              <div className="space-y-3 divide-y divide-[#f1f5f9]">
                {searchResults.map((item) => {
                  const isOpen = !!openQuestionIds[item.id];
                  return (
                    <div key={item.id} className="pt-3 first:pt-0">
                      <button
                        type="button"
                        onClick={() => toggleQuestion(item.id)}
                        className="w-full flex items-center justify-between text-left py-2 font-semibold text-sm sm:text-base text-[#1e293b] hover:text-primary transition-colors"
                      >
                        <div className="pr-4">
                          <span className="text-xs font-normal text-[#94a3b8] block mb-0.5">
                            [{item.groupTitle}]
                          </span>
                          <span>{item.question}</span>
                        </div>
                        {isOpen ? (
                          <Minus className="h-4 w-4 shrink-0 text-[#64748b]" />
                        ) : (
                          <Plus className="h-4 w-4 shrink-0 text-[#64748b]" />
                        )}
                      </button>
                      {isOpen && (
                        <div className="mt-2 text-xs sm:text-sm text-[#475569] leading-relaxed pb-2">
                          <MarkdownContent>{item.answer}</MarkdownContent>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        ) : (
          /* Bố cục 2 cột danh mục & accordion câu hỏi */
          <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
            {/* Cột trái: Menu chuyên mục */}
            <aside className="lg:col-span-4 rounded-2xl border border-[#e5e9f0] bg-white overflow-hidden shadow-xs divide-y divide-[#f1f5f9]">
              {faqGroups.map((group) => {
                const isActive = group.id === activeGroupId;
                return (
                  <button
                    key={group.id}
                    type="button"
                    onClick={() => setActiveGroupId(group.id)}
                    className={`w-full flex items-center justify-between px-5 py-3.5 text-left text-sm transition-colors ${
                      isActive
                        ? "bg-[#eaf4f2] text-[#005963] font-bold border-l-4 border-[#005963]"
                        : "text-[#334155] hover:bg-gray-50/80 font-normal"
                    }`}
                  >
                    <span>{group.title}</span>
                    <span
                      className={`text-xs px-2 py-0.5 rounded-full ${
                        isActive
                          ? "bg-[#005963]/10 text-[#005963] font-semibold"
                          : "text-[#94a3b8]"
                      }`}
                    >
                      {group.count}
                    </span>
                  </button>
                );
              })}
            </aside>

            {/* Cột phải: Accordion câu hỏi trong chuyên mục */}
            <section className="lg:col-span-8 rounded-2xl border border-[#e5e9f0] bg-white p-6 sm:p-7 shadow-xs space-y-4">
              {currentGroup && (
                <>
                  <div className="border-b border-[#f1f5f9] pb-4">
                    <h2 className="text-xl font-bold text-[#0f172a]">
                      {currentGroup.title}
                    </h2>
                    <p className="text-xs text-[#64748b] mt-0.5">
                      {currentGroup.count} câu hỏi
                    </p>
                  </div>

                  {!currentGroup.questions.length && <p className="py-4 text-sm text-[#64748b]">Chưa có câu hỏi được xuất bản. Bạn có thể gửi yêu cầu hỗ trợ bên dưới.</p>}
                  <div className="space-y-1 divide-y divide-[#f1f5f9]">
                    {currentGroup.questions.map((q, qIdx) => {
                      const isOpen = !!openQuestionIds[q.id];
                      return (
                        <div key={q.id} className={qIdx > 0 ? "pt-3.5" : ""}>
                          <button
                            type="button"
                            onClick={() => toggleQuestion(q.id)}
                            className="w-full flex items-start justify-between text-left py-2 font-semibold text-sm sm:text-[15px] text-[#0f172a] hover:text-primary transition-colors gap-4"
                          >
                            <span className="leading-snug">{q.question}</span>
                            <span className="shrink-0 mt-0.5 text-[#64748b]">
                              {isOpen ? (
                                <Minus className="h-4 w-4" />
                              ) : (
                                <Plus className="h-4 w-4" />
                              )}
                            </span>
                          </button>
                          {isOpen && (
                            <div className="mt-2 text-xs sm:text-sm text-[#475569] leading-relaxed pb-3">
                              <MarkdownContent>{q.answer}</MarkdownContent>
                            </div>
                          )}
                        </div>
                      );
                    })}
                  </div>
                </>
              )}
            </section>
          </div>
        )}

        {/* Banner hỗ trợ chân trang: CSKH & Gửi khiếu nại */}
        <div className="rounded-2xl border border-[#e5e9f0] bg-white p-5 sm:p-6 shadow-xs flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
          <div className="flex items-center gap-4">
            <div className="h-11 w-11 rounded-full bg-[#f0f7ff] flex items-center justify-center text-primary shrink-0">
              <Headphones className="h-5 w-5" />
            </div>
            <div>
              <h3 className="text-sm sm:text-base font-bold text-[#0f172a]">
                Chưa tìm thấy câu trả lời?
              </h3>
              <p className="text-xs text-[#64748b]">
                Xem và gửi yêu cầu hỗ trợ cho vé đã đặt.
              </p>
            </div>
          </div>

          <div className="flex flex-wrap items-center gap-3 w-full sm:w-auto">
            <Link href="/support" className="inline-flex h-9 items-center gap-1.5 rounded-lg bg-[#005963] px-4 text-xs font-medium text-white hover:bg-[#00474f]">
              <MessageSquare className="h-3.5 w-3.5" /><span>Trung tâm hỗ trợ</span>
            </Link>
          </div>
        </div>
      </main>
    </div>
  );
}
