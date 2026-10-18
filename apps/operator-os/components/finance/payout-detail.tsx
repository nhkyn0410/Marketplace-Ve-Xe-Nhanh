"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, CircleAlert, FileX2, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { shortMoment } from "../../lib/booking/booking-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { getFinanceSummary, getPayout, type PayoutDetail } from "../../lib/finance/finance-api";
import { PAYOUT_STATUS, periodLabel, periodNote, rateLabel, signedVnd } from "../../lib/finance/finance-format";
import { formatTime } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON } from "../list-parts";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "../stop-point/list-controls";

/**
 * Chi tiết kỳ chi trả (Figma "Nhà xe · Tài chính / 03"; TASK-OPR-002): chuyến trong kỳ, cách tính, tài khoản nhận tiền
 * (số đã che), tiến trình. Nhà xe chỉ xem — Vé Xe Nhanh rà soát và chuyển khoản.
 */
export function PayoutDetailScreen({ payoutId }: { payoutId: string }) {
  const payout = useQuery({ queryKey: ["operator-payout", payoutId], queryFn: () => getPayout(payoutId), retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2 });
  const summary = useQuery({ queryKey: ["finance-summary"], queryFn: getFinanceSummary });
  if (payout.error instanceof ApiError && payout.error.status === 404) {
    return (
      <Shell>
        <Panel icon={<FileX2 className="size-6 text-vxn-fg-3" />} title="Không tìm thấy kỳ chi trả" description="Kỳ chi trả không tồn tại hoặc không thuộc nhà xe của bạn." />
      </Shell>
    );
  }
  if (payout.isError && !payout.data) {
    return (
      <Shell>
        <Panel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được kỳ chi trả"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void payout.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!payout.data) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải kỳ chi trả" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
          <Skeleton className="h-[420px] rounded-xl" />
          <Skeleton className="h-[420px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  return <DetailBody payout={payout.data} delay={summary.data?.payoutDelayDays ?? 3} />;
}

function DetailBody({ payout, delay }: { payout: PayoutDetail; delay: number }) {
  const status = PAYOUT_STATUS[payout.status];
  const bookings = payout.trips.reduce((sum, trip) => sum + trip.bookingCount, 0);
  return (
    <Shell>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-[32px] leading-10 font-semibold text-vxn-ink">Kỳ chi trả {periodLabel(payout.period)}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {periodNote(payout.period, delay)} · mã tham chiếu {payout.payoutCode}
          </p>
        </div>
        <Badge tone={status.tone}>{status.label}</Badge>
      </header>
      {payout.holdReason && payout.status === "ON_HOLD" && (
        <p role="note" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          Đang giữ lại: {payout.holdReason}
        </p>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
        <Card title="Chuyến trong kỳ" subtitle="Tiền vé từng chuyến sau hoa hồng và hoàn tiền.">
          <div className="overflow-x-auto">
            <table className={`${TABLE} min-w-[640px]`}>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  {["Chuyến", "Đơn", "Giá vé", "Hoa hồng", "Hoàn / điều chỉnh", "Thực nhận"].map((heading, index) => (
                    <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index >= 1 ? "text-right" : ""}`}>
                      {heading}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {payout.trips.map((trip) => (
                  <tr key={trip.tripId ?? "adjustment"} className="border-b last:border-b-0">
                    <td className={`${TABLE_CELL} min-w-[220px]`}>
                      <p className="font-medium">{trip.departureAt ? `${formatTime(trip.departureAt)} · ${trip.routeName}` : "Điều chỉnh"}</p>
                      <p className="text-xs leading-[18px] text-muted-foreground">
                        {trip.departureAt ? `${shortMoment(trip.departureAt).split(" · ")[1]} · ${trip.vehiclePlateNumber ? formatPlateNumber(trip.vehiclePlateNumber) : "Chưa gắn xe"}` : "Không gắn chuyến"}
                      </p>
                    </td>
                    <td className={`${TABLE_CELL} text-right tabular-nums`}>{trip.bookingCount}</td>
                    <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatVnd(trip.grossAmount)}</td>
                    <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(-trip.commissionAmount, formatVnd)}</td>
                    <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(trip.refundAdjustmentAmount, formatVnd)}</td>
                    <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(trip.amount)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="mt-4 text-xs leading-[18px] text-muted-foreground">
            {payout.trips.filter((trip) => trip.tripId).length} chuyến · {bookings} đơn
          </p>
        </Card>
        <div className="flex flex-col gap-6">
          <Card title="Cách tính">
            <dl className="flex flex-col gap-3">
              <Row label="Tổng đủ điều kiện" value={formatVnd(payout.grossAmount)} />
              <Row label={`Hoa hồng ${rateLabel(payout.commissionRateBps)}`.trim()} value={signedVnd(-payout.commissionAmount, formatVnd)} />
              <Row label="Hoàn tiền" value={signedVnd(-payout.refundAmount, formatVnd)} />
              <Row label="Điều chỉnh" value={signedVnd(payout.adjustmentAmount, formatVnd)} />
            </dl>
            <div className="mt-4 flex items-baseline justify-between gap-3 border-t pt-4">
              <span className="text-sm leading-5 font-semibold text-vxn-ink">Thực nhận</span>
              <span className="text-[26px] leading-8 font-semibold text-vxn-teal-700 tabular-nums">{formatVnd(payout.amount)}</span>
            </div>
          </Card>
          <Card title="Tài khoản nhận tiền" action={payout.checks.bankVerified ? <Badge tone="success">Đã xác minh</Badge> : <Badge tone="warning">Chờ xác minh</Badge>}>
            {payout.bank ? (
              <dl className="flex flex-col gap-3">
                <Row label="Ngân hàng" value={payout.bank.bankName} />
                <Row label="Số tài khoản" value={payout.bank.accountNumberMasked} />
                <Row label="Chủ tài khoản" value={payout.bank.accountHolder} />
              </dl>
            ) : (
              <p className="text-sm leading-5 text-muted-foreground">
                Chưa có tài khoản nhận tiền đã xác minh. Cập nhật ở mục{" "}
                <Link href="/profile" className="font-medium text-vxn-teal-700 hover:underline">
                  Hồ sơ &amp; KYC
                </Link>
                .
              </p>
            )}
          </Card>
          <Card title="Tiến trình">
            <ol className="flex flex-col">
              {[...payout.histories].reverse().map((history, index) => (
                <li key={index} className="flex gap-4 pb-4 last:pb-0">
                  <span className="mt-1.5 size-2.5 shrink-0 rounded-full bg-vxn-teal-600" aria-hidden />
                  <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                    <p className="text-sm leading-5 font-semibold text-vxn-ink">{history.fromStatus === null ? "Tạo kỳ chi trả" : PAYOUT_STATUS[history.toStatus].label}</p>
                    {(history.reason || history.actor) && (
                      <p className="text-sm leading-5 text-muted-foreground">{[history.actor, history.fromStatus === null ? null : history.reason].filter(Boolean).join(" · ")}</p>
                    )}
                  </div>
                  <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={history.createdAt}>
                    {shortMoment(history.createdAt).split(" · ").reverse().join(" · ")}
                  </time>
                </li>
              ))}
            </ol>
          </Card>
        </div>
      </div>
    </Shell>
  );
}

function Card({ title, subtitle, action, children }: { title: string; subtitle?: string; action?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col rounded-xl border bg-card p-6">
      <div className="mb-4 flex items-start justify-between gap-3">
        <div className="flex flex-col gap-0.5">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
          {subtitle && <p className="text-xs leading-[18px] text-muted-foreground">{subtitle}</p>}
        </div>
        {action}
      </div>
      {children}
    </section>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="text-right text-sm leading-5 font-medium text-vxn-fg-1 tabular-nums">{value}</dd>
    </div>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link href="/finance/payouts" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-vxn-teal-700 hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách kỳ chi trả
      </Link>
      {children}
    </div>
  );
}

function Panel({ icon, title, description, action }: { icon: ReactNode; title: string; description: string; action?: ReactNode }) {
  return (
    <div className="flex min-h-[420px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action && <div className="mt-2">{action}</div>}
    </div>
  );
}
