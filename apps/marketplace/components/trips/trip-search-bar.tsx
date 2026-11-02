"use client";

import { ArrowRightLeft } from "lucide-react";
import { useState } from "react";
import { useRouter } from "next/navigation";
import { initialPlace, placeSearchParams, samePlace } from "../../lib/data/trip-mappers";
import { ProvinceItem } from "../../lib/data/types";
import { PlaceInput, type PlaceValue } from "./place-input";
import { ChoiceField, DateField, PASSENGER_OPTIONS, PLACE_INPUT, PLACE_PLACEHOLDER, SEARCH_FIELD, SEARCH_LABEL } from "./search-fields";

/**
 * Thuộc tính của thanh tìm kiếm chuyến xe tóm tắt trên trang danh sách chuyến.
 */
export interface TripSearchBarProps {
  readonly initialOrigin?: string;
  /** Loại + tên điểm từ URL (`originType`, `originLabel`); thiếu = tỉnh, tên lấy từ `provinces`. */
  readonly initialOriginType?: string;
  readonly initialOriginLabel?: string;
  readonly initialDestination?: string;
  readonly initialDestinationType?: string;
  readonly initialDestinationLabel?: string;
  readonly initialDate?: string;
  readonly initialPassengers?: number;
  readonly provinces?: readonly ProvinceItem[];
  /** Nhà xe đang lọc (`operatorId` trên URL) — tìm lại vẫn giữ; bỏ bằng link "Bỏ lọc nhà xe". */
  readonly operatorId?: string;
}

/**
 * Thanh tìm kiếm chuyến xe nhỏ gọn trên đầu trang /trips chuẩn theo Figma 1440:11297.
 */
export function TripSearchBar({
  initialOrigin,
  initialOriginType,
  initialOriginLabel,
  initialDestination,
  initialDestinationType,
  initialDestinationLabel,
  initialDate = "",
  initialPassengers = 1,
  provinces = [],
  operatorId
}: TripSearchBarProps) {
  const router = useRouter();
  const [origin, setOrigin] = useState<PlaceValue | null>(() =>
    initialPlace(initialOrigin, initialOriginType, initialOriginLabel, provinces)
  );
  const [destination, setDestination] = useState<PlaceValue | null>(() =>
    initialPlace(initialDestination, initialDestinationType, initialDestinationLabel, provinces)
  );
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
    if (!date || (origin && destination && samePlace(origin, destination))) {
      setActionError("Chọn ngày đi; nếu chọn cả điểm đi và điểm đến, hai điểm phải khác nhau.");
      return;
    }
    router.push(`/trips?${new URLSearchParams({
      ...(origin ? placeSearchParams("origin", origin) : {}),
      ...(destination ? placeSearchParams("destination", destination) : {}),
      date,
      passengers: String(passengers),
      ...(operatorId ? { operatorId } : {})
    })}`);
  };

  return (
    <div className="rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs">
      <form onSubmit={handleSearch} className="flex flex-col gap-3 lg:flex-row lg:items-center">
        {/* Cụm Điểm đi & Điểm đến */}
        <div className="flex flex-1 flex-col gap-2 sm:flex-row sm:items-center">
          <PlaceInput
            id="search-origin"
            label="Điểm đi (tùy chọn)"
            placeholder={PLACE_PLACEHOLDER}
            value={origin}
            onChange={setOrigin}
            fieldClassName={`${SEARCH_FIELD} flex-1`}
            labelClassName={SEARCH_LABEL}
            inputClassName={PLACE_INPUT}
          />

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

          <PlaceInput
            id="search-destination"
            label="Điểm đến (tùy chọn)"
            placeholder={PLACE_PLACEHOLDER}
            value={destination}
            onChange={setDestination}
            fieldClassName={`${SEARCH_FIELD} flex-1`}
            labelClassName={SEARCH_LABEL}
            inputClassName={PLACE_INPUT}
          />
        </div>

        <DateField value={date} onChange={setDate} placement="bottom" className="w-full sm:w-48 lg:w-[170px] lg:shrink-0" />

        <ChoiceField
          label="Hành khách"
          options={PASSENGER_OPTIONS}
          value={String(passengers)}
          onChange={(value) => setPassengers(Number(value))}
          placement="bottom"
          className="w-full sm:w-44 lg:w-[150px] lg:shrink-0"
        />

        {/* Nút Tìm chuyến */}
        <button
          type="submit"
          className="h-[54px] w-full shrink-0 cursor-pointer rounded-xl bg-[#00506a] px-6 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] disabled:cursor-not-allowed disabled:opacity-60 lg:w-[140px]"
        >
          Tìm chuyến
        </button>
      </form>

      <p className="mt-3 text-xs text-slate-500">Có thể chỉ chọn ngày đi để xem chuyến trên mọi tuyến.</p>
      {actionError && (
        <div role="alert" className="mt-3 rounded-lg border border-amber-200 bg-amber-50 p-2.5 text-xs font-medium text-amber-800">
          {actionError}
        </div>
      )}
    </div>
  );
}
