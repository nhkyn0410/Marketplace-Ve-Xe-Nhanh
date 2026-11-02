import Link from "next/link";
import { SeatLocationPoint } from "../../lib/data/types";

/**
 * Thuộc tính của component tóm tắt điểm đón và trả.
 */
export interface TripPointsSummaryCardProps {
  readonly tripId: string;
  readonly pickupPoint: SeatLocationPoint;
  readonly dropoffPoint: SeatLocationPoint;
}

/**
 * Khối tóm tắt điểm đón và điểm trả đã chọn theo Figma 1444:12531.
 */
export function TripPointsSummaryCard({
  tripId,
  pickupPoint,
  dropoffPoint
}: TripPointsSummaryCardProps) {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="flex items-center justify-between border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Điểm đón và điểm trả
        </h3>
        <Link
          href={`/trips/${tripId}/seats`}
          className="text-xs font-semibold text-vxn-teal-800 hover:underline"
        >
          Thay đổi ở bước 1 &gt;
        </Link>
      </div>

      <div className="mt-5 grid grid-cols-1 gap-4 sm:grid-cols-2">
        {/* Điểm đón */}
        <div className="rounded-xl border border-vxn-border/60 bg-neutral-50/40 p-3.5">
          <div className="text-[11px] font-bold uppercase tracking-wider text-vxn-fg-4">
            Điểm đón • {pickupPoint.time}
          </div>
          <div className="mt-1 text-xs sm:text-sm font-bold text-vxn-ink">
            {pickupPoint.name}
          </div>
          <div className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">
            {pickupPoint.address}
          </div>
        </div>

        {/* Điểm trả */}
        <div className="rounded-xl border border-vxn-border/60 bg-neutral-50/40 p-3.5">
          <div className="text-[11px] font-bold uppercase tracking-wider text-vxn-fg-4">
            Điểm trả • {dropoffPoint.time}
          </div>
          <div className="mt-1 text-xs sm:text-sm font-bold text-vxn-ink">
            {dropoffPoint.name}
          </div>
          <div className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">
            {dropoffPoint.address}
          </div>
        </div>
      </div>
    </section>
  );
}
