"use client";

import { AlertCircle, Check } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { CheckoutStalePriceData } from "../../lib/data/types";

/**
 * Thuộc tính của component modal cảnh báo giá vé thay đổi.
 */
export interface CheckoutStalePriceModalProps {
  readonly isOpen: boolean;
  readonly stalePrice: CheckoutStalePriceData;
  readonly onDismiss?: () => void;
  readonly onAccept?: () => void;
}

/**
 * Hộp thoại cảnh báo giá vé vừa thay đổi theo Figma 1450:22911.
 */
export function CheckoutStalePriceModal({
  isOpen,
  stalePrice,
  onDismiss,
  onAccept
}: CheckoutStalePriceModalProps) {
  if (!isOpen) {
    return null;
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 flex items-center justify-center bg-[rgb(8_23_33/0.55)] p-4 animate-in fade-in-50 duration-200"
    >
      <div className="w-full max-w-md rounded-3xl bg-white p-6 sm:p-8 text-center shadow-2xl animate-in zoom-in-95 duration-200">
        {/* Icon cảnh báo */}
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-amber-500">
          <AlertCircle className="h-7 w-7" />
        </div>

        {/* Tiêu đề */}
        <h3 className="mt-4 text-lg sm:text-xl font-extrabold text-vxn-ink">
          Giá vé vừa thay đổi
        </h3>

        {/* Diễn giải */}
        <p className="mt-2 text-xs sm:text-sm text-vxn-fg-4 leading-relaxed">
          Nhà xe đã cập nhật giá cho chuyến này trước khi bạn xác nhận. Vui lòng xem lại tổng tiền mới.
        </p>

        {/* Bảng so sánh giá */}
        <div className="mt-5 rounded-2xl bg-neutral-50 p-4 text-xs space-y-2.5 text-left border border-neutral-100">
          <div className="flex items-center justify-between text-neutral-500">
            <span>Giá vé cũ (2 chỗ)</span>
            <span className="line-through">{formatVnd(stalePrice.oldPriceVnd)}</span>
          </div>

          <div className="flex items-center justify-between font-medium text-vxn-ink">
            <span>Giá vé mới (2 chỗ)</span>
            <span className="font-bold">{formatVnd(stalePrice.newPriceVnd)}</span>
          </div>

          <div className="flex items-center justify-between text-emerald-700">
            <span>Voucher đổi điểm</span>
            <span className="font-bold">-{formatVnd(stalePrice.discountVnd)}</span>
          </div>

          <div className="flex items-baseline justify-between border-t border-neutral-200/80 pt-3">
            <span className="font-bold text-vxn-ink text-sm">
              Tổng thanh toán mới
            </span>
            <span className="text-xl font-extrabold text-vxn-teal-800">
              {formatVnd(stalePrice.newTotalVnd)}
            </span>
          </div>
        </div>

        {/* 2 nút hành động */}
        <div className="mt-6 flex flex-col-reverse gap-2.5 sm:flex-row sm:items-center sm:justify-center">
          <button
            type="button"
            onClick={onDismiss}
            className="w-full sm:w-auto rounded-xl border border-neutral-300 bg-white px-5 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 cursor-pointer"
          >
            Quay lại
          </button>

          <button
            type="button"
            onClick={onAccept}
            className="flex w-full sm:w-auto items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-6 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
          >
            <Check className="h-4 w-4" />
            Đồng ý giá mới
          </button>
        </div>
      </div>
    </div>
  );
}
