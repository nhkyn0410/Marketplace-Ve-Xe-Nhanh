"use client";

import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, FilterSelect, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { CalendarClock, CircleAlert, Download, RefreshCw } from "lucide-react";
import { useId, useState } from "react";

import { getLoyaltyReport, type LoyaltyReport, type LoyaltyTier } from "../../lib/loyalty/loyalty-api";
import { formatPoints, monthLabel, quarterLabel, recentQuarters, reportCsv, TIER_LABEL, TIERS } from "../../lib/loyalty/loyalty-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { LoyaltyFrame } from "./loyalty-screen";

const COLUMNS = ["", "w-[16%]", "w-[15%]", "w-[15%]", "w-[15%]", "w-[19%]"];

/**
 * Báo cáo VXN Plus (Figma ADM-12d; FR-LOY-12): điểm phát hành / đổi / hết hạn theo tháng của quý (giờ VN), lọc theo hạng lúc ghi
 * giao dịch; voucher đã dùng + phần giảm Vé Xe Nhanh chịu = 0 tới khi có ví voucher (TASK-PROM-002). Xuất CSV số liệu tổng hợp.
 */
export function LoyaltyReportTab() {
  const quarters = recentQuarters(new Date(), 8);
  const [period, setPeriod] = useState(`${quarters[0]!.year}-${quarters[0]!.quarter}`);
  const [tier, setTier] = useState(ALL);
  const [year, quarter] = period.split("-").map(Number) as [number, number];
  const tierFilter = tier === ALL ? null : (tier as LoyaltyTier);
  const report = useQuery({
    queryKey: ["admin-loyalty-report", year, quarter, tierFilter],
    queryFn: () => getLoyaltyReport(year, quarter, tierFilter),
    placeholderData: keepPreviousData
  });
  const data = report.data;
  const periodId = useId();

  return (
    <LoyaltyFrame
      tab="report"
      actions={
        <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={!data || report.isPlaceholderData} onClick={() => data && download(data)}>
          <Download className="size-[18px]" />
          Xuất báo cáo
        </Button>
      }
    >
      {report.isError && !data ? (
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={<CircleAlert className="size-6 text-warning-700" />}
            title="Không tải được báo cáo"
            description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
            action={
              <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void report.refetch()}>
                <RefreshCw className="size-[18px]" />
                Thử lại
              </Button>
            }
          />
        </section>
      ) : (
        <>
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <Stat label="Điểm phát hành" value={data && formatPoints(data.totals.issued)} note={data && quarterLabel(data.year, data.quarter)} />
            <Stat label="Điểm đã đổi" value={data && formatPoints(data.totals.redeemed)} note={data && `${formatPoints(data.totals.vouchersRedeemed)} voucher`} />
            <Stat label="Điểm hết hạn" value={data && formatPoints(data.totals.expired)} note={data && "Theo hạn dùng điểm của chính sách"} />
            <Stat label="Giảm do Vé Xe Nhanh chịu" value={data && formatVnd(data.totals.platformDiscount)} note={data && `${formatPoints(data.totals.vouchersUsed)} voucher đã dùng`} accent />
          </div>
          <section aria-label="Báo cáo theo kỳ" className="flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6">
            <div className="flex flex-wrap items-end gap-4">
              <div className="flex w-52 flex-col gap-1.5">
                <label htmlFor={periodId} className="text-xs leading-[18px] font-medium text-muted-foreground">
                  Kỳ báo cáo
                </label>
                <Select value={period} onValueChange={setPeriod}>
                  <SelectTrigger id={periodId}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {quarters.map((item) => (
                      <SelectItem key={`${item.year}-${item.quarter}`} value={`${item.year}-${item.quarter}`}>
                        {quarterLabel(item.year, item.quarter)}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <FilterSelect label="Hạng thành viên" allLabel="Tất cả hạng" value={tier} onChange={setTier} options={TIERS.map((value) => ({ value, label: TIER_LABEL[value] }))} />
            </div>
            {!data ? (
              <TableSkeleton label="Đang tải báo cáo" rows={3} />
            ) : data.months.length === 0 ? (
              <ListStatePanel icon={<CalendarClock className="size-6 text-vxn-fg-3" />} title="Quý chưa bắt đầu" description="Chọn quý hiện tại hoặc một quý trước đó." compact />
            ) : (
              <div className="relative overflow-x-auto">
                <table className={`${TABLE} min-w-[760px]`}>
                  <colgroup>
                    {COLUMNS.map((width, index) => (
                      <col key={index} className={width} />
                    ))}
                  </colgroup>
                  <thead>
                    <tr className={TABLE_HEAD_ROW}>
                      <th scope="col" className={TABLE_HEAD_CELL}>
                        Kỳ
                      </th>
                      {["Điểm phát hành", "Điểm đã đổi", "Điểm hết hạn", "Voucher đã dùng", "Giảm do Vé Xe Nhanh chịu"].map((heading) => (
                        <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                          {heading}
                        </th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {data.months.map((month) => (
                      <tr key={month.month} className="h-12 border-b">
                        <th scope="row" className={`${TABLE_CELL} font-semibold text-vxn-ink`}>
                          {monthLabel(month.month)}
                        </th>
                        <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatPoints(month.issued)}</td>
                        <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatPoints(month.redeemed)}</td>
                        <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatPoints(month.expired)}</td>
                        <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatPoints(month.vouchersUsed)}</td>
                        <td className={`${TABLE_CELL} text-right font-semibold text-vxn-ink tabular-nums`}>{formatVnd(month.platformDiscount)}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
            {data && (
              <p className="text-xs leading-[18px] text-muted-foreground">
                {data.months.length} kỳ trong quý · Ví voucher đổi điểm chưa mở cho hành khách nên voucher đã dùng và phần giảm Vé Xe Nhanh chịu hiện là 0.
              </p>
            )}
          </section>
        </>
      )}
    </LoyaltyFrame>
  );
}

function download(report: LoyaltyReport) {
  const url = URL.createObjectURL(new Blob([reportCsv(report)], { type: "text/csv;charset=utf-8" }));
  const link = document.createElement("a");
  link.href = url;
  link.download = `vxn-plus-quy-${report.quarter}-${report.year}${report.tier ? `-${report.tier.toLowerCase()}` : ""}.csv`;
  link.click();
  URL.revokeObjectURL(url);
}

function Stat({ label, value, note, accent }: { label: string; value: string | undefined; note: string | undefined; accent?: boolean }) {
  return (
    <div className="flex flex-col gap-2 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === undefined ? (
        <Skeleton className="h-[38px] w-40" />
      ) : (
        <p className={`text-[30px] leading-[38px] font-semibold tabular-nums ${accent ? "text-warning-700" : "text-vxn-ink"}`}>{value}</p>
      )}
      <p className="text-xs leading-[18px] text-muted-foreground">{note ?? " "}</p>
    </div>
  );
}
