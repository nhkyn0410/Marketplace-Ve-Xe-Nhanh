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
  initialEmail = "khach.nguyen@gmail.com",
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
      if (res.status === "unavailable") {
        setErrorMessage("Chức năng gửi OTP đăng nhập qua email đang chờ kết nối cổng API backend (POST /auth/otp/send).");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể gửi mã OTP. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi gửi mã OTP. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleOAuthLogin = (provider: "Google" | "Facebook" | "Apple") => {
    if (isPreview) {
      router.push(`/auth/callback?provider=${provider.toLowerCase()}&preview=ideal`);
    } else {
      setErrorMessage(`Đăng nhập qua ${provider} đang chờ hoàn thiện luồng OAuth backend.`);
      console.warn(`[marketplace] chưa có OAuth: ${provider}`);
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

        {/* Phân cách hoặc */}
        <div className="relative flex items-center justify-center">
          <div className="w-full border-t border-border"></div>
          <span className="absolute px-3 bg-white dark:bg-card text-[11px] text-muted-foreground">
            hoặc
          </span>
        </div>

        {/* 3 Nút đăng nhập mạng xã hội */}
        <div className="grid grid-cols-3 gap-2.5">
          {/* Nút Google */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Google")}
            className="flex items-center justify-center gap-1.5 h-10 px-2 rounded-xl border border-border bg-background hover:bg-muted/40 transition-colors text-xs font-semibold text-foreground shadow-2xs"
          >
            <svg className="w-4 h-4 shrink-0" viewBox="0 0 24 24">
              <path
                d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                fill="#4285F4"
              />
              <path
                d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                fill="#34A853"
              />
              <path
                d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.06H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.94l2.85-2.22.81-.63z"
                fill="#FBBC05"
              />
              <path
                d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.06l3.66 2.84c.87-2.6 3.3-4.52 6.16-4.52z"
                fill="#EA4335"
              />
            </svg>
            <span>Google</span>
          </button>

          {/* Nút Facebook */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Facebook")}
            className="flex items-center justify-center gap-1.5 h-10 px-2 rounded-xl border border-border bg-background hover:bg-muted/40 transition-colors text-xs font-semibold text-foreground shadow-2xs"
          >
            <svg className="w-4 h-4 shrink-0 text-[#1877F2]" fill="currentColor" viewBox="0 0 24 24">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
            </svg>
            <span>Facebook</span>
          </button>

          {/* Nút Apple */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Apple")}
            className="flex items-center justify-center gap-1.5 h-10 px-2 rounded-xl border border-border bg-background hover:bg-muted/40 transition-colors text-xs font-semibold text-foreground shadow-2xs"
          >
            <svg className="w-4 h-4 shrink-0" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 6.37c.61-.75 1.04-1.8 1.01-2.87-.96.04-2.1.65-2.73 1.39-.56.64-.99 1.68-.89 2.7.99.08 2.02-.47 2.61-1.22z" />
            </svg>
            <span>Apple</span>
          </button>
        </div>

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
