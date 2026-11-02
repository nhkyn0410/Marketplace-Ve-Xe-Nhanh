"use client";

import { keepPreviousData, useMutation, useQuery } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { ArrowLeft, CalendarX2, CircleAlert, Download, FileX2, LoaderCircle, Printer, RefreshCw, Smartphone, Users } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useId, useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { downloadPassengerCsv, listTripPassengers, type TicketStatus, type TripPassengerList } from "../../lib/booking/booking-api";
import { describePrivacyError, displayCode, TICKET_STATUS, TICKET_STATUS_ORDER } from "../../lib/booking/booking-format";
import { listTrips } from "../../lib/trip/trip-api";
import { formatTime, formatWeekdayDate, fromLocalParts, nextLocalDate, todayLocalDate } from "../../lib/trip/trip-format";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListFooterNote, ListStatePanel } from "../list-parts";
import { ALL, FilterSelect, SearchField, TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW, TableSkeleton, useDebouncedValue } from "../stop-point/list-controls";

const COLUMNS = ["w-[7%]", "w-[19%]", "w-[12%]", "w-[18%]", "w-[18%]", "w-[14%]", "w-[12%]"];
const HEADINGS = ["Chỗ", "Hành khách", "Số điện thoại", "Điểm đón", "Điểm trả", "Mã vé", "Trạng thái vé"];

/**
 * Danh sách hành khách theo chuyến (Figma "Nhà xe · Đặt vé / 03"; TASK-OPR-003, FR-OPS-15): số liệu lên xe, lọc điểm đón /
 * trạng thái vé / tìm, in và xuất CSV (máy chủ ghi nhật ký mỗi lần xuất). Chưa chọn chuyến → chọn ngày + chuyến.
 */
export function TripPassengerListScreen() {
  const params = useSearchParams();
  const tripId = params.get("tripId");
  return (
    <div className="flex flex-col gap-6">
      <Link href="/bookings" className="flex w-fit items-center gap-1.5 text-sm leading-5 font-medium text-vxn-teal-700 hover:underline">
        <ArrowLeft className="size-[18px]" />
        Quay lại danh sách đơn
      </Link>
      {tripId ? <Manifest tripId={tripId} /> : <TripPicker initialDate={params.get("date") ?? todayLocalDate()} />}
    </div>
  );
}

function TripPicker({ initialDate }: { initialDate: string }) {
  const router = useRouter();
  const [date, setDate] = useState(initialDate);
  const validDate = /^\d{4}-\d{2}-\d{2}$/.test(date);
  const trips = useQuery({
    queryKey: ["trips", "day", date],
    queryFn: () => listTrips({ departureFrom: fromLocalParts(date, "00:00"), departureTo: fromLocalParts(nextLocalDate(date), "00:00") }),
    enabled: validDate
  });
  const id = useId();
  return (
    <>
      <header className="flex flex-col gap-1.5">
        <h1 className="text-[32px] leading-10 font-semibold text-vxn-ink">Danh sách hành khách</h1>
        <p className="text-sm leading-5 text-muted-foreground">Chọn chuyến để xem hành khách đã có vé.</p>
      </header>
      <section aria-label="Chọn chuyến" className="flex flex-col gap-5 rounded-xl border bg-card p-6">
        <div className="flex w-52 flex-col gap-1.5">
          <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
            Ngày đi
          </label>
          <Input id={id} type="date" value={date} onChange={(event) => setDate(event.target.value)} />
        </div>
        {trips.isPending && validDate ? (
          <TableSkeleton label="Đang tải chuyến" rows={3} />
        ) : (trips.data?.items ?? []).length === 0 ? (
          <ListStatePanel icon={<CalendarX2 className="size-6 text-vxn-fg-3" />} title="Không có chuyến trong ngày" description="Chọn ngày khác." compact />
        ) : (
          <ul className="flex flex-col divide-y rounded-lg border">
            {trips.data!.items.map((trip) => (
              <li key={trip.id}>
                <button
                  type="button"
                  onClick={() => router.push(`/bookings/passengers?tripId=${trip.id}`)}
                  className="flex w-full items-center justify-between gap-4 px-4 py-3 text-left text-sm leading-5 hover:bg-muted"
                >
                  <span className="font-semibold text-vxn-ink">
                    {formatTime(trip.departureAt)} · {trip.routeName}
                  </span>
                  <span className="text-muted-foreground">{trip.vehiclePlateNumber ? formatPlateNumber(trip.vehiclePlateNumber) : "Chưa gắn xe"}</span>
                </button>
              </li>
            ))}
          </ul>
        )}
      </section>
    </>
  );
}

