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
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  DropdownMenu,
  DropdownMenuCheckboxItem,
  DropdownMenuContent,
  DropdownMenuTrigger
} from "@vexenhanh/ui/components/dropdown-menu";
import { Input } from "@vexenhanh/ui/components/input";
import { Label } from "@vexenhanh/ui/components/label";
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
import { ChevronDown, CircleAlert, CircleCheck, Copy, FileX2, ImagePlus, LoaderCircle, RefreshCw } from "lucide-react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { useId, useMemo, useState, type ReactNode } from "react";
import { Controller, useForm } from "react-hook-form";

import { ApiError } from "../../lib/auth/api-client";
import {
  createVehicle,
  getSeatMap,
  getVehicle,
  listAllSeatMaps,
  listAmenities,
  listVehicleTypes,
  updateVehicle,
  type Amenity,
  type SeatMapSummary,
  type Vehicle,
  type VehicleType
} from "../../lib/vehicle/vehicle-api";
import {
  describeSaveError,
  DESCRIPTION_MAX_LENGTH,
  EMPTY_VEHICLE_FORM,
  toFormValues,
  toVehicleInput,
  vehicleFormSchema,
  type VehicleFormValues
} from "../../lib/vehicle/vehicle-form";
import {
  formatPlateNumber,
  sortVehicleTypes,
  VEHICLE_STATUS,
  VEHICLE_STATUS_ORDER,
  vehicleTypeLabel
} from "../../lib/vehicle/vehicle-format";
import { PageHeader } from "../page-header";
import { SeatMapPreview } from "./seat-map-preview";

const BUTTON = "h-10 rounded-lg px-4 text-sm font-semibold";
const CARD = "flex flex-col gap-5 rounded-xl border bg-card p-6";
const CARD_TITLE = "text-base leading-6 font-semibold text-vxn-ink";
const HELPER = "text-xs leading-[18px] text-muted-foreground";
const NO_SEAT_MAP = "NONE";
const FORM_ID = "vehicle-form";

/** Màn Thêm / Sửa phương tiện (Figma 02, 04; FR-OPS-01..02, UC-12). Không truyền `vehicleId` = thêm mới. */
export function VehicleForm({ vehicleId }: { vehicleId?: string }) {
  const vehicleTypes = useQuery({ queryKey: ["catalog", "vehicle-types"], queryFn: listVehicleTypes, staleTime: 300_000 });
  const amenities = useQuery({ queryKey: ["catalog", "amenities"], queryFn: listAmenities, staleTime: 300_000 });
  const seatMaps = useQuery({ queryKey: ["seat-maps", "all"], queryFn: listAllSeatMaps });
  const vehicle = useQuery({
    queryKey: ["vehicle", vehicleId],
    queryFn: () => getVehicle(vehicleId!),
    enabled: vehicleId !== undefined
  });
  const queries = [vehicleTypes, amenities, seatMaps, ...(vehicleId ? [vehicle] : [])];

  if (vehicle.error instanceof ApiError && vehicle.error.status === 404) {
    return (
      <FormShell title="Sửa phương tiện" description="Không tìm thấy phương tiện.">
        <StatePanel
          icon={<FileX2 className="size-6 text-vxn-fg-3" />}
          title="Không tìm thấy phương tiện"
          description="Phương tiện không tồn tại hoặc không thuộc nhà xe của bạn."
          action={
            <Button asChild variant="outline" className={`${BUTTON} bg-card`}>
              <Link href="/vehicles">Về danh sách phương tiện</Link>
            </Button>
          }
        />
      </FormShell>
    );
  }
  if (queries.some((query) => query.isError)) {
    return (
      <FormShell title={vehicleId ? "Sửa phương tiện" : "Thêm phương tiện"} description="Chưa tải được dữ liệu.">
        <StatePanel
          icon={<CircleAlert className="size-6 text-warning-700" />}
          title="Không tải được dữ liệu"
          description="Không kết nối được máy chủ. Vui lòng kiểm tra kết nối và thử lại."
          action={
            <Button
              variant="outline"
              className={`${BUTTON} bg-card`}
              onClick={() => queries.filter((query) => query.isError).forEach((query) => void query.refetch())}
            >
              <RefreshCw className="size-[18px]" />
              Thử lại
            </Button>
          }
        />
      </FormShell>
    );
  }
  if (queries.some((query) => query.isPending)) {
    return (
      <FormShell title={vehicleId ? "Sửa phương tiện" : "Thêm phương tiện"} description="Đang tải dữ liệu…">
        <div role="status" aria-label="Đang tải thông tin phương tiện" className="grid gap-6 xl:grid-cols-[minmax(0,672fr)_minmax(0,440fr)]">
          <Skeleton className="h-[440px] rounded-xl" />
          <Skeleton className="h-[440px] rounded-xl" />
        </div>
      </FormShell>
    );
  }
  return (
    <VehicleFormBody
      // Đổi xe (hoặc từ thêm sang sửa) thì dựng lại form với giá trị của xe đó.
      key={vehicle.data?.id ?? "new"}
      vehicle={vehicleId ? vehicle.data! : undefined}
      vehicleTypes={vehicleTypes.data!}
      amenities={amenities.data!}
      seatMaps={seatMaps.data!}
    />
  );
}

