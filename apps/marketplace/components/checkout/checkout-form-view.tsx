"use client";

import { useState } from "react";
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
  SavedPassenger
} from "../../lib/data/types";

/**
 * Thuộc tính của component form đặt vé B2.
 */
export interface CheckoutFormViewProps {
  readonly initialData: CheckoutHoldData;
}

/**
 * View tổng hợp toàn bộ màn hình B2 Nhập thông tin hành khách (SCR-PSG-19).
 */
export function CheckoutFormView({ initialData }: CheckoutFormViewProps) {
  const [contactInfo, setContactInfo] = useState<CheckoutContactInfo>(
    initialData.contactInfo
  );
  const [passengers, setPassengers] = useState<readonly CheckoutPassengerItem[]>(
    initialData.passengers
  );
  const [note, setNote] = useState<string>(initialData.noteForOperator ?? "");
  const [selectedVoucherId, setSelectedVoucherId] = useState<string | undefined>(
    initialData.selectedVoucherId
  );
  const [showStaleModal, setShowStaleModal] = useState<boolean>(
    Boolean(initialData.stalePrice)
  );
  const [actionError, setActionError] = useState<string | null>(null);

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
  const handleProceedToPayment = (): void => {
    // Tuân thủ A5 #3: Không gọi mạng giả mạo, báo lỗi tại chỗ và console.warn
    console.warn("[marketplace] chưa có API: POST /bookings");
    setActionError(
      "Chưa thực hiện được — chức năng đặt vé chưa sẵn sàng (POST /bookings)."
    );
  };

  return (
    <div className="mx-auto max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
      {/* 1. Thanh tiến trình Stepper (Bước 2) */}
      <CheckoutStepper
        currentStep={2}
        holdCountdownSeconds={initialData.holdCountdownSeconds}
      />

      {/* Thông báo lỗi thao tác (khi bấm tiếp tục) */}
      {actionError && (
        <div className="mt-4 rounded-xl border border-amber-200 bg-amber-50 p-3.5 text-xs font-semibold text-amber-800">
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
            vouchers={initialData.vouchers}
            selectedVoucherId={selectedVoucherId}
            onSelectVoucher={setSelectedVoucherId}
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
          priceSummary={initialData.priceSummary}
          onProceedToPayment={handleProceedToPayment}
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
