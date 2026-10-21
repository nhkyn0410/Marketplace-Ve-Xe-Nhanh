"use client";

import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL } from "@vexenhanh/ui/components/list-controls";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowUpRight, ChevronRight, Download } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { listAuditLogs } from "../../lib/audit/audit-api";
import { actionLabel, actorLines, formatAuditTime, targetLabel } from "../../lib/audit/audit-format";
import { listApplications } from "../../lib/operator-application/application-api";
import { formatVnd } from "../../lib/payment/payment-format";
import { getAdminOverview, type AdminOverview } from "../../lib/report/report-api";
import { compareLabel, countLabel, dailyBars, lastDays, percentLabel, rangeDays, validRange } from "../../lib/report/report-format";
import { listProposals } from "../../lib/stop-point/stop-point-api";
import { listDisputes, listTickets } from "../../lib/support/support-api";
import { getIntegrations, INTEGRATION_STATUS } from "../../lib/system/system-format";
import { listOperators } from "../../lib/user/user-api";
import { formatDateTime } from "../../lib/user/user-format";
import { PageHeader } from "../page-header";
import { ReportFilters, toParams, type ReportFilterState } from "../report/report-filters";

const CARD = "flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6";

/**
 * Số của một hàng đợi; `null` khi đang tải / lỗi. Hồ sơ đăng ký chưa có `total` nên đếm tối đa một trang (20+). Chỉ gọi API
 * tài khoản có quyền (TASK-IAM-007) — khối không có quyền bị ẩn, không phải lỗi 403.
 */
function useCounts(can: (...permissions: string[]) => boolean) {
  const applications = useQuery({
    queryKey: ["admin-overview", "applications"],
    queryFn: async () => {
      const page = await listApplications({ status: "SUBMITTED" }, null);
      return { count: page.items.length, more: page.nextCursor !== null };
    },
    enabled: can("kyc:review")
  });
  const proposals = useQuery({ queryKey: ["admin-overview", "proposals"], queryFn: () => listProposals({ status: "PENDING" }, null), enabled: can("catalog:manage") });
  const users = can("user:manage");
  const bankChanges = useQuery({ queryKey: ["admin-overview", "bank"], queryFn: () => listOperators({ bankChange: "PENDING" }, null), enabled: users });
  const operators = useQuery({ queryKey: ["admin-overview", "operators"], queryFn: () => listOperators({}, null), enabled: users });
  const active = useQuery({ queryKey: ["admin-overview", "operators-active"], queryFn: () => listOperators({ status: "ACTIVE" }, null), enabled: users });
  const integrations = useQuery({ queryKey: ["admin-system", "integrations"], queryFn: getIntegrations, enabled: can("system:read") });
  const audit = useQuery({ queryKey: ["admin-overview", "audit"], queryFn: () => listAuditLogs({ actorType: "PLATFORM" }, null), retry: false, enabled: can("audit:read") });
  const support = can("support:manage");
  const disputes = useQuery({ queryKey: ["admin-disputes", "count"], queryFn: () => listDisputes({ status: "open" }), enabled: support });
  const tickets = useQuery({ queryKey: ["admin-tickets", "count"], queryFn: () => listTickets({ status: "NEW" }), enabled: support });
  return { applications, proposals, bankChanges, operators, active, integrations, audit, disputes, tickets };
}

/**
 * Tổng quan nền tảng (Figma ADM-01; TASK-RPT-002): giá trị giao dịch so với kỳ trước, đơn, vé, nhà xe hoạt động; việc cần xử lý;
 * tiền đang giữ (escrow); giá trị giao dịch theo ngày; trạng thái tích hợp; thao tác gần đây của tài khoản nền tảng (nhật ký
 * audit); khiếu nại chưa phân loại + tranh chấp đang mở (TASK-TRUST-001).
 */
