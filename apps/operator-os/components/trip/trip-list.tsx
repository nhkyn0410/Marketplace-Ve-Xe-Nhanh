"use client";

import { useInfiniteQuery, useQuery } from "@tanstack/react-query";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Tabs, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CalendarClock, CalendarSync, ChevronRight, CircleAlert, FileX2, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { usePathname, useRouter, useSearchParams } from "next/navigation";
import { useId, useMemo, useState, type ReactNode } from "react";

import { listAllRoutes } from "../../lib/route/route-api";
import { listTrips, type TripStatus, type TripSummary } from "../../lib/trip/trip-api";
import {
  arrivalDayNote,
  formatTime,
  formatWeekdayDate,
  fromLocalParts,
  nextLocalDate,
  seatCountLabel,
  todayLocalDate,
  TRIP_STATUS,
  TRIP_STATUS_ORDER,
  tripDurationLabel
} from "../../lib/trip/trip-format";
import { listAllVehicles } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON, ListFooterNote, ListLoadMoreFooter, ListStatePanel } from "../list-parts";
import { PageHeader } from "../page-header";
import { VehicleSchedule } from "./vehicle-schedule";
import {
  ALL,
  FilterSelect,
  TAB_TRIGGER,
  TABLE,
  TABLE_CELL,
  TABLE_HEAD_CELL,
  TABLE_HEAD_ROW,
  TableSkeleton
} from "../stop-point/list-controls";

/**
 * Màn Chuyến xe (Figma "01 · Chuyến xe / Danh sách", "07 · Lịch xe"; FR-OPS-06, UC-14, TASK-TRN-015): công tắc
 * "Danh sách | Lịch xe" (`?view=schedule`) ở đầu trang.
 */
export function TripList() {
  const canManage = useCan()("trip:manage");
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const schedule = params.get("view") === "schedule";
  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title="Chuyến xe"
        description={
          schedule
            ? "Xem từng xe chạy chuyến nào trong ngày, đến lúc mấy giờ và rảnh từ khi nào."
            : "Tạo chuyến từ tuyến, gắn xe và theo dõi trạng thái bán của từng chuyến."
        }
        actions={
          <>
            <Tabs
              value={schedule ? "schedule" : "list"}
              onValueChange={(next) => router.replace(next === "schedule" ? `${pathname}?view=schedule` : pathname, { scroll: false })}
            >
              <TabsList className="h-10" aria-label="Cách xem">
                <TabsTrigger value="list" className={TAB_TRIGGER}>
                  Danh sách
                </TabsTrigger>
                <TabsTrigger value="schedule" className={TAB_TRIGGER}>
                  Lịch xe
                </TabsTrigger>
              </TabsList>
            </Tabs>
            {canManage && <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/trips/schedules">
                <CalendarSync className="size-[18px]" />
                Lịch chạy lặp lại
              </Link>
            </Button>}
            {canManage && <Button asChild className={`${BUTTON} w-40`}>
              <Link href="/trips/new">
                <Plus className="size-[18px]" />
                Tạo chuyến
              </Link>
            </Button>}
          </>
        }
      />
      {schedule ? <VehicleSchedule /> : <TripListView />}
    </div>
  );
}

