"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ArrowLeft, Clock, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { requestLoginOtp, verifyOtp } from "../../lib/data/auth";
import { AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE, AuthModalShell } from "./auth-modal-shell";

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
    <AuthModalShell
      topLeft={
        <Link
          href={isPreview ? "/login?preview=ideal" : "/login"}
          className="inline-flex items-center gap-1.5 text-[13px] font-medium text-vxn-teal-500 hover:underline"
        >
          <ArrowLeft className="size-4" />
          <span>Đổi email</span>
        </Link>
      }
    >
      {/* Modal Nhập mã xác minh — Figma 1447:17487 */}
      <div className="flex w-full flex-col items-center gap-1.5 text-center">
        <h1 className={AUTH_TITLE}>Nhập mã xác minh</h1>
        <p className={AUTH_SUBTITLE}>
          Mã gồm 6 số đã gửi tới <span className="font-medium text-vxn-ink">{email}</span>
        </p>
      </div>

      <form onSubmit={handleVerify} className="flex w-full flex-col gap-4">
        {/* Ô nhập 6 số OTP (hộp 406×64 bo góc) */}
        <div className="mx-auto flex h-16 w-full max-w-[406px] items-center justify-around rounded-2xl border border-[#e4e5e7] bg-white px-2 transition-all focus-within:border-vxn-teal-500 focus-within:ring-2 focus-within:ring-vxn-teal-500/20">
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
              className="h-12 w-12 bg-transparent text-center text-[28px] font-semibold text-vxn-teal-500 focus:outline-none"
            />
          ))}
        </div>

        <p className="flex items-center gap-1.5 text-xs/[18px] text-vxn-fg-5">
          <Clock className="size-3.5 shrink-0" />
          Mã có hiệu lực trong 5 phút kể từ khi được gửi. Vui lòng dùng mã mới nhất.
        </p>

        {errorMessage && (
          <div role="alert" className="flex items-start gap-2 rounded-xl bg-destructive/10 p-3 text-sm text-destructive">
            <AlertCircle className="mt-0.5 size-4 shrink-0" />
            <span>{errorMessage}</span>
          </div>
        )}

        <Button type="submit" disabled={isSubmitting || !isOtpComplete} className={AUTH_PRIMARY_BUTTON}>
          {isSubmitting ? "Đang xác minh..." : "Xác minh"}
        </Button>

        <div className="text-center">
          {resendCooldown > 0 ? (
            <span className="cursor-not-allowed text-[13px] font-medium text-vxn-teal-500">
              Gửi lại mã (sau {resendCooldown} giây)
            </span>
          ) : (
            <button
              type="button"
              disabled={isSubmitting}
              onClick={handleResend}
              className="text-[13px] font-medium text-vxn-teal-500 hover:underline"
            >
              Gửi lại mã xác minh
            </button>
          )}
        </div>
      </form>
    </AuthModalShell>
  );
};