export function OverviewScreen() {
  const can = useCan();
  const money = can("payment:monitor");
  const [filters, setFilters] = useState<ReportFilterState>({ ...lastDays(7), operatorId: ALL, provider: ALL });
  const ok = validRange(filters.from, filters.to);
  const params = toParams(filters);
  const overview = useQuery({
    queryKey: ["admin-overview", "numbers", params],
    queryFn: () => getAdminOverview(params),
    enabled: ok && money,
    placeholderData: keepPreviousData
  });
  const { applications, proposals, bankChanges, operators, active, integrations, audit, disputes, tickets } = useCounts(can);
  const data = overview.data;
  const days = ok ? rangeDays(filters.from, filters.to) : 0;
  const allQueue: { label: string; hint: string; href: string | null; value: string | null; permission: string }[] = [
    {
      permission: "kyc:review",
      label: "Hồ sơ nhà xe chờ duyệt",
      hint: "Hồ sơ đã gửi, chưa có quyết định",
      href: "/operators",
      value: applications.data ? `${applications.data.count}${applications.data.more ? "+" : ""}` : null
    },
    { permission: "payment:monitor", label: "Chi trả chờ rà soát", hint: "Kỳ chi trả đã tạo, chờ Admin duyệt", href: "/payouts", value: data ? String(data.queues.payoutsPendingReview) : null },
    { permission: "support:manage", label: "Tranh chấp đang mở", hint: "Chưa có quyết định của Vé Xe Nhanh", href: "/disputes?tab=disputes", value: disputes.data ? String(disputes.data.open) : null },
    { permission: "payment:monitor", label: "Hoàn tiền lỗi cần xử lý", hint: "Cổng thanh toán trả lỗi khi hoàn", href: "/payments?tab=refunds", value: data ? String(data.queues.refundsFailed) : null },
    { permission: "payment:monitor", label: "Thanh toán cần đối soát", hint: "Cổng đã trừ tiền nhưng đơn không nhận", href: "/payments?tab=reconcile", value: data ? String(data.queues.reconcileOpen) : null },
    { permission: "support:manage", label: "Khiếu nại chưa phân loại", hint: "Khách vừa gửi, chưa phân loại / phân công", href: "/disputes", value: tickets.data ? String(tickets.data.unclassified) : null },
    {
      permission: "catalog:manage",
      label: "Đề xuất điểm dừng chờ duyệt",
      hint: "Nhà xe đề xuất bến / điểm đón trả mới",
      href: "/stop-points?tab=proposals",
      value: proposals.data ? String(proposals.data.total) : null
    },
    {
      permission: "user:manage",
      label: "Yêu cầu đổi tài khoản nhận tiền",
      hint: "Chờ Admin xác minh trước khi dùng để chi trả",
      href: "/operators?tab=operators",
      value: bankChanges.data ? String(bankChanges.data.total) : null
    }
  ];
  const queue = allQueue.filter((item) => can(item.permission));

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Tổng quan nền tảng"
        description="Số liệu toàn hệ thống trong khoảng thời gian đã chọn."
        actions={
          money ? (
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/reports">
                <Download className="size-[18px]" />
                Xuất báo cáo
              </Link>
            </Button>
          ) : undefined
        }
      />
      {money && (
        <>
          <ReportFilters value={filters} onChange={setFilters} />
          {!ok && <p className="text-sm leading-5 text-error-600">Ngày bắt đầu phải trước ngày kết thúc, tối đa 366 ngày.</p>}
          {overview.isError && !data && ok && <p className="text-sm leading-5 text-error-600">Không tải được số liệu giao dịch. Vui lòng tải lại trang.</p>}
        </>
      )}
      {(money || can("user:manage")) && (
        <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
          {money && (
            <>
              <Stat label="Giá trị giao dịch" value={data ? formatVnd(data.gmv) : null} hint={data ? compareLabel(data.gmv, data.previousGmv, days) : ""} />
              <Stat
                label="Đơn đặt vé"
                value={data ? countLabel(data.bookings.total) : null}
                hint={data ? `${countLabel(data.bookings.confirmed)} đã thanh toán · ${countLabel(data.bookings.cancelledOrExpired)} hủy / hết hạn` : ""}
              />
              <Stat label="Vé đã phát hành" value={data ? countLabel(data.tickets.issued) : null} hint={data ? `Tỷ lệ hoàn tiền ${percentLabel(data.tickets.refunded, data.tickets.issued)}` : ""} />
            </>
          )}
          {can("user:manage") && (
            <Stat
              label="Nhà xe đang hoạt động"
              value={active.data && operators.data ? `${active.data.total} / ${operators.data.total}` : null}
              hint={operators.data && active.data ? `${operators.data.total - active.data.total} bị khóa` : ""}
            />
          )}
        </div>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <div className="flex min-w-0 flex-col gap-6">
          {queue.length > 0 && (
            <section aria-labelledby="overview-queue" className={CARD}>
              <div className="flex flex-col gap-1">
                <h2 id="overview-queue" className="text-lg leading-7 font-semibold text-vxn-ink">
                  Việc cần xử lý
                </h2>
                <p className="text-sm leading-5 text-muted-foreground">Các hàng đợi đang chờ Admin.</p>
              </div>
              <ul className="flex flex-col divide-y">
                {queue.map((item) => (
                  <QueueItem key={item.label} label={item.label} hint={item.hint} href={item.href} value={item.value} />
                ))}
              </ul>
            </section>
          )}
          {money && (
            <section aria-labelledby="overview-daily" className={CARD}>
              <div className="flex flex-col gap-1">
                <h2 id="overview-daily" className="text-lg leading-7 font-semibold text-vxn-ink">
                  Giá trị giao dịch theo ngày
                </h2>
                <p className="text-sm leading-5 text-muted-foreground">Thanh toán thành công · đơn vị: triệu đồng · tối đa 31 ngày cuối của khoảng.</p>
              </div>
              {data ? <DailyChart daily={data.daily} /> : <Skeleton className="h-48 w-full" />}
            </section>
          )}
        </div>
        <div className="flex min-w-0 flex-col gap-6">
          {money && (
            <section aria-labelledby="overview-escrow" className={CARD}>
              <div className="flex flex-col gap-1">
                <h2 id="overview-escrow" className="text-lg leading-7 font-semibold text-vxn-ink">
                  Tiền đang giữ (escrow)
                </h2>
                <p className="text-sm leading-5 text-muted-foreground">Tiền hành khách đã thanh toán, Platform giữ đến khi đủ điều kiện chi trả.</p>
              </div>
              {data ? <Escrow escrow={data.escrow} /> : <Skeleton className="h-40 w-full" />}
              <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
                <Link href="/payouts">
                  <ArrowUpRight className="size-[18px]" />
                  Xem chi trả nhà xe
                </Link>
              </Button>
            </section>
          )}
          {can("system:read") && (
            <section aria-labelledby="overview-integrations" className={CARD}>
              <div className="flex flex-col gap-1">
                <h2 id="overview-integrations" className="text-lg leading-7 font-semibold text-vxn-ink">
                  Trạng thái tích hợp
                </h2>
                {integrations.data && <p className="text-sm leading-5 text-muted-foreground">Kiểm tra lúc {formatDateTime(integrations.data.checkedAt)}</p>}
              </div>
              {integrations.data ? (
                <ul className="flex flex-col gap-3">
                  {integrations.data.items.map((item) => (
                    <li key={item.key} className="flex items-center justify-between gap-3 text-sm leading-5">
                      <span className="flex min-w-0 flex-col">
                        <span className="font-semibold text-vxn-ink">{item.name}</span>
                        <span className="truncate text-xs leading-[18px] text-muted-foreground">{item.category}</span>
                      </span>
                      <Badge tone={INTEGRATION_STATUS[item.status].tone}>{INTEGRATION_STATUS[item.status].label}</Badge>
                    </li>
                  ))}
                </ul>
              ) : (
                <Skeleton className="h-24 w-full" />
              )}
              <Link href="/system" className="inline-flex items-center gap-1 text-sm font-semibold text-primary hover:underline">
                Xem tích hợp & hệ thống
                <ChevronRight className="size-4" />
              </Link>
            </section>
          )}
        </div>
      </div>
      {can("audit:read") && !audit.isError && (
        <section aria-labelledby="overview-audit" className={CARD}>
          <div className="flex items-center justify-between gap-3">
            <div className="flex flex-col gap-1">
              <h2 id="overview-audit" className="text-lg leading-7 font-semibold text-vxn-ink">
                Thao tác gần đây của tài khoản nền tảng
              </h2>
              <p className="text-sm leading-5 text-muted-foreground">Trích từ nhật ký audit.</p>
            </div>
            <Link href="/audit-logs" className="inline-flex items-center gap-1 text-sm font-semibold text-primary hover:underline">
              <ArrowUpRight className="size-4" />
              Mở nhật ký audit
            </Link>
          </div>
          {audit.data ? <RecentAudit items={audit.data.items.slice(0, 5)} /> : <Skeleton className="h-32 w-full" />}
        </section>
      )}
    </div>
  );
}

function QueueItem({ label, hint, href, value }: { label: string; hint: string; href: string | null; value: string | null }) {
  const content = (
    <>
      <span className="flex min-w-0 flex-1 flex-col">
        <span className="font-semibold text-vxn-ink">{label}</span>
        <span className="text-xs leading-[18px] text-muted-foreground">{hint}</span>
      </span>
      {value === null ? <Skeleton className="h-6 w-10" /> : <span className={`text-lg font-semibold ${href && value !== "0" ? "text-vxn-ink" : "text-muted-foreground"}`}>{value}</span>}
      {href && <ChevronRight className="size-4 text-muted-foreground" />}
    </>
  );
  return (
    <li>
      {href ? (
        <Link href={href} className="flex items-center gap-3 py-3 text-sm hover:bg-muted/50">
          {content}
        </Link>
      ) : (
        <div className="flex items-center gap-3 py-3 text-sm">{content}</div>
      )}
    </li>
  );
}

function DailyChart({ daily }: { daily: AdminOverview["daily"] }) {
  const bars = dailyBars(daily);
  if (bars.every((bar) => bar.height === 0)) {
    return <p className="text-sm leading-5 text-muted-foreground">Chưa có thanh toán thành công trong khoảng này.</p>;
  }
  return (
    <div className="overflow-x-auto">
      <ol className="flex h-56 min-w-fit items-end gap-2" aria-label="Giá trị giao dịch theo ngày">
        {bars.map((bar, index) => (
          <li key={bar.date} className="flex h-full min-w-10 flex-1 flex-col items-center justify-end gap-1.5" aria-label={`${bar.label}: ${bar.value} triệu đồng`}>
            <span className="text-xs leading-[18px] text-muted-foreground tabular-nums">{bar.value}</span>
            <div className={`w-full rounded-t-md ${index === bars.length - 1 ? "bg-primary" : "bg-primary/70"}`} style={{ height: `${bar.height * 0.7}%` }} />
            <span className="text-xs leading-[18px] text-muted-foreground tabular-nums">{bar.label}</span>
          </li>
        ))}
      </ol>
    </div>
  );
}

function Escrow({ escrow }: { escrow: AdminOverview["escrow"] }) {
  const rows: { label: string; value: number; tone?: string }[] = [
    { label: "Đủ điều kiện chi trả", value: escrow.eligible, tone: "text-success-600" },
    { label: "Chưa đủ điều kiện chi trả", value: escrow.pending },
    { label: "Đang giữ do hoàn tiền", value: escrow.onHold, tone: "text-warning-700" }
  ];
  return (
    <div className="flex flex-col gap-3">
      <p className="text-[30px] leading-[38px] font-semibold text-vxn-ink tabular-nums">{formatVnd(escrow.held)}</p>
      <dl className="flex flex-col gap-2.5 text-sm leading-5">
        {rows.map((row) => (
          <Row key={row.label} label={row.label}>
            <span className={`font-semibold tabular-nums ${row.tone ?? "text-vxn-ink"}`}>{formatVnd(row.value)}</span>
          </Row>
        ))}
        <div className="my-1 border-t" />
        <Row label="Hoa hồng ghi nhận trong kỳ">
          <span className="font-semibold text-vxn-ink tabular-nums">{formatVnd(escrow.commissionInRange)}</span>
        </Row>
      </dl>
    </div>
  );
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-center justify-between gap-3">
      <dt className="text-muted-foreground">{label}</dt>
      <dd>{children}</dd>
    </div>
  );
}

