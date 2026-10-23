"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Loader2, RefreshCw, Info } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { BookingPaymentResultData } from "../../lib/data/types";
import Link from "next/link";

/**
 * Thuộc tính của component thẻ trạng thái chờ xác nhận thanh toán (SCR-PSG-21).
 */
export interface PaymentProcessingCardProps {
  readonly result: BookingPaymentResultData;
  readonly onRefreshCheck?: () => void;
}

/**
 * Card trạng thái Đang chờ cổng thanh toán xác nhận theo Figma 1444:13464.
 */
export function PaymentProcessingCard({
  result,
  onRefreshCheck
}: PaymentProcessingCardProps) {
  const router = useRouter();
  const [countdown, setCountdown] = useState(5);
  const [isChecking, setIsChecking] = useState(false);

  useEffect(() => {
    if (countdown <= 0) {
      router.refresh();
      setCountdown(5);
      return;
    }
    const timer = setInterval(() => {
      setCountdown((prev) => (prev > 0 ? prev - 1 : 5));
    }, 1000);
    return () => clearInterval(timer);
  }, [countdown, router]);

  const handleManualCheck = () => {
    setIsChecking(true);
    router.refresh();
    setTimeout(() => {
      setIsChecking(false);
      setCountdown(5);
      onRefreshCheck?.();
    }, 600);
  };

  return (
    <div className="mx-auto max-w-2xl rounded-3xl border border-vxn-border bg-white p-6 sm:p-10 shadow-xs text-center">
      {/* Icon loading vòng xoay */}
      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-teal-50 text-vxn-teal-800">
        <Loader2 className="h-8 w-8 animate-spin" />
      </div>

      {/* Tiêu đề & mô tả */}
      <h2 className="mt-5 text-xl sm:text-2xl font-black text-vxn-ink">
        Đang kiểm tra đơn đặt vé
      </h2>
      <p className="mt-2.5 text-xs sm:text-sm text-vxn-fg-4 max-w-lg mx-auto leading-relaxed">
        {result.processingMessage ?? "Hệ thống tự kiểm tra kết quả và hiển thị vé khi thanh toán được xác nhận, vé được phát hành."}
      </p>

      {/* Bảng chi tiết đơn hàng */}
      <div className="mt-6 rounded-2xl bg-neutral-50/80 p-5 border border-neutral-100 text-xs sm:text-sm space-y-3.5 text-left">
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Mã đặt vé</span>
          <span className="font-bold text-vxn-ink">{result.bookingCode}</span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Phương thức</span>
          <span className="font-semibold text-vxn-ink">{result.paymentMethodLabel}</span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Số tiền</span>
          <span className="font-bold text-vxn-ink">{formatVnd(result.amountVnd)}</span>
        </div>
        <div className="flex items-center justify-between">
          <span className="text-vxn-fg-4">Trạng thái</span>
          <span className="inline-flex items-center rounded-md bg-amber-50 px-2.5 py-1 text-xs font-bold text-amber-700 border border-amber-200/60">
            Đang xử lý
          </span>
        </div>
      </div>
      {result.canRetryPayment && <Link href={`/bookings/${result.bookingId}/payment`} className="mt-5 inline-block rounded-xl bg-teal-900 px-5 py-2.5 text-sm font-semibold text-white">Tiếp tục thanh toán</Link>}

      {/* Hàng đếm ngược và nút kiểm tra */}
      <div className="mt-6 flex flex-col sm:flex-row items-center justify-center gap-3">
        <span className="text-xs sm:text-sm text-vxn-fg-4">
          Tự kiểm tra lại sau {countdown} giây
        </span>
        <button
          type="button"
          onClick={handleManualCheck}
          disabled={isChecking}
          className="inline-flex items-center justify-center gap-2 rounded-xl border border-neutral-300 bg-white px-4 py-2 text-xs sm:text-sm font-semibold text-neutral-800 transition hover:bg-neutral-50 active:scale-[0.99] disabled:opacity-60 cursor-pointer"
        >
          <RefreshCw className={`h-4 w-4 ${isChecking ? "animate-spin text-vxn-teal-800" : ""}`} />
          <span>Kiểm tra lại ngay</span>
        </button>
      </div>

      {/* Box thông báo đối soát */}
      <div className="mt-6 flex items-start gap-2.5 rounded-2xl bg-teal-50/60 p-4 text-left text-xs sm:text-sm text-vxn-teal-900 border border-teal-100">
        <Info className="h-4 w-4 shrink-0 text-vxn-teal-700 mt-0.5" />
        <p className="leading-relaxed">
          Nếu tài khoản đã bị trừ tiền nhưng chưa có vé, giao dịch sẽ được đối soát và kết quả gửi qua email liên hệ của đơn.
        </p>
      </div>
    </div>
  );
}
