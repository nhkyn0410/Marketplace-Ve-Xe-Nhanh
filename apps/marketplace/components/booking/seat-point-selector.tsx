"use client";

import { vnDayOffset } from "../../lib/format";
import { SeatLocationPoint } from "../../lib/data/types";

/**
 * Thuộc tính của component chọn điểm đón và điểm trả.
 */
export interface SeatPointSelectorProps {
  readonly pickupPoints: readonly SeatLocationPoint[];
  readonly dropoffPoints: readonly SeatLocationPoint[];
  readonly selectedPickupId: string;
  readonly selectedDropoffId: string;
  readonly onSelectPickup?: (id: string) => void;
  readonly onSelectDropoff?: (id: string) => void;
  /** Điểm trả không chọn được với điểm đón hiện tại (đứng trước / trùng điểm đón trên hành trình). */
  readonly isDropoffDisabled?: (id: string) => boolean;
}

/** Một lựa chọn điểm đón / trả; giờ kèm "+N ngày" khi điểm rơi vào ngày sau giờ khởi hành. */
function PointOption({
  point,
  departureAt,
  isSelected,
  disabled = false,
  onSelect
}: {
  readonly point: SeatLocationPoint;
  readonly departureAt?: string;
  readonly isSelected: boolean;
  readonly disabled?: boolean;
  readonly onSelect?: (id: string) => void;
}) {
  const dayOffset = vnDayOffset(departureAt, point.plannedAt);
  const select = () => {
    if (!disabled) onSelect?.(point.id);
  };

  return (
    <div
      onClick={select}
      onKeyDown={(event) => {
        if (event.key === "Enter" || event.key === " ") {
          event.preventDefault();
          select();
        }
      }}
      className={`flex items-start gap-3 rounded-xl p-3.5 transition ${
        disabled
          ? "cursor-not-allowed border border-dashed border-vxn-border bg-neutral-50/60 opacity-60"
          : isSelected
            ? "cursor-pointer border-2 border-vxn-teal-800 bg-teal-50/15 shadow-2xs"
            : "cursor-pointer border border-vxn-border bg-white hover:border-neutral-300 hover:bg-neutral-50/50"
      }`}
      role="radio"
      aria-checked={isSelected}
      aria-disabled={disabled || undefined}
      tabIndex={disabled ? -1 : 0}
    >
      <div className="mt-0.5 shrink-0">
        {isSelected ? (
          <div className="flex h-4 w-4 items-center justify-center rounded-full border-2 border-vxn-teal-800">
            <div className="h-2 w-2 rounded-full bg-vxn-teal-800" />
          </div>
        ) : (
          <div className="h-4 w-4 rounded-full border border-neutral-300" />
        )}
      </div>

      <div className="flex-1 min-w-0">
        <div className="flex items-start justify-between gap-2">
          <span className="text-xs sm:text-sm font-bold text-vxn-ink">{point.name}</span>
          <span className="text-right text-xs font-bold text-vxn-teal-900 shrink-0">
            {point.time}
            {dayOffset > 0 && <span className="block text-[10px] font-semibold text-vxn-fg-4">+{dayOffset} ngày</span>}
          </span>
        </div>
        <p className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">{point.address}</p>
        {disabled && <p className="mt-1 text-[11px] text-vxn-fg-4">Phải nằm sau điểm đón đã chọn</p>}
        {point.hasFreeShuttle && (
          <div className="mt-2">
            <span className="inline-block rounded-md bg-amber-50 px-2 py-0.5 text-[10px] font-semibold text-amber-800">
              Trung chuyển miễn phí
            </span>
          </div>
        )}
      </div>
    </div>
  );
}

/**
 * Khối chọn điểm đón và trả theo Figma 1443:12719. "+N ngày" tính so với điểm đón đầu tiên của chuyến (giờ khởi hành).
 */
export function SeatPointSelector({
  pickupPoints,
  dropoffPoints,
  selectedPickupId,
  selectedDropoffId,
  onSelectPickup,
  onSelectDropoff,
  isDropoffDisabled
}: SeatPointSelectorProps) {
  const departureAt = pickupPoints[0]?.plannedAt;

  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <div className="border-b border-vxn-border/50 pb-4">
        <h3 className="text-base font-bold text-vxn-ink sm:text-lg">
          Điểm đón và điểm trả
        </h3>
        <p className="mt-1 text-xs text-vxn-fg-4 leading-relaxed">
          Điểm đón phải đứng trước điểm trả trên hành trình. Văn phòng nhà xe có xe trung chuyển miễn phí ra bến.
        </p>
      </div>

      <div className="mt-5 grid grid-cols-1 gap-6 md:grid-cols-2">
        <div role="radiogroup" aria-labelledby="pickup-heading">
          <h4 id="pickup-heading" className="text-xs font-bold uppercase tracking-wider text-vxn-fg-3">
            Điểm đón
          </h4>
          <div className="mt-3 space-y-2.5">
            {pickupPoints.map((point) => (
              <PointOption
                key={point.id}
                point={point}
                departureAt={departureAt}
                isSelected={point.id === selectedPickupId}
                onSelect={onSelectPickup}
              />
            ))}
          </div>
        </div>

        <div role="radiogroup" aria-labelledby="dropoff-heading">
          <h4 id="dropoff-heading" className="text-xs font-bold uppercase tracking-wider text-vxn-fg-3">
            Điểm trả
          </h4>
          <div className="mt-3 space-y-2.5">
            {dropoffPoints.map((point) => (
              <PointOption
                key={point.id}
                point={point}
                departureAt={departureAt}
                isSelected={point.id === selectedDropoffId}
                disabled={isDropoffDisabled?.(point.id)}
                onSelect={onSelectDropoff}
              />
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}
