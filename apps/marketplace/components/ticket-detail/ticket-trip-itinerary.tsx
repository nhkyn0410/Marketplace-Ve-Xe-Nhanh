import React from "react";
import Link from "next/link";
import { ChevronRight } from "lucide-react";
import type { TicketTripInfo } from "../../lib/data/types";

/**
 * Thuộc tính của TicketTripItinerary
 */
export interface TicketTripItineraryProps {
  readonly trip: TicketTripInfo;
}

/**
 * Khối hiển thị chi tiết hành trình di chuyển và điểm đón/trả chuẩn Figma 1445:14456
 */
export const TicketTripItinerary: React.FC<TicketTripItineraryProps> = ({ trip }) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-4">
      {/* Tiêu đề khối & Header nhà xe */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-3 border-b border-border/50">
        <div className="flex items-center gap-3">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-teal-900 text-white font-bold text-xs tracking-wider">
            {trip.operatorCode}
          </div>
          <div>
            <h3 className="text-base font-bold text-foreground">
              {trip.routeName}
            </h3>
            <p className="text-xs text-muted-foreground mt-0.5">
              {trip.operatorName} · {trip.departureDayOfWeek}, {trip.departureDateText}
            </p>
          </div>
        </div>

        <Link
          href={`/operators/${trip.operatorCode.toLowerCase()}`}
          className="text-xs font-semibold text-primary hover:underline inline-flex items-center gap-0.5 self-start sm:self-auto"
        >
          <span>Xem trang nhà xe</span>
          <ChevronRight className="h-3.5 w-3.5" />
        </Link>
      </div>

      {/* 2 Khung Điểm đón & Điểm trả dạng Card xám bo góc */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-3.5">
        {/* Điểm đón */}
        <div className="p-4 rounded-xl bg-muted/40 border border-border/60 space-y-1">
          <div className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">
            ĐIỂM ĐÓN · {trip.departureTime}
          </div>
          <div className="text-sm font-bold text-foreground">
            {trip.departurePointName}
          </div>
          <div className="text-xs text-muted-foreground leading-relaxed">
            {trip.departureAddress}
          </div>
        </div>

        {/* Điểm trả */}
        <div className="p-4 rounded-xl bg-muted/40 border border-border/60 space-y-1">
          <div className="text-[11px] font-bold text-muted-foreground uppercase tracking-wider">
            ĐIỂM TRẢ · {trip.arrivalTime} ({trip.arrivalNoticeText.toUpperCase()})
          </div>
          <div className="text-sm font-bold text-foreground">
            {trip.arrivalPointName}
          </div>
          <div className="text-xs text-muted-foreground leading-relaxed">
            {trip.arrivalAddress}
          </div>
        </div>
      </div>
    </div>
  );
};
