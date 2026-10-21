"use client";

import { useMutation, useQuery } from "@tanstack/react-query";
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
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Check, CircleAlert, Info, LoaderCircle, X } from "lucide-react";
import { useState } from "react";

import {
  type AdminOperator,
  approveBankChange,
  type BankChange,
  getBankChange,
  rejectBankChange
} from "../../lib/user/user-api";
import { describeAccountError, formatDate, LOCK_REASON_MAX, lockReasonError } from "../../lib/user/user-format";

/**
 * Hộp thoại xác minh yêu cầu đổi tài khoản nhận tiền của nhà xe (TASK-OPR-001b, UC-11 bước 4, BR-37; Figma chưa có
 * màn này — dựng theo bộ thành phần Admin). Hiện tài khoản đang dùng và tài khoản mới (số đầy đủ, mỗi lần mở ghi nhật
 * ký) để đối chiếu với tên pháp lý / ngân hàng; xác minh hoặc từ chối kèm lý do, cần mã TOTP.
 */
export function BankChangeDialog({
  operator,
  onClose,
  onDone,
  onStale
}: {
  operator: AdminOperator | null;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
}) {
  const [pending, setPending] = useState(false);
  return (
    <Dialog open={operator !== null} onOpenChange={(open) => !open && !pending && onClose()}>
      {operator && (
        <ReviewForm key={operator.id} operator={operator} onClose={onClose} onDone={onDone} onStale={onStale} onPendingChange={setPending} />
      )}
    </Dialog>
  );
}

