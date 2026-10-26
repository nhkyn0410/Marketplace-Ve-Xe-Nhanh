"use client";

import { useState } from "react";
import { Star, ChevronDown, Check } from "lucide-react";
import { OperatorReviewItem } from "../../lib/data/types";
import { MarkdownContent } from "../explore/markdown-content";

interface OperatorReviewsAndTermsProps {
  readonly reviews: readonly OperatorReviewItem[];
  readonly terms: readonly string[];
}

/**
 * Khối hiển thị đánh giá từ hành khách và điều khoản dịch vụ của nhà xe (SCR-PSG-17).
 */
export function OperatorReviewsAndTerms({
  reviews,
  terms
}: OperatorReviewsAndTermsProps) {
  const [activeTab, setActiveTab] = useState<"newest" | "highest" | "lowest">("newest");
  const [expanded, setExpanded] = useState(false);
  const sortedReviews = activeTab === "newest" ? reviews : [...reviews].sort((a, b) => activeTab === "highest" ? b.rating - a.rating : a.rating - b.rating);

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      {/* Cột trái: Đánh giá hành khách */}
      <div id="reviews" className="lg:col-span-8 scroll-mt-24 bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <h2 className="text-base font-semibold text-neutral-900">
            Đánh giá từ hành khách
          </h2>

          {/* 3 tabs lọc */}
          <div className="inline-flex rounded-lg bg-neutral-100 p-0.5 text-xs font-medium text-neutral-600">
            <button
              type="button"
              onClick={() => setActiveTab("newest")}
              className={`px-3 py-1 rounded-md transition-colors ${
                activeTab === "newest"
                  ? "bg-white text-neutral-900 shadow-2xs font-semibold"
                  : "hover:text-neutral-900"
              }`}
            >
              Mới nhất
            </button>
            <button
              type="button"
              onClick={() => setActiveTab("highest")}
              className={`px-3 py-1 rounded-md transition-colors ${
                activeTab === "highest"
                  ? "bg-white text-neutral-900 shadow-2xs font-semibold"
                  : "hover:text-neutral-900"
              }`}
            >
              Cao nhất trang
            </button>
            <button
              type="button"
              onClick={() => setActiveTab("lowest")}
              className={`px-3 py-1 rounded-md transition-colors ${
                activeTab === "lowest"
                  ? "bg-white text-neutral-900 shadow-2xs font-semibold"
                  : "hover:text-neutral-900"
              }`}
            >
              Thấp nhất trang
            </button>
          </div>
        </div>

        {/* Danh sách bình luận */}
        <div className="space-y-4 pt-2 border-t border-neutral-100">
          {!reviews.length && <p className="text-sm text-neutral-500">Chưa có đánh giá để hiển thị.</p>}
          {sortedReviews.slice(0, expanded ? sortedReviews.length : 5).map((rev) => (
            <div
              key={rev.id}
              className="space-y-2 pb-4 border-b border-neutral-100 last:border-0 last:pb-0"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2.5">
                  <div className="w-8 h-8 rounded-full bg-neutral-100 border border-neutral-200 text-neutral-700 font-semibold text-xs flex items-center justify-center">
                    {rev.authorInitial}
                  </div>
                  <div>
                    <h4 className="text-xs font-semibold text-neutral-900">
                      {rev.authorName}
                    </h4>
                    <p className="text-[11px] text-neutral-400">
                      {rev.routeAndDateText}
                    </p>
                  </div>
                </div>

                <div className="flex items-center gap-1 text-xs text-neutral-700 font-semibold">
                  <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                  <span>{rev.rating.toFixed(1).replace(".", ",")}</span>
                </div>
              </div>

              <p className="text-xs text-neutral-600 leading-relaxed pl-10.5">
                {rev.content}
              </p>
            </div>
          ))}
        </div>

        {/* Nút xem thêm */}
        {reviews.length > 5 && <div className="pt-2 flex justify-center">
          <button
            type="button"
            onClick={() => setExpanded(!expanded)}
            className="inline-flex items-center gap-1 text-xs text-neutral-700 hover:text-neutral-900 font-medium px-4 py-2 rounded-xl border border-neutral-200 bg-neutral-50 hover:bg-neutral-100 transition-colors"
          >
            <span>{expanded ? "Thu gọn" : "Xem thêm đánh giá"}</span>
            <ChevronDown className="w-3.5 h-3.5" />
          </button>
        </div>}
      </div>

      {/* Cột phải: Điều khoản dịch vụ */}
      <div className="lg:col-span-4 bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-4">
        <h3 className="text-lg/6 font-semibold text-vxn-ink">
          Điều khoản dịch vụ
        </h3>

        <div className="space-y-3.5 text-xs text-neutral-600">
          {terms.map((term) => (
            <div key={term} className="flex items-start gap-2">
              <Check className="mt-0.5 h-3.5 w-3.5 shrink-0 text-success-600" />
              <div className="min-w-0 flex-1"><MarkdownContent>{term}</MarkdownContent></div>
            </div>
          ))}
        </div>

        {!terms.length && <p className="text-sm text-neutral-500">Nhà xe chưa công bố điều khoản dịch vụ.</p>}
      </div>
    </div>
  );
}
