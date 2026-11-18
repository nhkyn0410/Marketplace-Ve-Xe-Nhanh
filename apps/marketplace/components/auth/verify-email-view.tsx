"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { ArrowLeft, Clock, AlertCircle } from "lucide-react";
import { Button } from "@vexenhanh/ui/components/button";
import { requestLoginOtp, verifyOtp } from "../../lib/data/auth";
import { AUTH_PRIMARY_BUTTON, AUTH_SUBTITLE, AUTH_TITLE } from "./auth-styles";
import { AuthModalShell, type AuthModalVariant } from "./auth-modal-shell";

/** Mã OTP email có hiệu lực 5 phút (07 Security, cùng hằng số với app). */
export const OTP_LIFETIME_SECONDS = 300;

/** 272 → "04:32". */
export function formatCountdown(seconds: number): string {
  const safe = Math.max(0, Math.floor(seconds));
  return `${String(Math.floor(safe / 60)).padStart(2, "0")}:${String(safe % 60).padStart(2, "0")}`;
}

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
  readonly variant?: AuthModalVariant;
  /** "register": vừa tạo tài khoản → sau OTP chuyển sang bước 2 Hoàn thiện hồ sơ. */
  readonly flow?: "login" | "register";
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
  isPreview = false,
  variant = "page",
  flow = "login"
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
  // Hiệu lực mã đếm ngược 5 phút, gửi mã mới thì đếm lại (SCR-PSG-09: "đếm ngược hiệu lực").
  const [expiresIn, setExpiresIn] = useState<number>(initialData.expiresInSeconds ?? OTP_LIFETIME_SECONDS);
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

  // Đếm ngược hiệu lực mã
  useEffect(() => {
    if (expiresIn <= 0) return;
    const timer = setInterval(() => {
      setExpiresIn((prev) => (prev > 0 ? prev - 1 : 0));
    }, 1000);
    return () => clearInterval(timer);
  }, [expiresIn]);

  const handleDigitChange = (index: number, val: string) => {
    // Chỉ nhận chữ số
    const clean = val.replace(/\D/g, "");
    if (!clean) {
      const next = [...digits];
      next[index] = "";
      setDigits(next);
      return;
    }

    // Nhiều số cùng lúc (bàn phím điện thoại tự điền mã) → rải từ ô 0
    if (clean.length > 2) {
      fillFrom(clean);
      return;
    }

    // Gõ đè lên ô đã có số: lấy số vừa gõ
    const next = [...digits];
    next[index] = clean.slice(-1);
    setDigits(next);

    if (index < 5 && clean) {
      inputRefs.current[index + 1]?.focus();
    }
  };

  const fillFrom = (clean: string) => {
    const next = ["", "", "", "", "", ""];
    for (let i = 0; i < 6; i++) next[i] = clean[i] ?? "";
    setDigits(next);
    inputRefs.current[Math.min(clean.length, 5)]?.focus();
  };

  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>) => {
    const clean = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, 6);
    if (!clean) return;
    e.preventDefault();
    fillFrom(clean);
  };

  const handleKeyDown = (index: number, e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Backspace" && !digits[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    } else if (e.key === "ArrowLeft" && index > 0) {
      e.preventDefault();
      inputRefs.current[index - 1]?.focus();
    } else if (e.key === "ArrowRight" && index < 5) {
      e.preventDefault();
      inputRefs.current[index + 1]?.focus();
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
      router.push(flow === "register" ? "/register/profile?preview=ideal" : "/account?preview=ideal");
      return;
    }

    setIsSubmitting(true);
    try {
      const target = flow === "register" ? "/register/profile" : "/account";
      // Thành công thì Server Action tự redirect tới `target` (router.push sau Server Action ghi cookie trong modal bị hủy).
      const res = await verifyOtp({
        email,
        otp: digits.join("")
      }, target);
      if (!res) return;
      if (res.status === "ok") {
        window.location.assign(target);
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
      setExpiresIn(OTP_LIFETIME_SECONDS);
      return;
    }
    setIsSubmitting(true);
    setErrorMessage(null);
    try {
      const result = await requestLoginOtp({ email });
      if (result.status === "ok") {
        setResendCooldown(60);
        setExpiresIn(OTP_LIFETIME_SECONDS);
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
      variant={variant}
      topLeft={
        <Link
          href={`${flow === "register" ? "/register" : "/login"}${isPreview ? "?preview=ideal" : ""}`}
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
        {/* 6 ô OTP riêng, ô đang nhập được viền + vòng focus */}
        <div className="mx-auto flex w-full max-w-[406px] items-center justify-between gap-2">
          {digits.map((digit, index) => (
            <input
              key={index}
              ref={(el) => {
                inputRefs.current[index] = el;
              }}
              type="text"
              aria-label={`Chữ số xác minh ${index + 1}`}
              autoComplete={index === 0 ? "one-time-code" : "off"}
              autoFocus={index === 0 && !isPreview}
              inputMode="numeric"
              pattern="[0-9]*"
              value={digit}
              onChange={(e) => handleDigitChange(index, e.target.value)}
              onKeyDown={(e) => handleKeyDown(index, e)}
              onPaste={handlePaste}
              onFocus={(e) => e.target.select()}
              className={`h-14 min-w-0 flex-1 rounded-xl border bg-white text-center text-[26px] font-semibold text-vxn-teal-500 transition-all focus:border-vxn-teal-500 focus:outline-none focus:ring-2 focus:ring-vxn-teal-500/20 sm:h-16 sm:max-w-14 ${
                digit ? "border-vxn-teal-500/60" : "border-[#e4e5e7]"
              }`}
            />
          ))}
        </div>

        <p className={`flex items-center gap-1.5 text-xs/[18px] ${expiresIn > 0 ? "text-vxn-fg-5" : "text-destructive"}`} aria-live="polite">
          <Clock className="size-3.5 shrink-0" />
          {expiresIn > 0
            ? `Mã hết hạn sau ${formatCountdown(expiresIn)}. Vui lòng dùng mã mới nhất.`
            : "Mã đã hết hạn. Hãy gửi lại mã mới."}
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
