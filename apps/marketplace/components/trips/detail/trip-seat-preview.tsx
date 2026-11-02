"use client";

import { TripSeatPreviewItem } from "../../../lib/data/types";


/**
 * Thuộc tính của khối sơ đồ chỗ xem trước.
 */
interface TripSeatPreviewProps {
  readonly seatMap: readonly TripSeatPreviewItem[];
  readonly totalSeats: number;
  readonly availableSeats: number;
}

/**
 * Khối xem trước sơ đồ chỗ của chuyến xe (SCR-PSG-16).
 */
export function TripSeatPreview({
  seatMap,
  totalSeats,
  availableSeats
}: TripSeatPreviewProps) {
  const floor1Seats = seatMap.filter((s) => s.floor === 1);
  const floor2Seats = seatMap.filter((s) => s.floor === 2);

  /**
   * Trả về class kiểu dáng cho từng ô ghế.
   */
  const getSeatClass = (status: TripSeatPreviewItem["status"]) => {
    switch (status) {
      case "available":
        return "bg-white border-neutral-300 text-neutral-700 hover:border-[#00506a]";
      case "holding":
        return "bg-amber-50 border-amber-400 text-amber-800";
      case "booked":
      case "unavailable":
        return "bg-neutral-100 border-neutral-200 text-neutral-400 cursor-not-allowed";
    }
  };

  return (
    <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
      <div className="flex items-center justify-between">
        <div>
          <h3 className="text-base font-semibold text-neutral-900">
            Sơ đồ chỗ
          </h3>
          <p className="text-xs text-neutral-500 mt-0.5">
            Xem trước tình trạng chỗ. Bấm &quot;Chọn ghế&quot; để chọn và giữ chỗ.
          </p>
        </div>
        <span className="text-xs font-semibold px-2.5 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200">
          Còn {availableSeats} / {totalSeats} chỗ
        </span>
      </div>

      <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 pt-2">
        {/* Tầng dưới */}
        <div className="bg-neutral-50/70 p-4 rounded-xl border border-neutral-100 flex flex-col items-center">
          <span className="text-xs font-semibold text-neutral-600 mb-3">
            Tầng dưới
          </span>
          <div className="grid gap-2 w-full max-w-[220px]" style={{ gridTemplateColumns: `repeat(${Math.max(1, ...floor1Seats.map((s) => s.col))}, minmax(0, 1fr))` }}>
            {floor1Seats.map((seat) => (
              <div
                key={seat.id}
                style={{ gridRowStart: seat.row, gridColumnStart: seat.col }}
                className={`h-7 rounded border text-[11px] font-medium flex items-center justify-center transition-colors ${
                  seat.isDouble ? "h-8" : ""
                } ${getSeatClass(seat.status)}`}
              >
                {seat.label}
              </div>
            ))}
          </div>
        </div>

        {/* Tầng trên */}
        {floor2Seats.length > 0 && <div className="bg-neutral-50/70 p-4 rounded-xl border border-neutral-100 flex flex-col items-center">
          <span className="text-xs font-semibold text-neutral-600 mb-3">
            Tầng trên
          </span>
          <div className="grid gap-2 w-full max-w-[220px]" style={{ gridTemplateColumns: `repeat(${Math.max(1, ...floor2Seats.map((s) => s.col))}, minmax(0, 1fr))` }}>
            {floor2Seats.map((seat) => (
              <div
                key={seat.id}
                style={{ gridRowStart: seat.row, gridColumnStart: seat.col }}
                className={`h-7 rounded border text-[11px] font-medium flex items-center justify-center transition-colors ${
                  seat.isDouble ? "h-8" : ""
                } ${getSeatClass(seat.status)}`}
              >
                {seat.label}
              </div>
            ))}
          </div>
        </div>}

        {/* Chú thích màu sắc */}
        <div className="flex flex-col justify-center space-y-3 pl-2 sm:border-l sm:border-neutral-100 text-xs text-neutral-600">
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded border border-neutral-300 bg-white" />
            <span>Còn trống</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded border border-amber-400 bg-amber-50" />
            <span>Đang giữ</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-4 h-4 rounded border border-neutral-200 bg-neutral-100" />
            <span>Không khả dụng</span>
          </div>
          <div className="pt-2 border-t border-neutral-100 flex items-center gap-2 text-neutral-500">
            <div className="w-7 h-4 rounded border border-neutral-300 bg-white" />
            <span className="text-[11px]">Chỗ rộng = giường đôi (2 người)</span>
          </div>
        </div>
      </div>
    </div>
  );
}
