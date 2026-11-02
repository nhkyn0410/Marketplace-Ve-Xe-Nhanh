"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { CircleAlert, Info, LoaderCircle } from "lucide-react";
import { useState, type FormEvent, type ReactNode } from "react";

import {
  activateCatalogItem,
  createAmenity,
  createProvince,
  createVehicleType,
  createWard,
  deactivateCatalogItem,
  listAllProvinces,
  updateCatalogItem,
  type CatalogItem,
  type CatalogKind,
  type VehicleClass,
  type VehicleForm
} from "../../lib/catalog/catalog-api";
import {
  codeError,
  DEACTIVATE_NOTE,
  DESCRIPTION_MAX_LENGTH,
  describeCatalogError,
  impactRows,
  KIND_COPY,
  NAME_MAX_LENGTH,
  nameError,
  REASON_MAX_LENGTH,
  reasonError,
  VEHICLE_CLASS,
  VEHICLE_FORM_LABELS
} from "../../lib/catalog/catalog-format";

export type ItemTarget = { kind: CatalogKind; item: CatalogItem | null };
export type StatusTarget = { kind: CatalogKind; item: CatalogItem };

/** Hộp thoại thêm / sửa một mục danh mục. Sửa chỉ đổi tên (loại xe: thêm mô tả); mã và thuộc tính gốc giữ nguyên. */
export function ItemDialog({
  target,
  onClose,
  onDone
}: {
  target: ItemTarget | null;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {target && <ItemForm target={target} onClose={onClose} onDone={onDone} onPendingChange={setPending} />}
    </Dialog>
  );
}

