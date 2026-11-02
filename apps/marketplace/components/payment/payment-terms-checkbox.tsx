"use client";

import { Info } from "lucide-react";
import Link from "next/link";

/**
 * Thuộc tính của component xác nhận điều khoản thanh toán.
 */
export interface PaymentTermsCheckboxProps {
  readonly isAgreed: boolean;
  readonly onToggleAgreed?: (agreed: boolean) => void;
}

/**
 * Khối cam kết điều khoản và lưu ý kiểm tra giá trước khi thanh toán theo Figma 1444:13055.
 */
export function PaymentTermsCheckbox({
  isAgreed,
  onToggleAgreed
}: PaymentTermsCheckboxProps) {
  return (
    <div className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs space-y-4">
      {/* Checkbox điều khoản */}
      <label className="flex items-start gap-3 cursor-pointer select-none">
        <input
          type="checkbox"
          checked={isAgreed}
          onChange={(e) => onToggleAgreed?.(e.target.checked)}
          className="mt-0.5 h-4 w-4 rounded border-neutral-300 text-vxn-teal-800 focus:ring-vxn-teal-700 cursor-pointer"
        />
        <span className="text-xs sm:text-sm text-vxn-ink font-medium leading-relaxed">
          Tôi đã đọc và đồng ý{" "}
          <Link
            href="/legal/terms"
            target="_blank"
            className="text-vxn-teal-800 font-semibold underline hover:text-vxn-teal-900"
          >
            Điều khoản sử dụng
          </Link>
          ,{" "}
          <Link
            href="/legal/privacy"
            target="_blank"
            className="text-vxn-teal-800 font-semibold underline hover:text-vxn-teal-900"
          >
            Chính sách bảo mật
          </Link>{" "}
          và{" "}
          <Link
            href="/legal/refund-policy"
            target="_blank"
            className="text-vxn-teal-800 font-semibold underline hover:text-vxn-teal-900"
          >
            chính sách hủy / hoàn tiền
          </Link>{" "}
          của chuyến này.
        </span>
      </label>

      {/* Info Callout */}
      <div className="flex items-start gap-2.5 rounded-xl bg-teal-50/50 p-3.5 text-xs text-vxn-teal-900 border border-teal-100">
        <Info className="h-4 w-4 shrink-0 text-vxn-teal-700 mt-0.5" />
        <p className="leading-relaxed">
          Giá vé và tình trạng chỗ được kiểm tra lại trước khi chuyển sang cổng thanh toán. Nếu có thay đổi, bạn sẽ được hỏi xác nhận lại.
        </p>
      </div>
    </div>
  );
}
