"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  ALL,
  FilterSelect,
  SearchField,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton,
  useDebouncedValue
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { CircleAlert, Lock, LockOpen, RefreshCw, Users } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import { listPassengers, lockPassenger, unlockPassenger, type AccountStatus, type Passenger } from "../../lib/user/user-api";
import { ACCOUNT_STATUS, formatDate, formatDateTime, PROVIDER_LABELS } from "../../lib/user/user-format";
import type { AccountAction } from "./account-dialogs";

const STATUSES: AccountStatus[] = ["ACTIVE", "LOCKED"];

/**
 * Tab "Hành khách" (Figma ADM-03a; FR-IAM-08): tìm email / họ tên, lọc trạng thái; khóa (lý do + TOTP) / mở khóa.
 * Hành khách không có mật khẩu — khóa chặn đăng nhập OTP / OAuth và thu hồi mọi phiên.
 */
export function PassengerList({ onAction }: { onAction: (action: AccountAction) => void }) {
  const [search, setSearch] = useState("");
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = useMemo(() => ({ q: q || undefined, status: status === ALL ? undefined : status }), [q, status]);
  const pages = useInfiniteQuery({
    queryKey: ["admin-passengers", filters],
    queryFn: ({ pageParam }) => listPassengers(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;

  function lock(passenger: Passenger) {
    onAction({
      title: "Khóa tài khoản hành khách",
      subtitle: `${passenger.name ?? "Chưa có họ tên"} · ${passenger.email}`,
      warning: "Hành khách không đăng nhập được nữa và mọi phiên đăng nhập bị thu hồi. Vé đã đặt giữ nguyên.",
      withReason: true,
      confirmLabel: "Khóa tài khoản",
      destructive: true,
      run: (reason) => lockPassenger(passenger.id, reason),
      done: `Đã khóa tài khoản ${passenger.email}.`
    });
  }

  function unlock(passenger: Passenger) {
    onAction({
      title: "Mở khóa tài khoản hành khách",
      subtitle: `${passenger.name ?? "Chưa có họ tên"} · ${passenger.email}`,
      note: "Hành khách đăng nhập lại được bằng email OTP hoặc tài khoản mạng xã hội đã liên kết.",
      withReason: false,
      confirmLabel: "Mở khóa",
      run: () => unlockPassenger(passenger.id),
      done: `Đã mở khóa tài khoản ${passenger.email}.`
    });
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = <ErrorPanel onRetry={() => void pages.refetch()} />;
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải hành khách" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<Users className="size-6 text-vxn-fg-3" />}
        title={q || status !== ALL ? "Không có hành khách phù hợp" : "Chưa có hành khách nào"}
        description="Hành khách tự đăng ký bằng email ở trang đặt vé."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[900px]`}>
          <colgroup>
            <col />
            <col className="w-[20%]" />
            <col className="w-[14%]" />
            <col className="w-[16%]" />
            <col className="w-[18%]" />
            <col className="w-[11%]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Hành khách", "Đăng nhập bằng", "Đăng ký", "Hoạt động gần nhất", "Trạng thái", ""].map((heading, index) => (
                <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                  {heading || <span className="sr-only">Thao tác</span>}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="h-[68px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className="truncate font-semibold text-vxn-ink">{row.name ?? "Chưa có họ tên"}</span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{row.email}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{row.providers.map((provider) => PROVIDER_LABELS[provider] ?? provider).join(", ")}</td>
                <td className={TABLE_CELL}>{formatDate(row.createdAt)}</td>
                <td className={TABLE_CELL}>{formatDateTime(row.lastLoginAt)}</td>
                <td className={TABLE_CELL}>
                  <StatusCell status={row.status} reason={row.lockedReason} since={row.lockedAt} />
                </td>
                <td className={TABLE_CELL}>
                  {row.status === "LOCKED" ? (
                    <Button variant="ghost" className="h-8 px-2 font-semibold" aria-label={`Mở khóa ${row.email}`} onClick={() => unlock(row)}>
                      Mở khóa
                      <LockOpen className="size-4" />
                    </Button>
                  ) : (
                    <Button variant="ghost" className="h-8 px-2 font-semibold" aria-label={`Khóa ${row.email}`} onClick={() => lock(row)}>
                      Khóa
                      <Lock className="size-4" />
                    </Button>
                  )}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} hành khách`}
        endText={`Đã hiện tất cả ${rows.length} hành khách`}
        errorText="Không tải thêm được hành khách. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <>
      <section aria-label="Danh sách hành khách" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField label="Tìm hành khách" placeholder="Email hoặc họ tên" value={search} onChange={setSearch} />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={STATUSES.map((value) => ({ value, label: ACCOUNT_STATUS[value].label }))}
            className="w-52"
          />
        </div>
        <div className="min-h-[320px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Lock className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Khóa hoặc mở khóa tài khoản bắt buộc lý do, thu hồi mọi phiên đăng nhập và được ghi nhật ký audit. Tài khoản hành khách
          không có mật khẩu.
        </p>
      </div>
    </>
  );
}

export function StatusCell({ status, reason, since }: { status: AccountStatus; reason: string | null; since: string | null }) {
  const label = ACCOUNT_STATUS[status];
  return (
    <div className="flex flex-col items-start gap-1">
      <Badge tone={label.tone}>{label.label}</Badge>
      {status === "LOCKED" && reason && (
        <span className="line-clamp-2 text-xs leading-[18px] text-muted-foreground">
          Từ {formatDate(since)} · {reason}
        </span>
      )}
    </div>
  );
}

export function ErrorPanel({ onRetry }: { onRetry: () => void }) {
  return (
    <ListStatePanel
      icon={<CircleAlert className="size-6 text-warning-700" />}
      title="Không tải được danh sách"
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
