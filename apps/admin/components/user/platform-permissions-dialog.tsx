"use client";

import { useMutation } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { PermissionChecklist } from "@vexenhanh/ui/components/permission-checklist";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { samePermissions } from "@vexenhanh/ui/lib/permission-matrix";
import { CircleAlert, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent } from "react";

import { PERMISSION_GROUPS, PERMISSION_TEMPLATES, type Permission } from "../../lib/user/permission-catalog";
import { type PlatformAccount, updatePlatformPermissions } from "../../lib/user/user-api";
import { describeAccountError, LOCK_REASON_MAX, lockReasonError, PLATFORM_ROLE } from "../../lib/user/user-format";

/**
 * Hộp thoại "Phân quyền" tài khoản quản trị (FR-IAM-07, TASK-IAM-007 — Figma chưa có khung): tick quyền theo nhóm màn
 * hình, lý do, mã TOTP. Lưu xong tài khoản bị đăng xuất khỏi mọi thiết bị để quyền mới có hiệu lực ngay.
 */
export function PlatformPermissionsDialog({
  target,
  onClose,
  onDone,
  onStale
}: {
  target: { account: PlatformAccount; grantable: Permission[] } | null;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={target !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {target && (
        <PermissionsForm
          key={target.account.id}
          account={target.account}
          grantable={target.grantable}
          onClose={onClose}
          onDone={onDone}
          onStale={onStale}
          onPendingChange={setPending}
        />
      )}
    </Dialog>
  );
}

function PermissionsForm({
  account,
  grantable,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: {
  account: PlatformAccount;
  grantable: Permission[];
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const [permissions, setPermissions] = useState<Permission[]>(account.permissions);
  const [reason, setReason] = useState("");
  const [reasonError, setReasonError] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const unchanged = samePermissions(permissions, account.permissions);
  const run = useMutation({
    mutationFn: () => withReauth(identity.secret, () => updatePlatformPermissions(account.id, permissions, reason.trim())),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: () => {
      onDone(`Đã cập nhật quyền của ${account.username}; tài khoản cần đăng nhập lại.`);
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
    const invalid = lockReasonError(reason);
    setReasonError(invalid);
    if (!identity.check() || invalid || unchanged) {
      return;
    }
    run.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Phân quyền</DialogTitle>
        <DialogDescription>
          {account.username} · {PLATFORM_ROLE[account.role].label}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <PermissionChecklist
          groups={PERMISSION_GROUPS}
          templates={PERMISSION_TEMPLATES[account.role]}
          grantable={grantable}
          value={permissions}
          onChange={setPermissions}
          disabled={run.isPending}
        />
        <div role="note" className="flex gap-3 rounded-lg bg-warning-50 px-4 py-3 text-sm leading-5 text-warning-700">
          <TriangleAlert className="mt-px size-5 shrink-0" />
          <p>Tài khoản bị đăng xuất khỏi mọi thiết bị để quyền mới có hiệu lực ngay.</p>
        </div>
        <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký audit." error={reasonError ?? undefined}>
          {(control) => (
            <Textarea
              {...control}
              rows={2}
              maxLength={LOCK_REASON_MAX}
              placeholder={`Vì sao đổi quyền (3–${LOCK_REASON_MAX} ký tự)…`}
              value={reason}
              disabled={run.isPending}
              onChange={(event) => {
                setReason(event.target.value);
                setReasonError(null);
              }}
            />
          )}
        </FormField>
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
          <Button type="submit" className={BUTTON} disabled={run.isPending || unchanged}>
            {run.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
            Lưu quyền
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
