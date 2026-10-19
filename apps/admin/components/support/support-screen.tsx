"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ALL, FilterSelect, SearchField, TAB_TRIGGER, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { ChevronRight, CircleAlert, MessageSquareWarning, RefreshCw } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { formatVnd } from "../../lib/payment/payment-format";
import { listOperatorOptions } from "../../lib/report/report-api";
import {
  listAssignees,
  listDisputes,
  listTickets,
  type DisputeStatus,
  type DisputeSummary,
  type SupportCategory,
  type SupportStatus,
  type TicketSummary
} from "../../lib/support/support-api";
import {
  CATEGORY_LABEL,
  CATEGORY_ORDER,
  displayBookingCode,
  DISPUTE_STATUS,
  DISPUTE_STATUS_ORDER,
  PARTY_LABEL,
  shortMoment,
  TICKET_STATUS,
  TICKET_STATUS_ORDER
} from "../../lib/support/support-format";
import { PageHeader } from "../page-header";

const DISPUTES = "disputes";
const OPEN = "open";
const NONE = "none";
const COUNT = new Intl.NumberFormat("vi-VN");

/**
 * Khiếu nại & tranh chấp (Figma ADM-09a / 09c; TASK-TRUST-001, FR-NSR-08, FR-DSP-*): tab Khiếu nại (phân loại, phân công, theo dõi)
 * và Tranh chấp (Vé Xe Nhanh phân xử cuối). Tab đang mở nằm trên URL (`?tab=disputes`).
 */
export function SupportScreen() {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const tab = params.get("tab") === DISPUTES ? DISPUTES : "tickets";
  const unclassified = useQuery({ queryKey: ["admin-tickets", "count"], queryFn: () => listTickets({ status: "NEW" }) });
  const open = useQuery({ queryKey: ["admin-disputes", "count"], queryFn: () => listDisputes({ status: "open" }) });
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Khiếu nại & tranh chấp" description="Phân loại, phân công và theo dõi khiếu nại; phân xử tranh chấp giữa hành khách và nhà xe." />
      <Tabs value={tab} onValueChange={(next) => router.replace(next === DISPUTES ? `${pathname}?tab=${DISPUTES}` : pathname, { scroll: false })} className="flex flex-col gap-6">
        <TabsList className="h-10 w-fit max-w-full overflow-x-auto" aria-label="Nhóm hồ sơ">
          <TabsTrigger value="tickets" className={TAB_TRIGGER}>
            Khiếu nại{unclassified.data ? ` (${COUNT.format(unclassified.data.unclassified)} chưa phân loại)` : ""}
          </TabsTrigger>
          <TabsTrigger value={DISPUTES} className={TAB_TRIGGER}>
            Tranh chấp{open.data ? ` (${COUNT.format(open.data.open)} đang mở)` : ""}
          </TabsTrigger>
        </TabsList>
        <TabsContent value="tickets">
          <TicketList />
        </TabsContent>
        <TabsContent value={DISPUTES}>
          <DisputeList />
        </TabsContent>
      </Tabs>
    </div>
  );
}

function useFilterOptions() {
  const operators = useQuery({ queryKey: ["admin-report", "operators"], queryFn: listOperatorOptions });
  const assignees = useQuery({ queryKey: ["admin-support", "assignees"], queryFn: listAssignees });
  return {
    operators: operators.data ?? [],
    assignees: [{ value: NONE, label: "Chưa phân công" }, ...(assignees.data ?? []).map((item) => ({ value: item.id, label: item.username }))]
  };
}

