"use client";

import { OperatorQualityMetrics } from "../../lib/data/types";

interface OperatorMetricsProps {
  readonly metrics: OperatorQualityMetrics;
}

/**
 * Khối hiển thị 4 chỉ số chất lượng vận hành nhà xe (SCR-PSG-17).
 */
export function OperatorMetrics({ metrics }: OperatorMetricsProps) {
  return (
    <div className="space-y-3.5">
      <div>
        <h2 className="text-base font-semibold text-neutral-900">
          Chỉ số chất lượng
        </h2>
        <p className="text-xs text-neutral-500 mt-0.5">
          Tính từ đánh giá và dữ liệu vận hành trên Vé Xe Nhanh. Chỉ số thiếu dữ liệu được ghi rõ.
        </p>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Card 1: Đánh giá trung bình */}
        <div className="bg-white rounded-2xl border border-neutral-200 p-5 shadow-xs space-y-2">
          <span className="text-xs text-neutral-500 font-medium block">
            Đánh giá trung bình
          </span>
          <div className="text-2xl font-bold text-neutral-900 tracking-tight">
            {metrics.ratingAverageText}
          </div>
          <p className="text-[11px] text-neutral-400">
            {metrics.ratingTotalText}
          </p>
        </div>

        {/* Card 2: Hủy chuyến do nhà xe */}
        <div className="bg-white rounded-2xl border border-neutral-200 p-5 shadow-xs space-y-2">
          <span className="text-xs text-neutral-500 font-medium block">
            Hủy chuyến do nhà xe
          </span>
          <div className="text-2xl font-bold text-neutral-900 tracking-tight">
            {metrics.cancellationRateText}
          </div>
          <p className="text-[11px] text-neutral-400">
            {metrics.cancellationRatePeriod}
          </p>
        </div>

        {/* Card 3: Đơn có hoàn tiền / tranh chấp */}
        <div className="bg-white rounded-2xl border border-neutral-200 p-5 shadow-xs space-y-2">
          <span className="text-xs text-neutral-500 font-medium block">
            Đơn có hoàn tiền / tranh chấp
          </span>
          <div className="text-2xl font-bold text-neutral-900 tracking-tight">
            {metrics.refundDisputeRateText}
          </div>
          <p className="text-[11px] text-neutral-400">
            {metrics.refundDisputePeriod}
          </p>
        </div>

        {/* Card 4: Tỷ lệ check-in */}
        <div className="bg-white rounded-2xl border border-neutral-200 p-5 shadow-xs space-y-2">
          <span className="text-xs text-neutral-500 font-medium block">
            Tỷ lệ check-in
          </span>
          <div className="text-lg font-bold text-neutral-400 tracking-tight pt-1">
            {metrics.checkinRateText}
          </div>
          <p className="text-[11px] text-neutral-400">
            {metrics.checkinRateNote}
          </p>
        </div>
      </div>
    </div>
  );
}
