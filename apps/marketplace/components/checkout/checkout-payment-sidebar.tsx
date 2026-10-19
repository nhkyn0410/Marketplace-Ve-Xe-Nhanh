"use client";

import { ArrowLeft, Info, MapPin } from "lucide-react";
import Link from "next/link";
import { formatVnd } from "../../lib/format";
import {
  CheckoutPassengerItem,
  CheckoutPriceSummary,
  SeatLocationPoint
} from "../../lib/data/types";

/**
 * Thuộc tính của component tóm tắt thanh toán bên phải.
 */
export interface CheckoutPaymentSidebarProps {
  readonly tripId: string;
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly pickupPoint: SeatLocationPoint;
  readonly dropoffPoint: SeatLocationPoint;
  readonly passengers: readonly CheckoutPassengerItem[];
  readonly priceSummary: CheckoutPriceSummary;
  readonly onProceedToPayment?: () => void;
}

/**
 * Cột tóm tắt chuyến xe và thanh toán theo Figma 1444:12531.
 */
export function CheckoutPaymentSidebar({
  tripId,
  routeName,
  departureTimeText,
  operatorName,
  pickupPoint,
  dropoffPoint,
  passengers,
  priceSummary,
  onProceedToPayment
}: CheckoutPaymentSidebarProps) {
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
          {/* Lộ trình đón / trả */}
          <div className="flex items-start gap-2.5 border-b border-vxn-border/50 pb-4 text-xs text-vxn-fg-4">
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
          <div className="py-4 border-b border-vxn-border/50 space-y-2.5">
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
          <div className="py-4 border-b border-vxn-border/50 space-y-2 text-xs">
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

            {/* Giảm giá voucher (nếu có) */}
            {priceSummary.discountVnd !== "0" && (
              <div className="flex items-center justify-between text-emerald-700">
                <span>Voucher đổi điểm</span>
                <span className="font-bold">
                  -{formatVnd(priceSummary.discountVnd)}
                </span>
              </div>
            )}
          </div>

          {/* Tổng thanh toán */}
          <div className="flex items-baseline justify-between pt-4 pb-5">
            <span className="text-sm font-medium text-vxn-fg-3">
              Tổng thanh toán
            </span>
            <span className="text-xl sm:text-2xl font-black text-vxn-teal-800">
              {formatVnd(priceSummary.finalTotalVnd)}
            </span>
          </div>

          {/* Hành động */}
          <div className="space-y-2.5">
            <button
              type="button"
              onClick={onProceedToPayment}
              className="w-full rounded-xl bg-[#00506a] py-3 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] text-center cursor-pointer"
            >
              Tiếp tục thanh toán
            </button>

            <Link
              href={`/trips/${tripId}/seats`}
              className="flex w-full items-center justify-center gap-1.5 rounded-xl border border-neutral-300/90 bg-white py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 hover:border-neutral-400 text-center"
            >
              <ArrowLeft className="h-3.5 w-3.5" />
              Quay lại chọn chỗ
            </Link>
          </div>
        </div>
      </div>

      {/* Lưu ý chính sách hoàn hủy */}
      <div className="mt-3 flex items-start gap-2 rounded-xl bg-teal-50/50 p-3 text-xs text-vxn-teal-900 border border-teal-100">
        <Info className="h-4 w-4 shrink-0 text-vxn-teal-700 mt-0.5" />
        <p className="leading-relaxed">
          Chính sách hủy / hoàn tiền của chuyến được lưu cùng đơn tại thời điểm đặt.
        </p>
      </div>
    </aside>
  );
}
