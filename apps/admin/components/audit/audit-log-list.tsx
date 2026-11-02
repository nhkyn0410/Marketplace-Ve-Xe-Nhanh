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
import { ChevronRight, CircleAlert, FileSearch, RefreshCw, ScrollText } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { listAuditLogs, type AuditLogFilters, type AuditLogItem } from "../../lib/audit/audit-api";
import {
  ACTOR_TYPE_LABELS,
  actionLabel,
  actorLines,
  formatAuditTime,
  MODULE_LABELS,
  MODULE_ORDER,
  PERIODS,
  periodStart,
  targetLabel
} from "../../lib/audit/audit-format";
import { PageHeader } from "../page-header";

/**
 * Nhật ký audit (Figma ADM-15a; UC-30, FR-ADM-16): bản ghi chỉ ghi thêm của mọi loại tài khoản và hệ thống, mới nhất
 * trước; lọc thời gian / loại người thực hiện / phân hệ / kết quả, tìm theo tài khoản hoặc mã đối tượng.
 */
export function AuditLogList() {
  const [period, setPeriod] = useState<string>("7");
  const [actorType, setActorType] = useState<string>(ALL);
  const [module, setModule] = useState<string>(ALL);
  const [result, setResult] = useState<string>(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());

  const filters = useMemo<AuditLogFilters>(
    () => ({
      from: period === ALL ? undefined : periodStart(Number(period)),
      actorType: actorType === ALL ? undefined : (actorType as AuditLogFilters["actorType"]),
      module: module === ALL ? undefined : (module as AuditLogFilters["module"]),
      result: result === ALL ? undefined : (result as AuditLogFilters["result"]),
      q: q || undefined
    }),
    [period, actorType, module, result, q]
  );
  const pages = useInfiniteQuery({
    queryKey: ["admin-audit-logs", filters],
    queryFn: ({ pageParam }) => listAuditLogs(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  const filtered = period !== ALL || actorType !== ALL || module !== ALL || result !== ALL || q !== "";

  function resetFilters() {
    setPeriod(ALL);
    setActorType(ALL);
    setModule(ALL);
    setResult(ALL);
    setSearch("");
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được nhật ký"
        description="Kho nhật ký chưa phản hồi hoặc mất kết nối. Thử lại sau ít phút."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải nhật ký audit" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileSearch className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có bản ghi phù hợp" : "Chưa có bản ghi nào"}
        description={filtered ? "Mở rộng khoảng thời gian hoặc đổi bộ lọc." : "Thao tác nhạy cảm của mọi tài khoản sẽ hiện ở đây."}
        action={
          filtered ? (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={resetFilters}>
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = <LogTable rows={rows} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} / ${total.toLocaleString("vi-VN")} bản ghi`}
        endText={`Đã hiện tất cả ${rows.length} bản ghi`}
        errorText="Không tải thêm được bản ghi. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Nhật ký audit"
        description="Nhật ký chỉ ghi thêm cho thao tác nhạy cảm của mọi loại tài khoản và của hệ thống."
      />
      <section aria-label="Bản ghi audit" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect
            label="Khoảng thời gian"
            allLabel="Mọi thời điểm"
            value={period}
            onChange={setPeriod}
            options={PERIODS.map((option) => ({ ...option }))}
            className="w-48"
          />
          <FilterSelect
            label="Loại người thực hiện"
            allLabel="Tất cả"
            value={actorType}
            onChange={setActorType}
            options={Object.entries(ACTOR_TYPE_LABELS).map(([value, label]) => ({ value, label }))}
            className="w-48"
          />
          <FilterSelect
            label="Phân hệ"
            allLabel="Tất cả"
            value={module}
            onChange={setModule}
            options={MODULE_ORDER.map((value) => ({ value, label: MODULE_LABELS[value] }))}
            className="w-48"
          />
          <FilterSelect
            label="Kết quả"
            allLabel="Tất cả"
            value={result}
            onChange={setResult}
            options={[
              { value: "SUCCESS", label: "Thành công" },
              { value: "FAILURE", label: "Thất bại / bị chặn" }
            ]}
            className="w-48"
          />
          <SearchField label="Tìm kiếm" placeholder="Tài khoản hoặc mã đối tượng" value={search} onChange={setSearch} />
        </div>
        <div className="min-h-[360px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <ScrollText className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Nhật ký không sửa hoặc xóa được. Việc xem chi tiết cũng được ghi lại; dữ liệu cá nhân và số tài khoản được che.
        </p>
      </div>
    </div>
  );
}

// Độ rộng cột theo Figma ADM-15a (co giãn ở cột Hành động); cột thời điểm có giây nên rộng hơn mẫu.
const COLUMNS = ["w-[13%]", "w-[17%]", "", "w-[19%]", "w-[13%]", "w-[10%]", "w-[6%]"];
const HEADINGS = ["Thời điểm", "Người thực hiện", "Hành động", "Đối tượng", "Nhà xe", "Kết quả", ""];
const SUBLINE = "truncate text-xs leading-[18px] text-muted-foreground";
const STRONG = "truncate font-semibold text-vxn-ink";

function LogTable({ rows }: { rows: AuditLogItem[] }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[1040px]`}>
        <colgroup>
          {COLUMNS.map((width, index) => (
            <col key={index} className={width} />
          ))}
        </colgroup>
        <thead>
          <tr className={TABLE_HEAD_ROW}>
            {HEADINGS.map((heading, index) => (
              <th key={index} scope="col" className={TABLE_HEAD_CELL}>
                {heading || <span className="sr-only">Thao tác</span>}
              </th>
            ))}
          </tr>
        </thead>
        <tbody>
          {rows.map((row) => {
            const actor = actorLines(row);
            const label = actionLabel(row.action);
            return (
              <tr key={row.id} className="h-[68px] border-b">
                <td className={`${TABLE_CELL} whitespace-nowrap`}>{formatAuditTime(row.createdAt)}</td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className={STRONG}>{actor.name}</span>
                    <span className={SUBLINE}>{actor.role}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <span className="line-clamp-2">{label}</span>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className={STRONG}>{targetLabel(row.targetType)}</span>
                    <span className={`${SUBLINE} font-mono`}>{row.targetId}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <span className="line-clamp-2">{row.operator?.name ?? "—"}</span>
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={row.result === "SUCCESS" ? "success" : "danger"}>
                    {row.result === "SUCCESS" ? "Thành công" : "Thất bại"}
                  </Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Link
                    href={`/audit-logs/${row.id}`}
                    aria-label={`Xem bản ghi ${label} lúc ${formatAuditTime(row.createdAt)}`}
                    className="inline-flex items-center gap-1 rounded text-sm font-semibold text-vxn-ink outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
                  >
                    Xem
                    <ChevronRight className="size-4 text-muted-foreground" />
                  </Link>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}
