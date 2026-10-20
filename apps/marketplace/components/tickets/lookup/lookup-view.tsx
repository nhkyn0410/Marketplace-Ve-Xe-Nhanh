"use client";

import React, { useState } from "react";
import Link from "next/link";
import { ChevronRight } from "lucide-react";
import { LookupFormStep } from "./lookup-form-step";
import { LookupOtpStep } from "./lookup-otp-step";
import { LookupInstructionsCard } from "./lookup-instructions-card";
import type {
  TicketLookupInitData,
  TicketLookupOtpState
} from "../../../lib/data/types";

/**
 * Thuộc tính của LookupView
 */
export interface LookupViewProps {
  readonly initialStep?: "form" | "otp";
  readonly formData?: TicketLookupInitData;
  readonly otpData: TicketLookupOtpState;
}

/**
 * Giao diện chính Tra cứu vé không đăng nhập (SCR-PSG-27 & SCR-PSG-28)
 */
export const LookupView: React.FC<LookupViewProps> = ({
  initialStep = "form",
  formData,
  otpData
}) => {
  const [currentStep, setCurrentStep] = useState<"form" | "otp">(initialStep);
  const [lookupFormData, setLookupFormData] = useState<TicketLookupInitData | undefined>(formData);

  const handleNextToOtp = (submitted: TicketLookupInitData): void => {
    setLookupFormData(submitted);
    setCurrentStep("otp");
  };

  const handleBackToForm = (): void => {
    setCurrentStep("form");
  };

  return (
    <div className="container mx-auto px-4 sm:px-6 py-6 sm:py-8 max-w-5xl space-y-6">
      {/* Breadcrumb điều hướng */}
      <nav aria-label="Breadcrumb" className="flex items-center gap-1.5 text-xs text-muted-foreground">
        <Link href="/" className="hover:text-foreground transition-colors">
          Trang chủ
        </Link>
        <ChevronRight className="h-3 w-3 text-muted-foreground/60" />
        <Link
          href="/tickets/lookup"
          onClick={(e) => {
            if (currentStep === "otp") {
              e.preventDefault();
              setCurrentStep("form");
            }
          }}
          className={currentStep === "otp" ? "hover:text-foreground transition-colors" : "font-medium text-foreground"}
        >
          Tra cứu vé
        </Link>
        {currentStep === "otp" && (
          <>
            <ChevronRight className="h-3 w-3 text-muted-foreground/60" />
            <span className="font-medium text-foreground">Xác minh</span>
          </>
        )}
      </nav>

      {/* Lưới 2 cột chính: Trái là Form B1/B2, Phải là Hướng dẫn */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Cột trái: 7 cột */}
        <div className="lg:col-span-7">
          {currentStep === "form" ? (
            <LookupFormStep
              initialData={lookupFormData}
              onNextStep={handleNextToOtp}
            />
          ) : (
            <LookupOtpStep
              initialData={otpData}
              onBackToForm={handleBackToForm}
            />
          )}
        </div>

        {/* Cột phải: 5 cột */}
        <div className="lg:col-span-5">
          <LookupInstructionsCard />
        </div>
      </div>
    </div>
  );
};
