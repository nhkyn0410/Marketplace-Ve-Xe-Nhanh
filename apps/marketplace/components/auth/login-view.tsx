"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { X, Check, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { requestLoginOtp } from "../../lib/data/auth";

/**
 * Thuộc tính của LoginView (SCR-PSG-07)
 */
export interface LoginViewProps {
  readonly initialEmail?: string;
  readonly isPreview?: boolean;
}

/**
 * Màn hình Đăng nhập hành khách chuẩn Figma node 1447:16634
 */
export const LoginView: React.FC<LoginViewProps> = ({
  initialEmail = "",
  isPreview = false
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
    <div className="relative min-h-[calc(100vh-4rem)] flex items-center justify-center p-4 sm:p-6 bg-slate-900/40 backdrop-blur-xs">
      {/* Khung modal Chào mừng trở lại chuẩn Figma node 1447:16634 */}
      <div className="relative w-full max-w-[460px] bg-white dark:bg-card rounded-3xl shadow-2xl border border-border p-6 sm:p-8 space-y-6">
        {/* Nút đóng góc phải */}
        <button
          type="button"
          onClick={() => router.push("/")}
          aria-label="Đóng"
          className="absolute top-5 right-5 p-1 text-muted-foreground hover:text-foreground rounded-full hover:bg-muted/60 transition-colors"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Logo và tiêu đề */}
        <div className="text-center space-y-2 pt-2">
          {/* Logo Vé Xe Nhanh SVG */}
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

          <h1 className="text-2xl font-bold tracking-tight text-foreground">
            Chào mừng trở lại
          </h1>
          <p className="text-xs text-muted-foreground leading-relaxed">
            Đăng nhập để quản lý hành trình, ví voucher và điểm VXN Plus.
          </p>
        </div>

        {/* Form nhập Email */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="space-y-1.5 text-left">
            <label className="text-xs font-semibold text-foreground">
              Email
            </label>
            <div className="relative">
              <input
                type="email"
                required
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value);
                  if (errorMessage) setErrorMessage(null);
                }}
                placeholder="tenban@gmail.com"
                className="w-full h-11 px-3.5 pr-10 rounded-xl border border-teal-700/60 bg-background text-sm font-medium focus:outline-none focus:ring-2 focus:ring-teal-700/30"
              />
              {isValidEmail && (
                <div className="absolute inset-y-0 right-3 flex items-center pointer-events-none text-teal-700">
                  <Check className="w-4 h-4" />
                </div>
              )}
            </div>
          </div>

          {/* Thông báo lỗi tại chỗ */}
          {errorMessage && (
            <div className="p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-700 text-xs flex items-start gap-2">
              <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
              <span>{errorMessage}</span>
            </div>
          )}

          {/* Nút Tiếp tục với email */}
          <Button
            type="submit"
            disabled={isSubmitting}
            className="w-full h-11 text-sm font-bold bg-[#0F5B60] hover:bg-[#0c474b] text-white rounded-xl shadow-xs"
          >
            Tiếp tục với email
          </Button>

          <p className="text-[11px] text-muted-foreground text-center">
            Chúng tôi gửi mã xác minh 6 số tới email của bạn. Không cần mật khẩu.
          </p>
        </form>

        {/* Chuyển hướng Tạo tài khoản */}
        <div className="pt-2 text-center text-xs text-muted-foreground border-t border-border/60">
          <span>Chưa có tài khoản? </span>
          <Link
            href="/register"
            className="font-bold text-teal-700 hover:text-teal-800 dark:text-teal-400 hover:underline"
          >
            Tạo tài khoản
          </Link>
        </div>

        {/* Chuyển hướng Tra cứu vé */}
        <div className="text-center text-xs text-muted-foreground">
          <Link
            href="/tickets/lookup"
            className="inline-flex items-center gap-1 hover:text-foreground font-medium transition-colors"
          >
            <span>Chỉ cần xem vé đã mua?</span>
            <span className="font-bold text-teal-700 dark:text-teal-400">Tra cứu vé ›</span>
          </Link>
        </div>
      </div>
    </div>
  );
};
