"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ArrowLeft, X, Clock, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { requestLoginOtp, verifyOtp } from "../../lib/data/auth";
import { LogoWordmark } from "@vexenhanh/ui/components/logo";

/**
 * Dữ liệu cấu hình cho VerifyEmailView (SCR-PSG-09)
 */
export interface VerifyEmailData {
  readonly email?: string;
  readonly otpDigits?: readonly string[];
  readonly expiresInSeconds?: number;
  readonly resendCountdownSeconds?: number;
  readonly remainingAttempts?: number;
}

export interface VerifyEmailViewProps {
  readonly initialData?: VerifyEmailData;
  readonly isPreview?: boolean;
}

/**
 * Màn hình Nhập mã xác minh OTP chuẩn Figma node 1447:17487
 */
export const VerifyEmailView: React.FC<VerifyEmailViewProps> = ({
  initialData = {
    email: "khach.nguyen@gmail.com",
    otpDigits: ["4", "8", "2", "9", "1", "7"],
    expiresInSeconds: 272,
    resendCountdownSeconds: 28,
    remainingAttempts: 5
  },
  isPreview = false
}) => {
  const router = useRouter();
  const email = initialData.email ?? "";
  const [digits, setDigits] = useState<string[]>(() => {
    if (initialData.otpDigits && initialData.otpDigits.length === 6) {
      return [...initialData.otpDigits];
    }
    return ["", "", "", "", "", ""];
  });

  const [resendCooldown, setResendCooldown] = useState<number>(initialData.resendCountdownSeconds ?? 60);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);

  const inputRefs = useRef<Array<HTMLInputElement | null>>([]);

  // Đếm ngược gửi lại mã
  useEffect(() => {
    if (resendCooldown <= 0) return;
    const timer = setInterval(() => {
      setResendCooldown((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, [resendCooldown]);

  const handleDigitChange = (index: number, val: string) => {
    // Chỉ nhận chữ số
    const clean = val.replace(/\D/g, "");
    if (!clean) {
      const next = [...digits];
      next[index] = "";
      setDigits(next);
      return;
    }

    // Nếu dán chuỗi nhiều số
    if (clean.length > 1) {
      const next = [...digits];
      for (let i = 0; i < 6; i++) {
        if (clean[i]) next[i] = clean[i];
      }
      setDigits(next);
      const focusTarget = Math.min(clean.length, 5);
      inputRefs.current[focusTarget]?.focus();
      return;
    }

    const next = [...digits];
    next[index] = clean.slice(-1);
    setDigits(next);

    if (index < 5 && clean) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Backspace" && !digits[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
  };

  const isOtpComplete = digits.every((d) => d.trim().length === 1);

  const handleVerify = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    if (!isOtpComplete) {
      setErrorMessage("Vui lòng nhập đủ 6 chữ số mã xác minh.");
      return;
    }

    setErrorMessage(null);

    if (isPreview) {
      router.push("/account?preview=ideal");
      return;
    }

    setIsSubmitting(true);
    try {
      const res = await verifyOtp({
        email,
        otp: digits.join("")
      });
      if (res.status === "ok") {
        router.push("/account");
        router.refresh();
      } else if (res.status === "unavailable") {
        setErrorMessage("Chưa thể xác minh mã. Vui lòng thử lại sau.");
      } else if (res.status === "error") {
        setErrorMessage(res.message ?? "Mã xác minh không chính xác hoặc đã hết hạn.");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi khi xác minh mã OTP. Vui lòng thử lại.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleResend = async () => {
    if (resendCooldown > 0 || isSubmitting) return;
    if (isPreview) {
      setResendCooldown(60);
      return;
    }
    setIsSubmitting(true);
    setErrorMessage(null);
    try {
      const result = await requestLoginOtp({ email });
      if (result.status === "ok") {
        setResendCooldown(60);
        setDigits(["", "", "", "", "", ""]);
      } else {
        setErrorMessage(result.status === "error" ? result.message ?? "Không thể gửi lại mã OTP." : "Chức năng gửi mã chưa khả dụng.");
      }
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="relative min-h-[calc(var(--vxn-vh)_-_4rem)] lg:min-h-viewport flex items-center justify-center p-4 sm:p-6 bg-slate-900/40 backdrop-blur-xs">
      {/* Khung modal Nhập OTP chuẩn Figma node 1447:17850 */}
      <div className="relative w-full max-w-[480px] bg-white dark:bg-card rounded-3xl shadow-2xl border border-border p-6 sm:p-8 space-y-6">
        {/* Hàng điều hướng trên cùng */}
        <div className="flex items-center justify-between">
          <Link
            href={isPreview ? "/login?preview=ideal" : "/login"}
            className="inline-flex items-center gap-1.5 text-xs font-medium text-[#2B7EAD] hover:underline"
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Đổi email</span>
          </Link>
          <button
            type="button"
            onClick={() => router.push("/")}
            aria-label="Đóng"
            className="p-1 text-muted-foreground hover:text-foreground rounded-full hover:bg-muted/60 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Logo và tiêu đề */}
        <div className="text-center space-y-2">
          {/* Logo Vé Xe Nhanh SVG */}
          <div className="inline-flex items-center gap-2 mb-1">
            <LogoWordmark className="h-[43px] w-auto text-vxn-teal-500" />
          </div>

          <h1 className="text-2xl font-bold tracking-tight text-foreground">
            Nhập mã xác minh
          </h1>
          <p className="text-xs text-muted-foreground leading-relaxed">
            Mã gồm 6 số đã gửi tới <span className="font-medium text-foreground">{email}</span>
          </p>
        </div>

        {/* Khung nhập 6 số OTP (hộp 406x64px bo góc viền nhẹ) */}
        <form onSubmit={handleVerify} className="space-y-4">
          <div className="mx-auto max-w-[406px] h-16 rounded-2xl border border-input bg-background/50 flex items-center justify-around px-2 transition-all focus-within:ring-2 focus-within:ring-[#2B7EAD] focus-within:border-transparent">
            {digits.map((digit, index) => (
              <input
                key={index}
                ref={(el) => {
                  inputRefs.current[index] = el;
                }}
                type="text"
                aria-label={`Chữ số xác minh ${index + 1}`}
                autoComplete={index === 0 ? "one-time-code" : "off"}
                inputMode="numeric"
                maxLength={1}
                value={digit}
                onChange={(e) => handleDigitChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                className="w-12 h-12 text-center text-2xl sm:text-[28px] font-bold text-[#2B7EAD] bg-transparent focus:outline-none"
              />
            ))}
          </div>

          <p className="flex items-center gap-1.5 text-xs text-muted-foreground px-1">
            <Clock className="w-3.5 h-3.5 shrink-0" />
            Mã có hiệu lực trong 5 phút kể từ khi được gửi. Vui lòng dùng mã mới nhất.
          </p>

          {/* Thông báo lỗi khi có */}
          {errorMessage && (
            <div className="flex items-start gap-2 p-3 rounded-xl bg-destructive/10 text-destructive text-xs leading-relaxed">
              <AlertCircle className="w-4 h-4 shrink-0 mt-0.5" />
              <span>{errorMessage}</span>
            </div>
          )}

          {/* Nút chính Xác minh */}
          <Button
            type="submit"
            disabled={isSubmitting || !isOtpComplete}
            className="w-full h-11 rounded-xl bg-[#2B7EAD] hover:bg-[#236a92] text-white font-medium text-sm transition-all shadow-xs"
          >
            {isSubmitting ? "Đang xác minh..." : "Xác minh"}
          </Button>

          {/* Nút gửi lại mã */}
          <div className="text-center pt-1">
            {resendCooldown > 0 ? (
              <span className="text-xs text-[#2B7EAD] font-medium cursor-not-allowed">
                Gửi lại mã (sau {resendCooldown} giây)
              </span>
            ) : (
              <button
                type="button"
                disabled={isSubmitting}
                onClick={handleResend}
                className="text-xs text-[#2B7EAD] font-medium hover:underline"
              >
                Gửi lại mã xác minh
              </button>
            )}
          </div>
        </form>
      </div>
    </div>
  );
};
