"use client";

import { useQuery } from "@tanstack/react-query";
import { useEffect, useRef } from "react";

import { getRoute } from "../../lib/route/route-api";
import { formatDistance } from "../../lib/route/route-format";

const VND = new Intl.NumberFormat("vi-VN");

/**
 * Ô "Mở bán theo chặng" của form chuyến / lịch lặp lại (giai đoạn 3.3, tự thiết kế 29/10/2026, chờ duyệt): tuyến con đang
 * bật của tuyến đã chọn. Khách đi trong đoạn của tuyến con trả giá tuyến con; chỗ ngồi vẫn tính cả chuyến. Tạo mới thì tích
 * sẵn mọi tuyến con đang bật mỗi khi đổi tuyến (`autoSelect`). Tuyến không có tuyến con đang bật → không hiện gì.
 */
export function SegmentOffersField({
  routeId,
  value,
  onChange,
  autoSelect,
  disabled = false
}: {
  routeId: string;
  value: string[];
  onChange: (next: string[]) => void;
  autoSelect: boolean;
  disabled?: boolean;
}) {
  const route = useQuery({ queryKey: ["route", routeId], queryFn: () => getRoute(routeId), enabled: routeId !== "" });
  // Tuyến con đang bật + tuyến con đã gắn sẵn (giữ được dù vừa bị ngừng, như máy chủ).
  const options = (route.data?.subRoutes ?? []).filter((sub) => sub.status === "ACTIVE" || value.includes(sub.id));
  const filledFor = useRef<string | null>(autoSelect ? null : routeId);

  useEffect(() => {
    if (!route.data || route.data.id !== routeId || filledFor.current === routeId) {
      return;
    }
    filledFor.current = routeId;
    onChange(route.data.subRoutes.filter((sub) => sub.status === "ACTIVE").map((sub) => sub.id));
  }, [route.data, routeId, onChange]);

  if (routeId === "" || options.length === 0) {
    return null;
  }
  return (
    <fieldset className="flex flex-col gap-2" disabled={disabled}>
      <legend className="text-sm leading-5 font-medium text-vxn-ink">Mở bán theo chặng</legend>
      <p className="text-xs leading-[18px] text-muted-foreground">
        Khách đi trong đoạn của tuyến con trả giá của tuyến con; ghế vẫn tính cho cả chuyến. Bỏ chọn để bán theo giá tuyến
        chính.
      </p>
      <ul className="flex flex-col divide-y rounded-lg border">
        {options.map((sub) => {
          const checked = value.includes(sub.id);
          return (
            <li key={sub.id}>
              <label className="flex items-start gap-3 px-3 py-2.5">
                <input
                  type="checkbox"
                  className="mt-0.5 size-4 shrink-0 accent-primary"
                  checked={checked}
                  onChange={(event) =>
                    onChange(event.target.checked ? [...value, sub.id] : value.filter((id) => id !== sub.id))
                  }
                />
                <span className="flex min-w-0 flex-1 flex-col gap-0.5">
                  <span className="text-sm leading-5 font-semibold text-vxn-ink">{sub.name}</span>
                  <span className="text-xs leading-[18px] text-muted-foreground">
                    {sub.from.name} → {sub.to.name} · {formatDistance(sub.totalDistanceMeters)}
                    {sub.fare?.minPrice !== null && sub.fare?.minPrice !== undefined ? ` · từ ${VND.format(sub.fare.minPrice)} ₫` : ""}
                    {sub.status !== "ACTIVE" ? " · đã ngừng" : ""}
                  </span>
                </span>
              </label>
            </li>
          );
        })}
      </ul>
    </fieldset>
  );
}