function TicketList() {
  const [status, setStatus] = useState(ALL);
  const [category, setCategory] = useState(ALL);
  const [operatorId, setOperatorId] = useState(ALL);
  const [assigneeId, setAssigneeId] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const options = useFilterOptions();
  const tickets = useInfiniteQuery({
    queryKey: ["admin-tickets", status, category, operatorId, assigneeId, q],
    queryFn: ({ pageParam }) =>
      listTickets({
        status: status === ALL ? undefined : (status as SupportStatus),
        category: category === ALL ? undefined : (category as SupportCategory),
        operatorId: operatorId === ALL ? undefined : operatorId,
        assigneeId: assigneeId === ALL ? undefined : assigneeId,
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = tickets.data?.pages.flatMap((page) => page.items) ?? [];
  const total = tickets.data?.pages[0]?.total ?? 0;
  const filtered = status !== ALL || category !== ALL || operatorId !== ALL || assigneeId !== ALL || q !== "";
  const reset = () => {
    setStatus(ALL);
    setCategory(ALL);
    setOperatorId(ALL);
    setAssigneeId(ALL);
    setSearch("");
  };
  return (
    <ListSection
      label="Khiếu nại"
      filters={
        <>
          <FilterSelect label="Trạng thái" allLabel="Tất cả trạng thái" value={status} onChange={setStatus} options={TICKET_STATUS_ORDER.map((value) => ({ value, label: TICKET_STATUS[value].label }))} className="w-44" />
          <FilterSelect label="Danh mục" allLabel="Tất cả" value={category} onChange={setCategory} options={CATEGORY_ORDER.map((value) => ({ value, label: CATEGORY_LABEL[value] }))} className="w-44" />
          <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operatorId} onChange={setOperatorId} options={options.operators} className="w-44" />
          <FilterSelect label="Người phụ trách" allLabel="Tất cả" value={assigneeId} onChange={setAssigneeId} options={options.assignees} className="w-44" />
          <SearchField value={search} onChange={setSearch} placeholder="Mã khiếu nại hoặc mã đặt vé" />
        </>
      }
      query={tickets}
      count={items.length}
      empty={{
        title: filtered ? "Không có khiếu nại phù hợp" : "Chưa có khiếu nại",
        description: filtered ? "Đổi bộ lọc hoặc từ khóa để xem khiếu nại khác." : "Khiếu nại của hành khách về đơn đặt vé hiện ở đây.",
        reset: filtered ? reset : undefined
      }}
      footer={{ loaded: `Đã tải ${items.length} / ${COUNT.format(total)} khiếu nại`, end: `Đã hiển thị tất cả ${COUNT.format(items.length)} khiếu nại` }}
      headings={["Mã", "Vụ việc", "Người gửi", "Nhà xe", "Phụ trách", "Trạng thái", "Cập nhật", ""]}
      columns={["w-[13%]", "w-[23%]", "w-[11%]", "w-[13%]", "w-[13%]", "w-[13%]", "w-[9%]", "w-[5%]"]}
      rows={items.map((item) => (
        <TicketRow key={item.ticketId} item={item} />
      ))}
    />
  );
}

function TicketRow({ item }: { item: TicketSummary }) {
  const status = TICKET_STATUS[item.status];
  const href = `/disputes/tickets/${item.ticketId}`;
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} truncate font-semibold`}>
        <Link href={href} className="text-vxn-ink hover:underline">
          {item.ticketCode}
        </Link>
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-medium text-vxn-ink">{item.subject}</p>
        <p className="text-xs leading-[18px] text-muted-foreground">Đơn {displayBookingCode(item.bookingCode)}</p>
      </td>
      <td className={`${TABLE_CELL} truncate`}>{PARTY_LABEL[item.reporterParty]}</td>
      <td className={`${TABLE_CELL} truncate`}>{item.operatorName}</td>
      <td className={`${TABLE_CELL} truncate`}>{item.assignee?.username ?? <span className="text-muted-foreground">Chưa phân công</span>}</td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <td className={`${TABLE_CELL} text-muted-foreground tabular-nums`}>{shortMoment(item.lastMessageAt)}</td>
      <td className={TABLE_CELL}>
        <Link href={href} aria-label={`Xem ${item.ticketCode}`} className="inline-flex items-center font-semibold text-vxn-ink">
          Xem
          <ChevronRight className="size-4" />
        </Link>
      </td>
    </tr>
  );
}

function DisputeList() {
  const [status, setStatus] = useState(OPEN);
  const [operatorId, setOperatorId] = useState(ALL);
  const [due, setDue] = useState(ALL);
  const [assigneeId, setAssigneeId] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const options = useFilterOptions();
  const disputes = useInfiniteQuery({
    queryKey: ["admin-disputes", status, operatorId, due, assigneeId, q],
    queryFn: ({ pageParam }) =>
      listDisputes({
        status: status === ALL ? undefined : (status as DisputeStatus | "open"),
        operatorId: operatorId === ALL ? undefined : operatorId,
        due: due === ALL ? undefined : (due as "overdue" | "upcoming"),
        assigneeId: assigneeId === ALL ? undefined : assigneeId,
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = disputes.data?.pages.flatMap((page) => page.items) ?? [];
  const total = disputes.data?.pages[0]?.total ?? 0;
  const filtered = status !== OPEN || operatorId !== ALL || due !== ALL || assigneeId !== ALL || q !== "";
  const reset = () => {
    setStatus(OPEN);
    setOperatorId(ALL);
    setDue(ALL);
    setAssigneeId(ALL);
    setSearch("");
  };
  return (
    <ListSection
      label="Tranh chấp"
      filters={
        <>
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={[{ value: OPEN, label: "Đang mở" }, ...DISPUTE_STATUS_ORDER.map((value) => ({ value, label: DISPUTE_STATUS[value].label }))]}
            className="w-44"
          />
          <FilterSelect label="Nhà xe" allLabel="Tất cả nhà xe" value={operatorId} onChange={setOperatorId} options={options.operators} className="w-44" />
          <FilterSelect
            label="Hạn phản hồi"
            allLabel="Tất cả"
            value={due}
            onChange={setDue}
            options={[
              { value: "overdue", label: "Quá hạn" },
              { value: "upcoming", label: "Còn hạn" }
            ]}
            className="w-40"
          />
          <FilterSelect label="Người phụ trách" allLabel="Tất cả" value={assigneeId} onChange={setAssigneeId} options={options.assignees} className="w-44" />
          <SearchField value={search} onChange={setSearch} placeholder="Mã tranh chấp hoặc mã đặt vé" />
        </>
      }
      query={disputes}
      count={items.length}
      empty={{
        title: filtered ? "Không có tranh chấp phù hợp" : "Không có tranh chấp đang mở",
        description: filtered ? "Đổi bộ lọc hoặc từ khóa để xem tranh chấp khác." : "Khiếu nại được chuyển thành tranh chấp hiện ở đây.",
        reset: filtered ? reset : undefined
      }}
      footer={{ loaded: `Đã tải ${items.length} / ${COUNT.format(total)} tranh chấp`, end: `Đã hiển thị tất cả ${COUNT.format(items.length)} tranh chấp` }}
      headings={["Mã", "Vụ việc", "Nhà xe", "Số tiền liên quan", "Hạn phản hồi", "Trạng thái", ""]}
      columns={["w-[12%]", "w-[26%]", "w-[16%]", "w-[13%]", "w-[12%]", "w-[15%]", "w-[6%]"]}
      rows={items.map((item) => (
        <DisputeRow key={item.disputeId} item={item} />
      ))}
    />
  );
}

function DisputeRow({ item }: { item: DisputeSummary }) {
  const status = DISPUTE_STATUS[item.status];
  const href = `/disputes/cases/${item.disputeId}`;
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} font-semibold`}>
        <Link href={href} className="text-vxn-ink hover:underline">
          {item.disputeCode}
        </Link>
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-medium text-vxn-ink">{item.title}</p>
        <p className="text-xs leading-[18px] text-muted-foreground">Đơn {displayBookingCode(item.bookingCode)}</p>
      </td>
      <td className={`${TABLE_CELL} truncate`}>{item.operatorName}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.paidAmount)}</td>
      <td className={`${TABLE_CELL} tabular-nums`}>
        {item.responseDueAt ? (
          <span className={item.overdue ? "font-semibold text-error-600" : ""}>
            {shortMoment(item.responseDueAt)}
            {item.overdue && <span className="block text-xs leading-[18px] font-normal text-muted-foreground">Quá hạn</span>}
          </span>
        ) : (
          "—"
        )}
      </td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <td className={TABLE_CELL}>
        <Link href={href} aria-label={`Xem ${item.disputeCode}`} className="inline-flex items-center font-semibold text-vxn-ink">
          Xem
          <ChevronRight className="size-4" />
        </Link>
      </td>
    </tr>
  );
}