function ReviewForm({
  operator,
  onClose,
  onDone,
  onStale,
  onPendingChange
}: {
  operator: AdminOperator;
  onClose: () => void;
  onDone: (message: string) => void;
  onStale: () => void;
  onPendingChange: (pending: boolean) => void;
}) {
  // Mỗi lần mở là một lần xem số đầy đủ (ghi nhật ký) — không giữ trong bộ nhớ đệm.
  const change = useQuery({ queryKey: ["admin-bank-change", operator.id], queryFn: () => getBankChange(operator.id), gcTime: 0, retry: false });
  const identity = useIdentityField();
  const [reason, setReason] = useState("");
  const [reasonMessage, setReasonMessage] = useState<string | null>(null);
  const [formError, setFormError] = useState<string | null>(null);
  const decide = useMutation({
    mutationFn: ({ approve, changeId }: { approve: boolean; changeId: string }) =>
      withReauth(identity.secret, () =>
        approve ? approveBankChange(operator.id, changeId) : rejectBankChange(operator.id, changeId, reason.trim())
      ),
    onMutate: () => {
      setFormError(null);
      onPendingChange(true);
    },
    onSettled: () => onPendingChange(false),
    onSuccess: (_result, { approve }) => {
      onDone(approve ? `Đã xác minh tài khoản nhận tiền mới của ${operator.name}.` : `Đã từ chối yêu cầu đổi tài khoản của ${operator.name}.`);
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

  function submit(approve: boolean, data: BankChange) {
    setFormError(null);
    const invalid = approve ? null : lockReasonError(reason);
    setReasonMessage(invalid);
    if (!identity.check() || invalid) {
      return;
    }
    decide.mutate({ approve, changeId: data.changeId });
  }

  const data = change.data;
  const loadError = change.isError ? describeAccountError(change.error).message : null;
  return (
    <DialogContent className="sm:max-w-[640px]">
      <DialogHeader>
        <DialogTitle>Xác minh tài khoản nhận tiền</DialogTitle>
        <DialogDescription>
          {operator.name} · {operator.slug}
        </DialogDescription>
      </DialogHeader>
      {!data ? (
        loadError ? (
          <>
            <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              <CircleAlert className="size-5 shrink-0" />
              {loadError}
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" className={`${BUTTON} bg-card`} onClick={onClose}>
                Đóng
              </Button>
            </DialogFooter>
          </>
        ) : (
          <div aria-label="Đang tải yêu cầu" className="flex flex-col gap-3">
            <Skeleton className="h-24 rounded-lg" />
            <Skeleton className="h-24 rounded-lg" />
          </div>
        )
      ) : (
        <form noValidate onSubmit={(event) => event.preventDefault()} className="flex flex-col gap-4">
          <div className="grid gap-3 sm:grid-cols-2">
            <AccountBox
              title="Tài khoản đang dùng"
              account={data.current}
              footnote={data.current?.verifiedAt ? `Xác minh ngày ${formatDate(data.current.verifiedAt)}` : null}
            />
            <AccountBox
              title="Tài khoản mới"
              highlight
              account={data.requested}
              footnote={`Gửi ngày ${formatDate(data.requested.requestedAt)}${data.requested.requestedBy ? ` · ${data.requested.requestedBy}` : ""}`}
            />
          </div>
          <dl className="grid gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
            <Row label="Tên pháp lý" value={data.legalName ?? "—"} />
            <Row label="Mã số thuế" value={data.taxCode ?? "—"} />
            <Row label="Lý do đổi" value={data.requested.reason ?? "—"} />
          </dl>
          <div role="note" className="flex gap-3 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-px size-5 shrink-0" />
            <p>
              Đối chiếu tên chủ tài khoản với tên pháp lý và xác nhận với nhà xe trước khi duyệt. Sau khi xác minh, các kỳ chi trả tiếp
              theo chuyển vào tài khoản mới.
            </p>
          </div>
          <FormField label="Lý do từ chối" helper="Bắt buộc khi từ chối · gửi cho chủ nhà xe và lưu nhật ký." error={reasonMessage ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                rows={2}
                maxLength={LOCK_REASON_MAX}
                value={reason}
                disabled={decide.isPending}
                onChange={(event) => {
                  setReason(event.target.value);
                  setReasonMessage(null);
                }}
              />
            )}
          </FormField>
          {identity.needed && (
            <IdentityField totp value={identity.value} error={identity.error} disabled={decide.isPending} onChange={identity.change} />
          )}
          {formError && (
            <div role="alert" className="flex items-center gap-3 rounded-lg bg-error-50 px-4 py-3 text-sm leading-5 text-error-600">
              <CircleAlert className="size-5 shrink-0" />
              {formError}
            </div>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={`${BUTTON} bg-card`} disabled={decide.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button
              type="button"
              variant="outline"
              className={`${BUTTON} bg-card text-error-600 hover:bg-error-50 hover:text-error-600`}
              disabled={decide.isPending}
              onClick={() => submit(false, data)}
            >
              {decide.isPending && decide.variables?.approve === false ? (
                <LoaderCircle className="size-[18px] animate-spin" />
              ) : (
                <X className="size-[18px]" />
              )}
              Từ chối
            </Button>
            <Button type="button" className={BUTTON} disabled={decide.isPending} onClick={() => submit(true, data)}>
              {decide.isPending && decide.variables?.approve ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
              Xác minh
            </Button>
          </DialogFooter>
        </form>
      )}
    </DialogContent>
  );
}

function AccountBox({
  title,
  account,
  footnote,
  highlight = false
}: {
  title: string;
  account: { bankName: string; accountNumber: string; accountHolder: string } | null;
  footnote: string | null;
  highlight?: boolean;
}) {
  return (
    <section
      aria-label={title}
      className={`flex flex-col gap-1.5 rounded-lg border px-4 py-3 ${highlight ? "border-primary bg-accent" : "bg-card"}`}
    >
      <h3 className="text-xs leading-[18px] font-semibold text-muted-foreground uppercase">{title}</h3>
      {account ? (
        <>
          <p className="text-sm leading-5 font-semibold text-vxn-ink">{account.bankName}</p>
          <p className="font-mono text-base leading-6 tracking-wide text-vxn-ink">{account.accountNumber}</p>
          <p className="text-sm leading-5 text-vxn-ink">{account.accountHolder}</p>
        </>
      ) : (
        <p className="text-sm leading-5 text-muted-foreground">Chưa có tài khoản đã xác minh.</p>
      )}
      {footnote && <p className="text-xs leading-[18px] text-muted-foreground">{footnote}</p>}
    </section>
  );
}

function Row({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex gap-3">
      <dt className="w-28 shrink-0 text-muted-foreground">{label}</dt>
      <dd className="min-w-0 break-words text-vxn-ink">{value}</dd>
    </div>
  );
}
