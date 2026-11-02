"use client";

import { BookingPaymentResultData } from "../../lib/data/types";
import { CheckoutStepper } from "../booking/checkout-stepper";
import { PaymentProcessingCard } from "./payment-processing-card";
import { PaymentSuccessView } from "./payment-success-view";
import { PaymentFailedCard } from "./payment-failed-card";

/**
 * Thuộc tính của component trang kết quả thanh toán.
 */
export interface PaymentResultViewProps {
  readonly result: BookingPaymentResultData;
}

/**
 * Client component hiển thị 1 trong 3 trạng thái kết quả thanh toán (SCR-PSG-21, 22, 23).
 */
export function PaymentResultView({ result }: PaymentResultViewProps) {
  const currentStep = result.status === "success" ? 4 : 3;

  return (
    <div className="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-14 py-6 space-y-8">
      {/* Thanh tiến trình */}
      <CheckoutStepper
        currentStep={currentStep}
        holdCountdownSeconds={
          result.status === "failed" ? result.holdCountdownSeconds : undefined
        }
      />

      {/* Nội dung tương ứng trạng thái */}
      {result.status === "processing" && (
        <PaymentProcessingCard result={result} />
      )}

      {result.status === "success" && (
        <PaymentSuccessView result={result} />
      )}

      {result.status === "failed" && (
        <PaymentFailedCard result={result} />
      )}
    </div>
  );
}