type PageQuery = {
  isPending: boolean;
  isError: boolean;
  data?: unknown;
  refetch: () => unknown;
  hasNextPage: boolean;
  isFetchingNextPage: boolean;
  isFetchNextPageError: boolean;
  fetchNextPage: () => unknown;
};

/** Khung chung của hai bảng: bộ lọc, trạng thái tải / lỗi / rỗng, bảng, "Tải thêm". */
function ListSection({
  label,
  filters,
  query,
  count,
  empty,
  footer,
  headings,
  columns,
  rows
}: {
  label: string;
  filters: ReactNode;
  query: PageQuery;
  count: number;
  empty: { title: string; description: string; reset?: () => void };
  footer: { loaded: string; end: string };
  headings: string[];
  columns: string[];
  rows: ReactNode[];
}) {
  let body: ReactNode;
  if (query.isPending) {
    body = <TableSkeleton label={`Đang tải ${label.toLowerCase()}`} rows={6} />;
  } else if (query.isError && !query.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title={`Không tải được ${label.toLowerCase()}`}
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void query.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (count === 0) {
    body = (
      <ListStatePanel
        icon={<MessageSquareWarning className="size-6 text-vxn-fg-3" />}
        title={empty.title}
        description={empty.description}
        action={
          empty.reset ? (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={empty.reset}>
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[960px]`}>
          <colgroup>
            {columns.map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {headings.map((heading, index) => (
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${heading === "Số tiền liên quan" ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>{rows}</tbody>
        </table>
      </div>
    );
  }
  return (
    <section aria-label={label} className="flex flex-col rounded-xl border bg-card p-6">
      <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">{filters}</div>
      {body}
      {count > 0 && (
        <div className="flex pt-5">
          <ListLoadMoreFooter
            hasMore={query.hasNextPage}
            loading={query.isFetchingNextPage}
            failed={query.isFetchNextPageError}
            loadedText={footer.loaded}
            endText={footer.end}
            errorText={`Chưa tải thêm được ${label.toLowerCase()}. Các dòng đã tải vẫn được giữ lại.`}
            onLoadMore={() => void query.fetchNextPage()}
          />
        </div>
      )}
    </section>
  );
}
