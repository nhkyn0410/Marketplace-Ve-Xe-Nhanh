"use client";

import { useQuery, type UseQueryResult } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TAB_TRIGGER, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import {
  Activity,
  Bell,
  CircleAlert,
  CreditCard,
  Database,
  HardDrive,
  Info,
  ListChecks,
  Mail,
  MapPin,
  MessageSquare,
  RefreshCw,
  Server,
  Wallet
} from "lucide-react";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import type { ReactNode } from "react";

import {
  type BackgroundJobs,
  getBackgroundJobs,
  getIntegrations,
  INTEGRATION_STATUS,
  type Integration,
  isOverdue,
  jobState,
  scheduleLabel,
  type SystemIntegrations
} from "../../lib/system/system-format";
import { formatDateTime } from "../../lib/user/user-format";
import { PageHeader } from "../page-header";

const ICONS: Record<string, ReactNode> = {
  postgres: <Database className="size-5" />,
  redis: <Server className="size-5" />,
  mongo: <Database className="size-5" />,
  queues: <ListChecks className="size-5" />,
  email: <Mail className="size-5" />,
  goong: <MapPin className="size-5" />,
  "storage-public": <HardDrive className="size-5" />,
  "storage-private": <HardDrive className="size-5" />,
  vnpay: <CreditCard className="size-5" />,
  momo: <Wallet className="size-5" />,
  push: <Bell className="size-5" />,
  sms: <MessageSquare className="size-5" />
};

/**
 * Màn Tích hợp & hệ thống (Figma ADM-16a / 16b) — CHỈ ĐỌC (Khanh 16/10/2026): trạng thái dịch vụ nền / bên ngoài và tác
 * vụ nền. Không có chế độ bảo trì, không chạy lại tác vụ ở phiên bản này.
 */
export function SystemScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === "jobs" ? "jobs" : "integrations";
  const integrations = useQuery({ queryKey: ["admin-system", "integrations"], queryFn: getIntegrations, enabled: tab === "integrations" });
  const jobs = useQuery({ queryKey: ["admin-system", "jobs"], queryFn: getBackgroundJobs, enabled: tab === "jobs" });
  const active = tab === "jobs" ? jobs : integrations;

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Tích hợp & hệ thống"
        description="Trạng thái vận hành của dịch vụ bên ngoài và các tác vụ chạy nền. Trang chỉ đọc."
        actions={
          <Button variant="outline" className={`${BUTTON} bg-card`} disabled={active.isFetching} onClick={() => void active.refetch()}>
            <RefreshCw className={`size-[18px] ${active.isFetching ? "animate-spin" : ""}`} />
            Kiểm tra lại
          </Button>
        }
      />
      <Tabs
        value={tab}
        onValueChange={(next) => router.replace(next === "jobs" ? `${pathname}?tab=jobs` : pathname, { scroll: false })}
        className="flex flex-col gap-6"
      >
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm thông tin">
          <TabsTrigger value="integrations" className={TAB_TRIGGER}>
            Tích hợp
          </TabsTrigger>
          <TabsTrigger value="jobs" className={TAB_TRIGGER}>
            Tác vụ nền
          </TabsTrigger>
        </TabsList>
        <TabsContent value="integrations" className="flex flex-col gap-6">
          <IntegrationsTab query={integrations} />
        </TabsContent>
        <TabsContent value="jobs" className="flex flex-col gap-6">
          <JobsTab query={jobs} />
        </TabsContent>
      </Tabs>
    </div>
  );
}

function LoadError({ onRetry }: { onRetry: () => void }) {
  return (
    <ListStatePanel
      compact
      icon={<CircleAlert className="size-6 text-warning-700" />}
      title="Không tải được trạng thái hệ thống"
      description="Kiểm tra kết nối mạng rồi thử lại."
      action={
        <Button className={`${BUTTON} w-36`} onClick={onRetry}>
          <RefreshCw className="size-[18px]" />
          Thử lại
        </Button>
      }
    />
  );
}

function IntegrationsTab({ query }: { query: UseQueryResult<SystemIntegrations> }) {
  if (!query.data) {
    return query.isError ? <LoadError onRetry={() => void query.refetch()} /> : <TableSkeleton label="Đang kiểm tra tích hợp" />;
  }
  const items = query.data.items.filter((item) => item.key !== "sms");
  const sms = query.data.items.find((item) => item.key === "sms");
  return (
    <>
      <div className="grid gap-4 md:grid-cols-2 xl:grid-cols-3">
        {items.map((item) => (
          <IntegrationCard key={item.key} item={item} checkedAt={query.data.checkedAt} />
        ))}
      </div>
      {sms && (
        <section aria-label={sms.name} className="flex items-center gap-4 rounded-xl border bg-muted/60 p-5">
          <span aria-hidden className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-card text-muted-foreground">
            {ICONS.sms}
          </span>
          <div className="flex min-w-0 flex-1 flex-col">
            <h2 className="text-base leading-6 font-semibold text-vxn-ink">{sms.name}</h2>
            <p className="text-sm leading-5 text-muted-foreground">{sms.detail}</p>
          </div>
          <span className="text-sm text-muted-foreground">{INTEGRATION_STATUS[sms.status].label}</span>
        </section>
      )}
      <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="mt-px size-5 shrink-0" />
        <p>
          Kiểm tra lúc {formatDateTime(query.data.checkedAt)} · môi trường {query.data.environment}. Cơ sở dữ liệu, Redis, hàng đợi và kho lưu trữ được
          gọi thử thật; email và bản đồ chỉ đọc cấu hình (không gửi / gọi thử). Chế độ bảo trì chưa có ở phiên bản này.
        </p>
      </div>
    </>
  );
}

