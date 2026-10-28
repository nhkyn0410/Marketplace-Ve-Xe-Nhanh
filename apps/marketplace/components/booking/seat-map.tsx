"use client";

import { User } from "lucide-react";
import { SeatSelectionItem, SeatSelectionStatus } from "../../lib/data/types";

/**
 * Thuộc tính của component sơ đồ chọn ghế.
 */
export interface SeatMapProps {
  readonly seats: readonly SeatSelectionItem[];
  readonly selectedSeatCodes: readonly string[];
  readonly maxSeats: number;
  readonly onToggleSeat?: (seatCode: string) => void;
}

/**
 * Hiển thị một ô ghế cụ thể với kiểu dáng chuẩn Figma 1443:12719.
 */
function SeatTile({
  seat,
  isSelected,
  onToggle
}: {
  readonly seat: SeatSelectionItem;
  readonly isSelected: boolean;
  readonly onToggle?: (code: string) => void;
}) {
  // Trạng thái hiển thị thực tế
  let effectiveStatus: SeatSelectionStatus = seat.status;
  if (isSelected) {
    effectiveStatus = "selected";
  }

  const isClickable =
    seat.status === "available" || seat.status === "selected" || isSelected;

  // Lớp CSS theo trạng thái
  let statusClasses = "";
  if (effectiveStatus === "selected") {
    statusClasses = "bg-vxn-teal-900 text-white border-vxn-teal-900 shadow-xs";
  } else if (effectiveStatus === "holding") {
    statusClasses =
      "bg-amber-50/70 border-amber-400 text-amber-800 cursor-not-allowed";
  } else if (effectiveStatus === "booked") {
    statusClasses =
      "bg-neutral-100 border-neutral-200 text-neutral-400 cursor-not-allowed";
  } else if (effectiveStatus === "disabled") {
    statusClasses =
      "bg-neutral-50/50 border border-dashed border-neutral-300 text-neutral-300 cursor-not-allowed";
  } else {
    // available
    statusClasses =
      "bg-white border-neutral-200 text-vxn-ink hover:border-vxn-teal-700 hover:bg-teal-50/10 cursor-pointer";
  }

  // Nếu là giường đôi
  if (seat.type === "double") {
    return (
      <button
        type="button"
        disabled={!isClickable}
        style={{ gridRowStart: seat.row, gridColumnStart: seat.column }}
        onClick={() => isClickable && onToggle?.(seat.code)}
        className={`col-start-2 col-span-1 flex h-12 w-20 sm:w-22 flex-col items-center justify-center rounded-xl border p-1 transition active:scale-[0.99] ${statusClasses}`}
        aria-label={`Ghế ${seat.code} (${seat.capacityText ?? "giường đôi"})`}
      >
        <span className="text-xs font-bold leading-tight">{seat.code}</span>
        {seat.capacityText && (
          <span
            className={`text-[10px] leading-tight ${
              effectiveStatus === "selected" ? "text-teal-100" : "text-neutral-500"
            }`}
          >
            {seat.capacityText}
          </span>
        )}
      </button>
    );
  }

  return (
    <button
      type="button"
      disabled={!isClickable}
      style={{ gridRowStart: seat.row, gridColumnStart: seat.column }}
      onClick={() => isClickable && onToggle?.(seat.code)}
      className={`flex h-11 w-11 sm:h-12 sm:w-12 items-center justify-center rounded-xl border text-xs font-bold transition active:scale-95 ${statusClasses}`}
      aria-label={`Ghế ${seat.code}`}
    >
      {seat.code}
    </button>
  );
}

/** Một tầng của sơ đồ; `title` trống (xe một tầng) thì không ghi tên tầng. */
function SeatDeck({
  title,
  seats,
  selectedSeatCodes,
  onToggleSeat
}: {
  readonly title: string | null;
  readonly seats: readonly SeatSelectionItem[];
  readonly selectedSeatCodes: readonly string[];
  readonly onToggleSeat?: (seatCode: string) => void;
}) {
  return (
    <div className="rounded-2xl border border-vxn-border bg-neutral-50/30 p-4 sm:p-5">
      {title && <div className="text-center font-bold text-sm text-vxn-ink">{title}</div>}
      <div className={`${title ? "mt-2.5" : ""} flex items-center justify-center`}>
        <span className="inline-flex items-center gap-1.5 rounded-full border border-neutral-200 bg-white px-3 py-0.5 text-[11px] text-neutral-500">
          <User className="h-3 w-3" />
          Đầu xe • tài xế
        </span>
      </div>

      <div
        className="mt-5 grid gap-2.5 sm:gap-3 place-items-center"
        style={{ gridTemplateColumns: `repeat(${Math.max(1, ...seats.map((seat) => seat.column ?? 3))}, minmax(0, 1fr))` }}
      >
        {seats.map((seat) => (
          <SeatTile key={seat.id} seat={seat} isSelected={selectedSeatCodes.includes(seat.code)} onToggle={onToggleSeat} />
        ))}
      </div>
    </div>
  );
}

