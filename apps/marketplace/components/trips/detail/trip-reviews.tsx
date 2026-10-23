"use client";

import Link from "next/link";
import { Star, ChevronRight, ArrowRight } from "lucide-react";
import { TripDetailData } from "../../../lib/data/types";


/**
 * Thuộc tính của khối đánh giá và tóm tắt nhà xe.
 */
interface TripReviewsProps {
  readonly trip: TripDetailData;
}

/**
 * Khối hiển thị đánh giá từ hành khách và thẻ tóm tắt nhà xe (SCR-PSG-16).
 */
export function TripReviews({ trip }: TripReviewsProps) {
  return (
    <div className="space-y-6">
      {/* Khối đánh giá hành khách */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
        <div className="flex items-center justify-between">
          <h3 className="text-base font-semibold text-neutral-900">
            Đánh giá nhà xe
          </h3>
          <Link
            href={`/operators/${trip.operatorId}#reviews`}
            className="text-xs text-[#00506a] hover:underline font-medium flex items-center gap-0.5"
          >
            <span>Xem tất cả</span>
            <ChevronRight className="w-3.5 h-3.5" />
          </Link>
        </div>

        {/* Điểm trung bình và số lượng */}
        <div className="flex items-center gap-3">
          <span className="text-3xl font-extrabold text-neutral-900 tracking-tight">
            {trip.reviewsAverage > 0 ? trip.reviewsAverage.toFixed(1).replace(".", ",") : "—"}
          </span>
          <div className="space-y-0.5">
            <div className="flex items-center gap-1">
              {(trip.reviewsAverage > 0 ? [1, 2, 3, 4, 5] : []).map((star) => (
                <Star
                  key={star}
                  className={`w-4 h-4 ${star <= Math.round(trip.reviewsAverage) ? "fill-amber-400 text-amber-400" : "text-neutral-300"}`}
                />
              ))}
            </div>
            <p className="text-xs text-neutral-500 font-medium">
              {trip.reviewsCountText}
            </p>
          </div>
        </div>

        {/* Danh sách bình luận */}
        <div className="space-y-4 pt-2 border-t border-neutral-100">
          {!trip.reviews.length && <p className="text-sm text-neutral-500">Chưa có đánh giá để hiển thị.</p>}
          {trip.reviews.map((rev) => (
            <div
              key={rev.id}
              className="space-y-2 pb-4 border-b border-neutral-100 last:border-0 last:pb-0"
            >
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2.5">
                  <div className="w-7 h-7 rounded-full bg-neutral-100 border border-neutral-200 text-neutral-700 font-semibold text-xs flex items-center justify-center">
                    {rev.authorInitial}
                  </div>
                  <div>
                    <h5 className="text-xs font-semibold text-neutral-900">
                      {rev.authorName}
                    </h5>
                    <p className="text-[11px] text-neutral-400">
                      {rev.travelDateText}
                    </p>
                  </div>
                </div>

                <div className="flex items-center gap-1 text-xs text-neutral-700 font-semibold">
                  <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />
                  <span>{rev.rating.toFixed(1)}</span>
                </div>
              </div>

              <p className="text-xs text-neutral-600 leading-relaxed pl-9.5">
                {rev.content}
              </p>
            </div>
          ))}
        </div>
      </div>

      {/* Thẻ tóm tắt nhà xe ở chân trang */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-11 h-11 rounded-xl bg-[#00506a] text-white flex items-center justify-center font-bold text-sm shrink-0">
            {trip.operatorCode}
          </div>
          <div>
            <h4 className="text-sm font-semibold text-neutral-900">
              {trip.operatorName}
            </h4>
            <p className="text-xs text-neutral-500 mt-0.5">
              {trip.operatorDescription}
            </p>
          </div>
        </div>

        <Link
          href={`/operators/${trip.operatorId}`}
          className="inline-flex items-center justify-center gap-1.5 px-4 py-2 rounded-xl border border-neutral-300 text-xs font-medium text-neutral-700 hover:bg-neutral-50 hover:text-neutral-900 transition-colors shrink-0"
        >
          <span>Xem trang nhà xe</span>
          <ArrowRight className="w-3.5 h-3.5" />
        </Link>
      </div>
    </div>
  );
}
