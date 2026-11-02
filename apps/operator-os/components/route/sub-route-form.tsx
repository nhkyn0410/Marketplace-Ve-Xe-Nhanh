"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Switch } from "@vexenhanh/ui/components/switch";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ArrowLeft, CircleAlert, CircleCheck, LoaderCircle, Tag } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";

import { createSubRoute, getRoute, previewRouteName, updateSubRoute, type Route } from "../../lib/route/route-api";
import { formatDistance, formatDuration, ROUTE_STATUS, ROUTE_STATUS_ORDER } from "../../lib/route/route-format";
import {
  describeSubRouteError,
  EMPTY_SUB_ROUTE,
  fromOptions,
  pointKey,
  sliceOf,
  sliceStopInputs,
  sliceTotals,
  toOptions,
  toSubRouteInput,
  toSubRouteValues,
  type SubRouteValues
} from "../../lib/route/sub-route";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const NAME_MAX = 150;
const NOTE_MAX = 500;

/**
 * Form Thêm / Sửa tuyến con (giai đoạn 3.2, tự thiết kế 29/10/2026, chờ duyệt): chọn điểm đầu / điểm cuối trên tuyến chính,
 * các điểm ở giữa chỉ xem (lấy theo tuyến chính); tên, trạng thái, ghi chú riêng. Bảng giá ở màn Bảng giá.
 */
export function SubRouteForm({ parentId, route }: { parentId: string; route?: Route }) {
  const parent = useQuery({ queryKey: ["route", parentId], queryFn: () => getRoute(parentId) });
  if (parent.isError) {
    return (
      <div className="flex flex-col gap-6">
        <PageHeader title="Tuyến con" description="Không tải được tuyến chính." />
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3.5 text-sm text-error-600">
          Không tải được tuyến chính. Vui lòng kiểm tra kết nối và thử lại.
        </p>
      </div>
    );
  }
  if (!parent.data) {
    return (
      <div className="flex flex-col gap-6">
        <PageHeader title={route ? "Sửa tuyến con" : "Thêm tuyến con"} description="Đang tải dữ liệu…" />
        <Skeleton className="h-[440px] rounded-xl" aria-label="Đang tải tuyến chính" />
      </div>
    );
  }
  return <SubRouteFormBody key={`${route?.id ?? "new"}-${parent.data.updatedAt}`} parent={parent.data} route={route} />;
}

