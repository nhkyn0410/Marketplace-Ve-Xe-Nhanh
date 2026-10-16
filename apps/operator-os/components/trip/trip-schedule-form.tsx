"use client";

import { zodResolver } from "@hookform/resolvers/zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Switch } from "@vexenhanh/ui/components/switch";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { cn } from "@vexenhanh/ui/lib/utils";
import { ArrowLeft, CalendarSync, CircleAlert, CircleCheck, FileX2, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useId, useMemo, useState, type ReactNode } from "react";
import { Controller, useForm } from "react-hook-form";

import { ApiError } from "../../lib/auth/api-client";
import { listAllRoutes } from "../../lib/route/route-api";
import { formatDuration } from "../../lib/route/route-format";
import { MAX_ONLINE_SALE_CUTOFF_MINUTES, NO_VEHICLE, TRIP_NOTE_MAX_LENGTH } from "../../lib/trip/trip-form";
import { TRIP_STATUS, todayLocalDate } from "../../lib/trip/trip-format";
import {
  createTripSchedule,
  generateTripSchedule,
  getTripSchedule,
  updateTripSchedule,
  type TripSchedule,
  type TripScheduleGenerateResult
} from "../../lib/trip/trip-schedule-api";
import {
  describeScheduleSaveError,
  emptyScheduleValues,
  formatDateOnly,
  matchingDates,
  notOpenedLabel,
  scheduleSchema,
  shortDayLabel,
  SKIP_REASON_LABEL,
  suggestDuration,
  toScheduleFormValues,
  toScheduleInput,
  totalDurationMinutes,
  WEEKDAY_OPTIONS,
  weekdaysLabel,
  type ScheduleFormValues
} from "../../lib/trip/trip-schedule-form";
import { listAllVehicles } from "../../lib/vehicle/vehicle-api";
import { formatPlateNumber } from "../../lib/vehicle/vehicle-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const FORM_ID = "trip-schedule-form";
/** Số ngày xem trước hiện trong thẻ tóm tắt. */
const PREVIEW_DATES = 8;

/**
 * Màn Tạo / Sửa lịch chạy lặp lại (TASK-TRN-007, FR-OPS-07, UC-14 bước 7 — chưa có khung Figma, dựng theo bộ kit màn
 * "02 · Chuyến xe / Tạo chuyến"). Không truyền `scheduleId` = tạo mới; lịch đã lưu có thêm khối "Sinh chuyến".
 */
