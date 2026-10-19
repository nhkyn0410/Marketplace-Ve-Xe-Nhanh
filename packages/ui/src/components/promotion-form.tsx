"use client";

import { Check, LoaderCircle } from "lucide-react";
import { useState, type ReactNode } from "react";

import { fromLocalInput, toLocalInput } from "../lib/promotion-format";
import { Button } from "./button";
import { FormField } from "./form-field";
import { Input } from "./input";
import { BUTTON } from "./list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./select";

// Form tạo / sửa khuyến mãi (Figma "Nhà xe · Khuyến mãi / Tạo", ADM-11a "Tạo khuyến mãi"; TASK-PROM-001) — dùng chung Admin + Operator
// OS. Admin không có ô tuyến (khuyến mãi nền tảng áp toàn hệ thống); nhà xe chọn tuyến của mình.

export type PromotionFormValues = {
  code: string;
  name: string;
  discountType: "PERCENT" | "AMOUNT";
  discountValue: number;
  maxDiscount: number | null;
  minOrder: number;
  routeId: string | null;
  tripId: string | null;
  startsAt: string;
  endsAt: string;
  usageLimit: number;
};

const ALL_ROUTES = "all";
const VND = new Intl.NumberFormat("vi-VN");
const digits = (value: string) => Number(value.replace(/\D/g, "")) || 0;
const showMoney = (value: number) => (value ? VND.format(value) : "");

export function emptyPromotion(now: number = Date.now()): PromotionFormValues {
  const start = new Date(now);
  start.setMinutes(0, 0, 0);
  return {
    code: "",
    name: "",
    discountType: "PERCENT",
    discountValue: 10,
    maxDiscount: null,
    minOrder: 0,
    routeId: null,
    tripId: null,
    startsAt: start.toISOString(),
    endsAt: new Date(start.getTime() + 30 * 86_400_000).toISOString(),
    usageLimit: 100
  };
}

type Errors = Partial<Record<keyof PromotionFormValues | "form", string>>;

/** Kiểm ở trình duyệt (server vẫn kiểm lại + kiểm giới hạn được cấp). */
export function validatePromotion(values: PromotionFormValues): Errors {
  const errors: Errors = {};
  if (!/^[A-Z0-9]{3,20}$/.test(values.code)) errors.code = "Mã gồm 3–20 chữ / số, không dấu, không khoảng trắng.";
  if (values.name.trim().length < 3) errors.name = "Nhập tên chương trình (3–120 ký tự).";
  if (values.discountType === "PERCENT" && (values.discountValue < 1 || values.discountValue > 100)) errors.discountValue = "Phần trăm từ 1 tới 100.";
  if (values.discountType === "AMOUNT" && values.discountValue < 1) errors.discountValue = "Nhập số tiền giảm.";
  if (Date.parse(values.endsAt) <= Date.parse(values.startsAt)) errors.endsAt = "Kết thúc phải sau thời điểm bắt đầu.";
  if (values.usageLimit < 1) errors.usageLimit = "Tổng lượt dùng ít nhất 1.";
  return errors;
}