function RecentAudit({ items }: { items: Awaited<ReturnType<typeof listAuditLogs>>["items"] }) {
  if (items.length === 0) {
    return <p className="text-sm leading-5 text-muted-foreground">Chưa có thao tác nào được ghi.</p>;
  }
  return (
    <ul className="flex flex-col divide-y">
      {items.map((item) => {
        const actor = actorLines(item);
        return (
          <li key={item.id} className="flex flex-wrap items-center gap-x-4 gap-y-1 py-3 text-sm leading-5">
            <span className="w-32 shrink-0 text-muted-foreground tabular-nums">{formatAuditTime(item.createdAt)}</span>
            <span className="w-40 min-w-0 shrink-0 truncate font-semibold text-vxn-ink">{actor.name}</span>
            <span className="min-w-0 flex-1 truncate">{actionLabel(item.action)}</span>
            <span className="min-w-0 truncate text-muted-foreground">{item.operator?.name ?? targetLabel(item.targetType)}</span>
            <Badge tone={item.result === "SUCCESS" ? "success" : "danger"}>{item.result === "SUCCESS" ? "Thành công" : "Bị từ chối"}</Badge>
          </li>
        );
      })}
    </ul>
  );
}

function Stat({ label, value, hint }: { label: string; value: string | null; hint: string }) {
  return (
    <div className="flex flex-col gap-2 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === null ? <Skeleton className="h-[38px] w-24" /> : <p className="text-[30px] leading-[38px] font-semibold text-vxn-ink tabular-nums">{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{hint}</p>
    </div>
  );
}
