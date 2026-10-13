"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle
} from "@vexenhanh/ui/components/alert-dialog";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Switch } from "@vexenhanh/ui/components/switch";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { Bus, CircleAlert, FileX2, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useId, useMemo, useState, type ReactNode } from "react";
import { Controller, useForm } from "react-hook-form";

import { ApiError } from "../../lib/auth/api-client";
import { getRoute, listAllRoutes, type Route } from "../../lib/route/route-api";
import { formatDuration, stopCountLabel } from "../../lib/route/route-format";
import { createTrip, getTrip, updateTrip, type Trip } from "../../lib/trip/trip-api";
import {
  arrivalIso,
  autoSplitTimes,
  departureIso,
  describeTripSaveError,
  EMPTY_TRIP_VALUES,
  hasCompleteTimes,
  NO_VEHICLE,
  resolveManualTimes,
  suggestArrival,
  toTripFormValues,
  toTripInput,
  TRIP_NOTE_MAX_LENGTH,
  tripInfoSchema,
  usesAutoSplit,
  type TripFormValues
} from "../../lib/trip/trip-form";
import {
  arrivalDayNote,
  formatTime,
  formatWeekdayDate,
  stopMetaLabel,
  TRIP_STATUS,
  tripDurationLabel
} from "../../lib/trip/trip-format";
import { listAllVehicles, listVehicleTypes } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber, vehicleTypeLabel } from "../../lib/vehicle/vehicle-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { StopTimeDay, StopTimeLocked, TripStopRow } from "./trip-stop-row";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const FORM_ID = "trip-form";

const legSecondsOf = (route: Route) => route.stops.map((stop) => stop.durationSecondsFromPrevious);

/**
 * Màn Tạo / Sửa chuyến nháp (Figma "02 · Chuyến xe / Tạo chuyến"; FR-OPS-06, UC-14, BR-14). Không truyền
 * `tripId` = tạo mới. Chỉ chuyến đang Nháp mới sửa được.
 */
export function TripForm({ tripId }: { tripId?: string }) {
  const trip = useQuery({
    queryKey: ["trip", tripId],
    queryFn: () => getTrip(tripId!),
    enabled: tripId !== undefined
  });
  // Tuyến của chuyến đang sửa: cần số liệu chặng để biết chuyến đang dùng giờ tự chia hay giờ tự nhập.
  const tripRouteId = trip.data?.routeId;
  const tripRoute = useQuery({
    queryKey: ["route", tripRouteId],
    queryFn: () => getRoute(tripRouteId!),
    enabled: tripRouteId !== undefined
  });
  const title = tripId ? "Sửa chuyến" : "Tạo chuyến";

  if (trip.error instanceof ApiError && trip.error.status === 404) {
    return (
      <FormShell title={title} description="Không tìm thấy chuyến.">
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
      </FormShell>
    );
  }
  // Chỉ khi CHƯA có dữ liệu: refetch nền lỗi (đổi tab rồi quay lại) không được xóa form đang nhập dở.
  if ((trip.isError && !trip.data) || (tripRoute.isError && !tripRoute.data)) {
    return (
      <FormShell title={title} description="Chưa tải được dữ liệu.">
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được chuyến"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => void (trip.isError ? trip.refetch() : tripRoute.refetch())}
            >
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </FormShell>
    );
  }
  if (tripId && (trip.isPending || tripRoute.isPending)) {
    return (
      <FormShell title={title} description="Đang tải dữ liệu…">
        <div role="status" aria-label="Đang tải thông tin chuyến" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
          <Skeleton className="h-[440px] rounded-xl" />
          <Skeleton className="h-[440px] rounded-xl" />
        </div>
      </FormShell>
    );
  }
  if (trip.data && trip.data.status !== "DRAFT") {
    return (
      <FormShell title={title} description={`Chuyến đang ở trạng thái ${TRIP_STATUS[trip.data.status].label}.`}>
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Chỉ sửa được chuyến đang Nháp"
          description="Chuyến này đã rời trạng thái Nháp nên không sửa được ở đây."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href={`/trips/${trip.data.id}`}>Về chi tiết chuyến</Link>
            </Button>
          }
        />
      </FormShell>
    );
  }
  // Đổi chuyến (hoặc từ tạo sang sửa) thì dựng lại form với dữ liệu của chuyến đó.
  return <TripFormBody key={trip.data?.id ?? "new"} trip={trip.data} tripRoute={tripRoute.data} />;
}

