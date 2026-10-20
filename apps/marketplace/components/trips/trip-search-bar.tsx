"use client";

import { ArrowRightLeft, Calendar, MapPin, Search, Users } from "lucide-react";
import { useState } from "react";
import { ProvinceItem } from "../../lib/data/types";

/**
 * Thuộc tính của thanh tìm kiếm chuyến xe tóm tắt trên trang danh sách chuyến.
 */
export interface TripSearchBarProps {
  readonly initialOrigin?: string;
  readonly initialDestination?: string;
  readonly initialDate?: string;
  readonly initialPassengers?: number;
  readonly provinces?: readonly ProvinceItem[];
}

/**
 * Thanh tìm kiếm chuyến xe nhỏ gọn trên đầu trang /trips.
 */
export function TripSearchBar({
  initialOrigin = "TP. Hồ Chí Minh",
  initialDestination = "Đà Lạt",
  initialDate = "2026-10-16",
  initialPassengers = 2
}: TripSearchBarProps) {
  const [origin, setOrigin] = useState<string>(initialOrigin);
  const [destination, setDestination] = useState<string>(initialDestination);
  const [date] = useState<string>(initialDate);
  const [passengers] = useState<number>(initialPassengers);
  const [actionError, setActionError] = useState<string | null>(null);

  const handleSwap = (): void => {
    const temp = origin;
    setOrigin(destination);
    setDestination(temp);
  };

  const handleSearch = (e: React.FormEvent): void => {
    e.preventDefault();
    console.warn("[Marketplace] Tìm kiếm chuyến xe: API GET /trips/search chưa sẵn sàng.");
    setActionError("Chức năng tìm kiếm chuyến đang được hoàn thiện. Vui lòng thử lại sau.");
  };

  return (
    <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs sm:p-5">
      <form onSubmit={handleSearch} className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-12 lg:items-center">
        {/* Điểm đi */}
        <div className="relative lg:col-span-3">
          <label className="block text-xs font-semibold text-vxn-fg-4">Điểm đi</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2 text-sm">
            <MapPin className="mr-2 h-4 w-4 shrink-0 text-vxn-teal-600" />
            <input
              type="text"
              value={origin}
              onChange={(e) => setOrigin(e.target.value)}
              placeholder="Chọn điểm đi"
              className="w-full bg-transparent font-bold text-vxn-ink outline-none"
            />
          </div>
        </div>

        {/* Nút hoán đổi */}
        <div className="flex items-center justify-center lg:col-span-1">
          <button
            type="button"
            onClick={handleSwap}
            title="Đổi chiều điểm đi / đến"
            className="inline-flex h-9 w-9 items-center justify-center rounded-full border border-vxn-border bg-white text-vxn-fg-3 shadow-xs hover:border-vxn-teal-500 hover:text-vxn-teal-700"
          >
            <ArrowRightLeft className="h-4 w-4" />
          </button>
        </div>

        {/* Điểm đến */}
        <div className="relative lg:col-span-3">
          <label className="block text-xs font-semibold text-vxn-fg-4">Điểm đến</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2 text-sm">
            <MapPin className="mr-2 h-4 w-4 shrink-0 text-[#e89b26]" />
            <input
              type="text"
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              placeholder="Chọn điểm đến"
              className="w-full bg-transparent font-bold text-vxn-ink outline-none"
            />
          </div>
        </div>

        {/* Ngày đi */}
        <div className="relative lg:col-span-2">
          <label className="block text-xs font-semibold text-vxn-fg-4">Ngày đi</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2 text-sm">
            <Calendar className="mr-2 h-4 w-4 shrink-0 text-vxn-fg-3" />
            <input
              type="text"
              value={`T6, ${date.split("-").reverse().join("/")}`}
              readOnly
              className="w-full bg-transparent font-bold text-vxn-ink outline-none cursor-default"
            />
          </div>
        </div>

        {/* Hành khách */}
        <div className="relative lg:col-span-1">
          <label className="block text-xs font-semibold text-vxn-fg-4">Hành khách</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-2.5 py-2 text-sm">
            <Users className="mr-1.5 h-4 w-4 shrink-0 text-vxn-fg-3" />
            <span className="font-bold text-vxn-ink">{passengers} khách</span>
          </div>
        </div>

        {/* Nút Tìm chuyến */}
        <div className="mt-2 sm:mt-0 lg:col-span-2">
          <label className="hidden text-xs font-semibold text-transparent lg:block">Tìm</label>
          <button
            type="submit"
            className="mt-1 flex w-full items-center justify-center gap-2 rounded-xl bg-[#00506a] py-2.5 px-4 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
          >
            <Search className="h-4 w-4" />
            <span>Tìm chuyến</span>
          </button>
        </div>
      </form>

      {actionError && (
        <div className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-2.5 text-xs font-medium text-amber-800">
          {actionError}
        </div>
      )}
    </div>
  );
}
