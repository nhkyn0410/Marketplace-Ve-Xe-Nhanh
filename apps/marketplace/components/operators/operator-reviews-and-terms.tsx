"use client";

import { useState } from "react";
import Link from "next/link";
import { Star, ChevronDown, Check, ChevronRight } from "lucide-react";
import { OperatorReviewItem } from "../../lib/data/types";

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

  return (
    <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
      {/* Cột trái: Đánh giá hành khách */}
      <div className="lg:col-span-8 bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
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
              Cao nhất
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
              Thấp nhất
            </button>
          </div>
        </div>

        {/* Danh sách bình luận */}
        <div className="space-y-4 pt-2 border-t border-neutral-100">
          {reviews.map((rev) => (
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
        <div className="pt-2 flex justify-center">
          <button
            type="button"
            onClick={() => setExpanded(!expanded)}
            className="inline-flex items-center gap-1 text-xs text-neutral-700 hover:text-neutral-900 font-medium px-4 py-2 rounded-xl border border-neutral-200 bg-neutral-50 hover:bg-neutral-100 transition-colors"
          >
            <span>Xem thêm đánh giá</span>
            <ChevronDown className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>

      {/* Cột phải: Điều khoản dịch vụ */}
      <div className="lg:col-span-4 bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-4">
        <h3 className="text-base font-semibold text-neutral-900">
          Điều khoản dịch vụ
        </h3>

        <div className="space-y-3.5 text-xs text-neutral-600">
          {terms.map((term) => (
            <div key={term} className="flex items-start gap-2.5">
              <Check className="w-4 h-4 text-emerald-600 shrink-0 mt-0.5" />
              <p className="leading-relaxed">{term}</p>
            </div>
          ))}
        </div>

        <div className="pt-2 border-t border-neutral-100">
          <Link
            href="/terms-of-service"
            className="text-xs font-semibold text-[#00506a] hover:underline flex items-center gap-0.5"
          >
            <span>Xem đầy đủ điều khoản</span>
            <ChevronRight className="w-3.5 h-3.5" />
          </Link>
        </div>
      </div>
    </div>
  );
}
