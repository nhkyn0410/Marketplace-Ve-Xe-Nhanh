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
    email: ""
  },
  isPreview = false
}) => {
  const router = useRouter();
  const [email, setEmail] = useState<string>(initialData.email ?? "");
  const [agreeTerms, setAgreeTerms] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const isValidEmail = email.includes("@") && email.includes(".");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
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
      const res = await registerAccount({ email });
      if (res.status === "ok") {
        router.push(`/verify-email?email=${encodeURIComponent(res.data.email)}`);
      } else if (res.status === "unavailable") {
        setErrorMessage("Chưa thể tạo tài khoản. Vui lòng thử lại sau.");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Không thể hoàn tất đăng ký. Vui lòng thử lại sau.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi tạo tài khoản. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="relative min-h-[calc(var(--vxn-vh)_-_4rem)] flex items-center justify-center p-4 sm:p-6 bg-slate-900/40 backdrop-blur-xs">
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

          <p className="text-xs text-muted-foreground leading-relaxed">
            Sau khi xác minh email, bạn có thể bổ sung họ tên, số điện thoại và ngày sinh tại Hồ sơ cá nhân.
          </p>

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
              <Link href="/legal/terms" className="text-[#0F5B60] font-medium hover:underline">
                Điều khoản sử dụng
              </Link>{" "}
              và{" "}
              <Link href="/legal/privacy" className="text-[#0F5B60] font-medium hover:underline">
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
            disabled={isSubmitting || !isValidEmail || !agreeTerms}
            className="w-full h-11 rounded-xl bg-[#2B7EAD] hover:bg-[#236a92] text-white font-medium text-sm transition-all shadow-xs"
          >
            {isSubmitting ? "Đang xử lý..." : "Tạo tài khoản và gửi mã"}
          </Button>
        </form>

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
