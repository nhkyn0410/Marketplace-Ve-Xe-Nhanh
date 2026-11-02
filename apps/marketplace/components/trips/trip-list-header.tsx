"use client";

import Link from "next/link";
import { useState } from "react";

type TripSort = "earliest" | "price_asc" | "fastest";

/**
 * Thuộc tính của thanh tiêu đề và nhóm tab sắp xếp danh sách chuyến xe.
 * Có `query` (dữ liệu thật) thì tab sắp xếp là link đổi `sortBy`; không có (preview) thì chỉ đổi trạng thái tại chỗ.
 */
export interface TripListHeaderProps {
  readonly totalTrips: number;
  readonly dateText: string;
  readonly passengerCount: number;
  readonly query?: string;
  readonly sort?: TripSort;
}

/**
 * Header danh sách kết quả tìm chuyến và nút chuyển đổi thứ tự sắp xếp (Figma 1440:11297).
 */
export function TripListHeader({
  totalTrips,
  dateText,
  passengerCount,
  query,
  sort = "earliest"
}: TripListHeaderProps) {
  const [localSort, setLocalSort] = useState<TripSort>(sort);
  const activeSort = query === undefined ? localSort : sort;
  const sortHref = (id: TripSort) => {
    const params = new URLSearchParams(query);
    params.set("sortBy", id);
    params.delete("page");
    return `/trips?${params.toString()}`;
  };

  return (
    <div className="flex flex-col justify-between gap-4 border-b border-slate-100 pb-4 sm:flex-row sm:items-center">
      {/* Tiêu đề & Thông tin ngày/khách */}
      <div>
        <h1 className="text-lg/6 font-semibold text-vxn-ink">
          {totalTrips} chuyến đang mở bán
        </h1>
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
        ].map((tab) => {
          const className = `rounded-lg py-1.5 px-3 transition cursor-pointer ${
            activeSort === tab.id
              ? "bg-white text-[#00506a] shadow-xs font-bold"
              : "text-slate-600 hover:text-slate-900"
          }`;
          return query === undefined ? (
            <button key={tab.id} type="button" onClick={() => setLocalSort(tab.id as TripSort)} className={className}>
              {tab.label}
            </button>
          ) : (
            <Link key={tab.id} href={sortHref(tab.id as TripSort)} aria-current={activeSort === tab.id ? "true" : undefined} className={className}>
              {tab.label}
            </Link>
          );
        })}
      </div>
    </div>
  );
}
