"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { ChevronRight, CircleAlert, Info, RefreshCw, Wallet } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { formatVnd } from "../../lib/fare/fare-format";
import { getFinanceSummary, listPayouts, type PayoutStatus, type PayoutSummary } from "../../lib/finance/finance-api";
import { PAYOUT_STATUS, PAYOUT_STATUS_ORDER, periodLabel, periodNote, refundAdjustment, signedVnd } from "../../lib/finance/finance-format";
import { todayLocalDate } from "../../lib/trip/trip-format";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { ALL, FilterSelect, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "../stop-point/list-controls";
import { FinanceHeader } from "./finance-tabs";

const COLUMNS = ["w-[22%]", "w-[14%]", "w-[13%]", "w-[14%]", "w-[14%]", "w-[15%]", "w-[8%]"];
const HEADINGS = ["Kỳ chi trả", "Đủ điều kiện", "Hoa hồng", "Hoàn / điều chỉnh", "Thực nhận", "Trạng thái", ""];

/** 12 tháng gần nhất (giờ VN) cho ô chọn tháng. */
function recentMonths(): { value: string; label: string }[] {
  const [year, month] = todayLocalDate().split("-").map(Number) as [number, number];
  return Array.from({ length: 12 }, (_, index) => {
    const total = year * 12 + (month - 1) - index;
    const value = `${Math.floor(total / 12)}-${String((total % 12) + 1).padStart(2, "0")}`;
    return { value, label: `Tháng ${value.slice(5)}/${value.slice(0, 4)}` };
  });
}

/** Tài chính — Chi trả (Figma "Nhà xe · Tài chính / 02"; TASK-OPR-002, FR-OPR-08): các kỳ chi trả T+N của nhà xe. */
export function PayoutList() {
  const months = recentMonths();
  const [month, setMonth] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const summary = useQuery({ queryKey: ["finance-summary"], queryFn: getFinanceSummary });
  const payouts = useInfiniteQuery({
    queryKey: ["operator-payouts", month, status],
    queryFn: ({ pageParam }) =>
      listPayouts({ month: month === ALL ? undefined : month, status: status === ALL ? undefined : (status as PayoutStatus), cursor: pageParam ?? undefined }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = payouts.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = month !== ALL || status !== ALL;
  const delay = summary.data?.payoutDelayDays ?? 3;

  let body;
  if (payouts.isPending) {
    body = <TableSkeleton label="Đang tải kỳ chi trả" rows={5} />;
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
        description={filtered ? "Đổi tháng hoặc trạng thái để xem kỳ khác." : `Kỳ chi trả được tạo tự động mỗi ngày cho tiền vé đã qua T+${delay} kể từ khi chuyến đến nơi.`}
      />
    );
  } else {
    body = (
      <div className="overflow-x-auto">
        <table className={`${TABLE} min-w-[900px]`}>
          <colgroup>
            {COLUMNS.map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {HEADINGS.map((heading, index) => (
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index >= 1 && index <= 4 ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <PayoutRow key={item.payoutId} item={item} delay={delay} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-6">
      <FinanceHeader />
      <section aria-label="Kỳ chi trả" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <FilterSelect label="Khoảng thời gian" allLabel="Tất cả tháng" value={month} onChange={setMonth} options={months} />
          <FilterSelect label="Trạng thái" allLabel="Tất cả trạng thái" value={status} onChange={setStatus} options={PAYOUT_STATUS_ORDER.map((value) => ({ value, label: PAYOUT_STATUS[value].label }))} />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={payouts.hasNextPage}
              loading={payouts.isFetchingNextPage}
              failed={payouts.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} kỳ`}
              endText={`Đã hiển thị tất cả ${items.length} kỳ`}
              errorText="Chưa tải thêm được kỳ chi trả. Các kỳ đã tải vẫn được giữ lại."
              onLoadMore={() => void payouts.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Kỳ &quot;Đang giữ lại&quot; là kỳ có hoàn tiền, tranh chấp chưa đóng, số liệu lệch hoặc tài khoản nhận tiền cần xác minh. Vé Xe Nhanh sẽ chi trả sau khi xử lý xong.
      </div>
    </div>
  );
}

function PayoutRow({ item, delay }: { item: PayoutSummary; delay: number }) {
  const status = PAYOUT_STATUS[item.status];
  return (
    <tr className="border-b last:border-b-0">
      <td className={TABLE_CELL}>
        <Link href={`/finance/payouts/${item.payoutId}`} className="font-semibold text-vxn-ink hover:underline">
          Kỳ {periodLabel(item.period)}
        </Link>
        <p className="text-xs leading-[18px] text-muted-foreground">{periodNote(item.period, delay)}</p>
      </td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{formatVnd(item.grossAmount)}</td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(-item.commissionAmount, formatVnd)}</td>
      <td className={`${TABLE_CELL} text-right tabular-nums`}>{signedVnd(refundAdjustment(item), formatVnd)}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.amount)}</td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <td className={`${TABLE_CELL} text-right`}>
        <Link href={`/finance/payouts/${item.payoutId}`} className="inline-flex items-center gap-1 font-semibold text-vxn-ink hover:underline">
          Xem
          <ChevronRight className="size-4" aria-hidden />
        </Link>
      </td>
    </tr>
  );
}
