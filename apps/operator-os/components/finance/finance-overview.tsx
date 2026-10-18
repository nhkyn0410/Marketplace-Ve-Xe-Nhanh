"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Banknote, CircleAlert, ReceiptText, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useId, useState } from "react";

import { displayCode, shortMoment } from "../../lib/booking/booking-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { getFinanceSummary, listFinanceBookings, type FinanceBooking, type FinanceState } from "../../lib/finance/finance-api";
import { FINANCE_STATE, FINANCE_STATE_ORDER, signedVnd, tripProgress } from "../../lib/finance/finance-format";
import { listAllRoutes } from "../../lib/route/route-api";
import { formatDay, todayLocalDate } from "../../lib/trip/trip-format";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
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
} from "../stop-point/list-controls";
import { FinanceHeader } from "./finance-tabs";

const COLUMNS = ["w-[13%]", "w-[24%]", "w-[11%]", "w-[11%]", "w-[12%]", "w-[11%]", "w-[18%]"];
const HEADINGS = ["Mã đặt vé", "Chuyến", "Giá vé", "Hoa hồng", "Hoàn / điều chỉnh", "Nhà xe nhận", "Tình trạng"];

/** Ngày cách hôm nay `days` ngày (giờ VN), dạng `2026-10-08`. */
function shiftDate(days: number): string {
  return todayLocalDate(new Date(Date.now() + days * 86_400_000));
}

/**
 * Tài chính — Tổng quan (Figma "Nhà xe · Tài chính / 01"; TASK-OPR-002, FR-OPR-07): số dư giữ hộ, đủ điều kiện / chờ, kỳ đã
 * chi gần nhất, và tiền từng đơn (giá vé, hoa hồng, hoàn, nhà xe nhận) theo ngày khởi hành.
 */
