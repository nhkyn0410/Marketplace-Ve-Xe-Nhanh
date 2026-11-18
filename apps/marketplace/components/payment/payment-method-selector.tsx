"use client";

import type { PaymentProviderOption, SupportedPaymentMethod } from "../../lib/data/types";

/** Cổng dùng khi chưa đọc được danh sách từ máy chủ: giữ cách cũ của web (VNPay, MoMo) để khách vẫn thanh toán được. */
export const FALLBACK_PAYMENT_PROVIDERS: readonly PaymentProviderOption[] = [
  { method: "vnpay", enabled: true },
  { method: "momo", enabled: true }
];

const METHODS: Readonly<Record<SupportedPaymentMethod, { readonly badge: string; readonly badgeClass: string; readonly title: string; readonly description: string }>> = {
  payos: {
    badge: "VietQR",
    badgeClass: "bg-emerald-50 text-emerald-700",
    title: "Chuyển khoản VietQR qua payOS",
    description: "Quét mã VietQR hoặc chuyển khoản bằng ứng dụng ngân hàng."
  },
  momo: {
    badge: "MoMo",
    badgeClass: "bg-pink-50 text-pink-600",
    title: "Ví MoMo",
    description: "Thanh toán bằng ứng dụng MoMo hoặc mã QR MoMo"
  },
  vnpay: {
    badge: "VNPAY",
    badgeClass: "bg-white text-blue-700 tracking-tighter",
    title: "VNPay",
    description: "Chọn ngân hàng hoặc cách thanh toán trên cổng VNPay."
  },
  demo: {
    badge: "DEMO",
    badgeClass: "bg-neutral-100 text-neutral-700",
    title: "Cổng thanh toán thử",
    description: "Mô phỏng thanh toán, không chuyển tiền thật."
  }
};

/** Cổng hiện trên màn: cổng đang bật, và cổng thật chưa bật (mờ, "Sắp hỗ trợ"). Cổng thử chưa bật thì ẩn hẳn. */
export function visiblePaymentProviders(providers: readonly PaymentProviderOption[]): readonly PaymentProviderOption[] {
  return providers.filter((provider) => provider.enabled || provider.method !== "demo");
}

/** Cổng mặc định: cổng của lần thanh toán trước nếu còn bật, không thì cổng đang bật đầu tiên. */
export function defaultPaymentMethod(
  providers: readonly PaymentProviderOption[],
  previous?: SupportedPaymentMethod
): SupportedPaymentMethod | undefined {
  const enabled = providers.filter((provider) => provider.enabled).map((provider) => provider.method);
  return previous && enabled.includes(previous) ? previous : enabled[0];
}

/**
 * Thuộc tính của component chọn phương thức thanh toán.
 */
export interface PaymentMethodSelectorProps {
  readonly providers: readonly PaymentProviderOption[];
  readonly selectedMethod?: SupportedPaymentMethod;
  readonly onSelectMethod?: (method: SupportedPaymentMethod) => void;
}

/**
 * Khối chọn phương thức thanh toán (SCR-PSG-20): danh sách cổng lấy từ máy chủ, thứ tự payOS, MoMo, VNPay, cổng thử.
 */
export function PaymentMethodSelector({
  providers,
  selectedMethod,
  onSelectMethod
}: PaymentMethodSelectorProps) {
  const visible = visiblePaymentProviders(providers);
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Phương thức thanh toán
        </h3>
        <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
          Bạn sẽ được chuyển sang cổng thanh toán để hoàn tất, sau đó quay lại Vé Xe Nhanh.
        </p>
      </div>

      <div className="mt-5 space-y-3.5" role="radiogroup" aria-label="Phương thức thanh toán">
        {!providers.some((provider) => provider.enabled) && (
          <p className="rounded-xl bg-amber-50 px-4 py-3 text-xs text-amber-900">
            Hiện chưa có cổng thanh toán nào hoạt động. Vui lòng quay lại sau.
          </p>
        )}
        {visible.map(({ method, enabled }) => {
          const info = METHODS[method];
          const checked = enabled && selectedMethod === method;
          return (
            <div
              key={method}
              data-method={method}
              onClick={enabled ? () => onSelectMethod?.(method) : undefined}
              className={`flex items-start gap-3.5 rounded-2xl p-4 sm:p-5 transition ${
                !enabled
                  ? "cursor-not-allowed border border-dashed border-vxn-border bg-neutral-50 opacity-60"
                  : checked
                    ? "cursor-pointer border-2 border-vxn-teal-800 bg-teal-50/10 shadow-2xs"
                    : "cursor-pointer border border-vxn-border bg-white hover:border-neutral-300"
              }`}
              role="radio"
              aria-checked={checked}
              aria-disabled={!enabled}
            >
              {/* Radio icon */}
              <div className="mt-1 shrink-0">
                {checked ? (
                  <div className="flex h-4 w-4 items-center justify-center rounded-full border-2 border-vxn-teal-800">
                    <div className="h-2 w-2 rounded-full bg-vxn-teal-800" />
                  </div>
                ) : (
                  <div className="h-4 w-4 rounded-full border border-neutral-300" />
                )}
              </div>

              {/* Logo Badge */}
              <div className={`flex h-9 w-16 shrink-0 items-center justify-center rounded-lg border border-neutral-200 text-xs font-extrabold shadow-2xs ${info.badgeClass}`}>
                {info.badge}
              </div>

              {/* Tên & mô tả */}
              <div className="flex-1 min-w-0">
                <h4 className="text-sm font-bold text-vxn-ink">
                  {info.title}
                  {!enabled && <span className="ml-2 rounded-full bg-neutral-200 px-2 py-0.5 text-[11px] font-semibold text-neutral-600">Sắp hỗ trợ</span>}
                </h4>
                <p className="mt-0.5 text-xs text-vxn-fg-4">{info.description}</p>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}
