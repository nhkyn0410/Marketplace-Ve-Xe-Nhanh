import { Airplay, Droplets, MapPin, Star, Wifi } from "lucide-react";
import Link from "next/link";
import { formatVnd } from "../../lib/format";
import { TripSearchResultItem } from "../../lib/data/types";

/**
 * Thuộc tính của component thẻ chuyến xe.
 */
export interface TripCardProps {
  readonly trip: TripSearchResultItem;
}

/**
 * Thẻ hiển thị một chuyến xe trong danh sách kết quả tìm kiếm chuẩn theo Figma 1440:11297.
 */
export function TripCard({ trip }: TripCardProps) {
  return (
    <div className="flex flex-col overflow-hidden rounded-2xl border border-vxn-border bg-white shadow-2xs transition hover:border-vxn-teal-400 hover:shadow-md md:flex-row">
      {/* Ảnh xe bên trái (w-48 đến w-52) */}
      <div
        className="h-44 w-full shrink-0 bg-cover bg-center md:h-auto md:w-48 lg:w-52"
        style={trip.imageUrl ? { backgroundImage: `url('${trip.imageUrl}')` } : undefined}
      />

      {/* Vùng nội dung chi tiết bên phải */}
      <div className="flex flex-1 min-w-0 flex-col justify-between p-4 sm:p-5">
        <div>
          {/* Hàng 1: Nhà xe & Badges */}
          <div className="flex items-center justify-between gap-2 border-b border-vxn-border/50 pb-3">
            <div className="flex items-center gap-2.5 min-w-0">
              <div
                className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl text-xs font-black text-white shadow-xs"
                style={{ backgroundColor: trip.operatorAccentColor ?? "#00506a" }}
              >
                {trip.operatorCode}
              </div>
              <div className="min-w-0">
                <Link href={`/operators/${encodeURIComponent(trip.operatorId)}`} className="block text-sm font-bold text-vxn-ink truncate hover:text-vxn-teal-700">
                  {trip.operatorName}
                </Link>
                <div className="flex items-center gap-1 text-xs text-vxn-fg-4">
                  {trip.operatorRating > 0 && <Star className="h-3 w-3 fill-amber-400 text-amber-500 shrink-0" />}
                  {trip.operatorRating > 0 && <span className="font-bold text-vxn-ink">{trip.operatorRating.toFixed(1)}</span>}
                  <span className="truncate">({trip.operatorRatingCountText})</span>
                </div>
              </div>
            </div>

            {/* Badges loại xe */}
            <div className="flex items-center gap-1.5 shrink-0">
              <span className="rounded-md bg-vxn-bg-mist px-2 py-0.5 text-xs font-semibold text-vxn-teal-900 whitespace-nowrap">
                {trip.seatType}
              </span>
              {trip.vehicleType && trip.vehicleType !== "Tiêu chuẩn" && (
                <span className="rounded-md bg-amber-50 px-2 py-0.5 text-xs font-semibold text-amber-800 whitespace-nowrap">
                  {trip.vehicleType}
                </span>
              )}
            </div>
          </div>

          {/* Hàng 2: Lộ trình & Giá vé */}
          <div className="mt-3.5 flex flex-col gap-2.5 sm:flex-row sm:items-center sm:justify-between">
            {/* Cột thời gian di chuyển */}
            <div className="flex items-center justify-between sm:justify-start gap-2 sm:gap-3.5 shrink-0">
              {/* Giờ đi */}
              <div>
                <div className="text-xl font-black text-vxn-ink sm:text-2xl">
                  {trip.departureTime}
                </div>
                <div className="text-xs font-medium text-vxn-fg-4">{trip.departureCity}</div>
              </div>

              {/* Đường kẻ thời gian */}
              <div className="flex flex-col items-center px-1">
                <span className="text-[11px] font-medium text-vxn-fg-4 whitespace-nowrap">{trip.durationText}</span>
                <div className="relative my-1 flex w-12 sm:w-16 items-center justify-between">
                  <div className="h-1.5 w-1.5 rounded-full bg-vxn-teal-700" />
                  <div className="h-0.5 flex-1 bg-vxn-border-strong border-dashed" />
                  <div className="h-1.5 w-1.5 rounded-full bg-vxn-teal-700" />
                </div>
                <span className="text-[10px] text-vxn-fg-5 whitespace-nowrap">{trip.stopCountText}</span>
              </div>

              {/* Giờ đến */}
              <div>
                <div className="flex items-center gap-1">
                  <span className="text-xl font-black text-vxn-ink sm:text-2xl">
                    {trip.arrivalTime}
                  </span>
                  {trip.isNextDay && (
                    <span className="rounded bg-amber-100 px-1 py-0.5 text-[10px] font-bold text-amber-800 whitespace-nowrap">
                      Ngày sau
                    </span>
                  )}
                </div>
                <div className="text-xs font-medium text-vxn-fg-4">{trip.arrivalCity}</div>
              </div>
            </div>

            {/* Cột Giá vé */}
            <div className="flex items-baseline justify-between sm:block sm:text-right shrink-0 pt-2 sm:pt-0 border-t border-dashed border-vxn-border/50 sm:border-0">
              <span className="text-xs text-vxn-fg-4 sm:hidden">Giá vé từ</span>
              <div className="text-right">
                <div className="text-xl font-black text-vxn-teal-800 sm:text-2xl lg:text-3xl whitespace-nowrap leading-tight">
                  {formatVnd(trip.priceVnd)}
                </div>
                <div className="text-[11px] text-vxn-fg-4">từ / chỗ</div>
              </div>
            </div>
          </div>

          {/* Hàng 3: Chi tiết điểm đón / trả */}
          <div className="mt-3 flex items-center gap-1 text-xs text-vxn-fg-4">
            <MapPin className="h-3.5 w-3.5 shrink-0 text-vxn-fg-5" />
            <span className="truncate">
              Đón: <span className="text-vxn-fg-2 font-medium">{trip.departureStation}</span> • Trả:{" "}
              <span className="text-vxn-fg-2 font-medium">{trip.arrivalStation}</span>
            </span>
          </div>
        </div>

        {/* Hàng 4: Tiện ích & Nút Chọn chuyến */}
        <div className="mt-4 flex flex-col gap-2.5 sm:flex-row sm:items-center sm:justify-between border-t border-vxn-border/50 pt-3">
          {/* Tiện ích */}
          <div className="flex items-center gap-1.5 overflow-hidden">
            {trip.amenities.map((amenity, idx) => (
              <span
                key={idx}
                className="inline-flex items-center gap-1 rounded-md bg-vxn-bg-soft px-2 py-0.5 text-xs text-vxn-fg-3 shrink-0 whitespace-nowrap"
              >
                {amenity === "WiFi" && <Wifi className="h-3 w-3 text-vxn-teal-600" />}
                {amenity === "Điều hòa" && <Airplay className="h-3 w-3 text-vxn-teal-600" />}
                {amenity === "Nước uống" && <Droplets className="h-3 w-3 text-vxn-teal-600" />}
                <span>{amenity}</span>
              </span>
            ))}
          </div>

          {/* Trạng thái chỗ & Nút */}
          <div className="flex items-center justify-between sm:justify-end gap-2.5 sm:gap-3 shrink-0">
            {trip.isUrgent ? (
              <span className="text-xs font-bold text-amber-700 whitespace-nowrap">
                Sắp hết • còn {trip.availableSeats} chỗ
              </span>
            ) : (
              <span className="rounded-md bg-emerald-50 px-2 py-1 text-xs font-bold text-emerald-700 whitespace-nowrap">
                Còn {trip.availableSeats} chỗ
              </span>
            )}

            <Link
              href={`/trips/${trip.id}`}
              className="rounded-xl bg-[#00506a] px-4 sm:px-5 py-2 text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99] whitespace-nowrap shrink-0 text-center"
            >
              Chọn chuyến
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}

