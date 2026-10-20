"use client";

import { useState } from "react";
import { BookingPaymentData, SupportedPaymentMethod, VNPayBankOption } from "../../lib/data/types";
import { CheckoutStepper } from "../booking/checkout-stepper";
import { PaymentMethodSelector } from "./payment-method-selector";
import { PaymentOrderSummaryCard } from "./payment-order-summary-card";
import { PaymentTermsCheckbox } from "./payment-terms-checkbox";
import { PaymentSummarySidebar } from "./payment-summary-sidebar";
import { PaymentExpiredModal } from "./payment-expired-modal";
import { AlertCircle } from "lucide-react";

/**
 * Thuộc tính của component trang thanh toán B3.
 */
export interface PaymentPageViewProps {
  readonly paymentData: BookingPaymentData;
  readonly isExpired?: boolean;
}

/**
 * Client component quản lý luồng tương tác màn hình thanh toán B3 (Figma 1444:13055 & 1450:23099).
 */
export function PaymentPageView({ paymentData, isExpired = false }: PaymentPageViewProps) {
  const [selectedMethod, setSelectedMethod] = useState<SupportedPaymentMethod>(
    paymentData.selectedPaymentMethod ?? "vnpay"
  );
  const [selectedBank, setSelectedBank] = useState<VNPayBankOption>(
    paymentData.selectedBankOption ?? "vnpay_qr"
  );
  const [isTermsAccepted, setIsTermsAccepted] = useState(true);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  /**
   * Xử lý khi nhấn nút thanh toán.
   */
  const handlePaymentSubmit = () => {
    setErrorMessage(null);

    if (!isTermsAccepted) {
      setErrorMessage("Vui lòng đồng ý với Điều khoản sử dụng và chính sách hủy / hoàn tiền để tiếp tục.");
      return;
    }

    // Báo warn do chưa có API theo quy tắc A5
    console.warn(
      `[marketplace] chưa có API: POST /bookings/${paymentData.bookingId}/payments (phương thức: ${selectedMethod})`
    );

    setErrorMessage(
      "Cổng thanh toán chưa sẵn sàng trong môi trường thử nghiệm (chưa có API backend: POST /bookings/{bookingId}/payments)."
    );
  };

  return (
    <div className="mx-auto w-full max-w-7xl px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Thanh tiến trình */}
      <CheckoutStepper
        currentStep={3}
        holdCountdownSeconds={paymentData.holdCountdownSeconds}
      />

      {/* Thông báo lỗi tại chỗ nếu có */}
      {errorMessage && (
        <div
          role="alert"
          className="flex items-center gap-3 rounded-2xl border border-rose-200 bg-rose-50/90 p-4 text-xs sm:text-sm text-rose-800 animate-in fade-in-50 duration-200"
        >
          <AlertCircle className="h-5 w-5 shrink-0 text-rose-600" />
          <p className="font-medium">{errorMessage}</p>
        </div>
      )}

      {/* Lưới bố cục 2 cột */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        {/* Cột trái (7 cột trên lg) */}
        <div className="lg:col-span-7 space-y-6">
          {/* Lựa chọn phương thức thanh toán */}
          <PaymentMethodSelector
            selectedMethod={selectedMethod}
            onSelectMethod={setSelectedMethod}
            selectedBank={selectedBank}
            onSelectBank={setSelectedBank}
          />

          {/* Tóm tắt thông tin đơn hàng & hành khách */}
          <PaymentOrderSummaryCard
            bookingId={paymentData.bookingId}
            contactInfo={paymentData.contactInfo}
            passengers={paymentData.passengers}
          />

          {/* Điều khoản sử dụng */}
          <PaymentTermsCheckbox
            isAgreed={isTermsAccepted}
            onToggleAgreed={setIsTermsAccepted}
          />
        </div>

        {/* Cột phải (5 cột trên lg) */}
        <div className="lg:col-span-5">
          <PaymentSummarySidebar
            bookingCode={paymentData.bookingCode}
            routeName={paymentData.routeName}
            departureTimeText={paymentData.departureTimeText}
            operatorName={paymentData.operatorName}
            pickupPoint={paymentData.pickupPoint}
            dropoffPoint={paymentData.dropoffPoint}
            passengers={paymentData.passengers}
            priceSummary={paymentData.priceSummary}
            selectedPaymentMethod={selectedMethod}
            isAgreedTerms={isTermsAccepted}
            onPayNow={handlePaymentSubmit}
          />
        </div>
      </div>

      {/* Modal hết thời gian giữ chỗ nếu preview=expired */}
      <PaymentExpiredModal
        isOpen={isExpired}
        bookingCode={paymentData.bookingCode}
        seats={paymentData.passengers.map((p) => p.seatCode)}
        tripId={paymentData.tripId}
      />
    </div>
  );
}
