"use client";

import { useInfiniteQuery, useQuery, useQueryClient } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { TableSkeleton } from "@vexenhanh/ui/components/list-controls";
import { BUTTON, ListLoadMoreFooter } from "@vexenhanh/ui/components/list-parts";
import { CircleCheck, Eye, Lock, LockOpen, Sparkles } from "lucide-react";
import Link from "next/link";
import { useState } from "react";

import { getPassenger, listPassengerBookings, type PassengerBooking, type PassengerDetail } from "../../lib/operation/operation-api";
import { BOOKING_STATUS, count, TICKET_STATUS, tripTime } from "../../lib/operation/operation-format";
import { formatVnd } from "../../lib/payment/payment-format";
import { lockPassenger, unlockPassenger } from "../../lib/user/user-api";
import { ACCOUNT_STATUS, formatDate, formatDateTime, PROVIDER_LABELS } from "../../lib/user/user-format";
import { Card, DetailHeader, DetailShell, detailState, retryUnlessFinal, Row, Rows, Stat } from "../operation/detail-parts";
import { AccountActionDialog, type AccountAction } from "./account-dialogs";

const BACK = { href: "/users", label: "Quay lại danh sách tài khoản hành khách" };

/**
 * Chi tiết tài khoản hành khách (tự thiết kế 28/10/2026, chờ duyệt; chưa có Figma): thông tin tài khoản (SĐT che), số đơn /
 * vé, điểm VXN Plus (sổ điểm + điều chỉnh ở VXN Plus), đơn đặt vé kèm người đi trên từng vé. Chỉ tài khoản — khách vãng lai
 * tra theo đơn ở Giao dịch hoặc chi tiết chuyến. Mỗi lượt mở trang được ghi nhật ký audit.
 */
export function PassengerDetailScreen({ passengerId }: { passengerId: string }) {
  // Không giữ bộ nhớ đệm: mỗi lần mở là một lượt xem có ghi nhật ký.
  const passenger = useQuery({ queryKey: ["admin-passenger", passengerId], queryFn: () => getPassenger(passengerId), retry: retryUnlessFinal, gcTime: 0 });
  return <DetailShell back={BACK}>{detailState(passenger, "hành khách") ?? <PassengerBody passenger={passenger.data!} />}</DetailShell>;
}