function VehicleFormBody({
  vehicle,
  vehicleTypes,
  amenities,
  seatMaps
}: {
  vehicle?: Vehicle;
  vehicleTypes: VehicleType[];
  amenities: Amenity[];
  seatMaps: SeatMapSummary[];
}) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const searchParams = useSearchParams();
  const justCreated = searchParams.get("saved") === "1";
  // Vừa lưu một sơ đồ ở trình soạn rồi quay lại (`?seatMap=`): chọn sẵn sơ đồ đó, người dùng chỉ cần lưu xe.
  const returnedSeatMap =
    !vehicle?.seatMapLocked && seatMaps.find((seatMap) => seatMap.id === searchParams.get("seatMap"));
  const [saved, setSaved] = useState(justCreated);
  const [formError, setFormError] = useState<string | null>(null);
  const [confirmLeave, setConfirmLeave] = useState(false);
  const [confirmCopy, setConfirmCopy] = useState(false);

  const stored = vehicle ? toFormValues(vehicle, formatPlateNumber) : EMPTY_VEHICLE_FORM;
  const form = useForm<VehicleFormValues>({
    resolver: zodResolver(vehicleFormSchema),
    // `defaultValues` là dữ liệu đã lưu; `values` chồng sơ đồ vừa tạo lên trên nên form ở trạng thái "đã sửa".
    defaultValues: stored,
    values: returnedSeatMap ? { ...stored, seatMapId: returnedSeatMap.id } : undefined,
    resetOptions: { keepDefaultValues: true }
  });
  const { errors, isDirty } = form.formState;
  const description = form.watch("description");
  const seatMapId = form.watch("seatMapId");

  const save = useMutation({
    mutationFn: (values: VehicleFormValues) =>
      vehicle ? updateVehicle(vehicle.id, toVehicleInput(values)) : createVehicle(toVehicleInput(values)),
    onSuccess: (result) => {
      void queryClient.invalidateQueries({ queryKey: ["vehicles"] });
      queryClient.setQueryData(["vehicle", result.id], result);
      if (!vehicle) {
        router.replace(`/vehicles/${result.id}?saved=1`);
        return;
      }
      form.reset(toFormValues(result, formatPlateNumber));
      setSaved(true);
    },
    onError: (error) => {
      const { field, message } = describeSaveError(error);
      if (field) {
        form.setError(field, { message }, { shouldFocus: field === "plateNumber" });
      } else {
        setFormError(message);
      }
      if (error instanceof ApiError && error.code === "CATALOG_ITEM_UNAVAILABLE") {
        // Catalog vừa đổi: tải lại để ô chọn không còn mục đã ngừng.
        void queryClient.invalidateQueries({ queryKey: ["catalog"] });
      }
    }
  });

  // Loại xe đã bị ngừng vẫn giữ được trên xe cũ (API cho phép) → thêm một lựa chọn để không mất khi lưu.
  const typeOptions = useMemo(() => {
    const options = sortVehicleTypes(vehicleTypes).map((type) => ({ id: type.id, label: vehicleTypeLabel(type) }));
    if (vehicle && !options.some((option) => option.id === vehicle.vehicleTypeId)) {
      options.push({ id: vehicle.vehicleTypeId, label: "Loại xe đã ngừng dùng" });
    }
    return options;
  }, [vehicleTypes, vehicle]);

  const plate = vehicle ? formatPlateNumber(vehicle.plateNumber) : null;
  const locked = vehicle?.seatMapLocked ?? false;
  const selectedSeatMap = seatMaps.find((seatMap) => seatMap.id === seatMapId) ?? null;
  const copyHref = `/seat-maps/new?copyFrom=${seatMapId}&vehicle=${vehicle?.id ?? "new"}`;

  function submit(values: VehicleFormValues) {
    setFormError(null);
    setSaved(false);
    save.mutate(values);
  }

  return (
    <FormShell
      title={vehicle ? "Sửa phương tiện" : "Thêm phương tiện"}
      description={
        vehicle
          ? `${plate} · ${saved ? "Thông tin xe đã được lưu." : "Cập nhật thông tin và ảnh phương tiện."}`
          : "Thông tin có dấu * là bắt buộc."
      }
      actions={
        <>
          <Button
            type="button"
            variant="outline"
            className={`${BUTTON} w-20 bg-card`}
            disabled={save.isPending}
            onClick={() => (isDirty ? setConfirmLeave(true) : router.push("/vehicles"))}
          >
            Hủy
          </Button>
          <Button type="submit" form={FORM_ID} className={`${BUTTON} w-[188px]`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {save.isPending ? "Đang lưu phương tiện…" : "Lưu phương tiện"}
          </Button>
        </>
      }
    >
      {saved && (
        <div role="status" className="flex flex-wrap items-center gap-3 rounded-lg bg-success-50 px-5 py-3.5">
          <CircleCheck className="size-5 shrink-0 text-success-600" />
          <div className="min-w-0 flex-1">
            <p className="text-sm leading-5 font-semibold text-success-600">Đã lưu phương tiện</p>
            <p className="text-sm leading-5 text-success-600">Thông tin phương tiện đã được cập nhật.</p>
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
      {returnedSeatMap && isDirty && (
        <p role="status" className="rounded-lg bg-accent px-5 py-3.5 text-sm leading-5 text-vxn-teal-700">
          Đã chọn sơ đồ “{returnedSeatMap.name}” vừa lưu. Bấm “Lưu phương tiện” để gắn sơ đồ này cho xe.
        </p>
      )}

      <form
        id={FORM_ID}
        noValidate
        onSubmit={(event) => void form.handleSubmit(submit)(event)}
        className="grid items-start gap-6 xl:grid-cols-[minmax(0,672fr)_minmax(0,440fr)]"
      >
        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="vehicle-info-heading" className={CARD}>
            <h2 id="vehicle-info-heading" className={CARD_TITLE}>
              Thông tin phương tiện
            </h2>
            <div className="grid gap-x-6 gap-y-5 sm:grid-cols-2">
              <Field label="Biển số xe *" helper="Ví dụ: 51B-289.12" error={errors.plateNumber?.message}>
                {(control) => (
                  <Input
                    {...control}
                    {...form.register("plateNumber")}
                    autoComplete="off"
                    maxLength={20}
                    placeholder="51B-289.12"
                  />
                )}
              </Field>
              <Field label="Dạng chỗ · Hạng xe *" helper="Dạng chỗ và hạng xe" error={errors.vehicleTypeId?.message}>
                {(control) => (
                  <Controller
                    control={form.control}
                    name="vehicleTypeId"
                    render={({ field }) => (
                      <Select value={field.value} onValueChange={field.onChange}>
                        <SelectTrigger {...control} onBlur={field.onBlur}>
                          <SelectValue placeholder="Chọn dạng chỗ và hạng xe" />
                        </SelectTrigger>
                        <SelectContent>
                          {typeOptions.map((option) => (
                            <SelectItem key={option.id} value={option.id}>
                              {option.label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    )}
                  />
                )}
              </Field>
              <Field label="Trạng thái *" error={errors.status?.message}>
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
                          {VEHICLE_STATUS_ORDER.map((status) => (
                            <SelectItem key={status} value={status}>
                              {VEHICLE_STATUS[status].label}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    )}
                  />
                )}
              </Field>
              <Field label="Tiện ích" helper="Chọn một hoặc nhiều tiện ích" labelGap="gap-2">
                {(control) => (
                  <Controller
                    control={form.control}
                    name="amenityIds"
                    render={({ field }) => (
                      <AmenitySelect {...control} amenities={amenities} value={field.value} onChange={field.onChange} />
                    )}
                  />
                )}
              </Field>
            </div>
            <Field
              label="Mô tả"
              helper={`${description.length} / ${DESCRIPTION_MAX_LENGTH} ký tự`}
              error={errors.description?.message}
              labelGap="gap-2"
            >
              {(control) => <Textarea {...control} {...form.register("description")} rows={2} />}
            </Field>
          </section>

          <VehicleImagesBlock />
        </div>

        <div className="flex min-w-0 flex-col gap-6">
          <section aria-labelledby="vehicle-seat-map-heading" className={CARD}>
            <h2 id="vehicle-seat-map-heading" className={CARD_TITLE}>
              Sơ đồ ghế
            </h2>
            <Field
              label={locked ? "Sơ đồ đang dùng" : "Chọn sơ đồ"}
              helper={locked ? "Đang được chuyến chưa kết thúc sử dụng" : "Mẫu dùng chung của nhà xe"}
              error={errors.seatMapId?.message}
            >
              {(control) => (
                <Controller
                  control={form.control}
                  name="seatMapId"
                  render={({ field }) => (
                    <Select
                      value={field.value ?? NO_SEAT_MAP}
                      onValueChange={(value) => field.onChange(value === NO_SEAT_MAP ? null : value)}
                      disabled={locked}
                    >
                      <SelectTrigger {...control} onBlur={field.onBlur}>
                        <SelectValue />
                      </SelectTrigger>
                      <SelectContent>
                        <SelectItem value={NO_SEAT_MAP}>Chưa gán sơ đồ</SelectItem>
                        {seatMaps.map((seatMap) => (
                          <SelectItem key={seatMap.id} value={seatMap.id}>
                            {seatMap.name}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  )}
                />
              )}
            </Field>
            {selectedSeatMap && <SeatMapSection seatMap={selectedSeatMap} />}
            {selectedSeatMap && !locked && (
              <>
                <p className="text-sm leading-5 text-muted-foreground">
                  Muốn thay đổi bố cục? Tạo bản sao để giữ nguyên sơ đồ dùng chung.
                </p>
                <Button
                  type="button"
                  variant="outline"
                  className={`${BUTTON} w-full bg-card text-vxn-fg-1`}
                  onClick={() => (isDirty ? setConfirmCopy(true) : router.push(copyHref))}
                >
                  <Copy className="size-[18px]" />
                  Tùy chỉnh bản sao
                </Button>
              </>
            )}
            {locked && (
              <div className="flex flex-col gap-2 rounded-lg bg-warning-50 p-4 text-warning-700">
                <p className="text-sm leading-5 font-semibold">Chưa thể đổi sơ đồ ghế</p>
                <p className="text-sm leading-5">
                  Sơ đồ đang được dùng cho chuyến chưa kết thúc. Bạn có thể đổi sơ đồ sau khi không còn chuyến sử
                  dụng.
                </p>
                <p className="text-xs leading-[18px]">Các thông tin xe khác vẫn có thể cập nhật.</p>
              </div>
            )}
          </section>
          <div className="flex gap-3 rounded-lg bg-accent p-4">
            <CircleAlert className="mt-px size-5 shrink-0 text-vxn-teal-700" />
            <p className="text-sm leading-5 text-vxn-teal-700">
              Có thể bổ sung sơ đồ sau. Xe cần có sơ đồ ghế hợp lệ trước khi dùng cho chuyến.
            </p>
          </div>
        </div>
      </form>

      <AlertDialog open={confirmLeave} onOpenChange={setConfirmLeave}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Bỏ thay đổi chưa lưu?</AlertDialogTitle>
            <AlertDialogDescription>
              Thông tin vừa nhập sẽ không được lưu nếu bạn rời trang này.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ở lại</AlertDialogCancel>
            <AlertDialogAction onClick={() => router.push("/vehicles")}>Rời trang</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>

      {/* Khanh chốt 04/10/2026: sang trình soạn thì KHÔNG giữ dữ liệu form chưa lưu, chỉ cảnh báo trước. */}
      <AlertDialog open={confirmCopy} onOpenChange={setConfirmCopy}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>Thông tin xe chưa lưu sẽ mất</AlertDialogTitle>
            <AlertDialogDescription>
              Mở trình soạn sơ đồ sẽ rời form này. Các thay đổi chưa lưu của phương tiện không được giữ lại — hãy
              lưu phương tiện trước nếu cần.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel>Ở lại để lưu</AlertDialogCancel>
            <AlertDialogAction onClick={() => router.push(copyHref)}>Vẫn mở trình soạn</AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </FormShell>
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

type ControlProps = { id: string; "aria-invalid": boolean; "aria-describedby": string | undefined };

/** Nhãn + ô nhập + dòng gợi ý; có lỗi thì lỗi thay chỗ gợi ý, ngay dưới ô (06 UI §10). */
function Field({
  label,
  helper,
  error,
  labelGap = "gap-1.5",
  children
}: {
  label: string;
  helper?: string;
  error?: string;
  labelGap?: string;
  children: (control: ControlProps) => ReactNode;
}) {
  const id = useId();
  const noteId = `${id}-note`;
  const note = error ?? helper;
  return (
    <div className={cn("flex min-w-0 flex-col", labelGap)}>
      <Label htmlFor={id}>{label}</Label>
      {children({ id, "aria-invalid": Boolean(error), "aria-describedby": note ? noteId : undefined })}
      {note && (
        <p id={noteId} role={error ? "alert" : undefined} className={error ? "text-xs leading-[18px] text-error-600" : HELPER}>
          {note}
        </p>
      )}
    </div>
  );
}

/** Ô chọn nhiều tiện ích: hai tên đầu thành thẻ, phần còn lại gộp "+N" (Figma "Amenities / Values"). */
function AmenitySelect({
  amenities,
  value,
  onChange,
  ...control
}: ControlProps & { amenities: Amenity[]; value: string[]; onChange: (value: string[]) => void }) {
  const selected = amenities.filter((amenity) => value.includes(amenity.id));
  // Tiện ích đã ngừng không còn trong catalog nhưng xe vẫn giữ: tính vào "+N" và gửi lại khi lưu.
  const hidden = value.length - Math.min(selected.length, 2);
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button
          type="button"
          {...control}
          className="flex h-10 w-full items-center gap-2 rounded-lg border border-input bg-card px-2 text-left text-sm outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50"
        >
          <span className="flex min-w-0 flex-1 items-center gap-2 overflow-hidden">
            {value.length === 0 && <span className="px-1 text-muted-foreground">Chọn tiện ích</span>}
            {selected.slice(0, 2).map((amenity) => (
              <Badge key={amenity.id} className="max-w-[45%] shrink truncate">
                <span className="truncate">{amenity.name}</span>
              </Badge>
            ))}
            {hidden > 0 && <Badge>+{hidden}</Badge>}
          </span>
          <ChevronDown className="size-4 shrink-0 text-muted-foreground" />
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="start" className="w-(--radix-dropdown-menu-trigger-width)">
        {amenities.map((amenity) => (
          <DropdownMenuCheckboxItem
            key={amenity.id}
            checked={value.includes(amenity.id)}
            // Giữ menu mở để chọn nhiều mục liên tiếp.
            onSelect={(event) => event.preventDefault()}
            onCheckedChange={(checked) =>
              onChange(checked ? [...value, amenity.id] : value.filter((id) => id !== amenity.id))
            }
          >
            {amenity.name}
          </DropdownMenuCheckboxItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

function SeatMapSection({ seatMap }: { seatMap: SeatMapSummary }) {
  const detail = useQuery({ queryKey: ["seat-map", seatMap.id], queryFn: () => getSeatMap(seatMap.id) });
  return (
    <>
      <div className="flex flex-wrap gap-2">
        <Badge>{seatMap.seatCount} chỗ</Badge>
        <Badge>{seatMap.passengerCapacity} người</Badge>
        <Badge>{seatMap.deckCount} tầng</Badge>
      </div>
      {detail.isPending && <Skeleton role="status" aria-label="Đang tải sơ đồ ghế" className="h-[308px]" />}
      {detail.isError && (
        <div role="alert" className="flex flex-wrap items-center gap-3 rounded-lg bg-error-50 px-4 py-3">
          <p className="min-w-0 flex-1 text-sm leading-5 text-error-600">Chưa tải được bố cục sơ đồ.</p>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={() => void detail.refetch()}>
            Thử lại
          </Button>
        </div>
      )}
      {detail.data && <SeatMapPreview key={detail.data.id} seatMap={detail.data} />}
    </>
  );
}

/**
 * Khối ảnh phương tiện theo mock (Khanh chốt "giữ như mock"). Tải / sắp xếp / xóa ảnh cần API của
 * TASK-TRN-009 nên vùng thêm ảnh chưa bấm được.
 */
function VehicleImagesBlock() {
  return (
    <section aria-labelledby="vehicle-images-heading" className={CARD}>
      <div className="flex items-start">
        <h2 id="vehicle-images-heading" className={`${CARD_TITLE} flex-1`}>
          Ảnh phương tiện
        </h2>
        <p className="text-xs leading-[18px] font-medium text-muted-foreground">0 / 8 ảnh</p>
      </div>
      <p className="text-sm leading-5 text-muted-foreground">Kéo thả để sắp xếp. Ảnh đầu tiên là ảnh đại diện.</p>
      <button
        type="button"
        disabled
        title="Tải ảnh sẽ có trong bản cập nhật sau."
        className="flex h-[120px] w-[212px] max-w-full cursor-not-allowed flex-col items-center justify-center gap-2 rounded-lg border border-dashed bg-background"
      >
        <ImagePlus className="size-6 text-vxn-teal-700" />
        <span className="text-sm leading-5 font-semibold text-vxn-teal-700">Thêm ảnh</span>
        <span className={HELPER}>hoặc kéo thả vào đây</span>
      </button>
      <p className={HELPER}>JPEG, PNG hoặc WebP · Tối đa 5 MB / ảnh · Tối đa 8 ảnh</p>
      <p className={`${HELPER} rounded-lg bg-muted p-3`}>Ảnh sẽ hiển thị công khai ngay sau khi lưu.</p>
    </section>
  );
}
