"use client";

import { ArrowRightLeft, Calendar, MapPin, Search, Users } from "lucide-react";
import { useState } from "react";
import { useRouter } from "next/navigation";
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
  initialOrigin = "",
  initialDestination = "",
  initialDate = "",
  initialPassengers = 1,
  provinces = []
}: TripSearchBarProps) {
  const router = useRouter();
  const [origin, setOrigin] = useState<string>(initialOrigin);
  const [destination, setDestination] = useState<string>(initialDestination);
  const [date, setDate] = useState<string>(initialDate);
  const [passengers, setPassengers] = useState<number>(initialPassengers);
  const [actionError, setActionError] = useState<string | null>(null);

  const handleSwap = (): void => {
    const temp = origin;
    setOrigin(destination);
    setDestination(temp);
  };

  const handleSearch = (e: React.FormEvent): void => {
    e.preventDefault();
    if (!date || !origin || !destination || origin === destination) {
      setActionError("Chọn ngày đi và hai tỉnh thành khác nhau.");
      return;
    }
    router.push(`/trips?${new URLSearchParams({ origin, destination, date, passengers: String(passengers) })}`);
  };

  return (
    <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs sm:p-5">
      <form onSubmit={handleSearch} className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-12 lg:items-center">
        {/* Điểm đi */}
        <div className="relative lg:col-span-3">
          <label className="block text-xs font-semibold text-vxn-fg-4">Điểm đi</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2 text-sm">
            <MapPin className="mr-2 h-4 w-4 shrink-0 text-vxn-teal-600" />
            <select
              required disabled={!provinces.length}
              value={origin}
              onChange={(e) => setOrigin(e.target.value)}
              className="w-full bg-transparent font-bold text-vxn-ink outline-none"
            ><option value="">Chọn điểm đi</option>{provinces.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}</select>
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
            <select
              required disabled={!provinces.length}
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              className="w-full bg-transparent font-bold text-vxn-ink outline-none"
            ><option value="">Chọn điểm đến</option>{provinces.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}</select>
          </div>
        </div>

        {/* Ngày đi */}
        <div className="relative lg:col-span-2">
          <label className="block text-xs font-semibold text-vxn-fg-4">Ngày đi</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-3 py-2 text-sm">
            <Calendar className="mr-2 h-4 w-4 shrink-0 text-vxn-fg-3" />
            <input
              type="date"
              required
              value={date}
              onChange={(e) => setDate(e.target.value)}
              className="w-full bg-transparent font-bold text-vxn-ink outline-none cursor-default"
            />
          </div>
        </div>

        {/* Hành khách */}
        <div className="relative lg:col-span-1">
          <label className="block text-xs font-semibold text-vxn-fg-4">Hành khách</label>
          <div className="mt-1 flex items-center rounded-xl border border-vxn-border bg-vxn-bg-soft px-2.5 py-2 text-sm">
            <Users className="mr-1.5 h-4 w-4 shrink-0 text-vxn-fg-3" />
            <input aria-label="Số hành khách" type="number" required min={1} max={10} step={1} value={passengers} onChange={(e) => setPassengers(Number(e.target.value))} className="w-12 bg-transparent font-bold text-vxn-ink" />
          </div>
        </div>

        {/* Nút Tìm chuyến */}
        <div className="mt-2 sm:mt-0 lg:col-span-2">
          <label className="hidden text-xs font-semibold text-transparent lg:block">Tìm</label>
          <button
            type="submit"
            disabled={!provinces.length}
            className="mt-1 flex w-full items-center justify-center gap-2 rounded-xl bg-[#00506a] py-2.5 px-4 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
          >
            <Search className="h-4 w-4" />
            <span>Tìm chuyến</span>
          </button>
        </div>
      </form>

      {!provinces.length && <p className="mt-3 text-xs text-amber-800">Chưa tải được danh sách tỉnh thành. Vui lòng tải lại trang để thay đổi tìm kiếm.</p>}
      {actionError && (
        <div className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-2.5 text-xs font-medium text-amber-800">
          {actionError}
        </div>
      )}
    </div>
  );
}
