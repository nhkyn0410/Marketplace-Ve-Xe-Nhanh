"use client";

import { useState } from "react";
import Link from "next/link";
import { AlertCircle, CheckCircle2, Gift, ArrowRight } from "lucide-react";
import type { UserVouchersData, UserVoucherStatus } from "../../lib/data/types";
import { AccountSidebar } from "../account/account-sidebar";
import { saveVoucherCode } from "../../lib/data/loyalty";

/**
 * Thuộc tính của component Ví voucher (SCR-PSG-36).
 */
export interface VouchersViewProps {
  readonly vouchersData: UserVouchersData;
  readonly isPreview?: boolean;
}

/**
 * Component hiển thị trang Ví voucher (SCR-PSG-36 - Figma 1448:20565).
 */
export function VouchersView({ vouchersData, isPreview = false }: VouchersViewProps) {
  const [activeTab, setActiveTab] = useState<UserVoucherStatus>("available");
  const [voucherCodeInput, setVoucherCodeInput] = useState<string>("");
  const [isSaving, setIsSaving] = useState<boolean>(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [saveSuccess, setSaveSuccess] = useState<string | null>(null);

  // Lọc voucher theo trạng thái tab (available bao gồm cả holding)
  const filteredVouchers = vouchersData.vouchers.filter((v) => {
    if (activeTab === "available") {
      return v.status === "available" || v.status === "holding";
    }
    return v.status === activeTab;
  });

  const handleSaveCode = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!voucherCodeInput.trim()) return;

    setIsSaving(true);
    setSaveError(null);
    setSaveSuccess(null);

    try {
      const res = await saveVoucherCode(voucherCodeInput.trim());
      if (res.status === "ok") {
        setSaveSuccess(`Đã lưu thành công mã ${voucherCodeInput.trim().toUpperCase()} vào ví!`);
        setVoucherCodeInput("");
      } else {
        setSaveError(
          "Tính năng lưu mã khuyến mãi hiện chưa sẵn sàng (endpoint POST /me/vouchers chưa khả dụng)."
        );
        console.warn("[Voucher] Gọi POST /me/vouchers bị từ chối do thiếu endpoint");
      }
    } catch {
      setSaveError("Đã xảy ra lỗi kết nối khi lưu mã khuyến mãi.");
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="flex flex-col gap-8 lg:flex-row">
      {/* 1. Cột Sidebar tài khoản bên trái */}
      <div className="w-full shrink-0 lg:w-72">
        <AccountSidebar activeTab="vouchers" isPreview={isPreview} />
      </div>

      {/* 2. Cột nội dung Ví voucher bên phải */}
      <div className="flex-1 space-y-6">
        {/* Header & Nút Đổi điểm */}
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <h1 className="text-xl font-black text-vxn-ink sm:text-2xl">Ví voucher</h1>
            <p className="mt-1 text-xs text-vxn-fg-4">
              Voucher đổi từ điểm và mã khuyến mãi công khai bạn đã lưu.
            </p>
          </div>

          <Link
            href="/plus?preview=redeem"
            className="inline-flex items-center gap-2 rounded-xl bg-[#00506a] px-4 py-2.5 text-xs font-bold text-white shadow-xs transition hover:bg-[#00476b]"
          >
            <Gift className="h-4 w-4" />
            <span>Đổi điểm lấy voucher</span>
          </Link>
        </div>

        {/* Khối Lưu mã khuyến mãi vào ví */}
        <div className="rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs sm:p-6">
          <h2 className="text-sm font-bold text-vxn-ink">Lưu mã khuyến mãi vào ví</h2>

          <form onSubmit={handleSaveCode} className="mt-3 flex flex-col gap-3 sm:flex-row">
            <div className="relative flex-1">
              <input
                type="text"
                placeholder="Nhập mã khuyến mãi, ví dụ THU10"
                value={voucherCodeInput}
                onChange={(e) => setVoucherCodeInput(e.target.value)}
                className="w-full rounded-xl border border-vxn-border bg-white px-4 py-2.5 text-xs font-bold uppercase placeholder:normal-case placeholder:font-normal text-vxn-ink focus:border-vxn-teal-600 focus:outline-hidden focus:ring-2 focus:ring-vxn-teal-500/20"
              />
            </div>
            <button
              type="submit"
              disabled={isSaving || !voucherCodeInput.trim()}
              className="rounded-xl bg-[#00506a] px-5 py-2.5 text-xs font-bold text-white shadow-xs transition hover:bg-[#00476b] disabled:opacity-50"
            >
              {isSaving ? "Đang lưu..." : "Lưu vào ví"}
            </button>
          </form>

          {saveError && (
            <div className="mt-3 flex items-start gap-2 rounded-xl border border-red-200 bg-red-50 p-3 text-xs text-red-700">
              <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
              <div>{saveError}</div>
            </div>
          )}

          {saveSuccess && (
            <div className="mt-3 flex items-start gap-2 rounded-xl border border-green-200 bg-green-50 p-3 text-xs text-green-700">
              <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0" />
              <div>{saveSuccess}</div>
            </div>
          )}

          <p className="mt-3 text-2xs text-vxn-fg-4">
            Mỗi mã chỉ lưu một lần. Lưu mã không giữ chỗ lượt dùng của chương trình.
          </p>
        </div>

        {/* Tabs trạng thái voucher */}
        <div className="flex items-center gap-2 border-b border-vxn-border/60 pb-1">
          <button
            type="button"
            onClick={() => setActiveTab("available")}
            className={`border-b-2 px-4 py-2.5 text-xs font-bold transition ${
              activeTab === "available"
                ? "border-vxn-teal-700 text-vxn-teal-800"
                : "border-transparent text-vxn-fg-4 hover:text-vxn-fg-2"
            }`}
          >
            Khả dụng ({vouchersData.availableCount})
          </button>
          <button
            type="button"
            onClick={() => setActiveTab("used")}
            className={`border-b-2 px-4 py-2.5 text-xs font-bold transition ${
              activeTab === "used"
                ? "border-vxn-teal-700 text-vxn-teal-800"
                : "border-transparent text-vxn-fg-4 hover:text-vxn-fg-2"
            }`}
          >
            Đã dùng ({vouchersData.usedCount})
          </button>
          <button
            type="button"
            onClick={() => setActiveTab("expired")}
            className={`border-b-2 px-4 py-2.5 text-xs font-bold transition ${
              activeTab === "expired"
                ? "border-vxn-teal-700 text-vxn-teal-800"
                : "border-transparent text-vxn-fg-4 hover:text-vxn-fg-2"
            }`}
          >
            Hết hạn ({vouchersData.expiredCount})
          </button>
        </div>

        {/* Danh sách thẻ voucher */}
        <div className="space-y-4">
          {filteredVouchers.map((v) => {
            const isHolding = v.status === "holding";
            const isExpiringSoon = v.statusLabel === "Sắp hết hạn";

            return (
              <div
                key={v.id}
                className="relative flex flex-col justify-between overflow-hidden rounded-2xl border border-vxn-border bg-white p-5 shadow-2xs transition hover:shadow-md sm:flex-row sm:items-center"
              >
                {/* Dải màu đánh dấu bên trái */}
                <div
                  className={`absolute top-0 bottom-0 left-0 w-1.5 ${
                    isHolding
                      ? "bg-slate-400"
                      : isExpiringSoon
                        ? "bg-amber-500"
                        : "bg-teal-600"
                  }`}
                />

                <div className="space-y-1.5 pl-2">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="rounded-md bg-slate-100 px-2 py-0.5 text-2xs font-bold text-slate-700">
                      {v.typeLabel}
                    </span>
                    <span
                      className={`rounded-md px-2 py-0.5 text-2xs font-bold ${
                        isHolding
                          ? "bg-slate-100 text-slate-700"
                          : isExpiringSoon
                            ? "bg-amber-50 text-amber-700"
                            : "bg-emerald-50 text-emerald-700"
                      }`}
                    >
                      {v.statusLabel}
                    </span>
                  </div>

                  <h3 className="text-base font-black text-vxn-ink">{v.title}</h3>

                  <p className="text-xs text-vxn-fg-3">{v.scopeText}</p>

                  <p className="text-2xs font-medium text-vxn-fg-4">Hạn dùng {v.expiryDateText}</p>
                </div>

                {/* Nút Dùng ngay */}
                <div className="mt-4 shrink-0 sm:mt-0 sm:pl-4">
                  {!isHolding ? (
                    <Link
                      href="/trips"
                      className="inline-flex items-center gap-1.5 text-xs font-bold text-vxn-teal-700 hover:text-vxn-teal-800 hover:underline"
                    >
                      <span>Dùng ngay</span>
                      <ArrowRight className="h-3.5 w-3.5" />
                    </Link>
                  ) : (
                    <span className="text-xs font-semibold text-vxn-fg-4 italic">
                      Đang được áp dụng
                    </span>
                  )}
                </div>
              </div>
            );
          })}
        </div>

        {/* Chú thích phía dưới danh sách */}
        <div className="rounded-xl bg-vxn-bg-soft/70 p-4 text-2xs leading-relaxed text-vxn-fg-4">
          Voucher đang giữ sẽ chuyển thành &quot;Đã dùng&quot; khi thanh toán thành công, hoặc trở về ví
          nếu đơn hết hạn hay thanh toán thất bại.
        </div>
      </div>
    </div>
  );
}
