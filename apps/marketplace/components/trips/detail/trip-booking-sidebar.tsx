"use client";

import { useState } from "react";
import { ShieldCheck, QrCode, Headphones, Clock, AlertCircle } from "lucide-react";
import { formatVnd } from "../../../lib/format";

import { TripDetailData } from "../../../lib/data/types";


/**
 * Thuộc tính của thanh bên đặt vé.
 */
interface TripBookingSidebarProps {
  readonly trip: TripDetailData;
  readonly passengerCount?: number;
}

/**
 * Cột bên phải cố định hiển thị tóm tắt chi phí và nút chọn ghế (SCR-PSG-16).
 */
export function TripBookingSidebar({
  trip,
  passengerCount = 2
}: TripBookingSidebarProps) {
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  // Tính tạm tính: giá đơn * số hành khách (dùng BigInt)
  const singlePrice = BigInt(trip.priceSingleVnd);
  const estimatedTotalVnd = (singlePrice * BigInt(passengerCount)).toString();

  const handleSelectSeat = () => {
    // Thông báo lỗi tại chỗ theo luật: không chuyển trang khi thiếu endpoint hoặc chưa sẵn sàng
    setErrorMessage("Tính năng chọn ghế đang được đồng bộ hóa với hệ thống quản lý chỗ nhà xe.");
  };

  return (
    <div className="space-y-4 sticky top-6">
      {/* Card đặt vé */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
        <div className="flex items-baseline justify-between">
          <div className="flex items-baseline gap-1">
            <span className="text-xs text-neutral-500">Từ</span>
            <span className="text-2xl font-extrabold text-[#00506a] tracking-tight">
              {formatVnd(trip.priceSingleVnd)}
            </span>
            <span className="text-xs text-neutral-500">/ chỗ</span>
          </div>

          <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200">
            Còn {trip.availableSeats} chỗ
          </span>
        </div>

        {/* Tóm tắt ngày và người */}
        <div className="space-y-2.5 py-3 border-y border-neutral-100 text-xs">
          <div className="flex items-center justify-between">
            <span className="text-neutral-500">Ngày đi</span>
            <span className="font-semibold text-neutral-900">
              T6, 16/10/2026
            </span>
          </div>
          <div className="flex items-center justify-between">
            <span className="text-neutral-500">Hành khách</span>
            <span className="font-semibold text-neutral-900">
              {passengerCount} người
            </span>
          </div>
          <div className="flex items-center justify-between pt-1 border-t border-neutral-50">
            <span className="text-neutral-600 font-medium">Tạm tính từ</span>
            <span className="text-base font-extrabold text-neutral-900">
              {formatVnd(estimatedTotalVnd)}
            </span>
          </div>
        </div>

        {/* Nút hành động chọn ghế */}
        <div className="space-y-2.5">
          <button
            type="button"
            onClick={handleSelectSeat}
            className="w-full py-3 rounded-xl bg-[#00506a] hover:bg-[#003d52] active:bg-[#002e3e] text-white font-bold text-sm shadow-xs transition-colors flex items-center justify-center cursor-pointer"
          >
            Chọn ghế
          </button>

          {errorMessage && (
            <div className="flex items-start gap-2 p-3 rounded-lg bg-amber-50 border border-amber-200 text-xs text-amber-900">
              <AlertCircle className="w-4 h-4 text-amber-600 shrink-0 mt-0.5" />
              <span>{errorMessage}</span>
            </div>
          )}

          <div className="flex items-center gap-1.5 justify-center text-[11px] text-neutral-500">
            <Clock className="w-3.5 h-3.5 text-neutral-400" />
            <span>Chỗ được giữ 10 phút kể từ khi bạn chọn xong.</span>
          </div>
        </div>
      </div>

      {/* Cam kết an tâm Vé Xe Nhanh */}
      <div className="p-4 rounded-xl border border-neutral-200/80 bg-neutral-50/50 space-y-3.5 text-xs text-neutral-600">
        <div className="flex items-start gap-2.5">
          <ShieldCheck className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            Thanh toán qua VNPay hoặc MoMo; tiền được Vé Xe Nhanh giữ đến khi chuyến hoàn thành.
          </p>
        </div>

        <div className="flex items-start gap-2.5">
          <QrCode className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            Vé điện tử có mã QR, gửi qua email ngay sau khi thanh toán.
          </p>
        </div>

        <div className="flex items-start gap-2.5">
          <Headphones className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            Cần hỗ trợ? Gọi CSKH 1900 6067.
          </p>
        </div>
      </div>
    </div>
  );
}
