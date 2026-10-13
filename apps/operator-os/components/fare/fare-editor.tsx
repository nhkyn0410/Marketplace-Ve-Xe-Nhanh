"use client";

import { useInfiniteQuery, useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
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
import { cn } from "@vexenhanh/ui/lib/utils";
import {
  ArrowLeft,
  Check,
  CircleAlert,
  CircleCheck,
  FileX2,
  Info,
  LoaderCircle,
  Pencil,
  Plus,
  RefreshCw,
  Trash2
} from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useMemo, useState, type ReactNode } from "react";

import { ApiError } from "../../lib/auth/api-client";
import {
  createFare,
  getFare,
  listAllFares,
  listFareRevisions,
  updateFare,
  type Fare,
  type FareRule,
  type FareStatus
} from "../../lib/fare/fare-api";
import {
  ANY,
  describeFareSaveError,
  EMPTY_FARE_INFO,
  EMPTY_RULE_FORM,
  FARE_NOTE_MAX_LENGTH,
  findConflict,
  MAX_FARE_RULES,
  parseRuleForm,
  sortRules,
  toFareCreateInput,
  toFareInfo,
  toFareUpdateInput,
  toRuleForm,
  type FareInfoValues,
  type RuleFormErrors,
  type RuleFormValues
} from "../../lib/fare/fare-form";
import {
  describeRevision,
  FARE_STATUS,
  FARE_STATUS_ORDER,
  formatMoment,
  formatVnd,
  ruleSeatTypeLabel,
  ruleVehicleTypeLabel,
  ruleWindowLabel
} from "../../lib/fare/fare-format";
import { listAllRoutes } from "../../lib/route/route-api";
import { SEAT_TYPES } from "../../lib/seat-map/seat-map-editor";
import { listVehicleTypes } from "../../lib/vehicle/vehicle-api";
import { sortVehicleTypes, vehicleTypeLabel } from "../../lib/vehicle/vehicle-format";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";
import { PageHeader } from "../page-header";
import { TABLE, TABLE_CELL, TABLE_HEAD_CELL, TABLE_HEAD_ROW } from "../stop-point/list-controls";

const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-lg leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const ICON_BUTTON =
  "flex size-8 shrink-0 items-center justify-center rounded-lg text-muted-foreground outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-40";

/**
 * Màn Tạo / Chỉnh sửa bảng giá của một tuyến (Figma "02 · Bảng giá / Chỉnh sửa bảng giá"; FR-OPS-08, BR-40,
 * BR-41). Không truyền `fareId` = tạo mới (tuyến lấy từ `?routeId=` hoặc ô chọn). Lưu là thay toàn bộ quy tắc.
 */
export function FareEditor({ fareId }: { fareId?: string }) {
  const fare = useQuery({
    queryKey: ["fare", fareId],
    queryFn: () => getFare(fareId!),
    enabled: fareId !== undefined,
    // Form giữ bản sao các quy tắc đang sửa: không tải lại ngầm khi đổi tab rồi quay lại.
    refetchOnWindowFocus: false
  });
  const title = fareId ? "Chỉnh sửa bảng giá" : "Tạo bảng giá";

  if (fare.error instanceof ApiError && fare.error.status === 404) {
    return (
      <Shell title={title} description="Không tìm thấy bảng giá.">
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy bảng giá"
          description="Bảng giá không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/fares">Về danh sách bảng giá</Link>
            </Button>
          }
        />
      </Shell>
    );
  }
  // Chỉ khi CHƯA có dữ liệu: một lần tải lại lỗi không được xóa các quy tắc đang sửa dở.
  if (fare.isError && !fare.data) {
    return (
      <Shell title={title} description="Chưa tải được dữ liệu.">
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được bảng giá"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => void fare.refetch()}>
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </Shell>
    );
  }
  if (fareId && fare.isPending) {
    return (
      <Shell title={title} description="Đang tải dữ liệu…">
        <div role="status" aria-label="Đang tải bảng giá" className="grid gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
          <Skeleton className="h-[440px] rounded-xl" />
          <Skeleton className="h-[440px] rounded-xl" />
        </div>
      </Shell>
    );
  }
  // Đổi bảng giá (hoặc từ tạo sang sửa) thì dựng lại form với dữ liệu của bảng giá đó.
  return <FareEditorBody key={fare.data?.id ?? "new"} fare={fare.data} />;
}

