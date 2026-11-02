"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  ALL,
  FilterSelect,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ChevronRight, CircleAlert, Info, Inbox, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useMemo, useState, type ReactNode } from "react";

import { formatShortDateTime } from "../../lib/operator-application/application-format";
import { listProposals, type Proposal } from "../../lib/stop-point/stop-point-api";
import {
  formatCount,
  nearbyWarning,
  PROPOSAL_STATUS,
  PROPOSAL_TYPES,
  STOP_POINT_TYPE_LABELS
} from "../../lib/stop-point/stop-point-format";

/**
 * Tab "Chờ duyệt" (Figma ADM-05b; LLD §6.13 bước 3): đề xuất của các nhà xe, mặc định đang chờ duyệt, mới gửi
 * trước; cảnh báo khi có điểm dùng chung cùng loại trong 200 m. "Xem xét" mở trang duyệt.
 */
export function ProposalList() {
  const [status, setStatus] = useState<string>("PENDING");
  const [type, setType] = useState<string>(ALL);
  const filters = { status: status === ALL ? undefined : status, type: type === ALL ? undefined : type };
  const pages = useInfiniteQuery({
    queryKey: ["admin-stop-points", "proposals", filters],
    queryFn: ({ pageParam }) => listProposals(filters, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const items = useMemo(() => pages.data?.pages.flatMap((page) => page.items) ?? [], [pages.data]);
  const total = pages.data?.pages[0]?.total ?? 0;

  let body: ReactNode;
  let footer: ReactNode = null;
  if (pages.isError && items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được đề xuất"
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
    body = <TableSkeleton label="Đang tải đề xuất" rows={3} />;
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        compact
        icon={<Inbox className="size-6 text-vxn-fg-3" />}
        title={status === "PENDING" ? "Không có đề xuất chờ duyệt" : "Không có đề xuất phù hợp"}
        description="Đề xuất bến xe / điểm dừng đón trả của nhà xe sẽ hiện ở đây."
      />
    );
  } else {
    body = <ProposalTable items={items} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={pages.hasNextPage}
        loading={pages.isFetchingNextPage}
        failed={pages.isFetchNextPageError}
        loadedText={`Đã tải ${formatCount(items.length)} / ${formatCount(total)} đề xuất`}
        endText={`Đã tải ${formatCount(items.length)} đề xuất`}
        errorText="Chưa tải thêm được. Các dòng đã tải vẫn được giữ lại."
        onLoadMore={() => void pages.fetchNextPage()}
      />
    );
  }

  return (
    <>
      <section aria-label="Đề xuất điểm dừng" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-4 pb-5">
          <FilterSelect
            label="Trạng thái đề xuất"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={(["PENDING", "APPROVED", "REJECTED"] as const).map((value) => ({ value, label: PROPOSAL_STATUS[value].label }))}
            className="w-52"
          />
          <FilterSelect
            label="Loại điểm"
            allLabel="Tất cả loại"
            value={type}
            onChange={setType}
            options={PROPOSAL_TYPES.map((value) => ({ value, label: STOP_POINT_TYPE_LABELS[value] }))}
            className="w-52"
          />
        </div>
        <div className="min-h-[200px]">{body}</div>
        {footer && <div className="flex min-h-14 flex-wrap items-center gap-3 pt-5">{footer}</div>}
      </section>
      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <Info className="size-5 shrink-0 text-accent-foreground" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-accent-foreground">
          Nhà xe chỉ đề xuất bến xe hoặc điểm dừng đón trả khách, kèm căn cứ công bố. Khi duyệt có thể chỉnh tên, địa chỉ
          và tọa độ; từ chối cần lý do và nhà xe sửa rồi gửi lại được.
        </p>
      </div>
    </>
  );
}

// Tỉ lệ cột theo Figma ADM-05b (tên co giãn / 185 / 175 / 115 / 205 / 105 / 90 trên bảng rộng 1056).
const COLUMNS = ["", "w-[17.5%]", "w-[16.5%]", "w-[11%]", "w-[19%]", "w-[10.5%]", "w-[96px]"];
const HEADINGS = ["Điểm đề xuất", "Loại điểm", "Nhà xe đề xuất", "Gửi lúc", "Cảnh báo", "Trạng thái", ""];

function ProposalTable({ items }: { items: Proposal[] }) {
  return (
    <div className="relative overflow-x-auto">
      <table className={`${TABLE} min-w-[960px]`}>
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
          {items.map((item) => {
            const status = PROPOSAL_STATUS[item.status];
            const warning = item.status === "PENDING" ? nearbyWarning(item) : null;
            return (
              <tr key={item.id} className="h-[76px] border-b">
                <td className={TABLE_CELL}>
                  <div className="flex min-w-0 flex-col gap-1">
                    <span className="truncate font-semibold text-vxn-ink">{item.name}</span>
                    <span className="truncate text-xs leading-[18px] text-muted-foreground">{item.address}</span>
                  </div>
                </td>
                <td className={TABLE_CELL}>{STOP_POINT_TYPE_LABELS[item.type]}</td>
                <td className={`${TABLE_CELL} truncate`}>{item.operatorName}</td>
                <td className={TABLE_CELL}>{formatShortDateTime(item.createdAt)}</td>
                <td className={TABLE_CELL}>
                  {warning ? <Badge tone="warning">{warning}</Badge> : <span className="text-muted-foreground">—</span>}
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={status.tone}>{status.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Link
                    href={`/stop-points/proposals/${item.id}`}
                    aria-label={`Xem xét ${item.name}`}
                    className="inline-flex items-center gap-1 rounded text-sm font-semibold whitespace-nowrap text-vxn-ink outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
                  >
                    Xem xét
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
