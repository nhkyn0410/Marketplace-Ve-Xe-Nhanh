"use client";

import { TripTimelineStop } from "../../../lib/data/types";



/**
 * Thuộc tính của khối lịch trình và điểm dừng.
 */
interface TripItineraryProps {
  readonly timeline: readonly TripTimelineStop[];
}

/**
 * Khối hiển thị dòng thời gian các điểm dừng đón/trả và dừng nghỉ (SCR-PSG-16).
 */
export function TripItinerary({ timeline }: TripItineraryProps) {
  return (
    <div className="bg-white rounded-2xl border border-neutral-200 p-6 shadow-xs space-y-4">
      <div>
        <h3 className="text-base font-semibold text-neutral-900">
          Lịch trình và điểm dừng
        </h3>
        <p className="text-xs text-neutral-500 mt-0.5">
          Chọn điểm đón và trả có nhãn tương ứng ở bước chọn ghế.
        </p>
      </div>

      <div className="pt-2">
        <div className="relative pl-6 space-y-6 before:absolute before:left-[11px] before:top-2 before:bottom-2 before:w-[2px] before:bg-neutral-200">
          {timeline.map((stop) => {

            const isRest = stop.isRestStop;
            return (
              <div key={`${stop.time}-${stop.stationName}`} className="relative group">
                {/* Dấu chấm timeline */}
                <div
                  className={`absolute -left-6 top-1 w-3 h-3 rounded-full border-2 bg-white transition-colors ${
                    isRest
                      ? "border-amber-400 bg-amber-50"
                      : "border-[#00506a] bg-white ring-2 ring-[#00506a]/20"
                  }`}
                />

                <div className="flex flex-col sm:flex-row sm:items-baseline justify-between gap-1">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-bold text-neutral-900 tracking-tight min-w-[50px]">
                      {stop.time}
                    </span>
                    <span className="text-sm font-semibold text-neutral-900">
                      {stop.stationName}
                    </span>
                  </div>

                  {/* Nhãn loại điểm và đón/trả */}
                  <div className="flex items-center gap-1.5 flex-wrap mt-1 sm:mt-0">
                    {stop.stationTypeLabel && !isRest && (
                      <span className="text-[11px] font-medium px-2 py-0.5 rounded bg-neutral-100 text-neutral-600 border border-neutral-200">
                        {stop.stationTypeLabel}
                      </span>
                    )}

                    {stop.badges?.map((badge) => {
                      const isPickup = badge.includes("Đón");
                      const isDrop = badge.includes("Trả");
                      const isTransit = badge.includes("Trung chuyển");

                      let colorClass = "bg-neutral-100 text-neutral-600 border-neutral-200";
                      if (isPickup) colorClass = "bg-blue-50 text-blue-700 border-blue-200";
                      else if (isDrop) colorClass = "bg-emerald-50 text-emerald-700 border-emerald-200";
                      else if (isTransit) colorClass = "bg-amber-50 text-amber-700 border-amber-200";

                      return (
                        <span
                          key={badge}
                          className={`text-[11px] font-medium px-2 py-0.5 rounded border ${colorClass}`}
                        >
                          {badge}
                        </span>
                      );
                    })}

                    {isRest && (
                      <span className="text-[11px] font-medium text-amber-700 bg-amber-50 px-2 py-0.5 rounded border border-amber-200">
                        {stop.restStopDurationText ?? "Dừng nghỉ"}
                      </span>
                    )}
                  </div>
                </div>

                <p className="text-xs text-neutral-500 mt-1 pl-[58px] sm:pl-0">
                  {stop.address}
                </p>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
