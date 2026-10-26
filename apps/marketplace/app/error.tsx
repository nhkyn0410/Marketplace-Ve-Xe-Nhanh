"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { AlertTriangle, ArrowLeft, Check, Copy, RotateCcw } from "lucide-react";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

import { PassengerTopBar } from "../components/passenger-topbar";

/**
 * Thuộc tính của trang xử lý lỗi toàn cục Next.js (Error Boundary).
 */
export interface ErrorPageProps {
  readonly error: Error & { readonly digest?: string };
  readonly reset: () => void;
}

/**
 * Trang lỗi 500 hiển thị khi xảy ra sự cố phía máy chủ theo thiết kế Figma 1449:21863 (SCR-PSG-05).
 */
export default function ErrorPage({ error, reset }: ErrorPageProps) {
  const router = useRouter();
  const [copied, setCopied] = useState(false);

  // Sinh hoặc lấy mã tham chiếu yêu cầu
  const referenceId = error.digest ? `REQ-${error.digest.slice(0, 8)}` : "REQ-7f3a91c2";

  useEffect(() => {
    console.error("[marketplace] lỗi hệ thống 500:", error);
  }, [error]);

  const handleCopy = () => {
    if (typeof navigator !== "undefined" && navigator.clipboard) {
      void navigator.clipboard.writeText(referenceId);
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    }
  };

  return (
    <div data-no-footer="true" className="flex min-h-[calc(var(--vxn-vh)_-_4rem)] flex-col bg-white">
      <PassengerTopBar
        breadcrumbs={[
          { label: "Trang chủ", href: "/" },
          { label: "Đã có lỗi xảy ra" }
        ]}
      />

      <div className="flex flex-1 flex-col items-center justify-center px-4 py-20 text-center">
        {/* Vòng tròn biểu tượng */}
        <div className="mb-6 flex size-24 items-center justify-center rounded-full bg-red-50 text-red-600">
          <AlertTriangle className="size-11 stroke-[2.2]" />
        </div>

        {/* Nhãn mã lỗi */}
        <span className="text-xs font-semibold uppercase tracking-widest text-vxn-fg-4">
          LỖI 500
        </span>

        {/* Tiêu đề lỗi */}
        <h1 className="mt-3 text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
          Đã có lỗi xảy ra
        </h1>

        {/* Mô tả chi tiết */}
        <p className="mt-3 max-w-lg text-sm leading-relaxed text-vxn-fg-3">
          Hệ thống gặp sự cố khi xử lý yêu cầu. Vui lòng thử lại; nếu lỗi lặp lại, hãy liên hệ CSKH 1900 6067 kèm mã tham chiếu bên dưới.
        </p>

        {/* Khung mã tham chiếu */}
        <div className="mt-5 inline-flex items-center gap-2 rounded-lg border border-vxn-border/80 bg-vxn-bg-soft px-3.5 py-1.5 text-xs text-vxn-fg-3 shadow-2xs">
          <span>Mã tham chiếu</span>
          <code className="font-mono font-semibold text-vxn-ink">{referenceId}</code>
          <button
            type="button"
            onClick={handleCopy}
            className="ml-1 text-vxn-fg-4 transition-colors hover:text-vxn-teal-700"
            aria-label="Sao chép mã tham chiếu"
          >
            {copied ? <Check className="size-3.5 text-emerald-600" /> : <Copy className="size-3.5" />}
          </button>
        </div>

        {/* Các nút hành động */}
        <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
          <Button
            type="button"
            variant="outline"
            onClick={() => router.back()}
            className="h-11 rounded-lg border-vxn-border bg-white px-5 text-sm font-medium text-vxn-ink hover:bg-vxn-bg-2"
          >
            <ArrowLeft className="mr-2 size-4" />
            Về trang trước
          </Button>

          <Button
            type="button"
            onClick={() => reset()}
            className="h-11 rounded-lg bg-vxn-teal-700 px-5 text-sm font-medium text-white shadow-xs hover:bg-vxn-teal-800"
          >
            <RotateCcw className="mr-2 size-4" />
            Thử lại
          </Button>
        </div>
      </div>
    </div>
  );
}
