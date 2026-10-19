"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import {
  ArrowLeft,
  CalendarClock,
  CircleAlert,
  CircleCheck,
  FileX2,
  LoaderCircle,
  Lock,
  LockOpen,
  Pencil,
  RefreshCw
} from "lucide-react";
import Link from "next/link";
import { useSearchParams } from "next/navigation";
import { useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { formatDateTime } from "../../lib/route/route-format";
import {
  changeTripStatus,
  getTrip,
  getTripSales,
  setTripSeatStatus,
  type Trip,
  type TripSales,
  type TripStatus,
  type TripStatusInput
} from "../../lib/trip/trip-api";
import { cancelSummary, changeKindLabel, changeLines } from "../../lib/trip/trip-change";
import {
  arrivalDayNote,
  formatTime,
  formatWeekdayDate,
  seatCountLabel,
  stopMetaLabel,
  TRIP_STATUS,
  tripDurationLabel,
  tripHeadline
} from "../../lib/trip/trip-format";
import {
  canEditSeats,
  cutoffLabel,
  describeSeatChangeError,
  describeStatusChangeError,
  readinessItems,
  seatChangeNotice,
  soldSeatCount,
  statusChangeNotice,
  toggleSeat,
  tripActions,
  validSelection,
  type SeatSelection,
  type TripAction
} from "../../lib/trip/trip-sale";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { BUTTON } from "../list-parts";
import { CancelTripDialog, SeatLockDialog } from "./trip-sale-dialogs";
import { OnlineSaleCard, ReadinessCard, SeatSummaryCard } from "./trip-sale-panels";
import { TripSeatMap } from "./trip-seat-map";
import { StopTimeText, TripStopRow } from "./trip-stop-row";
import { PickupWindowPanel } from "./pickup-window-panel";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";

/**
 * Trang chi tiết một chuyến (Figma "03"–"06 · Chuyến xe"; FR-OPS-06, FR-OPS-10, FR-OPS-13, UC-14): sơ đồ ghế theo
 * chuyến, lịch trình và thông tin chuyến. Từ đây nhà xe mở bán, tạm dừng bán, thu hồi về nháp, khóa / mở khóa chỗ bán ngoài
 * hệ thống (TASK-TRN-006); đổi lịch chạy và hủy chuyến kể cả khi đã có vé — khách được báo, hủy thì hoàn 100% (TASK-TRN-008).
 */
export function TripDetail({ tripId }: { tripId: string }) {
  const trip = useQuery({ queryKey: ["trip", tripId], queryFn: () => getTrip(tripId) });
  const params = useSearchParams();
  const [saved, setSaved] = useState(params.get("saved") === "1");
  const [changed, setChanged] = useState(params.get("changed") === "1");

  if (trip.error instanceof ApiError && trip.error.status === 404) {
    return (
      <Shell>
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy chuyến"
          description="Chuyến không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/trips">Về danh sách chuyến</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  // Chỉ khi CHƯA có dữ liệu: tải lại ngầm bị lỗi (đổi tab rồi quay lại) không được xóa lô chỗ đang chọn hay lý do
  // hủy đang gõ dở.
  if (trip.isError && !trip.data) {
    return (
      <Shell>
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được chuyến"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void trip.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (!trip.data) {
    return (
      <Shell>
        <div role="status" aria-label="Đang tải chuyến" className="flex flex-col gap-6">
          <Skeleton className="h-16 w-2/3 rounded-xl" />
          <div className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
            <Skeleton className="h-[440px] rounded-xl" />
            <Skeleton className="h-[440px] rounded-xl" />
          </div>
        </div>
      </Shell>
    );
  }
  return (
    <TripDetailBody
      trip={trip.data}
      saved={saved}
      changed={changed}
      onDismissSaved={() => {
        setSaved(false);
        setChanged(false);
      }}
    />
  );
}

const ACTION_LABEL: Record<Exclude<TripAction, "edit" | "change">, string> = {
  cancel: "Hủy chuyến",
  withdraw: "Thu hồi về nháp",
  lock: "Tạm dừng bán",
  open: "Mở bán",
  reopen: "Mở bán lại"
};

// Trạng thái đích của từng nút đổi ngay không hỏi lý do; hủy đi qua hộp thoại nhập lý do.
const ACTION_TARGET: Record<"withdraw" | "lock" | "open" | "reopen", TripStatusInput["status"]> = {
  withdraw: "DRAFT",
  lock: "LOCKED",
  open: "OPEN_FOR_SALE",
  reopen: "OPEN_FOR_SALE"
};

function TripDetailBody({ trip, saved, changed, onDismissSaved }: { trip: Trip; saved: boolean; changed: boolean; onDismissSaved: () => void }) {
  const queryClient = useQueryClient();
  // Tình hình bán + lịch sử đổi / hủy (TRN-008) — chuyến nháp chưa bán nên không cần.
  const sales = useQuery({ queryKey: ["trip-sales", trip.id], queryFn: () => getTripSales(trip.id), enabled: trip.status !== "DRAFT" });
  const state = TRIP_STATUS[trip.status];
  const plate = trip.vehiclePlateNumber && formatPlateNumber(trip.vehiclePlateNumber);
  const arrivalNote = arrivalDayNote(trip.departureAt, trip.arrivalAt);
  // Mốc "bây giờ" chụp một lần lúc mở trang, chỉ để ghi chú giờ bán online; máy chủ mới là nơi quyết định.
  const [nowMs] = useState(() => Date.now());

  const [notice, setNotice] = useState<{ title: string; detail: string } | null>(null);
  const [actionError, setActionError] = useState<string | null>(null);
  // Các điều kiện chưa đạt của lần bấm Mở bán gần nhất; `null` = chưa bấm lần nào từ khi mở trang.
  const [reasons, setReasons] = useState<string[] | null>(null);
  const [cancelOpen, setCancelOpen] = useState(false);
  const [cancelError, setCancelError] = useState<string | null>(null);
  const [selection, setSelection] = useState<SeatSelection | null>(null);
  const [seatDialogOpen, setSeatDialogOpen] = useState(false);
  const [seatError, setSeatError] = useState<string | null>(null);

  const tickets = soldSeatCount(trip.seats);
  const actions = tripActions(trip.status, tickets > 0);
  const seatsEditable = canEditSeats(trip.status);
  // Sơ đồ tải lại có thể làm một chỗ đang chọn không còn chọn được (vừa có khách giữ) — lô chỉ giữ chỗ còn hợp lệ.
  const picked = seatsEditable ? validSelection(selection, trip.seats) : null;
  const showReadiness = trip.status === "DRAFT" || trip.status === "LOCKED";
  const showOnlineSale = trip.status === "OPEN_FOR_SALE";
  const readiness = showReadiness ? readinessItems(trip, reasons, nowMs, plate) : [];
  const failedCount = readiness.filter((item) => item.state === "fail").length;

  function refreshTrip() {
    void queryClient.invalidateQueries({ queryKey: ["trip", trip.id] });
  }

  const changeStatus = useMutation({
    mutationFn: ({ input }: { input: TripStatusInput; from: TripStatus }) => changeTripStatus(trip.id, input),
    onSuccess: (result, { from }) => {
      queryClient.setQueryData(["trip", trip.id], result);
      void queryClient.invalidateQueries({ queryKey: ["trips"] });
      void queryClient.invalidateQueries({ queryKey: ["trip-sales", trip.id] });
      if (result.status === "CANCELLED") {
        // Hủy chuyến có vé: đơn / vé / hoàn tiền đổi theo (TRN-008).
        void queryClient.invalidateQueries({ queryKey: ["operator-bookings"] });
        // Chuyến hủy nhả xe: cờ "đang có chuyến" ở màn Phương tiện / Sơ đồ ghế đổi theo (UC-12 A3).
        for (const key of ["vehicles", "vehicle", "seat-maps", "seat-map"]) {
          void queryClient.invalidateQueries({ queryKey: [key] });
        }
      }
      setReasons(null);
      setCancelOpen(false);
      setSelection(null);
      onDismissSaved();
      setNotice(statusChangeNotice(from, result));
    },
    onError: (error, { input }) => {
      if (error instanceof ApiError && error.code === "TRIP_NOT_READY_FOR_SALE") {
        setReasons(error.reasons);
        refreshTrip();
        return;
      }
      const message = describeStatusChangeError(error);
      if (input.status === "CANCELLED") {
        setCancelError(message);
      } else {
        setActionError(message);
      }
      if (error instanceof ApiError && (error.status === 409 || error.status === 404)) {
        refreshTrip();
      }
    }
  });

  const changeSeats = useMutation({
    mutationFn: (variables: { selection: SeatSelection; note: string | null }) =>
      setTripSeatStatus(trip.id, {
        seatCodes: variables.selection.codes,
        status: variables.selection.mode === "lock" ? "BLOCKED" : "AVAILABLE",
        note: variables.note
      }),
    onSuccess: (result, variables) => {
      queryClient.setQueryData(["trip", trip.id], result);
      setSelection(null);
      setSeatDialogOpen(false);
      onDismissSaved();
      setNotice({
        title: seatChangeNotice(variables.selection.mode, variables.selection.codes),
        detail:
          variables.selection.mode === "lock"
            ? "Chỗ đã khóa không hiện cho khách đặt online."
            : "Chỗ trở lại Còn trống."
      });
    },
    onError: (error) => {
      const message = describeSeatChangeError(error);
      if (error instanceof ApiError && [404, 409, 422].includes(error.status)) {
        // Sơ đồ ghế đã khác lúc chọn: đóng hộp thoại, tải lại sơ đồ và báo ở đầu trang (lô đang chọn có thể không
        // còn chỗ nào hợp lệ nên hộp thoại không còn gì để hiện).
        setSeatDialogOpen(false);
        setActionError(message);
        refreshTrip();
      } else {
        setSeatError(message);
      }
    }
  });

  const busy = changeStatus.isPending || changeSeats.isPending;

  function requestStatus(input: TripStatusInput) {
    setNotice(null);
    setActionError(null);
    setCancelError(null);
    changeStatus.mutate({ input, from: trip.status });
  }

  function renderAction({ action, disabled }: { action: TripAction; disabled: boolean }) {
    if (action === "change") {
      return (
        <Button key={action} asChild variant="outline" className={`${BUTTON} bg-card`}>
          <Link href={`/trips/${trip.id}/change`}>
            <CalendarClock className="size-[18px]" />
            Đổi lịch chạy
          </Link>
        </Button>
      );
    }
    if (action === "edit") {
      return (
        <Button key={action} asChild variant="outline" className={`${BUTTON} bg-card`}>
          <Link href={`/trips/${trip.id}/edit`}>
            <Pencil className="size-[18px]" />
            Sửa chuyến
          </Link>
        </Button>
      );
    }
    if (action === "cancel") {
      return (
        <Button
          key={action}
          type="button"
          variant="ghost"
          className={`${BUTTON} text-error-600 hover:bg-error-50 hover:text-error-600`}
          disabled={disabled || busy}
          onClick={() => {
            setCancelError(null);
            setCancelOpen(true);
          }}
        >
          {ACTION_LABEL.cancel}
        </Button>
      );
    }
    const target = ACTION_TARGET[action];
    const running = changeStatus.isPending && changeStatus.variables?.input.status === target;
    const primary = action === "open" || action === "reopen";
    return (
      <Button
        key={action}
        type="button"
        variant={primary ? "default" : "outline"}
        className={primary ? BUTTON : `${BUTTON} bg-card`}
        disabled={disabled || busy}
        onClick={() => requestStatus({ status: target, reason: null })}
      >
        {running && <LoaderCircle className="size-[18px] animate-spin" />}
        {ACTION_LABEL[action]}
      </Button>
    );
  }

  return (
    <Shell>
      <header className="flex flex-wrap items-center gap-x-6 gap-y-3">
        <div className="flex min-w-0 flex-1 flex-col gap-1.5">
          <div className="flex flex-wrap items-center gap-3">
            <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{trip.routeName}</h1>
            <Badge tone={state.tone}>{state.label}</Badge>
          </div>
          <p className="text-sm leading-5 text-muted-foreground">{tripHeadline(trip, plate)}</p>
        </div>
        {actions.length > 0 && <div className="flex flex-wrap items-center gap-3">{actions.map(renderAction)}</div>}
      </header>

      {saved && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã lưu chuyến nháp</p>
            <p className="text-sm leading-5 text-success-600">Chuyến chưa hiện với khách cho tới khi được mở bán.</p>
          </div>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={onDismissSaved}>
            Đóng
          </Button>
        </div>
      )}

      {changed && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã đổi lịch chạy</p>
            <p className="text-sm leading-5 text-success-600">Khách bị ảnh hưởng nhận email kèm lý do; thay đổi được ghi ở mục Lịch sử thay đổi.</p>
          </div>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={onDismissSaved}>
            Đóng
          </Button>
        </div>
      )}

      {notice && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">{notice.title}</p>
            <p className="text-sm leading-5 text-success-600">{notice.detail}</p>
          </div>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-[100px] bg-card`}
            onClick={() => setNotice(null)}
          >
            Đóng
          </Button>
        </div>
      )}

      {actionError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {actionError}
        </div>
      )}

      {showReadiness && reasons !== null && failedCount > 0 && (
        <div role="alert" className="flex gap-3 rounded-lg bg-error-50 px-5 py-3.5">
          <CircleAlert className="mt-px size-5 shrink-0 text-error-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-error-600">Chưa mở bán được</p>
            <p className="text-sm leading-5 text-error-600">
              Còn {failedCount} điều kiện chưa đạt. Chuyến vẫn ở trạng thái {state.label}; sửa xong các mục màu đỏ ở
              khối Điều kiện mở bán rồi bấm {trip.status === "LOCKED" ? "Mở bán lại" : "Mở bán"} lần nữa.
            </p>
          </div>
        </div>
      )}

      {tickets > 0 && actions.length > 0 && (
        <div role="note" className="flex gap-3 rounded-lg bg-accent px-5 py-3.5 text-vxn-teal-700">
          <Lock className="mt-px size-5 shrink-0" />
          <p className="min-w-0 flex-1 text-sm leading-5">
            Chuyến đã có {tickets} vé nên không thu hồi về nháp được. Đổi lịch chạy hoặc hủy chuyến cần lý do và gửi email cho
            từng khách; hủy chuyến hoàn toàn bộ giá vé.
          </p>
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="trip-seats-heading" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="trip-seats-heading" className={CARD_TITLE}>
                Sơ đồ ghế theo chuyến
              </h2>
              <p className={HELPER}>
                {plate
                  ? `${seatCountLabel(trip.seatCount)} lấy từ sơ đồ ghế của xe ${plate} lúc gắn xe cho chuyến. Giá từng chỗ lấy theo bảng giá của tuyến và loại xe.`
                  : "Chuyến chưa gắn xe nên chưa có ghế."}
                {seatsEditable && trip.seats.length > 0 && (
                  <>
                    {" "}
                    Bấm chỗ còn trống để chọn rồi khóa (bán tại quầy, chỗ gặp sự cố); bấm chỗ đã khóa để chọn rồi mở
                    khóa. Chỗ đang giữ hoặc đã bán không khóa được.
                  </>
                )}
              </p>
            </div>
            {trip.seats.length > 0 ? (
              <>
                <TripSeatMap
                  seats={trip.seats}
                  picking={
                    seatsEditable
                      ? {
                          selection: picked,
                          disabled: busy,
                          onToggle: (seat) => {
                            setNotice(null);
                            setSelection(toggleSeat(picked, seat));
                          }
                        }
                      : undefined
                  }
                  toolbar={
                    picked && (
                      <SelectionBar
                        selection={picked}
                        disabled={busy}
                        onClear={() => setSelection(null)}
                        onConfirm={() => {
                          setSeatError(null);
                          setSeatDialogOpen(true);
                        }}
                      />
                    )
                  }
                />
                {trip.seats.some((seat) => seat.price === null) && (
                  <p role="note" className="flex flex-wrap items-center gap-x-2 rounded-lg bg-warning-50 px-4 py-3 text-xs leading-[18px] text-warning-700">
                    Có chỗ chưa có giá: tuyến chưa có bảng giá đang áp dụng, hoặc bảng giá chưa có quy tắc cho loại xe /
                    loại chỗ này.
                    <Link href="/fares" className="font-semibold underline underline-offset-2">
                      Mở Bảng giá
                    </Link>
                  </p>
                )}
              </>
            ) : (
              <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
                {trip.status === "DRAFT"
                  ? "Bấm “Sửa chuyến” để gắn xe. Ghế của chuyến được tạo từ sơ đồ ghế của xe."
                  : "Chuyến này không có ghế."}
              </p>
            )}
          </section>

          <section aria-labelledby="trip-schedule-heading" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="trip-schedule-heading" className={CARD_TITLE}>
                Lịch trình
              </h2>
              <p className={HELPER}>Giờ dự kiến tại từng điểm dừng, chép từ tuyến lúc lưu chuyến.</p>
            </div>
            <ol aria-label="Điểm dừng của chuyến" className="flex flex-col gap-2">
              {trip.stops.map((stop) => (
                <TripStopRow
                  key={stop.sequence}
                  order={stop.sequence}
                  name={stop.name}
                  address={stop.address}
                  meta={stopMetaLabel(stop)}
                >
                  <StopTimeText timeMs={new Date(stop.plannedAt).getTime()} />
                </TripStopRow>
              ))}
            </ol>
          </section>
        </div>

        <div className="flex min-w-0 flex-col gap-6">
          {showReadiness && <ReadinessCard items={readiness} checked={reasons !== null} />}
          {trip.status !== "DRAFT" && <SeatSummaryCard seats={trip.seats} />}
          {showOnlineSale && <OnlineSaleCard trip={trip} nowMs={nowMs} />}

          {sales.data && sales.data.changes.length > 0 && <ChangeHistoryCard changes={sales.data.changes} />}

          <PickupWindowPanel trip={trip} />
          <section aria-labelledby="trip-info-heading" className={`${CARD} gap-3.5`}>
            <h2 id="trip-info-heading" className={CARD_TITLE}>
              Thông tin chuyến
            </h2>
            <dl className="flex flex-col gap-3.5">
              <InfoRow label="Tuyến" value={trip.routeName} />
              <InfoRow label="Khởi hành" value={`${formatTime(trip.departureAt)} · ${formatWeekdayDate(trip.departureAt)}`} />
              <InfoRow
                label="Đến"
                value={`${formatTime(trip.arrivalAt)} · ${arrivalNote === "Cùng ngày" ? "cùng ngày" : arrivalNote}`}
              />
              <InfoRow label="Thời lượng" value={tripDurationLabel(trip.departureAt, trip.arrivalAt)} />
              <InfoRow label="Xe" value={plate ?? "Chưa gắn xe"} />
              <InfoRow label="Số chỗ" value={seatCountLabel(trip.seatCount)} />
              {/* Chuyến đang mở bán đã có thẻ Bán online ghi mục này. */}
              {!showOnlineSale && <InfoRow label="Ngừng bán online" value={cutoffLabel(trip.onlineSaleCutoffMinutes)} />}
              {trip.status === "CANCELLED" && trip.statusReason && <InfoRow label="Lý do hủy" value={trip.statusReason} />}
              {trip.departedAt && <InfoRow label="Khởi hành thực tế" value={formatDateTime(trip.departedAt)} />}
              {trip.completedAt && <InfoRow label="Hoàn thành lúc" value={formatDateTime(trip.completedAt)} />}
              <InfoRow label="Ghi chú" value={trip.note ?? "Không có"} />
              <InfoRow label="Cập nhật lần cuối" value={formatDateTime(trip.updatedAt)} />
            </dl>
          </section>
        </div>
      </div>

      <CancelTripDialog
        open={cancelOpen}
        routeName={trip.routeName}
        summary={cancelDialogSummary(trip, sales.data, plate)}
        pending={changeStatus.isPending}
        error={cancelError}
        onClose={() => setCancelOpen(false)}
        onConfirm={(reason) => requestStatus({ status: "CANCELLED", reason })}
      />
      <SeatLockDialog
        open={seatDialogOpen}
        selection={picked}
        pending={changeSeats.isPending}
        error={seatError}
        onClose={() => setSeatDialogOpen(false)}
        onConfirm={(note) => {
          if (picked) {
            setSeatError(null);
            changeSeats.mutate({ selection: picked, note });
          }
        }}
      />
    </Shell>
  );
}

/** Câu mô tả trong hộp thoại hủy: có vé thì nêu số hoàn 100% + đơn chờ thanh toán bị hủy (TRN-008). */
function cancelDialogSummary(trip: Trip, sales: TripSales | undefined, plate: string | null): string {
  const when = `Chuyến khởi hành ${formatTime(trip.departureAt)} ${formatWeekdayDate(trip.departureAt)}`;
  const tail = `Hủy xong chuyến không mở bán lại được${plate ? ` và xe ${plate} nhận được chuyến khác` : ""}.`;
  const impact = sales ? cancelSummary(sales) : null;
  return impact ? `${when}: ${impact} ${tail}` : `${when}, chưa có vé. ${tail}`;
}

/** Lịch sử đổi / hủy chuyến đã bán vé (TRN-008): loại thay đổi, trước → sau, lý do, số đơn được báo. */
function ChangeHistoryCard({ changes }: { changes: TripSales["changes"] }) {
  return (
    <section aria-labelledby="trip-changes-heading" className={`${CARD} gap-3.5`}>
      <h2 id="trip-changes-heading" className={CARD_TITLE}>
        Lịch sử thay đổi
      </h2>
      <ol className="flex flex-col gap-4">
        {changes.map((change) => (
          <li key={change.id} className="flex flex-col gap-1 border-b pb-4 last:border-b-0 last:pb-0">
            <div className="flex items-baseline justify-between gap-3">
              <p className="text-sm leading-5 font-semibold text-vxn-ink">{changeKindLabel(change.kinds)}</p>
              <time className={HELPER} dateTime={change.createdAt}>
                {formatDateTime(change.createdAt)}
              </time>
            </div>
            {changeLines(change).map((line) => (
              <p key={line} className="text-sm leading-5 text-vxn-fg-1">
                {line}
              </p>
            ))}
            <p className="text-sm leading-5 text-muted-foreground">Lý do: {change.reason}</p>
            <p className={HELPER}>
              {change.affectedBookings > 0 ? `Đã báo ${change.affectedBookings} đơn` : "Không có đơn bị ảnh hưởng"}
              {change.actor ? ` · ${change.actor}` : ""}
            </p>
          </li>
        ))}
      </ol>
    </section>
  );
}

/** Thanh "Đã chọn N chỗ" trên sơ đồ ghế (Figma "04"): bỏ chọn hoặc mở hộp thoại khóa / mở khóa cả lô. */
function SelectionBar({
  selection,
  disabled,
  onClear,
  onConfirm
}: {
  selection: SeatSelection;
  disabled: boolean;
  onClear: () => void;
  onConfirm: () => void;
}) {
  const locking = selection.mode === "lock";
  return (
    <div role="group" aria-label="Chỗ đang chọn" className="flex flex-wrap items-center gap-3 rounded-lg bg-accent px-4 py-3">
      <p aria-live="polite" className="min-w-0 flex-1 text-sm leading-5 font-semibold text-vxn-teal-700">
        Đã chọn {seatCountLabel(selection.codes.length)}
        {locking ? "" : " đã khóa"}: {selection.codes.join(", ")}
      </p>
      <Button type="button" variant="ghost" className={BUTTON} disabled={disabled} onClick={onClear}>
        Bỏ chọn
      </Button>
      <Button type="button" className={BUTTON} disabled={disabled} onClick={onConfirm}>
        {locking ? <Lock className="size-[18px]" /> : <LockOpen className="size-[18px]" />}
        {locking ? "Khóa chỗ đã chọn" : "Mở khóa chỗ đã chọn"}
      </Button>
    </div>
  );
}

function Shell({ children }: { children: ReactNode }) {
  return (
    <div className="flex flex-col gap-6">
      <Link
        href="/trips"
        className="flex w-fit items-center gap-1.5 rounded text-sm leading-5 font-medium text-muted-foreground outline-none hover:text-vxn-fg-1 focus-visible:ring-[3px] focus-visible:ring-ring/50"
      >
        <ArrowLeft className="size-[18px]" />
        Danh sách chuyến
      </Link>
      {children}
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start gap-3">
      <dt className="w-[150px] shrink-0 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 flex-1 text-right text-sm leading-5 font-semibold break-words text-vxn-ink">{value}</dd>
    </div>
  );
}

function StatePanel({
  icon,
  title,
  description,
  action
}: {
  icon: ReactNode;
  title: string;
  description: string;
  action: ReactNode;
}) {
  return (
    <div className="flex min-h-[440px] flex-col items-center justify-center gap-3 rounded-xl border bg-card px-4 text-center">
      {icon}
      <p className="text-base leading-6 font-semibold text-vxn-ink">{title}</p>
      <p className="max-w-md text-sm leading-5 text-muted-foreground">{description}</p>
      {action}
    </div>
  );
}