export function FinanceOverview() {
  const [from, setFrom] = useState(shiftDate(-30));
  const [to, setTo] = useState(shiftDate(30));
  const [routeId, setRouteId] = useState(ALL);
  const [state, setState] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const validRange = /^\d{4}-\d{2}-\d{2}$/.test(from) && /^\d{4}-\d{2}-\d{2}$/.test(to) && from <= to;
  const summary = useQuery({ queryKey: ["finance-summary"], queryFn: getFinanceSummary });
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const rows = useInfiniteQuery({
    queryKey: ["finance-bookings", from, to, routeId, state, q],
    queryFn: ({ pageParam }) =>
      listFinanceBookings({
        from,
        to,
        routeId: routeId === ALL ? undefined : routeId,
        state: state === ALL ? undefined : (state as FinanceState),
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor,
    enabled: validRange
  });
  const items = rows.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = routeId !== ALL || state !== ALL || q !== "";
  const delay = summary.data?.payoutDelayDays ?? 3;

  let body;
  if (!validRange) {
    body = <ListStatePanel icon={<ReceiptText className="size-6 text-vxn-fg-3" />} title="Chọn khoảng thời gian" description="Ngày bắt đầu phải trước ngày kết thúc." compact />;
  } else if (rows.isPending) {
    body = <TableSkeleton label="Đang tải giao dịch" rows={5} />;
  } else if (rows.isError && !rows.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được giao dịch"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void rows.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={<ReceiptText className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có giao dịch phù hợp" : "Chưa có giao dịch"}
        description={filtered ? "Đổi bộ lọc hoặc bỏ lọc để xem mọi giao dịch trong khoảng thời gian." : "Tiền vé của các đơn đã thanh toán hiện ở đây theo ngày khởi hành."}
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setRouteId(ALL);
                setState(ALL);
                setSearch("");
              }}
            >
              Bỏ lọc
            </Button>
          ) : undefined
        }
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[980px]`}>
          <colgroup>
            {COLUMNS.map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {HEADINGS.map((heading, index) => (
                <th key={heading} scope="col" className={`${TABLE_HEAD_CELL} ${index >= 2 && index <= 5 ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <FinanceRow key={item.bookingId} item={item} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <FinanceHeader />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Số dư đang giữ" value={summary.data?.heldBalance} note="Tiền vé đã thu, chưa chi trả" loading={summary.isPending} />
        <Stat label="Đủ điều kiện chi trả" value={summary.data?.eligibleAmount} note={`Đã qua T+${delay} kể từ khi chuyến đến nơi`} loading={summary.isPending} accent />
        <Stat label="Chờ đủ điều kiện" value={summary.data?.pendingAmount} note={`Chuyến chưa đến nơi hoặc chưa đủ T+${delay}`} loading={summary.isPending} />
        <Stat
          label="Kỳ chi trả gần nhất"
          value={summary.data?.lastPayout?.amount}
          note={summary.data?.lastPayout ? `Đã chi trả ngày ${formatDay(summary.data.lastPayout.paidAt)}` : "Chưa có kỳ đã chi"}
          loading={summary.isPending}
        />
      </div>
      <section aria-label="Giao dịch" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <DateField label="Khởi hành từ" value={from} onChange={setFrom} />
          <DateField label="Đến ngày" value={to} onChange={setTo} />
          <FilterSelect label="Tuyến" allLabel="Tất cả tuyến" value={routeId} onChange={setRouteId} options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))} />
          <FilterSelect
            label="Tình trạng"
            allLabel="Tất cả"
            value={state}
            onChange={setState}
            options={FINANCE_STATE_ORDER.map((value) => ({ value, label: FINANCE_STATE[value].label }))}
          />
          <SearchField value={search} onChange={setSearch} placeholder="Mã đặt vé" />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={rows.hasNextPage}
              loading={rows.isFetchingNextPage}
              failed={rows.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} giao dịch`}
              endText={`Đã hiển thị tất cả ${items.length} giao dịch`}
              errorText="Chưa tải thêm được giao dịch. Các giao dịch đã tải vẫn được giữ lại."
              onLoadMore={() => void rows.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <Banknote className="size-[18px] shrink-0" aria-hidden />
        Chi trả theo chu kỳ T+{delay} sau khi chuyến đến nơi, chuyển khoản tới tài khoản nhận tiền đã xác minh. Không có ngưỡng tối thiểu. Chi trả sớm chưa mở ở phiên bản này.
      </div>
    </div>
  );
}

function FinanceRow({ item }: { item: FinanceBooking }) {
  const state = FINANCE_STATE[item.state];
  const muted = "text-xs leading-[18px] text-muted-foreground";
  return (
    <tr className="border-b last:border-b-0">
      <td className={TABLE_CELL}>
        <Link href={`/bookings/${item.bookingId}`} className="font-semibold text-vxn-ink hover:underline">
          {displayCode(item.bookingCode)}
        </Link>
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-medium">
          {shortMoment(item.trip.departureAt)} · {item.trip.routeName}
        </p>
        <p className={muted}>{tripProgress(item.trip)}</p>
      </td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatVnd(item.grossAmount)}</td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(-item.commissionAmount, formatVnd)}</td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(item.refundAdjustmentAmount, formatVnd)}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.netAmount)}</td>
      <td className={TABLE_CELL}>
        <Badge tone={state.tone}>{state.label}</Badge>
      </td>
    </tr>
  );
}

function Stat({ label, value, note, loading, accent = false }: { label: string; value: number | undefined; note: string; loading: boolean; accent?: boolean }) {
  return (
    <div className="flex flex-col gap-1.5 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {loading ? (
        <Skeleton className="h-9 w-40" />
      ) : (
        <p className={`text-[28px] leading-9 font-semibold tabular-nums ${accent ? "text-success-600" : "text-vxn-ink"}`}>{value === undefined ? "—" : formatVnd(value)}</p>
      )}
      <p className="text-xs leading-[18px] text-muted-foreground">{note}</p>
    </div>
  );
}

function DateField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-44 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        {label}
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}
