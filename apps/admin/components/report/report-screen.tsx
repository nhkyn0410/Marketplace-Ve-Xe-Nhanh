"use client";

import { keepPreviousData, useMutation, useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ChartColumn, CircleAlert, Download, LoaderCircle, RefreshCw } from "lucide-react";
import { useState, type ReactNode } from "react";

import { formatVnd, PROVIDER_LABEL } from "../../lib/payment/payment-format";
import { downloadAdminReportCsv, getAdminReport, type AdminReport } from "../../lib/report/report-api";
import { countLabel, lastDays, percentLabel, validRange } from "../../lib/report/report-format";
import { PageHeader } from "../page-header";
import { ReportFilters, toParams, type ReportFilterState } from "./report-filters";

/**
 * Báo cáo toàn hệ thống (Figma ADM-14a; TASK-RPT-002, FR-NSR-13, FR-ADM-17, UC-29): giá trị giao dịch, doanh thu sau hoàn (tạm
 * tính khi còn giao dịch cần đối soát), lấp đầy, chuyến bị nhà xe hủy, bảng theo nhà xe, phương thức thanh toán; xuất CSV (có
 * nhật ký audit). Chưa có: lọc tuyến / khu vực, cột đánh giá, thẻ khiếu nại, hàng đợi xuất nền — xem `RPT-todo.md`.
 */
export function ReportScreen() {
  const [filters, setFilters] = useState<ReportFilterState>({ ...lastDays(7), operatorId: ALL, provider: ALL });
  const ok = validRange(filters.from, filters.to);
  const params = toParams(filters);
  const report = useQuery({ queryKey: ["admin-report", params], queryFn: () => getAdminReport(params), enabled: ok, placeholderData: keepPreviousData });
  const exporter = useMutation({ mutationFn: () => downloadAdminReportCsv(params) });
  const data = report.data;

  let body: ReactNode;
  if (!ok) {
    body = <ListStatePanel icon={<ChartColumn className="size-6 text-vxn-fg-3" />} title="Chọn khoảng thời gian" description="Ngày bắt đầu phải trước ngày kết thúc, tối đa 366 ngày." compact />;
  } else if (report.isError && !data) {
    body = (
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
    );
  } else {
    const totals = data?.totals;
    body = (
      <>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <Stat label="Giá trị giao dịch" value={totals && formatVnd(totals.gmv)} note={totals && `${countLabel(totals.bookings)} đơn · ${countLabel(totals.tickets)} vé`} />
          <Stat
            label="Doanh thu sau hoàn tiền"
            value={totals && formatVnd(totals.netRevenue)}
            note={totals && (totals.reconcileOpen > 0 ? `Tạm tính · còn ${countLabel(totals.reconcileOpen)} giao dịch đối soát` : "Đã trừ tiền hoàn trong kỳ")}
          />
          <Stat label="Tỷ lệ lấp đầy" value={totals && percentLabel(totals.ticketsSold, totals.seats)} note={totals && `${countLabel(totals.completedTrips)} chuyến đã chạy · ${countLabel(totals.trips)} chuyến`} />
          <Stat
            label="Chuyến bị nhà xe hủy"
            value={totals && percentLabel(totals.operatorCancelledTrips, totals.tripsWithSales)}
            note={totals && `${countLabel(totals.operatorCancelledTrips)} chuyến đã có vé`}
          />
        </div>
        <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_320px]">
          <Panel title="Theo nhà xe" description="Chuyến khởi hành trong kỳ; giá trị giao dịch và hoàn tiền theo thời điểm phát sinh.">
            {!data ? <TableSkeleton label="Đang tải số liệu theo nhà xe" rows={4} /> : <OperatorTable rows={data.byOperator} />}
          </Panel>
          <Panel title="Phương thức thanh toán">
            {!data ? <Skeleton className="h-16 w-full" /> : <Methods methods={data.paymentMethods} />}
          </Panel>
        </div>
      </>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Báo cáo"
        description="Số liệu toàn hệ thống. Số liệu đang đối soát được đánh dấu “tạm tính”."
        actions={
          <Button className={BUTTON} disabled={!ok || exporter.isPending} onClick={() => exporter.mutate()}>
            {exporter.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Download className="size-[18px]" />}
            Xuất báo cáo
          </Button>
        }
      />
      {exporter.isError && (
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          {exporter.error instanceof ApiError ? exporter.error.message : "Chưa xuất được báo cáo. Vui lòng thử lại."}
        </p>
      )}
      <ReportFilters value={filters} onChange={setFilters} />
      {body}
    </div>
  );
}

