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
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Check, CircleAlert, Info, LoaderCircle, TriangleAlert } from "lucide-react";
import { useState, type FormEvent, type ReactNode } from "react";

import {
  approveApplication,
  rejectApplication,
  requestApplicationInfo,
  resendOwnerCredentials,
  type ApplicationDetail,
  type ApprovalResult,
  type DecisionResult
} from "../../lib/operator-application/application-api";
import {
  describeReviewError,
  REASON_MAX_LENGTH,
  reasonError,
  slugError,
  suggestSlug,
  usernameError
} from "../../lib/operator-application/application-format";

export type ReviewAction = "approve" | "request-info" | "reject" | "resend";
export type ReviewOutcome =
  | { action: "approve" | "resend"; result: ApprovalResult }
  | { action: "request-info" | "reject"; result: DecisionResult };

type DialogProps = {
  application: ApplicationDetail;
  onClose: () => void;
  onDone: (outcome: ReviewOutcome) => void;
  /** Hồ sơ có thể đã khác (vừa được xử lý ở nơi khác) — màn hình tải lại. */
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
};

/**
 * Hộp thoại ra quyết định trên chi tiết hồ sơ (Figma ADM-02c duyệt, ADM-02d từ chối; yêu cầu bổ sung và gửi lại
 * mật khẩu tạm dựng theo cùng khuôn). Duyệt / từ chối / gửi lại cần mã TOTP nếu chưa xác nhận trong 5 phút.
 */
export function ReviewDialog({
  action,
  ...props
}: Omit<DialogProps, "onPendingChange"> & { action: ReviewAction | null }) {
  const [pending, setPending] = useState(false);
  const form = { ...props, onPendingChange: setPending };
  return (
    <Dialog open={action !== null} onOpenChange={(open) => !open && !pending && props.onClose()}>
      {action === "approve" && <ApproveForm {...form} />}
      {(action === "request-info" || action === "reject") && <DecisionForm kind={action} {...form} />}
      {action === "resend" && <ResendForm {...form} />}
    </Dialog>
  );
}

