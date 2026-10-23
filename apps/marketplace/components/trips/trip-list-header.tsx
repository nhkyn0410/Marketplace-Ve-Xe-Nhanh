"use client";

import { useState } from "react";

/**
 * Thuộc tính của thanh tiêu đề và nhóm tab sắp xếp danh sách chuyến xe.
 */
export interface TripListHeaderProps {
  readonly totalTrips: number;
  readonly dateText: string;
  readonly passengerCount: number;
}

/**
 * Header danh sách kết quả tìm chuyến và nút chuyển đổi thứ tự sắp xếp (Figma 1440:11297).
 */
export function TripListHeader({
  totalTrips,
  dateText,
  passengerCount
}: TripListHeaderProps) {
  const [activeSort, setActiveSort] = useState<"earliest" | "price_asc" | "fastest">(
    "earliest"
  );

  return (
    <div className="flex flex-col justify-between gap-4 border-b border-slate-100 pb-4 sm:flex-row sm:items-center">
      {/* Tiêu đề & Thông tin ngày/khách */}
      <div>
        <h2 className="text-xl font-black text-slate-900 sm:text-2xl">
          {totalTrips} chuyến đang mở bán
        </h2>
        <p className="mt-0.5 text-xs text-slate-500">
          {dateText} • {passengerCount} hành khách
        </p>
      </div>

      {/* Tabs sắp xếp */}
      <div className="flex items-center rounded-xl bg-[#f1f3fc] p-1 text-xs font-medium">
        {[
          { id: "earliest", label: "Giờ đi sớm" },
          { id: "price_asc", label: "Giá thấp" },
          { id: "fastest", label: "Đi nhanh nhất" }
        ].map((tab) => (
          <button
            key={tab.id}
            type="button"
            onClick={() => setActiveSort(tab.id as typeof activeSort)}
            className={`rounded-lg py-1.5 px-3 transition cursor-pointer ${
              activeSort === tab.id
                ? "bg-white text-[#00506a] shadow-xs font-bold"
                : "text-slate-600 hover:text-slate-900"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>
    </div>
  );
}
