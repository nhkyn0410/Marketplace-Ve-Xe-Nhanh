"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { CalendarX2, ChevronRight, CircleAlert, Lock, RefreshCw, Users } from "lucide-react";
import Link from "next/link";
import { useId, useState } from "react";

import { listBookings, type BookingStatus, type OperatorBooking } from "../../lib/booking/booking-api";
import { BOOKING_STATUS, BOOKING_STATUS_ORDER, displayCode, paymentState, shortMoment, ticketSummary } from "../../lib/booking/booking-format";
import { formatVnd } from "../../lib/fare/fare-format";
import { listTrips } from "../../lib/trip/trip-api";
import { formatTime, fromLocalParts, nextLocalDate, todayLocalDate } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
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

// Độ rộng cột theo Figma (bảng rộng 1086): mã / liên hệ / chuyến / vé / giá / thanh toán / trạng thái / xem.
const COLUMNS = ["w-[12%]", "w-[17%]", "w-[19%]", "w-[9%]", "w-[10%]", "w-[13%]", "w-[13%]", "w-[7%]"];
const HEADINGS = ["Mã đặt vé", "Khách liên hệ", "Chuyến", "Vé", "Giá vé", "Thanh toán", "Trạng thái đơn", ""];

/**
 * Màn Đặt vé — danh sách đơn (Figma "Nhà xe · Đặt vé / 01 Danh sách đơn"; TASK-OPR-003, FR-OPS-14): đơn của các chuyến
 * khởi hành trong ngày, lọc chuyến / trạng thái, tìm theo mã đặt vé, mã vé, số điện thoại hoặc tên. Số điện thoại che mặc
 * định — xem đầy đủ ở chi tiết đơn (ghi nhật ký).
 */
export function BookingList() {
  const [date, setDate] = useState(todayLocalDate());
  const [tripId, setTripId] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const validDate = /^\d{4}-\d{2}-\d{2}$/.test(date);
  const trips = useQuery({
    queryKey: ["trips", "day", date],
    queryFn: () => listTrips({ departureFrom: fromLocalParts(date, "00:00"), departureTo: fromLocalParts(nextLocalDate(date), "00:00") }),
    enabled: validDate
  });
  const bookings = useInfiniteQuery({
    queryKey: ["operator-bookings", date, tripId, status, q],
    queryFn: ({ pageParam }) =>
      listBookings({
        date,
        tripId: tripId === ALL ? undefined : tripId,
        status: status === ALL ? undefined : (status as BookingStatus),
        q: q || undefined,
        cursor: pageParam ?? undefined
      }),
    initialPageParam: null as string | null,
    getNextPageParam: (page) => page.nextCursor,
    enabled: validDate
  });
  const items = bookings.data?.pages.flatMap((page) => page.items) ?? [];
  const filtered = tripId !== ALL || status !== ALL || q !== "";
  const changeDate = (value: string) => {
    setDate(value);
    setTripId(ALL);
  };

  let body;
  if (!validDate) {
    body = <ListStatePanel icon={<CalendarX2 className="size-6 text-vxn-fg-3" />} title="Chọn ngày đi" description="Chọn ngày khởi hành để xem các đơn đặt vé." compact />;
  } else if (bookings.isPending) {
    body = <TableSkeleton label="Đang tải đơn đặt vé" rows={6} />;
  } else if (bookings.isError && !bookings.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được đơn đặt vé"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void bookings.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (items.length === 0) {
    body = (
      <ListStatePanel
        icon={<CalendarX2 className="size-6 text-vxn-fg-3" />}
        title={filtered ? "Không có đơn phù hợp" : "Chưa có đơn đặt vé"}
        description={
          filtered
            ? "Đổi chuyến, trạng thái hoặc từ khóa, hoặc bỏ lọc để xem mọi đơn trong ngày."
            : "Chưa có hành khách đặt vé cho các chuyến khởi hành ngày này. Chọn ngày khác để xem."
        }
        action={
          filtered ? (
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => {
                setTripId(ALL);
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
        <table className={`${TABLE} min-w-[1040px]`}>
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
              <BookingRow key={item.bookingId} item={item} />
            ))}
          </tbody>
        </table>
      </div>
    );
  }

  const manifestHref = tripId === ALL ? `/bookings/passengers?date=${date}` : `/bookings/passengers?tripId=${tripId}`;
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Đặt vé"
        description="Đơn đặt vé và vé thuộc các chuyến của nhà xe."
        actions={
          <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
            <Link href={manifestHref}>
              <Users className="size-[18px]" />
              Danh sách hành khách theo chuyến
            </Link>
          </Button>
        }
      />
      <section aria-label="Đơn đặt vé" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <DateField value={date} onChange={changeDate} />
          <FilterSelect
            label="Chuyến"
            allLabel="Tất cả chuyến"
            value={tripId}
            onChange={setTripId}
            disabled={!validDate}
            options={(trips.data?.items ?? []).map((trip) => ({ value: trip.id, label: `${formatTime(trip.departureAt)} · ${trip.routeName}` }))}
          />
          <FilterSelect
            label="Trạng thái đơn"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={BOOKING_STATUS_ORDER.map((value) => ({ value, label: BOOKING_STATUS[value].label }))}
          />
          <SearchField value={search} onChange={setSearch} placeholder="Mã đặt vé, mã vé hoặc SĐT" />
        </div>
        {body}
        {items.length > 0 && (
          <div className="flex pt-5">
            <ListLoadMoreFooter
              hasMore={bookings.hasNextPage}
              loading={bookings.isFetchingNextPage}
              failed={bookings.isFetchNextPageError}
              loadedText={`Đã tải ${items.length} đơn`}
              endText={`Đã hiển thị tất cả ${items.length} đơn`}
              errorText="Chưa tải thêm được đơn. Các đơn đã tải vẫn được giữ lại."
              onLoadMore={() => void bookings.fetchNextPage()}
            />
          </div>
        )}
      </section>
      <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700">
        <Lock className="size-[18px] shrink-0" aria-hidden />
        Số điện thoại hành khách được che mặc định. Việc xem đầy đủ hoặc xuất danh sách hành khách được ghi nhật ký.
      </div>
    </div>
  );
}

