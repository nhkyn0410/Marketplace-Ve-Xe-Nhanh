"use client";

import React, { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { X, Check, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { registerAccount } from "../../lib/data/auth";

/**
 * Thuộc tính của RegisterView (SCR-PSG-08)
 */
export interface RegisterViewProps {
  readonly initialData?: {
    readonly fullName?: string;
    readonly email?: string;
    readonly phone?: string;
  };
  readonly isPreview?: boolean;
}

/**
 * Màn hình Tạo tài khoản hành khách chuẩn Figma node 1447:17057
 */
export const RegisterView: React.FC<RegisterViewProps> = ({
  initialData = {
    fullName: "Nguyễn Văn Khách",
    email: "khach.nguyen@gmail.com",
    phone: "0901 234 567"
  },
  isPreview = false
}) => {
  const router = useRouter();
  const [fullName, setFullName] = useState<string>(initialData.fullName ?? "Nguyễn Văn Khách");
  const [email, setEmail] = useState<string>(initialData.email ?? "khach.nguyen@gmail.com");
  const [phone, setPhone] = useState<string>(initialData.phone ?? "0901 234 567");
  const [agreeTerms, setAgreeTerms] = useState<boolean>(true);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const isValidName = fullName.trim().length >= 2;
  const isValidEmail = email.includes("@") && email.includes(".");
  const isValidPhone = phone.trim().length >= 9;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!isValidName) {
      setErrorMessage("Vui lòng nhập họ và tên của bạn.");
      return;
    }
    if (!isValidEmail) {
      setErrorMessage("Vui lòng nhập địa chỉ email hợp lệ.");
      return;
    }
    if (!agreeTerms) {
      setErrorMessage("Vui lòng đồng ý với Điều khoản sử dụng và Chính sách bảo mật.");
      return;
    }

    setErrorMessage(null);

    if (isPreview) {
      router.push(`/verify-email?email=${encodeURIComponent(email)}&preview=ideal`);
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await registerAccount({
        fullName,
        email,
        phone
      });
      if (res.status === "unavailable") {
        setErrorMessage("Chức năng đăng ký tài khoản đang chờ kết nối cổng API backend (POST /auth/register).");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể hoàn tất đăng ký. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi tạo tài khoản. Vui lòng thử lại.");
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
      {/* Khung modal Tạo tài khoản chuẩn Figma node 1447:17420 */}
      <div className="relative w-full max-w-[480px] bg-white dark:bg-card rounded-3xl shadow-2xl border border-border p-6 sm:p-8 space-y-6">
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
            Tạo tài khoản
          </h1>
          <p className="text-xs text-muted-foreground leading-relaxed">
            Xác minh bằng mã OTP gửi qua email. Không cần mật khẩu.
          </p>
        </div>

        {/* Form nhập thông tin */}
        <form onSubmit={handleSubmit} className="space-y-4">
          {/* Họ và tên */}
          <div className="space-y-1.5 text-left">
            <label className="text-xs font-semibold text-foreground">
              Họ và tên
            </label>
            <div className="relative">
              <input
                type="text"
                required
                value={fullName}
                onChange={(e) => setFullName(e.target.value)}
                placeholder="Nguyễn Văn A"
                className={`w-full h-11 pl-3.5 pr-10 rounded-xl border bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-[#2B7EAD] transition-all ${
                  isValidName ? "border-[#2B7EAD]" : "border-input"
                }`}
              />
              {isValidName && (
                <div className="absolute right-3.5 top-1/2 -translate-y-1/2 pointer-events-none text-[#2B7EAD]">
                  <Check className="w-4 h-4 stroke-[2.5]" />
                </div>
              )}
            </div>
          </div>

          {/* Email */}
          <div className="space-y-1.5 text-left">
            <label className="text-xs font-semibold text-foreground">
              Email
            </label>
            <div className="relative">
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="email@example.com"
                className={`w-full h-11 pl-3.5 pr-10 rounded-xl border bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-[#2B7EAD] transition-all ${
                  isValidEmail ? "border-[#2B7EAD]" : "border-input"
                }`}
              />
              {isValidEmail && (
                <div className="absolute right-3.5 top-1/2 -translate-y-1/2 pointer-events-none text-[#2B7EAD]">
                  <Check className="w-4 h-4 stroke-[2.5]" />
                </div>
              )}
            </div>
          </div>

          {/* Số điện thoại */}
          <div className="space-y-1.5 text-left">
            <label className="text-xs font-semibold text-foreground">
              Số điện thoại (không bắt buộc)
            </label>
            <div className="relative">
              <input
                type="tel"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="0901 234 567"
                className={`w-full h-11 pl-3.5 pr-10 rounded-xl border bg-background text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-[#2B7EAD] transition-all ${
                  isValidPhone ? "border-[#2B7EAD]" : "border-input"
                }`}
              />
              {isValidPhone && (
                <div className="absolute right-3.5 top-1/2 -translate-y-1/2 pointer-events-none text-[#2B7EAD]">
                  <Check className="w-4 h-4 stroke-[2.5]" />
                </div>
              )}
            </div>
          </div>

          {/* Checkbox điều khoản */}
          <div className="flex items-start gap-2.5 pt-1 text-left">
            <button
              type="button"
              role="checkbox"
              aria-checked={agreeTerms}
              onClick={() => setAgreeTerms(!agreeTerms)}
              className={`mt-0.5 w-4 h-4 rounded-sm flex items-center justify-center transition-colors border ${
                agreeTerms
                  ? "bg-[#0F5B60] border-[#0F5B60] text-white"
                  : "bg-background border-input text-transparent"
              }`}
            >
              <Check className="w-3 h-3 stroke-[3]" />
            </button>
            <p className="text-xs text-muted-foreground leading-snug">
              Tôi đồng ý{" "}
              <Link href="/terms" className="text-[#0F5B60] font-medium hover:underline">
                Điều khoản sử dụng
              </Link>{" "}
              và{" "}
              <Link href="/privacy" className="text-[#0F5B60] font-medium hover:underline">
                Chính sách bảo mật
              </Link>{" "}
              của Vé Xe Nhanh.
            </p>
          </div>

          {/* Thông báo lỗi khi có */}
          {errorMessage && (
            <div className="flex items-start gap-2 p-3 rounded-xl bg-destructive/10 text-destructive text-xs leading-relaxed">
              <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
              <span>{errorMessage}</span>
            </div>
          )}

          {/* Nút gửi */}
          <Button
            type="submit"
            disabled={isSubmitting || !isValidEmail || !isValidName || !agreeTerms}
            className="w-full h-11 rounded-xl bg-[#2B7EAD] hover:bg-[#236a92] text-white font-medium text-sm transition-all shadow-xs"
          >
            {isSubmitting ? "Đang xử lý..." : "Tạo tài khoản và gửi mã"}
          </Button>
        </form>

        {/* Đường phân cách */}
        <div className="relative my-4">
          <div className="absolute inset-0 flex items-center">
            <div className="w-full border-t border-border" />
          </div>
          <div className="relative flex justify-center text-xs">
            <span className="bg-white dark:bg-card px-3 text-muted-foreground">
              hoặc
            </span>
          </div>
        </div>

        {/* Đăng nhập mạng xã hội (OAuth) */}
        <div className="grid grid-cols-3 gap-2.5">
          {/* Google */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Google")}
            className="h-10 flex items-center justify-center gap-2 rounded-xl border border-input bg-background hover:bg-muted/50 text-foreground text-xs font-medium transition-colors"
          >
            <svg className="w-4 h-4" viewBox="0 0 24 24">
              <path
                fill="#4285F4"
                d="M23.745 12.27c0-.7-.06-1.4-.19-2.07H12v4.51h6.6c-.29 1.52-1.14 2.82-2.4 3.68v3.05h3.88c2.27-2.09 3.66-5.17 3.66-9.17z"
              />
              <path
                fill="#34A853"
                d="M12 24c3.24 0 5.95-1.08 7.93-2.91l-3.88-3.05c-1.08.72-2.45 1.16-4.05 1.16-3.12 0-5.77-2.1-6.72-4.93H1.25v3.15C3.26 21.36 7.34 24 12 24z"
              />
              <path
                fill="#FBBC05"
                d="M5.28 14.27c-.25-.72-.38-1.49-.38-2.27s.13-1.55.38-2.27V6.58H1.25C.45 8.16 0 9.94 0 12s.45 3.84 1.25 5.42l4.03-3.15z"
              />
              <path
                fill="#EA4335"
                d="M12 4.75c1.77 0 3.35.61 4.6 1.8l3.42-3.42C17.95 1.19 15.24 0 12 0 7.34 0 3.26 2.64 1.25 6.58l4.03 3.15c.95-2.83 3.6-4.98 6.72-4.98z"
              />
            </svg>
            <span>Google</span>
          </button>

          {/* Facebook */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Facebook")}
            className="h-10 flex items-center justify-center gap-2 rounded-xl border border-input bg-background hover:bg-muted/50 text-foreground text-xs font-medium transition-colors"
          >
            <svg className="w-4 h-4 fill-[#1877F2]" viewBox="0 0 24 24">
              <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z" />
            </svg>
            <span>Facebook</span>
          </button>

          {/* Apple */}
          <button
            type="button"
            onClick={() => handleOAuthLogin("Apple")}
            className="h-10 flex items-center justify-center gap-2 rounded-xl border border-input bg-background hover:bg-muted/50 text-foreground text-xs font-medium transition-colors"
          >
            <svg className="w-4 h-4 fill-foreground" viewBox="0 0 24 24">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 7.04c.64-.78 1.08-1.87.96-2.96-.94.04-2.07.63-2.73 1.41-.58.67-1.09 1.76-.95 2.83 1.05.08 2.12-.55 2.72-1.28z" />
            </svg>
            <span>Apple</span>
          </button>
        </div>

        {/* Link chuyển sang đăng nhập */}
        <div className="text-center text-xs text-muted-foreground pt-1">
          Đã có tài khoản?{" "}
          <Link
            href={isPreview ? "/login?preview=ideal" : "/login"}
            className="text-[#0F5B60] font-semibold hover:underline"
          >
            Đăng nhập
          </Link>
        </div>
      </div>
    </div>
  );
};
