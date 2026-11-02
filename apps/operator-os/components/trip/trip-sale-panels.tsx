import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleAlert, CircleCheck, CircleDashed } from "lucide-react";

import type { Trip } from "../../lib/trip/trip-api";
import { seatCountLabel, TRIP_SEAT_STATUS } from "../../lib/trip/trip-format";
import {
  cutoffLabel,
  onlineSaleCloseLabel,
  onlineSaleCloseMs,
  readinessSummary,
  seatStatusCounts,
  type ReadinessItem,
  type ReadinessState
} from "../../lib/trip/trip-sale";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";

// Chữ cho trình đọc màn hình: màu và biểu tượng không phải cách duy nhất phân biệt ba trạng thái.
const READINESS_STATE: Record<ReadinessState, string> = { ok: "Đạt", fail: "Chưa đạt", unknown: "Chờ kiểm" };

function ReadinessIcon({ state }: { state: ReadinessState }) {
  if (state === "ok") {
    return <CircleCheck aria-hidden className="mt-px size-5 shrink-0 text-success-600" />;
  }
  if (state === "fail") {
    return <CircleAlert aria-hidden className="mt-px size-5 shrink-0 text-error-600" />;
  }
  return <CircleDashed aria-hidden className="mt-px size-5 shrink-0 text-vxn-fg-3" />;
}

/**
 * Khối "Điều kiện mở bán" (Figma "03 · Chi tiết chuyến nháp", BR-39). `checked` = đã có kết quả của lần bấm Mở
 * bán gần nhất; chưa có thì mục nào giao diện chưa tự biết ghi "Kiểm khi bấm Mở bán".
 */
export function ReadinessCard({ items, checked }: { items: ReadinessItem[]; checked: boolean }) {
  return (
    <section aria-labelledby="trip-readiness-heading" className={CARD}>
      <div className="flex flex-col gap-1">
        <h2 id="trip-readiness-heading" className={CARD_TITLE}>
          Điều kiện mở bán
        </h2>
        <p className={HELPER}>{readinessSummary(items, checked)}</p>
      </div>
      <ul aria-label="Các điều kiện mở bán" className="flex flex-col gap-5">
        {items.map((item) => (
          <li key={item.key} className="flex gap-3">
            <ReadinessIcon state={item.state} />
            <div className="flex min-w-0 flex-col gap-0.5">
              <p className="text-sm leading-5 font-medium text-vxn-ink">{item.label}</p>
              <p
                className={cn(
                  "text-xs leading-[18px]",
                  item.state === "fail" ? "text-error-600" : "text-muted-foreground"
                )}
              >
                <span className="sr-only">{READINESS_STATE[item.state]}: </span>
                {item.detail}
              </p>
            </div>
          </li>
        ))}
      </ul>
      <p className={HELPER}>
        Hệ thống kiểm lại toàn bộ mỗi lần bấm Mở bán. Dữ liệu gốc đổi sau khi đã mở bán thì chuyến không tự khóa.
      </p>
    </section>
  );
}

/** Thẻ "Tình trạng chỗ" (Figma "04 · Chi tiết chuyến đang mở bán"): số chỗ theo từng tình trạng. */
export function SeatSummaryCard({ seats }: { seats: Trip["seats"] }) {
  const counts = seatStatusCounts(seats);
  return (
    <section aria-labelledby="trip-seat-summary-heading" className={`${CARD} gap-3.5`}>
      <h2 id="trip-seat-summary-heading" className={CARD_TITLE}>
        Tình trạng chỗ
      </h2>
      <dl className="flex flex-col gap-3.5">
        <SummaryRow label={TRIP_SEAT_STATUS.AVAILABLE} value={seatCountLabel(counts.AVAILABLE)} />
        <SummaryRow label={TRIP_SEAT_STATUS.HOLDING} value={seatCountLabel(counts.HOLDING)} />
        <SummaryRow label={TRIP_SEAT_STATUS.BOOKED} value={seatCountLabel(counts.BOOKED)} />
        {/* "Đã lên xe" chỉ xuất hiện khi nhân viên bắt đầu đón khách. */}
        {counts.CHECKED_IN > 0 && (
          <SummaryRow label={TRIP_SEAT_STATUS.CHECKED_IN} value={seatCountLabel(counts.CHECKED_IN)} />
        )}
        <SummaryRow label={TRIP_SEAT_STATUS.BLOCKED} value={seatCountLabel(counts.BLOCKED)} />
        <SummaryRow label="Tổng" value={seatCountLabel(seats.length)} />
      </dl>
      <p className={HELPER}>
        Đếm từ sơ đồ ghế của chuyến. Chỗ đang giữ tự trả về còn trống nếu khách không thanh toán kịp.
      </p>
    </section>
  );
}

/** Thẻ "Bán online" của chuyến đang mở bán: mốc ngừng bán online (AS-20) và cài đặt của chuyến. */
export function OnlineSaleCard({
  trip,
  nowMs
}: {
  trip: Pick<Trip, "departureAt" | "onlineSaleCutoffMinutes">;
  nowMs: number;
}) {
  const closed = nowMs >= onlineSaleCloseMs(trip.departureAt, trip.onlineSaleCutoffMinutes);
  return (
    <section aria-labelledby="trip-online-sale-heading" className={`${CARD} gap-3.5`}>
      <h2 id="trip-online-sale-heading" className={CARD_TITLE}>
        Bán online
      </h2>
      <dl className="flex flex-col gap-3.5">
        <SummaryRow label="Ngừng bán lúc" value={onlineSaleCloseLabel(trip.departureAt, trip.onlineSaleCutoffMinutes)} />
        <SummaryRow label="Cài đặt" value={cutoffLabel(trip.onlineSaleCutoffMinutes)} />
      </dl>
      <p className={HELPER}>
        {closed
          ? "Đã qua mốc ngừng bán online nên khách không đặt online chuyến này được nữa."
          : "Chuyến đang bán online. Tạm dừng bán thì khách không đặt mới được; mở bán lại hệ thống kiểm lại điều kiện mở bán."}
      </p>
    </section>
  );
}

function SummaryRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start gap-3">
      <dt className="min-w-0 flex-1 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="text-right text-sm leading-5 font-semibold text-vxn-ink">{value}</dd>
    </div>
  );
}
