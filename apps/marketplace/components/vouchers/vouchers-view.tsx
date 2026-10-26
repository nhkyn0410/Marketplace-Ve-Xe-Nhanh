"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { AlertCircle, Award, CheckCircle2, Gift, Info, Tag } from "lucide-react";
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
  const router = useRouter();
  const [activeTab, setActiveTab] = useState<UserVoucherStatus>("available");
  const [voucherCodeInput, setVoucherCodeInput] = useState<string>("");
  const [isSaving, setIsSaving] = useState<boolean>(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [saveSuccess, setSaveSuccess] = useState<string | null>(null);

  const filteredVouchers = vouchersData.vouchers.filter((v) => v.status === activeTab);

  const handleSaveCode = async (e: React.FormEvent) => {
    e.preventDefault();
    if (isPreview || isSaving || !voucherCodeInput.trim()) return;

    setIsSaving(true);
    setSaveError(null);
    setSaveSuccess(null);

    try {
      const res = await saveVoucherCode(voucherCodeInput.trim());
      if (res.status === "ok") {
        setSaveSuccess(`Đã lưu thành công mã ${voucherCodeInput.trim().toUpperCase()} vào ví!`);
        setVoucherCodeInput("");
        router.refresh();
      } else {
        setSaveError(res.status === "error" ? res.message ?? "Không thể lưu mã khuyến mãi." : "Lưu mã chưa khả dụng.");
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
            <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">Ví voucher</h1>
            <p className="mt-1 text-xs text-vxn-fg-4">
              Voucher đổi từ điểm và mã khuyến mãi công khai bạn đã lưu.
            </p>
          </div>

          <Link
            href={isPreview ? "/plus?preview=redeem" : "/plus?redeem=1"}
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
                maxLength={20}
                disabled={isSaving || isPreview}
                onChange={(e) => setVoucherCodeInput(e.target.value)}
                className="w-full rounded-xl border border-vxn-border bg-white px-4 py-2.5 text-xs font-bold uppercase placeholder:normal-case placeholder:font-normal text-vxn-ink focus:border-vxn-teal-600 focus:outline-hidden focus:ring-2 focus:ring-vxn-teal-500/20"
              />
            </div>
            <button
              type="submit"
              disabled={isSaving || !voucherCodeInput.trim() || isPreview}
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

          <p className="mt-3 text-xs text-vxn-fg-4">
            Mỗi mã chỉ lưu một lần. Lưu mã không giữ chỗ lượt dùng của chương trình.
          </p>
          <p className="mt-2 text-xs text-vxn-fg-3">Bạn có thể lưu và theo dõi voucher tại đây. Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng.</p>
        </div>

        {/* Tabs trạng thái voucher */}
        <div className="flex flex-wrap items-center gap-2 border-b border-vxn-border/60 pb-1">
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
          <button type="button" onClick={() => setActiveTab("holding")}
            className={`border-b-2 px-4 py-2.5 text-xs font-bold transition ${activeTab === "holding" ? "border-vxn-teal-700 text-vxn-teal-800" : "border-transparent text-vxn-fg-4 hover:text-vxn-fg-2"}`}>
            Đang giữ ({vouchersData.holdingCount ?? vouchersData.vouchers.filter((v) => v.status === "holding").length})
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

        {/* Danh sách phiếu voucher — Figma 1448:20918 (lưới 2 cột, cuống trái theo nguồn voucher) */}
        {filteredVouchers.length === 0 && <p className="rounded-xl border bg-white p-5 text-sm text-vxn-fg-4">Chưa có voucher ở trạng thái này.</p>}
        <div className="grid grid-cols-1 gap-4 md:grid-cols-2">
          {filteredVouchers.map((v) => {
            const isRedemption = v.type === "loyalty_redemption";
            const isInactive = v.status === "used" || v.status === "expired";
            const StubIcon = isRedemption ? Award : Tag;
            const badgeClass =
              v.status === "expired"
                ? "bg-error-50 text-error-700"
                : v.status === "used" || v.status === "holding"
                  ? "bg-vxn-bg-mist text-vxn-fg-3"
                  : v.statusLabel === "Sắp hết hạn"
                    ? "bg-warning-50 text-warning-700"
                    : "bg-success-50 text-success-600";

            return (
              <div key={v.id} className={`flex overflow-hidden rounded-xl border border-vxn-border bg-white ${isInactive ? "opacity-70" : ""}`}>
                <div className={`flex w-24 shrink-0 flex-col items-center justify-center gap-1.5 p-3 ${isRedemption ? "bg-vxn-teal-700 text-white" : "bg-[#fef8ec] text-warning-700"}`}>
                  <StubIcon className="size-6" />
                  <span className="text-xs/[18px] font-medium">{v.typeLabel}</span>
                </div>
                <div className="flex min-w-0 flex-1 flex-col gap-1.5 p-4">
                  <div className="flex items-start gap-2">
                    <h3 className="min-w-0 flex-1 text-base/6 font-semibold text-vxn-ink">{v.title}</h3>
                    <span className={`shrink-0 rounded-lg px-2 py-1 text-xs/[18px] font-medium ${badgeClass}`}>{v.statusLabel}</span>
                  </div>
                  {v.discountLabel && <p className="text-[13px]/[19.5px] font-semibold text-vxn-teal-700">{v.discountLabel}</p>}
                  <p className="text-[13px]/[19.5px] text-foreground">{v.scopeText}</p>
                  {v.code && <p className="text-xs text-vxn-fg-5">Mã: <span className="font-mono font-semibold">{v.code}</span></p>}
                  <div className="mt-auto flex items-center justify-between gap-2 pt-1">
                    <span className="text-xs/[18px] text-vxn-fg-5">Hạn dùng {v.expiryDateText}</span>
                    {v.status === "available" ? (
                      <Link href="/trips" className="text-[13px] font-semibold whitespace-nowrap text-primary hover:underline">
                        Dùng ngay ›
                      </Link>
                    ) : (
                      <span className="text-xs whitespace-nowrap text-vxn-fg-5">{v.status === "holding" ? "Đang được áp dụng" : v.statusLabel}</span>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        {/* Chú thích phía dưới danh sách */}
        <div className="flex items-start gap-2 rounded-xl bg-vxn-bg-soft p-4 text-[13px]/[19.5px] text-vxn-fg-5">
          <Info className="mt-0.5 size-4 shrink-0" />
          Voucher đang giữ chưa thể dùng cho đơn khác. Trạng thái ví được cập nhật theo đơn vé.
        </div>
      </div>
    </div>
  );
}