export function PromotionForm({
  initial,
  routes,
  pending,
  serverError,
  editable = true,
  aside,
  onSubmit
}: {
  initial: PromotionFormValues;
  /** Có = form của nhà xe (chọn tuyến); không = khuyến mãi nền tảng. */
  routes?: { value: string; label: string }[];
  pending: boolean;
  serverError: string | null;
  editable?: boolean;
  aside?: (values: PromotionFormValues) => ReactNode;
  onSubmit: (values: PromotionFormValues, activate: boolean) => void;
}) {
  const [values, setValues] = useState(initial);
  const [errors, setErrors] = useState<Errors>({});
  const set = <K extends keyof PromotionFormValues>(key: K, value: PromotionFormValues[K]) => setValues((current) => ({ ...current, [key]: value }));
  const disabled = pending || !editable;
  const submit = (activate: boolean) => {
    const found = validatePromotion(values);
    setErrors(found);
    if (Object.keys(found).length === 0) onSubmit({ ...values, name: values.name.trim() }, activate);
  };
  return (
    <form
      className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]"
      onSubmit={(event) => {
        event.preventDefault();
        submit(false);
      }}
    >
      <div className="flex min-w-0 flex-col gap-6">
        <Section title="Thông tin chương trình">
          <div className="grid gap-4 md:grid-cols-[220px_minmax(0,1fr)]">
            <FormField label="Mã khuyến mãi *" helper="Hành khách nhập mã này khi đặt vé." error={errors.code}>
              {(control) => <Input {...control} maxLength={20} value={values.code} disabled={disabled} onChange={(event) => set("code", event.target.value.toUpperCase().replace(/\s/g, ""))} />}
            </FormField>
            <FormField label="Tên chương trình *" helper="Hiển thị trong danh sách và ví voucher." error={errors.name}>
              {(control) => <Input {...control} maxLength={120} value={values.name} disabled={disabled} onChange={(event) => set("name", event.target.value)} />}
            </FormField>
          </div>
        </Section>
        <Section title="Mức giảm">
          <fieldset className="grid gap-3 md:grid-cols-2" disabled={disabled}>
            <legend className="sr-only">Loại giảm</legend>
            <Choice checked={values.discountType === "PERCENT"} title="Giảm theo phần trăm" description="Giảm theo % giá vé, có mức trần." onSelect={() => setValues({ ...values, discountType: "PERCENT", discountValue: 10 })} />
            <Choice checked={values.discountType === "AMOUNT"} title="Giảm số tiền cố định" description="Giảm một số tiền cho mỗi đơn." onSelect={() => setValues({ ...values, discountType: "AMOUNT", discountValue: 30_000, maxDiscount: null })} />
          </fieldset>
          <div className="grid gap-4 md:grid-cols-3">
            {values.discountType === "PERCENT" ? (
              <>
                <FormField label="Mức giảm (%) *" error={errors.discountValue}>
                  {(control) => <Input {...control} inputMode="numeric" value={values.discountValue || ""} disabled={disabled} onChange={(event) => set("discountValue", digits(event.target.value))} />}
                </FormField>
                <FormField label="Giảm tối đa mỗi đơn (₫)" error={errors.maxDiscount}>
                  {(control) => <Input {...control} inputMode="numeric" value={showMoney(values.maxDiscount ?? 0)} disabled={disabled} onChange={(event) => set("maxDiscount", digits(event.target.value) || null)} />}
                </FormField>
              </>
            ) : (
              <FormField label="Số tiền giảm (₫) *" error={errors.discountValue}>
                {(control) => <Input {...control} inputMode="numeric" value={showMoney(values.discountValue)} disabled={disabled} onChange={(event) => set("discountValue", digits(event.target.value))} />}
              </FormField>
            )}
            <FormField label="Giá trị đơn tối thiểu (₫)">
              {(control) => <Input {...control} inputMode="numeric" value={showMoney(values.minOrder)} disabled={disabled} onChange={(event) => set("minOrder", digits(event.target.value))} />}
            </FormField>
          </div>
        </Section>
        <Section title="Phạm vi và thời gian">
          {routes && (
            <FormField label="Tuyến áp dụng *">
              {(control) => (
                <Select value={values.routeId ?? ALL_ROUTES} onValueChange={(value) => setValues({ ...values, routeId: value === ALL_ROUTES ? null : value, tripId: null })} disabled={disabled}>
                  <SelectTrigger id={control.id}>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value={ALL_ROUTES}>Mọi tuyến của nhà xe</SelectItem>
                    {routes.map((route) => (
                      <SelectItem key={route.value} value={route.value}>
                        {route.label}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              )}
            </FormField>
          )}
          <div className="grid gap-4 md:grid-cols-3">
            <FormField label="Hiệu lực từ *">
              {(control) => <Input {...control} type="datetime-local" value={toLocalInput(values.startsAt)} disabled={disabled} onChange={(event) => event.target.value && set("startsAt", fromLocalInput(event.target.value))} />}
            </FormField>
            <FormField label="Đến *" error={errors.endsAt}>
              {(control) => <Input {...control} type="datetime-local" value={toLocalInput(values.endsAt)} disabled={disabled} onChange={(event) => event.target.value && set("endsAt", fromLocalInput(event.target.value))} />}
            </FormField>
            <FormField label="Tổng lượt dùng *" error={errors.usageLimit}>
              {(control) => <Input {...control} inputMode="numeric" value={values.usageLimit ? VND.format(values.usageLimit) : ""} disabled={disabled} onChange={(event) => set("usageLimit", digits(event.target.value))} />}
            </FormField>
          </div>
        </Section>
        {serverError && (
          <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
            {serverError}
          </p>
        )}
        {editable && (
          <div className="flex flex-wrap justify-end gap-3">
            <Button type="submit" variant="outline" className={`${BUTTON} bg-card`} disabled={pending}>
              Lưu nháp
            </Button>
            <Button type="button" className={BUTTON} disabled={pending} onClick={() => submit(true)}>
              {pending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
              Kích hoạt
            </Button>
          </div>
        )}
      </div>
      {aside && <div className="flex min-w-0 flex-col gap-6">{aside(values)}</div>}
    </form>
  );
}

function Section({ title, children }: { title: string; children: ReactNode }) {
  return (
    <section aria-label={title} className="flex flex-col gap-4 rounded-xl border bg-card p-6">
      <h2 className="text-lg leading-7 font-semibold text-vxn-ink">{title}</h2>
      {children}
    </section>
  );
}

function Choice({ checked, title, description, onSelect }: { checked: boolean; title: string; description: string; onSelect: () => void }) {
  return (
    <label className={`flex cursor-pointer gap-3 rounded-lg border p-4 text-sm leading-5 ${checked ? "border-primary bg-accent" : "bg-card"}`}>
      <input type="radio" name="discount-type" className="mt-1 accent-[var(--primary)]" checked={checked} onChange={onSelect} />
      <span className="flex flex-col gap-0.5">
        <span className="font-semibold text-vxn-ink">{title}</span>
        <span className="text-muted-foreground">{description}</span>
      </span>
    </label>
  );
}
