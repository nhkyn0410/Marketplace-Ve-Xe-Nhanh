"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { checkCheckoutPromotion, createBooking } from "../../lib/data/booking";
import { CheckoutStepper } from "../booking/checkout-stepper";
import { ContactInfoForm } from "./contact-info-form";
import { PassengerListForm } from "./passenger-list-form";
import { TripPointsSummaryCard } from "./trip-points-summary-card";
import { OperatorNoteBox } from "./operator-note-box";
import { CheckoutVoucherSelector } from "./checkout-voucher-selector";
import { CheckoutPaymentSidebar } from "./checkout-payment-sidebar";
import { CheckoutStalePriceModal } from "./checkout-stale-price-modal";
import {
  CheckoutHoldData,
  CheckoutContactInfo,
  CheckoutPassengerItem,
  CheckoutPromotionQuote,
  SavedPassenger
} from "../../lib/data/types";

/**
 * Thuộc tính của component form đặt vé B2.
 */
export interface CheckoutFormViewProps {
  readonly initialData: CheckoutHoldData;
  readonly isPreview?: boolean;
}

/**
 * View tổng hợp toàn bộ màn hình B2 Nhập thông tin hành khách (SCR-PSG-19).
 */
export function CheckoutFormView({ initialData, isPreview = false }: CheckoutFormViewProps) {
  const router = useRouter();
  const submitting = useRef(false);
  const checkingPromotion = useRef(false);
  const [contactInfo, setContactInfo] = useState<CheckoutContactInfo>(
    initialData.contactInfo
  );
  const [passengers, setPassengers] = useState<readonly CheckoutPassengerItem[]>(
    initialData.passengers
  );
  const [note, setNote] = useState<string>(initialData.noteForOperator ?? "");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [expired, setExpired] = useState(initialData.holdCountdownSeconds <= 0);
  useEffect(() => {
    const timer = setTimeout(() => setExpired(true), Math.max(0, initialData.holdCountdownSeconds) * 1000);
    return () => clearTimeout(timer);
  }, [initialData.holdCountdownSeconds]);
  const [showStaleModal, setShowStaleModal] = useState<boolean>(
    Boolean(initialData.stalePrice)
  );
  const [actionError, setActionError] = useState<string | null>(null);
  const [promotionCode, setPromotionCode] = useState("");
  const [promotionQuote, setPromotionQuote] = useState<CheckoutPromotionQuote | null>(null);
  const [promotionError, setPromotionError] = useState<string | null>(null);
  const [isCheckingPromotion, setIsCheckingPromotion] = useState(false);
  // Voucher trong ví đã được máy chủ báo giá sẵn cho chuyến này; mỗi đơn một ưu đãi (voucher HOẶC mã).
  const [selectedVoucherId, setSelectedVoucherId] = useState<string | null>(initialData.selectedVoucherId ?? null);
  const selectedVoucher = initialData.vouchers.find((voucher) => voucher.id === selectedVoucherId && voucher.isApplicable) ?? null;
  const voucherTotalVnd = selectedVoucher ? (BigInt(initialData.priceSummary.ticketPriceTotalVnd) - BigInt(selectedVoucher.discountVnd)).toString() : null;
  const priceSummary = selectedVoucher && voucherTotalVnd
    ? { ...initialData.priceSummary, discountVnd: selectedVoucher.discountVnd, discountLabel: selectedVoucher.discountLabel, finalTotalVnd: voucherTotalVnd }
    : promotionQuote
      ? { ...initialData.priceSummary, discountVnd: promotionQuote.discountVnd, discountLabel: `Mã ${promotionQuote.code}`, finalTotalVnd: promotionQuote.totalVnd }
      : initialData.priceSummary;

  // Chọn voucher trong ví thì bỏ mã đang nhập (mỗi đơn một ưu đãi).
  const handleSelectVoucher = (voucherId: string | null): void => {
    if (checkingPromotion.current || submitting.current || isPreview || expired) return;
    setSelectedVoucherId(voucherId);
    setPromotionCode("");
    setPromotionQuote(null);
    setPromotionError(null);
    setActionError(null);
  };

  // Sửa hoặc bỏ mã phải bỏ cả báo giá cũ trước khi khách xác nhận.
  const handleChangePromotion = (code: string): void => {
    if (checkingPromotion.current || submitting.current || isPreview || expired) return;
    setPromotionCode(code);
    setPromotionQuote(null);
    setPromotionError(null);
    setActionError(null);
  };

  // Chỉ hiển thị số tiền API báo; việc kiểm mã chưa giữ lượt sử dụng.
  const handleApplyPromotion = async (): Promise<void> => {
    if (checkingPromotion.current || submitting.current || isPreview || expired || !promotionCode.trim()) return;
    checkingPromotion.current = true;
    setIsCheckingPromotion(true);
    setSelectedVoucherId(null);
    setPromotionQuote(null);
    setPromotionError(null);
    setActionError(null);
    try {
      const result = await checkCheckoutPromotion(initialData.holdId, promotionCode);
      if (result.status === "ok") {
        setPromotionCode(result.data.code);
        setPromotionQuote(result.data);
      } else {
        setPromotionError(result.status === "error" ? result.message ?? "Không thể áp dụng mã. Vui lòng thử lại." : "Chức năng kiểm mã tạm thời chưa khả dụng.");
      }
    } catch { setPromotionError("Không thể kiểm tra mã lúc này. Vui lòng thử lại."); }
    finally { checkingPromotion.current = false; setIsCheckingPromotion(false); }
  };

  // Cập nhật thông tin liên hệ
  const handleUpdateContact = (
    field: keyof CheckoutContactInfo,
    val: string
  ): void => {
    setContactInfo((prev) => ({ ...prev, [field]: val }));
  };

  // Cập nhật thông tin từng hành khách
  const handleUpdatePassenger = (
    index: number,
    field: keyof CheckoutPassengerItem,
    val: string | boolean
  ): void => {
    setPassengers((prev) =>
      prev.map((p, i) => (i === index ? { ...p, [field]: val } : p))
    );
  };

  // Điền nhanh từ danh sách hành khách đã lưu
  const handleSelectSavedPassenger = (
    index: number,
    saved: SavedPassenger
  ): void => {
    setPassengers((prev) =>
      prev.map((p, i) =>
        i === index
          ? {
              ...p,
              fullName: saved.fullName,
              phoneNumber: saved.phoneNumber,
              idNumber: saved.idNumber
            }
          : p
      )
    );
  };

  // Xử lý nút Tiếp tục thanh toán (B3)
  const handleProceedToPayment = async (): Promise<void> => {
    if (submitting.current || checkingPromotion.current || isPreview) return;
    if (expired) { setActionError("Phiên giữ chỗ đã hết hạn. Vui lòng quay lại chọn chỗ."); return; }
    if (promotionCode.trim() && !promotionQuote) {
      setPromotionError("Vui lòng áp dụng mã hoặc xóa mã trước khi tiếp tục.");
      return;
    }
    submitting.current = true;
    setIsSubmitting(true);
    setActionError(null);
    try {
      const result = await createBooking(initialData.holdId, {
        contactInfo, passengers, note,
        ...(selectedVoucher && voucherTotalVnd
          ? { promotion: { userVoucherId: selectedVoucher.id, expectedTotalVnd: voucherTotalVnd } }
          : promotionQuote ? { promotion: { code: promotionQuote.code, expectedTotalVnd: promotionQuote.totalVnd } } : {})
      });
      if (result.status === "ok") router.push(`/bookings/${result.data.bookingId}/payment`);
      else setActionError(result.status === "error" ? result.message ?? "Không thể tạo đơn. Vui lòng kiểm tra thông tin và giá vé." : "Chức năng đặt vé tạm thời chưa khả dụng.");
    } catch { setActionError("Không thể kết nối hệ thống đặt vé. Vui lòng thử lại."); }
    finally { submitting.current = false; setIsSubmitting(false); }
  };

  return (
    <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
      <h1 className="sr-only">Thông tin hành khách</h1>
      {/* 1. Thanh tiến trình Stepper (Bước 2) */}
      <CheckoutStepper
        currentStep={2}
        holdCountdownSeconds={initialData.holdCountdownSeconds}
      />

      {/* Thông báo lỗi thao tác (khi bấm tiếp tục) */}
      {actionError && (
        <div role="alert" className="mt-4 rounded-xl border border-amber-200 bg-amber-50 p-3.5 text-xs font-semibold text-amber-800">
          ⚠️ {actionError}
        </div>
      )}

      {/* 2. Bố cục 2 cột chính */}
      <div className="mt-6 flex flex-col gap-8 lg:flex-row lg:items-start">
        {/* Cột trái: 5 khối nhập thông tin */}
        <div className="flex-1 min-w-0 space-y-6">
          {/* Khối 1: Thông tin liên hệ */}
          <ContactInfoForm
            contactInfo={contactInfo}
            onChange={handleUpdateContact}
          />

          {/* Khối 2: Danh sách hành khách */}
          <PassengerListForm
            passengers={passengers}
            savedPassengers={initialData.savedPassengers}
            currentSavedCount={initialData.currentSavedPassengersCount}
            maxSavedCount={initialData.maxSavedPassengers}
            onUpdatePassenger={handleUpdatePassenger}
            onSelectSavedPassenger={handleSelectSavedPassenger}
          />

          {/* Khối 3: Tóm tắt điểm đón & trả */}
          <TripPointsSummaryCard
            tripId={initialData.tripId}
            pickupPoint={initialData.pickupPoint}
            dropoffPoint={initialData.dropoffPoint}
          />

          {/* Khối 4: Ghi chú cho nhà xe */}
          <OperatorNoteBox note={note} onChange={setNote} />

          {/* Khối 5: Ưu đãi voucher */}
          <CheckoutVoucherSelector
            code={promotionCode}
            quote={promotionQuote}
            error={promotionError}
            isChecking={isCheckingPromotion}
            isDisabled={isPreview || isSubmitting || isCheckingPromotion || expired}
            isPreview={isPreview}
            onChange={handleChangePromotion}
            onApply={handleApplyPromotion}
            onRemove={() => handleChangePromotion("")}
            vouchers={initialData.vouchers}
            selectedVoucherId={selectedVoucher?.id ?? null}
            onSelectVoucher={handleSelectVoucher}
          />
        </div>

        {/* Cột phải: Tóm tắt thanh toán */}
        <CheckoutPaymentSidebar
          tripId={initialData.tripId}
          routeName={initialData.routeName}
          departureTimeText={initialData.departureTimeText}
          operatorName={initialData.operatorName}
          pickupPoint={initialData.pickupPoint}
          dropoffPoint={initialData.dropoffPoint}
          passengers={passengers}
          priceSummary={priceSummary}
          onProceedToPayment={handleProceedToPayment}
          isSubmitting={isSubmitting}
          isExpired={expired}
          isDisabled={isPreview || isCheckingPromotion}
        />
      </div>

      {/* 3. Modal cảnh báo giá vé thay đổi (node 1450:22911) */}
      {initialData.stalePrice && (
        <CheckoutStalePriceModal
          isOpen={showStaleModal}
          stalePrice={initialData.stalePrice}
          onDismiss={() => setShowStaleModal(false)}
          onAccept={() => setShowStaleModal(false)}
        />
      )}
    </div>
  );
}
