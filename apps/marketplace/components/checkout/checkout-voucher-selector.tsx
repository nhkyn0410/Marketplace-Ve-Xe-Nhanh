"use client";

import { Tag } from "lucide-react";
import { useState } from "react";
import { CheckoutVoucherItem } from "../../lib/data/types";

/**
 * Thuộc tính của component chọn ưu đãi voucher.
 */
export interface CheckoutVoucherSelectorProps {
  readonly vouchers: readonly CheckoutVoucherItem[];
  readonly selectedVoucherId?: string;
  readonly onSelectVoucher?: (id: string | undefined) => void;
}

/**
 * Khối chọn ưu đãi / voucher theo Figma 1444:12531.
 */
export function CheckoutVoucherSelector({
  vouchers,
  selectedVoucherId,
  onSelectVoucher
}: CheckoutVoucherSelectorProps) {
  const [activeTab, setActiveTab] = useState<"wallet" | "code">("wallet");
  const [manualCode, setManualCode] = useState<string>("");
  const [manualError, setManualError] = useState<string | null>(null);

  const handleApplyManualCode = (): void => {
    if (!manualCode.trim()) {
      setManualError("Vui lòng nhập mã khuyến mãi");
      return;
    }
    // Giả lập theo A5 #3: Không gọi mạng giả
    setManualError("Mã khuyến mãi không hợp lệ hoặc đã hết lượt dùng.");
  };

  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      {/* Header và Tabs */}
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-b border-vxn-border/50 pb-4">
        <div>
          <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
            Ưu đãi
          </h3>
          <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
            Mỗi đơn áp dụng tối đa một voucher hoặc một mã khuyến mãi.
          </p>
        </div>

        {/* Tab chuyển đổi */}
        <div className="flex items-center rounded-xl bg-neutral-100 p-1 text-xs font-semibold self-start sm:self-auto">
          <button
            type="button"
            onClick={() => setActiveTab("wallet")}
            className={`rounded-lg px-3 py-1.5 transition cursor-pointer ${
              activeTab === "wallet"
                ? "bg-white text-vxn-ink shadow-2xs"
                : "text-neutral-500 hover:text-neutral-800"
            }`}
          >
            Ví voucher ({vouchers.length})
          </button>
          <button
            type="button"
            onClick={() => setActiveTab("code")}
            className={`rounded-lg px-3 py-1.5 transition cursor-pointer ${
              activeTab === "code"
                ? "bg-white text-vxn-ink shadow-2xs"
                : "text-neutral-500 hover:text-neutral-800"
            }`}
          >
            Nhập mã
          </button>
        </div>
      </div>

      {/* Tab 1: Danh sách ví voucher */}
      {activeTab === "wallet" && (
        <div className="mt-5 space-y-3">
          {vouchers.map((voucher) => {
            const isSelected = voucher.id === selectedVoucherId;
            const isAvailable = voucher.isApplicable;

            return (
              <div
                key={voucher.id}
                onClick={() => {
                  if (isAvailable) {
                    onSelectVoucher?.(isSelected ? undefined : voucher.id);
                  }
                }}
                className={`flex items-start gap-3 rounded-xl p-3.5 transition ${
                  !isAvailable
                    ? "cursor-not-allowed bg-neutral-50/70 border border-neutral-200/80 opacity-70"
                    : isSelected
                    ? "cursor-pointer border-2 border-vxn-teal-800 bg-teal-50/15 shadow-2xs"
                    : "cursor-pointer border border-vxn-border bg-white hover:border-neutral-300 hover:bg-neutral-50/50"
                }`}
                role="radio"
                aria-checked={isSelected}
              >
                {/* Radio circle */}
                <div className="mt-0.5 shrink-0">
                  {isSelected ? (
                    <div className="flex h-4 w-4 items-center justify-center rounded-full border-2 border-vxn-teal-800">
                      <div className="h-2 w-2 rounded-full bg-vxn-teal-800" />
                    </div>
                  ) : (
                    <div className="h-4 w-4 rounded-full border border-neutral-300" />
                  )}
                </div>

                {/* Icon Tag */}
                <Tag
                  className={`h-4 w-4 shrink-0 mt-0.5 ${
                    isSelected ? "text-vxn-teal-800" : "text-amber-500"
                  }`}
                />

                {/* Nội dung voucher */}
                <div className="flex-1 min-w-0">
                  <div className="flex items-start justify-between gap-2">
                    <span className="text-xs sm:text-sm font-bold text-vxn-ink">
                      {voucher.title}
                    </span>
                    <span
                      className={`text-[10px] font-semibold px-2 py-0.5 rounded-md shrink-0 ${
                        !isAvailable
                          ? "bg-neutral-100 text-neutral-500"
                          : isSelected
                          ? "bg-teal-50 text-vxn-teal-800"
                          : "bg-neutral-100 text-neutral-600"
                      }`}
                    >
                      {voucher.tagText}
                    </span>
                  </div>
                  <p className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">
                    {voucher.description}
                  </p>
                </div>
              </div>
            );
          })}

          {/* Link bỏ chọn voucher */}
          <div className="pt-2">
            <button
              type="button"
              onClick={() => onSelectVoucher?.(undefined)}
              className="text-xs font-semibold text-vxn-teal-800 hover:underline cursor-pointer"
            >
              Không dùng ưu đãi cho đơn này
            </button>
          </div>
        </div>
      )}

      {/* Tab 2: Nhập mã thủ công */}
      {activeTab === "code" && (
        <div className="mt-5">
          <div className="flex gap-2">
            <input
              type="text"
              value={manualCode}
              onChange={(e) => {
                setManualCode(e.target.value);
                setManualError(null);
              }}
              placeholder="Nhập mã voucher / khuyến mãi"
              className="flex-1 rounded-xl border border-neutral-300 bg-white px-3.5 py-2.5 text-xs sm:text-sm text-vxn-ink shadow-2xs focus:border-vxn-teal-700 focus:outline-hidden uppercase"
            />
            <button
              type="button"
              onClick={handleApplyManualCode}
              className="rounded-xl bg-[#00506a] px-5 py-2.5 text-xs sm:text-sm font-bold text-white transition hover:bg-[#00476b] cursor-pointer"
            >
              Áp dụng
            </button>
          </div>
          {manualError && (
            <p className="mt-2 text-xs text-red-600 font-medium">{manualError}</p>
          )}
        </div>
      )}
    </section>
  );
}
