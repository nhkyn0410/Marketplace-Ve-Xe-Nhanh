"use client";

import { ArrowRightLeft } from "lucide-react";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { ProvinceItem } from "../../lib/data/types";
import { formatTripDateVi } from "../../lib/format";

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

  const field = "relative rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a]";
  const label = "block text-xs font-medium text-slate-500";
  const value = "mt-0.5 w-full appearance-none truncate bg-transparent text-[15px] font-bold text-vxn-ink outline-none";

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs">
      <form onSubmit={handleSearch} className="flex flex-col gap-3 lg:flex-row lg:items-center">
        {/* Cụm Điểm đi & Điểm đến */}
        <div className="flex flex-1 flex-col gap-2 sm:flex-row sm:items-center">
          <div className={`${field} min-w-0 flex-1`}>
            <label htmlFor="search-origin" className={label}>Điểm đi</label>
            <select
              id="search-origin"
              required disabled={!provinces.length}
              value={origin}
              onChange={(e) => setOrigin(e.target.value)}
              className={value}
            >
              <option value="">Chọn điểm đi</option>
              {provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
            </select>
          </div>

          {/* Nút hoán đổi */}
          <div className="flex shrink-0 items-center justify-center">
            <button
              type="button"
              onClick={handleSwap}
              aria-label="Đổi chiều điểm đi / đến"
              className="inline-flex h-9 w-9 cursor-pointer items-center justify-center rounded-full border border-slate-200 bg-white text-slate-500 transition hover:border-[#00506a] hover:text-[#00506a]"
            >
              <ArrowRightLeft className="h-3.5 w-3.5" />
            </button>
          </div>

          <div className={`${field} min-w-0 flex-1`}>
            <label htmlFor="search-destination" className={label}>Điểm đến</label>
            <select
              id="search-destination"
              required disabled={!provinces.length}
              value={destination}
              onChange={(e) => setDestination(e.target.value)}
              className={value}
            >
              <option value="">Chọn điểm đến</option>
              {provinces.map((province) => <option key={province.id} value={province.id}>{province.name}</option>)}
            </select>
          </div>
        </div>

        {/* Ngày đi: hiển thị "T6, 16/10/2026", ô date gốc phủ trong suốt để mở lịch */}
        <div className={`${field} w-full sm:w-48 lg:w-[170px]`}>
          <label htmlFor="search-date" className={label}>Ngày đi</label>
          <div className="mt-0.5 text-[15px] font-bold text-vxn-ink">{date ? formatTripDateVi(date) : "Chọn ngày"}</div>
          <input
            id="search-date"
            type="date"
            required
            value={date}
            onChange={(e) => setDate(e.target.value)}
            className="absolute inset-0 cursor-pointer opacity-0"
          />
        </div>

        {/* Hành khách */}
        <div className={`${field} w-full sm:w-44 lg:w-[150px]`}>
          <label htmlFor="search-passengers" className={label}>Hành khách</label>
          <select
            id="search-passengers"
            value={passengers}
            onChange={(e) => setPassengers(Number(e.target.value))}
            className={value}
          >
            {Array.from({ length: 10 }, (_, index) => index + 1).map((count) => (
              <option key={count} value={count}>{count} hành khách</option>
            ))}
          </select>
        </div>

        {/* Nút Tìm chuyến */}
        <button
          type="submit"
          disabled={!provinces.length}
          className="h-[54px] w-full shrink-0 cursor-pointer rounded-xl bg-[#00506a] px-6 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] disabled:cursor-not-allowed disabled:opacity-60 lg:w-[140px]"
        >
          Tìm chuyến
        </button>
      </form>

      {!provinces.length && <p className="mt-3 text-xs text-amber-800">Chưa tải được danh sách tỉnh thành. Vui lòng tải lại trang để thay đổi tìm kiếm.</p>}
      {actionError && (
        <div role="alert" className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-2.5 text-xs font-medium text-amber-800">
          {actionError}
        </div>
      )}
    </div>
  );
}