function TripFormBody({ trip, tripRoute }: { trip?: Trip; tripRoute?: Route }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const backHref = trip ? `/trips/${trip.id}` : "/trips";
  const [formError, setFormError] = useState<string | null>(null);
  const [stopsError, setStopsError] = useState<string | null>(null);
  const [confirmLeave, setConfirmLeave] = useState(false);
  // Giờ đến chỉ tự gợi ý cho tới khi nhà xe sửa tay; chuyến đang sửa thì giữ giờ đã lưu.
  const [arrivalTouched, setArrivalTouched] = useState(trip !== undefined);
  const savedAutoSplit = trip && tripRoute ? usesAutoSplit(trip, legSecondsOf(tripRoute)) : true;
  const [autoSplit, setAutoSplit] = useState(savedAutoSplit);
  const savedManualTimes = useMemo(
    () => (trip && !savedAutoSplit ? trip.stops.map((stop) => formatTime(stop.plannedAt)) : []),
    [trip, savedAutoSplit]
  );
  const [manualTimes, setManualTimes] = useState<string[]>(savedManualTimes);

  const form = useForm<TripFormValues>({
    resolver: zodResolver(tripInfoSchema),
    defaultValues: trip ? toTripFormValues(trip) : EMPTY_TRIP_VALUES
  });
  const { errors } = form.formState;
  const values = form.watch();

  const activeRoutes = useQuery({ queryKey: ["routes", "all", "ACTIVE"], queryFn: () => listAllRoutes("ACTIVE") });
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });
  const vehicleTypes = useQuery({ queryKey: ["catalog", "vehicle-types"], queryFn: listVehicleTypes, staleTime: 300_000 });
  const route = useQuery({
    queryKey: ["route", values.routeId],
    queryFn: () => getRoute(values.routeId),
    enabled: values.routeId !== ""
  });

  // Tuyến / xe ĐANG gắn được giữ dù đã ngừng dùng (giống máy chủ); lựa chọn mới phải đang hoạt động.
  const routeOptions = useMemo(() => {
    const options = (activeRoutes.data ?? []).map((item) => ({ id: item.id, name: item.name }));
    if (trip && !options.some((option) => option.id === trip.routeId)) {
      options.unshift({ id: trip.routeId, name: `${trip.routeName} (đã ngừng dùng)` });
    }
    return options;
  }, [activeRoutes.data, trip]);
  const vehicleOptions = useMemo(
    () =>
      (vehicles.data ?? []).filter(
        (vehicle) => vehicle.id === trip?.vehicleId || (vehicle.status === "ACTIVE" && vehicle.seatMap !== null)
      ),
    [vehicles.data, trip]
  );
  const selectedRoute = activeRoutes.data?.find((item) => item.id === values.routeId);
  const selectedVehicle = vehicles.data?.find((vehicle) => vehicle.id === values.vehicleId);
  const vehicleType = vehicleTypes.data?.find((type) => type.id === selectedVehicle?.vehicleTypeId);

  const stops = route.data?.stops ?? [];
  const complete = hasCompleteTimes(values);
  const departureMs = complete ? new Date(departureIso(values)).getTime() : undefined;
  const arrivalMs = complete ? new Date(arrivalIso(values)).getTime() : undefined;
  const validSpan = departureMs !== undefined && arrivalMs !== undefined && arrivalMs > departureMs;
  const clockTimes = stops.map((_stop, index) => manualTimes[index] ?? "");
  // Giờ tại từng điểm để hiển thị: tự chia thì đủ cả dãy; tự nhập thì có tới đâu ghi ngày tới đó.
  let stopTimes: (number | undefined)[] = [];
  if (route.data && validSpan) {
    stopTimes = autoSplit
      ? autoSplitTimes(departureMs, arrivalMs, legSecondsOf(route.data))
      : resolveManualTimes(departureMs, arrivalMs, clockTimes).times;
  }

  const save = useMutation({
    mutationFn: (input: Parameters<typeof createTrip>[0]) => (trip ? updateTrip(trip.id, input) : createTrip(input)),
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["trips"] });
      // Xe và sơ đồ ghế của chuyến chưa kết thúc bị khóa đổi sơ đồ (UC-12 A3): hai cờ ở các màn đó đổi theo.
      void queryClient.invalidateQueries({ queryKey: ["vehicles"] });
      void queryClient.invalidateQueries({ queryKey: ["vehicle"] });
      void queryClient.invalidateQueries({ queryKey: ["seat-maps"] });
      void queryClient.invalidateQueries({ queryKey: ["seat-map"] });
      queryClient.setQueryData(["trip", result.id], result);
      router.replace(`/trips/${result.id}?saved=1`);
    },
    onError: (error) => {
      const { field, message } = describeTripSaveError(error);
      if (field === "routeId" || field === "vehicleId") {
        form.setError(field, { message }, { shouldFocus: true });
      } else if (field === "stops") {
        setStopsError(message);
      } else {
        setFormError(message);
      }
    }
  });

  /** Gợi ý lại giờ đến khi đổi tuyến hoặc giờ khởi hành, chừng nào nhà xe chưa tự sửa giờ đến. */
  function suggest(next: Partial<Pick<TripFormValues, "routeId" | "departureDate" | "departureTime">>) {
    if (arrivalTouched) {
      return;
    }
    const current = { ...form.getValues(), ...next };
    const duration = activeRoutes.data?.find((item) => item.id === current.routeId)?.totalDurationSeconds;
    const suggestion =
      duration === undefined ? null : suggestArrival(current.departureDate, current.departureTime, duration);
    if (suggestion) {
      form.setValue("arrivalDate", suggestion.date, { shouldDirty: true, shouldValidate: form.formState.isSubmitted });
      form.setValue("arrivalTime", suggestion.time, { shouldDirty: true, shouldValidate: form.formState.isSubmitted });
    }
  }

  function toggleAutoSplit(next: boolean) {
    setStopsError(null);
    setAutoSplit(next);
    // Tắt "Tự chia": điền sẵn giờ đang xem để nhà xe chỉ sửa điểm cần sửa.
    if (!next) {
      setManualTimes(stopTimes.map((time) => (time === undefined ? "" : formatTime(new Date(time).toISOString()))));
    }
  }

  function submit(info: TripFormValues) {
    setFormError(null);
    setStopsError(null);
    let manual: number[] | null = null;
    if (!autoSplit) {
      if (!route.data) {
        setStopsError("Chưa tải được điểm dừng của tuyến nên chưa kiểm được giờ tại từng điểm. Vui lòng thử lại.");
        return;
      }
      const resolved = resolveManualTimes(
        new Date(departureIso(info)).getTime(),
        new Date(arrivalIso(info)).getTime(),
        clockTimes
      );
      if (resolved.error) {
        setStopsError(resolved.error);
        return;
      }
      manual = resolved.times;
    }
    save.mutate(toTripInput(info, manual));
  }

  const dirty =
    form.formState.isDirty ||
    autoSplit !== savedAutoSplit ||
    (!autoSplit && manualTimes.join("|") !== savedManualTimes.join("|"));

  return (
    <FormShell
      title={trip ? "Sửa chuyến" : "Tạo chuyến"}
      description={
        trip
          ? `${trip.routeName} · thay đổi chỉ có hiệu lực khi bấm Lưu chuyến nháp.`
          : "Thông tin có dấu * là bắt buộc. Chuyến được lưu ở trạng thái Nháp, chưa hiện với khách."
      }
      actions={
        <>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-20 bg-card`}
            disabled={save.isPending}
            onClick={() => (dirty ? setConfirmLeave(true) : router.push(backHref))}
          >
            Hủy
          </Button>
          <Button type="submit" form={FORM_ID} className={`${BUTTON} w-44`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? "Đang lưu…" : "Lưu chuyến nháp"}
          </Button>
        </>
      }
    >
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="trip-info-heading" className={CARD}>
            <h2 id="trip-info-heading" className={CARD_TITLE}>
              Thông tin chuyến
            </h2>
            <form id={FORM_ID} noValidate onSubmit={(event) => void form.handleSubmit(submit)(event)} className="flex flex-col gap-4">
              <FormField
                label="Tuyến *"
                helper={
                  selectedRoute
                    ? `${selectedRoute.originName} → ${selectedRoute.destinationName} · ${stopCountLabel(selectedRoute.stopCount)} dừng · thời gian chạy ${formatDuration(selectedRoute.totalDurationSeconds)}`
                    : activeRoutes.data?.length === 0
                      ? "Chưa có tuyến đang hoạt động. Lập tuyến ở mục Tuyến đường trước khi tạo chuyến."
                      : "Chỉ chọn được tuyến đang hoạt động."
                }
                error={errors.routeId?.message}
              >
                {(control) => (
                  <Controller
                    control={form.control}
                    name="routeId"
                    render={({ field }) => (
                      <Select
                        value={field.value}
                        onValueChange={(routeId) => {
                          field.onChange(routeId);
                          // Tuyến khác có số điểm dừng khác: giờ tự nhập cũ không còn dùng được.
                          setManualTimes([]);
                          setStopsError(null);
                          suggest({ routeId });
                        }}
                      >
                        <SelectTrigger {...control} onBlur={field.onBlur}>
                          <SelectValue placeholder="Chọn tuyến" />
                        </SelectTrigger>
                        <SelectContent>
                          {routeOptions.map((option) => (
                            <SelectItem key={option.id} value={option.id}>
                              {option.name}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    )}
                  />
                )}
              </FormField>

              <div className="grid gap-4 sm:grid-cols-2">
                <FormField label="Ngày khởi hành *" helper="Phải ở tương lai" error={errors.departureDate?.message}>
                  {(control) => (
                    <Input
                      {...control}
                      type="date"
                      {...form.register("departureDate", {
                        onChange: (event) => suggest({ departureDate: (event.target as HTMLInputElement).value })
                      })}
                    />
                  )}
                </FormField>
                <FormField label="Giờ khởi hành *" error={errors.departureTime?.message}>
                  {(control) => (
                    <Input
                      {...control}
                      type="time"
                      {...form.register("departureTime", {
                        onChange: (event) => suggest({ departureTime: (event.target as HTMLInputElement).value })
                      })}
                    />
                  )}
                </FormField>
              </div>

              <div className="grid gap-4 sm:grid-cols-2">
                <FormField label="Ngày đến *" error={errors.arrivalDate?.message}>
                  {(control) => (
                    <Input
                      {...control}
                      type="date"
                      {...form.register("arrivalDate", { onChange: () => setArrivalTouched(true) })}
                    />
                  )}
                </FormField>
                <FormField
                  label="Giờ đến *"
                  helper="Gợi ý theo thời gian chạy của tuyến, sửa được"
                  error={errors.arrivalTime?.message}
                >
                  {(control) => (
                    <Input
                      {...control}
                      type="time"
                      {...form.register("arrivalTime", { onChange: () => setArrivalTouched(true) })}
                    />
                  )}
                </FormField>
              </div>

              <FormField
                label="Xe"
                helper="Để trống được khi còn nháp. Chỉ liệt kê xe đang hoạt động và đã có sơ đồ ghế."
                error={errors.vehicleId?.message}
              >
                {(control) => (
                  <Controller
                    control={form.control}
                    name="vehicleId"
                    render={({ field }) => (
                      <Select value={field.value} onValueChange={field.onChange}>
                        <SelectTrigger {...control} onBlur={field.onBlur}>
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          <SelectItem value={NO_VEHICLE}>Chưa gắn xe</SelectItem>
                          {vehicleOptions.map((vehicle) => (
                            <SelectItem key={vehicle.id} value={vehicle.id}>
                              {formatPlateNumber(vehicle.plateNumber)}
                              {vehicle.seatMap ? ` · ${vehicle.seatMap.name}` : ""}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    )}
                  />
                )}
              </FormField>

              <FormField
                label="Ghi chú"
                helper={`Tùy chọn · ${values.note.length} / ${TRIP_NOTE_MAX_LENGTH} ký tự`}
                error={errors.note?.message}
              >
                {(control) => <Textarea {...control} {...form.register("note")} rows={3} maxLength={TRIP_NOTE_MAX_LENGTH} />}
              </FormField>
            </form>
          </section>

          {/* Giờ từng điểm nằm NGOÀI thẻ form: Enter trong ô giờ không gửi form. */}
          <section aria-labelledby="trip-stops-heading" className={CARD}>
            <div className="flex flex-col gap-1">
              <h2 id="trip-stops-heading" className={CARD_TITLE}>
                Giờ dự kiến tại từng điểm dừng
              </h2>
              <p className={HELPER}>
                Điểm dừng lấy theo tuyến đã chọn. Điểm đầu luôn bằng giờ khởi hành, điểm cuối bằng giờ đến.
              </p>
            </div>

            <AutoSplitSwitch checked={autoSplit} onChange={toggleAutoSplit} />

            {stopsError && (
              <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
                <CircleAlert className="size-5 shrink-0" />
                {stopsError}
              </div>
            )}

            {values.routeId === "" ? (
              <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
                Chọn tuyến để xem các điểm dừng của chuyến.
              </p>
            ) : route.isError ? (
              <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3">
                <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được điểm dừng của tuyến.</p>
                <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => void route.refetch()}>
                  Thử lại
                </Button>
              </div>
            ) : route.isPending ? (
              <div role="status" aria-label="Đang tải điểm dừng của tuyến" className="flex flex-col gap-2">
                <Skeleton className="h-[86px] rounded-lg" />
                <Skeleton className="h-[86px] rounded-lg" />
              </div>
            ) : (
              <>
                {!validSpan && (
                  <p className={HELPER}>Nhập giờ khởi hành và giờ đến hợp lệ để xem giờ tại từng điểm.</p>
                )}
                <ol aria-label="Điểm dừng của chuyến" className="flex flex-col gap-2">
                  {stops.map((stop, index) => {
                    const edge = index === 0 || index === stops.length - 1;
                    return (
                      <TripStopRow
                        key={stop.sequence}
                        order={stop.sequence}
                        name={stop.name}
                        address={stop.address}
                        meta={stopMetaLabel(stop)}
                      >
                        {autoSplit || edge ? (
                          <StopTimeLocked timeMs={stopTimes[index]} />
                        ) : (
                          <>
                            <Input
                              type="time"
                              aria-label={`Giờ dự kiến tại ${stop.name}`}
                              className="w-[104px]"
                              value={clockTimes[index]}
                              onChange={(event) => {
                                const next = [...clockTimes];
                                next[index] = event.target.value;
                                setManualTimes(next);
                                setStopsError(null);
                              }}
                            />
                            <StopTimeDay timeMs={stopTimes[index]} />
                          </>
                        )}
                      </TripStopRow>
                    );
                  })}
                </ol>
              </>
            )}
          </section>
        </div>

        <div className="flex min-w-0 flex-col gap-6 xl:sticky xl:top-6">
          <section aria-labelledby="trip-vehicle-heading" className={`${CARD} gap-3.5`}>
            <h2 id="trip-vehicle-heading" className={CARD_TITLE}>
              Xe và sơ đồ ghế
            </h2>
            {selectedVehicle ? (
              <dl className="flex flex-col gap-3.5">
                <SummaryRow label="Biển số" value={formatPlateNumber(selectedVehicle.plateNumber)} />
                <SummaryRow label="Loại xe" value={vehicleType ? vehicleTypeLabel(vehicleType) : "—"} />
                <SummaryRow
                  label="Sơ đồ ghế"
                  value={
                    selectedVehicle.seatMap
                      ? `${selectedVehicle.seatMap.name} · ${selectedVehicle.seatMap.deckCount} tầng`
                      : "Chưa có sơ đồ ghế"
                  }
                />
                <SummaryRow
                  label="Số chỗ"
                  value={selectedVehicle.seatMap ? `${selectedVehicle.seatMap.seatCount} chỗ` : "—"}
                />
              </dl>
            ) : (
              <p className="text-sm leading-5 text-muted-foreground">Chưa gắn xe. Chuyến chưa có ghế cho tới khi gắn xe.</p>
            )}
            <p className={HELPER}>
              Ghế của chuyến được chụp lại từ sơ đồ ghế của xe lúc lưu. Đổi xe thì ghế được tạo lại theo xe mới.
            </p>
          </section>

          <section aria-labelledby="trip-summary-heading" className={`${CARD} gap-3.5`}>
            <h2 id="trip-summary-heading" className={CARD_TITLE}>
              Tổng quan
            </h2>
            <dl className="flex flex-col gap-3.5">
              <SummaryRow
                label="Tuyến"
                value={routeOptions.find((option) => option.id === values.routeId)?.name ?? "Chưa chọn"}
              />
              <SummaryRow
                label="Khởi hành"
                value={
                  departureMs === undefined
                    ? "Chưa nhập"
                    : `${formatTime(departureIso(values))} · ${formatWeekdayDate(departureIso(values))}`
                }
              />
              <SummaryRow
                label="Đến"
                value={
                  validSpan
                    ? `${formatTime(arrivalIso(values))} · ${lowerFirst(arrivalDayNote(departureIso(values), arrivalIso(values)))}`
                    : "Chưa nhập"
                }
              />
              <SummaryRow
                label="Thời lượng"
                value={validSpan ? tripDurationLabel(departureIso(values), arrivalIso(values)) : "—"}
              />
              <SummaryRow label="Trạng thái sau khi lưu" value={TRIP_STATUS.DRAFT.label} />
            </dl>
          </section>

          <div role="note" className="flex gap-3 rounded-lg bg-accent p-4 text-vxn-teal-700">
            <Bus className="mt-px size-[18px] shrink-0" />
            <p className="text-xs leading-[18px]">
              Một xe không chạy hai chuyến trùng giờ. Nếu xe đã có chuyến khác trong khoảng này, lỗi hiện ngay tại ô
              Xe khi lưu. Chuyến sau được khởi hành đúng lúc chuyến trước đến.
            </p>
          </div>
        </div>
      </div>

      <AlertDialog open={confirmLeave} onOpenChange={setConfirmLeave}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Bỏ thay đổi chưa lưu?</AlertDialogTitle>
            <AlertDialogDescription>Thông tin vừa nhập sẽ không được lưu nếu bạn rời trang này.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ở lại</AlertDialogCancel>
            <AlertDialogAction onClick={() => router.push(backHref)}>Rời trang</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </FormShell>
  );
}

/** `Cùng ngày` → `cùng ngày` khi đứng sau giờ; tên thứ (`Thứ Sáu, …`) giữ nguyên. */
function lowerFirst(note: string): string {
  return note === "Cùng ngày" ? "cùng ngày" : note;
}

function AutoSplitSwitch({ checked, onChange }: { checked: boolean; onChange: (checked: boolean) => void }) {
  const id = useId();
  return (
    <div className="flex items-center gap-3">
      <Switch id={id} checked={checked} onCheckedChange={onChange} aria-describedby={`${id}-hint`} />
      <div className="flex min-w-0 flex-1 flex-col gap-0.5">
        <label htmlFor={id} className="text-sm leading-5 font-medium text-vxn-ink">
          Tự chia theo thời gian chạy từng chặng của tuyến
        </label>
        <p id={`${id}-hint`} className={HELPER}>
          Tắt để tự nhập giờ tại các điểm ở giữa.
        </p>
      </div>
    </div>
  );
}

function SummaryRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex items-start gap-3">
      <dt className="min-w-0 flex-1 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className="max-w-[65%] text-right text-sm leading-5 font-semibold text-vxn-ink">{value}</dd>
    </div>
  );
}

function FormShell({
  title,
  description,
  actions,
  children
}: {
  title: string;
  description: string;
  actions?: ReactNode;
  children: ReactNode;
}) {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title={title} description={description} actions={actions} />
      {children}
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
