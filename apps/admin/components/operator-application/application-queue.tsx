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
import { ChevronRight, CircleAlert, FileSearch, RefreshCw, ShieldCheck } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import {
  listApplications,
  type ApplicationFilters,
  type ApplicationStatus,
  type ApplicationSummary
} from "../../lib/operator-application/application-api";
import {
  APPLICATION_STATUS,
  DUPLICATE_LABELS,
  formatShortDateTime,
  formatTaxCode,
  STATUS_FILTER_ORDER,
  SUBMITTED_WINDOWS,
  submittedSince
} from "../../lib/operator-application/application-format";
import { PageHeader } from "../page-header";

const FLAGGED = "FLAGGED";

/**
 * Hàng đợi hồ sơ đăng ký nhà xe (Figma ADM-02a; UC-23 bước 1): hồ sơ đã gửi duyệt, mới gửi trước, lọc theo trạng
 * thái / thời điểm gửi / cảnh báo trùng định danh, tìm theo mã, tên hoặc email. Lọc và phân trang ở máy chủ.
 */
export function ApplicationQueue() {
  const [status, setStatus] = useState<string>(ALL);
  const [period, setPeriod] = useState<string>("30");
  const [flag, setFlag] = useState<string>(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());

  const filters = useMemo<ApplicationFilters>(
    () => ({
      status: status === ALL ? undefined : (status as ApplicationStatus),
      submittedSince: period === ALL ? undefined : submittedSince(Number(period)),
      duplicatesOnly: flag === FLAGGED,
      q: q || undefined
    }),
    [status, period, flag, q]
  );
  const pages = useInfiniteQuery({
    queryKey: ["operator-applications", filters],
    queryFn: ({ pageParam }) => listApplications(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = status !== ALL || period !== ALL || flag !== ALL || q !== "";

  function resetFilters() {
    setStatus(ALL);
    setPeriod(ALL);
    setFlag(ALL);
    setSearch("");
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được hồ sơ"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void pages.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (pages.isPending) {
    body = <TableSkeleton label="Đang tải hồ sơ đăng ký" />;
  } else if (rows.length === 0) {
    body = (
      <ListStatePanel
        icon={<FileSearch className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có hồ sơ phù hợp" : "Chưa có hồ sơ nào gửi duyệt"}
        description={
          filtered
            ? "Đổi bộ lọc hoặc từ khóa, hoặc bỏ lọc để xem mọi hồ sơ."
            : "Hồ sơ nhà xe gửi duyệt từ trang đăng ký công khai sẽ hiện ở đây."
        }
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
    body = <QueueTable rows={rows} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${rows.length} hồ sơ`}
        endText={`Đã hiện tất cả ${rows.length} hồ sơ`}
        errorText="Không tải thêm được hồ sơ. Kiểm tra kết nối rồi thử lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Nhà xe & KYC" description="Duyệt hồ sơ đăng ký và quản lý trạng thái hoạt động của nhà xe." />

      <section aria-label="Hàng đợi hồ sơ đăng ký" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect
            label="Trạng thái hồ sơ"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={STATUS_FILTER_ORDER.map((value) => ({ value, label: APPLICATION_STATUS[value].label }))}
            className="w-56"
          />
          <FilterSelect
            label="Thời điểm gửi"
            allLabel="Mọi thời điểm"
            value={period}
            onChange={setPeriod}
            options={SUBMITTED_WINDOWS.map((option) => ({ ...option }))}
            className="w-56"
          />
          <FilterSelect
            label="Cảnh báo trùng định danh"
            allLabel="Tất cả"
            value={flag}
            onChange={setFlag}
            options={[{ value: FLAGGED, label: "Có cảnh báo" }]}
            className="w-56"
          />
          <SearchField
            label="Tìm hồ sơ"
            placeholder="Mã hồ sơ, tên nhà xe hoặc email"
            value={search}
            onChange={setSearch}
          />
        </div>
        <div className="min-h-[360px]">{body}</div>
        {footer && <div className="flex min-h-14 items-center pt-5">{footer}</div>}
      </section>

      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <ShieldCheck className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Chỉ hồ sơ ở trạng thái Chờ duyệt mới ra quyết định được. Mỗi lần mở giấy tờ KYC đều được ghi nhật ký audit.
        </p>
      </div>
    </div>
  );
}

// Độ rộng cột theo Figma ADM-02a (co giãn ở cột Nhà xe); mã hồ sơ 6 số dài hơn mẫu Figma nên cột mã rộng hơn.
const COLUMNS = ["w-[15.5%]", "", "w-[20%]", "w-[11%]", "w-[17.5%]", "w-[11%]", "w-[7%]"];
const HEADINGS = ["Mã hồ sơ", "Nhà xe", "Người liên hệ", "Gửi duyệt", "Cảnh báo", "Trạng thái", ""];
const SUBLINE = "truncate text-xs leading-[18px] text-muted-foreground";
const STRONG = "truncate font-semibold text-vxn-ink";

function QueueTable({ rows }: { rows: ApplicationSummary[] }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[980px]`}>
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
            const status = APPLICATION_STATUS[row.status];
            return (
              <tr key={row.id} className="h-[76px] border-b">
                <td className={`${TABLE_CELL} font-semibold whitespace-nowrap text-vxn-ink`}>{row.applicationCode}</td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className={STRONG}>{row.operatorName}</span>
                    <span className={SUBLINE}>{row.taxCode ? `MST ${formatTaxCode(row.taxCode)}` : "Chưa có MST"}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col">
                    <span className={STRONG}>{row.contactName}</span>
                    <span className={SUBLINE}>{row.contactEmail}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{formatShortDateTime(row.submittedAt)}</td>
                <td className={TABLE_CELL}>
                  {row.duplicates.length === 0 ? (
                    <span className="text-muted-foreground">—</span>
                  ) : (
                    <div className="flex flex-col items-start gap-1">
                      {row.duplicates.map((field) => (
                        <Badge key={field} tone="danger">
                          {DUPLICATE_LABELS[field]}
                        </Badge>
                      ))}
                    </div>
                  )}
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Link
                    href={`/operators/applications/${row.id}`}
                    aria-label={`Xem hồ sơ ${row.applicationCode}`}
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
