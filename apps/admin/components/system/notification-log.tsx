"use client";

import { keepPreviousData, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListStatePanel } from "@vexenhanh/ui/components/list-parts";
import { Bell, CircleAlert, RefreshCw } from "lucide-react";
import { useState } from "react";
import { getNotificationLog, NOTIFICATION_LOG_KEY, type NotificationLog } from "../../lib/notification/notification-api";
import { formatDateTime } from "../../lib/user/user-format";

type Delivery = NotificationLog["items"][number];
const PAGE_SIZE = 25;
const KIND: Record<Delivery["kind"], string> = {
  BOOKING_CONFIRMED: "Xác nhận đặt vé", TICKETS_CANCELLED: "Hủy vé", REFUND_SUCCEEDED: "Hoàn tiền thành công", TRIP_CHANGED: "Đổi chuyến", TRIP_CANCELLED: "Hủy chuyến", MANUAL_REFUND: "Hoàn tiền thủ công", CASE_UPDATED: "Cập nhật hồ sơ hỗ trợ", OPERATIONS_ALERT: "Cảnh báo vận hành", LOYALTY_UPDATED: "Cập nhật VXN Plus", PROMOTION: "Khuyến mãi",
};
const CHANNEL = { EMAIL: "Email", PUSH: "Thông báo đẩy", SMS: "SMS" };
const STATUS = { PENDING: { label: "Chờ gửi", tone: "warning" }, SENT: { label: "Đã gửi", tone: "success" }, FAILED: { label: "Gửi lỗi", tone: "danger" }, SKIPPED: { label: "Đã bỏ qua", tone: "neutral" } } as const;
const COUNT = new Intl.NumberFormat("vi-VN");

/** Nhật ký gửi thông báo giúp vận hành tra cứu kênh, kết quả, số lần thử và lỗi đã che dữ liệu nhạy cảm. */
export function NotificationLogPanel() {
  const [offset, setOffset] = useState(0);
  const query = useQuery({ queryKey: [...NOTIFICATION_LOG_KEY, offset], queryFn: () => getNotificationLog(offset, PAGE_SIZE), placeholderData: keepPreviousData });
  const data = query.data;
  return <section aria-label="Nhật ký gửi thông báo" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
    <div><h2 className="text-lg font-semibold">Nhật ký gửi thông báo</h2><p className="mt-1 text-sm text-muted-foreground">Theo dõi email và thông báo đẩy theo từng bản gửi. Địa chỉ người nhận được che.</p></div>
    {!data ? query.isError ? <ListStatePanel compact icon={<CircleAlert className="size-6 text-warning-700" />} title="Không tải được nhật ký thông báo" description="Kiểm tra kết nối mạng rồi thử lại." action={<Button className={BUTTON} onClick={() => void query.refetch()}><RefreshCw className="size-4" />Thử lại</Button>} /> : <TableSkeleton label="Đang tải nhật ký thông báo" /> : data.items.length === 0 ? <ListStatePanel compact icon={<Bell className="size-6 text-vxn-fg-3" />} title="Chưa có bản gửi thông báo" description="Khi có thông báo được xếp hàng, kết quả gửi sẽ xuất hiện tại đây." /> : <div className="overflow-x-auto" aria-busy={query.isFetching}>
      <table className={`${TABLE} min-w-[1100px]`}><thead><tr className={TABLE_HEAD_ROW}>{["Thông báo", "Người nhận", "Kênh", "Kết quả", "Số lần thử", "Tạo lúc", "Gửi lúc", "Chi tiết lỗi"].map((heading) => <th scope="col" key={heading} className={TABLE_HEAD_CELL}>{heading}</th>)}</tr></thead><tbody>{data.items.map((item) => <tr key={item.id} className="border-b last:border-b-0">
        <td className={`${TABLE_CELL} font-medium`}>{KIND[item.kind]}</td><td className={TABLE_CELL}>{item.recipientMasked}</td><td className={TABLE_CELL}>{CHANNEL[item.channel]}</td><td className={TABLE_CELL}><Badge tone={STATUS[item.status].tone}>{STATUS[item.status].label}</Badge></td><td className={`${TABLE_CELL} text-right tabular-nums`}>{COUNT.format(item.attempts)}</td><td className={`${TABLE_CELL} whitespace-nowrap`}>{formatDateTime(item.createdAt)}</td><td className={`${TABLE_CELL} whitespace-nowrap`}>{item.sentAt ? formatDateTime(item.sentAt) : "—"}</td><td className={`${TABLE_CELL} max-w-80 whitespace-pre-wrap break-words text-xs text-muted-foreground`}>{item.lastError ?? "—"}</td>
      </tr>)}</tbody></table>
    </div>}
    {data && <div className="flex flex-wrap items-center justify-between gap-3 text-sm text-muted-foreground"><p>{data.total ? `${COUNT.format(data.offset + 1)}–${COUNT.format(data.offset + data.items.length)} / ${COUNT.format(data.total)} bản gửi` : "0 bản gửi"}</p><div className="flex gap-2"><Button variant="outline" disabled={offset === 0 || query.isFetching} onClick={() => setOffset(Math.max(0, offset - PAGE_SIZE))}>Trang trước</Button><Button variant="outline" disabled={offset + PAGE_SIZE >= data.total || query.isFetching} onClick={() => setOffset(offset + PAGE_SIZE)}>Trang sau</Button></div></div>}
    {query.isError && data && <p role="alert" className="text-sm text-error-600">Chưa tải được dữ liệu mới. <button type="button" className="underline" onClick={() => void query.refetch()}>Thử lại</button></p>}
  </section>;
}
