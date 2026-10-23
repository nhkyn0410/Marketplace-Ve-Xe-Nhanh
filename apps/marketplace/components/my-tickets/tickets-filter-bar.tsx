"use client";

import { Search } from "lucide-react";

export type TicketTabKey = "upcoming" | "completed" | "cancelled" | "all";

export interface TicketsFilterBarProps {
  readonly activeTab: TicketTabKey;
  readonly onChangeTab: (tab: TicketTabKey) => void;
  readonly searchQuery: string;
  readonly onChangeSearch: (query: string) => void;
  readonly counts: {
    readonly upcoming: number;
    readonly completed: number;
    readonly cancelled: number;
    readonly all: number;
  };
}

/**
 * Thanh tabs lọc theo trạng thái chuyến và ô tìm kiếm vé theo Figma 1445:14030.
 */
export function TicketsFilterBar({
  activeTab,
  onChangeTab,
  searchQuery,
  onChangeSearch,
  counts
}: TicketsFilterBarProps) {
  const tabs = [
    { key: "upcoming" as const, label: `Sắp tới (${counts.upcoming})` },
    { key: "completed" as const, label: `Đã đi (${counts.completed})` },
    { key: "cancelled" as const, label: `Đã hủy (${counts.cancelled})` },
    { key: "all" as const, label: `Tất cả (${counts.all})` }
  ];

  return (
    <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between border-b border-vxn-border/50 pb-4">
      {/* Hàng tabs */}
      <div className="flex items-center gap-1.5 overflow-x-auto rounded-xl bg-neutral-100/80 p-1">
        {tabs.map((tab) => {
          const isActive = activeTab === tab.key;
          return (
            <button
              key={tab.key}
              type="button"
              onClick={() => onChangeTab(tab.key)}
              className={`rounded-lg px-3.5 py-1.5 text-xs sm:text-sm font-semibold transition shrink-0 cursor-pointer ${
                isActive
                  ? "bg-white text-vxn-ink shadow-2xs"
                  : "text-vxn-fg-4 hover:text-vxn-ink"
              }`}
            >
              {tab.label}
            </button>
          );
        })}
      </div>

      {/* Ô tìm kiếm */}
      <div className="relative w-full md:w-80">
        <Search className="absolute left-3.5 top-1/2 -translate-y-1/2 h-4 w-4 text-neutral-400" />
        <input
          type="text"
          value={searchQuery}
          onChange={(e) => onChangeSearch(e.target.value)}
          placeholder="Tìm theo mã đặt vé hoặc tuyến"
          className="w-full rounded-xl border border-vxn-border bg-white pl-10 pr-4 py-2 text-xs sm:text-sm text-vxn-ink placeholder:text-neutral-400 focus:outline-hidden focus:ring-2 focus:ring-vxn-teal-800/30"
        />
      </div>
    </div>
  );
}
