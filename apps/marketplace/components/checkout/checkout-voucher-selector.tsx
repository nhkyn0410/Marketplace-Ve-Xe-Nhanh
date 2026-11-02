"use client";

import { Tag } from "lucide-react";
import { useState } from "react";
import type { CheckoutPromotionQuote, CheckoutVoucherItem } from "../../lib/data/types";

/** Dữ liệu và thao tác ưu đãi của bước nhập hành khách: voucher trong ví hoặc mã khuyến mãi công khai. */
interface CheckoutVoucherSelectorProps {
  readonly code: string;
  readonly quote: CheckoutPromotionQuote | null;
  readonly error: string | null;
  readonly isChecking: boolean;
  readonly isDisabled: boolean;
  readonly isPreview: boolean;
  readonly onChange: (code: string) => void;
  readonly onApply: () => void;
  readonly onRemove: () => void;
  /** Voucher khả dụng trong ví, đã được máy chủ báo giá cho chuyến này (rỗng với khách vãng lai). */
  readonly vouchers?: readonly CheckoutVoucherItem[];
  readonly selectedVoucherId?: string | null;
  readonly onSelectVoucher?: (voucherId: string | null) => void;
}

/** Khối "Ưu đãi" theo Figma 1444:12945: tab Ví voucher / Nhập mã, mỗi đơn tối đa một ưu đãi. */
export function CheckoutVoucherSelector({
  code,
  quote,
  error,
  isChecking,
  isDisabled,
  isPreview,
  onChange,
  onApply,
  onRemove,
  vouchers = [],
  selectedVoucherId = null,
  onSelectVoucher
}: CheckoutVoucherSelectorProps) {
  const hasWallet = vouchers.length > 0;
  const [tab, setTab] = useState<"wallet" | "code">(hasWallet ? "wallet" : "code");
  const tabClass = (active: boolean) =>
    `rounded-md px-3 py-1.5 text-sm transition ${active ? "bg-white font-semibold text-foreground shadow-[0_1px_1px_rgb(16_24_40/0.05)]" : "font-medium text-vxn-fg-5 hover:text-foreground"}`;

  return (
    <section className="flex flex-col gap-3.5 rounded-xl border border-vxn-border bg-white p-5">
      <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
        <div className="min-w-0">
          <h3 className="text-lg/6 font-semibold text-vxn-ink">Ưu đãi</h3>
          <p className="text-[13px]/[19.5px] text-vxn-fg-5">Mỗi đơn áp dụng tối đa một voucher hoặc một mã khuyến mãi.</p>
        </div>
        {hasWallet && (
          <div role="tablist" aria-label="Loại ưu đãi" className="flex shrink-0 gap-0.5 self-start rounded-lg bg-muted p-1 sm:self-auto">
            <button type="button" role="tab" aria-selected={tab === "wallet"} onClick={() => setTab("wallet")} className={tabClass(tab === "wallet")}>
              Ví voucher ({vouchers.length})
            </button>
            <button type="button" role="tab" aria-selected={tab === "code"} onClick={() => setTab("code")} className={tabClass(tab === "code")}>
              Nhập mã
            </button>
          </div>
        )}
      </div>

      {hasWallet && tab === "wallet" ? (
        <div role="radiogroup" aria-label="Voucher trong ví" className="flex flex-col gap-3.5">
          {vouchers.map((voucher) => {
            const selected = voucher.id === selectedVoucherId;
            return (
              <button
                key={voucher.id}
                type="button"
                role="radio"
                aria-checked={selected}
                disabled={isDisabled || !voucher.isApplicable}
                onClick={() => onSelectVoucher?.(voucher.id)}
                className={`flex w-full items-center gap-3 rounded-[10px] p-3.5 text-left transition ${
                  selected ? "border-2 border-vxn-teal-700 bg-accent" : "border border-vxn-border bg-white hover:border-vxn-teal-700/50"
                } ${voucher.isApplicable ? "" : "cursor-not-allowed opacity-55"}`}
              >
                <span className={`flex size-[18px] shrink-0 items-center justify-center rounded-full bg-white ${selected ? "border-2 border-vxn-teal-700" : "border border-vxn-border"}`}>
                  {selected && <span className="size-2 rounded-full bg-vxn-teal-700" />}
                </span>
                <span className="flex size-10 shrink-0 items-center justify-center rounded-[10px] bg-[#fef8ec] text-vxn-saffron-600">
                  <Tag className="size-[18px]" />
                </span>
                <span className="min-w-0 flex-1">
                  <span className="block text-sm/5 font-semibold text-vxn-ink">{voucher.title}</span>
                  <span className="block text-[13px]/[19.5px] text-vxn-fg-5">{voucher.description}</span>
                </span>
                <span
                  className={`shrink-0 rounded-lg px-2 py-1 text-xs/[18px] font-medium ${
                    voucher.isApplicable && voucher.tagText === "Đổi từ điểm" ? "bg-success-50 text-success-600" : "bg-muted text-vxn-fg-5"
                  }`}
                >
                  {voucher.tagText}
                </span>
              </button>
            );
          })}
          {selectedVoucherId && (
            <button type="button" onClick={() => onSelectVoucher?.(null)} disabled={isDisabled} className="self-start text-[13px] text-primary hover:underline disabled:opacity-50">
              Không dùng ưu đãi cho đơn này
            </button>
          )}
        </div>
      ) : (
        <div>
          <label htmlFor="checkout-promotion-code" className="block text-sm font-medium text-vxn-ink">Mã khuyến mãi</label>
          <div className="mt-2 flex flex-wrap gap-2">
            <input
              id="checkout-promotion-code"
              value={code}
              onChange={(event) => onChange(event.target.value)}
              disabled={isDisabled}
              maxLength={20}
              autoCapitalize="characters"
              autoComplete="off"
              spellCheck={false}
              aria-invalid={Boolean(error)}
              aria-describedby="checkout-promotion-status"
              placeholder="Nhập mã khuyến mãi"
              className="min-w-0 flex-1 rounded-xl border border-vxn-border px-3 py-2.5 text-sm uppercase outline-none focus:border-vxn-teal-700 disabled:bg-neutral-50 disabled:text-neutral-400"
            />
            <button type="button" onClick={onApply} disabled={isDisabled || !code.trim()} className="rounded-xl bg-vxn-teal-700 px-4 py-2.5 text-sm font-semibold text-white hover:bg-vxn-teal-800 disabled:cursor-not-allowed disabled:opacity-50">
              {isChecking ? "Đang kiểm tra…" : "Áp dụng"}
            </button>
            {code && (
              <button type="button" onClick={onRemove} disabled={isDisabled} className="rounded-xl border border-vxn-border px-3 py-2.5 text-sm font-medium text-vxn-fg-3 disabled:cursor-not-allowed disabled:opacity-50">
                Xóa mã
              </button>
            )}
          </div>
          <div id="checkout-promotion-status" aria-live="polite" className="mt-2 text-[13px] leading-relaxed">
            {error && <p className="text-amber-800">{error}</p>}
            {quote && <p className="text-success-600">Đã áp dụng {quote.code} · {quote.name}. Số tiền giảm được hiển thị trong tóm tắt thanh toán.</p>}
          </div>
          <p className="mt-1 text-xs leading-relaxed text-vxn-fg-5">
            Mã được kiểm tra lại khi tạo đơn; lượt ưu đãi chưa được giữ ở bước này.
            {!hasWallet && " Đăng nhập để dùng voucher trong ví."}
          </p>
        </div>
      )}

      {isPreview && <p className="text-xs text-vxn-fg-5">Đây là giao diện xem trước; thao tác áp ưu đãi và tạo đơn đã được tắt.</p>}
    </section>
  );
}
