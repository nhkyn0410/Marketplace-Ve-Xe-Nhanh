"use client";

import { AlertTriangle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { SeatHoldConflictError } from "../../lib/data/types";

/**
 * Thuộc tính của component modal báo lỗi xung đột giữ chỗ.
 */
export interface SeatHoldConflictModalProps {
  readonly isOpen: boolean;
  readonly error: SeatHoldConflictError;
  readonly onClose?: () => void;
}

/**
 * Hộp thoại báo lỗi khi chỗ vừa bị người khác giữ theo Figma 1450:22717.
 */
export function SeatHoldConflictModal({
  isOpen,
  error,
  onClose
}: SeatHoldConflictModalProps) {
  if (!isOpen) {
    return null;
  }

  return (
    <div
      role="dialog"
      aria-modal="true"
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4 backdrop-blur-xs animate-in fade-in-50 duration-200"
    >
      <div className="w-full max-w-md rounded-3xl bg-white p-6 sm:p-8 text-center shadow-2xl animate-in zoom-in-95 duration-200">
        {/* Icon cảnh báo */}
        <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-amber-50 text-amber-500">
          <AlertTriangle className="h-7 w-7" />
        </div>

        {/* Tiêu đề lỗi */}
        <h3 className="mt-4 text-lg sm:text-xl font-extrabold text-vxn-ink">
          Chỗ {error.conflictedSeatCode} vừa có người khác giữ
        </h3>

        {/* Nội dung diễn giải */}
        <p className="mt-2 text-xs sm:text-sm text-vxn-fg-4 leading-relaxed">
          {error.message}
        </p>

        {/* 2 nút hành động */}
        <div className="mt-6 flex flex-col-reverse gap-2.5 sm:flex-row sm:items-center sm:justify-center">
          <Link
            href="/trips"
            className="w-full sm:w-auto rounded-xl border border-neutral-300 bg-white px-5 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 text-center"
          >
            Đổi chuyến khác
          </Link>

          <button
            type="button"
            onClick={onClose}
            className="flex w-full sm:w-auto items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-6 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] cursor-pointer"
          >
            <RefreshCw className="h-3.5 w-3.5" />
            Chọn lại chỗ
          </button>
        </div>
      </div>
    </div>
  );
}
