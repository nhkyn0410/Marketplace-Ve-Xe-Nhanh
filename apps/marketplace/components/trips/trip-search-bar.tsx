"use client";

import { ArrowRightLeft } from "lucide-react";
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
 * Thanh tìm kiếm chuyến xe nhỏ gọn trên đầu trang /trips chuẩn theo Figma 1440:11297.
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
    <div className="rounded-2xl border border-slate-200 bg-white p-3.5 shadow-2xs">
      <form onSubmit={handleSearch} className="flex flex-col gap-3 lg:flex-row lg:items-center">
        {/* Cụm Điểm đi & Điểm đến */}
        <div className="flex flex-1 flex-col gap-2 sm:flex-row sm:items-center">
          {/* Điểm đi */}
          <div className="flex-1 rounded-xl border border-slate-200 bg-white px-3.5 py-1.5 focus-within:border-[#00506a]">
            <label className="block text-[11px] font-semibold text-slate-400">Điểm đi</label>
            <select
              required disabled={!provinces.length}
              value={origin}
              onChange={(e) => setOrigin(e.target.value)}
              className="w-full bg-transparent text-sm font-bold text-slate-900 outline-none"
            >
              <option value="">Chọn điểm đi</option>
              {provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
            </select>
          </div>

          {/* Nút hoán đổi */}
          <div className="flex items-center justify-center shrink-0">
            <button
              type="button"
              onClick={handleSwap}
              title="Đổi chiều điểm đi / đến"
              className="inline-flex h-9 w-9 items-center justify-center rounded-full border border-slate-200 bg-white text-slate-600 shadow-xs hover:border-[#00506a] hover:text-[#00506a] transition cursor-pointer"
            >
              <ArrowRightLeft className="h-4 w-4" />
            </button>
          </div>

          {/* Điểm đến */}
          <div className="flex-1 rounded-xl border border-slate-200 bg-white px-3.5 py-1.5 focus-within:border-[#00506a]">
            <label className="block text-[11px] font-semibold text-slate-400">Điểm đến</label>
            <select
              required disabled={!provinces.length}
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              className="w-full bg-transparent text-sm font-bold text-slate-900 outline-none"
            >
              <option value="">Chọn điểm đến</option>
              {provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
            </select>
          </div>
        </div>

        {/* Ngày đi */}
        <div className="w-full sm:w-48 lg:w-44 rounded-xl border border-slate-200 bg-white px-3.5 py-1.5 focus-within:border-[#00506a]">
          <label className="block text-[11px] font-semibold text-slate-400">Ngày đi</label>
          <input
            type="date"
            required
            value={date}
            onChange={(e) => setDate(e.target.value)}
            className="w-full bg-transparent text-sm font-bold text-slate-900 outline-none cursor-default"
          />
        </div>

        {/* Hành khách */}
        <div className="w-full sm:w-44 lg:w-36 rounded-xl border border-slate-200 bg-white px-3.5 py-1.5 focus-within:border-[#00506a]">
          <label className="block text-[11px] font-semibold text-slate-400">Hành khách</label>
          <div className="text-sm font-bold text-slate-900">
            <input
              aria-label="Số hành khách"
              type="number"
              required min={1} max={10} step={1}
              value={passengers}
              onChange={(e) => setPassengers(Number(e.target.value))}
              className="w-12 bg-transparent font-bold text-slate-900"
            />
            hành khách
          </div>
        </div>

        {/* Nút Tìm chuyến */}
        <div className="shrink-0">
          <button
            type="submit"
            disabled={!provinces.length}
            className="flex w-full items-center justify-center rounded-xl bg-[#00506a] px-6 py-3 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
          >
            Tìm chuyến
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
