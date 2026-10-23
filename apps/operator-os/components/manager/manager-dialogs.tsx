"use client";

import { useMutation } from "@tanstack/react-query";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { Input } from "@vexenhanh/ui/components/input";
import { PermissionChecklist } from "@vexenhanh/ui/components/permission-checklist";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { samePermissions } from "@vexenhanh/ui/lib/permission-matrix";
import { CircleAlert, Info, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent, type ReactNode } from "react";

import { withReauth } from "../../lib/auth/reauth";
import {
  createManager,
  resetManagerMfa,
  resetManagerPassword,
  updateManager,
  type Manager,
  type ManagerPermission
} from "../../lib/manager/manager-api";
import {
  ALL_MANAGER_PERMISSIONS,
  describeManagerError,
  MANAGER_PERMISSION_GROUPS,
  MANAGER_REASON_MAX,
  MANAGER_TEMPLATES,
  managerEmailError,
  managerReasonError,
  managerUsernameError
} from "../../lib/manager/manager-format";
import { IdentityField, useIdentityField } from "../auth/identity-field";
import { FormField } from "../form-field";
import { BUTTON } from "../list-parts";

export type ManagerDialog =
  | { kind: "create" }
  | { kind: "permissions"; manager: Manager }
  | { kind: "reset" | "mfa" | "lock" | "unlock"; manager: Manager };

