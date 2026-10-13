import { cn } from "@vexenhanh/ui/lib/utils";

import type { TripSeat, TripSeatStatus } from "../../lib/trip/trip-api";
import { seatCountLabel, TRIP_SEAT_STATUS, TRIP_SEAT_STATUS_ORDER } from "../../lib/trip/trip-format";

const DOUBLE_TYPES: TripSeat["type"][] = ["BED_DOUBLE", "CABIN_DOUBLE"];

// Màu từng trạng thái chỗ theo Figma "VXN / Trip seat".
const SEAT_STYLE: Record<TripSeatStatus, string> = {
  AVAILABLE: "border bg-card text-vxn-ink",
  HOLDING: "border border-warning-50 bg-warning-50 text-warning-700",
  BOOKED: "border border-success-50 bg-success-50 text-success-600",
  CHECKED_IN: "border border-success-600 bg-success-600 text-primary-foreground",
  BLOCKED: "border bg-muted text-muted-foreground"
};

/**
 * Sơ đồ ghế theo chuyến (Figma "Trip seat map"): mỗi tầng một khối, mỗi chỗ ghi mã và tình trạng. Ghế là bản
 * chụp sơ đồ của xe lúc gắn xe nên lưới dựng từ chính vị trí của các chỗ. Chỉ đọc — khóa chỗ thuộc TRN-006.
 */
export function TripSeatMap({ seats }: { seats: TripSeat[] }) {
  const decks = [...new Set(seats.map((seat) => seat.deck))].sort((a, b) => a - b);
  const present = TRIP_SEAT_STATUS_ORDER.filter((status) => seats.some((seat) => seat.status === status));
  return (
    <div className="flex flex-col gap-5">
      <ul aria-label="Chú giải tình trạng chỗ" className="flex flex-wrap items-center gap-x-4 gap-y-2">
        {present.map((status) => (
          <li key={status} className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
            <span aria-hidden className={cn("size-3.5 rounded", SEAT_STYLE[status])} />
            {TRIP_SEAT_STATUS[status]}
          </li>
        ))}
      </ul>
      <div className="flex flex-wrap items-start gap-6 overflow-x-auto">
        {decks.map((deck) => (
          <Deck key={deck} deck={deck} seats={seats.filter((seat) => seat.deck === deck)} />
        ))}
      </div>
    </div>
  );
}

function Deck({ deck, seats }: { deck: number; seats: TripSeat[] }) {
  const rows = Math.max(...seats.map((seat) => seat.row));
  const columns = Math.max(...seats.map((seat) => seat.column));
  const byPosition = new Map(seats.map((seat) => [`${seat.row}:${seat.column}`, seat]));
  return (
    <section aria-label={`Tầng ${deck}: ${seats.length} chỗ`} className="flex flex-col gap-3 rounded-lg border p-4">
      <div className="flex items-center gap-2">
        <h3 className="flex-1 text-sm leading-5 font-semibold text-vxn-ink">Tầng {deck}</h3>
        <span className="text-xs leading-[18px] text-muted-foreground">{seatCountLabel(seats.length)}</span>
      </div>
      <p className="flex h-6 items-center justify-center rounded-md bg-muted text-[11px] leading-4 font-medium text-muted-foreground">
        ĐẦU XE
      </p>
      <ul className="flex flex-col gap-3">
        {Array.from({ length: rows }, (_, rowIndex) => (
          <li key={rowIndex} className="flex gap-3">
            {Array.from({ length: columns }, (_, columnIndex) => {
              const seat = byPosition.get(`${rowIndex + 1}:${columnIndex + 1}`);
              if (!seat) {
                // Ô trống giữ chỗ cho lối đi, để các hàng thẳng cột.
                return <span key={columnIndex} aria-hidden className="h-14 w-[76px]" />;
              }
              const double = DOUBLE_TYPES.includes(seat.type);
              return (
                <span
                  key={columnIndex}
                  className={cn(
                    "flex h-14 flex-col items-center justify-center gap-0.5 rounded-lg px-1",
                    double ? "w-[164px]" : "w-[76px]",
                    SEAT_STYLE[seat.status]
                  )}
                >
                  <span className="text-[13px] leading-[18px] font-semibold">{seat.code}</span>
                  <span className={cn("text-[11px] leading-4", seat.status === "AVAILABLE" && "text-muted-foreground")}>
                    {TRIP_SEAT_STATUS[seat.status]}
                    {double && " · Đôi"}
                  </span>
                </span>
              );
            })}
          </li>
        ))}
      </ul>
      <p className="text-center text-[11px] leading-4 font-medium text-muted-foreground">CUỐI XE</p>
    </section>
  );
}
