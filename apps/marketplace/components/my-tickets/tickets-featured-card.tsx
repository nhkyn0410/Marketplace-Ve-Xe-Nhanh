import Link from "next/link";
import { MapPin, Armchair, QrCode } from "lucide-react";

export interface TicketsFeaturedCardProps {
  readonly featured: {
    readonly badgeText: string;
    readonly routeName: string;
    readonly departureTimeText: string;
    readonly operatorName: string;
    readonly pickupPointName: string;
    readonly seatCodesText: string;
    readonly ticketId: string;
    readonly noticeText: string;
  };
}

/**
 * Thẻ Chuyến gần nhất làm nổi bật theo Figma 1445:14030.
 */
export function TicketsFeaturedCard({ featured }: TicketsFeaturedCardProps) {
  return (
    <div className="relative overflow-hidden rounded-3xl bg-[#00506a] text-white p-6 sm:p-8 shadow-sm">
      <div className="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
        {/* Nội dung thông tin chuyến đi bên trái */}
        <div className="space-y-3">
          <span className="inline-block rounded-full bg-emerald-500/20 px-3 py-1 text-xs font-bold text-emerald-300 border border-emerald-400/30">
            {featured.badgeText}
          </span>

          <h2 className="text-xl sm:text-2xl font-black text-white">
            {featured.routeName}
          </h2>

          <p className="text-xs sm:text-sm text-neutral-200">
            {featured.departureTimeText}
          </p>

          <div className="flex flex-wrap items-center gap-4 text-xs text-neutral-200/90 pt-1">
            <div className="flex items-center gap-1.5">
              <MapPin className="h-3.5 w-3.5 text-teal-300" />
              <span>Đón tại {featured.pickupPointName}</span>
            </div>
            <div className="flex items-center gap-1.5">
              <Armchair className="h-3.5 w-3.5 text-teal-300" />
              <span>{featured.seatCodesText}</span>
            </div>
          </div>
        </div>

        {/* Nút hành động và lưu ý bên phải */}
        <div className="flex flex-col sm:items-end gap-2 shrink-0">
          <Link
            href={`/my-tickets/${featured.ticketId}`}
            className="inline-flex items-center justify-center gap-2 rounded-xl bg-amber-400 px-6 py-3 text-xs sm:text-sm font-bold text-neutral-950 shadow-xs transition hover:bg-amber-300 active:scale-[0.99]"
          >
            <QrCode className="h-4 w-4" />
            <span>Xem vé và mã QR</span>
          </Link>
          <span className="text-xs text-neutral-300">
            {featured.noticeText}
          </span>
        </div>
      </div>
    </div>
  );
}
