"use client";

import React from "react";
import Image from "next/image";
import { ArrowRight, Info, Ticket as TicketIcon } from "lucide-react";
import type { TicketPassengerDetail, TicketTripInfo } from "../../lib/data/types";

/**
 * Thuộc tính của BoardingPassCard
 */
export interface BoardingPassCardProps {
  readonly trip: TicketTripInfo;
  readonly tickets: readonly TicketPassengerDetail[];
  readonly activeTicketIndex: number;
  readonly bookingCode: string;
  readonly onSelectTicket: (index: number) => void;
}

/**
 * Thẻ vé điện tử mô phỏng Boarding Pass thực tế chuẩn theo Figma 1445:14456
 */
export const BoardingPassCard: React.FC<BoardingPassCardProps> = ({
  trip,
  tickets,
  activeTicketIndex,
  bookingCode,
  onSelectTicket
}) => {
  const currentTicket = tickets[activeTicketIndex] ?? tickets[0];
  // Figma tách điểm đi / điểm đến bằng mũi tên màu cam: routeName dạng "A → B"
  const [origin, destination] = trip.routeName.split("→").map((part) => part.trim());

  return (
    <div className="space-y-3">
      {/* Thanh tiêu đề Vé điện tử và các Tab chọn vé */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg/6 font-semibold text-vxn-ink">
          Vé điện tử ({tickets.length})
        </h2>

        {tickets.length > 1 && (
          <div className="flex items-center gap-1.5" role="tablist">
            {tickets.map((t, idx) => {
              const isActive = idx === activeTicketIndex;
              return (
                <button
                  key={t.ticketId}
                  type="button"
                  role="tab"
                  aria-selected={isActive}
                  onClick={() => onSelectTicket(idx)}
                  className={`px-3 py-1.5 text-xs font-semibold rounded-lg transition-all border ${
                    isActive
                      ? "bg-amber-100/80 dark:bg-amber-950/40 border-amber-400 text-amber-950 dark:text-amber-100 shadow-xs"
                      : "bg-background border-border text-muted-foreground hover:bg-muted/60"
                  }`}
                >
                  Vé {idx + 1} · Chỗ {t.seatCode}
                </button>
              );
            })}
          </div>
        )}
      </div>

      {/* Thẻ vé lên xe — kit Figma `VXN / Ticket pass` (1456:23853) */}
      <div className="relative overflow-hidden rounded-[18px] border border-[#f6c55e] bg-[linear-gradient(161.5deg,#fff6e2_0%,#ffe9c4_60%,#ffd9a0_100%)] shadow-[0_12px_30px_0_rgb(232_155_38/0.22)] lg:flex">
        {/* Ánh sáng góc phải */}
        <div aria-hidden="true" className="pointer-events-none absolute -top-[60px] -right-10 size-[200px] rounded-full bg-[radial-gradient(circle,rgb(243_177_50/0.5)_0%,rgb(243_177_50/0)_70%)]" />

        {/* Thông tin vé */}
        <div className="relative flex min-w-0 flex-1 flex-col gap-[18px] p-5 sm:p-7">
          <div className="flex items-center gap-3">
            <span className="flex size-11 shrink-0 items-center justify-center rounded-full bg-white text-[#9e6410] shadow-[0_1px_2px_0_rgb(0_0_0/0.06)]">
              <TicketIcon className="size-[22px]" />
            </span>
            <div className="min-w-0 flex-1">
              <p className="text-sm/5 font-semibold text-[#9e6410]">VÉ XE NHANH</p>
              <p className="truncate text-xs/[18px] text-vxn-fg-5">Vé chuyến · {trip.operatorName}</p>
            </div>
            <span className={`shrink-0 rounded-full px-3 py-1 text-xs/[18px] font-semibold uppercase text-white ${currentTicket?.status === "valid" ? "bg-success-600" : "bg-vxn-fg-5"}`}>
              {currentTicket?.statusLabel ?? (currentTicket?.status === "cancelled" ? "Đã hủy" : "Hợp lệ")}
            </span>
          </div>

          <div className="flex flex-wrap items-center gap-x-3.5 gap-y-1">
            <span className="text-2xl font-bold text-vxn-ink sm:text-[32px] sm:leading-[47px]">{origin}</span>
            {destination && (
              <>
                <ArrowRight className="size-6 shrink-0 text-vxn-saffron-600 sm:size-7" />
                <span className="text-2xl font-bold text-vxn-ink sm:text-[32px] sm:leading-[47px]">{destination}</span>
              </>
            )}
          </div>

          <p className="text-base/6 font-semibold text-foreground">
            {trip.departureDayOfWeek} · {trip.departureDateText}
          </p>

          <div className="flex flex-wrap items-center gap-4">
            <div className="flex flex-col gap-0.5 rounded-[10px] border border-[rgb(232_155_38/0.3)] bg-white px-5 py-2.5">
              <span className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">{trip.departureTime}</span>
              <span className="text-xs/[18px] text-vxn-fg-5">{trip.departurePointName}</span>
            </div>
            <ArrowRight className="size-5 shrink-0 text-vxn-saffron-600" />
            <div className="flex flex-col gap-0.5 rounded-[10px] border border-[rgb(232_155_38/0.3)] bg-white px-5 py-2.5">
              <span className="flex items-end gap-1.5">
                <span className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">{trip.arrivalTime}</span>
                {trip.arrivalNoticeText && <span className="pb-1.5 text-xs/[18px] font-medium text-warning-700">{trip.arrivalNoticeText}</span>}
              </span>
              <span className="text-xs/[18px] text-vxn-fg-5">{trip.arrivalPointName}</span>
            </div>
            <div className="ml-auto flex flex-col items-start gap-0.5 font-semibold sm:items-end">
              <span className="text-xs/[18px] uppercase text-vxn-fg-5">Thời gian di chuyển</span>
              <span className="text-sm/5 text-vxn-ink">{trip.travelDurationText}</span>
            </div>
          </div>

          {currentTicket && (
            <dl className="grid grid-cols-2 gap-x-9 gap-y-3 sm:flex sm:flex-wrap">
              {[
                ["Hành khách", currentTicket.passengerName],
                ["Chỗ", currentTicket.seatCode],
                ["Loại chỗ", currentTicket.seatType],
                ["Mã đặt vé", bookingCode]
              ].map(([label, value]) => (
                <div key={label} className="flex flex-col gap-0.5">
                  <dt className="text-xs/[18px] text-vxn-fg-5">{label}</dt>
                  <dd className="text-sm/5 font-semibold text-vxn-ink">{value}</dd>
                </div>
              ))}
            </dl>
          )}
        </div>

        {/* Cuống vé: mã QR */}
        <div className="relative flex shrink-0 flex-col items-center justify-center gap-2.5 border-t-[1.5px] border-dashed border-vxn-saffron-600 bg-white/70 p-6 lg:w-[260px] lg:border-t-0 lg:border-l-[1.5px]">
          <div className="flex size-[204px] items-center justify-center rounded-xl bg-white shadow-[0_1px_3px_0_rgb(0_0_0/0.08)]">
            {currentTicket?.qrCodeDataUrl ? (
              <Image src={currentTicket.qrCodeDataUrl} alt={`Mã QR vé ${currentTicket.ticketCode}`} width={180} height={180} unoptimized />
            ) : (
              <p className="px-4 text-center text-xs text-vxn-fg-5">Mã QR chưa khả dụng</p>
            )}
          </div>
          <p className="font-mono text-[13px]/[19.5px] font-semibold text-vxn-ink">{currentTicket?.ticketCode ?? trip.operatorCode}</p>
          <p className="text-xs/[18px] font-medium text-[#9e6410]">Lên xe quét mã</p>
        </div>

        {/* Khía răng cưa trên/dưới đường cắt cuống vé */}
        <div aria-hidden="true" className="absolute -top-[11px] right-[249px] hidden size-5 rounded-full bg-vxn-saffron-600 lg:block" />
        <div aria-hidden="true" className="absolute right-[249px] -bottom-[11px] hidden size-5 rounded-full bg-vxn-saffron-600 lg:block" />
      </div>

      {/* Dòng ghi chú bảo mật mã QR dưới thẻ vé */}
      <div className="flex items-center gap-2 text-xs text-muted-foreground pt-1">
        <Info className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
        <span>Mã QR chỉ có giá trị khi nhân viên nhà xe quét và xác thực trên hệ thống. Không chia sẻ mã cho người khác.</span>
      </div>
    </div>
  );
};
