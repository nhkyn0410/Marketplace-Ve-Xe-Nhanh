"use client";

import { Airplay, Droplets, SlidersHorizontal, Star, Wifi, Zap } from "lucide-react";
import { useState } from "react";

/**
 * Khối bộ lọc bên trái cho trang danh sách chuyến xe (Figma 1440:11297).
 */
export function TripFilters() {
  const [selectedTimeRange, setSelectedTimeRange] = useState<string | null>(null);
  const [selectedSeatTypes, setSelectedSeatTypes] = useState<readonly string[]>([]);
  const [selectedVehicleTypes, setSelectedVehicleTypes] = useState<readonly string[]>([]);
  const [selectedOperators, setSelectedOperators] = useState<readonly string[]>([]);
  const [selectedPickupStations, setSelectedPickupStations] = useState<readonly string[]>([]);
  const [selectedDropoffStations, setSelectedDropoffStations] = useState<readonly string[]>([]);
  const [selectedAmenities, setSelectedAmenities] = useState<readonly string[]>([]);
  const [selectedRating, setSelectedRating] = useState<string>("all");

  const handleResetFilters = (): void => {
    setSelectedTimeRange(null);
    setSelectedSeatTypes([]);
    setSelectedVehicleTypes([]);
    setSelectedOperators([]);
    setSelectedPickupStations([]);
    setSelectedDropoffStations([]);
    setSelectedAmenities([]);
    setSelectedRating("all");
  };

  const toggleItem = (list: readonly string[], item: string, setter: (val: readonly string[]) => void): void => {
    if (list.includes(item)) {
      setter(list.filter((i) => i !== item));
    } else {
      setter([...list, item]);
    }
  };

  return (
    <aside className="w-full rounded-2xl border border-slate-200 bg-white p-4 shadow-2xs">
      {/* Header bộ lọc */}
      <div className="flex items-center justify-between border-b border-slate-100 pb-3">
        <div className="flex items-center gap-2">
          <SlidersHorizontal className="h-4 w-4 text-[#00506a]" />
          <h3 className="text-sm font-bold text-slate-900">Bộ lọc</h3>
        </div>

        <button
          type="button"
          onClick={handleResetFilters}
          className="text-xs font-semibold text-[#006481] hover:underline cursor-pointer"
        >
          Xóa lọc
        </button>
      </div>

      {/* Thân bộ lọc */}
      <div className="mt-4 space-y-4 text-sm">
        {/* 1. Giờ khởi hành */}
        <div>
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Giờ khởi hành
          </h4>
          <div className="mt-2 grid grid-cols-2 gap-1.5 text-xs">
            {[
              { id: "00-06", label: "00:00 – 06:00" },
              { id: "06-12", label: "06:00 – 12:00" },
              { id: "12-18", label: "12:00 – 18:00" },
              { id: "18-24", label: "18:00 – 24:00" }
            ].map((t) => (
              <button
                key={t.id}
                type="button"
                onClick={() => setSelectedTimeRange(selectedTimeRange === t.id ? null : t.id)}
                className={`rounded-lg border py-1.5 px-1 text-center text-[11px] font-medium transition cursor-pointer ${
                  selectedTimeRange === t.id
                    ? "border-[#00506a] bg-teal-50/60 font-bold text-[#00506a]"
                    : "border-slate-200 bg-white text-slate-600 hover:border-slate-300"
                }`}
              >
                {t.label}
              </button>
            ))}
          </div>
        </div>

        {/* 2. Khoảng giá */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Khoảng giá
          </h4>
          <div className="mt-2.5">
            <div className="relative h-1.5 w-full rounded-full bg-slate-100">
              <div className="absolute top-0 bottom-0 left-0 right-0 rounded-full bg-[#00506a]" />
              <div className="absolute top-1/2 left-0 h-3.5 w-3.5 -translate-y-1/2 rounded-full border-2 border-[#00506a] bg-white shadow-xs" />
              <div className="absolute top-1/2 right-0 h-3.5 w-3.5 -translate-y-1/2 rounded-full border-2 border-[#00506a] bg-white shadow-xs" />
            </div>
            <div className="mt-1.5 flex items-center justify-between text-[11px] text-slate-500">
              <span>0đ</span>
              <span>1.000.000đ</span>
            </div>
          </div>
        </div>

        {/* 3. Dạng chỗ */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Dạng chỗ
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "seat", label: "Ghế ngồi", count: 3 },
              { id: "sleeper", label: "Giường nằm", count: 7 },
              { id: "cabin", label: "Cabin", count: 2 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center justify-between text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedSeatTypes.includes(item.id)}
                    onChange={() => toggleItem(selectedSeatTypes, item.id, setSelectedSeatTypes)}
                    className="h-3.5 w-3.5 rounded border-slate-300 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                  />
                  <span>{item.label}</span>
                </div>
                <span className="text-[11px] text-slate-400">{item.count}</span>
              </label>
            ))}
          </div>
        </div>

        {/* 4. Hạng xe */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Hạng xe
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "standard", label: "Tiêu chuẩn", count: 8 },
              { id: "limousine", label: "Limousine", count: 4 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center justify-between text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedVehicleTypes.includes(item.id)}
                    onChange={() => toggleItem(selectedVehicleTypes, item.id, setSelectedVehicleTypes)}
                    className="h-3.5 w-3.5 rounded border-slate-300 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                  />
                  <span>{item.label}</span>
                </div>
                <span className="text-[11px] text-slate-400">{item.count}</span>
              </label>
            ))}
          </div>
        </div>

        {/* 5. Nhà xe */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Nhà xe
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "phuongnam", label: "Phương Nam Travel", count: 4 },
              { id: "halinh", label: "Hà Linh Express", count: 3 },
              { id: "tamhanh", label: "Tâm Hạnh Limousine", count: 3 },
              { id: "maihuong", label: "Mai Hương Sleeper", count: 2 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center justify-between text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedOperators.includes(item.id)}
                    onChange={() => toggleItem(selectedOperators, item.id, setSelectedOperators)}
                    className="h-3.5 w-3.5 rounded border-slate-300 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                  />
                  <span className="truncate max-w-[170px]">{item.label}</span>
                </div>
                <span className="text-[11px] text-slate-400">{item.count}</span>
              </label>
            ))}
          </div>
        </div>

        {/* 6. Điểm đón */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Điểm đón
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "bx-mientay", label: "Bến xe Miền Đông mới", count: 9 },
              { id: "vp-q1", label: "Văn phòng nhà xe – Quận 1", count: 5 },
              { id: "bx-ansuong", label: "Bến xe An Sương", count: 2 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center justify-between text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedPickupStations.includes(item.id)}
                    onChange={() => toggleItem(selectedPickupStations, item.id, setSelectedPickupStations)}
                    className="h-3.5 w-3.5 rounded border-slate-300 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                  />
                  <span className="truncate max-w-[170px]">{item.label}</span>
                </div>
                <span className="text-[11px] text-slate-400">{item.count}</span>
              </label>
            ))}
          </div>
        </div>

        {/* 7. Điểm trả */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Điểm trả
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "bx-dalat", label: "Bến xe liên tỉnh Đà Lạt", count: 12 },
              { id: "vp-dalat", label: "Văn phòng nhà xe – Đà Lạt", count: 6 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center justify-between text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <div className="flex items-center gap-2">
                  <input
                    type="checkbox"
                    checked={selectedDropoffStations.includes(item.id)}
                    onChange={() => toggleItem(selectedDropoffStations, item.id, setSelectedDropoffStations)}
                    className="h-3.5 w-3.5 rounded border-slate-300 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                  />
                  <span className="truncate max-w-[170px]">{item.label}</span>
                </div>
                <span className="text-[11px] text-slate-400">{item.count}</span>
              </label>
            ))}
          </div>
        </div>

        {/* 8. Tiện ích */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Tiện ích
          </h4>
          <div className="mt-2 grid grid-cols-2 gap-1.5">
            {[
              { id: "WiFi", label: "WiFi", icon: Wifi },
              { id: "Điều hòa", label: "Điều hòa", icon: Airplay },
              { id: "Nước uống", label: "Nước uống", icon: Droplets },
              { id: "Cổng sạc", label: "Cổng sạc", icon: Zap }
            ].map((amenity) => {
              const IconComp = amenity.icon;
              const isSelected = selectedAmenities.includes(amenity.id);
              return (
                <button
                  key={amenity.id}
                  type="button"
                  onClick={() => toggleItem(selectedAmenities, amenity.id, setSelectedAmenities)}
                  className={`flex items-center justify-center gap-1.5 rounded-lg border py-1.5 px-2 text-[11px] font-medium transition cursor-pointer ${
                    isSelected
                      ? "border-[#00506a] bg-teal-50 text-[#00506a] font-bold"
                      : "border-slate-200 bg-white text-slate-600 hover:border-slate-300"
                  }`}
                >
                  <IconComp className="h-3 w-3 shrink-0" />
                  <span>{amenity.label}</span>
                </button>
              );
            })}
          </div>
        </div>

        {/* 9. Đánh giá */}
        <div className="border-t border-slate-100 pt-3.5">
          <h4 className="text-[13px] font-semibold text-vxn-ink">
            Đánh giá
          </h4>
          <div className="mt-2 space-y-1.5">
            {[
              { id: "4.5", label: "Từ 4,5 sao", stars: 1 },
              { id: "4.0", label: "Từ 4,0 sao", stars: 1 },
              { id: "all", label: "Tất cả", stars: 0 }
            ].map((item) => (
              <label
                key={item.id}
                className="flex items-center gap-2 text-xs text-slate-600 hover:text-slate-900 cursor-pointer select-none py-0.5"
              >
                <input
                  type="radio"
                  name="rating_filter"
                  value={item.id}
                  checked={selectedRating === item.id}
                  onChange={() => setSelectedRating(item.id)}
                  className="h-3.5 w-3.5 text-[#00506a] accent-[#00506a] focus:ring-[#00506a]"
                />
                {item.stars > 0 && <Star className="h-3 w-3 fill-amber-400 text-amber-500" />}
                <span>{item.label}</span>
              </label>
            ))}
          </div>
        </div>
      </div>
    </aside>
  );
}
