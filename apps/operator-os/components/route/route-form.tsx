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
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, CircleCheck, FileX2, LoaderCircle, Plus, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useState, type ReactNode } from "react";
import { Controller, useForm } from "react-hook-form";

import { ApiError } from "../../lib/auth/api-client";
import { createRoute, getRoute, updateRoute, type Route } from "../../lib/route/route-api";
import {
  addStop,
  busStationWarning,
  countFlags,
  describeSaveError,
  EMPTY_ROUTE_INFO,
  MAX_ROUTE_STOPS,
  MIN_ROUTE_STOPS,
  moveStop,
  removeStop,
  ROUTE_NAME_MAX_LENGTH,
  ROUTE_NOTE_MAX_LENGTH,
  routeInfoSchema,
  savedLegs,
  setStopFlag,
  setStopNote,
  stopKey,
  toDraftStops,
  toRouteInfoValues,
  toRouteInput,
  totalsOf,
  validateStops,
  type DraftStop,
  type RouteInfoValues
} from "../../lib/route/route-form";
import {
  COMPUTED_ON_SAVE,
  formatDateTime,
  formatDistance,
  formatDuration,
  ROUTE_STATUS,
  ROUTE_STATUS_ORDER,
  stopCountLabel
} from "../../lib/route/route-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { RouteStopList } from "./route-stop-list";
import { StopPicker } from "./stop-picker";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const FORM_ID = "route-form";

/**
 * Màn Thêm / Chỉnh sửa tuyến (Figma 02, 03, 04 của "Nhà xe · Tuyến đường"; FR-OPS-04, UC-13, BR-79). Không
 * truyền `routeId` = thêm mới. Bản đồ lộ trình thuộc TASK-TRN-014 nên chưa có ở đây.
 */
export function RouteForm({ routeId }: { routeId?: string }) {
  const route = useQuery({
    queryKey: ["route", routeId],
    queryFn: () => getRoute(routeId!),
    enabled: routeId !== undefined
  });
  const title = routeId ? "Chỉnh sửa tuyến" : "Thêm tuyến";

  if (route.error instanceof ApiError && route.error.status === 404) {
    return (
      <FormShell title={title} description="Không tìm thấy tuyến.">
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy tuyến"
          description="Tuyến không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/routes">Về danh sách tuyến</Link>
            </Button>
          }
        />
      </FormShell>
    );
  }
  if (route.isError) {
    return (
      <FormShell title={title} description="Chưa tải được dữ liệu.">
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được tuyến"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void route.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </FormShell>
    );
  }
  if (routeId && route.isPending) {
    return (
      <FormShell title={title} description="Đang tải dữ liệu…">
        <div role="status" aria-label="Đang tải thông tin tuyến" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
          <Skeleton className="h-[440px] rounded-xl" />
          <Skeleton className="h-[440px] rounded-xl" />
        </div>
      </FormShell>
    );
  }
  // Đổi tuyến (hoặc từ thêm sang sửa) thì dựng lại form với dữ liệu của tuyến đó.
  return <RouteFormBody key={route.data?.id ?? "new"} route={route.data} />;
}