/** Danh sách chuyến (Figma 01): sắp theo giờ khởi hành; mặc định hiện chuyến từ hôm nay trở đi. */
function TripListView() {
  const canManage = useCan()("trip:manage");
  const today = useMemo(() => todayLocalDate(), []);
  const [from, setFrom] = useState(today);
  const [to, setTo] = useState("");
  const [routeId, setRouteId] = useState<string>(ALL);
  const [vehicleId, setVehicleId] = useState<string>(ALL);
  const [status, setStatus] = useState<string>(ALL);

  // Ô lọc cần đủ tuyến và xe của nhà xe, kể cả đã ngừng dùng (chuyến cũ vẫn gắn với chúng).
  const routes = useQuery({ queryKey: ["routes", "all"], queryFn: () => listAllRoutes() });
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });

  // Gõ năm bằng bàn phím, ô ngày phát ra giá trị dở dang (`0002-…`, `0202-…`); API chỉ nhận năm từ 1970 nên
  // mốc như vậy coi như chưa nhập xong, không gửi đi.
  const sentFrom = from >= MIN_FILTER_DATE ? from : "";
  const sentTo = to >= MIN_FILTER_DATE ? to : "";
  const trips = useInfiniteQuery({
    queryKey: ["trips", { from: sentFrom, to: sentTo, routeId, vehicleId, status }],
    queryFn: ({ pageParam }) =>
      listTrips({
        departureFrom: sentFrom ? fromLocalParts(sentFrom, "00:00") : undefined,
        // API lấy chuyến khởi hành TRƯỚC mốc này, nên "đến ngày" tính hết ngày đó.
        departureTo: sentTo ? fromLocalParts(nextLocalDate(sentTo), "00:00") : undefined,
        routeId: routeId === ALL ? undefined : routeId,
        vehicleId: vehicleId === ALL ? undefined : vehicleId,
        status: status === ALL ? undefined : (status as TripStatus),
        cursor: pageParam
      }),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const items = useMemo(() => trips.data?.pages.flatMap((page) => page.items) ?? [], [trips.data]);
  const filtered = from !== today || to !== "" || routeId !== ALL || vehicleId !== ALL || status !== ALL;

  function resetFilters() {
    setFrom(today);
    setTo("");
    setRouteId(ALL);
    setVehicleId(ALL);
    setStatus(ALL);
  }

  let body: ReactNode;
  let footer: ReactNode = null;
  // Lỗi khi tải thêm KHÔNG thuộc nhánh này: các chuyến đã tải vẫn được giữ lại (xem chân bảng).
  if (trips.isError && !trips.data) {
    body = (
      <ListStatePanel
        icon={<CircleAlert className="size-6 text-warning-700" />}
        title="Không tải được chuyến"
        description="Kiểm tra kết nối mạng rồi thử lại."
        action={
          <Button className={`${BUTTON} w-36`} onClick={() => void trips.refetch()}>
            <RefreshCw className="size-[18px]" />
            Thử lại
          </Button>
        }
      />
    );
  } else if (trips.isPending) {
    body = <TableSkeleton label="Đang tải danh sách chuyến" />;
    footer = <ListFooterNote>Đang tải danh sách chuyến…</ListFooterNote>;
  } else if (items.length === 0) {
    body = filtered ? (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Không có chuyến khớp bộ lọc"
        description="Đổi khoảng ngày, tuyến, xe hoặc trạng thái, hoặc bỏ lọc để xem chuyến từ hôm nay."
        action={
          <Button variant="outline" className={`${BUTTON} bg-card`} onClick={resetFilters}>
            Bỏ lọc
          </Button>
        }
      />
    ) : (
      <ListStatePanel
        icon={<FileX2 className="size-6 text-vxn-fg-3" />}
        title="Chưa có chuyến từ hôm nay"
        description="Tạo chuyến từ một tuyến đang hoạt động. Muốn xem chuyến đã qua thì lùi ngày ở ô “Khởi hành từ ngày”."
        action={canManage ? (
          <Button asChild className={`${BUTTON} w-[180px]`}>
            <Link href="/trips/new">
              <Plus className="size-[18px]" />
              Tạo chuyến
            </Link>
          </Button>
        ) : undefined}
      />
    );
  } else {
    body = <TripTable items={items} />;
    footer = (
      <ListLoadMoreFooter
        hasMore={trips.hasNextPage}
        loading={trips.isFetchingNextPage}
        failed={trips.isFetchNextPageError}
        loadedText={`Đã tải ${items.length} chuyến`}
        endText={`Đã hiển thị tất cả ${items.length} chuyến`}
        errorText="Chưa tải thêm được chuyến. Các chuyến đã tải vẫn được giữ lại."
        onLoadMore={() => void trips.fetchNextPage()}
      />
    );
  }

  return (
    <>
      <section aria-label="Danh sách chuyến" className="flex flex-col rounded-xl border bg-card p-6">
        <div className="flex flex-wrap items-end gap-x-4 gap-y-3 pb-5">
          <DateFilter label="Khởi hành từ ngày" value={from} onChange={setFrom} />
          <DateFilter label="Đến ngày" value={to} min={from || undefined} onChange={setTo} />
          <FilterSelect
            label="Tuyến"
            allLabel="Tất cả tuyến"
            value={routeId}
            onChange={setRouteId}
            options={(routes.data ?? []).map((route) => ({ value: route.id, label: route.name }))}
            className={FILTER}
          />
          <FilterSelect
            label="Xe"
            allLabel="Tất cả xe"
            value={vehicleId}
            onChange={setVehicleId}
            options={(vehicles.data ?? []).map((vehicle) => ({
              value: vehicle.id,
              label: formatPlateNumber(vehicle.plateNumber)
            }))}
            className={FILTER}
          />
          <FilterSelect
            label="Trạng thái"
            allLabel="Tất cả trạng thái"
            value={status}
            onChange={setStatus}
            options={TRIP_STATUS_ORDER.map((value) => ({ value, label: TRIP_STATUS[value].label }))}
            className={FILTER}
          />
        </div>
        <div className="min-h-[504px]">{body}</div>
        {footer && <div className="flex min-h-20 flex-wrap items-center gap-3 py-5">{footer}</div>}
      </section>

      <div className="flex items-center gap-4 rounded-lg bg-accent px-5 py-4">
        <CalendarClock className="size-5 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-sm leading-5 text-vxn-teal-700">
          Chuyến mới tạo ở trạng thái Nháp và chưa hiện với khách. Gắn xe cho chuyến trước khi mở bán.
        </p>
      </div>
    </>
  );
}

/** Ngày sớm nhất gửi được cho API ở ô lọc (đổi sang UTC vẫn còn trong năm 1970). */
const MIN_FILTER_DATE = "1970-01-02";

// Năm ô lọc chia đều một hàng (Figma "Toolbar"); màn hẹp thì xuống dòng.
const FILTER = "w-auto min-w-[170px] flex-1";

function DateFilter({
  label,
  value,
  min,
  onChange
}: {
  label: string;
  value: string;
  min?: string;
  onChange: (value: string) => void;
}) {
  const id = useId();
  return (
    <div className={cn("flex flex-col gap-1.5", FILTER)}>
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        {label}
      </label>
      <Input id={id} type="date" value={value} min={min} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}

// Độ rộng cột theo Figma (200 / 150 / co giãn / 180 / 150 / 96 trên bảng rộng 1086).
const COLUMNS = ["w-[18.4%]", "w-[13.8%]", "", "w-[16.6%]", "w-[13.8%]", "w-24"];
const HEADINGS = ["Khởi hành", "Đến", "Tuyến", "Xe", "Trạng thái", "Thao tác"];

function TripTable({ items }: { items: TripSummary[] }) {
  const router = useRouter();
  return (
    <div className="overflow-x-auto">
      <table className={`${TABLE} min-w-[980px]`}>
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
          {items.map((trip) => {
            const state = TRIP_STATUS[trip.status];
            const cancelled = trip.status === "CANCELLED";
            const strong = cn("font-semibold", cancelled ? "text-muted-foreground" : "text-vxn-ink");
            const departureLabel = `${formatTime(trip.departureAt)} ${formatWeekdayDate(trip.departureAt)}`;
            return (
              <tr
                key={trip.id}
                className="h-[71px] cursor-pointer border-b hover:bg-muted/50"
                // Bấm một dòng để mở chi tiết; nút "Xem" là lối đi cho bàn phím và trình đọc màn hình.
                onClick={(event) => {
                  if (!(event.target as Element).closest("a, button")) {
                    router.push(`/trips/${trip.id}`);
                  }
                }}
              >
                <td className={TABLE_CELL}>
                  <TwoLines strong={strong} first={formatTime(trip.departureAt)} second={formatWeekdayDate(trip.departureAt)} />
                </td>
                <td className={TABLE_CELL}>
                  <TwoLines
                    strong={strong}
                    first={formatTime(trip.arrivalAt)}
                    second={arrivalDayNote(trip.departureAt, trip.arrivalAt)}
                  />
                </td>
                <td className={TABLE_CELL}>
                  <TwoLines
                    strong={strong}
                    first={trip.routeName}
                    second={tripDurationLabel(trip.departureAt, trip.arrivalAt)}
                  />
                </td>
                <td className={TABLE_CELL}>
                  {trip.vehiclePlateNumber ? (
                    <TwoLines
                      strong={strong}
                      first={formatPlateNumber(trip.vehiclePlateNumber)}
                      second={seatCountLabel(trip.seatCount)}
                    />
                  ) : (
                    <TwoLines strong={strong} first="Chưa gắn xe" second="Gắn xe trước khi mở bán" />
                  )}
                </td>
                <td className={TABLE_CELL}>
                  <Badge tone={state.tone}>{state.label}</Badge>
                </td>
                <td className={TABLE_CELL}>
                  <Button asChild variant="ghost" className={`${BUTTON} w-[84px] gap-1.5 px-2 text-vxn-fg-1`}>
                    <Link href={`/trips/${trip.id}`} aria-label={`Xem chuyến ${trip.routeName} khởi hành ${departureLabel}`}>
                      Xem
                      <ChevronRight className="size-[18px]" />
                    </Link>
                  </Button>
                </td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </div>
  );
}

function TwoLines({ strong, first, second }: { strong: string; first: string; second: string }) {
  return (
    <div className="flex flex-col gap-1">
      <span className={cn("truncate", strong)}>{first}</span>
      <span className="truncate text-xs leading-[18px] text-muted-foreground">{second}</span>
    </div>
  );
}
