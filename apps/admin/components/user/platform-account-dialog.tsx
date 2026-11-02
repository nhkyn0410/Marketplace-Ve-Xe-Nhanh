"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { PermissionChecklist } from "@vexenhanh/ui/components/permission-checklist";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Check, CircleAlert, Info, LoaderCircle } from "lucide-react";
import { useState, type FormEvent } from "react";

import { PERMISSION_GROUPS, PERMISSION_TEMPLATES, type Permission } from "../../lib/user/permission-catalog";
import { createPlatformAccount, listPlatformAccounts, type PlatformAccount, type PlatformRole } from "../../lib/user/user-api";
import { describeAccountError, emailError, PLATFORM_ROLE, platformUsernameError } from "../../lib/user/user-format";

/**
 * Hộp thoại "Thêm tài khoản quản trị" (Figma ADM-03d): tên đăng nhập `platform/…`, email nội bộ, vai trò, quyền (TASK-IAM-007
 * — chỉ tick được quyền mình đang có), TOTP.
 */
export function PlatformAccountDialog({
  open,
  onClose,
  onCreated
}: {
  open: boolean;
  onClose: () => void;
  onCreated: (account: PlatformAccount) => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={open} onOpenChange={(next) => !next && !pending && onClose()}>
      {open && <CreateForm onClose={onClose} onCreated={onCreated} onPendingChange={setPending} />}
    </Dialog>
  );
}

function CreateForm({
  onClose,
  onCreated,
  onPendingChange
}: {
  onClose: () => void;
  onCreated: (account: PlatformAccount) => void;
  onPendingChange: (pending: boolean) => void;
}) {
  const identity = useIdentityField();
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<PlatformRole>("PLATFORM_ADMIN");
  const [permissions, setPermissions] = useState<Permission[]>([]);
  const [errors, setErrors] = useState<{ username?: string; email?: string; permissions?: string; form?: string }>({});
  // Cùng khóa với danh sách không lọc → dùng chung cache.
  const grantable = useQuery({ queryKey: ["admin-platform-accounts", {}], queryFn: () => listPlatformAccounts({}), select: (data) => data.grantable });
  const run = useMutation({
    mutationFn: () =>
      withReauth(identity.secret, () =>
        createPlatformAccount({ username: username.trim().toLowerCase(), email: email.trim(), role, permissions })
      ),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (account) => {
      onCreated(account);
      onClose();
    },
    onError: (error) => {
      const described = describeAccountError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors(described.field === "username" ? { username: described.message } : { form: described.message });
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    const next = {
      username: platformUsernameError(username) ?? undefined,
      email: emailError(email) ?? undefined,
      permissions: permissions.length === 0 ? "Chọn ít nhất một quyền." : undefined
    };
    setErrors(next);
    if (!identity.check() || next.username || next.email || next.permissions) {
      return;
    }
    run.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[560px]">
      <DialogHeader>
        <DialogTitle>Thêm tài khoản quản trị</DialogTitle>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField label="Tên đăng nhập *" error={errors.username}>
          {(control) => (
            <div className="flex min-w-0 items-stretch overflow-hidden rounded-md border border-input focus-within:ring-[3px] focus-within:ring-ring/50">
              <span className="flex shrink-0 items-center border-r bg-muted px-3 text-sm text-muted-foreground">platform/</span>
              <input
                {...control}
                value={username}
                maxLength={40}
                autoFocus
                disabled={run.isPending}
                className="h-9 min-w-0 flex-1 bg-transparent px-3 text-sm outline-none"
                onChange={(event) => {
                  setUsername(event.target.value);
                  setErrors((current) => ({ ...current, username: undefined }));
                }}
              />
            </div>
          )}
        </FormField>
        <FormField label="Email nội bộ *" helper="Mật khẩu tạm được gửi tới email này." error={errors.email}>
          {(control) => (
            <Input
              {...control}
              type="email"
              value={email}
              maxLength={254}
              disabled={run.isPending}
              onChange={(event) => {
                setEmail(event.target.value);
                setErrors((current) => ({ ...current, email: undefined }));
              }}
            />
          )}
        </FormField>
        <fieldset className="flex flex-col gap-2">
          <legend className="pb-1.5 text-sm leading-5 font-medium text-vxn-ink">Vai trò *</legend>
          {(Object.keys(PLATFORM_ROLE) as PlatformRole[]).map((value) => (
            <label
              key={value}
              className={cn(
                "flex cursor-pointer items-start gap-3 rounded-lg border px-4 py-3",
                role === value ? "border-primary bg-accent" : "bg-card"
              )}
            >
              <input
                type="radio"
                name="role"
                value={value}
                checked={role === value}
                disabled={run.isPending}
                onChange={() => {
                  setRole(value);
                  setPermissions([]);
                }}
                className="mt-1 accent-primary"
              />
              <span className="flex flex-col">
                <span className="text-sm leading-5 font-semibold text-vxn-ink">{PLATFORM_ROLE[value].label}</span>
                <span className="text-xs leading-[18px] text-muted-foreground">{PLATFORM_ROLE[value].description}</span>
              </span>
            </label>
          ))}
        </fieldset>
        <div className="flex flex-col gap-1.5">
          <p className="text-sm leading-5 font-medium text-vxn-ink">Quyền *</p>
          {grantable.isPending ? (
            <p className="flex items-center gap-2 text-sm text-muted-foreground">
              <LoaderCircle className="size-4 animate-spin" />
              Đang tải quyền được cấp…
            </p>
          ) : grantable.isError ? (
            <p className="text-sm text-error-600">Không tải được danh sách quyền. Đóng hộp thoại rồi thử lại.</p>
          ) : (
            <PermissionChecklist
              groups={PERMISSION_GROUPS}
              templates={PERMISSION_TEMPLATES[role]}
              grantable={grantable.data[role]}
              value={permissions}
              onChange={(next) => {
                setPermissions(next);
                setErrors((current) => ({ ...current, permissions: undefined }));
              }}
              disabled={run.isPending}
            />
          )}
          {errors.permissions && (
            <p role="alert" className="text-xs leading-[18px] text-error-600">
              {errors.permissions}
            </p>
          )}
        </div>
        <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
          <Info className="mt-px size-5 shrink-0" />
          <p>Lần đăng nhập đầu, tài khoản phải đổi mật khẩu tạm và thiết lập xác thực hai lớp.</p>
        </div>
        {identity.needed && (
          <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />
        )}
        {errors.form && (
          <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
            <CircleAlert className="size-5 shrink-0" />
            {errors.form}
          </div>
        )}
        <DialogFooter>
          <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={run.isPending} onClick={onClose}>
            Hủy
          </Button>
          <Button type="submit" className={BUTTON} disabled={run.isPending}>
            {run.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
            Tạo tài khoản
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  );
}