function RouteFormBody({ route }: { route?: Route }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [saved, setSaved] = useState(useSearchParams().get("saved") === "1");
  const [formError, setFormError] = useState<string | null>(null);
  const [stopsError, setStopsError] = useState<string | null>(null);
  const [stops, setStops] = useState<DraftStop[]>(() => (route ? toDraftStops(route) : []));
  const [pickerOpen, setPickerOpen] = useState(false);
  const [confirmLeave, setConfirmLeave] = useState(false);

  const form = useForm<RouteInfoValues>({
    resolver: zodResolver(routeInfoSchema),
    defaultValues: route ? toRouteInfoValues(route) : EMPTY_ROUTE_INFO
  });
  const { errors } = form.formState;
  const note = form.watch("note");

  const legs = useMemo(() => savedLegs(route), [route]);
  const storedStops = useMemo(() => JSON.stringify(route ? toDraftStops(route) : []), [route]);
  const dirty = form.formState.isDirty || JSON.stringify(stops) !== storedStops;
  const selectedKeys = useMemo(() => new Set(stops.map(stopKey)), [stops]);
  const totals = totalsOf(legs, stops);
  const counts = countFlags(stops);
  const warning = busStationWarning(stops);

  const save = useMutation({
    mutationFn: (info: RouteInfoValues) =>
      route ? updateRoute(route.id, toRouteInput(info, stops)) : createRoute(toRouteInput(info, stops)),
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["routes"] });
      // Số tuyến đang dùng của từng điểm dừng đổi theo.
      void queryClient.invalidateQueries({ queryKey: ["stop-points"] });
      queryClient.setQueryData(["route", result.id], result);
      if (!route) {
        router.replace(`/routes/${result.id}?saved=1`);
        return;
      }
      form.reset(toRouteInfoValues(result));
      setStops(toDraftStops(result));
      setPickerOpen(false);
      setSaved(true);
    },
    onError: (error) => {
      const { field, message } = describeSaveError(error);
      if (field === "name") {
        form.setError("name", { message }, { shouldFocus: true });
      } else if (field === "stops") {
        setStopsError(message);
      } else {
        setFormError(message);
      }
    }
  });

  /** Mọi thay đổi trên danh sách điểm dừng đi qua đây: xóa lỗi cũ và dòng báo "đã lưu". */
  function changeStops(next: DraftStop[]) {
    setStops(next);
    setStopsError(null);
    setSaved(false);
  }

  function submit(info: RouteInfoValues) {
    setFormError(null);
    setSaved(false);
    const problem = validateStops(stops);
    setStopsError(problem);
    if (!problem) {
      save.mutate(info);
    }
  }

  return (
    <FormShell
      title={route ? "Chỉnh sửa tuyến" : "Thêm tuyến"}
      description={
        route
          ? `${route.name} · thay đổi chỉ có hiệu lực khi bấm Lưu tuyến.`
          : `Thông tin có dấu * là bắt buộc. Tuyến cần ít nhất ${MIN_ROUTE_STOPS} điểm dừng.`
      }
      actions={
        <>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-20 bg-card`}
            disabled={save.isPending}
            onClick={() => (dirty ? setConfirmLeave(true) : router.push("/routes"))}
          >
            Hủy
          </Button>
          <Button type="submit" form={FORM_ID} className={`${BUTTON} w-40`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? "Đang lưu tuyến…" : "Lưu tuyến"}
          </Button>
        </>
      }
    >
      {saved && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã lưu tuyến</p>
            <p className="text-sm leading-5 text-success-600">Quãng đường và thời gian từng chặng đã được tính lại.</p>
          </div>
          <Button type="button" variant="outline" className={`${BUTTON} w-[100px] bg-card`} onClick={() => setSaved(false)}>
            Đóng
          </Button>
        </div>
      )}
      {formError && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {formError}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        {/* Danh sách điểm dừng nằm NGOÀI thẻ form: Enter trong ô tìm / ô ghi chú không gửi form. */}
        <section aria-labelledby="route-stops-heading" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="route-stops-heading" className={CARD_TITLE}>
              Điểm dừng theo thứ tự
            </h2>
            <p className={HELPER}>
              Điểm đầu chỉ đón, điểm cuối chỉ trả. Điểm ở giữa chọn cho đón, cho trả hoặc cả hai. Trạm dừng nghỉ không
              đón trả khách và không đứng đầu hay cuối tuyến.
            </p>
          </div>

          {stopsError && (
            <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              <CircleAlert className="size-5 shrink-0" />
              {stopsError}
            </div>
          )}

          {stops.length === 0 ? (
            <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
              Chưa có điểm dừng nào. Bấm “Thêm điểm dừng” để chọn điểm đầu tiên của tuyến.
            </p>
          ) : (
            <RouteStopList
              stops={stops}
              legs={legs}
              onMove={(index, direction) => changeStops(moveStop(stops, index, direction))}
              onRemove={(index) => changeStops(removeStop(stops, index))}
              onFlag={(index, flag, value) => changeStops(setStopFlag(stops, index, flag, value))}
              onNote={(index, value) => changeStops(setStopNote(stops, index, value))}
            />
          )}

          {pickerOpen ? (
            <StopPicker
              selectedKeys={selectedKeys}
              stopCount={stops.length}
              onAdd={(candidate) => changeStops(addStop(stops, candidate))}
              onClose={() => setPickerOpen(false)}
            />
          ) : (
            <div className="flex flex-wrap items-center gap-4">
              <Button
                type="button"
                variant="outline"
                className={`${BUTTON} bg-card`}
                disabled={stops.length >= MAX_ROUTE_STOPS}
                onClick={() => setPickerOpen(true)}
              >
                <Plus className="size-[18px]" />
                Thêm điểm dừng
              </Button>
              <p className={HELPER}>
                {stops.length} / {MAX_ROUTE_STOPS} điểm · tối thiểu {MIN_ROUTE_STOPS} điểm
              </p>
            </div>
          )}
        </section>

        <div className="flex min-w-0 flex-col gap-6 xl:sticky xl:top-6">
          <section aria-labelledby="route-info-heading" className={CARD}>
            <h2 id="route-info-heading" className={CARD_TITLE}>
              Thông tin tuyến
            </h2>
            <form
              id={FORM_ID}
              noValidate
              onSubmit={(event) =>
                void form.handleSubmit(submit, () => {
                  // Tên còn lỗi vẫn báo luôn lỗi của danh sách điểm dừng, để sửa một lượt.
                  setStopsError(validateStops(stops));
                })(event)
              }
              className="flex flex-col gap-4"
            >
              <FormField
                label="Tên tuyến *"
                helper={`Tối đa ${ROUTE_NAME_MAX_LENGTH} ký tự · không trùng tên trong nhà xe`}
                error={errors.name?.message}
              >
                {(control) => (
                  <Input
                    {...control}
                    {...form.register("name")}
                    autoComplete="off"
                    maxLength={ROUTE_NAME_MAX_LENGTH}
                    placeholder="Ví dụ: Sài Gòn – Đà Lạt"
                  />
                )}
              </FormField>
              <FormField label="Trạng thái *" error={errors.status?.message}>
                {(control) => (
                  <Controller
                    control={form.control}
                    name="status"
                    render={({ field }) => (
                      <Select value={field.value} onValueChange={field.onChange}>
                        <SelectTrigger {...control} onBlur={field.onBlur}>
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                          {ROUTE_STATUS_ORDER.map((value) => (
                            <SelectItem key={value} value={value}>
                              {ROUTE_STATUS[value].label}
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
                helper={`Tùy chọn · ${note.length} / ${ROUTE_NOTE_MAX_LENGTH} ký tự`}
                error={errors.note?.message}
              >
                {(control) => (
                  <Textarea {...control} {...form.register("note")} rows={3} maxLength={ROUTE_NOTE_MAX_LENGTH} />
                )}
              </FormField>
            </form>
          </section>

          <section aria-labelledby="route-summary-heading" className={CARD}>
            <h2 id="route-summary-heading" className={CARD_TITLE}>
              Tổng quan
            </h2>
            <dl className="flex flex-col gap-3">
              <SummaryRow label="Số điểm dừng" value={stopCountLabel(stops.length)} />
              <SummaryRow label="Điểm cho đón" value={stopCountLabel(counts.pickup)} />
              <SummaryRow label="Điểm cho trả" value={stopCountLabel(counts.dropoff)} />
              <SummaryRow
                label="Quãng đường"
                value={totals ? formatDistance(totals.distanceMeters) : COMPUTED_ON_SAVE}
                pending={!totals}
              />
              <SummaryRow
                label="Thời gian chạy"
                value={totals ? formatDuration(totals.durationSeconds) : COMPUTED_ON_SAVE}
                pending={!totals}
              />
              {route && <SummaryRow label="Cập nhật lần cuối" value={formatDateTime(route.updatedAt)} />}
            </dl>
            <p className={HELPER}>
              Quãng đường và thời gian do hệ thống tính bằng bản đồ Goong mỗi khi lưu thay đổi về điểm dừng; không nhập
              tay.
              {route?.metricsSource === "ESTIMATE" &&
                " Số liệu hiện tại là ước lượng vì môi trường này chưa có khóa bản đồ."}
            </p>
          </section>

          {warning && (
            <div role="note" className="flex gap-3 rounded-lg bg-warning-50 p-4 text-warning-700">
              <CircleAlert className="mt-px size-[18px] shrink-0" />
              <p className="text-xs leading-[18px]">{warning}</p>
            </div>
          )}
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
            <AlertDialogAction onClick={() => router.push("/routes")}>Rời trang</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </FormShell>
  );
}

function SummaryRow({ label, value, pending = false }: { label: string; value: string; pending?: boolean }) {
  return (
    <div className="flex items-center gap-3">
      <dt className="min-w-0 flex-1 text-sm leading-5 text-muted-foreground">{label}</dt>
      <dd className={`text-sm leading-5 font-semibold ${pending ? "text-muted-foreground" : "text-vxn-ink"}`}>{value}</dd>
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