function OperatorTable({ rows }: { rows: AdminReport["byOperator"] }) {
  if (rows.length === 0) {
    return <ListStatePanel icon={<ChartColumn className="size-6 text-vxn-fg-3" />} title="Chưa có số liệu trong kỳ" description="Nhà xe có chuyến, giao dịch hoặc hoàn tiền trong kỳ hiện ở đây." compact />;
  }
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[640px]`}>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            <th scope="col" className={`${TABLE_HEAD_CELL} w-[30%]`}>
              Nhà xe
            </th>
            {[
              ["Chuyến", "w-[10%]"],
              ["Vé", "w-[10%]"],
              ["Lấp đầy", "w-[12%]"],
              ["Giá trị giao dịch", "w-[22%]"],
              ["Hoàn tiền", "w-[16%]"]
            ].map(([heading, width]) => (
              <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${width} text-right`}>
                {heading}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => (
            <tr key={row.operatorId} className="border-b last:border-b-0">
              <td className={`${TABLE_CELL} truncate font-semibold text-vxn-ink`}>{row.operatorName}</td>
              <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.trips)}</td>
              <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.ticketsSold)}</td>
              <td className={`${TABLE_CELL} text-right tabular-nums`}>{percentLabel(row.ticketsSold, row.seats)}</td>
              <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(row.gmv)}</td>
              <td className={`${TABLE_CELL} text-right tabular-nums`} title={formatVnd(row.refunded)}>
                {percentLabel(row.refunded, row.gmv)}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

function Methods({ methods }: { methods: AdminReport["paymentMethods"] }) {
  const total = methods.reduce((sum, method) => sum + method.amount, 0);
  if (total === 0) {
    return <p className="text-sm leading-5 text-muted-foreground">Chưa có thanh toán thành công trong kỳ.</p>;
  }
  return (
    <ul className="flex flex-col gap-3">
      {methods.map((method) => (
        <li key={method.provider} className="flex flex-col gap-1.5 text-sm leading-5">
          <div className="flex items-center justify-between gap-3">
            <span className="font-medium text-vxn-ink">{PROVIDER_LABEL[method.provider]}</span>
            <span className="text-muted-foreground tabular-nums">{percentLabel(method.amount, total)}</span>
          </div>
          <div className="h-2 rounded-full bg-muted" aria-hidden>
            <div className="h-2 rounded-full bg-primary" style={{ width: `${(method.amount / total) * 100}%` }} />
          </div>
          <span className="text-xs leading-[18px] text-muted-foreground">
            {formatVnd(method.amount)} · {countLabel(method.count)} giao dịch
          </span>
        </li>
      ))}
    </ul>
  );
}

function Stat({ label, value, note }: { label: string; value: string | undefined; note: string | undefined }) {
  return (
    <div className="flex flex-col gap-2 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === undefined ? <Skeleton className="h-[38px] w-40" /> : <p className="text-[30px] leading-[38px] font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note ?? " "}</p>
    </div>
  );
}

function Panel({ title, description, children }: { title: string; description?: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6">
      <div className="flex flex-col gap-1">
        <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
        {description && <p className="text-sm leading-5 text-muted-foreground">{description}</p>}
      </div>
      {children}
    </section>
  );
}
