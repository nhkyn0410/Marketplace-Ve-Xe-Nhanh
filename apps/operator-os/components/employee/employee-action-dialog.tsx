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
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { cn } from "@vexenhanh/ui/lib/utils";
import { CircleAlert, Info, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent } from "react";

import { withReauth } from "../../lib/auth/reauth";
import { resetEmployeePassword, updateEmployee, type Employee } from "../../lib/employee/employee-api";
import { describeEmployeeError, REASON_MAX_LENGTH, reasonError } from "../../lib/employee/employee-form";
import { EMPLOYEE_ROLE, loginName } from "../../lib/employee/employee-format";
import { IdentityField, useIdentityField } from "../auth/identity-field";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

export type EmployeeActionKind = "reset" | "lock" | "unlock";
export type EmployeeActionTarget = { kind: EmployeeActionKind; employee: Employee };

type Copy = { title: string; submit: string; note: string; tone: "info" | "warning"; destructive: boolean };

function copyFor({ kind, employee }: EmployeeActionTarget): Copy {
  switch (kind) {
    case "reset":
      return {
        title: "Cấp lại mật khẩu tạm",
        submit: "Cấp lại mật khẩu",
        note: `Mật khẩu tạm mới được gửi tới ${employee.contactEmail}. Các phiên đang đăng nhập của nhân viên sẽ bị thu hồi. Mỗi nhân viên được cấp lại tối đa một lần mỗi giờ.`,
        tone: "info",
        destructive: false
      };
    case "lock":
      return {
        title: "Khóa tài khoản nhân viên",
        submit: "Khóa tài khoản",
        note: "Nhân viên sẽ bị đăng xuất khỏi mọi thiết bị và không đăng nhập được cho tới khi mở khóa.",
        tone: "warning",
        destructive: true
      };
    case "unlock":
      return {
        title: "Mở khóa tài khoản nhân viên",
        submit: "Mở khóa",
        note: "Nhân viên đăng nhập lại được. Nếu nhân viên quên mật khẩu, cấp lại mật khẩu tạm sau khi mở khóa.",
        tone: "info",
        destructive: false
      };
  }
}

/**
 * Hộp thoại cấp lại mật khẩu tạm / khóa / mở khóa một nhân viên (Figma "03", "04 · Nhân viên"; UC-16). Cả ba đều
 * bắt buộc lý do (lưu vào nhật ký) và xác nhận lại danh tính (TASK-IAM-005 Q8).
 */
export function EmployeeActionDialog({
  target,
  operatorSlug,
  onClose,
  onDone,
  onStale
}: {
  target: EmployeeActionTarget | null;
  operatorSlug: string;
  onClose: () => void;
  onDone: (target: EmployeeActionTarget) => void;
  /** Danh sách có thể đã khác — màn hình tải lại. */
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {target && (
        <ActionForm
          target={target}
          operatorSlug={operatorSlug}
          onClose={onClose}
          onDone={onDone}
          onStale={onStale}
          onPendingChange={setPending}
        />
      )}
    </Dialog>
  );
}

function ActionForm({
  target,
  operatorSlug,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: {
  target: EmployeeActionTarget;
  operatorSlug: string;
  onClose: () => void;
  onDone: (target: EmployeeActionTarget) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const { kind, employee } = target;
  const copy = copyFor(target);
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const identity = useIdentityField();
  // Tài khoản cũ có thể chưa có email: không có nơi nhận mật khẩu tạm nên phải thêm email trước.
  const blocked = kind === "reset" && !employee.contactEmail;

  const run = useMutation({
    mutationFn: (text: string) =>
      withReauth(identity.secret, async () => {
        if (kind === "reset") {
          await resetEmployeePassword(employee.id, text);
        } else {
          await updateEmployee(employee.id, { status: kind === "lock" ? "LOCKED" : "ACTIVE", reason: text });
        }
      }),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => onDone(target),
    onError: (error) => {
      const described = describeEmployeeError(error, kind === "reset" ? "reset" : "update");
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setFormError(described.message);
      if (described.refresh) {
        onStale();
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const invalid = reasonError(reason);
    setReasonMessage(invalid);
    const identityOk = identity.check();
    if (invalid || !identityOk) {
      return;
    }
    run.mutate(reason.trim());
  }

  const NoteIcon = copy.tone === "warning" ? TriangleAlert : Info;
  return (
    <DialogContent>
      <DialogHeader>
        <DialogTitle>{copy.title}</DialogTitle>
        <DialogDescription>
          {loginName(operatorSlug, employee.username)} · {EMPLOYEE_ROLE[employee.role].label}
        </DialogDescription>
      </DialogHeader>
      {blocked ? (
        <>
          <div role="alert" className="flex gap-3 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
            <TriangleAlert className="mt-px size-5 shrink-0" />
            Nhân viên này chưa có email liên hệ nên chưa có nơi nhận mật khẩu tạm. Sửa tài khoản để thêm email trước.
          </div>
          <DialogFooter>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={onClose}>
              Đã hiểu
            </Button>
          </DialogFooter>
        </>
      ) : (
        <form noValidate onSubmit={submit} className="flex flex-col gap-4">
          <div
            role="note"
            className={cn(
              "flex gap-3 rounded-lg px-4 py-3 text-sm leading-5",
              copy.tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-vxn-teal-700"
            )}
          >
            <NoteIcon className="mt-px size-5 shrink-0" />
            {copy.note}
          </div>

          <FormField
            label="Lý do *"
            helper={`3–${REASON_MAX_LENGTH} ký tự · lưu vào nhật ký thay đổi`}
            error={reasonMessage ?? undefined}
          >
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={REASON_MAX_LENGTH}
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

          {identity.needed && (
            <IdentityField
              value={identity.value}
              error={identity.error}
              disabled={run.isPending}
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
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button
              type="submit"
              variant={copy.destructive ? "destructive" : "default"}
              className={BUTTON}
              disabled={run.isPending}
            >
              {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {copy.submit}
            </Button>
          </DialogFooter>
        </form>
      )}
    </DialogContent>
  );
}
