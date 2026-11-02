"use client";

import { useRouter } from "next/navigation";
import Link from "next/link";
import { ShieldCheck, QrCode, Headphones, Clock } from "lucide-react";
import { formatVnd } from "../../../lib/format";
import { tripLegQuery, type TripLeg } from "../../../lib/data/trip-mappers";

import { TripDetailData } from "../../../lib/data/types";


/**
 * Thuộc tính của thanh bên đặt vé.
 */
interface TripBookingSidebarProps {
  readonly trip: TripDetailData;
  /** Chặng + số khách từ lần tìm: trang chọn chỗ chọn sẵn đúng điểm đón / trả. */
  readonly leg?: TripLeg;
}

/**
 * Cột bên phải cố định hiển thị tóm tắt chi phí và nút chọn ghế (SCR-PSG-16).
 */
export function TripBookingSidebar({
  trip,
  leg = {}
}: TripBookingSidebarProps) {
  const router = useRouter();
  const passengerCount = leg.passengers ?? 1;

  // Tính tạm tính: giá đơn * số hành khách (dùng BigInt)
  const estimatedTotalVnd = trip.priceSingleVnd ? (BigInt(trip.priceSingleVnd) * BigInt(passengerCount)).toString() : "";

  const handleSelectSeat = () => {
    const query = tripLegQuery(leg);
    router.push(`/trips/${encodeURIComponent(trip.id)}/seats${query ? `?${query}` : ""}`);
  };

  return (
    <div className="space-y-4 sticky top-6">
      {/* Card đặt vé */}
      <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-5">
        <div className="flex items-baseline justify-between">
          <div className="flex items-baseline gap-1">
            <span className="text-xs text-neutral-500">Từ</span>
            <span className="text-2xl font-extrabold text-[#00506a] tracking-tight">
              {trip.priceSingleVnd ? formatVnd(trip.priceSingleVnd) : "Chưa có giá"}
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
              {trip.routeMeta}
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
              {estimatedTotalVnd ? formatVnd(estimatedTotalVnd) : "Chưa có giá"}
            </span>
          </div>
        </div>

        {/* Nút hành động chọn ghế */}
        <div className="space-y-2.5">
          <button
            type="button"
            onClick={handleSelectSeat}
            disabled={trip.availableSeats === 0 || !trip.priceSingleVnd}
            className="w-full py-3 rounded-xl bg-[#00506a] hover:bg-[#003d52] active:bg-[#002e3e] text-white font-bold text-sm shadow-xs transition-colors flex items-center justify-center cursor-pointer disabled:cursor-not-allowed disabled:opacity-50"
          >
            Chọn ghế
          </button>

          <div className="flex items-center gap-1.5 justify-center text-[11px] text-neutral-500">
            <Clock className="w-3.5 h-3.5 text-neutral-400" />
            <span>Thời hạn giữ chỗ được hiển thị sau khi xác nhận chọn ghế.</span>
          </div>
        </div>
      </div>

      {/* Cam kết an tâm Vé Xe Nhanh */}
      <div className="p-4 rounded-xl border border-neutral-200/80 bg-neutral-50/50 space-y-3.5 text-xs text-neutral-600">
        <div className="flex items-start gap-2.5">
          <ShieldCheck className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            Chọn VNPay hoặc MoMo khi thanh toán và kiểm tra trạng thái đơn sau khi hoàn tất.
          </p>
        </div>

        <div className="flex items-start gap-2.5">
          <QrCode className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            Xem vé điện tử và mã QR khi đơn được xác nhận.
          </p>
        </div>

        <div className="flex items-start gap-2.5">
          <Headphones className="w-4 h-4 text-[#00506a] shrink-0 mt-0.5" />
          <p className="leading-relaxed">
            <Link href="/support" className="text-vxn-teal-800 underline">Trung tâm hỗ trợ</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
