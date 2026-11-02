"use client";

import { useEffect, useState } from "react";
import { Check, Clock } from "lucide-react";

/**
 * Thuộc tính của component thanh tiến trình đặt vé.
 */
export interface CheckoutStepperProps {
  /**
   * Bước hiện tại (1: Chọn ghế, 2: Thông tin hành khách, 3: Thanh toán, 4: Hoàn tất).
   */
  readonly currentStep: 1 | 2 | 3 | 4;
  /**
   * Số giây còn lại để giữ ghế.
   */
  readonly holdCountdownSeconds?: number;
}

const STEPS = [
  { step: 1, label: "Chọn ghế" },
  { step: 2, label: "Thông tin hành khách" },
  { step: 3, label: "Thanh toán" },
  { step: 4, label: "Hoàn tất" }
] as const;

/**
 * Định dạng số giây thành chuỗi MM:SS.
 */
function formatCountdown(totalSeconds: number): string {
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
}

/**
 * Thanh tiến trình các bước đặt vé kèm đồng hồ đếm ngược giữ chỗ theo Figma 1443:12719.
 */
export function CheckoutStepper({ currentStep, holdCountdownSeconds }: CheckoutStepperProps) {
  const [remaining, setRemaining] = useState(holdCountdownSeconds ?? 0);
  useEffect(() => {
    if (holdCountdownSeconds === undefined) return;
    const deadline = Date.now() + holdCountdownSeconds * 1000;
    setRemaining(holdCountdownSeconds);
    const timer = setInterval(() => setRemaining(Math.max(0, Math.ceil((deadline - Date.now()) / 1000))), 1000);
    return () => clearInterval(timer);
  }, [holdCountdownSeconds]);
  return (
    <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between border-b border-vxn-border/60 pb-4">
      {/* Các bước */}
      <nav aria-label="Tiến trình đặt vé" className="flex items-center gap-2 sm:gap-4 overflow-x-auto py-1">
        {STEPS.map((item, idx) => {
          const isActive = item.step === currentStep;
          const isDone = item.step < currentStep;

          return (
            <div key={item.step} className="flex items-center gap-2 shrink-0">
              {idx > 0 && (
                <div
                  className={`h-0.5 w-4 sm:w-8 ${
                    isDone ? "bg-vxn-teal-700" : "bg-neutral-200"
                  }`}
                />
              )}
              <div className="flex items-center gap-1.5">
                <span
                  className={`flex h-6 w-6 items-center justify-center rounded-full text-xs font-bold transition ${
                    isActive
                      ? "bg-vxn-teal-900 text-white shadow-xs"
                      : isDone
                      ? "bg-emerald-50 text-emerald-600 border border-emerald-200"
                      : "bg-neutral-100 text-neutral-400"
                  }`}
                >
                  {isDone ? <Check className="h-3.5 w-3.5 stroke-[2.5]" /> : item.step}
                </span>
                <span
                  className={`text-xs sm:text-sm whitespace-nowrap transition ${
                    isActive
                      ? "font-bold text-vxn-ink"
                      : isDone
                      ? "font-medium text-neutral-700"
                      : "font-normal text-neutral-400"
                  }`}
                >
                  {item.label}
                </span>
              </div>
            </div>
          );
        })}
      </nav>

      {/* Đồng hồ đếm ngược giữ chỗ */}
      {currentStep > 1 && typeof holdCountdownSeconds === "number" && (
        <div className="flex items-center gap-1.5 self-start sm:self-auto rounded-lg bg-neutral-100/80 px-2.5 py-1 text-xs text-neutral-600 shrink-0">
          <Clock className="h-3.5 w-3.5 text-neutral-500" />
          <span>Giữ ghế còn</span>
          <span className="font-bold text-vxn-teal-800">
            {formatCountdown(remaining)}
          </span>
        </div>
      )}
    </div>
  );
}
