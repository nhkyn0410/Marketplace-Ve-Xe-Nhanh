import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { X } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

/** Kiểu chữ và control của modal xác thực theo kit Figma `Auth / *` (Email Input, Primary Button). */
export const AUTH_TITLE = "text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink";
export const AUTH_SUBTITLE = "text-sm/5 text-vxn-fg-5";
export const AUTH_LABEL = "text-sm/[21px] font-medium text-[#1c1e22]";
export const AUTH_INPUT =
  "h-14 w-full rounded-2xl border bg-white px-4 text-base text-[#1c1e22] transition-colors placeholder:text-vxn-fg-5 focus:border-vxn-teal-500 focus:outline-none focus:ring-2 focus:ring-vxn-teal-500/20";
export const AUTH_PRIMARY_BUTTON =
  "h-14 w-full rounded-2xl bg-vxn-teal-500 text-base font-semibold text-white shadow-none hover:bg-vxn-teal-600 disabled:opacity-60";
export const AUTH_LINK = "font-semibold text-primary hover:underline";

/**
 * Khung chung của 4 màn xác thực (SCR-PSG-07..10): modal 480px nổi trên nền trang làm mờ
 * (Figma: overlay #081721 55%), logo 168×43, nút đóng và ô trái tuỳ chọn (vd "Đổi email").
 */
export function AuthModalShell({
  children,
  topLeft,
  showClose = true
}: {
  readonly children: ReactNode;
  readonly topLeft?: ReactNode;
  readonly showClose?: boolean;
}) {
  return (
    <div className="relative flex min-h-[calc(var(--vxn-vh)_-_4rem)] items-center justify-center overflow-hidden p-4 sm:p-6 lg:min-h-viewport">
      {/* Nền: ảnh trang chủ làm mờ thay cho trang phía sau khi mở thẳng đường dẫn */}
      <div aria-hidden="true" className="absolute inset-0 bg-[url('/images/hero-bg.jpg')] bg-cover bg-center" />
      <div aria-hidden="true" className="absolute inset-0 bg-[rgb(8_23_33/0.55)]" />

      <section className="relative flex w-full max-w-[480px] flex-col items-center gap-4 rounded-3xl border border-border bg-card p-6 shadow-[0_12px_16px_-4px_rgb(16_24_40/0.08),0_4px_6px_-2px_rgb(16_24_40/0.03)] sm:p-9">
        {(topLeft || showClose) && (
          <div className="flex w-full items-start justify-between">
            <div>{topLeft}</div>
            {showClose && (
              <Link href="/" aria-label="Đóng" className="rounded-full p-0.5 text-vxn-fg-5 transition-colors hover:bg-muted hover:text-vxn-ink">
                <X className="size-5" />
              </Link>
            )}
          </div>
        )}
        <LogoWordmark className="h-[43px] w-auto shrink-0 text-vxn-teal-500" />
        {children}
      </section>
    </div>
  );
}
