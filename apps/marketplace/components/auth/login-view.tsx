"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Check, AlertCircle, Search } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { requestLoginOtp } from "../../lib/data/auth";
import { AUTH_INPUT, AUTH_LABEL, AUTH_LINK, AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE } from "./auth-styles";
import { AuthModalShell, type AuthModalVariant } from "./auth-modal-shell";

/**
 * Thuộc tính của LoginView (SCR-PSG-07)
 */
export interface LoginViewProps {
  readonly initialEmail?: string;
  readonly isPreview?: boolean;
  readonly variant?: AuthModalVariant;
}

/**
 * Màn hình Đăng nhập hành khách chuẩn Figma node 1447:16634
 */
export const LoginView: React.FC<LoginViewProps> = ({
  initialEmail = "",
  isPreview = false,
  variant = "page"
}) => {
  const router = useRouter();
  const [email, setEmail] = useState<string>(initialEmail);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const isValidEmail = email.includes("@") && email.includes(".");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!isValidEmail) {
      setErrorMessage("Vui lòng nhập địa chỉ email hợp lệ.");
      return;
    }

    setErrorMessage(null);

    if (isPreview) {
      router.push(`/verify-email?email=${encodeURIComponent(email)}&preview=ideal`);
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await requestLoginOtp({ email });
      if (res.status === "ok") {
        router.push(`/verify-email?email=${encodeURIComponent(email)}`);
      } else if (res.status === "unavailable") {
        setErrorMessage("Chưa thể gửi mã xác minh. Vui lòng thử lại sau.");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể gửi mã OTP. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi gửi mã OTP. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <AuthModalShell variant={variant}>
      {/* Modal Chào mừng trở lại — Figma 1447:16997 */}
      <div className="flex w-full flex-col items-center gap-1.5 text-center">
        <h1 className={AUTH_TITLE}>Chào mừng trở lại</h1>
        <p className={AUTH_SUBTITLE}>Đăng nhập để quản lý hành trình, ví voucher và điểm VXN Plus.</p>
      </div>

      <form onSubmit={handleSubmit} className="flex w-full flex-col gap-4">
        <div className="flex flex-col gap-2 text-left">
          <label htmlFor="login-email" className={AUTH_LABEL}>
            Email
          </label>
          <div className="relative">
            <input
              id="login-email"
              type="email"
              required
              value={email}
              onChange={(e) => {
                setEmail(e.target.value);
                if (errorMessage) setErrorMessage(null);
              }}
              placeholder="tenban@gmail.com"
              className={`${AUTH_INPUT} pr-11 ${isValidEmail ? "border-vxn-teal-500" : "border-[#e4e5e7]"}`}
            />
            {isValidEmail && (
              <div className="pointer-events-none absolute inset-y-0 right-4 flex items-center text-vxn-teal-500">
                <Check className="size-5" />
              </div>
            )}
          </div>
        </div>

        {/* Thông báo lỗi tại chỗ */}
        {errorMessage && (
          <div role="alert" className="flex items-start gap-2 rounded-xl border border-rose-200 bg-rose-50 p-3 text-sm text-rose-700">
            <AlertCircle className="mt-0.5 size-4 shrink-0" />
            <span>{errorMessage}</span>
          </div>
        )}

        <Button type="submit" disabled={isSubmitting} className={AUTH_PRIMARY_BUTTON}>
          {isSubmitting ? "Đang gửi mã..." : "Tiếp tục với email"}
        </Button>

        <p className="text-center text-xs/[18px] text-vxn-fg-5">
          Chúng tôi gửi mã xác minh 6 số tới email của bạn. Không cần mật khẩu.
        </p>
      </form>

      <p className="text-[13px]/[19.5px] text-vxn-fg-5">
        Chưa có tài khoản?{" "}
        <Link href={isPreview ? "/register?preview=ideal" : "/register"} className={AUTH_LINK}>
          Tạo tài khoản
        </Link>
      </p>

      <div className="h-px w-full bg-border" />

      <Link href="/tickets/lookup" className="inline-flex items-center gap-1.5 text-[13px]/[19.5px] text-vxn-fg-5 hover:text-vxn-ink">
        <Search className="size-3.5" />
        <span>Chỉ cần xem vé đã mua?</span>
        <span className="font-semibold text-primary">Tra cứu vé ›</span>
      </Link>
    </AuthModalShell>
  );
};
