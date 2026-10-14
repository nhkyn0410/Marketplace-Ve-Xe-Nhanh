"use client";

import { useMutation } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle
} from "@vexenhanh/ui/components/dialog";
import { Input } from "@vexenhanh/ui/components/input";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Check, CircleAlert, LoaderCircle } from "lucide-react";
import { useId, useState, type FormEvent } from "react";

import { withReauth } from "../../lib/auth/reauth";
import { createEmployee, updateEmployee, type Employee } from "../../lib/employee/employee-api";
import {
  describeEmployeeError,
  EMPTY_EMPLOYEE_FORM,
  REASON_MAX_LENGTH,
  toCreateInput,
  toEmployeeForm,
  toUpdateInput,
  validateEmployeeForm,
  type EmployeeFormErrors,
  type EmployeeFormValues
} from "../../lib/employee/employee-form";
import { EMPLOYEE_ROLE, EMPLOYEE_ROLE_ORDER, EMPLOYEE_USERNAME_PREFIX } from "../../lib/employee/employee-format";
import { IdentityField, useIdentityField } from "../auth/identity-field";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

/** Thêm mới, hoặc sửa một nhân viên đang có. */
export type EmployeeFormTarget = { mode: "create" } | { mode: "edit"; employee: Employee };

/**
 * Hộp thoại thêm / sửa nhân viên (Figma "02 · Nhân viên / Hộp thoại thêm nhân viên"; UC-16). Tên đăng nhập có
 * tiền tố cố định `{mã nhà xe}/nv.`; mật khẩu tạm do máy chủ sinh và gửi qua email, không hiện ở đây. Sửa thì bắt
 * buộc lý do. Cả hai đều cần xác nhận lại danh tính (TASK-IAM-005 Q8).
 */
export function EmployeeFormDialog({
  target,
  operatorSlug,
  onClose,
  onSaved,
  onStale
}: {
  target: EmployeeFormTarget | null;
  operatorSlug: string;
  onClose: () => void;
  onSaved: (employee: Employee, mode: "create" | "edit") => void;
  /** Danh sách có thể đã khác (vd tài khoản được tạo dù gửi email lỗi) — màn hình tải lại. */
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    // Đang gửi thì không cho đóng: kết quả về sau sẽ không còn chỗ hiện.
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {/* Chỉ dựng khi mở để mỗi lần mở là một form mới. */}
      {target && (
        <EmployeeForm
          target={target}
          operatorSlug={operatorSlug}
          onClose={onClose}
          onSaved={onSaved}
          onStale={onStale}
          onPendingChange={setPending}
        />
      )}
    </Dialog>
  );
}

