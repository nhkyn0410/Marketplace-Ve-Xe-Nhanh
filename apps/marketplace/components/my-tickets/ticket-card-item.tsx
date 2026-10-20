"use client";

import Link from "next/link";
import { Clock, QrCode, CreditCard } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { MyTicketItem } from "../../lib/data/types";

export interface TicketCardItemProps {
  readonly ticket: MyTicketItem;
  readonly onCancelClick?: (ticket: MyTicketItem) => void;
}

/**
 * Định dạng số giây thành chuỗi MM:SS.
 */
function formatCountdown(totalSeconds: number): string {
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
}

/**
 * Thẻ vé đơn lẻ trong danh sách Hành trình của tôi theo Figma 1445:14030.
 */
export function TicketCardItem({ ticket, onCancelClick }: TicketCardItemProps) {
  const isPending = ticket.status === "pending_payment";

  const handleCancel = () => {
    console.warn(`[marketplace] chưa có API: POST /bookings/${ticket.bookingCode}/cancel`);
    onCancelClick?.(ticket);
  };

  return (
    <div className="flex flex-col gap-5 rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs md:flex-row md:items-center md:justify-between">
      {/* Khối bên trái: Ngày tháng + Thông tin lộ trình */}
      <div className="flex items-start gap-4 sm:gap-6">
        {/* Hộp ngày tháng */}
        <div className="flex h-20 w-16 shrink-0 flex-col items-center justify-center rounded-2xl bg-neutral-50 border border-neutral-200/70 text-center">
          <span className="text-[11px] font-medium text-neutral-500">
            {ticket.departureDayOfWeek}
          </span>
          <span className="text-2xl font-black text-vxn-ink leading-tight">
            {ticket.departureDay}
          </span>
          <span className="text-[10px] text-neutral-400">
            {ticket.departureMonth}
          </span>
        </div>

        {/* Thông tin chuyến */}
        <div className="space-y-1.5">
          <div className="flex flex-wrap items-center gap-2">
            <h3 className="text-base sm:text-lg font-bold text-vxn-ink">
              {ticket.routeName}
            </h3>

            {isPending ? (
              <div className="flex flex-wrap items-center gap-1.5">
                <span className="inline-flex items-center rounded-full bg-amber-50 px-2.5 py-0.5 text-xs font-bold text-amber-700 border border-amber-200">
                  Chờ thanh toán
                </span>
                {typeof ticket.holdCountdownSeconds === "number" && (
                  <span className="inline-flex items-center gap-1 rounded-full bg-neutral-100 px-2 py-0.5 text-[11px] text-neutral-600">
                    <Clock className="h-3 w-3 text-neutral-500" />
                    <span>Giữ ghế còn {formatCountdown(ticket.holdCountdownSeconds)}</span>
                  </span>
                )}
              </div>
            ) : (
              <span className="inline-flex items-center rounded-full bg-emerald-50 px-2.5 py-0.5 text-xs font-bold text-emerald-700 border border-emerald-200">
                Hợp lệ
              </span>
            )}
          </div>

          <p className="text-xs sm:text-sm text-vxn-fg-4">
            {ticket.departureTimeText} – {ticket.arrivalTimeText} · {ticket.operatorName} · {ticket.vehicleType}
          </p>

          <div className="flex flex-wrap items-center gap-3 text-xs text-neutral-500 pt-0.5">
            <span>Mã đặt vé <strong className="text-vxn-ink font-semibold">{ticket.bookingCode}</strong></span>
            <span>·</span>
            <span>{ticket.ticketCount} vé · {ticket.seatCodesText}</span>
            <span>·</span>
            <span>{ticket.pickupPointName}</span>
          </div>
        </div>
      </div>

      {/* Khối bên phải: Giá tiền và Nút thao tác */}
      <div className="flex flex-col sm:items-end gap-3 shrink-0 pt-2 md:pt-0 border-t md:border-t-0 border-neutral-100">
        <span className="text-lg sm:text-xl font-black text-vxn-ink">
          {formatVnd(ticket.totalAmountVnd)}
        </span>

        <div className="flex items-center gap-2.5">
          <button
            type="button"
            onClick={handleCancel}
            className="rounded-xl px-3 py-2 text-xs sm:text-sm font-semibold text-neutral-600 hover:bg-neutral-100 hover:text-neutral-900 transition cursor-pointer"
          >
            {isPending ? "Hủy đơn" : "Hủy vé"}
          </button>

          {isPending ? (
            <Link
              href={ticket.paymentUrl ?? `/bookings/${ticket.id}/payment`}
              className="inline-flex items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-4 py-2 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
            >
              <CreditCard className="h-4 w-4" />
              <span>Tiếp tục thanh toán</span>
            </Link>
          ) : (
            <Link
              href={`/my-tickets/${ticket.id}`}
              className="inline-flex items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-4 py-2 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
            >
              <QrCode className="h-4 w-4" />
              <span>Xem vé</span>
            </Link>
          )}
        </div>
      </div>
    </div>
  );
}
