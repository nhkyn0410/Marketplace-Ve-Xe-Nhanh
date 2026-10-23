"use client";

import { keepPreviousData, useMutation, useQuery } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ChartColumn, CircleAlert, Download, LoaderCircle, RefreshCw } from "lucide-react";
import { useId, useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { EMPLOYEE_ROLE } from "../../lib/employee/employee-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { downloadReportCsv, getOperatorReport, type ReportParams } from "../../lib/report/report-api";
import { cancelRate, countLabel, monthToDate, percentLabel, validRange } from "../../lib/report/report-format";
import { listAllRoutes } from "../../lib/route/route-api";
import type { TripStatus } from "../../lib/trip/trip-api";
import { TRIP_STATUS, TRIP_STATUS_ORDER } from "../../lib/trip/trip-format";
import { listAllVehicles } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { ALL, FilterSelect, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";

/**
 * Báo cáo (Figma "Nhà xe · Báo cáo / Tổng hợp" 1667:26847; TASK-RPT-001, FR-NSR-12, UC-17): doanh thu gộp, vé bán, lấp đầy, tỷ lệ
 * hủy, bảng theo tuyến và nhân viên theo chuyến được phân công, cho chuyến khởi hành trong khoảng ngày; xuất CSV (có nhật ký).
 * Thẻ đánh giá chỉ tính đánh giá công khai của chuyến trong bộ lọc; sự cố tính theo thời điểm nhân viên báo.
 */
export function ReportScreen() {
  const initial = monthToDate();
  const [from, setFrom] = useState(initial.from);
  const [to, setTo] = useState(initial.to);
  const [routeId, setRouteId] = useState(ALL);
  const [vehicleId, setVehicleId] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const ok = validRange(from, to);
  const params: ReportParams = {
    from,
    to,
    routeId: routeId === ALL ? undefined : routeId,
    vehicleId: vehicleId === ALL ? undefined : vehicleId,
    status: status === ALL ? undefined : (status as TripStatus)
  };
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });
  const report = useQuery({ queryKey: ["operator-report", params], queryFn: () => getOperatorReport(params), enabled: ok, placeholderData: keepPreviousData });
  const exporter = useMutation({ mutationFn: () => downloadReportCsv(params) });
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
    body = (
      <>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <Stat label="Doanh thu gộp" value={data && formatVnd(data.totals.grossRevenue)} note={data && `${countLabel(data.totals.completedTrips)} chuyến đã chạy · ${countLabel(data.totals.trips)} chuyến`} />
          <Stat label="Vé đã bán" value={data && countLabel(data.totals.ticketsSold)} note={data && `${countLabel(data.totals.bookings)} đơn đặt vé`} />
          <Stat label="Tỷ lệ lấp đầy" value={data && percentLabel(data.totals.ticketsSold, data.totals.seats)} note={data && `${countLabel(data.totals.ticketsSold)} / ${countLabel(data.totals.seats)} chỗ`} />
          <Stat
            label="Tỷ lệ hủy"
            value={data && cancelRate(data.totals)}
            note={data && `Hoàn tiền ${percentLabel(data.totals.refundedTickets, data.totals.ticketsSold + data.totals.cancelledTickets)} số vé`}
          />
        </div>
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          <Stat label="Đánh giá của hành khách" value={data && (data.totals.averageRating === null ? "—" : `${data.totals.averageRating.toFixed(1)} / 5`)} note={data && `${countLabel(data.totals.reviewCount)} đánh giá công khai`} />
        </div>
        <Panel title="Theo tuyến">
          {!data ? (
            <TableSkeleton label="Đang tải số liệu theo tuyến" rows={3} />
          ) : data.byRoute.length === 0 ? (
            <ListStatePanel icon={<ChartColumn className="size-6 text-vxn-fg-3" />} title="Chưa có chuyến trong khoảng này" description="Số liệu theo tuyến hiện ở đây cho các chuyến khởi hành trong khoảng ngày đã chọn." compact />
          ) : (
            <div className="overflow-x-auto">
              <table className={`${TABLE} min-w-[720px]`}>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    <th scope="col" className={`${TABLE_HEAD_CELL} w-[36%]`}>
                      Tuyến
                    </th>
                    {["Chuyến", "Vé bán", "Lấp đầy", "Doanh thu gộp"].map((heading) => (
                      <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                        {heading}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {data.byRoute.map((row) => (
                    <tr key={row.routeId} className="border-b last:border-b-0">
                      <td className={`${TABLE_CELL} truncate font-semibold text-vxn-ink`}>{row.routeName}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.trips)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.ticketsSold)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{percentLabel(row.ticketsSold, row.seats)}</td>
                      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(row.grossRevenue)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Panel>
        <Panel title="Nhân viên theo chuyến được phân công">
          {!data ? (
            <TableSkeleton label="Đang tải số liệu nhân viên" rows={3} />
          ) : data.employees.length === 0 ? (
            <ListStatePanel icon={<ChartColumn className="size-6 text-vxn-fg-3" />} title="Chưa có nhân viên" description="Tạo tài khoản nhân viên và phân công chuyến để theo dõi số liệu ở đây." compact />
          ) : (
            <div className="overflow-x-auto">
              <table className={`${TABLE} min-w-[760px]`}>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    <th scope="col" className={`${TABLE_HEAD_CELL} w-[30%]`}>
                      Nhân viên
                    </th>
                    <th scope="col" className={`${TABLE_HEAD_CELL} w-[20%]`}>
                      Vai trò
                    </th>
                    {["Chuyến được phân công", "Chuyến hoàn thành", "Vé đã soát", "Sự cố đã báo"].map((heading) => (
                      <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                        {heading}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {data.employees.map((row) => (
                    <tr key={row.employeeId} className="border-b last:border-b-0">
                      <td className={`${TABLE_CELL} truncate font-semibold text-vxn-ink`}>{row.loginName}</td>
                      <td className={TABLE_CELL}>{EMPLOYEE_ROLE[row.role].label}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.assignedTrips)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.completedTrips)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.ticketsChecked)}</td>
                      <td className={`${TABLE_CELL} text-right tabular-nums`}>{countLabel(row.incidentsReported)}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </Panel>
      </>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Báo cáo"
        description="Số liệu vận hành và doanh thu của nhà xe trong khoảng thời gian đã chọn."
        actions={
          <Button variant="outline" className={`${BUTTON} bg-card`} disabled={!ok || exporter.isPending} onClick={() => exporter.mutate()}>
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
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3">
        <DateField label="Khởi hành từ" value={from} onChange={setFrom} />
        <DateField label="Đến ngày" value={to} onChange={setTo} />
        <FilterSelect label="Tuyến" allLabel="Tất cả tuyến" value={routeId} onChange={setRouteId} options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))} />
        <FilterSelect
          label="Xe"
          allLabel="Tất cả xe"
          value={vehicleId}
          onChange={setVehicleId}
          options={(vehicles.data ?? []).map((vehicle) => ({ value: vehicle.id, label: formatPlateNumber(vehicle.plateNumber) }))}
        />
        <FilterSelect
          label="Trạng thái chuyến"
          allLabel="Tất cả"
          value={status}
          onChange={setStatus}
          options={TRIP_STATUS_ORDER.filter((value) => value !== "DRAFT").map((value) => ({ value, label: TRIP_STATUS[value].label }))}
        />
      </div>
      {body}
    </div>
  );
}

function Stat({ label, value, note }: { label: string; value: string | undefined; note: string | undefined }) {
  return (
    <div className="flex flex-col gap-1.5 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === undefined ? <Skeleton className="h-9 w-40" /> : <p className="text-[28px] leading-9 font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note ?? " "}</p>
    </div>
  );
}

function Panel({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col gap-5 rounded-xl border bg-card p-6">
      <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
      {children}
    </section>
  );
}

function DateField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-44 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        {label}
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}
