"use client";

import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { X } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, type ReactNode } from "react";

/**
 * `page`: mở thẳng đường dẫn (/login…) — modal trên nền ảnh trang chủ làm mờ.
 * `overlay`: mở từ trong web (intercepting route `app/@modal`) — modal phủ lên chính trang đang xem như Figma.
 */
export type AuthModalVariant = "page" | "overlay";

const CARD =
  "relative flex w-full max-w-[480px] flex-col items-center gap-4 rounded-3xl border border-border bg-card p-6 shadow-[0_12px_16px_-4px_rgb(16_24_40/0.08),0_4px_6px_-2px_rgb(16_24_40/0.03)] sm:p-9";

/**
 * Khung chung của các màn xác thực (SCR-PSG-07..10): modal 480px trên lớp phủ #081721 55%,
 * logo 168×43, nút đóng và ô trái tuỳ chọn (vd "Đổi email").
 */
export function AuthModalShell({
  children,
  topLeft,
  showClose = true,
  variant = "page"
}: {
  readonly children: ReactNode;
  readonly topLeft?: ReactNode;
  readonly showClose?: boolean;
  readonly variant?: AuthModalVariant;
}) {
  const router = useRouter();
  const isOverlay = variant === "overlay";

  // Overlay: Esc đóng modal, quay về trang phía dưới
  useEffect(() => {
    if (!isOverlay) return;
    const onKey = (event: KeyboardEvent) => {
      if (event.key === "Escape") router.back();
    };
    window.addEventListener("keydown", onKey);
    return () => window.removeEventListener("keydown", onKey);
  }, [isOverlay, router]);

  const closeClass = "rounded-full p-0.5 text-vxn-fg-5 transition-colors hover:bg-muted hover:text-vxn-ink";
  const card = (
    <section role={isOverlay ? "dialog" : undefined} aria-modal={isOverlay || undefined} className={CARD}>
      {(topLeft || showClose) && (
        <div className="flex w-full items-start justify-between">
          <div>{topLeft}</div>
          {showClose &&
            (isOverlay ? (
              <button type="button" onClick={() => router.back()} aria-label="Đóng" className={closeClass}>
                <X className="size-5" />
              </button>
            ) : (
              <Link href="/" aria-label="Đóng" className={closeClass}>
                <X className="size-5" />
              </Link>
            ))}
        </div>
      )}
      <LogoWordmark className="h-[43px] w-auto shrink-0 text-vxn-teal-500" />
      {children}
    </section>
  );

  if (isOverlay) {
    return (
      <div
        className="fixed inset-0 z-50 flex items-center justify-center overflow-y-auto bg-[rgb(8_23_33/0.55)] p-4"
        onClick={(event) => {
          if (event.target === event.currentTarget) router.back();
        }}
      >
        {card}
      </div>
    );
  }

  return (
    <div className="relative flex min-h-[calc(var(--vxn-vh)_-_4rem)] items-center justify-center overflow-hidden p-4 sm:p-6 lg:min-h-viewport">
      {/* Nền: ảnh trang chủ làm mờ thay cho trang phía sau khi mở thẳng đường dẫn */}
      <div aria-hidden="true" className="absolute inset-0 bg-[url('/images/hero-bg.jpg')] bg-cover bg-center" />
      <div aria-hidden="true" className="absolute inset-0 bg-[rgb(8_23_33/0.55)]" />
      {card}
    </div>
  );
}