function DateField({ value, onChange }: { value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-52 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        Ngày đi
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

function BookingRow({ item }: { item: OperatorBooking }) {
  const tickets = ticketSummary(item);
  const payment = paymentState(item.payment);
  const status = BOOKING_STATUS[item.status];
  const muted = "text-xs leading-[18px] text-muted-foreground";
  return (
    <tr className="border-b last:border-b-0">
      <td className={TABLE_CELL}>
        <Link href={`/bookings/${item.bookingId}`} className="font-semibold text-vxn-ink hover:underline">
          {displayCode(item.bookingCode)}
        </Link>
        <p className={muted}>Đặt {shortMoment(item.createdAt).split(" · ").reverse().join(" · ")}</p>
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-medium">{item.contactName}</p>
        <p className={`${muted} truncate`}>
          {item.contactPhoneMasked}
          {item.guest ? " · Khách vãng lai" : ""}
        </p>
      </td>
      <td className={TABLE_CELL}>
        <p className="truncate font-medium">
          {shortMoment(item.trip.departureAt)} · {item.trip.routeName}
        </p>
        <p className={muted}>{item.trip.vehiclePlateNumber ? formatPlateNumber(item.trip.vehiclePlateNumber) : "Chưa gắn xe"}</p>
      </td>
      <td className={TABLE_CELL}>
        <p className="font-medium">{tickets.title}</p>
        <p className={`${muted} truncate`}>{tickets.note}</p>
      </td>
      <td className={`${TABLE_CELL} text-right font-semibold tabular-nums`}>{formatVnd(item.total)}</td>
      <td className={TABLE_CELL}>
        <Badge tone={payment.tone}>{payment.label}</Badge>
      </td>
      <td className={TABLE_CELL}>
        <Badge tone={status.tone}>{status.label}</Badge>
      </td>
      <td className={`${TABLE_CELL} text-right`}>
        <Link href={`/bookings/${item.bookingId}`} className="inline-flex items-center gap-1 font-semibold text-vxn-ink hover:underline">
          Xem
          <ChevronRight className="size-4" aria-hidden />
        </Link>
      </td>
    </tr>
  );
}
