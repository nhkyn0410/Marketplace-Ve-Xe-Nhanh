"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
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
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ChevronRight, CircleAlert, Info, RefreshCw, Wallet } from "lucide-react";
import Link from "next/link";
import { useId, useState } from "react";

import { getPayoutStats, listPayouts, type PayoutStatus, type PayoutSummary } from "../../lib/payout/payout-api";
import { bankLabel, PAYOUT_STATUS, PAYOUT_STATUS_ORDER, periodLabel, rowAction } from "../../lib/payout/payout-format";
import { PageHeader } from "../page-header";

const VND = new Intl.NumberFormat("vi-VN");
const formatVnd = (amount: number) => `${VND.format(amount)} ₫`;
const COLUMNS = ["w-[17%]", "w-[19%]", "w-[11%]", "w-[13%]", "w-[16%]", "w-[16%]", "w-[8%]"];
const HEADINGS = ["Mã chi trả", "Nhà xe", "Kỳ", "Thực chi", "Tài khoản nhận", "Trạng thái", ""];

/**
 * Chi trả nhà xe (Figma ADM-08a; TASK-BTP-006 / ADM-002, FR-ADM-10, UC-26): kỳ chi trả được tạo tự động khi tiền vé đã qua
 * T+N kể từ chuyến đến nơi; Admin rà soát, tự chuyển khoản rồi xác nhận. Lọc kỳ / trạng thái, tìm mã hoặc tên nhà xe.
 */
export function PayoutList() {
  const [period, setPeriod] = useState("");
  const [status, setStatus] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const periodId = useId();
  const stats = useQuery({ queryKey: ["admin-payout-stats"], queryFn: getPayoutStats });
  const payouts = useInfiniteQuery({
    queryKey: ["admin-payouts", period, status, q],
    queryFn: ({ pageParam }) =>
      listPayouts({ period: period || undefined, status: status === ALL ? undefined : (status as PayoutStatus), q: q || undefined, cursor: pageParam ?? undefined }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = payouts.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = period !== "" || status !== ALL || q !== "";

  let body;
  if (payouts.isPending) {
    body = <TableSkeleton label="Đang tải kỳ chi trả" rows={6} />;
  } else if (payouts.isError && !payouts.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được kỳ chi trả"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void payouts.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={<Wallet className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có kỳ phù hợp" : "Chưa có kỳ chi trả"}
        description={filtered ? "Đổi kỳ, trạng thái hoặc từ khóa để xem kỳ khác." : "Kỳ chi trả được tạo mỗi ngày lúc 00:00 cho tiền vé đã qua T+N kể từ khi chuyến đến nơi."}
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setPeriod("");
                setStatus(ALL);
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
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 3 ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <PayoutRow key={item.payoutId} item={item} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Chi trả nhà xe" description="Kỳ chi trả được tạo tự động khi chuyến hoàn thành đủ T+3. Admin rà soát, chuyển khoản và xác nhận." />
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Chờ rà soát" value={stats.data ? `${stats.data.pendingReview.count} khoản` : undefined} note={stats.data ? formatVnd(stats.data.pendingReview.amount) : ""} />
        <Stat label="Sẵn sàng chuyển khoản" value={stats.data ? `${stats.data.readyToTransfer.count} khoản` : undefined} note={stats.data ? formatVnd(stats.data.readyToTransfer.amount) : ""} />
        <Stat label="Đang giữ lại" value={stats.data ? `${stats.data.onHold.count} khoản` : undefined} note="Hoàn tiền treo hoặc tài khoản chưa xác minh" tone="warning" />
        <Stat
          label="Đã chi trả trong tháng"
          value={stats.data ? formatVnd(stats.data.paidThisMonth.amount) : undefined}
          note={stats.data ? `${stats.data.paidThisMonth.count} khoản` : ""}
          tone="success"
        />
      </div>
      <section aria-label="Kỳ chi trả" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <div className="flex w-52 flex-col gap-1.5">
            <label htmlFor={periodId} className="text-xs leading-[18px] font-medium text-muted-foreground">
              Kỳ chi trả
            </label>
            <Input id={periodId} type="date" value={period} onChange={(event) => setPeriod(event.target.value)} />
          </div>
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={PAYOUT_STATUS_ORDER.map((value) => ({ value, label: PAYOUT_STATUS[value].label }))}
          />
          <SearchField value={search} onChange={setSearch} placeholder="Mã chi trả hoặc nhà xe" />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={payouts.hasNextPage}
              loading={payouts.isFetchingNextPage}
              failed={payouts.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} khoản`}
              endText={`Đã hiển thị tất cả ${items.length} khoản`}
              errorText="Chưa tải thêm được kỳ chi trả. Các kỳ đã tải vẫn được giữ lại."
              onLoadMore={() => void payouts.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Khoản có tranh chấp chưa đóng, hoàn tiền đang treo, số liệu lệch sổ giữ hộ hoặc tài khoản nhận tiền chưa xác minh không được đánh dấu đã chi trả.
      </div>
    </div>
  );
}

function PayoutRow({ item }: { item: PayoutSummary }) {
  const status = PAYOUT_STATUS[item.status];
  const note = item.status === "ON_HOLD" ? item.holdReason : item.status === "PAID" && item.paidAt ? new Date(item.paidAt).toLocaleString("vi-VN", { timeZone: "Asia/Ho_Chi_Minh", dateStyle: "short", timeStyle: "short" }) : null;
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} font-semibold`}>
        <Link href={`/payouts/${item.payoutId}`} className="text-vxn-ink hover:underline">
          {item.payoutCode}
        </Link>
      </td>
      <td className={`${TABLE_CELL} truncate font-medium`}>{item.operatorName}</td>
      <td className={TABLE_CELL}>{periodLabel(item.period)}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.amount)}</td>
      <td className={TABLE_CELL}>
        <p className="truncate">{bankLabel(item.bank)}</p>
      </td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
        {note && <p className="mt-1 truncate text-xs leading-[18px] text-muted-foreground">{note}</p>}
      </td>
      <td className={`${TABLE_CELL} text-right`}>
        <Link href={`/payouts/${item.payoutId}`} className="inline-flex items-center gap-1 font-semibold text-vxn-ink hover:underline">
          {rowAction(item.status)}
          <ChevronRight className="size-4" aria-hidden />
        </Link>
      </td>
    </tr>
  );
}

function Stat({ label, value, note, tone }: { label: string; value: string | undefined; note: string; tone?: "warning" | "success" }) {
  const color = tone === "warning" ? "text-warning-700" : tone === "success" ? "text-success-600" : "text-vxn-ink";
  return (
    <div className="flex flex-col gap-1.5 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      {value === undefined ? <Skeleton className="h-9 w-32" /> : <p className={`text-[28px] leading-9 font-semibold tabular-nums ${color}`}>{value}</p>}
      <p className="text-xs leading-[18px] text-muted-foreground">{note}</p>
    </div>
  );
}
