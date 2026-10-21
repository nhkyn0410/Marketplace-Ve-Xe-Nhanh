"use client";

import React from "react";
import Image from "next/image";
import { Badge } from "@vexenhanh/ui/components/badge";
import { ArrowRight, Info } from "lucide-react";
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

  return (
    <div className="space-y-3">
      {/* Thanh tiêu đề Vé điện tử và các Tab chọn vé */}
      <div className="flex items-center justify-between">
        <h2 className="text-base sm:text-lg font-bold text-foreground">
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

      {/* Thẻ vé chính Boarding Pass */}
      <div className="relative rounded-2xl border border-amber-300 bg-amber-50/50 dark:bg-amber-950/15 shadow-xs overflow-hidden">
        <div className="grid grid-cols-1 lg:grid-cols-12">
          {/* Cuống vé chính (Trái - 8 cột) */}
          <div className="lg:col-span-8 p-5 sm:p-6 space-y-4">
            {/* Header trong vé: Brand + Badge HỢP LỆ */}
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="flex h-7 w-7 items-center justify-center rounded-md bg-amber-500/20 text-amber-900 dark:text-amber-200 font-extrabold text-xs">
                  VXN
                </div>
                <div>
                  <div className="text-xs font-bold text-amber-950 dark:text-amber-200 uppercase tracking-wider">
                    VÉ XE NHANH
                  </div>
                  <div className="text-[11px] text-muted-foreground">
                    Vé chuyến · {trip.operatorName}
                  </div>
                </div>
              </div>

              <Badge tone={currentTicket?.status === "valid" ? "success" : "neutral"} className="font-bold text-[11px] tracking-wider px-2 py-0.5 rounded">
                {currentTicket?.statusLabel ?? (currentTicket?.status === "cancelled" ? "ĐÃ HỦY" : "HỢP LỆ")}
              </Badge>
            </div>

            {/* Tuyến đường & Ngày đi */}
            <div>
              <div className="text-xl sm:text-2xl font-black tracking-tight text-foreground flex items-center gap-2">
                <span>{trip.routeName}</span>
              </div>
              <div className="text-xs text-muted-foreground mt-0.5">
                {trip.departureDayOfWeek} · {trip.departureDateText}
              </div>
            </div>

            {/* Khung giờ đón/trả và thời lượng di chuyển */}
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pt-1">
              <div className="flex items-center gap-3">
                {/* Giờ đón */}
                <div className="bg-white dark:bg-muted/60 p-3 rounded-xl border border-amber-200/80 dark:border-amber-900/50 min-w-[140px]">
                  <div className="text-xl font-black text-foreground tracking-tight">
                    {trip.departureTime}
                  </div>
                  <div className="text-[11px] text-muted-foreground mt-0.5 line-clamp-1">
                    {trip.departurePointName}
                  </div>
                </div>

                <ArrowRight className="h-4 w-4 text-amber-600 dark:text-amber-400 shrink-0" />

                {/* Giờ đến */}
                <div className="bg-white dark:bg-muted/60 p-3 rounded-xl border border-amber-200/80 dark:border-amber-900/50 min-w-[140px]">
                  <div className="text-xl font-black text-foreground tracking-tight flex items-baseline gap-1.5">
                    <span>{trip.arrivalTime}</span>
                    <span className="text-[10px] font-bold text-amber-800 dark:text-amber-300 bg-amber-500/20 px-1 py-0.2 rounded">
                      {trip.arrivalNoticeText}
                    </span>
                  </div>
                  <div className="text-[11px] text-muted-foreground mt-0.5 line-clamp-1">
                    {trip.arrivalPointName}
                  </div>
                </div>
              </div>

              {/* Thời gian di chuyển */}
              <div className="sm:text-right">
                <div className="text-[10px] font-bold text-muted-foreground uppercase tracking-wider">
                  Thời gian di chuyển
                </div>
                <div className="text-xs font-bold text-foreground mt-0.5">
                  {trip.travelDurationText}
                </div>
              </div>
            </div>

            {/* 4 Cột thông tin chi tiết hành khách, chỗ, loại chỗ, mã đơn */}
            {currentTicket && (
              <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-4 border-t border-amber-200/80 dark:border-amber-900/40 text-xs">
                <div>
                  <div className="text-[11px] text-muted-foreground">Hành khách</div>
                  <div className="font-bold text-foreground mt-0.5">{currentTicket.passengerName}</div>
                </div>

                <div>
                  <div className="text-[11px] text-muted-foreground">Chỗ</div>
                  <div className="font-bold text-foreground mt-0.5">{currentTicket.seatCode}</div>
                </div>

                <div>
                  <div className="text-[11px] text-muted-foreground">Loại chỗ</div>
                  <div className="font-bold text-foreground mt-0.5">{currentTicket.seatType}</div>
                </div>

                <div>
                  <div className="text-[11px] text-muted-foreground">Mã đặt vé</div>
                  <div className="font-bold text-foreground mt-0.5">{bookingCode}</div>
                </div>
              </div>
            )}
          </div>

          {/* Cuống vé kiểm soát & QR Code (Phải - 4 cột) */}
          <div className="lg:col-span-4 relative border-t lg:border-t-0 lg:border-l border-dashed border-amber-300 dark:border-amber-900/60 p-5 sm:p-6 flex flex-col items-center justify-center text-center bg-amber-100/20 dark:bg-amber-950/10">
            {/* Vết khuyết răng cưa hình bán nguyệt trên màn hình lớn */}
            <div className="hidden lg:block absolute -top-3.5 -left-3.5 h-7 w-7 rounded-full bg-background border border-amber-300 dark:border-amber-900/60" />
            <div className="hidden lg:block absolute -bottom-3.5 -left-3.5 h-7 w-7 rounded-full bg-background border border-amber-300 dark:border-amber-900/60" />

            <div className="w-full max-w-[200px] space-y-3">
              {/* QR Code vector hiển thị rõ ràng */}
              <div className="p-3 bg-white rounded-xl shadow-xs border border-amber-200 inline-block">
                {currentTicket?.qrCodeDataUrl ? <Image src={currentTicket.qrCodeDataUrl} alt={`Mã QR vé ${currentTicket.ticketCode}`} width={160} height={160} unoptimized /> : <p className="text-xs text-muted-foreground">Mã QR chưa khả dụng</p>}
              </div>

              <div className="space-y-1">
                <div className="font-mono text-xs font-bold text-foreground">
                  {currentTicket?.ticketCode ?? trip.operatorCode}
                </div>
                <div className="text-[11px] text-amber-900 dark:text-amber-300 font-medium">
                  Lên xe quét mã
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Dòng ghi chú bảo mật mã QR dưới thẻ vé */}
      <div className="flex items-center gap-2 text-xs text-muted-foreground pt-1">
        <Info className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
        <span>Mã QR chỉ có giá trị khi nhân viên nhà xe quét và xác thực trên hệ thống. Không chia sẻ mã cho người khác.</span>
      </div>
    </div>
  );
};
