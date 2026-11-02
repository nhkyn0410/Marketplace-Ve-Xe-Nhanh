"use client";

import { SupportedPaymentMethod } from "../../lib/data/types";

/**
 * Thuộc tính của component chọn phương thức thanh toán.
 */
export interface PaymentMethodSelectorProps {
  readonly selectedMethod: SupportedPaymentMethod;
  readonly onSelectMethod?: (method: SupportedPaymentMethod) => void;
}

/**
 * Khối chọn phương thức thanh toán VNPay và MoMo theo Figma 1444:13055.
 */
export function PaymentMethodSelector({
  selectedMethod,
  onSelectMethod
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
            <div className="flex h-9 w-16 shrink-0 items-center justify-center rounded-lg border border-neutral-200 bg-white font-extrabold text-xs text-blue-700 tracking-tighter shadow-2xs">
              VNPAY
            </div>

            {/* Tên & mô tả */}
            <div className="flex-1 min-w-0">
              <h4 className="text-sm font-bold text-vxn-ink">VNPay</h4>
              <p className="mt-0.5 text-xs text-vxn-fg-4">
                Chọn ngân hàng hoặc cách thanh toán trên cổng VNPay.
              </p>
            </div>
          </div>

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
          <div className="flex h-9 w-16 shrink-0 items-center justify-center rounded-lg border border-neutral-200 bg-pink-50 font-extrabold text-xs text-pink-600 shadow-2xs">
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
