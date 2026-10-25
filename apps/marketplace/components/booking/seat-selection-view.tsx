"use client";

import { useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { holdSeats } from "../../lib/data/booking";
import { CheckoutStepper } from "./checkout-stepper";
import { SeatPointSelector } from "./seat-point-selector";
import { SeatMap } from "./seat-map";
import { SeatSelectionSidebar } from "./seat-selection-sidebar";
import { SeatHoldConflictModal } from "./seat-hold-conflict-modal";
import { TripSeatSelectionData, SelectedSeatDetail } from "../../lib/data/types";

/**
 * Thuộc tính của view chọn điểm và chọn ghế.
 */
export interface SeatSelectionViewProps {
  readonly initialData: TripSeatSelectionData;
}

/**
 * View tổng hợp toàn bộ màn hình B1 Chọn điểm & Chỗ (SCR-PSG-18).
 */
export function SeatSelectionView({ initialData }: SeatSelectionViewProps) {
  const router = useRouter();
  const submitting = useRef(false);
  // Điểm đón và điểm trả
  const [selectedPickupId, setSelectedPickupId] = useState<string>(
    initialData.selectedPickupPointId
  );
  const [selectedDropoffId, setSelectedDropoffId] = useState<string>(
    initialData.selectedDropoffPointId
  );

  // Danh sách mã ghế đang chọn
  const [selectedSeatCodes, setSelectedSeatCodes] = useState<readonly string[]>(
    initialData.selectedSeatCodes
  );

  // Modal lỗi xung đột chỗ (node 1450:22717)
  const [showConflictModal, setShowConflictModal] = useState<boolean>(
    Boolean(initialData.conflictError)
  );

  // Thông báo lỗi thao tác giữ chỗ
  const [actionError, setActionError] = useState<string | null>(null);

  // Thông tin điểm đón & trả hiện tại
  const currentPickup =
    initialData.pickupPoints.find((p) => p.id === selectedPickupId) ??
    initialData.pickupPoints[0];
  const currentDropoff =
    initialData.dropoffPoints.find((p) => p.id === selectedDropoffId) ??
    initialData.dropoffPoints[0];

  // Tính danh sách tóm tắt ghế đã chọn
  const selectedSeatsSummary: SelectedSeatDetail[] = selectedSeatCodes.map(
    (code) => {
      const seat = initialData.seats.find((s) => s.code === code);
      return {
        id: seat?.id ?? code,
        code,
        seatTypeLabel: seat?.type === "double" ? "Giường đôi" : "Giường đơn",
        floorLabel: seat?.floor === 1 ? "Tầng dưới" : "Tầng trên",
        priceVnd: seat?.priceVnd ?? "0"
      };
    }
  );

  // Tính tổng tiền từ các ghế đã chọn bằng BigInt
  const subtotalBigInt = selectedSeatsSummary.reduce(
    (acc, curr) => acc + BigInt(curr.priceVnd),
    0n
  );
  const subtotalVnd = subtotalBigInt.toString();

  // Toggle chọn / bỏ chọn ghế
  const handleToggleSeat = (code: string): void => {
    setActionError(null);
    if (selectedSeatCodes.includes(code)) {
      setSelectedSeatCodes(selectedSeatCodes.filter((c) => c !== code));
    } else {
      if (selectedSeatCodes.length >= initialData.maxSeats) {
        return;
      }
      setSelectedSeatCodes([...selectedSeatCodes, code]);
    }
  };

  // Bỏ chọn tất cả ghế
  const handleClearSelection = (): void => {
    setSelectedSeatCodes([]);
    setActionError(null);
  };

  // Xử lý nút Tiếp tục (B2)
  const handleContinue = async (): Promise<void> => {
    if (submitting.current) return;
    submitting.current = true;
    setActionError(null);
    try {
      const result = await holdSeats(initialData.tripId, selectedSeatCodes, Number(selectedPickupId), Number(selectedDropoffId));
      if (result.status === "ok") router.push(`/checkout/${result.data.holdId}`);
      else setActionError(result.status === "error" ? result.message ?? "Không thể giữ chỗ. Vui lòng chọn lại ghế." : "Chức năng giữ chỗ tạm thời chưa khả dụng.");
    } catch { setActionError("Không thể kết nối hệ thống giữ chỗ. Vui lòng thử lại."); }
    finally { submitting.current = false; }
  };

  return (
    <div className="mx-auto w-full max-w-[1200px] px-4 py-6 sm:px-6 lg:px-14">
      {/* 1. Thanh tiến trình Stepper */}
      <CheckoutStepper
        currentStep={1}
        holdCountdownSeconds={initialData.holdCountdownSeconds}
      />

      {/* Thông báo lỗi thao tác (nếu người dùng bấm Tiếp tục) */}
      {actionError && (
        <div className="mt-4 rounded-xl border border-amber-200 bg-amber-50 p-3.5 text-xs font-semibold text-amber-800">
          ⚠️ {actionError}
        </div>
      )}

      {/* 2. Bố cục 2 cột chính */}
      <div className="mt-6 flex flex-col gap-8 lg:flex-row lg:items-start">
        {/* Cột trái: Điểm đón/trả và Sơ đồ chọn chỗ */}
        <div className="flex-1 min-w-0 space-y-6">
          <SeatPointSelector
            pickupPoints={initialData.pickupPoints}
            dropoffPoints={initialData.dropoffPoints}
            selectedPickupId={selectedPickupId}
            selectedDropoffId={selectedDropoffId}
            onSelectPickup={setSelectedPickupId}
            onSelectDropoff={setSelectedDropoffId}
          />

          <SeatMap
            seats={initialData.seats}
            selectedSeatCodes={selectedSeatCodes}
            maxSeats={initialData.maxSeats}
            onToggleSeat={handleToggleSeat}
          />
        </div>

        {/* Cột phải: Tóm tắt thông tin đặt vé & nút tiếp tục */}
        <SeatSelectionSidebar
          routeName={initialData.routeName}
          departureTimeText={initialData.departureTimeText}
          operatorName={initialData.operatorName}
          pickupPointName={currentPickup?.name ?? ""}
          pickupTime={currentPickup?.time ?? ""}
          dropoffPointName={currentDropoff?.name ?? ""}
          dropoffTime={currentDropoff?.time ?? ""}
          selectedSeatsSummary={selectedSeatsSummary}
          subtotalVnd={subtotalVnd}
          onClearSelection={handleClearSelection}
          onContinue={handleContinue}
        />
      </div>

      {/* 3. Modal lỗi xung đột chỗ (node 1450:22717) */}
      {initialData.conflictError && (
        <SeatHoldConflictModal
          isOpen={showConflictModal}
          error={initialData.conflictError}
          onClose={() => setShowConflictModal(false)}
        />
      )}
    </div>
  );
}
