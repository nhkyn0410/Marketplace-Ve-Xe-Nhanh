"use client";

import { useInfiniteQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { ALL, FilterSelect, SearchField, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { ChevronRight, CircleAlert, CircleCheck, CreditCard, Info, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useId, useState } from "react";

import { listPayments, type PaymentProvider, type PaymentStatus, type PaymentSummary } from "../../lib/payment/payment-api";
import { formatVnd, moment, PAYMENT_STATUS, PAYMENT_STATUS_ORDER, paymentNote, PROVIDER_LABEL } from "../../lib/payment/payment-format";

const COLUMNS = ["w-[18%]", "w-[12%]", "w-[17%]", "w-[8%]", "w-[12%]", "w-[15%]", "w-[11%]", "w-[7%]"];
const HEADINGS = ["Mã thanh toán", "Đơn đặt vé", "Nhà xe", "Cổng", "Số tiền", "Trạng thái", "Thời gian", ""];
const VND = new Intl.NumberFormat("vi-VN");

/**
 * Danh sách giao dịch thanh toán (Figma ADM-07a): lọc khoảng ngày tạo / cổng / trạng thái, tìm mã thanh toán, mã đặt vé hoặc
 * mã giao dịch cổng. `reconcile` = tab "Cần đối soát": chỉ thanh toán cổng đã trừ tiền mà chưa có hướng xử lý.
 */
export function PaymentList({ mode }: { mode: "all" | "reconcile" }) {
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [provider, setProvider] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const fromId = useId();
  const toId = useId();
  const reconcile = mode === "reconcile";
  const payments = useInfiniteQuery({
    queryKey: ["admin-payments", mode, from, to, provider, status, q],
    queryFn: ({ pageParam }) =>
      listPayments({
        from: from || undefined,
        to: to || undefined,
        provider: provider === ALL ? undefined : (provider as PaymentProvider),
        status: reconcile || status === ALL ? undefined : (status as PaymentStatus),
        reconcile: reconcile ? "open" : undefined,
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor
  });
  const items = payments.data?.pages.flatMap((page) => page.items) ?? [];
  const total = payments.data?.pages[0]?.total ?? 0;
  const filtered = from !== "" || to !== "" || provider !== ALL || status !== ALL || q !== "";
  const rangeInvalid = from !== "" && to !== "" && from > to;

  let body;
  if (rangeInvalid) {
    body = <ListStatePanel icon={<CircleAlert className="size-6 text-warning-700" />} title="Khoảng ngày không hợp lệ" description="Ngày bắt đầu phải trước hoặc bằng ngày kết thúc." />;
  } else if (payments.isPending) {
    body = <TableSkeleton label="Đang tải giao dịch" rows={6} />;
  } else if (payments.isError && !payments.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được giao dịch"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void payments.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={reconcile && !filtered ? <CircleCheck className="size-6 text-success-600" /> : <CreditCard className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có giao dịch phù hợp" : reconcile ? "Không có khoản cần đối soát" : "Chưa có giao dịch"}
        description={
          filtered
            ? "Đổi khoảng ngày, cổng, trạng thái hoặc từ khóa để xem giao dịch khác."
            : reconcile
              ? "Thanh toán bị cổng trừ tiền nhưng không nhận vào đơn (đơn hết hạn, ghế đã nhả, trả trùng) sẽ hiện ở đây."
              : "Giao dịch qua VNPay / MoMo hiện ở đây khi hành khách thanh toán đơn đặt vé."
        }
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setFrom("");
                setTo("");
                setProvider(ALL);
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
              <PaymentRow key={item.paymentId} item={item} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  return (
    <>
      <section aria-label={reconcile ? "Thanh toán cần đối soát" : "Giao dịch thanh toán"} className="flex flex-col rounded-xl border bg-card p-6">
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
            label="Cổng thanh toán"
            allLabel="Tất cả"
            value={provider}
            onChange={setProvider}
            options={(Object.keys(PROVIDER_LABEL) as PaymentProvider[]).map((value) => ({ value, label: PROVIDER_LABEL[value] }))}
            className="w-40"
          />
          {!reconcile && (
            <FilterSelect
              label="Trạng thái"
              allLabel="Tất cả"
              value={status}
              onChange={setStatus}
              options={PAYMENT_STATUS_ORDER.map((value) => ({ value, label: PAYMENT_STATUS[value].label }))}
              className="w-44"
            />
          )}
          <SearchField value={search} onChange={setSearch} placeholder="Mã đặt vé, mã thanh toán, mã giao dịch cổng" />
        </div>
        {body}
        {items.length > 0 && !rangeInvalid && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={payments.hasNextPage}
              loading={payments.isFetchingNextPage}
              failed={payments.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} / ${VND.format(total)} giao dịch`}
              endText={`Đã hiển thị tất cả ${VND.format(items.length)} giao dịch`}
              errorText="Chưa tải thêm được giao dịch. Các giao dịch đã tải vẫn được giữ lại."
              onLoadMore={() => void payments.fetchNextPage()}
            />
          </div>
        )}
      </section>
      {reconcile && (
        <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-accent-foreground">
          <Info className="size-[18px] shrink-0" aria-hidden />
          Khách đã bị trừ tiền nhưng không nhận được vé. Mở giao dịch để hoàn toàn bộ cho khách; khoản lệch số tiền cần đối chiếu với cổng trước.
        </div>
      )}
    </>
  );
}

function PaymentRow({ item }: { item: PaymentSummary }) {
  const status = PAYMENT_STATUS[item.status];
  const note = paymentNote(item);
  const href = `/payments/${item.paymentId}`;
  return (
    <tr className="border-b last:border-b-0">
      <td className={`${TABLE_CELL} font-semibold`}>
        <Link href={href} className="text-vxn-ink hover:underline">
          {item.paymentCode}
        </Link>
      </td>
      <td className={TABLE_CELL}>{item.bookingCode}</td>
      <td className={`${TABLE_CELL} truncate font-medium`}>{item.operatorName}</td>
      <td className={TABLE_CELL}>{PROVIDER_LABEL[item.provider]}</td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.amount)}</td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
        {note && <p className="mt-1 truncate text-xs leading-[18px] text-muted-foreground">{note}</p>}
      </td>
      <td className={`${TABLE_CELL} tabular-nums`}>{moment(item.createdAt)}</td>
      <td className={`${TABLE_CELL} text-right`}>
        <Link href={href} className="inline-flex items-center gap-1 font-semibold text-vxn-ink hover:underline">
          {item.status === "RECONCILING" && !item.reconcileResolved ? "Xử lý" : "Xem"}
          <ChevronRight className="size-4" aria-hidden />
        </Link>
      </td>
    </tr>
  );
}
