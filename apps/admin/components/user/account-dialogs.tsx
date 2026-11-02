"use client";

import { useMutation } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
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
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { CircleAlert, Info, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent, type ReactNode } from "react";

import { describeAccountError, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";

export type AccountAction = {
  title: string;
  subtitle: string;
  /** Cảnh báo hệ quả (nền vàng). */
  warning?: string;
  /** Ghi chú (nền xanh nhạt). */
  note?: string;
  /** Có ô "Lý do *" 3–500 ký tự. */
  withReason: boolean;
  confirmLabel: string;
  destructive?: boolean;
  run: (reason: string) => Promise<unknown>;
  /** Câu báo sau khi xong (hiện ở màn danh sách). */
  done: string;
};

/**
 * Hộp thoại xác nhận một thao tác nhạy cảm trên tài khoản / nhà xe (Figma ADM-02f, ADM-03): lý do (tùy thao tác) +
 * mã xác thực TOTP (xác nhận lại danh tính — 5 phút tới không phải nhập lại).
 */
export function AccountActionDialog({
  action,
  onClose,
  onDone,
  onStale
}: {
  action: AccountAction | null;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={action !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {action && (
        <ActionForm key={action.title} action={action} onClose={onClose} onDone={onDone} onStale={onStale} onPendingChange={setPending} />
      )}
    </Dialog>
  );
}

function ActionForm({
  action,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: {
  action: AccountAction;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const run = useMutation({
    mutationFn: () => withReauth(identity.secret, () => action.run(reason.trim())),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => {
      onDone(action.done);
      onClose();
    },
    onError: (error) => {
      const described = describeAccountError(error);
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
    const invalid = action.withReason ? lockReasonError(reason) : null;
    setReasonMessage(invalid);
    if (!identity.check() || invalid) {
      return;
    }
    run.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[520px]">
      <DialogHeader>
        <DialogTitle>{action.title}</DialogTitle>
        <DialogDescription>{action.subtitle}</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        {action.warning && (
          <Banner tone="warning" icon={<TriangleAlert className="mt-px size-5 shrink-0" />}>
            {action.warning}
          </Banner>
        )}
        {action.note && (
          <Banner tone="info" icon={<Info className="mt-px size-5 shrink-0" />}>
            {action.note}
          </Banner>
        )}
        {action.withReason && (
          <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={reasonMessage ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={LOCK_REASON_MAX}
                placeholder={`Nhập lý do (3–${LOCK_REASON_MAX} ký tự)…`}
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
        {identity.needed && (
          <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />
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
          <Button type="submit" variant={action.destructive ? "destructive" : "default"} className={BUTTON} disabled={run.isPending}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            {action.confirmLabel}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}

function Banner({ tone, icon, children }: { tone: "warning" | "info"; icon: ReactNode; children: ReactNode }) {
  return (
    <div
      role="note"
      className={`flex gap-3 rounded-lg px-4 py-3 text-sm leading-5 ${
        tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-accent-foreground"
      }`}
    >
      {icon}
      <p>{children}</p>
    </div>
  );
}
