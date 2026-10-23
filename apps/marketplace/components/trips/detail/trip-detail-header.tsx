"use client";

import { Star } from "lucide-react";
import { TripDetailData } from "../../../lib/data/types";

/**
 * Thuộc tính của khối Header chi tiết chuyến xe.
 */
interface TripDetailHeaderProps {
  readonly trip: TripDetailData;
}

/**
 * Khối Header chi tiết chuyến xe (SCR-PSG-16).
 * Bao gồm thông tin nhà xe, tuyến đường, huy hiệu và lộ trình tóm tắt chuẩn theo Figma 1443:11643.
 */
export function TripDetailHeader({ trip }: TripDetailHeaderProps) {
  return (
    <div className="bg-white rounded-2xl border border-slate-200 p-4 sm:p-6 shadow-2xs space-y-5">
      {/* Hàng 1: Nhà xe & Badges */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-4 border-b border-slate-100">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-[#006481] text-white flex items-center justify-center font-bold text-sm shadow-xs">
            {trip.operatorCode}
          </div>
          <div>
            <h2 className="text-base font-bold text-slate-900">
              {trip.operatorName}
            </h2>
            <div className="flex items-center gap-1 text-xs text-slate-500 mt-0.5">
              {trip.operatorRating > 0 && <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />}
              {trip.operatorRating > 0 && <span className="font-bold text-slate-800">{trip.operatorRating.toFixed(1)}</span>}
              <span>({trip.operatorRatingCountText})</span>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2 flex-wrap">
          <span className="px-2.5 py-1 rounded-md text-xs font-semibold bg-[#f1f3fc] text-[#00506a]">
            {trip.seatTypeName}
          </span>
          <span className="px-2.5 py-1 rounded-md text-xs font-semibold bg-[#fffbeb] text-[#b45309]">
            {trip.vehicleClass}
          </span>
          {trip.statusBadge && <span className="px-2.5 py-1 rounded-md text-xs font-semibold bg-emerald-50 text-emerald-700">
            {trip.statusBadge}
          </span>}
        </div>
      </div>

      {/* Hàng 2: Tuyến xe */}
      <div>
        <h1 className="text-2xl font-black text-slate-900">
          {trip.routeName}
        </h1>
        <p className="text-xs text-slate-500 mt-1">
          {trip.routeMeta}
        </p>

        {/* Hàng 3: Thời gian và điểm đi / đến */}
        <div className="mt-5 flex items-center justify-between gap-2 sm:gap-4">
          {/* Giờ xuất phát */}
          <div className="shrink-0">
            <div className="text-xl sm:text-2xl font-black text-slate-900">
              {trip.departureTime}
            </div>
            <p className="text-[11px] sm:text-xs text-slate-500 mt-0.5 max-w-[110px] sm:max-w-none truncate sm:whitespace-normal">
              {trip.departureStation}
            </p>
          </div>

          {/* Đường thời gian ở giữa */}
          <div className="flex flex-col items-center flex-1 min-w-[70px] max-w-xs px-1 sm:px-2">
            <span className="text-[10px] sm:text-[11px] font-medium text-slate-500 whitespace-nowrap">{trip.durationText}</span>
            <div className="relative my-1.5 flex w-full items-center justify-between">
              <div className="h-1.5 w-1.5 sm:h-2 sm:w-2 rounded-full bg-[#00506a]" />
              <div className="h-0.5 flex-1 bg-slate-300 border-dashed" />
              <div className="h-1.5 w-1.5 sm:h-2 sm:w-2 rounded-full bg-[#00506a]" />
            </div>
            <span className="text-[9px] sm:text-[10px] text-slate-400 whitespace-nowrap">{trip.stopsSummaryText}</span>
          </div>

          {/* Giờ đến */}
          <div className="text-right shrink-0">
            <div className="flex items-center justify-end gap-1">
              <span className="text-xl sm:text-2xl font-black text-slate-900">
                {trip.arrivalTime}
              </span>
              {trip.isNextDay && (
                <span className="rounded bg-amber-100 px-1 py-0.5 text-[9px] sm:text-[10px] font-bold text-amber-800 whitespace-nowrap">
                  Ngày sau
                </span>
              )}
            </div>
            <p className="text-[11px] sm:text-xs text-slate-500 mt-0.5 max-w-[110px] sm:max-w-none truncate sm:whitespace-normal">
              {trip.arrivalStation}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
