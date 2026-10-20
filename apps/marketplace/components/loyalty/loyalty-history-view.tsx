"use client";

import { useMemo, useState } from "react";
import { ChevronDown } from "lucide-react";
import type { LoyaltyHistoryData, LoyaltyTransactionType } from "../../lib/data/types";
import { AccountSidebar } from "../account/account-sidebar";

/**
 * Thuộc tính của component Lịch sử điểm (SCR-PSG-34).
 */
export interface LoyaltyHistoryViewProps {
  readonly historyData: LoyaltyHistoryData;
  readonly isPreview?: boolean;
}

type FilterTabKey = "all" | LoyaltyTransactionType;

/**
 * Component hiển thị trang Lịch sử điểm thưởng (SCR-PSG-34 - Figma 1448:19985).
 */
export function LoyaltyHistoryView({ historyData, isPreview = false }: LoyaltyHistoryViewProps) {
  const [activeFilter, setActiveFilter] = useState<FilterTabKey>("all");
  const [selectedPeriod, setSelectedPeriod] = useState<string>("12m");

  // Lọc danh sách giao dịch theo tab
  const filteredTransactions = useMemo(() => {
    if (activeFilter === "all") return historyData.transactions;
    return historyData.transactions.filter((tx) => tx.type === activeFilter);
  }, [historyData.transactions, activeFilter]);

  const filterTabs: readonly { readonly key: FilterTabKey; readonly label: string }[] = [
    { key: "all", label: "Tất cả" },
    { key: "earn", label: "Tích điểm" },
    { key: "redeem", label: "Đổi điểm" },
    { key: "expire", label: "Hết hạn" },
    { key: "adjust", label: "Điều chỉnh" }
  ];

  return (
    <div className="flex flex-col gap-8 lg:flex-row">
      {/* 1. Cột Sidebar tài khoản bên trái */}
      <div className="w-full shrink-0 lg:w-72">
        <AccountSidebar activeTab="points" isPreview={isPreview} />
      </div>

      {/* 2. Cột nội dung Lịch sử điểm bên phải */}
      <div className="flex-1 space-y-6">
        {/* Tiêu đề & mô tả */}
        <div>
          <h1 className="text-xl font-black text-vxn-ink sm:text-2xl">Lịch sử điểm</h1>
          <p className="mt-1 text-xs text-vxn-fg-4">
            Mọi thay đổi điểm đều được ghi lại, mới nhất trước.
          </p>
        </div>

        {/* 4 Thẻ thống kê */}
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs">
            <span className="text-2xs font-bold text-vxn-fg-4 uppercase tracking-wider">
              Điểm hiện có
            </span>
            <div className="mt-1 text-xl font-black text-[#00506a] sm:text-2xl">
              {historyData.availablePoints.toLocaleString("vi-VN")}
            </div>
          </div>

          <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs">
            <span className="text-2xs font-bold text-vxn-fg-4 uppercase tracking-wider">
              Đã tích
            </span>
            <div className="mt-1 text-xl font-black text-emerald-700 sm:text-2xl">
              {historyData.totalEarnedPoints.toLocaleString("vi-VN")}
            </div>
          </div>

          <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs">
            <span className="text-2xs font-bold text-vxn-fg-4 uppercase tracking-wider">
              Đã đổi
            </span>
            <div className="mt-1 text-xl font-black text-slate-700 sm:text-2xl">
              {historyData.totalRedeemedPoints.toLocaleString("vi-VN")}
            </div>
          </div>

          <div className="rounded-2xl border border-vxn-border bg-white p-4 shadow-2xs">
            <span className="text-2xs font-bold text-vxn-fg-4 uppercase tracking-wider">
              Đã hết hạn
            </span>
            <div className="mt-1 text-xl font-black text-red-600 sm:text-2xl">
              {historyData.totalExpiredPoints.toLocaleString("vi-VN")}
            </div>
          </div>
        </div>

        {/* Thanh lọc & Bảng giao dịch */}
        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs sm:p-6">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
            {/* Tabs bộ lọc */}
            <div className="flex flex-wrap items-center gap-1.5 border-b border-vxn-border/60 pb-3 sm:border-b-0 sm:pb-0">
              {filterTabs.map((tab) => (
                <button
                  key={tab.key}
                  type="button"
                  onClick={() => setActiveFilter(tab.key)}
                  className={`rounded-lg px-3 py-1.5 text-xs font-bold transition ${
                    activeFilter === tab.key
                      ? "bg-[#00506a] text-white shadow-xs"
                      : "text-vxn-fg-3 hover:bg-vxn-bg-soft"
                  }`}
                >
                  {tab.label}
                </button>
              ))}
            </div>

            {/* Dropdown thời gian */}
            <div className="relative inline-block w-48 shrink-0">
              <select
                value={selectedPeriod}
                onChange={(e) => setSelectedPeriod(e.target.value)}
                className="w-full appearance-none rounded-xl border border-vxn-border bg-white px-3.5 py-2 pr-9 text-xs font-semibold text-vxn-fg-2 focus:border-vxn-teal-600 focus:outline-hidden"
              >
                <option value="12m">12 tháng gần nhất</option>
                <option value="6m">6 tháng gần nhất</option>
                <option value="3m">3 tháng gần nhất</option>
                <option value="all">Tất cả thời gian</option>
              </select>
              <ChevronDown className="pointer-events-none absolute top-1/2 right-3 -translate-y-1/2 h-4 w-4 text-vxn-fg-4" />
            </div>
          </div>

          {/* Bảng giao dịch */}
          <div className="mt-5 overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead>
                <tr className="border-b border-vxn-border text-2xs font-bold text-vxn-fg-4 uppercase">
                  <th className="pb-3 pl-2">Ngày</th>
                  <th className="pb-3 text-center sm:text-left">Loại</th>
                  <th className="pb-3">Nguồn</th>
                  <th className="pb-3 pr-2 text-right">Điểm</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-vxn-border/60">
                {filteredTransactions.map((tx) => {
                  const isPositive = tx.pointsChange > 0;
                  return (
                    <tr key={tx.id} className="transition hover:bg-vxn-bg-soft/40">
                      <td className="py-4 pl-2 font-medium text-vxn-fg-3 whitespace-nowrap">
                        {tx.dateText}
                      </td>
                      <td className="py-4 text-center sm:text-left whitespace-nowrap">
                        <span
                          className={`inline-block rounded-md px-2 py-0.5 text-2xs font-bold ${
                            tx.type === "earn"
                              ? "bg-emerald-50 text-emerald-700"
                              : tx.type === "redeem"
                                ? "bg-slate-100 text-slate-700"
                                : tx.type === "expire"
                                  ? "bg-red-50 text-red-700"
                                  : tx.type === "revoke"
                                    ? "bg-amber-50 text-amber-700"
                                    : "bg-sky-50 text-sky-700"
                          }`}
                        >
                          {tx.typeLabel}
                        </span>
                      </td>
                      <td className="py-4 text-vxn-ink font-medium">{tx.sourceText}</td>
                      <td className="py-4 pr-2 text-right font-black whitespace-nowrap">
                        <span className={isPositive ? "text-emerald-600" : "text-red-600"}>
                          {isPositive ? `+${tx.pointsChange}` : `−${Math.abs(tx.pointsChange)}`}
                        </span>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>

          {/* Phân trang */}
          <div className="mt-6 flex flex-wrap items-center justify-between gap-3 border-t border-vxn-border/60 pt-4 text-xs">
            <span className="text-vxn-fg-4">
              Hiển thị 1–{filteredTransactions.length} trong {historyData.totalCount} giao dịch
            </span>

            <div className="flex items-center gap-2">
              <button
                type="button"
                disabled
                className="rounded-lg border border-vxn-border bg-white px-3 py-1.5 font-bold text-vxn-fg-4 opacity-50 shadow-2xs"
              >
                Trước
              </button>
              <button
                type="button"
                className="rounded-lg border border-vxn-border bg-white px-3 py-1.5 font-bold text-vxn-fg-2 shadow-2xs transition hover:bg-vxn-bg-soft"
              >
                Sau
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
