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
    <div className="flex flex-col justify-between gap-4 border-b border-vxn-border/60 pb-4 sm:flex-row sm:items-center">
      {/* Tiêu đề & Thông tin ngày/khách */}
      <div>
        <h2 className="text-xl font-black text-vxn-ink sm:text-2xl">
          {totalTrips} chuyến đang mở bán
        </h2>
        <p className="mt-0.5 text-xs text-vxn-fg-4">
          {dateText} • {passengerCount} hành khách
        </p>
      </div>

      {/* Tabs sắp xếp */}
      <div className="flex items-center rounded-xl border border-vxn-border bg-white p-1 shadow-2xs text-xs">
        {[
          { id: "earliest", label: "Giờ đi sớm" },
          { id: "price_asc", label: "Giá thấp" },
          { id: "fastest", label: "Đi nhanh nhất" }
        ].map((tab) => (
          <button
            key={tab.id}
            type="button"
            onClick={() => setActiveSort(tab.id as typeof activeSort)}
            className={`rounded-lg py-1.5 px-3 font-semibold transition ${
              activeSort === tab.id
                ? "bg-vxn-bg-mist text-vxn-teal-800 shadow-2xs font-bold"
                : "text-vxn-fg-3 hover:text-vxn-ink"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>
    </div>
  );
}