/** Mọi hộp thoại của màn Tài khoản quản lý (TASK-IAM-007): lý do (lưu nhật ký) + xác nhận lại danh tính. */
export function ManagerDialogs({
  dialog,
  operatorSlug,
  onClose,
  onDone,
  onStale
}: {
  dialog: ManagerDialog | null;
  operatorSlug: string;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  const props = { onClose, onDone, onStale, onPendingChange: setPending };
  return (
    <Dialog open={dialog !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {dialog?.kind === "create" && <CreateForm operatorSlug={operatorSlug} {...props} />}
      {dialog?.kind === "permissions" && <PermissionsForm key={dialog.manager.id} manager={dialog.manager} {...props} />}
      {dialog && dialog.kind !== "create" && dialog.kind !== "permissions" && (
        <ActionForm key={`${dialog.kind}-${dialog.manager.id}`} kind={dialog.kind} manager={dialog.manager} {...props} />
      )}
    </Dialog>
  );
}

type FormProps = {
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
};

/** Khung chung: lý do, mã xác nhận danh tính, lỗi, hai nút. */
function useSubmit<T>(run: (reason: string) => Promise<T>, done: (result: T) => string, { onClose, onDone, onStale, onPendingChange }: FormProps) {
  const identity = useIdentityField();
  const [reason, setReason] = useState("");
  const [reasonError, setReasonError] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const [usernameError, setUsernameError] = useState<string | null>(null);
  const mutation = useMutation({
    mutationFn: () => withReauth(identity.secret, () => run(reason.trim())),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (result) => {
      onDone(done(result));
      onClose();
    },
    onError: (error) => {
      const described = describeManagerError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      if (described.field === "username") {
        setUsernameError(described.message);
      } else {
        setFormError(described.message);
      }
      if (described.refresh) {
        onStale();
      }
    }
  });

  /** `extraValid` = các ô riêng của form đã hợp lệ. */
  function submit(event: FormEvent, extraValid = true) {
    event.preventDefault();
    setFormError(null);
    const invalid = managerReasonError(reason);
    setReasonError(invalid);
    if (!identity.check() || invalid || !extraValid) {
      return;
    }
    mutation.mutate();
  }

  const footer = (label: string, destructive = false, disabled = false): ReactNode => (
    <>
      <FormField label="Lý do *" helper="Lý do được lưu vào nhật ký." error={reasonError ?? undefined}>
        {(control) => (
          <Textarea
            {...control}
            rows={2}
            maxLength={MANAGER_REASON_MAX}
            placeholder={`Nhập lý do (3–${MANAGER_REASON_MAX} ký tự)…`}
            value={reason}
            disabled={mutation.isPending}
            onChange={(event) => {
              setReason(event.target.value);
              setReasonError(null);
            }}
          />
        )}
      </FormField>
      {identity.needed && (
        <IdentityField value={identity.value} error={identity.error} disabled={mutation.isPending} onChange={identity.change} />
      )}
      {formError && (
        <p role="alert" className="flex items-start gap-2 rounded-lg bg-error-50 px-3 py-2.5 text-sm leading-5 text-error-600">
          <CircleAlert className="mt-0.5 size-4 shrink-0" />
          {formError}
        </p>
      )}
      <DialogFooter>
        <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={mutation.isPending} onClick={onClose}>
          Hủy
        </Button>
        <Button type="submit" variant={destructive ? "destructive" : "default"} className={BUTTON} disabled={mutation.isPending || disabled}>
          {mutation.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
          {label}
        </Button>
      </DialogFooter>
    </>
  );

  return { submit, footer, pending: mutation.isPending, usernameError, clearUsernameError: () => setUsernameError(null) };
}

function CreateForm({ operatorSlug, ...props }: FormProps & { operatorSlug: string }) {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [permissions, setPermissions] = useState<ManagerPermission[]>([]);
  const [errors, setErrors] = useState<{ username?: string; email?: string; permissions?: string }>({});
  const form = useSubmit(
    (reason) => createManager({ username: username.trim().toLowerCase(), contactEmail: email.trim(), permissions, reason }),
    (manager) =>
      manager.credentialDeliveryPending
        ? `Đã tạo ${manager.username} nhưng chưa gửi được mật khẩu tạm. Bấm "Cấp lại mật khẩu" để gửi lại.`
        : `Đã tạo ${manager.username}; mật khẩu tạm đã gửi tới ${manager.contactEmail}.`,
    props
  );

  function submit(event: FormEvent) {
    const next = {
      username: managerUsernameError(username) ?? undefined,
      email: managerEmailError(email) ?? undefined,
      permissions: permissions.length === 0 ? "Chọn ít nhất một quyền." : undefined
    };
    setErrors(next);
    form.submit(event, !next.username && !next.email && !next.permissions);
  }

  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Thêm tài khoản quản lý</DialogTitle>
        <DialogDescription>Đăng nhập trang quản lý nhà xe bằng tên riêng, chỉ dùng được các mục bạn tick.</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField label="Tên đăng nhập *" error={errors.username ?? form.usernameError ?? undefined}>
          {(control) => (
            <div className="flex min-w-0 items-stretch overflow-hidden rounded-md border border-input focus-within:ring-[3px] focus-within:ring-ring/50">
              <span className="flex shrink-0 items-center border-r bg-muted px-3 text-sm text-muted-foreground">{operatorSlug}/</span>
              <input
                {...control}
                value={username}
                maxLength={40}
                autoFocus
                disabled={form.pending}
                className="h-9 min-w-0 flex-1 bg-transparent px-3 text-sm outline-none"
                onChange={(event) => {
                  setUsername(event.target.value);
                  setErrors((current) => ({ ...current, username: undefined }));
                  form.clearUsernameError();
                }}
              />
            </div>
          )}
        </FormField>
        <FormField label="Email *" helper="Mật khẩu tạm được gửi tới email này." error={errors.email}>
          {(control) => (
            <Input
              {...control}
              type="email"
              value={email}
              maxLength={254}
              disabled={form.pending}
              onChange={(event) => {
                setEmail(event.target.value);
                setErrors((current) => ({ ...current, email: undefined }));
              }}
            />
          )}
        </FormField>
        <div className="flex flex-col gap-1.5">
          <p className="text-sm leading-5 font-medium text-vxn-ink">Quyền *</p>
          <PermissionChecklist
            groups={MANAGER_PERMISSION_GROUPS}
            templates={MANAGER_TEMPLATES}
            grantable={ALL_MANAGER_PERMISSIONS}
            value={permissions}
            onChange={(next) => {
              setPermissions(next);
              setErrors((current) => ({ ...current, permissions: undefined }));
            }}
            disabled={form.pending}
          />
          {errors.permissions && (
            <p role="alert" className="text-xs leading-[18px] text-error-600">
              {errors.permissions}
            </p>
          )}
        </div>
        <Note tone="info">
          Lần đăng nhập đầu, tài khoản phải đổi mật khẩu tạm và bật xác thực hai lớp. Hồ sơ & KYC, tài khoản nhận tiền và tài khoản quản
          lý chỉ chủ nhà xe dùng được.
        </Note>
        {form.footer("Tạo tài khoản")}
      </form>
    </DialogContent>
  );
}

function PermissionsForm({ manager, ...props }: FormProps & { manager: Manager }) {
  const [permissions, setPermissions] = useState<ManagerPermission[]>(manager.permissions);
  const unchanged = samePermissions(permissions, manager.permissions);
  const form = useSubmit(
    (reason) => updateManager(manager.id, { permissions, reason }),
    () => `Đã cập nhật quyền của ${manager.username}; tài khoản cần đăng nhập lại.`,
    props
  );
  return (
    <DialogContent className="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Phân quyền</DialogTitle>
        <DialogDescription>{manager.username}</DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={(event) => form.submit(event, !unchanged)} className="flex flex-col gap-4">
        <PermissionChecklist
          groups={MANAGER_PERMISSION_GROUPS}
          templates={MANAGER_TEMPLATES}
          grantable={ALL_MANAGER_PERMISSIONS}
          value={permissions}
          onChange={setPermissions}
          disabled={form.pending}
        />
        <Note tone="warning">Tài khoản bị đăng xuất khỏi mọi thiết bị để quyền mới có hiệu lực ngay.</Note>
        {form.footer("Lưu quyền", false, unchanged)}
      </form>
    </DialogContent>
  );
}

const ACTION_COPY = {
  reset: {
    title: "Cấp lại mật khẩu tạm",
    submit: "Cấp lại mật khẩu",
    note: "Mật khẩu tạm mới được gửi tới email của tài khoản; mọi phiên đăng nhập hiện tại bị thu hồi.",
    tone: "info",
    destructive: false,
    done: "Đã cấp lại mật khẩu tạm cho"
  },
  mfa: {
    title: "Đặt lại xác thực hai lớp",
    submit: "Đặt lại",
    note: "Ứng dụng xác thực và mã dự phòng cũ hết hiệu lực. Mật khẩu tạm mới được gửi tới email để đăng nhập lại và thiết lập lại xác thực hai lớp.",
    tone: "warning",
    destructive: true,
    done: "Đã đặt lại xác thực hai lớp cho"
  },
  lock: {
    title: "Khóa tài khoản quản lý",
    submit: "Khóa tài khoản",
    note: "Tài khoản bị đăng xuất khỏi mọi thiết bị và không đăng nhập được cho tới khi mở khóa.",
    tone: "warning",
    destructive: true,
    done: "Đã khóa"
  },
  unlock: {
    title: "Mở khóa tài khoản quản lý",
    submit: "Mở khóa",
    note: "Tài khoản đăng nhập lại được bằng mật khẩu và xác thực hai lớp hiện có.",
    tone: "info",
    destructive: false,
    done: "Đã mở khóa"
  }
} as const;

function ActionForm({ kind, manager, ...props }: FormProps & { kind: "reset" | "mfa" | "lock" | "unlock"; manager: Manager }) {
  const copy = ACTION_COPY[kind];
  const form = useSubmit(
    (reason) => {
      switch (kind) {
        case "reset":
          return resetManagerPassword(manager.id, reason);
        case "mfa":
          return resetManagerMfa(manager.id, reason);
        default:
          return updateManager(manager.id, { status: kind === "lock" ? "LOCKED" : "ACTIVE", reason });
      }
    },
    () => `${copy.done} ${manager.username}.`,
    props
  );
  return (
    <DialogContent className="sm:max-w-[520px]">
      <DialogHeader>
        <DialogTitle>{copy.title}</DialogTitle>
        <DialogDescription>
          {manager.username} · {manager.contactEmail ?? "chưa có email"}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={(event) => form.submit(event)} className="flex flex-col gap-4">
        <Note tone={copy.tone}>{copy.note}</Note>
        {form.footer(copy.submit, copy.destructive)}
      </form>
    </DialogContent>
  );
}

function Note({ tone, children }: { tone: "info" | "warning"; children: ReactNode }) {
  return (
    <div
      role="note"
      className={`flex gap-3 rounded-lg px-4 py-3 text-sm leading-5 ${tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-accent-foreground"}`}
    >
      {tone === "warning" ? <TriangleAlert className="mt-px size-5 shrink-0" /> : <Info className="mt-px size-5 shrink-0" />}
      <p>{children}</p>
    </div>
  );
}