function PassengerBody({ passenger }: { passenger: PassengerDetail }) {
  const queryClient = useQueryClient();
  const can = useCan();
  const showMoney = can("payment:monitor");
  const [action, setAction] = useState<AccountAction | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const status = ACCOUNT_STATUS[passenger.status];
  const label = passenger.name ?? "Chưa có họ tên";
  const refresh = () => {
    void queryClient.invalidateQueries({ queryKey: ["admin-passenger", passenger.id] });
    void queryClient.invalidateQueries({ queryKey: ["admin-passengers"] });
  };

  function lock() {
    setAction({
      title: "Khóa tài khoản hành khách",
      subtitle: `${label} · ${passenger.email}`,
      warning: "Hành khách không đăng nhập được nữa và mọi phiên đăng nhập bị thu hồi. Vé đã đặt giữ nguyên.",
      withReason: true,
      confirmLabel: "Khóa tài khoản",
      destructive: true,
      run: (reason) => lockPassenger(passenger.id, reason),
      done: `Đã khóa tài khoản ${passenger.email}.`
    });
  }

  function unlock() {
    setAction({
      title: "Mở khóa tài khoản hành khách",
      subtitle: `${label} · ${passenger.email}`,
      note: "Hành khách đăng nhập lại được bằng email OTP hoặc tài khoản mạng xã hội đã liên kết.",
      withReason: false,
      confirmLabel: "Mở khóa",
      run: () => unlockPassenger(passenger.id),
      done: `Đã mở khóa tài khoản ${passenger.email}.`
    });
  }

  return (
    <>
      <DetailHeader
        title={label}
        badges={<Badge tone={status.tone}>{status.label}</Badge>}
        subtitle={`${passenger.email} · đăng ký ngày ${formatDate(passenger.createdAt)}`}
        actions={
          passenger.status === "LOCKED" ? (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={unlock}>
              <LockOpen className="size-[18px]" />
              Mở khóa
            </Button>
          ) : (
            <Button variant="destructive" className={BUTTON} onClick={lock}>
              <Lock className="size-[18px]" />
              Khóa tài khoản
            </Button>
          )
        }
      />
      {notice && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          {notice}
        </div>
      )}
      {passenger.status === "LOCKED" && passenger.lockedReason && (
        <div role="note" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-700">
          Khóa từ {formatDate(passenger.lockedAt)}: {passenger.lockedReason}
        </div>
      )}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Đơn đặt vé" value={count(passenger.bookingCount)} />
        <Stat label="Vé còn hiệu lực / đã đi" value={count(passenger.ticketCount)} note="Không tính vé đã hủy, đã hoàn" />
        {showMoney && <Stat label="Tổng đã thanh toán" value={passenger.totalPaid === null ? "—" : formatVnd(passenger.totalPaid)} />}
        <Stat label="Yêu cầu hỗ trợ" value={count(passenger.supportTicketCount)} />
      </div>
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_380px]">
        <Card
          title="Thông tin tài khoản"
          actions={
            <span className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
              <Eye className="size-4" />
              Lượt xem được ghi nhật ký
            </span>
          }
        >
          <Rows>
            <Row label="Email" value={`${passenger.email}${passenger.emailVerified ? "" : " (chưa xác minh)"}`} />
            <Row label="Số điện thoại" value={passenger.phone ?? "Chưa khai"} />
            <Row label="Đăng nhập bằng" value={passenger.providers.map((provider) => PROVIDER_LABELS[provider] ?? provider).join(", ")} />
            <Row label="Hoạt động gần nhất" value={formatDateTime(passenger.lastLoginAt)} />
            <Row label="Hành khách thường đi đã lưu" value={count(passenger.savedPassengerCount)} />
          </Rows>
        </Card>
        <Card title="VXN Plus" description="Hạng, sổ điểm và điều chỉnh điểm ở mục VXN Plus.">
          <div className="flex items-center gap-3">
            <span aria-hidden className="flex size-10 items-center justify-center rounded-full bg-accent text-accent-foreground">
              <Sparkles className="size-5" />
            </span>
            <div className="flex flex-col">
              <span className="text-lg leading-7 font-semibold text-vxn-ink">
                {passenger.loyaltyPoints === null ? "Chưa tham gia" : `${count(passenger.loyaltyPoints)} điểm khả dụng`}
              </span>
              <span className="text-xs leading-[18px] text-muted-foreground">Chỉ đơn đặt khi đã đăng nhập mới tích điểm.</span>
            </div>
          </div>
          {can("loyalty:manage") && (
            <Button asChild variant="outline" className={`${BUTTON} w-fit bg-card`}>
              <Link href={`/loyalty?tab=members&email=${encodeURIComponent(passenger.email)}`}>Mở sổ điểm</Link>
            </Button>
          )}
        </Card>
      </div>
      <BookingHistory passengerId={passenger.id} showMoney={showMoney} canOpenPayment={can("payment:monitor")} />
      <AccountActionDialog
        action={action}
        onClose={() => setAction(null)}
        onDone={(message) => {
          setNotice(message);
          refresh();
        }}
        onStale={refresh}
      />
    </>
  );
}

