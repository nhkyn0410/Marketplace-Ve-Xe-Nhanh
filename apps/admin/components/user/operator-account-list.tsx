"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, FilterSelect, SearchField, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { KeyRound, Users } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { listOperatorAccounts, type AccountStatus } from "../../lib/user/user-api";
import { ACCOUNT_STATUS, formatDateTime, OPERATOR_STATUS } from "../../lib/user/user-format";
import type { AccountAction } from "./account-dialogs";
import { operatorPasswordAction } from "./operator-account-actions";
import { ErrorPanel, StatusCell } from "./passenger-list";

const ROLES = [
  { value: "OPERATOR_OWNER", label: "Chủ nhà xe" },
  { value: "OPERATOR_MANAGER", label: "Quản lý nhà xe" }
];

/** Danh sách tài khoản chủ / quản lý nhà xe dùng chung ở Người dùng và chi tiết nhà xe. */
export function OperatorAccountList({ operatorId: fixedOperator, onAction }: { operatorId?: string; onAction: (action: AccountAction) => void }) {
  const [search, setSearch] = useState("");
  const [operatorId, setOperatorId] = useState(ALL);
  const [role, setRole] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = {
    q: q || undefined,
    operatorId: fixedOperator ?? (operatorId === ALL ? undefined : operatorId),
    role: role === ALL ? undefined : role,
    status: status === ALL ? undefined : status
  };
  const pages = useInfiniteQuery({
    queryKey: ["admin-operator-accounts", filters],
    queryFn: ({ pageParam }) => listOperatorAccounts(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const operators = pages.data?.pages[0]?.operators ?? [];
  let body: ReactNode;
  if (pages.isError && rows.length === 0) {
    body = <ErrorPanel onRetry={() => void pages.refetch()} />;
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải tài khoản nhà xe" />;
  } else if (rows.length === 0) {
    body = <ListStatePanel icon={<Users className="size-6 text-vxn-fg-3" />} title="Không có tài khoản phù hợp" description="Đổi bộ lọc hoặc từ khóa tìm kiếm." />;
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[1040px]`}>
          <colgroup>
            {["w-[22%]", "w-[15%]", "w-[12%]", "w-[13%]", "w-[18%]", "w-[15%]", "w-[5%]"].map((width, index) => <col key={index} className={width} />)}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Tài khoản", "Nhà xe", "Vai trò", "Xác thực hai lớp", "Trạng thái", "Đăng nhập gần nhất", "Thao tác"].map((heading) => <th key={heading} scope="col" className={TABLE_HEAD_CELL}>{heading}</th>)}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="h-[72px] border-b">
                <td className={TABLE_CELL}>
                  <span className="block truncate font-semibold text-vxn-ink" title={row.username}>{row.username}</span>
                  <span className="block truncate text-xs text-muted-foreground" title={row.email ?? undefined}>{row.email ?? "Chưa có email"}</span>
                  <span className="block text-xs text-muted-foreground">Tạo {formatDateTime(row.createdAt)}</span>
                </td>
                <td className={TABLE_CELL}>
                  <Link href={`/operators/${row.operatorId}?tab=accounts`} className="font-semibold hover:text-primary hover:underline">{row.operatorName}</Link>
                  {row.operatorStatus === "SUSPENDED" && <span className="mt-1 block text-xs text-warning-700">Nhà xe {OPERATOR_STATUS[row.operatorStatus].label.toLowerCase()}</span>}
                </td>
                <td className={TABLE_CELL}>{ROLES.find((role) => role.value === row.role)?.label}</td>
                <td className={TABLE_CELL}><Badge tone={row.mfaEnabled ? "success" : "warning"}>{row.mfaEnabled ? "Đang bật" : "Chưa thiết lập"}</Badge></td>
                <td className={TABLE_CELL}>
                  <StatusCell status={row.status} reason={null} since={null} />
                  {(row.credentialDeliveryPending || row.passwordChangeRequired) && (
                    <span className="mt-1 block text-xs text-muted-foreground">
                      {row.credentialDeliveryPending ? "Chưa gửi được mật khẩu tạm" : "Chờ đổi mật khẩu tạm"}
                      {row.temporaryPasswordExpiresAt && ` · Hạn ${formatDateTime(row.temporaryPasswordExpiresAt)}`}
                    </span>
                  )}
                </td>
                <td className={TABLE_CELL}>{formatDateTime(row.lastLoginAt)}</td>
                <td className={TABLE_CELL}>
                  <Button variant="ghost" size="icon" aria-label={`Cấp lại mật khẩu cho ${row.username}`} title={row.status !== "ACTIVE" ? "Tài khoản đang bị khóa hoặc vô hiệu hóa" : !row.email ? "Tài khoản chưa có email nhận mật khẩu" : "Cấp lại mật khẩu tạm"} disabled={row.status !== "ACTIVE" || !row.email} onClick={() => onAction(operatorPasswordAction(row))}>
                    <KeyRound className="size-4" />
                  </Button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }
  return (
    <>
      <section aria-label="Danh sách tài khoản nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField label="Tìm tài khoản nhà xe" placeholder="Tên đăng nhập, email hoặc nhà xe" value={search} onChange={setSearch} />
          {!fixedOperator && <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operatorId} onChange={setOperatorId} options={operators.map((operator) => ({ value: operator.id, label: operator.name }))} className="w-52" />}
          <FilterSelect label="Vai trò" allLabel="Tất cả vai trò" value={role} onChange={setRole} options={ROLES} className="w-48" />
          <FilterSelect label="Trạng thái" allLabel="Tất cả" value={status} onChange={setStatus} options={(Object.keys(ACCOUNT_STATUS) as AccountStatus[]).map((value) => ({ value, label: ACCOUNT_STATUS[value].label }))} className="w-44" />
        </div>
        <div className="min-h-[240px]">{body}</div>
        {rows.length > 0 && <div className="flex min-h-14 items-center pt-5"><ListLoadMoreFooter hasMore={pages.hasNextPage} loading={pages.isFetchingNextPage} failed={pages.isFetchNextPageError} loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} tài khoản`} endText={`Đã hiện tất cả ${rows.length} tài khoản`} errorText="Không tải thêm được tài khoản. Vui lòng thử lại." onLoadMore={() => void pages.fetchNextPage()} /></div>}
      </section>
      <p className="rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">Cấp lại mật khẩu yêu cầu lý do và xác nhận danh tính. Mật khẩu tạm gửi qua email, phải đổi khi đăng nhập; phiên cũ bị thu hồi. Mỗi tài khoản được cấp lại tối đa một lần mỗi giờ.</p>
    </>
  );
}
