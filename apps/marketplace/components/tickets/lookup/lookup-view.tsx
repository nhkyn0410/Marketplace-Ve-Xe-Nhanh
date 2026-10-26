"use client";

import React, { useState } from "react";
import { LookupFormStep } from "./lookup-form-step";
import { LookupInstructionsCard } from "./lookup-instructions-card";
import { LookupOtpStep } from "./lookup-otp-step";
import type { TicketLookupInitData, TicketLookupOtpState } from "../../../lib/data/types";
import { PassengerTopBar } from "../../passenger-topbar";

/**
 * Thuộc tính của LookupView
 */
export interface LookupViewProps {
  readonly formData?: TicketLookupInitData;
  /** Mở thẳng bước nhập mã (bản xem trước B2). */
  readonly otpState?: TicketLookupOtpState;
  readonly isPreview?: boolean;
}

/**
 * Giao diện chính Tra cứu vé không đăng nhập: B1 gửi mã (SCR-PSG-27) → B2 nhập mã (SCR-PSG-28) → kết quả.
 */
export const LookupView: React.FC<LookupViewProps> = ({
  formData,
  otpState,
  isPreview = false
}) => {
  const [otp, setOtp] = useState<TicketLookupOtpState | null>(otpState ?? null);
  const [form, setForm] = useState<TicketLookupInitData | undefined>(formData);

  return (
    <>
      <PassengerTopBar
        breadcrumbs={otp
          ? [{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé", href: "/tickets/lookup" }, { label: "Xác minh" }]
          : [{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé" }]}
      />
      <div className="mx-auto w-full max-w-[1200px] space-y-6 px-4 py-6 sm:px-6 sm:py-8 lg:px-14">

      {/* Lưới 2 cột chính: Trái là Form B1/B2, Phải là Hướng dẫn */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        <div className="lg:col-span-6">
          {otp ? (
            <LookupOtpStep
              key={`${otp.bookingCode}|${otp.email}|${otp.sentAt ?? ""}`}
              initialData={otp}
              isPreview={isPreview}
              onBackToForm={() => setOtp(null)}
              onResent={setOtp}
            />
          ) : (
            <LookupFormStep
              initialData={form}
              isPreview={isPreview}
              onSent={(next) => {
                setForm({ bookingCodeOrTicketCode: next.bookingCode, email: next.email });
                setOtp(next);
              }}
            />
          )}
        </div>

        <div className="lg:col-span-6">
          <LookupInstructionsCard />
        </div>
      </div>
    </div>
    </>
  );
};
