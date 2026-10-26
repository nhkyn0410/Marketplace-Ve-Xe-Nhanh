"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@vexenhanh/ui/components/button";
import { Clock, ArrowLeft, AlertCircle } from "lucide-react";
import { requestTicketLookupOtp, verifyTicketLookupOtp } from "../../../lib/data/tickets";
import type { TicketLookupOtpSent, TicketLookupOtpState } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupOtpStep
 */
export interface LookupOtpStepProps {
  readonly initialData: TicketLookupOtpState;
  readonly isPreview?: boolean;
  readonly onBackToForm?: () => void;
  /** Đã gửi lại mã — mã cũ hết hiệu lực, đếm ngược và lượt thử bắt đầu lại. */
  readonly onResent?: (state: TicketLookupOtpState) => void;
}

/** Trạng thái bước nhập mã từ phản hồi gửi mã của API. */
export function otpStateFrom(bookingCode: string, email: string, sent: TicketLookupOtpSent): TicketLookupOtpState {
  return {
    bookingCode,
    email,
    maskedEmail: sent.maskedEmail,
    otpDigits: [],
    expiresInSeconds: sent.expiresInSeconds,
    remainingAttempts: sent.maxAttempts,
    resendCountdownSeconds: sent.resendAfterSeconds,
    sentAt: Date.now()
  };
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
  isPreview = false,
  onBackToForm,
  onResent
}) => {
  const router = useRouter();
  const [digits, setDigits] = useState<string[]>(() => {
    return initialData.otpDigits.length === 6
      ? [...initialData.otpDigits]
      : ["", "", "", "", "", ""];
  });
  const [expiresIn, setExpiresIn] = useState(initialData.expiresInSeconds);
  const [resendIn, setResendIn] = useState(initialData.resendCountdownSeconds);
  const [remainingAttempts, setRemainingAttempts] = useState(initialData.remainingAttempts);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isResending, setIsResending] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Đếm ngược hạn mã và thời gian chờ gửi lại (bản xem trước giữ nguyên số như Figma).
  useEffect(() => {
    if (isPreview) return;
    const timer = window.setInterval(() => {
      setExpiresIn((value) => Math.max(0, value - 1));
      setResendIn((value) => Math.max(0, value - 1));
    }, 1000);
    return () => window.clearInterval(timer);
  }, [isPreview]);

  const isExpired = expiresIn === 0 || remainingAttempts === 0;
  const otpCode = digits.join("");

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

  // Dán cả mã 6 số từ email vào bất kỳ ô nào
  const handlePaste = (e: React.ClipboardEvent<HTMLInputElement>): void => {
    const pasted = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, 6);
    if (pasted.length !== 6) return;
    e.preventDefault();
    setErrorMessage(null);
    setDigits(pasted.split(""));
    document.getElementById("otp-input-5")?.focus();
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

    if (otpCode.length < 6) {
      setErrorMessage("Vui lòng nhập đủ 6 chữ số mã xác minh.");
      return;
    }
    if (isPreview) {
      setErrorMessage("Đây là giao diện xem trước; xác minh mã đã được tắt.");
      return;
    }

    setIsSubmitting(true);
    try {
      const result = await verifyTicketLookupOtp({
        bookingCodeOrTicketCode: initialData.bookingCode,
        email: initialData.email,
        otp: otpCode
      });

      if (result.status === "ok") {
        router.push("/tickets/lookup/result");
        return;
      }
      if (result.status === "error" && result.httpStatus === 422) {
        // API trả số lần thử còn lại trong câu thông báo; hết lượt / hết hạn thì phải gửi lại mã.
        const left = Number(/Còn (\d+) lần thử/.exec(result.message ?? "")?.[1] ?? 0);
        setRemainingAttempts(left);
        setDigits(["", "", "", "", "", ""]);
        document.getElementById("otp-input-0")?.focus();
      }
      setErrorMessage(
        result.status === "error" ? result.message ?? "Chưa xác minh được mã. Vui lòng thử lại." : "Chức năng tra cứu tạm thời chưa khả dụng."
      );
    } catch {
      setErrorMessage("Đã có lỗi xảy ra khi xác minh mã. Quý khách vui lòng thử lại sau.");
    } finally {
      setIsSubmitting(false);
    }
  };

  // Gửi lại mã: mã cũ hết hiệu lực
  const handleResend = async (): Promise<void> => {
    setErrorMessage(null);
    if (isPreview) {
      setErrorMessage("Đây là giao diện xem trước; gửi lại mã đã được tắt.");
      return;
    }
    setIsResending(true);
    try {
      const result = await requestTicketLookupOtp({ bookingCodeOrTicketCode: initialData.bookingCode, email: initialData.email });
      if (result.status === "ok") {
        onResent?.(otpStateFrom(initialData.bookingCode, initialData.email, result.data));
      } else {
        setErrorMessage(result.status === "error" ? result.message ?? "Chưa gửi lại được mã. Vui lòng thử lại." : "Chức năng tra cứu tạm thời chưa khả dụng.");
      }
    } catch {
      setErrorMessage("Đã có lỗi xảy ra. Quý khách vui lòng thử lại sau.");
    } finally {
      setIsResending(false);
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
        <h1 className="text-2xl font-bold tracking-tight text-foreground">
          Nhập mã xác minh
        </h1>
        <p className="text-xs text-muted-foreground leading-relaxed">
          Nếu thông tin khớp với một đơn, mã gồm 6 số đã được gửi tới{" "}
          <strong className="font-semibold text-foreground">{initialData.maskedEmail}</strong>.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        {/* Thông báo lỗi tại chỗ nếu có */}
        {errorMessage && (
          <div role="alert" className="p-3.5 rounded-xl bg-destructive/10 border border-destructive/30 flex items-start gap-2.5 text-xs text-destructive animate-in fade-in">
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
                autoComplete={index === 0 ? "one-time-code" : "off"}
                maxLength={1}
                value={digit}
                disabled={isExpired}
                onChange={(e) => handleDigitChange(index, e.target.value)}
                onKeyDown={(e) => handleKeyDown(index, e)}
                onPaste={handlePaste}
                className={`h-14 min-w-0 flex-1 sm:h-16 sm:w-14 sm:flex-none text-center text-xl sm:text-2xl font-bold rounded-xl border bg-background text-foreground transition-all focus:outline-none focus:ring-2 focus:ring-teal-700/20 disabled:opacity-50 ${
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
            {isExpired ? (
              <span className="font-semibold text-destructive">Mã đã hết hiệu lực — gửi lại mã mới</span>
            ) : (
              <span>Mã hết hạn sau <strong className="font-mono font-bold text-foreground">{formatSecondsToTimer(expiresIn)}</strong></span>
            )}
          </div>

          <div>
            Còn {remainingAttempts} lần thử
          </div>
        </div>

        {/* Nút xác minh */}
        <Button
          type="submit"
          disabled={isSubmitting || isExpired || otpCode.length < 6}
          className="w-full h-11 text-xs font-bold rounded-xl bg-teal-900 hover:bg-teal-950 text-white shadow-xs"
        >
          {isSubmitting ? "Đang xác minh..." : "Xác minh"}
        </Button>
      </form>

      {/* Dòng gửi lại mã OTP */}
      <div className="pt-1 text-center text-xs text-muted-foreground">
        <span>Chưa nhận được mã? </span>
        {resendIn > 0 ? (
          <span className="font-semibold text-foreground">
            Gửi lại sau {resendIn} giây
          </span>
        ) : (
          <button
            type="button"
            onClick={() => void handleResend()}
            disabled={isResending}
            className="font-semibold text-teal-700 dark:text-teal-400 hover:underline disabled:opacity-50"
          >
            {isResending ? "Đang gửi lại..." : "Gửi lại mã"}
          </button>
        )}
      </div>
    </div>
  );
};
