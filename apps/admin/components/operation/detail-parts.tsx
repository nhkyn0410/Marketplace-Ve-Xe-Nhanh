"use client";

import type { UseQueryResult } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowLeft, CircleAlert, FileX2, RefreshCw, ShieldOff } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

/**
 * Khối dùng chung của các trang chi tiết giám sát (nhà xe, hành khách, tuyến, chuyến; tự thiết kế 28/10/2026, chờ duyệt):
 * khung có nút quay lại, thẻ, dòng nhãn – giá trị, thẻ số, trạng thái tải / lỗi / không tìm thấy / thiếu quyền.
 */
export function DetailShell({ back, children }: { back: { href: string; label: string }; children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link href={back.href} className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-primary hover:underline">
        <ArrowLeft className="size-[18px]" />
        {back.label}
      </Link>
      {children}
    </div>
  );
}

export function DetailHeader({ title, subtitle, badges, actions }: { title: string; subtitle?: ReactNode; badges?: ReactNode; actions?: ReactNode }) {
  return (
    <header className="flex flex-wrap items-start justify-between gap-4">
      <div className="flex min-w-0 flex-col gap-1.5">
        <div className="flex flex-wrap items-center gap-3">
          <h1 className="text-[30px] leading-[38px] font-semibold break-words text-vxn-ink">{title}</h1>
          {badges}
        </div>
        {subtitle && <p className="text-sm leading-5 text-muted-foreground">{subtitle}</p>}
      </div>
      {actions && <div className="flex flex-wrap items-center gap-3">{actions}</div>}
    </header>
  );
}

export function Card({ title, description, actions, children }: { title: string; description?: string; actions?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex min-w-0 flex-col gap-4 rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="flex min-w-0 flex-col gap-1">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
          {description && <p className="text-xs leading-[18px] text-muted-foreground">{description}</p>}
        </div>
        {actions}
      </div>
      {children}
    </section>
  );
}

export function Rows({ children }: { children: ReactNode }) {
  return <dl className="flex flex-col gap-3">{children}</dl>;
}

export function Row({ label, value }: { label: string; value: ReactNode }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="shrink-0 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 text-right text-sm leading-5 font-medium break-words text-vxn-fg-1 tabular-nums">{value}</dd>
    </div>
  );
}

/** Thẻ số; `value` null = đang tải. */
export function Stat({ label, value, note }: { label: string; value: ReactNode; note?: ReactNode }) {
  return (
    <div className="flex min-w-0 flex-col gap-1.5 rounded-xl border bg-card px-5 py-4">
      <span className="text-sm leading-5 text-muted-foreground">{label}</span>
      {value === null ? <Skeleton className="h-8 w-28" /> : <span className="text-2xl leading-8 font-semibold text-vxn-ink tabular-nums">{value}</span>}
      {note && <span className="text-xs leading-[18px] text-muted-foreground">{note}</span>}
    </div>
  );
}

export function StatePanel({ icon, title, description, action }: { icon: ReactNode; title: string; description: string; action?: ReactNode }) {
  return (
    <div className="flex min-h-[360px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action && <div className="mt-2">{action}</div>}
    </div>
  );
}

/** Không lặp lại khi 404 / 403 — kết quả không đổi khi thử lại. */
export const retryUnlessFinal = (count: number, error: Error) =>
  !(error instanceof ApiError && (error.status === 404 || error.status === 403)) && count < 2;

/**
 * Trạng thái chưa có dữ liệu của một trang chi tiết: không tìm thấy, thiếu quyền, lỗi tải (thử lại), đang tải. `null` =
 * đã có dữ liệu.
 */
export function detailState(query: UseQueryResult<unknown>, noun: string): ReactNode {
  if (query.error instanceof ApiError && query.error.status === 404) {
    return <StatePanel icon={<FileX2 className="size-6 text-vxn-fg-3" />} title={`Không tìm thấy ${noun}`} description={`${capitalize(noun)} không tồn tại hoặc đã bị xóa.`} />;
  }
  if (query.error instanceof ApiError && query.error.status === 403) {
    return (
      <StatePanel
        icon={<ShieldOff className="size-6 text-vxn-fg-3" />}
        title="Bạn chưa được cấp quyền xem mục này"
        description="Liên hệ quản trị viên có quyền phân quyền nếu công việc của bạn cần xem."
      />
    );
  }
  if (query.isError && query.data === undefined) {
    return (
      <StatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title={`Không tải được ${noun}`}
        description={query.error instanceof ApiError && query.error.status === 503 ? query.error.message : "Kiểm tra kết nối mạng rồi thử lại."}
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void query.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  }
  if (query.data === undefined) {
    return (
      <div role="status" aria-label={`Đang tải ${noun}`} className="flex flex-col gap-6">
        <Skeleton className="h-24 rounded-xl" />
        <Skeleton className="h-[420px] rounded-xl" />
      </div>
    );
  }
  return null;
}

function capitalize(text: string): string {
  return text.charAt(0).toUpperCase() + text.slice(1);
}
