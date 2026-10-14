import { cn } from "@vexenhanh/ui/lib/utils";
import type { ReactNode } from "react";

import { formatVnd } from "../../lib/fare/fare-format";
import type { TripSeat, TripSeatStatus } from "../../lib/trip/trip-api";
import { seatCountLabel, TRIP_SEAT_STATUS, TRIP_SEAT_STATUS_ORDER } from "../../lib/trip/trip-format";
import { seatSelectionMode, type SeatSelection } from "../../lib/trip/trip-sale";

const DOUBLE_TYPES: TripSeat["type"][] = ["BED_DOUBLE", "CABIN_DOUBLE"];

// Màu từng trạng thái chỗ theo Figma "VXN / Trip seat".
const SEAT_STYLE: Record<TripSeatStatus, string> = {
  AVAILABLE: "border bg-card text-vxn-ink",
  HOLDING: "border border-warning-50 bg-warning-50 text-warning-700",
  BOOKED: "border border-success-50 bg-success-50 text-success-600",
  CHECKED_IN: "border border-success-600 bg-success-600 text-primary-foreground",
  BLOCKED: "border bg-muted text-muted-foreground"
};
const SELECTED_STYLE = "border-2 border-primary bg-accent text-vxn-teal-700";

/** Cách chọn chỗ để khóa / mở khóa (TRN-006); không truyền thì sơ đồ chỉ đọc. */
export type SeatPicking = {
  selection: SeatSelection | null;
  onToggle: (seat: TripSeat) => void;
  /** Đang gửi thay đổi lên máy chủ: tạm không cho đổi lô đang chọn. */
  disabled: boolean;
};

/**
 * Sơ đồ ghế theo chuyến (Figma "Trip seat map"): mỗi tầng một khối, mỗi chỗ ghi mã kèm giá (chỗ còn trống) hoặc
 * tình trạng. Ghế là bản chụp sơ đồ của xe lúc gắn xe nên lưới dựng từ chính vị trí của các chỗ. Giá lấy theo
 * bảng giá của tuyến (TRN-005), màn này chỉ hiển thị. Có `picking` thì chỗ Còn trống / Đã khóa bấm được để chọn
 * rồi khóa / mở khóa (TRN-006, BR-42); `toolbar` là thanh "Đã chọn …" nằm giữa chú giải và sơ đồ.
 */
export function TripSeatMap({
  seats,
  picking,
  toolbar
}: {
  seats: TripSeat[];
  picking?: SeatPicking;
  toolbar?: ReactNode;
}) {
  const decks = [...new Set(seats.map((seat) => seat.deck))].sort((a, b) => a - b);
  const legend = TRIP_SEAT_STATUS_ORDER.filter((status) => seats.some((seat) => seat.status === status)).map(
    (status) => ({ label: TRIP_SEAT_STATUS[status], style: SEAT_STYLE[status] })
  );
  if (picking) {
    // "Đang chọn" đứng ngay sau "Còn trống" như khung Figma.
    const afterAvailable = seats.some((seat) => seat.status === "AVAILABLE") ? 1 : 0;
    legend.splice(afterAvailable, 0, { label: "Đang chọn", style: SELECTED_STYLE });
  }
  return (
    <div className="flex flex-col gap-5">
      <ul aria-label="Chú giải tình trạng chỗ" className="flex flex-wrap items-center gap-x-4 gap-y-2">
        {legend.map(({ label, style }) => (
          <li key={label} className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
            <span aria-hidden className={cn("size-3.5 rounded", style)} />
            {label}
          </li>
        ))}
      </ul>
      {toolbar}
      <div className="flex flex-wrap items-start gap-6 overflow-x-auto">
        {decks.map((deck) => (
          <Deck key={deck} deck={deck} seats={seats.filter((seat) => seat.deck === deck)} picking={picking} />
        ))}
      </div>
    </div>
  );
}

/**
 * Dòng dưới mã chỗ: chỗ còn trống ghi giá ("Chưa có giá" nếu bảng giá chưa phủ tới); chỗ khác ghi tình trạng. Chỗ
 * đôi ghi thêm "Đôi" để không chỉ phân biệt bằng bề rộng ô.
 */
function SeatDetail({ seat, double, selected }: { seat: TripSeat; double: boolean; selected: boolean }) {
  const suffix = double ? " · Đôi" : "";
  if (selected) {
    return <span className="text-[11px] leading-4">Đang chọn{suffix}</span>;
  }
  if (seat.status !== "AVAILABLE") {
    return (
      <span className="text-[11px] leading-4">
        {TRIP_SEAT_STATUS[seat.status]}
        {suffix}
      </span>
    );
  }
  if (seat.price === null) {
    return <span className="text-[11px] leading-4 text-error-600">Chưa có giá{suffix}</span>;
  }
  return (
    <span className="text-[11px] leading-4 text-muted-foreground">
      {formatVnd(seat.price)}
      {suffix}
    </span>
  );
}

function Deck({ deck, seats, picking }: { deck: number; seats: TripSeat[]; picking?: SeatPicking }) {
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
              return <SeatCell key={columnIndex} seat={seat} picking={picking} />;
            })}
          </li>
        ))}
      </ul>
      <p className="text-center text-[11px] leading-4 font-medium text-muted-foreground">CUỐI XE</p>
    </section>
  );
}

function SeatCell({ seat, picking }: { seat: TripSeat; picking?: SeatPicking }) {
  const double = DOUBLE_TYPES.includes(seat.type);
  const mode = seatSelectionMode(seat.status);
  const selected = picking?.selection?.codes.includes(seat.code) ?? false;
  const className = cn(
    "flex h-14 flex-col items-center justify-center gap-0.5 rounded-lg px-1",
    double ? "w-[164px]" : "w-[76px]",
    selected ? SELECTED_STYLE : SEAT_STYLE[seat.status]
  );
  const content = (
    <>
      <span className="text-[13px] leading-[18px] font-semibold">{seat.code}</span>
      <SeatDetail seat={seat} double={double} selected={selected} />
    </>
  );
  // Chỗ đang giữ / đã bán / đã lên xe không khóa hay mở khóa được nên không phải nút.
  if (!picking || !mode) {
    return <span className={className}>{content}</span>;
  }
  // Một lô chỉ gồm một loại: đang chọn chỗ để khóa thì chỗ đã khóa tạm không bấm được, và ngược lại.
  const otherKind = picking.selection !== null && picking.selection.mode !== mode;
  return (
    <button
      type="button"
      aria-pressed={selected}
      disabled={picking.disabled || otherKind}
      title={
        otherKind
          ? mode === "unlock"
            ? "Bỏ chọn các chỗ đang chọn trước khi chọn chỗ đã khóa"
            : "Bỏ chọn các chỗ đang chọn trước khi chọn chỗ còn trống"
          : undefined
      }
      onClick={() => picking.onToggle(seat)}
      className={cn(
        className,
        "cursor-pointer outline-none hover:border-primary focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-60 disabled:hover:border-border"
      )}
    >
      {content}
    </button>
  );
}