function SubRouteFormBody({ parent, route }: { parent: Route; route?: Route }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [saved, setSaved] = useState(useSearchParams().get("saved") === "1");
  const [values, setValues] = useState<SubRouteValues>(() => (route ? toSubRouteValues(route) : EMPTY_SUB_ROUTE));
  const [errors, setErrors] = useState<{ name?: string; bounds?: string; status?: string; form?: string }>({});
  const stops = parent.stops;
  const slice = sliceOf(stops, values.fromKey, values.toKey);
  const totals = sliceTotals(slice);
  const preview = useQuery({
    queryKey: ["route-name-preview", route?.id ?? parent.id, JSON.stringify(slice.map(pointKey))],
    // Tuyến đang sửa không tính trùng tên với chính nó; tạo mới thì điểm thuộc tuyến chính nên giữ được điểm đã ngừng.
    queryFn: () => previewRouteName(sliceStopInputs(slice), route?.id ?? parent.id),
    enabled: values.nameSource === "AUTO" && slice.length >= 2,
    staleTime: 60_000
  });

  function change(next: Partial<SubRouteValues>) {
    setValues((current) => ({ ...current, ...next }));
    setErrors({});
    setSaved(false);
  }

  const save = useMutation({
    mutationFn: () => {
      const input = toSubRouteInput(values, stops)!;
      return route ? updateSubRoute(parent.id, route.id, input) : createSubRoute(parent.id, input);
    },
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["routes"] });
      void queryClient.invalidateQueries({ queryKey: ["route", parent.id] });
      void queryClient.invalidateQueries({ queryKey: ["sub-route-suggestions", parent.id] });
      queryClient.setQueryData(["route", result.id], result);
      if (!route) {
        router.replace(`/routes/${result.id}?saved=1`);
        return;
      }
      setValues(toSubRouteValues(result));
      setSaved(true);
    },
    onError: (error) => {
      const { field, message } = describeSubRouteError(error);
      setErrors(field ? { [field]: message } : { form: message });
    }
  });

  function submit() {
    if (!toSubRouteInput(values, stops)) {
      setErrors({ bounds: "Chọn điểm đầu và điểm cuối của tuyến con." });
      return;
    }
    if (values.nameSource === "MANUAL" && values.name.trim() === "") {
      setErrors({ name: "Nhập tên tuyến hoặc bật tự đặt tên." });
      return;
    }
    save.mutate();
  }

  const fare = route ? parent.subRoutes.find((sub) => sub.id === route.id)?.fare : undefined;
  const nameText =
    slice.length < 2
      ? "Chọn hai đầu để có tên"
      : preview.isPending
        ? "Đang ghép tên…"
        : preview.isError
          ? "Chưa xem trước được tên — khi lưu hệ thống sẽ tự ghép"
          : preview.data;

  return (
    <div className="flex flex-col gap-6">
      <PageHeader
        title={route ? "Sửa tuyến con" : "Thêm tuyến con"}
        description={`Tuyến chính: ${parent.name}. Điểm dừng lấy theo tuyến chính; khách mua chặng trên chuyến của tuyến chính.`}
        actions={
          <>
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href={`/routes/${parent.id}`}>
                <ArrowLeft className="size-[18px]" />
                Về tuyến chính
              </Link>
            </Button>
            <Button type="button" className={`${BUTTON} w-40`} disabled={save.isPending} onClick={submit}>
              {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {save.isPending ? "Đang lưu…" : "Lưu tuyến con"}
            </Button>
          </>
        }
      />

      {saved && (
        <div role="status" className="flex items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5 text-sm leading-5 text-success-600">
          <CircleCheck className="size-5 shrink-0" />
          Đã lưu tuyến con.
        </div>
      )}
      {route?.needsReview && (
        <div role="alert" className="flex items-start gap-3 rounded-lg bg-warning-50 px-5 py-3.5 text-sm leading-5 text-warning-700">
          <CircleAlert className="mt-px size-5 shrink-0" />
          Tuyến chính đã đổi điểm dừng nên điểm đầu / cuối của tuyến con không còn hợp lệ — tuyến con đã tự về Nháp. Chọn lại
          hai đầu rồi lưu.
        </div>
      )}
      {errors.form && (
        <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-5 py-3.5 text-sm leading-5 text-error-600">
          <CircleAlert className="size-5 shrink-0" />
          {errors.form}
        </div>
      )}

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_440px]">
        <section aria-labelledby="sub-route-slice-heading" className={CARD}>
          <div className="flex flex-col gap-1">
            <h2 id="sub-route-slice-heading" className={CARD_TITLE}>
              Đoạn trên tuyến chính
            </h2>
            <p className={HELPER}>Điểm đầu cho đón, điểm cuối cho trả. Điểm ở giữa giữ quyền đón / trả như tuyến chính.</p>
          </div>
          <div className="grid gap-4 sm:grid-cols-2">
            <FormField label="Điểm đầu *" error={errors.bounds}>
              {(control) => (
                <Select value={values.fromKey || undefined} onValueChange={(fromKey) => change({ fromKey, toKey: "" })}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn điểm đầu" />
                  </SelectTrigger>
                  <SelectContent>
                    {fromOptions(stops).map((stop) => (
                      <SelectItem key={pointKey(stop)} value={pointKey(stop)}>
                        {stop.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
            <FormField label="Điểm cuối *">
              {(control) => (
                <Select value={values.toKey || undefined} onValueChange={(toKey) => change({ toKey })} disabled={!values.fromKey}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn điểm cuối" />
                  </SelectTrigger>
                  <SelectContent>
                    {toOptions(stops, values.fromKey).map((stop) => (
                      <SelectItem key={pointKey(stop)} value={pointKey(stop)}>
                        {stop.name}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          </div>
          {slice.length === 0 ? (
            <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
              Chọn điểm đầu và điểm cuối để xem đoạn.
            </p>
          ) : (
            <ol className="flex flex-col divide-y rounded-lg border" aria-label="Điểm dừng của tuyến con">
              {slice.map((stop, index) => {
                const last = index === slice.length - 1;
                const flags =
                  index === 0 ? "Điểm đầu · đón" : last ? "Điểm cuối · trả" : [stop.allowPickup && "đón", stop.allowDropoff && "trả"].filter(Boolean).join(" · ") || "Dừng nghỉ";
                return (
                  <li key={pointKey(stop)} className="flex items-center gap-3 px-4 py-2.5">
                    <span className="flex size-6 shrink-0 items-center justify-center rounded-full bg-muted text-xs font-semibold">{index + 1}</span>
                    <span className="min-w-0 flex-1 truncate text-sm leading-5 text-vxn-ink">{stop.name}</span>
                    <span className={HELPER}>{flags}</span>
                  </li>
                );
              })}
            </ol>
          )}
          {slice.length > 0 && (
            <p className="text-sm leading-5 text-vxn-ink">
              {formatDistance(totals.distanceMeters)} · {formatDuration(totals.durationSeconds)}
            </p>
          )}
        </section>

        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="sub-route-info-heading" className={CARD}>
            <h2 id="sub-route-info-heading" className={CARD_TITLE}>
              Thông tin tuyến con
            </h2>
            <FormField label={values.nameSource === "AUTO" ? "Tên tuyến" : "Tên tuyến *"} error={errors.name}>
              {(control) =>
                values.nameSource === "AUTO" ? (
                  <Input {...control} readOnly aria-readonly value={nameText ?? ""} className="bg-muted/50" />
                ) : (
                  <Input {...control} value={values.name} maxLength={NAME_MAX} onChange={(event) => change({ name: event.target.value })} />
                )
              }
            </FormField>
            <div className="flex items-start gap-3">
              <Switch
                id="sub-route-auto-name"
                checked={values.nameSource === "AUTO"}
                onCheckedChange={(checked) =>
                  change(checked ? { nameSource: "AUTO" } : { nameSource: "MANUAL", name: preview.data ?? values.name })
                }
              />
              <label htmlFor="sub-route-auto-name" className="text-sm leading-5 font-medium text-vxn-ink">
                Tự đặt tên theo điểm dừng
              </label>
            </div>
            <FormField label="Trạng thái *" helper="Bật cần có bảng giá đang áp dụng." error={errors.status}>
              {(control) => (
                <Select value={values.status} onValueChange={(status) => change({ status: status as SubRouteValues["status"] })}>
                  <SelectTrigger {...control}>
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
            </FormField>
            <FormField label="Ghi chú" helper={`Tùy chọn · ${values.note.length} / ${NOTE_MAX} ký tự`}>
              {(control) => (
                <Textarea {...control} rows={3} maxLength={NOTE_MAX} value={values.note} onChange={(event) => change({ note: event.target.value })} />
              )}
            </FormField>
          </section>

          {route && (
            <section aria-labelledby="sub-route-fare-heading" className={CARD}>
              <h2 id="sub-route-fare-heading" className={CARD_TITLE}>
                Bảng giá
              </h2>
              <p className={HELPER}>
                {fare
                  ? "Tuyến con có bảng giá riêng. Xem lại giá trước khi bật."
                  : "Tuyến con chưa có bảng giá. Tạo bảng giá rồi mới bật được."}
              </p>
              <Button asChild variant="outline" className={`${BUTTON} self-start bg-card`}>
                <Link href={fare ? `/fares/${fare.id}` : `/fares/new?routeId=${route.id}`}>
                  <Tag className="size-[18px]" />
                  {fare ? "Mở bảng giá" : "Tạo bảng giá"}
                </Link>
              </Button>
            </section>
          )}
        </div>
      </div>
    </div>
  );
}
