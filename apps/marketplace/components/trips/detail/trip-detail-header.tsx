"use client";

import Link from "next/link";
import { Star, ChevronRight } from "lucide-react";
import { TripDetailData } from "../../../lib/data/types";


/**
 * Thuộc tính của khối Header chi tiết chuyến xe.
 */
interface TripDetailHeaderProps {
  readonly trip: TripDetailData;
}

/**
 * Khối Header chi tiết chuyến xe (SCR-PSG-16).
 * Bao gồm Breadcrumbs, thông tin nhà xe, tuyến đường, huy hiệu và lộ trình tóm tắt.
 */
export function TripDetailHeader({ trip }: TripDetailHeaderProps) {
  return (
    <div className="space-y-4">
      {/* Breadcrumb và hotline hỗ trợ */}
      <div className="flex flex-wrap items-center justify-between gap-2 text-xs text-neutral-500">
        <nav aria-label="Breadcrumb" className="flex items-center space-x-1.5 flex-wrap">
          <Link href="/" className="hover:text-neutral-900 transition-colors">
            Trang chủ
          </Link>
          <ChevronRight className="w-3.5 h-3.5 text-neutral-400" />
          <Link href="/trips" className="hover:text-neutral-900 transition-colors">
            Mua vé
          </Link>
          <ChevronRight className="w-3.5 h-3.5 text-neutral-400" />
          <span>{trip.routeName}</span>
          <ChevronRight className="w-3.5 h-3.5 text-neutral-400" />
          <span className="text-neutral-900 font-medium">Chi tiết chuyến</span>
        </nav>

        <div className="flex items-center gap-4">
          <div className="flex items-center gap-1.5 text-xs text-neutral-600 bg-neutral-100 px-2.5 py-1 rounded-full border border-neutral-200">
            <Link href="/support" className="hover:underline">Trung tâm hỗ trợ</Link>
          </div>
          <div className="flex items-center gap-1 text-xs text-neutral-700 bg-neutral-100 px-2 py-1 rounded border border-neutral-200">
            <span>VI 🇻🇳</span>
          </div>
        </div>
      </div>

      {/* Card Header chuyến xe */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 pb-4 border-b border-neutral-100">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-xl bg-[#00506a] text-white flex items-center justify-center font-bold text-base shadow-xs">
              {trip.operatorCode}
            </div>
            <div>
              <h2 className="text-base font-semibold text-neutral-900">
                {trip.operatorName}
              </h2>
              <div className="flex items-center gap-1 text-xs text-neutral-500 mt-0.5">
                {trip.operatorRating > 0 && <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-400" />}
                {trip.operatorRating > 0 && <span className="font-semibold text-neutral-800">{trip.operatorRating.toFixed(1)}</span>}
                <span>({trip.operatorRatingCountText})</span>
              </div>
            </div>
          </div>

          <div className="flex items-center gap-2 flex-wrap">
            <span className="px-3 py-1 rounded-full text-xs font-medium bg-blue-50 text-blue-700 border border-blue-200">
              {trip.seatTypeName}
            </span>
            <span className="px-3 py-1 rounded-full text-xs font-medium bg-amber-50 text-amber-700 border border-amber-200">
              {trip.vehicleClass}
            </span>
            {trip.statusBadge && <span className="px-3 py-1 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700 border border-emerald-200">{trip.statusBadge}</span>}
          </div>
        </div>

        {/* Tiêu đề tuyến và mốc thời gian */}
        <div className="pt-5">
          <h1 className="text-2xl font-bold text-neutral-900">
            {trip.routeName}
          </h1>
          <p className="text-xs text-neutral-500 mt-1">
            {trip.routeMeta}
          </p>

          <div className="mt-6 flex flex-col md:flex-row md:items-center justify-between gap-4 bg-neutral-50/70 p-4 rounded-xl border border-neutral-100">
            {/* Giờ xuất phát */}
            <div className="space-y-1">
              <span className="text-2xl font-bold text-neutral-900 tracking-tight">
                {trip.departureTime}
              </span>
              <p className="text-xs text-neutral-600 font-medium">
                {trip.departureStation}
              </p>
            </div>

            {/* Đoạn nối thời gian */}
            <div className="flex-1 max-w-md mx-auto w-full px-4 text-center">
              <div className="relative flex items-center justify-center">
                <div className="absolute left-0 w-3 h-3 rounded-full border-2 border-[#00506a] bg-white z-10" />
                <div className="w-full border-t-2 border-dashed border-neutral-300 relative flex items-center justify-center">
                  <div className="w-2.5 h-2.5 rounded-full bg-amber-400 absolute" />
                </div>
                <div className="absolute right-0 w-3 h-3 rounded-full border-2 border-[#00506a] bg-white z-10" />
              </div>
              <div className="mt-2 text-xs text-neutral-500">
                <span className="font-semibold text-neutral-700">{trip.durationText}</span>
                <span className="mx-1">•</span>
                <span>{trip.stopsSummaryText}</span>
              </div>
            </div>

            {/* Giờ đến */}
            <div className="space-y-1 text-left md:text-right">
              <div className="flex items-center md:justify-end gap-1.5">
                <span className="text-2xl font-bold text-neutral-900 tracking-tight">
                  {trip.arrivalTime}
                </span>
                {trip.isNextDay && (
                  <span className="text-[11px] font-semibold text-amber-700 bg-amber-100 px-1.5 py-0.5 rounded">
                    Ngày sau
                  </span>
                )}
              </div>
              <p className="text-xs text-neutral-600 font-medium">
                {trip.arrivalStation}
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
