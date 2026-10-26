"use client";

import { useId, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { AlertCircle, CheckCircle2, Gift, X } from "lucide-react";
import { formatVnd } from "../../lib/format";
import type { LoyaltyRedemptionQuote } from "../../lib/data/types";
import { loyaltyVoucherValue, type LoyaltyProfileData } from "../../lib/data/loyalty-mappers";
import { redeemLoyaltyPoints } from "../../lib/data/loyalty";

/**
 * Thuộc tính của modal Đổi điểm lấy voucher (SCR-PSG-35).
 */
export interface LoyaltyRedemptionModalProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly profile: LoyaltyProfileData;
  readonly defaultQuote?: LoyaltyRedemptionQuote;
  readonly isPreview?: boolean;
}

/**
 * Modal Đổi điểm lấy voucher (SCR-PSG-35 - Figma 1448:20406).
 */
export function LoyaltyRedemptionModal({
  isOpen,
  onClose,
  profile,
  isPreview = false
}: LoyaltyRedemptionModalProps) {
  const router = useRouter();
  const [pointsInput, setPointsInput] = useState<number>(profile.rules?.minRedeemPoints ?? 0);
  const request = useRef<{ points: number; key: string } | null>(null);
  const [redemption, setRedemption] = useState<LoyaltyRedemptionQuote | null>(null);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  const titleId = useId();
  const descId = useId();

  const minPoints = profile.rules?.minRedeemPoints ?? 1;
  const maxPoints = Math.min(profile.availablePoints, 1_000_000);
  const disabled = isPreview || isSubmitting || !!redemption || !profile.rules || (profile.memberStatus !== undefined && profile.memberStatus !== "ACTIVE") || maxPoints < minPoints;
  const quickPoints = [...new Set([minPoints, Math.floor(maxPoints / 2), maxPoints])].filter((points) => points >= minPoints && points <= maxPoints);

  // Giá trị quy đổi theo chính sách hiện hành, không dùng số thực cho phép tính tiền.
  const voucherValueVnd = useMemo(() => {
    return profile.rules && Number.isSafeInteger(pointsInput) && pointsInput >= 0 ? loyaltyVoucherValue(pointsInput, profile.rules.pointValue) : "0";
  }, [pointsInput, profile.rules]);

  const remainingPoints = useMemo(() => {
    return Math.max(0, profile.availablePoints - pointsInput);
  }, [profile.availablePoints, pointsInput]);

  if (!isOpen) return null;

  const handleQuickSelect = (points: number) => {
    const valid = Math.min(Math.max(minPoints, points), maxPoints);
    setPointsInput(valid);
    setErrorMessage(null);
  };

  const handleSliderChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = Number(e.target.value);
    setPointsInput(val);
    setErrorMessage(null);
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const val = Number(e.target.value);
    setPointsInput(val);
    setErrorMessage(null);
  };

  const handleConfirm = async () => {
    if (disabled) return;
    if (!profile.rules) { setErrorMessage("Chưa có chính sách đổi điểm đang áp dụng."); return; }
    if (!Number.isSafeInteger(pointsInput) || pointsInput < minPoints) {
      setErrorMessage(`Số điểm đổi tối thiểu là ${minPoints} điểm.`);
      return;
    }
    if (pointsInput > maxPoints) {
      setErrorMessage(`Bạn chỉ có tối đa ${maxPoints.toLocaleString("vi-VN")} điểm khả dụng.`);
      return;
    }

    setIsSubmitting(true);
    setErrorMessage(null);

    try {
      if (!request.current || request.current.points !== pointsInput) request.current = { points: pointsInput, key: crypto.randomUUID() };
      const result = await redeemLoyaltyPoints(pointsInput, request.current.key);
      if (result.status === "ok") {
        setRedemption(result.data);
        setSuccessMessage(`Đã đổi thành công voucher giảm ${formatVnd(result.data.voucherValueVnd)}, hạn dùng ${result.data.expiryDateText}.${result.data.remainingPoints < 0 ? " Vui lòng tải lại trang để cập nhật số dư." : ""}`);
        router.refresh();
      } else setErrorMessage(result.status === "error" ? result.message ?? "Không thể đổi điểm." : "Đổi điểm chưa khả dụng.");
    } catch {
      setErrorMessage("Đã xảy ra lỗi kết nối khi thực hiện đổi điểm.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-[rgb(8_23_33/0.55)] p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby={titleId}
      aria-describedby={descId}
    >
      <div className="relative w-full max-w-lg rounded-2xl bg-white p-6 shadow-2xl transition-all sm:p-7">
        {/* Nút đóng */}
        <button
          type="button"
          onClick={onClose}
          disabled={isSubmitting}
          className="absolute top-4 right-4 rounded-lg p-1.5 text-vxn-fg-4 transition hover:bg-vxn-bg-soft hover:text-vxn-ink"
          aria-label="Đóng hộp thoại"
        >
          <X className="h-5 w-5" />
        </button>

        {/* Tiêu đề */}
        <div className="flex items-center gap-2.5">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-teal-50 text-vxn-teal-700">
            <Gift className="h-5 w-5" />
          </div>
          <div>
            <h2 id={titleId} className="text-lg font-extrabold text-vxn-ink sm:text-xl">
              Đổi điểm lấy voucher
            </h2>
            <p id={descId} className="text-xs text-vxn-fg-4">
              Quy đổi điểm thưởng VXN Plus sang voucher giảm giá cước vé
            </p>
          </div>
        </div>

        {/* Khối tóm tắt 3 chỉ số */}
        <div className="mt-5 grid grid-cols-3 divide-x divide-vxn-border/60 rounded-xl border border-vxn-border bg-vxn-bg-soft p-3 text-center">
          <div>
            <div className="text-xs text-vxn-fg-4">Điểm hiện có</div>
            <div className="mt-0.5 text-xs font-bold text-vxn-ink sm:text-sm">
              {profile.availablePoints.toLocaleString("vi-VN")} điểm
            </div>
          </div>
          <div>
            <div className="text-xs text-vxn-fg-4">Giá trị quy đổi</div>
            <div className="mt-0.5 text-xs font-bold text-vxn-teal-700 sm:text-sm">
              {profile.rules ? `1 điểm = ${formatVnd(String(profile.rules.pointValue))}` : "Chưa có chính sách"}
            </div>
          </div>
          <div>
            <div className="text-xs text-vxn-fg-4">Số điểm tối thiểu</div>
            <div className="mt-0.5 text-xs font-bold text-vxn-ink sm:text-sm">
              {minPoints} điểm
            </div>
          </div>
        </div>

        {/* Form nhập điểm đổi */}
        <div className="mt-5 space-y-3">
          <label htmlFor="points-input" className="block text-xs font-bold text-vxn-fg-2">
            Số điểm muốn đổi <span className="text-red-500">*</span>
          </label>
          <div className="relative">
            <input
              id="points-input"
              type="number"
              min={minPoints}
              max={maxPoints}
              step={1}
              disabled={disabled}
              value={pointsInput}
              onChange={handleInputChange}
              className="w-full rounded-xl border border-vxn-border bg-white px-4 py-2.5 pr-14 text-sm font-bold text-vxn-ink focus:border-vxn-teal-600 focus:outline-hidden focus:ring-2 focus:ring-vxn-teal-500/20"
            />
            <span className="pointer-events-none absolute top-1/2 right-4 -translate-y-1/2 text-xs font-bold text-vxn-fg-4">
              điểm
            </span>
          </div>

          {/* Nút chọn nhanh */}
          <div className="flex flex-wrap items-center gap-2">
            {quickPoints.map((pts) => (
              <button
                key={pts}
                type="button"
                disabled={disabled}
                onClick={() => handleQuickSelect(pts)}
                className={`rounded-lg border px-3 py-1 text-xs font-semibold transition ${
                  pointsInput === pts
                    ? "border-vxn-teal-600 bg-teal-50 text-vxn-teal-800"
                    : "border-vxn-border bg-white text-vxn-fg-3 hover:bg-vxn-bg-soft"
                }`}
              >
                {pts}
              </button>
            ))}
          </div>

          {/* Slider */}
          <div className="pt-2">
            <input
              type="range"
              min={minPoints}
              max={Math.max(minPoints, maxPoints)}
              step={1}
              disabled={disabled}
              value={pointsInput}
              onChange={handleSliderChange}
              className="h-2 w-full cursor-pointer appearance-none rounded-lg bg-slate-200 accent-[#00506a]"
            />
            <div className="mt-1 flex justify-between text-xs text-vxn-fg-4">
              <span>{minPoints}</span>
              <span>{maxPoints.toLocaleString("vi-VN")}</span>
            </div>
          </div>
        </div>

        {/* Khối tóm tắt kết quả voucher */}
        <div className="mt-5 space-y-2 rounded-xl border border-teal-100 bg-teal-50/60 p-3.5 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Voucher nhận được:</span>
            <span className="text-sm font-extrabold text-vxn-teal-800">
              {profile.rules ? `Giảm ${formatVnd(redemption?.voucherValueVnd ?? voucherValueVnd)}` : "Chưa có chính sách"}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Điểm còn lại sau khi đổi:</span>
            <span className="font-bold text-vxn-ink">
              {redemption ? redemption.remainingPoints < 0 ? "Đang cập nhật số dư" : `${redemption.remainingPoints.toLocaleString("vi-VN")} điểm` : `${remainingPoints.toLocaleString("vi-VN")} điểm (dự kiến)`}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Hạn dùng voucher:</span>
            <span className="font-medium text-vxn-fg-2">{redemption?.expiryDateText ?? (profile.rules ? `${profile.rules.voucherValidityDays} ngày kể từ khi đổi` : "Chưa có chính sách")}</span>
          </div>
        </div>

        {/* Cảnh báo lỗi nếu có */}
        {errorMessage && (
          <div className="mt-4 flex items-start gap-2 rounded-xl border border-red-200 bg-red-50 p-3 text-xs text-red-700">
            <AlertCircle className="mt-0.5 h-4 w-4 shrink-0" />
            <div>{errorMessage}</div>
          </div>
        )}

        {/* Thông báo thành công nếu có */}
        {successMessage && (
          <div className="mt-4 flex items-start gap-2 rounded-xl border border-green-200 bg-green-50 p-3 text-xs text-green-700">
            <CheckCircle2 className="mt-0.5 h-4 w-4 shrink-0" />
            <div>{successMessage}</div>
          </div>
        )}

        {/* Chú thích điều khoản */}
        <p className="mt-4 text-xs leading-relaxed text-vxn-fg-4">
          Điểm đã đổi không hoàn lại. Voucher được lưu vào ví của bạn. Áp dụng voucher khi đặt vé trên web hiện chưa khả dụng.
        </p>

        {/* Nút hành động */}
        <div className="mt-6 flex items-center justify-end gap-3 border-t border-vxn-border/60 pt-4">
          <button
            type="button"
            onClick={onClose}
            disabled={isSubmitting}
            className="rounded-xl border border-vxn-border bg-white px-4 py-2.5 text-xs font-bold text-vxn-fg-3 transition hover:bg-vxn-bg-soft"
          >
            {redemption ? "Đóng" : "Hủy"}
          </button>
          <button
            type="button"
            disabled={disabled || !Number.isSafeInteger(pointsInput) || pointsInput < minPoints || pointsInput > maxPoints}
            onClick={handleConfirm}
            className="rounded-xl bg-[#00506a] px-5 py-2.5 text-xs font-bold text-white shadow-xs transition hover:bg-[#00476b] disabled:opacity-50"
          >
            {isSubmitting ? "Đang xử lý..." : `Xác nhận đổi ${pointsInput.toLocaleString("vi-VN")} điểm`}
          </button>
        </div>
      </div>
    </div>
  );
}