function Manifest({ tripId }: { tripId: string }) {
  const [pickup, setPickup] = useState(ALL);
  const [status, setStatus] = useState(ALL);
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const list = useQuery({
    queryKey: ["trip-passengers", tripId, pickup, status, q],
    queryFn: () =>
      listTripPassengers(tripId, {
        pickupSequence: pickup === ALL ? undefined : Number(pickup),
        ticketStatus: status === ALL ? undefined : (status as TicketStatus),
        q: q || undefined
      }),
    placeholderData: keepPreviousData,
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  const exporter = useMutation({ mutationFn: () => downloadPassengerCsv(tripId) });

  if (list.error instanceof ApiError && list.error.status === 404) {
    return (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không tìm thấy chuyến"
        description="Chuyến không tồn tại hoặc không thuộc nhà xe của bạn."
        action={
          <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
            <Link href="/bookings/passengers">Chọn chuyến khác</Link>
          </Button>
        }
      />
    );
  }
  if (list.isError && !list.data) {
    return (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được danh sách hành khách"
        description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void list.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  }
  if (!list.data) {
    return <TableSkeleton label="Đang tải danh sách hành khách" rows={6} />;
  }
  const data = list.data;
  const filtered = pickup !== ALL || status !== ALL || q !== "";
  return (
    <>
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[32px] leading-10 font-semibold text-vxn-ink">Danh sách hành khách</h1>
          <p className="text-sm leading-5 text-muted-foreground">{tripLine(data.trip)}</p>
        </div>
        <div className="flex flex-wrap gap-3 print:hidden">
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => window.print()}>
            <Printer className="size-[18px]" />
            In danh sách
          </Button>
          <Button className={BUTTON} disabled={exporter.isPending} onClick={() => exporter.mutate()}>
            {exporter.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Download className="size-[18px]" />}
            Xuất danh sách
          </Button>
        </div>
      </header>
      {exporter.isError && (
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          {describePrivacyError(exporter.error)}
        </p>
      )}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Stat label="Chỗ đã bán" value={`${data.summary.sold} / ${data.trip.seatCount}`} note={`Còn ${Math.max(0, data.trip.seatCount - data.summary.sold)} chỗ chưa bán`} />
        <Stat label="Đã lên xe" value={String(data.summary.checkedIn)} />
        <Stat label="Chưa lên xe" value={String(data.summary.notBoarded)} />
        <Stat label="Vắng mặt" value={String(data.summary.noShow)} />
      </div>
      <section aria-label="Hành khách" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5 print:hidden">
          <FilterSelect
            label="Điểm đón"
            allLabel="Tất cả điểm đón"
            value={pickup}
            onChange={setPickup}
            options={data.pickups.map((stop) => ({ value: String(stop.sequence), label: stop.name }))}
          />
          <FilterSelect
            label="Trạng thái vé"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={TICKET_STATUS_ORDER.map((value) => ({ value, label: TICKET_STATUS[value].label }))}
          />
          <SearchField value={search} onChange={setSearch} label="Tìm hành khách" placeholder="Tên, mã vé hoặc SĐT" className="max-w-sm" />
        </div>
        {data.items.length === 0 ? (
          <ListStatePanel
            icon={<Users className="size-6 text-vxn-fg-3" />}
            title={filtered ? "Không có hành khách phù hợp" : "Chuyến chưa có hành khách"}
            description={filtered ? "Đổi bộ lọc hoặc từ khóa để xem hành khách khác." : "Hành khách hiện ở đây khi vé được phát hành (sau khi thanh toán thành công)."}
            compact
          />
        ) : (
          <div className="overflow-x-auto">
            <table className={`${TABLE} min-w-[1000px]`}>
              <colgroup>
                {COLUMNS.map((width, index) => (
                  <col key={index} className={width} />
                ))}
              </colgroup>
              <thead>
                <tr className={TABLE_HEAD_ROW}>
                  {HEADINGS.map((heading) => (
                    <th key={heading} scope="col" className={TABLE_HEAD_CELL}>
                      {heading}
                    </th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {data.items.map((item) => {
                  const ticket = TICKET_STATUS[item.ticketStatus];
                  const inactive = item.ticketStatus === "CANCELLED" || item.ticketStatus === "REFUNDED";
                  return (
                    <tr key={item.ticketCode} className={`border-b last:border-b-0 ${inactive ? "text-muted-foreground" : ""}`}>
                      <td className={`${TABLE_CELL} font-semibold`}>{item.seatCode}</td>
                      <td className={TABLE_CELL}>
                        <p className="truncate font-medium">{item.passengerName}</p>
                        {item.companionName && <p className="truncate text-xs text-muted-foreground">Đi cùng: {item.companionName}</p>}
                        <p className="truncate text-xs leading-[18px] text-muted-foreground">
                          <Link href={`/bookings/${item.bookingId}`} className="hover:underline">
                            Đơn {displayCode(item.bookingCode)}
                          </Link>
                          {item.guest ? " · Khách vãng lai" : ""}
                        </p>
                      </td>
                      <td className={`${TABLE_CELL} tabular-nums`}>{item.phoneMasked ?? "—"}</td>
                      <td className={`${TABLE_CELL} truncate`}>{item.pickup.name}</td>
                      <td className={`${TABLE_CELL} truncate`}>{item.dropoff.name}</td>
                      <td className={TABLE_CELL}>{displayCode(item.ticketCode)}</td>
                      <td className={TABLE_CELL}>
                        <Badge tone={ticket.tone}>{ticket.label}</Badge>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        )}
        {data.items.length > 0 && (
          <div className="flex pt-5">
            <ListFooterNote>Đã hiển thị {data.items.length} hành khách</ListFooterNote>
          </div>
        )}
      </section>
      <Banner icon={<Smartphone className="size-[18px] shrink-0" aria-hidden />}>
        Tài xế và nhân viên soát vé xem danh sách này và check-in trên ứng dụng Nhân viên. Mỗi lần xuất danh sách được ghi nhật ký.
      </Banner>
    </>
  );
}

function tripLine(trip: TripPassengerList["trip"]): string {
  const plate = trip.vehiclePlateNumber ? ` · ${formatPlateNumber(trip.vehiclePlateNumber)}` : "";
  return `${formatTime(trip.departureAt)} · ${formatWeekdayDate(trip.departureAt)} · ${trip.routeName}${plate}`;
}

function Stat({ label, value, note }: { label: string; value: string; note?: string }) {
  return (
    <div className="flex flex-col gap-1 rounded-xl border bg-card p-5">
      <p className="text-sm leading-5 text-muted-foreground">{label}</p>
      <p className="text-[28px] leading-9 font-semibold text-vxn-ink tabular-nums">{value}</p>
      {note && <p className="text-xs leading-[18px] text-muted-foreground">{note}</p>}
    </div>
  );
}

function Banner({ icon, children }: { icon: ReactNode; children: ReactNode }) {
  return (
    <div role="note" className="flex items-center gap-3 rounded-lg bg-accent px-5 py-4 text-sm leading-5 text-vxn-teal-700 print:hidden">
      {icon}
      {children}
    </div>
  );
}