function FareEditorBody({ fare }: { fare?: Fare }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const searchParams = useSearchParams();
  const [saved, setSaved] = useState(searchParams.get("saved") === "1");
  const [formError, setFormError] = useState<string | null>(null);
  const [routeError, setRouteError] = useState<string | null>(null);
  const [rulesError, setRulesError] = useState<string | null>(null);
  const [confirmLeave, setConfirmLeave] = useState(false);
  const [info, setInfo] = useState<FareInfoValues>(() =>
    fare ? toFareInfo(fare) : { ...EMPTY_FARE_INFO, routeId: searchParams.get("routeId") ?? "" }
  );
  const [rules, setRules] = useState<FareRule[]>(() => fare?.rules ?? []);
  // Khối nhập quy tắc: `null` = đang đóng; `index = null` = thêm mới, ngược lại là sửa dòng đó.
  const [editing, setEditing] = useState<{ index: number | null; values: RuleFormValues; errors: RuleFormErrors } | null>(null);
  // Khối nhập vừa đóng: nút "Thêm quy tắc" dựng lại nhận tiêu điểm, để dùng bàn phím không phải Tab lại từ đầu trang.
  const [returnFocus, setReturnFocus] = useState(false);

  const vehicleTypes = useQuery({ queryKey: ["catalog", "vehicle-types"], queryFn: listVehicleTypes, staleTime: 300_000 });
  // Chỉ cần khi tạo mới: ô chọn tuyến liệt kê tuyến đang hoạt động chưa có bảng giá.
  const routes = useQuery({ queryKey: ["routes", "all", "ACTIVE"], queryFn: () => listAllRoutes("ACTIVE"), enabled: !fare });
  const fares = useQuery({ queryKey: ["fares", "all"], queryFn: listAllFares, enabled: !fare });

  const typeNames = useMemo(
    () => new Map((vehicleTypes.data ?? []).map((type) => [type.id, vehicleTypeLabel(type)])),
    [vehicleTypes.data]
  );
  const typeOptions = useMemo(() => sortVehicleTypes(vehicleTypes.data ?? []), [vehicleTypes.data]);
  // Danh mục chưa tải xong / tải lỗi: chưa kết luận được một loại xe là "đã ngừng dùng".
  const unknownType = vehicleTypes.isSuccess ? undefined : vehicleTypes.isError ? "Chưa tải được loại xe" : "Đang tải…";
  const typeLabel = (vehicleTypeId: string | null) => ruleVehicleTypeLabel(typeNames, vehicleTypeId, unknownType);
  const routeOptions = useMemo(() => {
    const taken = new Set((fares.data ?? []).map((item) => item.routeId));
    return (routes.data ?? []).filter((route) => !taken.has(route.id));
  }, [routes.data, fares.data]);
  const routeName = fare?.routeName ?? routeOptions.find((route) => route.id === info.routeId)?.name;

  const savedState = useMemo(
    () => JSON.stringify(fare ? { info: toFareInfo(fare), rules: fare.rules } : { info: EMPTY_FARE_INFO, rules: [] }),
    [fare]
  );
  const dirty = editing !== null || JSON.stringify({ info: fare ? info : { ...info, routeId: "" }, rules }) !== savedState;

  const save = useMutation({
    mutationFn: () => (fare ? updateFare(fare.id, toFareUpdateInput(info, rules)) : createFare(toFareCreateInput(info, rules))),
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["fares"] });
      void queryClient.invalidateQueries({ queryKey: ["fare-revisions", result.id] });
      // Giá từng chỗ ở trang chi tiết chuyến lấy theo bảng giá này.
      void queryClient.invalidateQueries({ queryKey: ["trip"] });
      queryClient.setQueryData(["fare", result.id], result);
      if (!fare) {
        router.replace(`/fares/${result.id}?saved=1`);
        return;
      }
      setInfo(toFareInfo(result));
      setRules(result.rules);
      setSaved(true);
    },
    onError: (error) => {
      const { field, message } = describeFareSaveError(error);
      if (field === "routeId") {
        setRouteError(message);
      } else if (field === "rules") {
        setRulesError(message);
      } else {
        setFormError(message);
      }
    }
  });

  function submit() {
    setFormError(null);
    setRouteError(null);
    setRulesError(null);
    setSaved(false);
    // Tuyến có thể đến từ `?routeId=` trên URL: chỉ lưu khi nó đúng là lựa chọn đang hiện trong ô chọn, để không
    // tạo bảng giá cho một tuyến mà màn hình không cho thấy đang chọn.
    if (!fare && !routeOptions.some((route) => route.id === info.routeId)) {
      setRouteError(
        routes.isError || fares.isError
          ? "Chưa tải được danh sách tuyến. Tải lại trang rồi thử lại."
          : "Chọn tuyến của bảng giá."
      );
      return;
    }
    if (editing) {
      // Quy tắc đang nhập dở chưa nằm trong bảng: lưu lúc này sẽ lặng lẽ bỏ mất nó.
      setRulesError("Bấm “Áp dụng quy tắc” hoặc “Bỏ” cho quy tắc đang nhập trước khi lưu bảng giá.");
      return;
    }
    save.mutate();
  }

  function applyRule() {
    if (!editing) {
      return;
    }
    const { rule, errors } = parseRuleForm(editing.values);
    if (rule && findConflict(rules, rule, editing.index) !== -1) {
      errors.scope = "Đã có quy tắc cùng loại xe, loại chỗ và trùng khung giờ. Sửa quy tắc đó hoặc đổi khung giờ.";
    }
    if (!rule || errors.scope) {
      setEditing({ ...editing, errors });
      return;
    }
    const next = editing.index === null ? [...rules, rule] : rules.map((item, index) => (index === editing.index ? rule : item));
    setRules(sortRules(next));
    setEditing(null);
    setReturnFocus(true);
    setRulesError(null);
    setSaved(false);
  }

  const editingRule = editing?.index != null ? rules[editing.index] : undefined;

  return (
    <Shell
      title={routeName ? `Bảng giá · ${routeName}` : "Tạo bảng giá"}
      description="Quy tắc cụ thể hơn được ưu tiên: có khung giờ hơn mọi ngày, đúng loại xe hơn “mọi loại xe”, đúng loại chỗ hơn “mọi loại chỗ”."
      actions={
        <>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-20 bg-card`}
            disabled={save.isPending}
            onClick={() => (dirty ? setConfirmLeave(true) : router.push("/fares"))}
          >
            Hủy
          </Button>
          <Button type="button" className={`${BUTTON} w-40`} disabled={save.isPending} onClick={submit}>
            {save.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            {save.isPending ? "Đang lưu…" : "Lưu bảng giá"}
          </Button>
        </>
      }
    >
      {saved && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã lưu bảng giá</p>
            <p className="text-sm leading-5 text-success-600">Giá mới áp dụng cho lượt đặt vé sau thời điểm này.</p>
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

      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_360px]">
        <section aria-labelledby="fare-rules-heading" className={CARD}>
          <div className="flex flex-wrap items-center gap-3">
            <div className="flex min-w-0 flex-1 flex-col gap-0.5">
              <h2 id="fare-rules-heading" className={CARD_TITLE}>
                Quy tắc giá
              </h2>
              <p className="text-[13px] leading-[19.5px] text-muted-foreground">
                Chỗ đôi (giường đôi, cabin đôi) có giá theo chỗ, không tính theo số người.
              </p>
            </div>
            <p className={HELPER}>
              {rules.length} / {MAX_FARE_RULES} quy tắc
            </p>
          </div>

          {rulesError && (
            <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              <CircleAlert className="size-5 shrink-0" />
              {rulesError}
            </div>
          )}
          {vehicleTypes.isError && (
            <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3">
              <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">
                Chưa tải được danh mục loại xe nên chưa chọn được loại xe cho quy tắc.
              </p>
              <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => void vehicleTypes.refetch()}>
                Thử lại
              </Button>
            </div>
          )}

          {rules.length === 0 ? (
            <p className="rounded-lg border border-dashed px-4 py-6 text-center text-sm leading-5 text-muted-foreground">
              Chưa có quy tắc giá. Thêm ít nhất một quy tắc “mọi loại xe · mọi loại chỗ” để mọi chỗ đều có giá.
            </p>
          ) : (
            <div className="overflow-x-auto">
              <table className={`${TABLE} min-w-[620px]`}>
                <colgroup>
                  <col />
                  <col className="w-[22%]" />
                  <col className="w-[28%]" />
                  <col className="w-[18%]" />
                  <col className="w-[84px]" />
                </colgroup>
                <thead>
                  <tr className={TABLE_HEAD_ROW}>
                    <th scope="col" className={TABLE_HEAD_CELL}>
                      Loại xe
                    </th>
                    <th scope="col" className={TABLE_HEAD_CELL}>
                      Loại chỗ
                    </th>
                    <th scope="col" className={TABLE_HEAD_CELL}>
                      Khung giờ khởi hành
                    </th>
                    <th scope="col" className={`${TABLE_HEAD_CELL} text-right`}>
                      Giá mỗi chỗ
                    </th>
                    <th scope="col" className={TABLE_HEAD_CELL}>
                      <span className="sr-only">Thao tác</span>
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {rules.map((rule, index) => {
                    const name = `${typeLabel(rule.vehicleTypeId)}, ${ruleSeatTypeLabel(rule.seatType)}, ${ruleWindowLabel(rule)}`;
                    return (
                      <tr
                        key={[rule.vehicleTypeId, rule.seatType, rule.validFrom].join("|")}
                        className={cn("h-[49px] border-b", editing?.index === index && "bg-accent")}
                      >
                        <td className={TABLE_CELL}>{typeLabel(rule.vehicleTypeId)}</td>
                        <td className={TABLE_CELL}>{ruleSeatTypeLabel(rule.seatType)}</td>
                        <td className={TABLE_CELL}>{ruleWindowLabel(rule)}</td>
                        <td className={`${TABLE_CELL} text-right font-semibold whitespace-nowrap text-vxn-ink`}>
                          {formatVnd(rule.price)}
                        </td>
                        <td className={TABLE_CELL}>
                          <div className="flex items-center justify-end gap-1">
                            <button
                              type="button"
                              className={ICON_BUTTON}
                              aria-label={`Sửa quy tắc ${name}`}
                              disabled={editing !== null || save.isPending}
                              onClick={() => setEditing({ index, values: toRuleForm(rule), errors: {} })}
                            >
                              <Pencil className="size-4" />
                            </button>
                            <button
                              type="button"
                              className={ICON_BUTTON}
                              aria-label={`Xóa quy tắc ${name}`}
                              disabled={editing !== null || save.isPending}
                              onClick={() => {
                                setRules(rules.filter((_item, position) => position !== index));
                                setRulesError(null);
                                setSaved(false);
                              }}
                            >
                              <Trash2 className="size-4" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}

          {editing ? (
            <RuleForm
              title={editing.index === null ? "Thêm quy tắc" : "Sửa quy tắc đang chọn"}
              values={editing.values}
              errors={editing.errors}
              typeOptions={typeOptions.map((type) => ({ id: type.id, label: vehicleTypeLabel(type) }))}
              // Loại xe của dòng đang sửa đã bị ngừng trong danh mục: vẫn giữ làm một lựa chọn để không đổi ngầm.
              keptType={
                editingRule?.vehicleTypeId && !typeNames.has(editingRule.vehicleTypeId)
                  ? { id: editingRule.vehicleTypeId, label: typeLabel(editingRule.vehicleTypeId) }
                  : undefined
              }
              onChange={(values) => setEditing({ ...editing, values, errors: {} })}
              onCancel={() => {
                setEditing(null);
                setReturnFocus(true);
              }}
              onApply={applyRule}
            />
          ) : (
            <div>
              <Button
                type="button"
                variant="outline"
                className={`${BUTTON} bg-card`}
                disabled={rules.length >= MAX_FARE_RULES || save.isPending}
                autoFocus={returnFocus}
                onClick={() => setEditing({ index: null, values: EMPTY_RULE_FORM, errors: {} })}
              >
                <Plus className="size-[18px]" />
                Thêm quy tắc
              </Button>
            </div>
          )}
        </section>

        <div className="flex min-w-0 flex-col gap-5">
          <section aria-labelledby="fare-info-heading" className={`${CARD} gap-4 p-5`}>
            <h2 id="fare-info-heading" className={CARD_TITLE}>
              Thông tin bảng giá
            </h2>
            {fare ? (
              <div className="flex flex-col gap-1">
                <p className="text-xs leading-[18px] font-medium text-muted-foreground">Tuyến</p>
                <p className="text-sm leading-5 font-medium text-vxn-ink">{fare.routeName}</p>
              </div>
            ) : (
              <FormField
                label="Tuyến *"
                helper={
                  routes.isSuccess && fares.isSuccess && routeOptions.length === 0
                    ? "Mọi tuyến đang hoạt động đã có bảng giá."
                    : "Chỉ liệt kê tuyến đang hoạt động chưa có bảng giá."
                }
                error={
                  routeError ??
                  (routes.isError || fares.isError ? "Chưa tải được danh sách tuyến. Tải lại trang rồi thử lại." : undefined)
                }
              >
                {(control) => (
                  <Select
                    value={routeOptions.some((route) => route.id === info.routeId) ? info.routeId : ""}
                    onValueChange={(routeId) => {
                      setInfo({ ...info, routeId });
                      setRouteError(null);
                    }}
                  >
                    <SelectTrigger {...control}>
                      <SelectValue placeholder="Chọn tuyến" />
                    </SelectTrigger>
                    <SelectContent>
                      {routeOptions.map((route) => (
                        <SelectItem key={route.id} value={route.id}>
                          {route.name}
                        </SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                )}
              </FormField>
            )}
            <FormField label="Trạng thái *">
              {(control) => (
                <Select
                  value={info.status}
                  onValueChange={(status) => {
                    setInfo({ ...info, status: status as FareStatus });
                    setSaved(false);
                  }}
                >
                  <SelectTrigger {...control}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    {FARE_STATUS_ORDER.map((value) => (
                      <SelectItem key={value} value={value}>
                        {FARE_STATUS[value].label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
            <FormField label="Ghi chú" helper={`Không bắt buộc · ${info.note.length} / ${FARE_NOTE_MAX_LENGTH} ký tự`}>
              {(control) => (
                <Textarea
                  {...control}
                  rows={3}
                  maxLength={FARE_NOTE_MAX_LENGTH}
                  value={info.note}
                  onChange={(event) => {
                    setInfo({ ...info, note: event.target.value });
                    setSaved(false);
                  }}
                />
              )}
            </FormField>
          </section>

          {fare && <RevisionCard fareId={fare.id} typeNames={typeNames} unknownType={unknownType} />}
        </div>
      </div>

      <AlertDialog open={confirmLeave} onOpenChange={setConfirmLeave}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Bỏ thay đổi chưa lưu?</AlertDialogTitle>
            <AlertDialogDescription>Quy tắc giá vừa sửa sẽ không được lưu nếu bạn rời trang này.</AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ở lại</AlertDialogCancel>
            <AlertDialogAction onClick={() => router.push("/fares")}>Rời trang</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </Shell>
  );
}

/** Khối nhập một quy tắc giá (Figma "Sửa quy tắc"): loại xe, loại chỗ, khung giờ khởi hành và giá. */
function RuleForm({
  title,
  values,
  errors,
  typeOptions,
  keptType,
  onChange,
  onCancel,
  onApply
}: {
  title: string;
  values: RuleFormValues;
  errors: RuleFormErrors;
  typeOptions: { id: string; label: string }[];
  keptType?: { id: string; label: string };
  onChange: (values: RuleFormValues) => void;
  onCancel: () => void;
  onApply: () => void;
}) {
  return (
    <div role="group" aria-label={title} className="flex flex-col gap-3 rounded-[10px] border bg-background p-4">
      <p className="text-sm leading-5 font-semibold text-vxn-ink">{title}</p>
      <div className="grid gap-3 sm:grid-cols-2">
        <FormField label="Loại xe">
          {(control) => (
            <Select value={values.vehicleTypeId} onValueChange={(vehicleTypeId) => onChange({ ...values, vehicleTypeId })}>
              <SelectTrigger {...control} autoFocus>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={ANY}>Mọi loại xe</SelectItem>
                {keptType && <SelectItem value={keptType.id}>{keptType.label}</SelectItem>}
                {typeOptions.map((type) => (
                  <SelectItem key={type.id} value={type.id}>
                    {type.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          )}
        </FormField>
        <FormField label="Loại chỗ">
          {(control) => (
            <Select value={values.seatType} onValueChange={(seatType) => onChange({ ...values, seatType })}>
              <SelectTrigger {...control}>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value={ANY}>Mọi loại chỗ</SelectItem>
                {SEAT_TYPES.map((seat) => (
                  <SelectItem key={seat.type} value={seat.type}>
                    {seat.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>
          )}
        </FormField>
      </div>
      <div className="grid gap-3 sm:grid-cols-3">
        <FormField label="Khởi hành từ" error={errors.from}>
          {(control) => (
            <Input
              {...control}
              type="datetime-local"
              value={values.from}
              onChange={(event) => onChange({ ...values, from: event.target.value })}
            />
          )}
        </FormField>
        <FormField label="Đến trước" error={errors.to}>
          {(control) => (
            <Input
              {...control}
              type="datetime-local"
              value={values.to}
              onChange={(event) => onChange({ ...values, to: event.target.value })}
            />
          )}
        </FormField>
        <FormField label="Giá mỗi chỗ (₫) *" error={errors.price}>
          {(control) => (
            <Input
              {...control}
              inputMode="numeric"
              autoComplete="off"
              placeholder="300.000"
              value={values.price}
              onChange={(event) => onChange({ ...values, price: event.target.value })}
              onKeyDown={(event) => {
                if (event.key === "Enter") {
                  event.preventDefault();
                  onApply();
                }
              }}
            />
          )}
        </FormField>
      </div>
      {errors.scope && (
        <p role="alert" className="text-xs leading-[18px] text-error-600">
          {errors.scope}
        </p>
      )}
      <p className={HELPER}>
        Khung giờ tính theo giờ khởi hành của chuyến, gồm mốc bắt đầu và không gồm mốc kết thúc; dùng cho giá dịp lễ,
        Tết. Bỏ trống cả hai ô để áp dụng mọi ngày. Giá là số nguyên từ 0 đến 100.000.000 ₫.
      </p>
      <div className="flex justify-end gap-3">
        <Button type="button" variant="ghost" className={`${BUTTON} text-vxn-fg-1`} onClick={onCancel}>
          Bỏ
        </Button>
        <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={onApply}>
          <Check className="size-[18px]" />
          Áp dụng quy tắc
        </Button>
      </div>
    </div>
  );
}

/** Thẻ "Lịch sử thay đổi" (BR-40): mới nhất trước, tải thêm theo trang. */
function RevisionCard({
  fareId,
  typeNames,
  unknownType
}: {
  fareId: string;
  typeNames: ReadonlyMap<string, string>;
  unknownType?: string;
}) {
  const revisions = useInfiniteQuery({
    queryKey: ["fare-revisions", fareId],
    queryFn: ({ pageParam }) => listFareRevisions(fareId, pageParam),
    initialPageParam: undefined as string | undefined,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined
  });
  const items = revisions.data?.pages.flatMap((page) => page.items) ?? [];

  return (
    <section aria-labelledby="fare-history-heading" className={`${CARD} gap-3.5 p-5`}>
      <h2 id="fare-history-heading" className={CARD_TITLE}>
        Lịch sử thay đổi
      </h2>
      {revisions.isPending ? (
        <div role="status" aria-label="Đang tải lịch sử thay đổi" className="flex flex-col gap-3">
          <Skeleton className="h-10 rounded-lg" />
          <Skeleton className="h-10 rounded-lg" />
        </div>
      ) : revisions.isError && !revisions.data ? (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3">
          <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được lịch sử thay đổi.</p>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => void revisions.refetch()}>
            Thử lại
          </Button>
        </div>
      ) : items.length === 0 ? (
        <p className="text-sm leading-5 text-muted-foreground">Chưa có thay đổi nào được ghi lại.</p>
      ) : (
        <ol className="flex flex-col">
          {items.map((revision) => {
            const { title, detail } = describeRevision(revision, typeNames, unknownType);
            return (
              <li key={`${revision.createdAt}-${revision.action}`} className="flex gap-3">
                <div aria-hidden className="flex w-3 shrink-0 flex-col items-center gap-1 pt-[5px]">
                  <span
                    className={cn(
                      "size-2.5 rounded-full",
                      revision.action === "fare.create" ? "bg-muted-foreground" : "bg-primary"
                    )}
                  />
                  <span className="w-0.5 flex-1 rounded-[1px] bg-border" />
                </div>
                <div className="flex min-w-0 flex-1 flex-col gap-0.5 pb-3.5">
                  <div className="flex items-start gap-2">
                    <p className="min-w-0 flex-1 text-sm leading-5 font-semibold break-words text-vxn-ink">{title}</p>
                    <p className="shrink-0 text-xs leading-[18px] whitespace-nowrap text-muted-foreground">
                      {formatMoment(revision.createdAt)}
                    </p>
                  </div>
                  <p className="text-[13px] leading-[19.5px] text-muted-foreground">
                    {[detail, "Chủ nhà xe"].filter(Boolean).join(" · ")}
                  </p>
                </div>
              </li>
            );
          })}
        </ol>
      )}
      {revisions.hasNextPage && (
        <button
          type="button"
          className="w-fit rounded text-left text-[13px] leading-[19.5px] text-vxn-teal-700 outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:opacity-60"
          disabled={revisions.isFetchingNextPage}
          onClick={() => void revisions.fetchNextPage()}
        >
          {revisions.isFetchingNextPage ? "Đang tải…" : "Xem thêm lịch sử ›"}
        </button>
      )}
      {revisions.isFetchNextPageError && (
        <p role="alert" className="text-xs leading-[18px] text-error-600">
          Chưa tải thêm được lịch sử. Bấm “Xem thêm lịch sử” để thử lại.
        </p>
      )}
      <div role="note" className="flex gap-2 rounded-lg bg-accent p-3">
        <Info className="mt-px size-4 shrink-0 text-vxn-teal-700" />
        <p className="min-w-0 flex-1 text-[13px] leading-[19.5px] text-vxn-fg-1">
          Sửa bảng giá không làm đổi giá của vé đã bán.
        </p>
      </div>
    </section>
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
        href="/fares"
        className="flex w-fit items-center gap-1.5 rounded text-sm leading-5 font-medium text-vxn-teal-700 outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
      >
        <ArrowLeft className="size-4" />
        Quay lại danh sách bảng giá
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
