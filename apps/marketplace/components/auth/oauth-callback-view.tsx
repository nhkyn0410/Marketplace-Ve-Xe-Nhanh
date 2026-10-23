"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, Info, ArrowRight, Loader2 } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";

/**
 * Dữ liệu cấu hình cho OAuthCallbackView (SCR-PSG-10)
 */
export interface OAuthCallbackData {
  readonly provider?: string;
  readonly email?: string;
  readonly isExistingLinked?: boolean;
  readonly redirectUrl?: string;
}

export interface OAuthCallbackViewProps {
  readonly data?: OAuthCallbackData;
  readonly isPreview?: boolean;
}

/**
 * Màn hình OAuth Callback thành công chuẩn Figma node 1447:17897
 */
export const OAuthCallbackView: React.FC<OAuthCallbackViewProps> = ({
  data = {
    provider: "Google",
    email: "khach.nguyen@gmail.com",
    isExistingLinked: true,
    redirectUrl: "/"
  },
  isPreview = false
}) => {
  const router = useRouter();
  const provider = data.provider ?? "Google";
  const email = data.email ?? "khach.nguyen@gmail.com";
  const redirectUrl = data.redirectUrl ?? "/";

  const [hasRedirected, setHasRedirected] = useState<boolean>(false);

  useEffect(() => {
    // Chỉ tự động chuyển hướng khi không ở chế độ preview kiểm tra giao diện
    if (!isPreview && !hasRedirected) {
      const timer = setTimeout(() => {
        setHasRedirected(true);
        router.push(redirectUrl);
      }, 2500);
      return () => clearTimeout(timer);
    }
  }, [isPreview, redirectUrl, router, hasRedirected]);

  const handleContinue = () => {
    setHasRedirected(true);
    router.push(redirectUrl);
  };

  return (
    <div className="relative min-h-[calc(100vh-4rem)] flex items-center justify-center p-4 sm:p-6 bg-slate-900/40 backdrop-blur-xs">
      {/* Khung modal OAuth Callback chuẩn Figma node 1447:18260 */}
      <div className="relative w-full max-w-[480px] bg-white dark:bg-card rounded-3xl shadow-2xl border border-border p-6 sm:p-8 space-y-6">
        {/* Logo Vé Xe Nhanh ở giữa */}
        <div className="text-center pt-2">
          <div className="inline-flex items-center gap-2 mb-1">
            <svg
              className="h-8 w-auto"
              viewBox="0 0 160 36"
              fill="none"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                d="M10 6L2 20L10 30L22 30L30 16L18 16L22 6H10Z"
                fill="#F59E0B"
              />
              <path
                d="M18 6L10 20L18 30L30 30L38 16L26 16L30 6H18Z"
                fill="#0F5B60"
              />
              <text
                x="44"
                y="24"
                fontFamily="system-ui, -apple-system, sans-serif"
                fontWeight="800"
                fontSize="18"
                fill="#0F5B60"
              >
                Vé Xe
              </text>
              <text
                x="98"
                y="24"
                fontFamily="system-ui, -apple-system, sans-serif"
                fontWeight="800"
                fontSize="18"
                fill="#F59E0B"
              >
                Nhanh
              </text>
            </svg>
          </div>
        </div>

        {/* Khối Thông báo xác thực thành công (Auth / Authentication Success) */}
        <div className="bg-[#EBF5FA] dark:bg-sky-950/40 rounded-2xl p-6 flex flex-col items-center justify-center text-center space-y-3">
          {/* Icon Verified checkmark tròn to */}
          <div className="w-12 h-12 rounded-full border-2 border-[#2B7EAD] flex items-center justify-center text-[#2B7EAD]">
            <Check className="w-6 h-6 stroke-[2.5]" />
          </div>

          <h1 className="text-lg sm:text-xl font-bold tracking-tight text-foreground">
            Đăng nhập bằng {provider} thành công
          </h1>
        </div>

        {/* Khối Ghi chú liên kết tài khoản */}
        <div className="bg-[#EEF8FA] dark:bg-teal-950/30 rounded-2xl p-4 flex items-start gap-3 text-left">
          <Info className="w-4 h-4 text-[#0F5B60] shrink-0 mt-0.5" />
          <p className="text-xs text-[#0F5B60] dark:text-teal-200 leading-relaxed">
            Email <span className="font-semibold">{email}</span> đã có tài khoản Vé Xe Nhanh nên tài khoản {provider} này được liên kết vào tài khoản sẵn có.
          </p>
        </div>

        {/* Hàng trạng thái loading */}
        <div className="flex items-center justify-center gap-2 text-xs text-muted-foreground pt-1">
          <Loader2 className="w-4 h-4 text-[#2B7EAD] animate-spin" />
          <span>Đang đưa bạn về trang trước…</span>
        </div>

        {/* Nút Tiếp tục ngay */}
        <div>
          <Button
            type="button"
            variant="outline"
            onClick={handleContinue}
            className="w-full h-11 rounded-xl border border-border bg-white dark:bg-card hover:bg-muted text-foreground font-medium text-sm transition-all flex items-center justify-center gap-2 shadow-2xs"
          >
            <ArrowRight className="w-4 h-4" />
            <span>Tiếp tục ngay</span>
          </Button>
        </div>
      </div>
    </div>
  );
};
