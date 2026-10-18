"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { ArrowLeft, ArrowUpRight, CircleAlert, Eye, FileX2, Info, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { getBooking, revealContact, type BookingContact, type OperatorBookingDetail } from "../../lib/booking/booking-api";
import {
  BOOKING_STATUS,
  cancellationRows,
  describePrivacyError,
  displayCode,
  historyLine,
  paymentState,
  PROVIDER_LABEL,
  shortMoment,
  TICKET_STATUS
} from "../../lib/booking/booking-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { seatTypeInfo } from "../../lib/seat-map/seat-map-editor";
import { formatDay, formatTime, formatWeekdayDate } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON } from "../list-parts";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "../stop-point/list-controls";

/**
 * Chi tiết đơn đặt vé (Figma "Nhà xe · Đặt vé / 02 Chi tiết đơn"; TASK-OPR-003): vé trong đơn, chuyến + điểm đón / trả,
 * lịch sử trạng thái, liên hệ (che mặc định, "Hiện đầy đủ" ghi nhật ký), thanh toán, chính sách hủy lưu lúc đặt.
 * Nhà xe chỉ xem — hủy / hoàn vé theo luồng hoàn tiền (TASK-BTP-005).
 */
export function BookingDetail({ bookingId }: { bookingId: string }) {
  const booking = useQuery({ queryKey: ["operator-booking", bookingId], queryFn: () => getBooking(bookingId), retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2 });
  if (booking.error instanceof ApiError && booking.error.status === 404) {
    return (
      <Shell>
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy đơn"
          description="Đơn không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/bookings">Về danh sách đơn</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  if (booking.isError && !booking.data) {
    return (
      <Shell>
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được đơn"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void booking.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!booking.data) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải đơn" className="flex flex-col gap-6">
          <Skeleton className="h-16 w-2/3 rounded-xl" />
          <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
            <Skeleton className="h-[440px] rounded-xl" />
            <Skeleton className="h-[440px] rounded-xl" />
          </div>
        </div>
      </Shell>
    );
  }
  return <DetailBody booking={booking.data} />;
}

function DetailBody({ booking }: { booking: OperatorBookingDetail }) {
  const status = BOOKING_STATUS[booking.status];
  return (
    <Shell>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex flex-col gap-1.5">
          <h1 className="text-[32px] leading-10 font-semibold text-vxn-ink">Đơn {displayCode(booking.bookingCode)}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            Đặt lúc {formatTime(booking.createdAt)} · {formatDay(booking.createdAt)} · {booking.seats.length} vé
          </p>
        </div>
        <Badge tone={status.tone}>{status.label}</Badge>
      </header>
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Vé trong đơn">
            <div className="overflow-x-auto">
              <table className={`${TABLE} min-w-[600px]`}>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    {["Mã vé", "Hành khách", "Chỗ", "Trạng thái vé"].map((heading) => (
                      <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                        {heading}
                      </th>
                    ))}
                  </tr>
                </thead>
                <tbody>
                  {booking.seats.map((seat) => {
                    const ticket = seat.ticketStatus ? TICKET_STATUS[seat.ticketStatus] : null;
                    return (
                      <tr key={seat.seatCode} className="border-b last:border-b-0">
                        <td className={`${TABLE_CELL} font-semibold`}>{seat.ticketCode ? displayCode(seat.ticketCode) : "Chưa phát hành"}</td>
                        <td className={TABLE_CELL}>
                          <p className="truncate font-medium">{seat.passengerName}</p>
                          {seat.phoneMasked && <p className="text-xs leading-[18px] text-muted-foreground">{seat.phoneMasked}</p>}
                        </td>
                        <td className={TABLE_CELL}>
                          <p className="font-medium">{seat.seatCode}</p>
                          <p className="text-xs leading-[18px] text-muted-foreground">{seatTypeInfo(seat.seatType).label}</p>
                        </td>
                        <td className={TABLE_CELL}>{ticket ? <Badge tone={ticket.tone}>{ticket.label}</Badge> : <Badge>Chờ thanh toán</Badge>}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </Card>
          <Card
            title="Chuyến và điểm đón trả"
            action={
              <Link href={`/trips/${booking.trip.tripId}`} className="flex items-center gap-1.5 text-sm leading-5 font-semibold text-vxn-ink hover:underline">
                <ArrowUpRight className="size-4" aria-hidden />
                Mở chi tiết chuyến
              </Link>
            }
          >
            <dl className="grid gap-x-6 gap-y-4 sm:grid-cols-3">
              <Field label="Tuyến" value={booking.trip.routeName} />
              <Field label="Khởi hành" value={`${formatTime(booking.trip.departureAt)} · ${formatWeekdayDate(booking.trip.departureAt)}`} />
              <Field label="Xe" value={booking.trip.vehiclePlateNumber ? formatPlateNumber(booking.trip.vehiclePlateNumber) : "Chưa gắn xe"} />
            </dl>
            <dl className="mt-4 grid gap-x-6 gap-y-4 sm:grid-cols-2">
              <Field label="Điểm đón" value={`${booking.pickup.name} · ${formatTime(booking.pickup.plannedAt)}`} />
              <Field label="Điểm trả" value={`${booking.dropoff.name} · ${shortMoment(booking.dropoff.plannedAt)}`} />
            </dl>
          </Card>
          <Card title="Lịch sử trạng thái">
            <ol className="flex flex-col">
              {[...booking.histories].reverse().map((history, index) => {
                const line = historyLine(history, booking);
                return (
                  <li key={index} className="relative flex gap-4 pb-5 last:pb-0">
                    <span className="mt-1.5 size-2.5 shrink-0 rounded-full bg-vxn-teal-600" aria-hidden />
                    <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                      <p className="text-sm leading-5 font-semibold text-vxn-ink">{line.title}</p>
                      <p className="text-sm leading-5 text-muted-foreground">{line.note}</p>
                    </div>
                    <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={history.createdAt}>
                      {shortMoment(history.createdAt).split(" · ").reverse().join(" · ")}
                    </time>
                  </li>
                );
              })}
            </ol>
          </Card>
        </div>
        <div className="flex flex-col gap-6">
          <ContactCard booking={booking} />
          <PaymentCard booking={booking} />
          <Card title="Chính sách hủy / hoàn tiền" subtitle="Lưu tại thời điểm đặt">
            {booking.cancellationPolicy.tiers.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Chưa có chính sách hủy lúc đặt.</p>
            ) : (
              <dl className="flex flex-col gap-3">
                {cancellationRows(booking.trip.departureAt, booking.cancellationPolicy.tiers).map((row) => (
                  <Row key={row.when} label={row.when} value={row.refund} />
                ))}
              </dl>
            )}
            <Note>Nhà xe không duyệt hoàn tiền. Hoàn tiền do hệ thống xử lý theo chính sách này hoặc do Vé Xe Nhanh quyết định.</Note>
          </Card>
        </div>
      </div>
    </Shell>
  );
}

function ContactCard({ booking }: { booking: OperatorBookingDetail }) {
  const reveal = useMutation({ mutationFn: () => revealContact(booking.bookingId) });
  const contact: BookingContact | undefined = reveal.data;
  return (
    <Card
      title="Người liên hệ"
      action={
        !contact && (
          <Button variant="ghost" className="h-8 px-2 text-sm font-semibold" disabled={reveal.isPending} onClick={() => reveal.mutate()}>
            {reveal.isPending ? <LoaderCircle className="size-4 animate-spin" /> : <Eye className="size-4" />}
            Hiện đầy đủ
          </Button>
        )
      }
    >
      <dl className="flex flex-col gap-3">
        <Row label="Họ tên" value={booking.contactName} />
        <Row label="Số điện thoại" value={contact?.phone ?? booking.contactPhoneMasked} />
        <Row label="Email" value={contact?.email ?? booking.contactEmailMasked} />
        <Row label="Ghi chú" value={booking.note ?? "Không có"} />
        {contact?.passengers
          .filter((passenger) => passenger.phone)
          .map((passenger) => <Row key={passenger.seatCode} label={`SĐT hành khách ${passenger.seatCode}`} value={passenger.phone!} />)}
      </dl>
      {reveal.isError && (
        <p role="alert" className="mt-3 text-sm leading-5 text-error-600">
          {describePrivacyError(reveal.error)}
        </p>
      )}
      {booking.guest && <Note>Khách vãng lai — không có tài khoản Vé Xe Nhanh.</Note>}
    </Card>
  );
}

function PaymentCard({ booking }: { booking: OperatorBookingDetail }) {
  const payment = paymentState(booking.payment);
  return (
    <Card title="Thanh toán">
      <dl className="flex flex-col gap-3">
        <Row label={`Giá vé (${booking.seats.length} chỗ)`} value={formatVnd(booking.subtotal)} strong />
        <Row label="Phí dịch vụ" value={formatVnd(booking.serviceFee)} />
        {booking.discount > 0 && <Row label="Giảm giá" value={`−${formatVnd(booking.discount)}`} />}
        <Row label="Khách thanh toán" value={formatVnd(booking.total)} strong />
      </dl>
      <div className="mt-4 flex items-center justify-between gap-3 border-t pt-4">
        <span className="text-sm leading-5 text-muted-foreground">
          Trạng thái thanh toán{booking.payment ? ` · ${PROVIDER_LABEL[booking.payment.provider]}` : ""}
        </span>
        <Badge tone={payment.tone}>{payment.label}</Badge>
      </div>
      <Note>Doanh thu và hoa hồng của nhà xe tính trên giá vé; tiền về nhà xe theo kỳ đối soát (T+3).</Note>
    </Card>
  );
}

function Card({ title, subtitle, action, children }: { title: string; subtitle?: string; action?: ReactNode; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col rounded-xl border bg-card p-6">
      <div className="mb-5 flex items-start justify-between gap-3">
        <div className="flex flex-col gap-0.5">
          <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
          {subtitle && <p className="text-xs leading-[18px] text-muted-foreground">{subtitle}</p>}
        </div>
        {action}
      </div>
      {children}
    </section>
  );
}

function Field({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex min-w-0 flex-col gap-1">
      <dt className="text-xs leading-[18px] text-muted-foreground">{label}</dt>
      <dd className="text-sm leading-5 font-medium text-vxn-fg-1">{value}</dd>
    </div>
  );
}

function Row({ label, value, strong = false }: { label: string; value: string; strong?: boolean }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className={`text-right text-sm leading-5 text-vxn-fg-1 ${strong ? "font-semibold" : "font-medium"}`}>{value}</dd>
    </div>
  );
}

function Note({ children }: { children: ReactNode }) {
  return (
    <p className="mt-4 flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-vxn-teal-700">
      <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
      <span>{children}</span>
    </p>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link
        href="/bookings"
        className="flex w-fit items-center gap-1.5 rounded text-sm leading-5 font-medium text-vxn-teal-700 outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
      >
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách đơn
      </Link>
      {children}
    </div>
  );
}

function StatePanel({ icon, title, description, action }: { icon: ReactNode; title: string; description: string; action: ReactNode }) {
  return (
    <div className="flex min-h-[440px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      <div className="mt-2">{action}</div>
    </div>
  );
}
