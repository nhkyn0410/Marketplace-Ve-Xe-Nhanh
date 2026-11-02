"use client";

import { useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowLeft, CircleAlert, FileX2, LockKeyhole, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { getAuditLog, type AuditLogItem } from "../../lib/audit/audit-api";
import {
  actionLabel,
  actorLines,
  diffRows,
  formatAuditDateTime,
  formatAuditTime,
  MODULE_LABELS,
  targetLabel
} from "../../lib/audit/audit-format";

/**
 * Chi tiết một bản ghi audit (Figma ADM-15b; UC-30 bước 4–6): trước / sau (đã che ở server), lý do, chuỗi bản ghi
 * cùng đối tượng, tóm tắt người thực hiện / IP / thiết bị. Mỗi lượt mở trang được ghi audit ở server.
 */
export function AuditLogDetail({ logId }: { logId: string }) {
  // Mỗi lần mở là một lượt xem được ghi nhật ký — không dùng lại bản cũ trong bộ nhớ đệm.
  const detail = useQuery({ queryKey: ["admin-audit-log", logId], queryFn: () => getAuditLog(logId), gcTime: 0, staleTime: 0 });

  if (detail.isPending) {
    return (
      <div role="status" aria-label="Đang tải bản ghi" className="flex flex-col gap-6">
        <BackLink />
        <div className="h-10 w-2/3 animate-pulse rounded bg-muted" />
        <div className="h-72 animate-pulse rounded-xl bg-muted" />
      </div>
    );
  }
  if (detail.isError) {
    const missing = detail.error instanceof ApiError && detail.error.status === 404;
    return (
      <div className="flex flex-col gap-6">
        <BackLink />
        <section className="rounded-xl border bg-card">
          <ListStatePanel
            icon={missing ? <FileX2 className="size-6 text-vxn-fg-3" /> : <CircleAlert className="size-6 text-warning-700" />}
            title={missing ? "Không tìm thấy bản ghi" : "Không tải được bản ghi"}
            description={missing ? "Mã bản ghi không đúng." : "Kho nhật ký chưa phản hồi hoặc mất kết nối. Thử lại sau ít phút."}
            action={
              missing ? undefined : (
                <Button className={`${BUTTON} w-36`} onClick={() => void detail.refetch()}>
                  <RefreshCw className="size-[18px]" />
                  Thử lại
                </Button>
              )
            }
          />
        </section>
      </div>
    );
  }

  const log = detail.data;
  const actor = actorLines(log);
  const rows = diffRows(log.before, log.after);
  return (
    <div className="flex flex-col gap-6">
      <BackLink />
      <header className="flex flex-wrap items-start gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-[1_1_18rem] flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{actionLabel(log.action)}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {formatAuditDateTime(log.createdAt)} · {actor.name}
          </p>
        </div>
        <Badge tone={log.result === "SUCCESS" ? "success" : "danger"}>{log.result === "SUCCESS" ? "Thành công" : "Thất bại"}</Badge>
      </header>

      <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_360px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Trước và sau" description="Giá trị nhạy cảm đã được che.">
            {rows.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Bản ghi này không lưu dữ liệu trước / sau.</p>
            ) : (
              <div className="relative overflow-x-auto">
                <table className={`${TABLE} min-w-[560px]`}>
                  <colgroup>
                    <col className="w-[30%]" />
                    <col className="w-[35%]" />
                    <col className="w-[35%]" />
                  </colgroup>
                  <thead>
                    <tr className={TABLE_HEAD_ROW}>
                      <th scope="col" className={TABLE_HEAD_CELL}>
                        Trường
                      </th>
                      <th scope="col" className={TABLE_HEAD_CELL}>
                        Trước
                      </th>
                      <th scope="col" className={TABLE_HEAD_CELL}>
                        Sau
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    {rows.map((row) => (
                      <tr key={row.field} className="border-b">
                        <td className={`${TABLE_CELL} font-mono text-xs font-semibold text-vxn-ink`}>{row.field}</td>
                        <td className={`${TABLE_CELL} break-words`}>{row.before}</td>
                        <td className={`${TABLE_CELL} break-words ${row.changed ? "font-semibold text-vxn-ink" : ""}`}>{row.after}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </Card>
          {log.reason && (
            <Card title="Lý do và ghi chú">
              <p className="text-sm leading-6 whitespace-pre-wrap text-vxn-fg-1">{log.reason}</p>
            </Card>
          )}
          <Card title="Chuỗi bản ghi liên quan" description={`Các bản ghi của cùng ${targetLabel(log.targetType).toLowerCase()} này.`}>
            <ol className="flex flex-col">
              {log.related.map((item, index) => (
                <ChainItem key={item.id} item={item} current={item.id === log.id} last={index === log.related.length - 1} />
              ))}
            </ol>
          </Card>
        </div>

        <div className="flex flex-col gap-4">
          <Card title="Tóm tắt">
            <dl className="flex flex-col gap-3 text-sm leading-5">
              <Row label="Người thực hiện">{actor.name}</Row>
              <Row label="Vai trò">{actor.role}</Row>
              <Row label="Phân hệ">{MODULE_LABELS[log.module]}</Row>
              <Row label="Hành động">
                <span className="font-mono text-xs">{log.action}</span>
              </Row>
              <Row label="Đối tượng">{targetLabel(log.targetType)}</Row>
              <Row label="Mã đối tượng">
                <span className="font-mono text-xs break-all">{log.targetId}</span>
              </Row>
              <Row label="Nhà xe">{log.operator?.name ?? "—"}</Row>
              <div className="border-t" />
              <Row label="Địa chỉ IP">{log.ip ?? "—"}</Row>
              <Row label="Thiết bị">{log.device ?? "—"}</Row>
              <Row label="Mã yêu cầu">
                <span className="font-mono text-xs break-all">{log.requestId ?? "—"}</span>
              </Row>
            </dl>
          </Card>
          <div className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <LockKeyhole className="mt-px size-4 shrink-0" />
            <p>Lượt xem chi tiết này đã được ghi vào nhật ký audit.</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function BackLink() {
  return (
    <Link
      href="/audit-logs"
      className="inline-flex w-fit items-center gap-2 rounded text-sm font-medium text-primary outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
    >
      <ArrowLeft className="size-4" />
      Quay lại nhật ký audit
    </Link>
  );
}

function Card({ title, description, children }: { title: string; description?: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <div className="flex flex-col gap-1">
        <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
        {description && <p className="text-xs leading-[18px] text-muted-foreground">{description}</p>}
      </div>
      {children}
    </section>
  );
}

function Row({ label, children }: { label: string; children: ReactNode }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="shrink-0 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 text-right text-vxn-ink">{children}</dd>
    </div>
  );
}

function ChainItem({ item, current, last }: { item: AuditLogItem; current: boolean; last: boolean }) {
  const actor = actorLines(item);
  const label = actionLabel(item.action);
  return (
    <li className="relative flex gap-3 pb-4 last:pb-0">
      {!last && <span aria-hidden className="absolute top-4 left-[5px] h-full w-px bg-border" />}
      <span
        aria-hidden
        className={`relative mt-1.5 size-[11px] shrink-0 rounded-full ${
          item.result === "FAILURE" ? "bg-error-600" : current ? "bg-success-600" : "bg-primary"
        }`}
      />
      <div className="flex min-w-0 flex-1 flex-wrap items-baseline justify-between gap-x-4 gap-y-0.5">
        <div className="flex min-w-0 flex-col">
          {current ? (
            <span className="text-sm leading-5 font-semibold text-vxn-ink">{label}</span>
          ) : (
            <Link
              href={`/audit-logs/${item.id}`}
              className="text-sm leading-5 font-semibold text-vxn-ink outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
            >
              {label}
            </Link>
          )}
          <span className="text-xs leading-[18px] text-muted-foreground">
            {actor.name}
            {current ? " · bản ghi đang xem" : ""}
          </span>
        </div>
        <span className="text-xs leading-[18px] whitespace-nowrap text-muted-foreground">{formatAuditTime(item.createdAt)}</span>
      </div>
    </li>
  );
}