export function TripScheduleForm({ scheduleId }: { scheduleId?: string }) {
  const schedule = useQuery({
    queryKey: ["trip-schedule", scheduleId],
    queryFn: () => getTripSchedule(scheduleId!),
    enabled: scheduleId !== undefined
  });
  const title = scheduleId ? "Lịch chạy lặp lại" : "Tạo lịch chạy lặp lại";

  if (schedule.error instanceof ApiError && schedule.error.status === 404) {
    return (
      <Shell title={title} description="Không tìm thấy lịch.">
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy lịch"
          description="Lịch không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/trips/schedules">Về danh sách lịch</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  if (schedule.isError && !schedule.data) {
    return (
      <Shell title={title} description="Chưa tải được dữ liệu.">
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được lịch"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void schedule.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (scheduleId && schedule.isPending) {
    return (
      <Shell title={title} description="Đang tải dữ liệu…">
        <div role="status" aria-label="Đang tải lịch" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
          <Skeleton className="h-[480px] rounded-xl" />
          <Skeleton className="h-[480px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  return <ScheduleFormBody key={schedule.data?.id ?? "new"} schedule={schedule.data} />;
}

function ScheduleFormBody({ schedule }: { schedule?: TripSchedule }) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const queryClient = useQueryClient();
  const today = todayLocalDate();
  const [formError, setFormError] = useState<string | null>(null);
  // Thời gian chạy tự gợi ý theo tuyến cho tới khi nhà xe sửa tay; lịch đã lưu giữ số đã lưu.
  const [durationTouched, setDurationTouched] = useState(schedule !== undefined);
  const schema = useMemo(() => scheduleSchema(today), [today]);
  const form = useForm<ScheduleFormValues>({
    resolver: zodResolver(schema),
    defaultValues: schedule ? toScheduleFormValues(schedule) : emptyScheduleValues(today)
  });
  const { errors } = form.formState;
  const values = form.watch();

  const activeRoutes = useQuery({ queryKey: ["routes", "all", "ACTIVE"], queryFn: () => listAllRoutes("ACTIVE") });
  const vehicles = useQuery({ queryKey: ["vehicles", "all"], queryFn: listAllVehicles });
  const vehicleOptions = useMemo(
    () => (vehicles.data ?? []).filter((vehicle) => vehicle.status === "ACTIVE" && vehicle.seatMap !== null),
    [vehicles.data]
  );
  const selectedRoute = activeRoutes.data?.find((route) => route.id === values.routeId);
  const routeOptions = useMemo(() => {
    const options = (activeRoutes.data ?? []).map((route) => ({ id: route.id, name: route.name }));
    // Tuyến của lịch đã ngừng dùng: vẫn hiện để biết lịch đang gắn tuyến nào (lưu sẽ bị từ chối — chọn tuyến khác).
    if (schedule && activeRoutes.data && !options.some((option) => option.id === schedule.routeId)) {
      options.unshift({ id: schedule.routeId, name: `${schedule.routeName} (đã ngừng dùng)` });
    }
    return options;
  }, [activeRoutes.data, schedule]);
  const dates = matchingDates(values);
  const duration = totalDurationMinutes(values);

  const save = useMutation({
    mutationFn: () => {
      const input = toScheduleInput(form.getValues());
      return schedule ? updateTripSchedule(schedule.id, input) : createTripSchedule(input);
    },
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["trip-schedules"] });
      queryClient.setQueryData(["trip-schedule", result.id], result);
      if (schedule) {
        form.reset(toScheduleFormValues(result));
      } else {
        router.replace(`/trips/schedules/${result.id}?saved=1`);
      }
    },
    onError: (error) => {
      const { field, message } = describeScheduleSaveError(error);
      if (field) {
        form.setError(field, { message }, { shouldFocus: true });
      } else {
        setFormError(message);
      }
    }
  });

  function suggest(routeId: string) {
    if (durationTouched) {
      return;
    }
    const seconds = activeRoutes.data?.find((route) => route.id === routeId)?.totalDurationSeconds;
    if (seconds !== undefined) {
      const suggestion = suggestDuration(seconds);
      form.setValue("durationHours", suggestion.hours, { shouldDirty: true });
      form.setValue("durationMinutes", suggestion.minutes, { shouldDirty: true });
    }
  }

  const dirty = form.formState.isDirty;
  const justCreated = searchParams.get("saved") === "1";

  return (
    <Shell
      title={schedule ? `${schedule.routeName} · ${schedule.departureTime}` : "Tạo lịch chạy lặp lại"}
      description={
        schedule
          ? `${weekdaysLabel(schedule.daysOfWeek)} · ${formatDateOnly(schedule.startDate)} – ${formatDateOnly(schedule.endDate)}. Sửa lịch chỉ áp cho ngày chưa sinh chuyến.`
          : "Thông tin có dấu * là bắt buộc. Lưu lịch xong mới sinh chuyến."
      }
      actions={
        <>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-20 bg-card`}
            disabled={save.isPending}
            onClick={() => router.push("/trips/schedules")}
          >
            {schedule ? "Đóng" : "Hủy"}
          </Button>
          <Button type="submit" form={FORM_ID} className={`${BUTTON} w-36`} disabled={save.isPending || (schedule && !dirty)}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? "Đang lưu…" : "Lưu lịch"}
          </Button>
        </>
      }
    >
      {justCreated && !dirty && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5 text-sm leading-5 text-success-700">
          <CircleCheck className="size-5 shrink-0" />
          Đã lưu lịch. Bấm “Sinh chuyến” để tạo chuyến nháp cho các ngày khớp lịch.
        </div>
      )}
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        <section aria-labelledby="schedule-rule-heading" className={cn(CARD, "min-w-0")}>
          <h2 id="schedule-rule-heading" className={CARD_TITLE}>
            Quy tắc chạy
          </h2>
          <form
            id={FORM_ID}
            noValidate
            onSubmit={(event) =>
              void form.handleSubmit(() => {
                setFormError(null);
                save.mutate();
              })(event)
            }
            className="flex flex-col gap-4"
          >
            <FormField
              label="Tuyến *"
              helper={
                selectedRoute
                  ? `${selectedRoute.originName} → ${selectedRoute.destinationName} · thời gian chạy theo tuyến ${formatDuration(selectedRoute.totalDurationSeconds)}`
                  : activeRoutes.data?.length === 0
                    ? "Chưa có tuyến đang hoạt động. Lập tuyến ở mục Tuyến đường trước."
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
                        suggest(routeId);
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
              <FormField label="Giờ khởi hành *" helper="Theo giờ Việt Nam" error={errors.departureTime?.message}>
                {(control) => <Input {...control} type="time" {...form.register("departureTime")} />}
              </FormField>
              <FormField
                label="Thời gian chạy *"
                helper={duration ? `Mỗi chuyến chạy ${formatDuration(duration * 60)}` : "Gợi ý theo tuyến, sửa được"}
                error={errors.durationHours?.message}
              >
                {(control) => (
                  <div className="flex items-center gap-2">
                    <Input
                      {...control}
                      inputMode="numeric"
                      maxLength={3}
                      className="w-20"
                      {...form.register("durationHours", { onChange: () => setDurationTouched(true) })}
                    />
                    <span className="text-sm text-muted-foreground">giờ</span>
                    <Input
                      aria-label="Số phút của thời gian chạy"
                      inputMode="numeric"
                      maxLength={2}
                      className="w-20"
                      {...form.register("durationMinutes", { onChange: () => setDurationTouched(true) })}
                    />
                    <span className="text-sm text-muted-foreground">phút</span>
                  </div>
                )}
              </FormField>
            </div>

            <Controller
              control={form.control}
              name="daysOfWeek"
              render={({ field }) => (
                <WeekdayPicker value={field.value} onChange={field.onChange} error={errors.daysOfWeek?.message} />
              )}
            />

            <div className="grid gap-4 sm:grid-cols-2">
              <FormField label="Áp dụng từ ngày *" error={errors.startDate?.message}>
                {(control) => <Input {...control} type="date" {...form.register("startDate")} />}
              </FormField>
              <FormField label="Đến ngày *" helper="Tối đa 93 ngày mỗi lịch" error={errors.endDate?.message}>
                {(control) => <Input {...control} type="date" {...form.register("endDate")} />}
              </FormField>
            </div>

            <FormField
              label="Xe"
              helper="Để trống thì chuyến sinh ra chưa gắn xe (gắn ở từng chuyến trước khi mở bán). Ngày xe trùng giờ chuyến khác sẽ được bỏ qua khi sinh."
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
                        {schedule?.vehicleId && !vehicleOptions.some((vehicle) => vehicle.id === schedule.vehicleId) && (
                          <SelectItem value={schedule.vehicleId}>
                            {formatPlateNumber(schedule.vehiclePlateNumber ?? "")} (không còn dùng được)
                          </SelectItem>
                        )}
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
              label="Ngừng bán online trước giờ khởi hành (phút) *"
              helper={`Từ 0 đến ${MAX_ONLINE_SALE_CUTOFF_MINUTES} phút, áp cho mọi chuyến sinh từ lịch.`}
              error={errors.onlineSaleCutoffMinutes?.message}
            >
              {(control) => <Input {...control} inputMode="numeric" maxLength={4} {...form.register("onlineSaleCutoffMinutes")} />}
            </FormField>

            <FormField
              label="Ghi chú cho chuyến"
              helper={`Tùy chọn · chép vào từng chuyến sinh ra · ${values.note.length} / ${TRIP_NOTE_MAX_LENGTH} ký tự`}
              error={errors.note?.message}
            >
              {(control) => <Textarea {...control} {...form.register("note")} rows={3} maxLength={TRIP_NOTE_MAX_LENGTH} />}
            </FormField>
          </form>
        </section>

        <div className="flex min-w-0 flex-col gap-6 xl:sticky xl:top-6">
          <section aria-labelledby="schedule-dates-heading" className={cn(CARD, "gap-3.5")}>
            <h2 id="schedule-dates-heading" className={CARD_TITLE}>
              Ngày có chuyến
            </h2>
            {dates.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Chọn thứ chạy và khoảng ngày hợp lệ để xem các ngày có chuyến.</p>
            ) : (
              <>
                <p className="text-sm leading-5 text-vxn-fg-1">
                  <span className="font-semibold text-vxn-ink">{dates.length} ngày</span> từ {formatDateOnly(dates[0]!)} đến{" "}
                  {formatDateOnly(dates[dates.length - 1]!)}
                  {values.departureTime ? `, khởi hành ${values.departureTime}` : ""}.
                </p>
                <ul aria-label="Các ngày có chuyến" className="flex flex-wrap gap-1.5">
                  {dates.slice(0, PREVIEW_DATES).map((date) => (
                    <li key={date} className="rounded-md bg-muted px-2 py-1 text-xs leading-[18px] font-medium text-vxn-fg-1">
                      {shortDayLabel(date)}
                    </li>
                  ))}
                  {dates.length > PREVIEW_DATES && (
                    <li className="px-1 py-1 text-xs leading-[18px] text-muted-foreground">+{dates.length - PREVIEW_DATES} ngày</li>
                  )}
                </ul>
              </>
            )}
          </section>

          {schedule && <GeneratePanel schedule={schedule} dirty={dirty} />}

          <div role="note" className="flex gap-3 rounded-lg bg-accent p-4 text-vxn-teal-700">
            <CalendarSync className="mt-px size-[18px] shrink-0" />
            <p className="text-xs leading-[18px]">
              Lịch là quy tắc: chuyến chỉ có khi bấm Sinh chuyến. Mỗi ngày có tối đa một chuyến của lịch — sinh lại không tạo
              trùng, chuyến đã hủy cũng không bị tạo lại. Chuyến sinh ra sửa, mở bán, khóa chỗ như chuyến tạo tay.
            </p>
          </div>
        </div>
      </div>
    </Shell>
  );
}

function WeekdayPicker({ value, onChange, error }: { value: number[]; onChange: (days: number[]) => void; error?: string }) {
  const id = useId();
  return (
    <fieldset className="flex min-w-0 flex-col gap-1.5" aria-describedby={`${id}-note`}>
      <legend className="pb-1.5 text-sm leading-5 font-medium text-vxn-ink">Ngày chạy trong tuần *</legend>
      <div className="flex flex-wrap gap-2">
        {WEEKDAY_OPTIONS.map((option) => {
          const pressed = value.includes(option.day);
          return (
            <button
              key={option.day}
              type="button"
              aria-pressed={pressed}
              aria-label={option.long}
              onClick={() => onChange(pressed ? value.filter((day) => day !== option.day) : [...value, option.day])}
              className={cn(
                "h-10 w-12 rounded-lg border text-sm font-semibold transition-colors",
                pressed ? "border-primary bg-primary text-primary-foreground" : "bg-card text-vxn-fg-1 hover:bg-muted"
              )}
            >
              {option.short}
            </button>
          );
        })}
        <Button type="button" variant="ghost" className={`${BUTTON} text-vxn-fg-1`} onClick={() => onChange([1, 2, 3, 4, 5, 6, 7])}>
          Hằng ngày
        </Button>
      </div>
      <p
        id={`${id}-note`}
        role={error ? "alert" : undefined}
        className={cn("text-xs leading-[18px]", error ? "text-error-600" : "text-muted-foreground")}
      >
        {error ?? (value.length > 0 ? `Đang chọn: ${weekdaysLabel(value)}` : "Chọn ít nhất một thứ.")}
      </p>
    </fieldset>
  );
}

function GeneratePanel({ schedule, dirty }: { schedule: TripSchedule; dirty: boolean }) {
  const queryClient = useQueryClient();
  const switchId = useId();
  const [openForSale, setOpenForSale] = useState(false);
  const [result, setResult] = useState<TripScheduleGenerateResult | null>(null);
  const today = todayLocalDate();
  const savedDates = matchingDates(schedule).filter((date) => date >= today);
  const generate = useMutation({
    mutationFn: () => generateTripSchedule(schedule.id, openForSale),
    onSuccess: (next) => {
      setResult(next);
      void queryClient.invalidateQueries({ queryKey: ["trip-schedules"] });
      void queryClient.invalidateQueries({ queryKey: ["trip-schedule", schedule.id] });
      void queryClient.invalidateQueries({ queryKey: ["trips"] });
    }
  });
  const generateError =
    generate.error instanceof ApiError && generate.error.code === "ROUTE_UNAVAILABLE"
      ? "Tuyến của lịch đã ngừng dùng. Chọn tuyến khác rồi lưu lịch trước khi sinh."
      : generate.error instanceof ApiError && generate.error.code === "VEHICLE_UNAVAILABLE"
        ? "Xe của lịch không còn hoạt động hoặc chưa có sơ đồ ghế. Đổi xe rồi lưu lịch trước khi sinh."
        : generate.error
          ? "Chưa sinh được chuyến. Vui lòng kiểm tra kết nối và thử lại — ngày đã sinh sẽ không bị tạo lại."
          : null;

  return (
    <section aria-labelledby="schedule-generate-heading" className={cn(CARD, "gap-4")}>
      <div className="flex flex-col gap-1">
        <h2 id="schedule-generate-heading" className={CARD_TITLE}>
          Sinh chuyến
        </h2>
        <p className={HELPER}>
          Đã sinh {schedule.tripCount} chuyến từ lịch này
          {schedule.lastGeneratedAt ? ` · lần gần nhất ${new Date(schedule.lastGeneratedAt).toLocaleString("vi-VN")}` : ""}.
        </p>
      </div>
      <p className="text-sm leading-5 text-vxn-fg-1">
        Tạo chuyến nháp cho {savedDates.length} ngày còn lại của lịch đã lưu (ngày đã có chuyến, giờ khởi hành đã qua được bỏ
        qua).
      </p>
      <div className="flex items-center gap-3">
        <Switch id={switchId} checked={openForSale} onCheckedChange={setOpenForSale} />
        <label htmlFor={switchId} className="text-sm leading-5 font-medium text-vxn-ink">
          Mở bán ngay chuyến đủ điều kiện
        </label>
      </div>
      {dirty && (
        <p role="note" className="rounded-lg bg-warning-50 px-4 py-3 text-xs leading-[18px] text-warning-700">
          Có thay đổi chưa lưu. Lưu lịch trước khi sinh chuyến — sinh chuyến dùng lịch đã lưu.
        </p>
      )}
      <Button className={`${BUTTON} w-full`} disabled={dirty || generate.isPending} onClick={() => generate.mutate()}>
        {generate.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
        {generate.isPending ? "Đang sinh chuyến…" : "Sinh chuyến"}
      </Button>
      {generateError && (
        <p role="alert" className="rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
          {generateError}
        </p>
      )}
      {result && <GenerateResult result={result} />}
    </section>
  );
}

function GenerateResult({ result }: { result: TripScheduleGenerateResult }) {
  const opened = result.created.filter((trip) => trip.status === "OPEN_FOR_SALE").length;
  return (
    <div role="status" className="flex flex-col gap-3 border-t pt-4">
      <p className="text-sm leading-5 font-semibold text-vxn-ink">
        Đã tạo {result.created.length} chuyến{opened > 0 ? ` (${opened} đang mở bán)` : ""} · bỏ qua {result.skipped.length} ngày
      </p>
      {(result.created.length > 0 || result.skipped.length > 0) && (
        <ul aria-label="Kết quả từng ngày" className="flex max-h-80 flex-col gap-1.5 overflow-y-auto pr-1">
          {result.created.map((trip) => (
            <li key={trip.tripId} className="flex flex-wrap items-center gap-x-3 gap-y-1 rounded-lg bg-muted/60 px-3 py-2">
              <span className="w-16 shrink-0 text-xs font-semibold text-vxn-ink">{shortDayLabel(trip.serviceDate)}</span>
              <Badge tone={TRIP_STATUS[trip.status].tone}>{TRIP_STATUS[trip.status].label}</Badge>
              <Link href={`/trips/${trip.tripId}`} className="ml-auto text-xs font-semibold text-vxn-teal-700 hover:underline">
                Xem chuyến
              </Link>
              {trip.notOpenedReasons.length > 0 && (
                <span className="w-full text-xs leading-[18px] text-warning-700">
                  Chưa mở bán: {notOpenedLabel(trip.notOpenedReasons)}
                </span>
              )}
            </li>
          ))}
          {result.skipped.map((day) => (
            <li key={day.serviceDate} className="flex items-center gap-3 rounded-lg px-3 py-2">
              <span className="w-16 shrink-0 text-xs font-semibold text-muted-foreground">{shortDayLabel(day.serviceDate)}</span>
              <span className={cn("text-xs leading-[18px]", day.reason === "VEHICLE_CONFLICT" ? "text-error-600" : "text-muted-foreground")}>
                {SKIP_REASON_LABEL[day.reason]}
              </span>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

function Shell({
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
      <Link
        href="/trips/schedules"
        className="flex w-fit items-center gap-2 text-sm leading-5 font-medium text-vxn-teal-700 hover:underline"
      >
        <ArrowLeft className="size-4" />
        Về danh sách lịch
      </Link>
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
