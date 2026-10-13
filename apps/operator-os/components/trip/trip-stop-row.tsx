import type { ReactNode } from "react";

import { formatDay, formatTime } from "../../lib/trip/trip-format";

/** Chữ thay cho giờ / ngày chưa tính được (chưa nhập đủ giờ đi và giờ đến). */
const UNKNOWN = "--:--";

/**
 * Một điểm dừng của chuyến kèm giờ dự kiến (Figma "VXN / Trip stop time row"): số thứ tự, tên, địa chỉ, dòng
 * mô tả loại điểm và quyền đón / trả; bên phải là ô giờ do nơi dùng truyền vào.
 */
export function TripStopRow({
  order,
  name,
  address,
  meta,
  children
}: {
  order: number;
  name: string;
  address: string;
  meta: string;
  children: ReactNode;
}) {
  return (
    <li className="flex items-center gap-3 rounded-lg border bg-card px-4 py-3">
      <span
        aria-hidden
        className="flex size-7 shrink-0 items-center justify-center rounded-full bg-accent text-sm leading-5 font-semibold text-vxn-teal-700"
      >
        {order}
      </span>
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <p className="truncate text-sm leading-5 font-semibold text-vxn-ink">
          <span className="sr-only">Điểm {order}: </span>
          {name}
        </p>
        <p className="truncate text-xs leading-[18px] text-muted-foreground">{address}</p>
        <p className="text-xs leading-[18px] font-medium text-vxn-teal-700">{meta}</p>
      </div>
      <div className="flex shrink-0 flex-col items-end gap-0.5">{children}</div>
    </li>
  );
}

function DayLine({ timeMs }: { timeMs: number | undefined }) {
  return (
    <span className="text-xs leading-[18px] text-muted-foreground">
      {timeMs === undefined ? "" : formatDay(new Date(timeMs).toISOString())}
    </span>
  );
}

/** Giờ chỉ đọc (trang chi tiết): giờ đậm, ngày ở dòng dưới. */
export function StopTimeText({ timeMs }: { timeMs: number }) {
  const iso = new Date(timeMs).toISOString();
  return (
    <>
      <span className="text-sm leading-5 font-semibold text-vxn-ink">{formatTime(iso)}</span>
      <DayLine timeMs={timeMs} />
    </>
  );
}

/** Ô giờ bị khóa trong form: điểm đầu / điểm cuối, hoặc mọi điểm khi đang "Tự chia". */
export function StopTimeLocked({ timeMs }: { timeMs: number | undefined }) {
  return (
    <>
      <span className="flex h-10 w-[104px] items-center justify-center rounded-lg border bg-muted px-3 text-sm leading-5 text-muted-foreground">
        {timeMs === undefined ? UNKNOWN : formatTime(new Date(timeMs).toISOString())}
      </span>
      <DayLine timeMs={timeMs} />
    </>
  );
}

/** Dòng ngày dưới ô nhập giờ của điểm ở giữa khi nhà xe tự nhập. */
export function StopTimeDay({ timeMs }: { timeMs: number | undefined }) {
  return <DayLine timeMs={timeMs} />;
}