function ApproveForm({ application, onClose, onDone, onStale, onPendingChange }: DialogProps) {
  const [slug, setSlug] = useState(() => suggestSlug(application.displayName ?? application.operatorName));
  const [username, setUsername] = useState("");
  const [slugMessage, setSlugMessage] = useState<string | null>(null);
  const [usernameMessage, setUsernameMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  // Một khóa cho mỗi lần mở hộp thoại: gửi lặp (bấm lại, mạng chập chờn) vẫn chỉ tạo một nhà xe.
  const [idempotencyKey] = useState(() => crypto.randomUUID());
  const identity = useIdentityField();

  const run = useMutation({
    mutationFn: () =>
      withReauth(identity.secret, () =>
        approveApplication(application.id, { operatorSlug: slug, ownerUsername: username.trim() }, idempotencyKey)
      ),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (result) => onDone({ action: "approve", result }),
    onError: (error) => {
      const described = describeReviewError(error);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      if (described.field === "slug") {
        setSlugMessage(described.message);
        return;
      }
      setFormError(described.message);
      if (described.refresh) {
        onStale();
      }
    }
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    const slugInvalid = slugError(slug);
    const usernameInvalid = usernameError(username.trim());
    setSlugMessage(slugInvalid);
    setUsernameMessage(usernameInvalid);
    if (!identity.check() || slugInvalid || usernameInvalid) {
      return;
    }
    run.mutate();
  }

  return (
    <DialogContent className="sm:max-w-[564px]">
      <DialogHeader>
        <DialogTitle>Duyệt hồ sơ và cấp tài khoản chủ nhà xe</DialogTitle>
        <DialogDescription>
          {application.applicationCode} · {application.operatorName}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <FormField
          label="Mã nhà xe (slug) *"
          helper="3–64 ký tự: chữ thường, số, gạch ngang; không dùng “platform”. Không đổi được sau khi duyệt."
          error={slugMessage ?? undefined}
        >
          {(control) => (
            <Input
              {...control}
              name="operatorSlug"
              value={slug}
              maxLength={64}
              autoComplete="off"
              disabled={run.isPending}
              onChange={(event) => {
                setSlug(event.target.value.toLowerCase());
                setSlugMessage(null);
              }}
            />
          )}
        </FormField>
        <FormField
          label="Tên đăng nhập chủ nhà xe *"
          helper="3–64 ký tự gồm chữ, số, dấu chấm, gạch dưới, gạch ngang; không bắt đầu bằng “nv.”."
          error={usernameMessage ?? undefined}
        >
          {(control) => (
            <div className="flex h-10 overflow-hidden rounded-md border border-input focus-within:ring-[3px] focus-within:ring-ring/50">
              <span className="flex max-w-[45%] items-center truncate border-r bg-muted px-3 text-sm text-muted-foreground">
                {slug || "slug"}/
              </span>
              <input
                {...control}
                name="ownerUsername"
                value={username}
                maxLength={64}
                autoComplete="off"
                placeholder="owner01"
                disabled={run.isPending}
                className="min-w-0 flex-1 bg-transparent px-3 text-sm outline-none placeholder:text-muted-foreground"
                onChange={(event) => {
                  setUsername(event.target.value);
                  setUsernameMessage(null);
                }}
              />
            </div>
          )}
        </FormField>
        <Note tone="info">
          Sau khi duyệt: nhà xe chuyển sang Đang hoạt động, mật khẩu tạm (hạn 24 giờ) được gửi tới{" "}
          {application.contactEmail} và link hồ sơ hết hiệu lực.
        </Note>
        {identity.needed && (
          <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />
        )}
        <FormError message={formError} />
        <Footer pending={run.isPending} onClose={onClose}>
          <Check className="size-[18px]" />
          Duyệt và cấp tài khoản
        </Footer>
      </form>
    </DialogContent>
  );
}

function DecisionForm({
  kind,
  application,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: DialogProps & { kind: "request-info" | "reject" }) {
  const reject = kind === "reject";
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const identity = useIdentityField();

  const run = useMutation({
    mutationFn: (text: string) =>
      reject
        ? withReauth(identity.secret, () => rejectApplication(application.id, text))
        : requestApplicationInfo(application.id, text),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (result) => onDone({ action: kind, result }),
    onError: (error) => {
      const described = describeReviewError(error);
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
    // Yêu cầu bổ sung không cần xác nhận lại danh tính (05 API §7.5).
    if ((reject && !identity.check()) || invalid) {
      return;
    }
    run.mutate(reason.trim());
  }

  return (
    <DialogContent className="sm:max-w-[564px]">
      <DialogHeader>
        <DialogTitle>{reject ? "Từ chối hồ sơ" : "Yêu cầu bổ sung hồ sơ"}</DialogTitle>
        <DialogDescription>
          {application.applicationCode} · {application.operatorName}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        {reject ? (
          <Note tone="warning">
            Từ chối là kết quả cuối: link hồ sơ hết hiệu lực và nhà xe muốn tham gia lại phải nộp hồ sơ mới. Lý do được
            gửi tới email liên hệ.
          </Note>
        ) : (
          <Note tone="info">
            Hồ sơ chuyển sang Cần bổ sung. Người nộp nhận email kèm nội dung dưới đây và link mới để sửa rồi gửi duyệt
            lại; link cũ hết hiệu lực.
          </Note>
        )}
        <FormField
          label={reject ? "Lý do từ chối *" : "Nội dung cần bổ sung *"}
          helper={`3–${REASON_MAX_LENGTH} ký tự · gửi tới ${application.contactEmail}`}
          error={reasonMessage ?? undefined}
        >
          {(control) => (
            <Textarea
              {...control}
              name="reason"
              rows={4}
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
        {reject && identity.needed && (
          <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />
        )}
        <FormError message={formError} />
        <Footer pending={run.isPending} onClose={onClose} destructive={reject}>
          {reject ? "Từ chối hồ sơ" : "Gửi yêu cầu bổ sung"}
        </Footer>
      </form>
    </DialogContent>
  );
}

function ResendForm({ application, onClose, onDone, onStale, onPendingChange }: DialogProps) {
  const [formError, setFormError] = useState<string | null>(null);
  const identity = useIdentityField();
  const run = useMutation({
    mutationFn: () => withReauth(identity.secret, () => resendOwnerCredentials(application.id)),
    onMutate: () => onPendingChange(true),
    onSettled: () => onPendingChange(false),
    onSuccess: (result) => onDone({ action: "resend", result }),
    onError: (error) => {
      const described = describeReviewError(error);
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
    if (identity.check()) {
      run.mutate();
    }
  }

  return (
    <DialogContent className="sm:max-w-[564px]">
      <DialogHeader>
        <DialogTitle>Gửi lại mật khẩu tạm</DialogTitle>
        <DialogDescription>
          {application.applicationCode} · {application.operatorName}
        </DialogDescription>
      </DialogHeader>
      <form noValidate onSubmit={submit} className="flex flex-col gap-4">
        <Note tone="info">
          Mật khẩu tạm mới (hạn 24 giờ) được gửi tới {application.contactEmail}. Mật khẩu tạm cũ không dùng được nữa.
        </Note>
        {identity.needed && (
          <IdentityField totp value={identity.value} error={identity.error} disabled={run.isPending} onChange={identity.change} />
        )}
        <FormError message={formError} />
        <Footer pending={run.isPending} onClose={onClose}>
          Gửi lại mật khẩu tạm
        </Footer>
      </form>
    </DialogContent>
  );
}

function Note({ tone, children }: { tone: "info" | "warning"; children: ReactNode }) {
  const Icon = tone === "warning" ? TriangleAlert : Info;
  return (
    <div
      role="note"
      className={cn(
        "flex gap-3 rounded-lg px-4 py-3 text-sm leading-5",
        tone === "warning" ? "bg-warning-50 text-warning-700" : "bg-accent text-accent-foreground"
      )}
    >
      <Icon className="mt-px size-5 shrink-0" />
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

function Footer({
  pending,
  destructive = false,
  onClose,
  children
}: {
  pending: boolean;
  destructive?: boolean;
  onClose: () => void;
  children: ReactNode;
}) {
  return (
    <DialogFooter>
      <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={pending} onClick={onClose}>
        Hủy
      </Button>
      <Button type="submit" variant={destructive ? "destructive" : "default"} className={BUTTON} disabled={pending}>
        {pending && <LoaderCircle className="size-[18px] animate-spin" />}
        {children}
      </Button>
    </DialogFooter>
  );
}