function ItemForm({
  target,
  onClose,
  onDone,
  onPendingChange
}: {
  target: ItemTarget;
  onClose: () => void;
  onDone: (message: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const { kind, item } = target;
  const editing = item !== null;
  const copy = KIND_COPY[kind];
  const [code, setCode] = useState("");
  const [name, setName] = useState(item?.name ?? "");
  const [description, setDescription] = useState(item && "description" in item ? (item.description ?? "") : "");
  const [provinceId, setProvinceId] = useState("");
  const [form, setForm] = useState<VehicleForm | "">("");
  const [vehicleClass, setVehicleClass] = useState<VehicleClass | "">("");
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [formError, setFormError] = useState<string | null>(null);
  const provinces = useQuery({
    queryKey: ["admin-catalog", "provinces", "all"],
    queryFn: listAllProvinces,
    enabled: kind === "wards" && !editing,
    staleTime: 60_000
  });

  const save = useMutation({
    mutationFn: async (): Promise<CatalogItem> => {
      if (editing) {
        return updateCatalogItem(kind, item.id, { name: name.trim(), description: description.trim() || null });
      }
      const fresh = { code: code.trim(), name: name.trim() };
      switch (kind) {
        case "provinces":
          return createProvince(fresh);
        case "wards":
          return createWard({ ...fresh, provinceId });
        case "vehicle-types":
          return createVehicleType({
            ...fresh,
            code: fresh.code.toUpperCase(),
            description: description.trim() || null,
            form: form as VehicleForm,
            class: vehicleClass as VehicleClass
          });
        case "amenities":
          return createAmenity({ ...fresh, code: fresh.code.toUpperCase() });
      }
    },
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (saved) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-catalog"] });
      onDone(editing ? `Đã lưu ${copy.noun} “${saved.name}”.` : `Đã thêm ${copy.noun} “${saved.name}”.`);
      onClose();
    },
    onError: (error) => {
      const described = describeCatalogError(error);
      if (described.field === "code") {
        setErrors({ code: described.message });
      } else {
        setFormError(described.message);
      }
      if (described.refresh) {
        void queryClient.invalidateQueries({ queryKey: ["admin-catalog"] });
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const next: Record<string, string> = {};
    const nameInvalid = nameError(name);
    if (nameInvalid) {
      next.name = nameInvalid;
    }
    if (!editing) {
      const codeInvalid = codeError(kind, code);
      if (codeInvalid) {
        next.code = codeInvalid;
      }
      if (kind === "wards" && provinceId === "") {
        next.provinceId = "Chọn tỉnh / thành.";
      }
      if (kind === "vehicle-types") {
        if (form === "") {
          next.form = "Chọn dạng chỗ.";
        }
        if (vehicleClass === "") {
          next.class = "Chọn hạng xe.";
        }
      }
    }
    setErrors(next);
    if (Object.keys(next).length === 0) {
      save.mutate();
    }
  }

  return (
    <DialogContent className="sm:max-w-[520px]">
      <DialogHeader>
        <DialogTitle>{editing ? `Sửa ${copy.noun}` : copy.add}</DialogTitle>
        <DialogDescription>
          {editing ? `Mã ${item.code} — mã không đổi được.` : "Mã không đổi được sau khi lưu."}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        {!editing && kind === "wards" && (
          <FormField label="Tỉnh / thành *" error={errors.provinceId}>
            {(control) => (
              <Select value={provinceId} onValueChange={setProvinceId} disabled={provinces.isPending}>
                <SelectTrigger {...control}>
                  <SelectValue placeholder={provinces.isPending ? "Đang tải…" : "Chọn tỉnh / thành"} />
                </SelectTrigger>
                <SelectContent>
                  {(provinces.data ?? []).map((province) => (
                    <SelectItem key={province.id} value={province.id}>
                      {province.name}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            )}
          </FormField>
        )}
        {!editing && (
          <FormField label="Mã *" helper={codeHelper(kind)} error={errors.code}>
            {(control) => (
              <Input
                {...control}
                name="code"
                value={code}
                maxLength={40}
                autoComplete="off"
                disabled={save.isPending}
                onChange={(event) => setCode(event.target.value)}
              />
            )}
          </FormField>
        )}
        <FormField label={kind === "vehicle-types" ? "Tên hiển thị *" : "Tên *"} error={errors.name}>
          {(control) => (
            <Input
              {...control}
              name="name"
              value={name}
              maxLength={NAME_MAX_LENGTH}
              autoComplete="off"
              disabled={save.isPending}
              onChange={(event) => setName(event.target.value)}
            />
          )}
        </FormField>
        {kind === "vehicle-types" && !editing && (
          <div className="grid gap-4 sm:grid-cols-2">
            <FormField label="Dạng chỗ *" error={errors.form}>
              {(control) => (
                <Select value={form} onValueChange={(value) => setForm(value as VehicleForm)}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn dạng chỗ" />
                  </SelectTrigger>
                  <SelectContent>
                    {(Object.keys(VEHICLE_FORM_LABELS) as VehicleForm[]).map((value) => (
                      <SelectItem key={value} value={value}>
                        {VEHICLE_FORM_LABELS[value]}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
            <FormField label="Hạng xe *" error={errors.class}>
              {(control) => (
                <Select value={vehicleClass} onValueChange={(value) => setVehicleClass(value as VehicleClass)}>
                  <SelectTrigger {...control}>
                    <SelectValue placeholder="Chọn hạng xe" />
                  </SelectTrigger>
                  <SelectContent>
                    {(Object.keys(VEHICLE_CLASS) as VehicleClass[]).map((value) => (
                      <SelectItem key={value} value={value}>
                        {VEHICLE_CLASS[value].label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          </div>
        )}
        {kind === "vehicle-types" && editing && "form" in item && (
          <p className="text-sm leading-5 text-muted-foreground">
            Dạng chỗ {VEHICLE_FORM_LABELS[item.form]} · hạng {VEHICLE_CLASS[item.class].label} — không đổi được vì xe và bảng
            giá đang dựa vào hai thuộc tính này.
          </p>
        )}
        {kind === "vehicle-types" && (
          <FormField label="Mô tả" helper={`Tùy chọn · tối đa ${DESCRIPTION_MAX_LENGTH} ký tự`}>
            {(control) => (
              <Textarea
                {...control}
                name="description"
                rows={2}
                maxLength={DESCRIPTION_MAX_LENGTH}
                value={description}
                disabled={save.isPending}
                onChange={(event) => setDescription(event.target.value)}
              />
            )}
          </FormField>
        )}
        <FormError message={formError} />
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={`${BUTTON} min-w-28`} disabled={save.isPending}>
            {save.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function codeHelper(kind: CatalogKind): string {
  switch (kind) {
    case "provinces":
      return "2 chữ số theo danh mục hành chính, vd 79.";
    case "wards":
      return "5 chữ số theo danh mục hành chính.";
    default:
      return "Chữ không dấu, số, gạch dưới; tự viết hoa, vd SLEEPER_LIMOUSINE.";
  }
}

/** Hộp thoại ngừng dùng (lý do 3–500 ký tự + mức ảnh hưởng, Figma ADM-04c) / dùng lại một mục. */
export function StatusDialog({
  target,
  onClose,
  onDone
}: {
  target: StatusTarget | null;
  onClose: () => void;
  onDone: (message: string) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {target && <StatusForm target={target} onClose={onClose} onDone={onDone} onPendingChange={setPending} />}
    </Dialog>
  );
}

function StatusForm({
  target,
  onClose,
  onDone,
  onPendingChange
}: {
  target: StatusTarget;
  onClose: () => void;
  onDone: (message: string) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const queryClient = useQueryClient();
  const { kind, item } = target;
  const copy = KIND_COPY[kind];
  const deactivate = item.status === "ACTIVE";
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const run = useMutation({
    mutationFn: () => (deactivate ? deactivateCatalogItem(kind, item.id, reason.trim()) : activateCatalogItem(kind, item.id)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ["admin-catalog"] });
      onDone(deactivate ? `Đã ngừng dùng ${copy.noun} “${item.name}”.` : `Đã dùng lại ${copy.noun} “${item.name}”.`);
      onClose();
    },
    onError: (error) => {
      const described = describeCatalogError(error);
      setFormError(described.message);
      if (described.refresh) {
        void queryClient.invalidateQueries({ queryKey: ["admin-catalog"] });
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    if (deactivate) {
      const invalid = reasonError(reason);
      setReasonMessage(invalid);
      if (invalid) {
        return;
      }
    }
    run.mutate();
  }

  const subtitle =
    "form" in item ? `Mã ${item.code} · dạng chỗ ${VEHICLE_FORM_LABELS[item.form]} · hạng ${VEHICLE_CLASS[item.class].label}` : `Mã ${item.code}`;
  return (
    <DialogContent className="sm:max-w-[520px]">
      <DialogHeader>
        <DialogTitle>{deactivate ? `Ngừng dùng ${copy.noun} “${item.name}”` : `Dùng lại ${copy.noun} “${item.name}”`}</DialogTitle>
        <DialogDescription>{subtitle}</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        {deactivate && (
          <div className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
            <p className="font-semibold text-vxn-ink">Mức ảnh hưởng</p>
            {impactRows(kind, item).map((row) => (
              <div key={row.label} className="flex justify-between gap-4">
                <span className="text-muted-foreground">{row.label}</span>
                <span className="text-right text-vxn-ink">{row.value}</span>
              </div>
            ))}
          </div>
        )}
        <Note>
          {deactivate ? DEACTIVATE_NOTE[kind] : `Mục này chọn được lại cho dữ liệu mới và hiện lại trong danh mục công khai.`}
        </Note>
        {deactivate && (
          <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={reasonMessage ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                name="reason"
                rows={3}
                maxLength={REASON_MAX_LENGTH}
                placeholder={`Nhập lý do (3–${REASON_MAX_LENGTH} ký tự)…`}
                value={reason}
                disabled={run.isPending}
                autoFocus
                onChange={(event) => {
                  setReason(event.target.value);
                  setReasonMessage(null);
                }}
              />
            )}
          </FormField>
        )}
        <FormError message={formError} />
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={run.isPending}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {deactivate ? "Ngừng dùng" : "Dùng lại"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function Note({ children }: { children: ReactNode }) {
  return (
    <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
      <Info className="mt-px size-5 shrink-0" />
      <p>{children}</p>
    </div>
  );
}

function FormError({ message }: { message: string | null }) {
  if (!message) {
    return null;
  }
  return (
    <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
      <CircleAlert className="size-5 shrink-0" />
      {message}
    </div>
  );
}
