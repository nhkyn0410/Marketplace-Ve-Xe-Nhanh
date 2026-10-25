"use client";

import Link from "next/link";
import { Clock, RefreshCw, Search } from "lucide-react";

/**
 * Thuộc tính của component modal thông báo hết hạn giữ chỗ thanh toán.
 */
export interface PaymentExpiredModalProps {
  readonly isOpen: boolean;
  readonly bookingCode: string;
  readonly seats: readonly string[];
  readonly tripId?: string;
}

/**
 * Modal hiển thị khi phiên giữ chỗ / thanh toán hết hạn (Figma 1450:23099).
 */
export function PaymentExpiredModal({
  isOpen,
  bookingCode,
  seats,
  tripId = "trip-dalat-pn01",
}: PaymentExpiredModalProps) {
  if (!isOpen) {
    return null;
  }

  const seatText = seats.join(", ");

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-xs animate-in fade-in-50 duration-200"
    >
      <div className="w-full max-w-md rounded-3xl bg-white p-6 sm:p-8 text-center shadow-2xl animate-in zoom-in-95 duration-200">
        {/* Icon cảnh báo / hết giờ */}
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-amber-600">
          <Clock className="h-7 w-7" />
        </div>

        {/* Badge báo hết thời gian */}
        <div className="mt-4 inline-flex items-center gap-1.5 rounded-full bg-rose-50 px-3 py-1 text-xs font-bold text-rose-600">
          <span>Đã hết thời gian giữ ghế</span>
          <span className="font-mono">00:00</span>
        </div>

        {/* Tiêu đề */}
        <h3 className="mt-3 text-lg sm:text-xl font-extrabold text-vxn-ink">
          Đã hết thời gian giữ chỗ
        </h3>

        {/* Diễn giải chi tiết */}
        <p className="mt-2 text-xs sm:text-sm text-vxn-fg-4 leading-relaxed">
          Đơn <strong className="text-vxn-ink font-semibold">{bookingCode}</strong> đã hết hạn nên chỗ{" "}
          <strong className="text-vxn-ink font-semibold">{seatText}</strong> được nhả cho hành khách khác. Voucher đã chọn trở về ví của bạn.
        </p>

        {/* 2 nút điều hướng hành động */}
        <div className="mt-6 flex flex-col-reverse gap-2.5 sm:flex-row sm:items-center sm:justify-center">
          <Link
            href="/trips"
            className="inline-flex w-full sm:w-auto items-center justify-center gap-1.5 rounded-xl border border-neutral-300 bg-white px-5 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50"
          >
            <Search className="h-4 w-4" />
            <span>Tìm chuyến khác</span>
          </Link>

          <Link
            href={`/trips/${tripId}/seats`}
            className="inline-flex w-full sm:w-auto items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-6 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
          >
            <RefreshCw className="h-4 w-4" />
            <span>Chọn lại chỗ</span>
          </Link>
        </div>
      </div>
    </div>
  );
}
