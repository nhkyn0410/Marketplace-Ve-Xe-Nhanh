"use client";

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
}

/**
 * Khối chọn điểm đón và trả theo Figma 1443:12719.
 */
export function SeatPointSelector({
  pickupPoints,
  dropoffPoints,
  selectedPickupId,
  selectedDropoffId,
  onSelectPickup,
  onSelectDropoff
}: SeatPointSelectorProps) {
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
        {/* Cột Điểm đón */}
        <div>
          <h4 className="text-xs font-bold uppercase tracking-wider text-vxn-fg-3">
            Điểm đón
          </h4>
          <div className="mt-3 space-y-2.5">
            {pickupPoints.map((point) => {
              const isSelected = point.id === selectedPickupId;

              return (
                <div
                  key={point.id}
                  onClick={() => onSelectPickup?.(point.id)}
                  className={`flex cursor-pointer items-start gap-3 rounded-xl p-3.5 transition ${
                    isSelected
                      ? "border-2 border-vxn-teal-800 bg-teal-50/15 shadow-2xs"
                      : "border border-vxn-border bg-white hover:border-neutral-300 hover:bg-neutral-50/50"
                  }`}
                  role="radio"
                  aria-checked={isSelected}
                  tabIndex={0}
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
                      <span className="text-xs sm:text-sm font-bold text-vxn-ink">
                        {point.name}
                      </span>
                      <span className="text-xs font-bold text-vxn-teal-900 shrink-0">
                        {point.time}
                      </span>
                    </div>
                    <p className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">
                      {point.address}
                    </p>
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
            })}
          </div>
        </div>

        {/* Cột Điểm trả */}
        <div>
          <h4 className="text-xs font-bold uppercase tracking-wider text-vxn-fg-3">
            Điểm trả
          </h4>
          <div className="mt-3 space-y-2.5">
            {dropoffPoints.map((point) => {
              const isSelected = point.id === selectedDropoffId;

              return (
                <div
                  key={point.id}
                  onClick={() => onSelectDropoff?.(point.id)}
                  className={`flex cursor-pointer items-start gap-3 rounded-xl p-3.5 transition ${
                    isSelected
                      ? "border-2 border-vxn-teal-800 bg-teal-50/15 shadow-2xs"
                      : "border border-vxn-border bg-white hover:border-neutral-300 hover:bg-neutral-50/50"
                  }`}
                  role="radio"
                  aria-checked={isSelected}
                  tabIndex={0}
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
                      <span className="text-xs sm:text-sm font-bold text-vxn-ink">
                        {point.name}
                      </span>
                      <span className="text-xs font-bold text-vxn-teal-900 shrink-0">
                        {point.time}
                      </span>
                    </div>
                    <p className="mt-0.5 text-xs text-vxn-fg-4 line-clamp-1">
                      {point.address}
                    </p>
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
            })}
          </div>
        </div>
      </div>
    </section>
  );
}
