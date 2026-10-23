"use client";

import { Lock, MapPin } from "lucide-react";
import { formatVnd } from "../../lib/format";
import {
  CheckoutPassengerItem,
  CheckoutPriceSummary,
  SeatLocationPoint,
  SupportedPaymentMethod
} from "../../lib/data/types";

/**
 * Thuộc tính của component tóm tắt thanh toán B3.
 */
export interface PaymentSummarySidebarProps {
  readonly bookingCode: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly pickupPoint: SeatLocationPoint;
  readonly dropoffPoint: SeatLocationPoint;
  readonly passengers: readonly CheckoutPassengerItem[];
  readonly priceSummary: CheckoutPriceSummary;
  readonly selectedPaymentMethod: SupportedPaymentMethod;
  readonly isAgreedTerms: boolean;
  readonly onPayNow?: () => void;
}

/**
 * Khối tóm tắt đơn và nút thanh toán theo Figma 1444:13055.
 */
export function PaymentSummarySidebar({
  bookingCode,
  routeName,
  departureTimeText,
  operatorName,
  pickupPoint,
  dropoffPoint,
  passengers,
  priceSummary,
  selectedPaymentMethod,
  isAgreedTerms,
  onPayNow
}: PaymentSummarySidebarProps) {
  const methodLabel = selectedPaymentMethod === "vnpay" ? "VNPay" : "MoMo";

  return (
    <aside className="w-full lg:w-[360px] xl:w-[380px] shrink-0 sticky top-6">
      <div className="overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs">
        {/* Header xanh đậm */}
        <div className="bg-[#00384a] p-4.5 text-white">
          <span className="text-[10px] font-bold uppercase tracking-wider text-teal-300">
            Chuyến đi
          </span>
          <h3 className="mt-1 text-base font-bold sm:text-lg">
            {routeName}
          </h3>
          <p className="mt-1 text-xs text-teal-100/75">
            {departureTimeText} • {operatorName}
          </p>
        </div>

        {/* Nội dung chi tiết */}
        <div className="p-4.5 sm:p-5">
          {/* Mã đặt vé */}
          <div className="flex items-center justify-between border-b border-vxn-border/50 pb-3.5">
            <div>
              <span className="text-[11px] text-vxn-fg-4 block">Mã đặt vé</span>
              <span className="font-black text-sm text-vxn-ink">
                {bookingCode}
              </span>
            </div>
            <span className="rounded-md bg-amber-50 px-2 py-0.5 text-[10px] font-bold text-amber-800">
              Chờ thanh toán
            </span>
          </div>

          {/* Lộ trình đón / trả */}
          <div className="flex items-start gap-2.5 border-b border-vxn-border/50 py-3.5 text-xs text-vxn-fg-4">
            <MapPin className="h-4 w-4 shrink-0 text-vxn-teal-700 mt-0.5" />
            <div className="min-w-0 flex-1 space-y-1">
              <div>
                Đón <span className="font-bold text-vxn-ink">{pickupPoint.time}</span> •{" "}
                <span className="text-vxn-fg-2">{pickupPoint.name}</span>
              </div>
              <div>
                Trả <span className="font-bold text-vxn-ink">{dropoffPoint.time}</span> •{" "}
                <span className="text-vxn-fg-2">{dropoffPoint.name}</span>
              </div>
            </div>
          </div>

          {/* Danh sách hành khách & chỗ */}
          <div className="py-3.5 border-b border-vxn-border/50 space-y-2.5">
            {passengers.map((p) => (
              <div
                key={p.seatCode}
                className="flex items-center justify-between gap-2 text-xs"
              >
                <div className="flex items-center gap-2 min-w-0">
                  <span className="flex h-6 w-7 shrink-0 items-center justify-center rounded-md bg-vxn-teal-900 font-bold text-white text-[11px]">
                    {p.seatCode}
                  </span>
                  <div className="min-w-0 truncate">
                    <div className="font-bold text-vxn-ink truncate">
                      {p.fullName || `Hành khách chỗ ${p.seatCode}`}
                    </div>
                    <div className="text-[11px] text-vxn-fg-4">
                      {p.seatTypeLabel} • {p.floorLabel}
                    </div>
                  </div>
                </div>
                <span className="font-bold text-vxn-ink whitespace-nowrap shrink-0">
                  {formatVnd(p.priceVnd)}
                </span>
              </div>
            ))}
          </div>

          {/* Chi tiết tính tiền theo quy tắc A3 #8 */}
          <div className="py-3.5 border-b border-vxn-border/50 space-y-2 text-xs">
            <div className="flex items-center justify-between">
              <span className="text-vxn-fg-3">
                Giá vé ({priceSummary.ticketCount} chỗ)
              </span>
              <span className="font-semibold text-vxn-ink">
                {formatVnd(priceSummary.ticketPriceTotalVnd)}
              </span>
            </div>

            {/* Phí dịch vụ */}
            <div className="flex items-center justify-between">
              <span className="text-vxn-fg-3">Phí dịch vụ</span>
              <span className="font-semibold text-vxn-ink">
                {formatVnd(priceSummary.serviceFeeVnd)}
              </span>
            </div>

            {/* Giảm giá voucher */}
            {priceSummary.discountVnd !== "0" && (
              <div className="flex items-center justify-between text-emerald-700">
                <span>{priceSummary.discountLabel}</span>
                <span className="font-bold">
                  -{formatVnd(priceSummary.discountVnd)}
                </span>
              </div>
            )}
          </div>

          {/* Tổng thanh toán */}
          <div className="flex items-baseline justify-between pt-3.5 pb-4">
            <span className="text-sm font-medium text-vxn-fg-3">
              Tổng thanh toán
            </span>
            <span className="text-xl sm:text-2xl font-black text-vxn-teal-800">
              {formatVnd(priceSummary.finalTotalVnd)}
            </span>
          </div>

          {/* Nút hành động */}
          <div className="space-y-3">
            <button
              type="button"
              disabled={!isAgreedTerms}
              onClick={onPayNow}
              className={`w-full rounded-xl py-3.5 text-sm font-bold text-white shadow-xs transition text-center ${
                isAgreedTerms
                  ? "bg-[#00506a] hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
                  : "bg-neutral-300 cursor-not-allowed"
              }`}
            >
              Thanh toán {formatVnd(priceSummary.finalTotalVnd)}
            </button>

            {/* Dòng bảo mật */}
            <div className="flex items-center justify-center gap-1.5 text-[11px] text-neutral-500">
              <Lock className="h-3 w-3 text-neutral-400" />
              <span>Thanh toán an toàn qua cổng {methodLabel}</span>
            </div>
          </div>
        </div>
      </div>
    </aside>
  );
}
