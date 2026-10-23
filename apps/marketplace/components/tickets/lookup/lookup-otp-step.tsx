"use client";

import React, { useState } from "react";
import { Button } from "@vexenhanh/ui/components/button";
import { Clock, ArrowLeft, AlertCircle } from "lucide-react";
import { verifyTicketLookupOtp } from "../../../lib/data/tickets";
import type { TicketLookupOtpState } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupOtpStep
 */
export interface LookupOtpStepProps {
  readonly initialData: TicketLookupOtpState;
  readonly onBackToForm?: () => void;
  readonly onVerifySuccess?: (token: string) => void;
}

/**
 * Định dạng số giây thành chuỗi MM:SS
 */
function formatSecondsToTimer(seconds: number): string {
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m.toString().padStart(2, "0")}:${s.toString().padStart(2, "0")}`;
}

/**
 * Bước 2 nhập mã OTP xác thực tra cứu vé (SCR-PSG-28 - node 1446:15277)
 */
export const LookupOtpStep: React.FC<LookupOtpStepProps> = ({
  initialData,
  onBackToForm,
  onVerifySuccess
}) => {
  const [digits, setDigits] = useState<string[]>(() => {
    return initialData.otpDigits.length === 6
      ? [...initialData.otpDigits]
      : ["", "", "", "", "", ""];
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Xử lý thay đổi từng số trong 6 ô OTP
  const handleDigitChange = (index: number, value: string): void => {
    setErrorMessage(null);
    const cleaned = value.replace(/\D/g, "");
    const lastChar = cleaned.slice(-1);

    setDigits((prev) => {
      const next = [...prev];
      next[index] = lastChar;
      return next;
    });

    // Tự động focus sang ô kế tiếp nếu có nhập số
    if (lastChar && index < 5) {
      const nextInput = document.getElementById(`otp-input-${index + 1}`);
      nextInput?.focus();
    }
  };

  // Xử lý phím Backspace để lùi ô
  const handleKeyDown = (
    index: number,
    e: React.KeyboardEvent<HTMLInputElement>
  ): void => {
    if (e.key === "Backspace" && !digits[index] && index > 0) {
      const prevInput = document.getElementById(`otp-input-${index - 1}`);
      prevInput?.focus();
    }
  };

  // Xử lý submit xác minh OTP
  const handleSubmit = async (e: React.FormEvent): Promise<void> => {
    e.preventDefault();
    setErrorMessage(null);

    const otpCode = digits.join("");
    if (otpCode.length < 6) {
      setErrorMessage("Vui lòng nhập đủ 6 chữ số mã xác minh.");
      return;
    }

    setIsSubmitting(true);
    try {
      const result = await verifyTicketLookupOtp({
        bookingCodeOrTicketCode: initialData.bookingCode,
        email: initialData.maskedEmail,
        otp: otpCode
      });

      if (result.status === "unavailable" || result.status === "error") {
        setErrorMessage(
          "Chức năng xác minh mã tra cứu vé hiện đang kết nối hệ thống. Vui lòng thử lại sau hoặc gọi tổng đài 1900 6067."
        );
      } else {
        onVerifySuccess?.(result.data.lookupToken);
      }
    } catch {
      setErrorMessage("Đã có lỗi xảy ra khi xác minh mã. Quý khách vui lòng thử lại sau.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="rounded-2xl border border-border/80 bg-card p-6 sm:p-8 shadow-xs space-y-6">
      {/* Nút quay lại bước nhập mã */}
      <button
        type="button"
        onClick={onBackToForm}
        className="inline-flex items-center gap-1.5 text-xs font-semibold text-teal-800 dark:text-teal-300 hover:underline transition-colors"
      >
        <ArrowLeft className="h-3.5 w-3.5" />
        <span>Đổi mã đặt vé hoặc email</span>
      </button>

      <div className="space-y-1.5">
        <h2 className="text-2xl font-bold tracking-tight text-foreground">
          Nhập mã xác minh
        </h2>
        <p className="text-xs text-muted-foreground leading-relaxed">
          Nếu thông tin khớp với một đơn, mã gồm 6 số đã được gửi tới{" "}
          <strong className="font-semibold text-foreground">{initialData.maskedEmail}</strong>.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Thông báo lỗi tại chỗ nếu có */}
        {errorMessage && (
          <div className="p-3.5 rounded-xl bg-destructive/10 border border-destructive/30 flex items-start gap-2.5 text-xs text-destructive animate-in fade-in">
            <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
            <div className="leading-relaxed font-medium">
              {errorMessage}
            </div>
          </div>
        )}

        {/* 6 Ô vuông nhập mã OTP */}
        <div className="flex items-center justify-between gap-2 sm:gap-3 py-1">
          {digits.map((digit, index) => {
            const isLast = index === 5;
            return (
              <input
                key={index}
                id={`otp-input-${index}`}
                type="text"
                inputMode="numeric"
                pattern="[0-9]*"
                maxLength={1}
                value={digit}
                onChange={(e) => handleDigitChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                className={`w-11 h-14 sm:w-14 sm:h-16 text-center text-xl sm:text-2xl font-bold rounded-xl border bg-background text-foreground transition-all focus:outline-none focus:ring-2 focus:ring-teal-700/20 ${
                  isLast || digit
                    ? "border-teal-700 dark:border-teal-400 ring-1 ring-teal-700/30"
                    : "border-border hover:border-border/80"
                }`}
                aria-label={`Chữ số thứ ${index + 1}`}
              />
            );
          })}
        </div>

        {/* Dòng trạng thái đếm ngược thời gian và số lần thử */}
        <div className="flex items-center justify-between text-xs text-muted-foreground pt-0.5">
          <div className="flex items-center gap-1.5">
            <Clock className="h-3.5 w-3.5 text-muted-foreground" />
            <span>Mã hết hạn sau <strong className="font-mono font-bold text-foreground">{formatSecondsToTimer(initialData.expiresInSeconds)}</strong></span>
          </div>

          <div>
            Còn {initialData.remainingAttempts} lần thử
          </div>
        </div>

        {/* Nút xác minh */}
        <Button
          type="submit"
          disabled={isSubmitting}
          className="w-full h-11 text-xs font-bold rounded-xl bg-teal-900 hover:bg-teal-950 text-white shadow-xs"
        >
          {isSubmitting ? "Đang xác minh..." : "Xác minh"}
        </Button>
      </form>

      {/* Dòng gửi lại mã OTP */}
      <div className="pt-1 text-center text-xs text-muted-foreground">
        <span>Chưa nhận được mã? </span>
        <span className="font-semibold text-foreground">
          Gửi lại sau {initialData.resendCountdownSeconds} giây
        </span>
      </div>
    </div>
  );
};
