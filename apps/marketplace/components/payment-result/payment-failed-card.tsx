"use client";

import Link from "next/link";
import { useState } from "react";
import { X, CreditCard, RefreshCw, Hourglass, Search } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { BookingPaymentResultData } from "../../lib/data/types";

/**
 * Thuộc tính của component thẻ trạng thái thanh toán thất bại (SCR-PSG-23).
 */
export interface PaymentFailedCardProps {
  readonly result: BookingPaymentResultData;
  readonly onRetryPayment?: () => void;
}

/**
 * Card trạng thái Thanh toán chưa thành công theo Figma 1444:14189.
 */
export function PaymentFailedCard({
  result,
  onRetryPayment
}: PaymentFailedCardProps) {
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleRetry = () => {
    setErrorMessage(null);
    console.warn(`[marketplace] chưa có API: POST /bookings/${result.bookingId}/payments`);
    setErrorMessage("Cổng thanh toán chưa sẵn sàng trong môi trường thử nghiệm (chưa có API: POST /bookings/{bookingId}/payments).");
    onRetryPayment?.();
  };

  return (
    <div className="mx-auto max-w-2xl rounded-3xl border border-vxn-border bg-white p-6 sm:p-10 shadow-xs text-center space-y-6">
      {/* Icon lỗi X đỏ */}
      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-rose-50 text-rose-600">
        <div className="flex h-10 w-10 items-center justify-center rounded-full border-2 border-rose-600">
          <X className="h-6 w-6 stroke-[3]" />
        </div>
      </div>

      {/* Tiêu đề & diễn giải */}
      <div>
        <h2 className="text-xl sm:text-2xl font-black text-vxn-ink">
          Thanh toán chưa thành công
        </h2>
        <p className="mt-2.5 text-xs sm:text-sm text-vxn-fg-4 max-w-lg mx-auto leading-relaxed">
          Cổng {result.paymentMethodLabel} báo giao dịch không hoàn tất nên đơn chưa được thanh toán. Chỗ của bạn vẫn đang được giữ trong thời gian còn lại.
        </p>
      </div>

      {/* Thông báo lỗi tại chỗ nếu bấm thanh toán lại */}
      {errorMessage && (
        <div className="rounded-xl border border-rose-200 bg-rose-50 p-3 text-xs sm:text-sm text-rose-700 text-left">
          {errorMessage}
        </div>
      )}

      {/* Bảng chi tiết lý do và mã đơn */}
      <div className="rounded-2xl bg-neutral-50/80 p-5 border border-neutral-100 text-xs sm:text-sm space-y-3.5 text-left">
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Mã đặt vé</span>
          <span className="font-bold text-vxn-ink">{result.bookingCode}</span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Số tiền</span>
          <span className="font-bold text-vxn-ink">{formatVnd(result.amountVnd)}</span>
        </div>
        <div className="flex items-center justify-between gap-4">
          <span className="text-vxn-fg-4 shrink-0">Lý do</span>
          <span className="font-medium text-vxn-ink text-right">
            {result.failureReason ?? "Giao dịch bị hủy trên cổng thanh toán"}
          </span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Trạng thái</span>
          <span className="inline-flex items-center rounded-md bg-rose-50 px-2.5 py-1 text-xs font-bold text-rose-700 border border-rose-200/60">
            Thất bại
          </span>
        </div>
      </div>

      {/* 2 nút hành động chính */}
      <div className="flex flex-col sm:flex-row items-center justify-center gap-3 pt-2">
        <Link
          href={`/bookings/${result.bookingId}/payment`}
          className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl border border-neutral-300 bg-white px-5 py-2.5 text-xs sm:text-sm font-semibold text-neutral-800 transition hover:bg-neutral-50 active:scale-[0.99]"
        >
          <CreditCard className="h-4 w-4" />
          <span>Đổi phương thức</span>
        </Link>
        <button
          type="button"
          onClick={handleRetry}
          className="inline-flex w-full sm:w-auto items-center justify-center gap-2 rounded-xl bg-[#00506a] px-6 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
        >
          <RefreshCw className="h-4 w-4" />
          <span>Thanh toán lại</span>
        </button>
      </div>

      {/* Link tìm chuyến khác */}
      <div>
        <Link
          href="/trips"
          className="inline-flex items-center gap-1.5 text-xs sm:text-sm font-semibold text-vxn-teal-800 hover:underline"
        >
          <Search className="h-3.5 w-3.5" />
          <span>Tìm chuyến khác</span>
        </Link>
      </div>

      {/* Cảnh báo hết giờ giữ chỗ */}
      <div className="flex items-start gap-2.5 rounded-2xl bg-amber-50/70 p-4 text-left text-xs sm:text-sm text-amber-900 border border-amber-200/60">
        <Hourglass className="h-4 w-4 shrink-0 text-amber-600 mt-0.5" />
        <p className="leading-relaxed">
          Khi hết thời gian giữ chỗ, đơn sẽ hết hạn, chỗ được nhả và voucher (nếu có) trở về ví.
        </p>
      </div>
    </div>
  );
}
