"use client";

import { ArrowLeft, MapPin, AlertTriangle } from "lucide-react";
import Link from "next/link";
import { formatVnd } from "../../lib/format";
import { SelectedSeatDetail } from "../../lib/data/types";

/**
 * Thuộc tính của component tóm tắt chuyến xe và ghế chọn bên phải.
 */
export interface SeatSelectionSidebarProps {
  readonly routeName: string;
  readonly departureTimeText: string;
  readonly operatorName: string;
  readonly pickupPointName: string;
  readonly pickupTime: string;
  readonly dropoffPointName: string;
  readonly dropoffTime: string;
  readonly selectedSeatsSummary: readonly SelectedSeatDetail[];
  readonly subtotalVnd: string;
  readonly onClearSelection?: () => void;
  readonly onContinue?: () => void;
  /** Lỗi giữ chỗ hiển thị ngay trên nút Tiếp tục (trên mobile nút nằm cuối trang). */
  readonly errorMessage?: string | null;
  readonly isSubmitting?: boolean;
}

/**
 * Khối tóm tắt thông tin đặt vé và nút tiếp tục theo Figma 1443:12719.
 */
export function SeatSelectionSidebar({
  routeName,
  departureTimeText,
  operatorName,
  pickupPointName,
  pickupTime,
  dropoffPointName,
  dropoffTime,
  selectedSeatsSummary,
  subtotalVnd,
  onClearSelection,
  onContinue,
  errorMessage,
  isSubmitting = false
}: SeatSelectionSidebarProps) {
  const hasSeats = selectedSeatsSummary.length > 0;

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
                Đón <span className="font-bold text-vxn-ink">{pickupTime}</span> •{" "}
                <span className="text-vxn-fg-2">{pickupPointName}</span>
              </div>
              <div>
                Trả <span className="font-bold text-vxn-ink">{dropoffTime}</span> (+1 ngày) •{" "}
                <span className="text-vxn-fg-2">{dropoffPointName}</span>
              </div>
            </div>
          </div>

          {/* Danh sách chỗ đã chọn */}
          <div className="py-4 border-b border-vxn-border/50">
            <div className="flex items-center justify-between">
              <span className="text-xs font-bold text-vxn-ink">
                Chỗ đã chọn ({selectedSeatsSummary.length})
              </span>
              {hasSeats && (
                <button
                  type="button"
                  onClick={onClearSelection}
                  className="text-xs font-semibold text-vxn-teal-800 hover:underline cursor-pointer"
                >
                  Bỏ chọn
                </button>
              )}
            </div>

            {hasSeats ? (
              <div className="mt-3 space-y-2.5">
                {selectedSeatsSummary.map((seat) => (
                  <div
                    key={seat.id}
                    className="flex items-center justify-between gap-2 text-xs"
                  >
                    <div className="flex items-center gap-2">
                      <span className="flex h-6 w-7 items-center justify-center rounded-md bg-vxn-teal-900 font-bold text-white text-[11px]">
                        {seat.code}
                      </span>
                      <span className="text-vxn-fg-3">
                        {seat.seatTypeLabel} • {seat.floorLabel}
                      </span>
                    </div>
                    <span className="font-bold text-vxn-ink whitespace-nowrap">
                      {formatVnd(seat.priceVnd)}
                    </span>
                  </div>
                ))}
              </div>
            ) : (
              <p className="mt-3 text-xs italic text-neutral-400">
                Vui lòng chọn ít nhất một chỗ trên sơ đồ.
              </p>
            )}
          </div>

          {/* Tạm tính */}
          <div className="flex items-baseline justify-between pt-4 pb-5">
            <span className="text-sm font-medium text-vxn-fg-3">Tạm tính</span>
            <span className="text-xl sm:text-2xl font-extrabold text-vxn-ink">
              {formatVnd(subtotalVnd)}
            </span>
          </div>

          {/* Hành động */}
          <div className="space-y-2.5">
            {errorMessage && (
              <div role="alert" className="flex items-start gap-2 rounded-xl border border-amber-200 bg-amber-50 p-3 text-xs font-semibold text-amber-800">
                <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
                <span>{errorMessage}</span>
              </div>
            )}
            <button
              type="button"
              disabled={!hasSeats || isSubmitting}
              aria-busy={isSubmitting}
              onClick={onContinue}
              className={`w-full rounded-xl py-3 text-sm font-bold text-white shadow-xs transition text-center ${
                hasSeats && !isSubmitting
                  ? "bg-[#00506a] hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
                  : hasSeats
                    ? "bg-[#00506a]/70 cursor-wait"
                    : "bg-neutral-300 cursor-not-allowed"
              }`}
            >
              {isSubmitting ? "Đang giữ chỗ..." : "Tiếp tục"}
            </button>

            <Link
              href="/trips"
              className="flex w-full items-center justify-center gap-1.5 rounded-xl border border-neutral-300/90 bg-white py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 hover:border-neutral-400 text-center"
            >
              <ArrowLeft className="h-3.5 w-3.5" />
              Đổi chuyến khác
            </Link>
          </div>
        </div>
      </div>
    </aside>
  );
}
