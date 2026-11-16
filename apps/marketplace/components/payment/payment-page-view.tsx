"use client";

import { useEffect, useRef, useState } from "react";
import { createPayment } from "../../lib/data/booking";
import type { BookingPaymentData, PaymentProviderOption, SupportedPaymentMethod } from "../../lib/data/types";
import { CheckoutStepper } from "../booking/checkout-stepper";
import { defaultPaymentMethod, FALLBACK_PAYMENT_PROVIDERS, PaymentMethodSelector } from "./payment-method-selector";
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
  /** Cổng theo `GET /payment-providers`; không có (máy chủ cũ / lỗi tải) thì dùng VNPay + MoMo như trước. */
  readonly providers?: readonly PaymentProviderOption[];
}

/**
 * Client component quản lý luồng tương tác màn hình thanh toán B3 (Figma 1444:13055 & 1450:23099).
 */
export function PaymentPageView({ paymentData, isExpired = false, providers = FALLBACK_PAYMENT_PROVIDERS }: PaymentPageViewProps) {
  const submitting = useRef(false);
  const [expired, setExpired] = useState(isExpired || Boolean(paymentData.isExpired));
  useEffect(() => {
    if (isExpired || paymentData.isExpired) { setExpired(true); return; }
    const timer = setTimeout(() => setExpired(true), paymentData.holdCountdownSeconds * 1000);
    return () => clearTimeout(timer);
  }, [isExpired, paymentData.isExpired, paymentData.holdCountdownSeconds]);
  // Mặc định: cổng của lần trước nếu còn bật, không thì cổng đang bật đầu tiên (Q5).
  const [selectedMethod, setSelectedMethod] = useState<SupportedPaymentMethod | undefined>(() =>
    defaultPaymentMethod(providers, paymentData.selectedPaymentMethod)
  );
  // Mặc định chưa đồng ý: khách phải tự tick thì nút thanh toán mới mở (SCR-PSG-20, trạng thái Empty).
  const [isTermsAccepted, setIsTermsAccepted] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  /**
   * Xử lý khi nhấn nút thanh toán.
   */
  const handlePaymentSubmit = async () => {
    setErrorMessage(null);

    if (!isTermsAccepted) {
      setErrorMessage("Vui lòng đồng ý với Điều khoản sử dụng và chính sách hủy / hoàn tiền để tiếp tục.");
      return;
    }

    if (submitting.current) return;
    if (expired) { setErrorMessage("Đơn đã hết hạn thanh toán. Vui lòng chọn lại chuyến."); return; }
    if (!selectedMethod) { setErrorMessage("Hiện chưa có cổng thanh toán nào hoạt động. Vui lòng quay lại sau."); return; }
    submitting.current = true;
    try {
      const result = await createPayment(paymentData.bookingId, selectedMethod);
      if (result.status === "ok") window.location.assign(result.data.paymentUrl);
      else setErrorMessage(result.status === "error" ? result.message ?? "Không thể khởi tạo thanh toán. Vui lòng thử lại." : "Cổng thanh toán tạm thời chưa khả dụng.");
    } catch { setErrorMessage("Không thể kết nối cổng thanh toán. Vui lòng thử lại."); }
    finally { submitting.current = false; }
  };

  return (
    <div className="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-14 py-6 space-y-6">
      <h1 className="sr-only">Thanh toán</h1>
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
            providers={providers}
            selectedMethod={selectedMethod}
            onSelectMethod={setSelectedMethod}
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
        isOpen={expired}
        bookingCode={paymentData.bookingCode}
        seats={paymentData.passengers.map((p) => p.seatCode)}
        tripId={paymentData.tripId}
      />
    </div>
  );
}
