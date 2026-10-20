"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Button } from "@vexenhanh/ui/components/button";
import { Info, AlertCircle } from "lucide-react";
import { requestTicketLookupOtp } from "../../../lib/data/tickets";
import type { TicketLookupInitData } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupFormStep
 */
export interface LookupFormStepProps {
  readonly initialData?: TicketLookupInitData;
  readonly onNextStep?: (data: TicketLookupInitData) => void;
}

/**
 * Bước 1 form tra cứu vé (SCR-PSG-27 - node 1446:14982)
 */
export const LookupFormStep: React.FC<LookupFormStepProps> = ({
  initialData,
  onNextStep
}) => {
  const [bookingCode, setBookingCode] = useState(
    initialData?.bookingCodeOrTicketCode ?? ""
  );
  const [email, setEmail] = useState(initialData?.email ?? "");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleSubmit = async (e: React.FormEvent): Promise<void> => {
    e.preventDefault();
    setErrorMessage(null);

    const trimmedCode = bookingCode.trim().toUpperCase();
    const trimmedEmail = email.trim().toLowerCase();

    if (!trimmedCode || !trimmedEmail) {
      setErrorMessage("Vui lòng nhập đầy đủ mã đặt vé và email liên hệ.");
      return;
    }

    setIsSubmitting(true);
    try {
      const result = await requestTicketLookupOtp({
        bookingCodeOrTicketCode: trimmedCode,
        email: trimmedEmail
      });

      if (result.status === "unavailable" || result.status === "error") {
        setErrorMessage(
          "Chức năng gửi mã xác minh tra cứu vé hiện đang được kết nối hệ thống. Vui lòng thử lại sau hoặc liên hệ tổng đài 1900 6067."
        );
      } else {
        onNextStep?.({
          bookingCodeOrTicketCode: trimmedCode,
          email: trimmedEmail
        });
      }
    } catch {
      setErrorMessage("Đã có lỗi xảy ra. Quý khách vui lòng thử lại sau.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="rounded-2xl border border-border/80 bg-card p-6 sm:p-8 shadow-xs space-y-6">
      <div className="space-y-1.5">
        <h2 className="text-2xl font-bold tracking-tight text-foreground">
          Tra cứu vé
        </h2>
        <p className="text-xs text-muted-foreground leading-relaxed">
          Dành cho khách đặt vé không đăng nhập. Nhập mã đặt vé (hoặc mã vé) và email đã dùng khi đặt.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Thông báo lỗi tại chỗ nếu có */}
        {errorMessage && (
          <div className="p-3.5 rounded-xl bg-destructive/10 border border-destructive/30 flex items-start gap-2.5 text-xs text-destructive animate-in fade-in">
            <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
            <div className="leading-relaxed font-medium">
              {errorMessage}
            </div>
          </div>
        )}

        {/* Ô nhập mã đặt vé */}
        <div className="space-y-1.5">
          <label
            htmlFor="lookup-booking-code"
            className="text-xs font-semibold text-foreground"
          >
            Mã đặt vé hoặc mã vé *
          </label>
          <input
            id="lookup-booking-code"
            type="text"
            required
            value={bookingCode}
            onChange={(e) => setBookingCode(e.target.value.toUpperCase())}
            placeholder="Ví dụ: VXN-4H9P6C"
            className="w-full h-11 px-3.5 rounded-xl border border-border bg-background text-sm font-medium uppercase text-foreground placeholder:normal-case placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-teal-700/20 focus:border-teal-700"
          />
        </div>

        {/* Ô nhập email liên hệ */}
        <div className="space-y-1.5">
          <label
            htmlFor="lookup-email"
            className="text-xs font-semibold text-foreground"
          >
            Email liên hệ của đơn *
          </label>
          <input
            id="lookup-email"
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="hoa.le@gmail.com"
            className="w-full h-11 px-3.5 rounded-xl border border-border bg-background text-sm font-medium text-foreground placeholder:text-muted-foreground/60 focus:outline-none focus:ring-2 focus:ring-teal-700/20 focus:border-teal-700"
          />
        </div>

        {/* Hộp ghi chú bảo mật mã OTP */}
        <div className="p-3.5 rounded-xl bg-teal-50/70 dark:bg-teal-950/20 border border-teal-200/60 dark:border-teal-900/40 flex items-start gap-2.5 text-xs text-teal-950 dark:text-teal-200">
          <Info className="h-4 w-4 text-teal-700 dark:text-teal-400 shrink-0 mt-0.5" />
          <div className="leading-relaxed">
            Mã xác minh (OTP) được gửi tới email liên hệ của đơn. Để bảo vệ thông tin, hệ thống không cho biết mã hoặc email có khớp hay không trước khi xác minh.
          </div>
        </div>

        {/* Nút gửi mã xác minh */}
        <Button
          type="submit"
          disabled={isSubmitting}
          className="w-full h-11 text-xs font-bold rounded-xl bg-teal-900 hover:bg-teal-950 text-white shadow-xs"
        >
          {isSubmitting ? "Đang gửi mã..." : "Gửi mã xác minh"}
        </Button>
      </form>

      {/* Dòng liên kết đăng nhập */}
      <div className="pt-2 text-center text-xs text-muted-foreground">
        <span>Đã có tài khoản? </span>
        <Link
          href="/login"
          className="font-semibold text-teal-700 dark:text-teal-400 hover:underline inline-flex items-center gap-0.5"
        >
          <span>Đăng nhập để xem toàn bộ vé</span>
          <span>›</span>
        </Link>
      </div>
    </div>
  );
};
