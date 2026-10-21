"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
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
import { ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Eye, Users } from "lucide-react";
import { useMemo, useState, type ReactNode } from "react";

import { listEmployees, type AccountStatus, type EmployeeRole } from "../../lib/user/user-api";
import { ACCOUNT_STATUS, EMPLOYEE_ROLE, formatDateTime } from "../../lib/user/user-format";
import { ErrorPanel, StatusCell } from "./passenger-list";

/** Tab "Nhân viên nhà xe" (Figma ADM-03b): chỉ xem — tạo, khóa, cấp lại mật khẩu nhân viên do chủ nhà xe làm. */
export function EmployeeList() {
  const [search, setSearch] = useState("");
  const [operatorId, setOperatorId] = useState<string>(ALL);
  const [role, setRole] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);
  const q = useDebouncedValue(search.trim());
  const filters = useMemo(
    () => ({
      q: q || undefined,
      operatorId: operatorId === ALL ? undefined : operatorId,
      role: role === ALL ? undefined : role,
      status: status === ALL ? undefined : status
    }),
    [q, operatorId, role, status]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-employees", filters],
    queryFn: ({ pageParam }) => listEmployees(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const operators = pages.data?.pages[0]?.operators ?? [];

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = <ErrorPanel onRetry={() => void pages.refetch()} />;
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải nhân viên" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<Users className="size-6 text-vxn-fg-3" />}
        title="Không có nhân viên phù hợp"
        description="Nhân viên do chủ nhà xe tạo ở trang quản lý nhà xe."
      />
    );
  } else {
    body = (
      <div className="relative overflow-x-auto">
        <table className={`${TABLE} min-w-[860px]`}>
          <colgroup>
            <col />
            <col className="w-[22%]" />
            <col className="w-[17%]" />
            <col className="w-[14%]" />
            <col className="w-[18%]" />
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {["Tài khoản", "Nhà xe", "Vai trò", "Trạng thái", "Đăng nhập gần nhất"].map((heading) => (
                <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {rows.map((row) => (
              <tr key={row.id} className="h-[60px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className="truncate font-semibold text-vxn-ink">{row.username}</span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{row.email ?? "—"}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <span className="line-clamp-2">{row.operatorName}</span>
                </td>
                <td className={TABLE_CELL}>{EMPLOYEE_ROLE[row.role]}</td>
                <td className={TABLE_CELL}>
                  <StatusCell status={row.status} reason={null} since={null} />
                </td>
                <td className={TABLE_CELL}>{formatDateTime(row.lastLoginAt)}</td>
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
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} nhân viên`}
        endText={`Đã hiện tất cả ${rows.length} nhân viên`}
        errorText="Không tải thêm được nhân viên. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <>
      <section aria-label="Danh sách nhân viên nhà xe" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <SearchField label="Tìm nhân viên" placeholder="Tên đăng nhập hoặc email" value={search} onChange={setSearch} />
          <FilterSelect
            label="Nhà xe"
            allLabel="Tất cả nhà xe"
            value={operatorId}
            onChange={setOperatorId}
            options={operators.map((operator) => ({ value: operator.id, label: operator.name }))}
            className="w-52"
          />
          <FilterSelect
            label="Vai trò"
            allLabel="Tất cả vai trò"
            value={role}
            onChange={setRole}
            options={(Object.keys(EMPLOYEE_ROLE) as EmployeeRole[]).map((value) => ({ value, label: EMPLOYEE_ROLE[value] }))}
            className="w-48"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={(Object.keys(ACCOUNT_STATUS) as AccountStatus[]).map((value) => ({ value, label: ACCOUNT_STATUS[value].label }))}
            className="w-44"
          />
        </div>
        <div className="min-h-[320px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Eye className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Admin chỉ giám sát để kiểm duyệt và audit. Việc tạo, khóa và cấp lại mật khẩu nhân viên do chủ nhà xe thực hiện.
        </p>
      </div>
    </>
  );
}
