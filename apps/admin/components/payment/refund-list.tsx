"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { ALL, FilterSelect, SearchField, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ChevronRight, CircleAlert, Info, ReceiptText, RefreshCw } from "lucide-react";
import { useId, useState } from "react";

import { listRefunds, type RefundSource, type RefundStatus, type RefundSummary } from "../../lib/payment/payment-api";
import { formatVnd, moment, REFUND_SOURCE, REFUND_STATUS, REFUND_STATUS_ORDER, refundAction, refundNote } from "../../lib/payment/payment-format";
import { RefundDialog } from "./refund-dialog";

const COLUMNS = ["w-[17%]", "w-[12%]", "w-[17%]", "w-[13%]", "w-[11%]", "w-[16%]", "w-[8%]", "w-[6%]"];
const HEADINGS = ["Mã hoàn tiền", "Đơn đặt vé", "Nhà xe", "Nguồn", "Số tiền hoàn", "Trạng thái", "Cập nhật", ""];
const VND = new Intl.NumberFormat("vi-VN");

/**
 * Danh sách hoàn tiền (Figma ADM-07c): hoàn theo chính sách lưu lúc đặt được xử lý tự động; yêu cầu lỗi cổng về đây để Admin
 * gửi lại cổng hoặc ghi nhận đã hoàn ngoài cổng (hộp thoại). Lọc khoảng ngày / nguồn / trạng thái, tìm mã hoàn hoặc mã đặt vé.
 */
export function RefundList() {
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [source, setSource] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const [search, setSearch] = useState("");
  const [openId, setOpenId] = useState<string | null>(null);
  const q = useDebouncedValue(search.trim());
  const fromId = useId();
  const toId = useId();
  const refunds = useInfiniteQuery({
    queryKey: ["admin-refunds", from, to, source, status, q],
    queryFn: ({ pageParam }) =>
      listRefunds({
        from: from || undefined,
        to: to || undefined,
        source: source === ALL ? undefined : (source as RefundSource),
        status: status === ALL ? undefined : (status as RefundStatus),
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = refunds.data?.pages.flatMap((page) => page.items) ?? [];
  const total = refunds.data?.pages[0]?.total ?? 0;
  const filtered = from !== "" || to !== "" || source !== ALL || status !== ALL || q !== "";
  const rangeInvalid = from !== "" && to !== "" && from > to;

  let body;
  if (rangeInvalid) {
    body = <ListStatePanel icon={<CircleAlert className="size-6 text-warning-700" />} title="Khoảng ngày không hợp lệ" description="Ngày bắt đầu phải trước hoặc bằng ngày kết thúc." />;
  } else if (refunds.isPending) {
    body = <TableSkeleton label="Đang tải yêu cầu hoàn tiền" rows={6} />;
  } else if (refunds.isError && !refunds.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được yêu cầu hoàn tiền"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void refunds.refetch()}>
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
        title={filtered ? "Không có yêu cầu phù hợp" : "Chưa có yêu cầu hoàn tiền"}
        description={filtered ? "Đổi khoảng ngày, nguồn, trạng thái hoặc từ khóa để xem yêu cầu khác." : "Yêu cầu hoàn tiền hiện ở đây khi hành khách hủy vé có hoàn tiền."}
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setFrom("");
                setTo("");
                setSource(ALL);
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
        <table className={`${TABLE} min-w-[900px]`}>
          <colgroup>
            {COLUMNS.map((width, index) => (
              <col key={index} className={width} />
            ))}
          </colgroup>
          <thead>
            <tr className={TABLE_HEAD_ROW}>
              {HEADINGS.map((heading, index) => (
                <th key={index} scope="col" className={`${TABLE_HEAD_CELL} ${index === 4 ? "text-right" : ""}`}>
                  {heading}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {items.map((item) => (
              <RefundRow key={item.refundId} item={item} onOpen={() => setOpenId(item.refundId)} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      <section aria-label="Yêu cầu hoàn tiền" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <div className="flex w-44 flex-col gap-1.5">
            <label htmlFor={fromId} className="text-xs leading-[18px] font-medium text-muted-foreground">
              Từ ngày
            </label>
            <Input id={fromId} type="date" value={from} onChange={(event) => setFrom(event.target.value)} />
          </div>
          <div className="flex w-44 flex-col gap-1.5">
            <label htmlFor={toId} className="text-xs leading-[18px] font-medium text-muted-foreground">
              Đến ngày
            </label>
            <Input id={toId} type="date" value={to} onChange={(event) => setTo(event.target.value)} />
          </div>
          <FilterSelect
            label="Nguồn yêu cầu"
            allLabel="Tất cả"
            value={source}
            onChange={setSource}
            options={(Object.keys(REFUND_SOURCE) as RefundSource[]).map((value) => ({ value, label: REFUND_SOURCE[value] }))}
            className="w-48"
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả"
            value={status}
            onChange={setStatus}
            options={REFUND_STATUS_ORDER.map((value) => ({ value, label: REFUND_STATUS[value].label }))}
            className="w-44"
          />
          <SearchField value={search} onChange={setSearch} placeholder="Mã hoàn tiền hoặc mã đặt vé" />
        </div>
        {body}
        {items.length > 0 && !rangeInvalid && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={refunds.hasNextPage}
              loading={refunds.isFetchingNextPage}
              failed={refunds.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${VND.format(total)} yêu cầu`}
              endText={`Đã hiển thị tất cả ${VND.format(items.length)} yêu cầu`}
              errorText="Chưa tải thêm được yêu cầu. Các yêu cầu đã tải vẫn được giữ lại."
              onLoadMore={() => void refunds.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
        <Info className="size-[18px] shrink-0" aria-hidden />
        Hoàn tiền theo chính sách lưu lúc đặt được xử lý tự động. Yêu cầu lỗi cổng chuyển về đây để Admin gửi lại cổng hoặc ghi nhận đã hoàn ngoài cổng.
      </div>
      <RefundDialog refundId={openId} onClose={() => setOpenId(null)} />
    </>
  );
}

function RefundRow({ item, onOpen }: { item: RefundSummary; onOpen: () => void }) {
  const status = REFUND_STATUS[item.status];
  const note = refundNote(item);
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} font-semibold text-vxn-ink`}>{item.refundCode}</td>
      <td className={TABLE_CELL}>{item.bookingCode}</td>
      <td className={`${TABLE_CELL} truncate font-medium`}>{item.operatorName}</td>
      <td className={TABLE_CELL}>{REFUND_SOURCE[item.source]}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.amount)}</td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
        {note && <p className="mt-1 truncate text-xs leading-[18px] text-muted-foreground">{note}</p>}
      </td>
      <td className={`${TABLE_CELL} tabular-nums`}>{moment(item.updatedAt)}</td>
      <td className={`${TABLE_CELL} text-right`}>
        <button type="button" onClick={onOpen} className="inline-flex items-center gap-1 font-semibold text-vxn-ink hover:underline" aria-label={`${refundAction(item.status)} ${item.refundCode}`}>
          {refundAction(item.status)}
          <ChevronRight className="size-4" aria-hidden />
        </button>
      </td>
    </tr>
  );
}
