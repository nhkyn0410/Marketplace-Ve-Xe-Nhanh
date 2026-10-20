"use client";

import { Info } from "lucide-react";
import { formatVnd } from "../../../lib/format";

import { TripCancellationTier } from "../../../lib/data/types";


/**
 * Thuộc tính của khối giá vé và chính sách.
 */
interface TripPricingPolicyProps {
  readonly priceSingleVnd: string;
  readonly priceDoubleVnd: string;
  readonly stopSalesTimeText: string;
  readonly cancellationPolicies: readonly TripCancellationTier[];
  readonly cancellationNote: string;
}

/**
 * Khối hiển thị chi tiết giá vé và chính sách hủy đổi (SCR-PSG-16).
 */
export function TripPricingPolicy({
  priceSingleVnd,
  priceDoubleVnd,
  stopSalesTimeText,
  cancellationPolicies,
  cancellationNote
}: TripPricingPolicyProps) {
  return (
    <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-6">
      <div className="space-y-4">
        <h3 className="text-base font-semibold text-neutral-900">
          Giá vé và chính sách
        </h3>

        {/* Bảng giá các loại chỗ */}
        <div className="space-y-2.5 text-xs">
          <div className="flex items-center justify-between py-1.5 border-b border-neutral-100">
            <span className="text-neutral-600">Giường đơn</span>
            <span className="font-bold text-neutral-900 text-sm">
              {formatVnd(priceSingleVnd)} / chỗ
            </span>
          </div>

          <div className="flex items-center justify-between py-1.5 border-b border-neutral-100">
            <span className="text-neutral-600">
              Giường đôi (1–2 người, bán nguyên chỗ)
            </span>
            <span className="font-bold text-neutral-900 text-sm">
              {formatVnd(priceDoubleVnd)} / chỗ
            </span>
          </div>

          <div className="flex items-center justify-between py-1.5 text-neutral-500">
            <span>Ngừng bán online</span>
            <span className="font-medium text-neutral-700">
              {stopSalesTimeText}
            </span>
          </div>
        </div>
      </div>

      {/* Chính sách hủy / hoàn tiền */}
      <div className="pt-4 border-t border-neutral-100 space-y-3.5">
        <h4 className="text-sm font-semibold text-neutral-900">
          Chính sách hủy / hoàn tiền của nhà xe
        </h4>

        <div className="space-y-2 text-xs">
          {cancellationPolicies.map((policy) => (
            <div
              key={policy.condition}
              className="flex items-center justify-between py-1.5 border-b border-neutral-50 last:border-0"
            >
              <span className="text-neutral-600">{policy.condition}</span>
              <span className="font-semibold text-neutral-900">
                {policy.refundPercentText}
              </span>
            </div>
          ))}
        </div>

        {/* Khung ghi chú pháp lý */}
        <div className="flex items-start gap-2.5 p-3 rounded-xl bg-blue-50/70 border border-blue-200/60 text-xs text-blue-900">
          <Info className="w-4 h-4 text-blue-600 shrink-0 mt-0.5" />
          <p className="leading-relaxed">{cancellationNote}</p>
        </div>
      </div>
    </div>
  );
}