function BookingHistory({ passengerId, showMoney, canOpenPayment }: { passengerId: string; showMoney: boolean; canOpenPayment: boolean }) {
  const pages = useInfiniteQuery({
    queryKey: ["admin-passenger-bookings", passengerId],
    queryFn: ({ pageParam }) => listPassengerBookings(passengerId, pageParam),
    initialPageParam: null as string | null,
    getNextPageParam: (last) => last.nextCursor
  });
  const rows = pages.data?.pages.flatMap((page) => page.items) ?? [];
  const total = pages.data?.pages[0]?.total ?? 0;
  return (
    <Card title="Đơn đặt vé" description="Mới đặt trước. Mỗi vé là một người đi — người đặt có thể không đi.">
      {pages.isPending ? (
        <TableSkeleton label="Đang tải đơn đặt vé" rows={3} />
      ) : pages.isError && rows.length === 0 ? (
        <p className="text-sm leading-5 text-warning-700">Không tải được đơn đặt vé. Tải lại trang để thử lại.</p>
      ) : rows.length === 0 ? (
        <p className="text-sm leading-5 text-muted-foreground">Tài khoản chưa có đơn đặt vé.</p>
      ) : (
        <>
          <ul className="flex flex-col divide-y">
            {rows.map((booking) => (
              <BookingRow key={booking.id} booking={booking} showMoney={showMoney} canOpenPayment={canOpenPayment} />
            ))}
          </ul>
          <ListLoadMoreFooter
            hasMore={pages.hasNextPage}
            loading={pages.isFetchingNextPage}
            failed={pages.isFetchNextPageError}
            loadedText={`Đã tải ${rows.length} / ${count(total)} đơn`}
            endText={`Đã hiện tất cả ${rows.length} đơn`}
            errorText="Không tải thêm được đơn. Kiểm tra kết nối rồi thử lại."
            onLoadMore={() => void pages.fetchNextPage()}
          />
        </>
      )}
    </Card>
  );
}

function BookingRow({ booking, showMoney, canOpenPayment }: { booking: PassengerBooking; showMoney: boolean; canOpenPayment: boolean }) {
  const status = BOOKING_STATUS[booking.status] ?? { label: booking.status, tone: "neutral" as const };
  return (
    <li className="flex flex-col gap-2 py-4 first:pt-0">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="flex min-w-0 flex-col gap-0.5">
          <span className="flex flex-wrap items-center gap-2">
            <span className="font-semibold text-vxn-ink">{booking.bookingCode}</span>
            <Badge tone={status.tone}>{status.label}</Badge>
          </span>
          <span className="text-sm leading-5 text-vxn-fg-1">
            <Link href={`/routes/trips/${booking.tripId}`} className="text-primary hover:underline">
              {booking.routeName} · {tripTime(booking.departureAt)}
            </Link>
            {" · "}
            <Link href={`/operators/${booking.operatorId}`} className="hover:underline">
              {booking.operatorName}
            </Link>
          </span>
          <span className="text-xs leading-[18px] text-muted-foreground">Đặt lúc {formatDateTime(booking.createdAt)}</span>
        </div>
        <div className="flex flex-col items-end gap-1">
          {showMoney && booking.total !== null && <span className="font-semibold text-vxn-ink tabular-nums">{formatVnd(booking.total)}</span>}
          {canOpenPayment && booking.paymentId && (
            <Link href={`/payments/${booking.paymentId}`} className="text-xs leading-[18px] font-medium text-primary hover:underline">
              Xem giao dịch
            </Link>
          )}
        </div>
      </div>
      <ul className="flex flex-wrap gap-2">
        {booking.passengers.map((passenger) => {
          const ticket = passenger.ticketStatus ? TICKET_STATUS[passenger.ticketStatus] : null;
          return (
            <li key={passenger.seatCode} className="flex items-center gap-2 rounded-lg bg-muted px-3 py-1.5 text-xs leading-[18px]">
              <span className="font-semibold text-vxn-ink">{passenger.seatCode}</span>
              <span className="text-vxn-fg-1">{passenger.fullName}</span>
              {ticket && <Badge tone={ticket.tone}>{ticket.label}</Badge>}
            </li>
          );
        })}
      </ul>
    </li>
  );
}