function EmployeeForm({
  target,
  operatorSlug,
  onClose,
  onSaved,
  onStale,
  onPendingChange
}: {
  target: EmployeeFormTarget;
  operatorSlug: string;
  onClose: () => void;
  onSaved: (employee: Employee, mode: "create" | "edit") => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const editing = target.mode === "edit" ? target.employee : null;
  const [values, setValues] = useState<EmployeeFormValues>(editing ? toEmployeeForm(editing) : EMPTY_EMPLOYEE_FORM);
  const [errors, setErrors] = useState<EmployeeFormErrors>({});
  const [formError, setFormError] = useState<string | null>(null);
  const identity = useIdentityField();
  const roleGroupId = useId();

  const save = useMutation({
    mutationFn: (action: () => Promise<Employee>) => withReauth(identity.secret, action),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (employee) => onSaved(employee, target.mode),
    onError: (error) => {
      const described = describeEmployeeError(error, target.mode === "create" ? "create" : "update");
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      if (described.field === "suffix") {
        setErrors((current) => ({ ...current, suffix: described.message }));
      } else {
        setFormError(described.message);
      }
      if (described.refresh) {
        onStale();
      }
    }
  });

  function change(patch: Partial<EmployeeFormValues>) {
    setValues((current) => ({ ...current, ...patch }));
    setErrors((current) => {
      const next = { ...current };
      for (const key of Object.keys(patch) as (keyof EmployeeFormValues)[]) {
        delete next[key];
      }
      return next;
    });
    setFormError(null);
  }

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const found = validateEmployeeForm(values, target.mode);
    setErrors(found);
    const identityOk = identity.check();
    if (Object.keys(found).length > 0 || !identityOk) {
      return;
    }
    if (editing) {
      const input = toUpdateInput(editing, values);
      if (!input) {
        setFormError("Chưa có thay đổi nào để lưu.");
        return;
      }
      save.mutate(() => updateEmployee(editing.id, input));
    } else {
      save.mutate(() => createEmployee(toCreateInput(values)));
    }
  }

  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>{editing ? "Sửa tài khoản nhân viên" : "Thêm nhân viên"}</DialogTitle>
        <DialogDescription>
          {editing
            ? "Đổi tên đăng nhập hoặc email sẽ đăng xuất nhân viên khỏi mọi thiết bị. Đổi email thì phải cấp lại mật khẩu tạm tới email mới."
            : "Mật khẩu tạm được gửi tới email liên hệ. Nhân viên phải đổi mật khẩu ở lần đăng nhập đầu trên ứng dụng Nhân viên."}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField
          label="Tên đăng nhập *"
          helper="Phần sau “nv.” dài 2–61 ký tự, gồm chữ thường a–z, số, dấu chấm, gạch dưới hoặc gạch ngang."
          error={errors.suffix}
        >
          {(control) => (
            <div className="flex">
              <span className="flex h-10 shrink-0 items-center rounded-l-lg border border-r-0 border-input bg-muted px-3 text-sm text-muted-foreground">
                {operatorSlug}/{EMPLOYEE_USERNAME_PREFIX}
              </span>
              <Input
                {...control}
                className="rounded-l-none"
                autoComplete="off"
                autoCapitalize="none"
                spellCheck={false}
                maxLength={61}
                value={values.suffix}
                disabled={save.isPending}
                onChange={(event) => change({ suffix: event.target.value })}
              />
            </div>
          )}
        </FormField>

        <FormField
          label="Email liên hệ *"
          helper="Mật khẩu tạm được gửi tới email này."
          error={errors.contactEmail}
        >
          {(control) => (
            <Input
              {...control}
              type="email"
              autoComplete="off"
              maxLength={254}
              value={values.contactEmail}
              disabled={save.isPending}
              onChange={(event) => change({ contactEmail: event.target.value })}
            />
          )}
        </FormField>

        <fieldset
          aria-describedby={errors.role ? `${roleGroupId}-error` : undefined}
          className="flex min-w-0 flex-col gap-2"
          disabled={save.isPending}
        >
          <legend className="pb-1.5 text-sm leading-5 font-medium text-vxn-ink">Vai trò *</legend>
          {EMPLOYEE_ROLE_ORDER.map((role) => {
            const checked = values.role === role;
            return (
              <label
                key={role}
                className={cn(
                  "flex cursor-pointer gap-3 rounded-lg border px-4 py-3 has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50",
                  checked ? "border-2 border-primary bg-accent" : "bg-card"
                )}
              >
                <input
                  type="radio"
                  name={roleGroupId}
                  value={role}
                  checked={checked}
                  onChange={() => change({ role })}
                  className="mt-1 size-4 shrink-0 accent-primary outline-none"
                />
                <span className="flex min-w-0 flex-col gap-0.5">
                  <span className="text-sm leading-5 font-semibold text-vxn-ink">{EMPLOYEE_ROLE[role].label}</span>
                  <span className="text-xs leading-[18px] text-muted-foreground">{EMPLOYEE_ROLE[role].description}</span>
                </span>
              </label>
            );
          })}
          {errors.role && (
            <p id={`${roleGroupId}-error`} role="alert" className="text-xs leading-[18px] text-error-600">
              {errors.role}
            </p>
          )}
        </fieldset>

        {editing && (
          <FormField
            label="Lý do thay đổi *"
            helper={`3–${REASON_MAX_LENGTH} ký tự · lưu vào nhật ký thay đổi`}
            error={errors.reason}
          >
            {(control) => (
              <Textarea
                {...control}
                rows={2}
                maxLength={REASON_MAX_LENGTH}
                value={values.reason}
                disabled={save.isPending}
                onChange={(event) => change({ reason: event.target.value })}
              />
            )}
          </FormField>
        )}

        {identity.needed && (
          <IdentityField
            value={identity.value}
            error={identity.error}
            disabled={save.isPending}
            onChange={identity.change}
          />
        )}

        {formError && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {formError}
          </div>
        )}

        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={save.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={save.isPending}>
            {save.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            {editing ? "Lưu thay đổi" : "Tạo tài khoản"}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
