"use client";

import { useId, useMemo, useState } from "react";
import { AlertCircle, CheckCircle2, Gift, X } from "lucide-react";
import { formatVnd } from "../../lib/format";
import type { LoyaltyProfile, LoyaltyRedemptionQuote } from "../../lib/data/types";

/**
 * Thuộc tính của modal Đổi điểm lấy voucher (SCR-PSG-35).
 */
export interface LoyaltyRedemptionModalProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly profile: LoyaltyProfile;
  readonly defaultQuote?: LoyaltyRedemptionQuote;
  readonly onConfirmRedeem?: (points: number) => Promise<boolean>;
}

/**
 * Modal Đổi điểm lấy voucher (SCR-PSG-35 - Figma 1448:20406).
 */
export function LoyaltyRedemptionModal({
  isOpen,
  onClose,
  profile,
  onConfirmRedeem
}: LoyaltyRedemptionModalProps) {
  const [pointsInput, setPointsInput] = useState<number>(100);
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  const titleId = useId();
  const descId = useId();

  const minPoints = 100;
  const maxPoints = profile.availablePoints;

  // Tính toán quy đổi theo thời gian thực (1 điểm = 1.000đ)
  const voucherValueVnd = useMemo(() => {
    return (BigInt(pointsInput) * 1000n).toString();
  }, [pointsInput]);

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
    if (pointsInput < minPoints) {
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
      if (onConfirmRedeem) {
        const ok = await onConfirmRedeem(pointsInput);
        if (ok) {
          setSuccessMessage(`Đã đổi thành công voucher giảm ${formatVnd(voucherValueVnd)}!`);
        } else {
          setErrorMessage(
            "Tính năng đổi điểm hiện đang bảo trì hoặc chưa sẵn sàng trên hệ thống (POST /me/loyalty/redemptions)."
          );
        }
      } else {
        setErrorMessage(
          "Tính năng đổi điểm hiện chưa sẵn sàng (endpoint POST /me/loyalty/redemptions chưa khả dụng)."
        );
        console.warn("[Redemption] Gọi POST /me/loyalty/redemptions bị từ chối do thiếu endpoint");
      }
    } catch {
      setErrorMessage("Đã xảy ra lỗi kết nối khi thực hiện đổi điểm.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-xs"
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
            <h2 id={titleId} className="text-lg font-black text-vxn-ink sm:text-xl">
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
            <div className="text-2xs text-vxn-fg-4">Điểm hiện có</div>
            <div className="mt-0.5 text-xs font-bold text-vxn-ink sm:text-sm">
              {profile.availablePoints.toLocaleString("vi-VN")} điểm
            </div>
          </div>
          <div>
            <div className="text-2xs text-vxn-fg-4">Giá trị quy đổi</div>
            <div className="mt-0.5 text-xs font-bold text-vxn-teal-700 sm:text-sm">
              1 điểm = 1.000đ
            </div>
          </div>
          <div>
            <div className="text-2xs text-vxn-fg-4">Số điểm tối thiểu</div>
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
              step={10}
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
            {[100, 200, 500].map((pts) => (
              <button
                key={pts}
                type="button"
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
            <button
              type="button"
              onClick={() => handleQuickSelect(maxPoints)}
              className={`rounded-lg border px-3 py-1 text-xs font-semibold transition ${
                pointsInput === maxPoints
                  ? "border-vxn-teal-600 bg-teal-50 text-vxn-teal-800"
                  : "border-vxn-border bg-white text-vxn-fg-3 hover:bg-vxn-bg-soft"
              }`}
            >
              Tất cả ({maxPoints.toLocaleString("vi-VN")})
            </button>
          </div>

          {/* Slider */}
          <div className="pt-2">
            <input
              type="range"
              min={minPoints}
              max={maxPoints}
              step={50}
              value={pointsInput}
              onChange={handleSliderChange}
              className="h-2 w-full cursor-pointer appearance-none rounded-lg bg-slate-200 accent-[#00506a]"
            />
            <div className="mt-1 flex justify-between text-2xs text-vxn-fg-4">
              <span>{minPoints}</span>
              <span>{maxPoints.toLocaleString("vi-VN")}</span>
            </div>
          </div>
        </div>

        {/* Khối tóm tắt kết quả voucher */}
        <div className="mt-5 space-y-2 rounded-xl border border-teal-100 bg-teal-50/60 p-3.5 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Voucher nhận được:</span>
            <span className="text-sm font-black text-vxn-teal-800">
              Giảm {formatVnd(voucherValueVnd)}
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Điểm còn lại sau khi đổi:</span>
            <span className="font-bold text-vxn-ink">
              {remainingPoints.toLocaleString("vi-VN")} điểm
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-vxn-fg-3">Hạn dùng voucher:</span>
            <span className="font-medium text-vxn-fg-2">30 ngày · đến 07/11/2026</span>
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
        <p className="mt-4 text-2xs leading-relaxed text-vxn-fg-4">
          Điểm đã đổi không hoàn lại. Voucher dùng cho mọi tuyến, mọi nhà xe; mỗi đơn áp dụng tối đa
          một voucher hoặc một mã.
        </p>

        {/* Nút hành động */}
        <div className="mt-6 flex items-center justify-end gap-3 border-t border-vxn-border/60 pt-4">
          <button
            type="button"
            onClick={onClose}
            className="rounded-xl border border-vxn-border bg-white px-4 py-2.5 text-xs font-bold text-vxn-fg-3 transition hover:bg-vxn-bg-soft"
          >
            Hủy
          </button>
          <button
            type="button"
            disabled={isSubmitting || pointsInput < minPoints || pointsInput > maxPoints}
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
