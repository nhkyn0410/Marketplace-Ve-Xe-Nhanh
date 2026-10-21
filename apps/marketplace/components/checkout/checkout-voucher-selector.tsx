import { Tag } from "lucide-react";
import type { CheckoutPromotionQuote } from "../../lib/data/types";

/** Dữ liệu và thao tác kiểm mã khuyến mãi công khai của bước nhập hành khách. */
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
}

/** Nhập mã công khai, hiển thị báo giá đã kiểm và cho phép bỏ mã trước khi tạo đơn. */
export function CheckoutVoucherSelector({ code, quote, error, isChecking, isDisabled, isPreview, onChange, onApply, onRemove }: CheckoutVoucherSelectorProps) {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <h3 className="flex items-center gap-2 text-base font-bold text-vxn-ink sm:text-lg"><Tag className="h-4 w-4 text-vxn-teal-700" />Ưu đãi</h3>
      <label htmlFor="checkout-promotion-code" className="mt-4 block text-xs font-semibold text-vxn-fg-3">Mã khuyến mãi</label>
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
          className="min-w-0 flex-1 rounded-xl border border-vxn-border px-3 py-2.5 text-sm uppercase disabled:bg-neutral-50 disabled:text-neutral-400"
        />
        <button type="button" onClick={onApply} disabled={isDisabled || !code.trim()} className="rounded-xl bg-vxn-teal-800 px-4 py-2.5 text-xs font-bold text-white disabled:cursor-not-allowed disabled:opacity-50">
          {isChecking ? "Đang kiểm tra…" : "Áp dụng"}
        </button>
        {code && <button type="button" onClick={onRemove} disabled={isDisabled} className="rounded-xl border border-vxn-border px-3 py-2.5 text-xs font-semibold text-vxn-fg-3 disabled:cursor-not-allowed disabled:opacity-50">Xóa mã</button>}
      </div>
      <div id="checkout-promotion-status" aria-live="polite" className="mt-2 text-xs leading-relaxed">
        {error && <p className="text-amber-800">{error}</p>}
        {quote && <p className="text-emerald-700">Đã áp dụng {quote.code} · {quote.name}. Số tiền giảm được hiển thị trong tóm tắt thanh toán.</p>}
      </div>
      <p className="mt-2 text-xs leading-relaxed text-vxn-fg-4">Mã được kiểm tra lại khi tạo đơn; lượt ưu đãi chưa được giữ ở bước này. Voucher đổi điểm trong ví chưa thể áp dụng tại đây.</p>
      {isPreview && <p className="mt-2 text-xs text-vxn-fg-4">Đây là giao diện xem trước; thao tác áp mã và tạo đơn đã được tắt.</p>}
    </section>
  );
}