function IntegrationCard({ item, checkedAt }: { item: Integration; checkedAt: string }) {
  const status = INTEGRATION_STATUS[item.status];
  return (
    <section aria-label={item.name} className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-5">
      <div className="flex items-start gap-3">
        <span aria-hidden className="flex size-10 shrink-0 items-center justify-center rounded-lg bg-accent text-accent-foreground">
          {ICONS[item.key] ?? <Activity className="size-5" />}
        </span>
        <div className="flex min-w-0 flex-1 flex-col">
          <h2 className="truncate text-base leading-6 font-semibold text-vxn-ink">{item.name}</h2>
          <p className="truncate text-xs leading-[18px] text-muted-foreground">{item.category}</p>
        </div>
        <Badge tone={status.tone}>{status.label}</Badge>
      </div>
      <dl className="flex flex-col gap-2 text-sm leading-5">
        <div className="flex justify-between gap-3">
          <dt className="text-muted-foreground">Kiểm tra gần nhất</dt>
          <dd className="font-semibold text-vxn-ink">{formatDateTime(checkedAt)}</dd>
        </div>
        <div className="flex justify-between gap-3">
          <dt className="text-muted-foreground">Thời gian phản hồi</dt>
          <dd className="font-semibold text-vxn-ink">{item.latencyMs === null ? "Không gọi thử" : `${item.latencyMs} ms`}</dd>
        </div>
      </dl>
      <p className="text-xs leading-[18px] text-muted-foreground">{item.detail}</p>
    </section>
  );
}

function JobsTab({ query }: { query: UseQueryResult<BackgroundJobs> }) {
  let body: ReactNode;
  if (!query.data) {
    body = query.isError ? <LoadError onRetry={() => void query.refetch()} /> : <TableSkeleton label="Đang tải tác vụ nền" />;
  } else if (!query.data.available) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không đọc được hàng đợi"
        description="Redis / BullMQ không phản hồi. Xem thẻ Redis và BullMQ ở tab Tích hợp."
      />
    );
  } else if (query.data.jobs.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<ListChecks className="size-6 text-vxn-fg-3" />}
        title="Chưa có tác vụ nào"
        description="Worker chưa chạy hoặc chưa đăng ký lịch tác vụ (ADR-024)."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[860px]`}>
          <colgroup>
            {["", "w-[16%]", "w-[11%]", "w-[8%]", "w-[24%]", "w-[16%]"].map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Tác vụ", "Lần chạy gần nhất", "Bản ghi xử lý", "Lỗi", "Trạng thái", "Lần chạy kế"].map((heading, index) => (
                <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index === 2 || index === 3 ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {query.data.jobs.map((job) => {
              const state = jobState(job);
              return (
                <tr key={`${job.queue}:${job.name}`} className="h-[68px] border-b">
                  <td className={TABLE_CELL}>
                    <span className="flex min-w-0 flex-col">
                      <span className="truncate font-semibold text-vxn-ink">{job.label}</span>
                      <span className="truncate text-xs leading-[18px] text-muted-foreground">{scheduleLabel(job.schedule)}</span>
                    </span>
                  </td>
                  <td className={TABLE_CELL}>{job.lastRun ? formatDateTime(job.lastRun.at) : "—"}</td>
                  <td className={`${TABLE_CELL} text-right`}>{job.lastRun?.processed?.toLocaleString("vi-VN") ?? "—"}</td>
                  <td className={`${TABLE_CELL} text-right ${job.failedCount > 0 ? "font-semibold text-error-600" : ""}`}>{job.failedCount}</td>
                  <td className={TABLE_CELL}>
                    <span className="flex min-w-0 flex-col items-start gap-1">
                      <Badge tone={state.tone}>{state.label}</Badge>
                      {state.note && <span className="line-clamp-2 text-xs leading-[18px] text-muted-foreground">{state.note}</span>}
                    </span>
                  </td>
                  <td className={TABLE_CELL}>
                    <span className="flex flex-col">
                      <span>{job.nextRunAt ? formatDateTime(job.nextRunAt) : "—"}</span>
                      {isOverdue(job.nextRunAt) && (
                        <span className="text-xs leading-[18px] font-semibold text-warning-700">Trễ lịch — kiểm tra worker</span>
                      )}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    );
  }
  return (
    <>
      <section aria-label="Tác vụ nền" className="flex min-w-0 flex-col gap-5 rounded-xl border bg-card p-6">
        {body}
        {query.data?.available && (
          <p className="text-sm leading-5 text-muted-foreground">
            Hàng đợi:{" "}
            {query.data.queues
              .map((queue) => `${queue.name} ${queue.waiting} chờ · ${queue.active} đang chạy · ${queue.failed} lỗi`)
              .join(" | ")}
          </p>
        )}
      </section>
      <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Activity className="mt-px size-5 shrink-0" />
        <p>
          Trang chỉ đọc. Tác vụ lỗi được thử lại tự động theo cấu hình hàng đợi; lần chạy thành công lưu 24 giờ, lần lỗi lưu 7 ngày. Các tác vụ đối soát,
          chi trả, thông báo, xuất báo cáo sẽ hiện ở đây khi các phần đó được xây.
        </p>
      </div>
    </>
  );
}