const LEGEND: readonly { status: SeatSelectionStatus; label: string; swatch: string }[] = [
  { status: "available", label: "Còn trống", swatch: "border border-neutral-300 bg-white" },
  { status: "selected", label: "Đang chọn", swatch: "bg-vxn-teal-900" },
  { status: "holding", label: "Đang giữ", swatch: "border border-amber-400 bg-amber-50" },
  { status: "booked", label: "Đã đặt", swatch: "border border-neutral-200 bg-neutral-100" },
  { status: "disabled", label: "Không bán", swatch: "border border-dashed border-neutral-300 bg-white" }
];

/**
 * Khối sơ đồ chọn chỗ theo Figma 1443:12719: xe hai tầng hiện hai tầng cạnh nhau; xe một tầng hiện một sơ đồ ở giữa,
 * không ghi tên tầng. Chú thích chỉ liệt kê trạng thái có trên xe này (API công khai gộp đã bán / đang giữ / bị khóa
 * thành "Đã đặt", nên thường không có "Đang giữ").
 */
export function SeatMap({
  seats,
  selectedSeatCodes,
  maxSeats,
  onToggleSeat
}: SeatMapProps) {
  const floor1Seats = seats.filter((s) => s.floor === 1);
  const floor2Seats = seats.filter((s) => s.floor === 2);
  const twoDecks = floor1Seats.length > 0 && floor2Seats.length > 0;
  const present = new Set<SeatSelectionStatus>(seats.map((seat) => seat.status));
  const legend = LEGEND.filter(({ status }) => status === "available" || status === "selected" || present.has(status));

  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      {/* Header khối */}
      <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between border-b border-vxn-border/50 pb-4">
        <div>
          <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
            Chọn chỗ
          </h3>
          <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
            Chỗ đang giữ hoặc đã đặt không chọn được. Giường đôi bán nguyên chỗ cho 1–2 hành khách.
          </p>
        </div>

        <div className="shrink-0 self-start sm:self-auto">
          <span className="inline-flex items-center rounded-full bg-teal-50 border border-teal-200/80 px-3 py-1 text-xs font-bold text-vxn-teal-900">
            Đã chọn {selectedSeatCodes.length} / {maxSeats} chỗ
          </span>
        </div>
      </div>

      {/* Chú thích màu sắc (Legend) */}
      <div className="mt-4 flex flex-wrap items-center gap-x-5 gap-y-2 rounded-xl bg-neutral-50/80 p-3 text-xs text-neutral-600">
        {legend.map(({ status, label, swatch }) => (
          <div key={status} className="flex items-center gap-2">
            <span className={`h-4 w-4 rounded-md ${swatch}`} />
            <span className={status === "selected" ? "font-medium text-vxn-ink" : undefined}>{label}</span>
          </div>
        ))}
      </div>

      {twoDecks ? (
        <div className="mt-6 grid grid-cols-1 gap-6 sm:grid-cols-2">
          <SeatDeck title="Tầng dưới" seats={floor1Seats} selectedSeatCodes={selectedSeatCodes} onToggleSeat={onToggleSeat} />
          <SeatDeck title="Tầng trên" seats={floor2Seats} selectedSeatCodes={selectedSeatCodes} onToggleSeat={onToggleSeat} />
        </div>
      ) : (
        <div className="mx-auto mt-6 w-full max-w-md">
          <SeatDeck title={null} seats={floor1Seats.length > 0 ? floor1Seats : floor2Seats} selectedSeatCodes={selectedSeatCodes} onToggleSeat={onToggleSeat} />
        </div>
      )}
    </section>
  );
}
