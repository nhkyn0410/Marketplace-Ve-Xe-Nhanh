"use client";

import { SupportedPaymentMethod, VNPayBankOption } from "../../lib/data/types";

/**
 * Thuộc tính của component chọn phương thức thanh toán.
 */
export interface PaymentMethodSelectorProps {
  readonly selectedMethod: SupportedPaymentMethod;
  readonly selectedBank: VNPayBankOption;
  readonly onSelectMethod?: (method: SupportedPaymentMethod) => void;
  readonly onSelectBank?: (bank: VNPayBankOption) => void;
}

const VNPAY_BANKS: readonly { readonly id: VNPayBankOption; readonly label: string }[] = [
  { id: "vnpay_qr", label: "VNPay QR" },
  { id: "vietcombank", label: "Vietcombank" },
  { id: "vietinbank", label: "VietinBank" },
  { id: "bidv", label: "BIDV" },
  { id: "techcombank", label: "Techcombank" },
  { id: "mbbank", label: "MB Bank" },
  { id: "acb", label: "ACB" },
  { id: "international_card", label: "Thẻ quốc tế" }
];

/**
 * Khối chọn phương thức thanh toán VNPay và MoMo theo Figma 1444:13055.
 */
export function PaymentMethodSelector({
  selectedMethod,
  selectedBank,
  onSelectMethod,
  onSelectBank
}: PaymentMethodSelectorProps) {
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

      <div className="mt-5 space-y-3.5">
        {/* 1. Lựa chọn VNPay */}
        <div
          onClick={() => onSelectMethod?.("vnpay")}
          className={`rounded-2xl p-4 sm:p-5 transition cursor-pointer ${
            selectedMethod === "vnpay"
              ? "border-2 border-vxn-teal-800 bg-teal-50/10 shadow-2xs"
              : "border border-vxn-border bg-white hover:border-neutral-300"
          }`}
          role="radio"
          aria-checked={selectedMethod === "vnpay"}
        >
          <div className="flex items-start gap-3.5">
            {/* Radio icon */}
            <div className="mt-1 shrink-0">
              {selectedMethod === "vnpay" ? (
                <div className="flex h-4 w-4 items-center justify-center rounded-full border-2 border-vxn-teal-800">
                  <div className="h-2 w-2 rounded-full bg-vxn-teal-800" />
                </div>
              ) : (
                <div className="h-4 w-4 rounded-full border border-neutral-300" />
              )}
            </div>

            {/* Logo Badge */}
            <div className="flex h-9 w-16 shrink-0 items-center justify-center rounded-lg border border-neutral-200 bg-white font-black text-xs text-blue-700 tracking-tighter shadow-2xs">
              VNPAY
            </div>

            {/* Tên & mô tả */}
            <div className="flex-1 min-w-0">
              <h4 className="text-sm font-bold text-vxn-ink">VNPay</h4>
              <p className="mt-0.5 text-xs text-vxn-fg-4">
                Quét mã QR, thẻ ATM nội địa hoặc thẻ quốc tế
              </p>
            </div>
          </div>

          {/* Danh sách ngân hàng chọn nhanh (khi chọn VNPay) */}
          {selectedMethod === "vnpay" && (
            <div className="mt-4 pt-3.5 border-t border-neutral-200/70 animate-in fade-in-50 duration-200">
              <p className="text-[11px] font-medium text-vxn-fg-4">
                Chọn nhanh ngân hàng (có thể chọn lại trên cổng VNPay)
              </p>
              <div className="mt-2.5 flex flex-wrap gap-2">
                {VNPAY_BANKS.map((b) => {
                  const isBankSelected = selectedBank === b.id;
                  return (
                    <button
                      key={b.id}
                      type="button"
                      onClick={(e) => {
                        e.stopPropagation();
                        onSelectBank?.(b.id);
                      }}
                      className={`rounded-xl px-3 py-1.5 text-xs font-semibold transition cursor-pointer ${
                        isBankSelected
                          ? "border-2 border-vxn-teal-800 bg-white text-vxn-teal-900 shadow-2xs"
                          : "border border-neutral-200 bg-white text-neutral-700 hover:border-neutral-300 hover:bg-neutral-50"
                      }`}
                    >
                      {b.label}
                    </button>
                  );
                })}
              </div>
            </div>
          )}
        </div>

        {/* 2. Lựa chọn Ví MoMo */}
        <div
          onClick={() => onSelectMethod?.("momo")}
          className={`flex items-start gap-3.5 rounded-2xl p-4 sm:p-5 transition cursor-pointer ${
            selectedMethod === "momo"
              ? "border-2 border-vxn-teal-800 bg-teal-50/10 shadow-2xs"
              : "border border-vxn-border bg-white hover:border-neutral-300"
          }`}
          role="radio"
          aria-checked={selectedMethod === "momo"}
        >
          {/* Radio icon */}
          <div className="mt-1 shrink-0">
            {selectedMethod === "momo" ? (
              <div className="flex h-4 w-4 items-center justify-center rounded-full border-2 border-vxn-teal-800">
                <div className="h-2 w-2 rounded-full bg-vxn-teal-800" />
              </div>
            ) : (
              <div className="h-4 w-4 rounded-full border border-neutral-300" />
            )}
          </div>

          {/* Logo Badge */}
          <div className="flex h-9 w-16 shrink-0 items-center justify-center rounded-lg border border-neutral-200 bg-pink-50 font-black text-xs text-pink-600 shadow-2xs">
            MoMo
          </div>

          {/* Tên & mô tả */}
          <div className="flex-1 min-w-0">
            <h4 className="text-sm font-bold text-vxn-ink">Ví MoMo</h4>
            <p className="mt-0.5 text-xs text-vxn-fg-4">
              Thanh toán bằng ứng dụng MoMo hoặc mã QR MoMo
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}
