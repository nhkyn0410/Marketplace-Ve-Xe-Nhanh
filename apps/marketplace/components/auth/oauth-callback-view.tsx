"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, Info, ArrowRight, Loader2 } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { AuthModalShell } from "./auth-modal-shell";

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
    <AuthModalShell showClose={false}>
      {/* Modal OAuth callback — Figma 1447:17897 */}
      <div className="flex w-full flex-col items-center gap-3 rounded-2xl bg-[#ebf5fa] p-6 text-center">
        <div className="flex size-12 items-center justify-center rounded-full border-2 border-vxn-teal-500 text-vxn-teal-500">
          <Check className="size-6 stroke-[2.5]" />
        </div>
        <h1 className="text-lg/6 font-semibold text-vxn-ink">Đăng nhập bằng {provider} thành công</h1>
      </div>

      <div className="flex w-full items-start gap-3 rounded-2xl bg-vxn-teal-50 p-4 text-left">
        <Info className="mt-0.5 size-4 shrink-0 text-vxn-teal-700" />
        <p className="text-[13px]/[19.5px] text-vxn-teal-700">
          Email <span className="font-semibold">{email}</span> đã có tài khoản Vé Xe Nhanh nên tài khoản {provider} này được liên kết vào tài khoản sẵn có.
        </p>
      </div>

      <div className="flex items-center justify-center gap-2 text-[13px] text-vxn-fg-5">
        <Loader2 className="size-4 animate-spin text-vxn-teal-500" />
        <span>Đang đưa bạn về trang trước…</span>
      </div>

      <Button
        type="button"
        variant="outline"
        onClick={handleContinue}
        className="h-11 gap-2 rounded-xl border-border bg-white px-5 text-sm font-medium text-vxn-ink hover:bg-muted"
      >
        <ArrowRight className="size-4" />
        <span>Tiếp tục ngay</span>
      </Button>
    </AuthModalShell>
  );
};
