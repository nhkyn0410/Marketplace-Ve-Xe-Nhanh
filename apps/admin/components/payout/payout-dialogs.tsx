"use client";

import { useMutation } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Info, LoaderCircle } from "lucide-react";
import { useState } from "react";

import { cancelPayout, confirmPayout, holdPayout, type PayoutDetail } from "../../lib/payout/payout-api";
import { describePayoutError } from "../../lib/payout/payout-format";

const VND = new Intl.NumberFormat("vi-VN");
const REASON_MAX = 500;

/** Giờ hiện tại theo giờ VN cho ô `datetime-local` (`2026-10-13T09:42`). */
function nowLocalInput(): string {
  return new Date(Date.now() + 7 * 3_600_000).toISOString().slice(0, 16);
}

/**
 * Hộp thoại "Giữ lại" / "Hủy kỳ chi trả": bắt buộc lý do (lưu lịch sử + nhật ký audit). Hủy thì các bút toán được trả về để
 * vào kỳ sau.
 */
export function PayoutReasonDialog({
  payout,
  kind,
  onClose,
  onDone
}: {
  payout: PayoutDetail;
  kind: "hold" | "cancel" | null;
  onClose: () => void;
  onDone: (message: string, next: PayoutDetail | null) => void;
}) {
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => (kind === "hold" ? holdPayout(payout.payoutId, reason.trim()) : cancelPayout(payout.payoutId, reason.trim())),
    onSuccess: (next) => {
      onDone(kind === "hold" ? `Đã giữ lại kỳ ${payout.payoutCode}.` : `Đã hủy kỳ ${payout.payoutCode}. Các bút toán sẽ vào kỳ chi trả sau.`, next);
      setReason("");
    },
    onError: (failure) => {
      const described = describePayoutError(failure);
      setError(described.message);
      if (described.refresh) {
        onDone(described.message, null);
      }
    }
  });
  const title = kind === "hold" ? "Giữ lại kỳ chi trả" : "Hủy kỳ chi trả";
  return (
    <Dialog open={kind !== null} onOpenChange={(open) => !open && !submit.isPending && onClose()}>
      <DialogContent className="sm:max-w-[520px]">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          <DialogDescription>
            {payout.payoutCode} · {payout.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            if (!reason.trim()) {
              setError("Nhập lý do.");
              return;
            }
            setError(null);
            submit.mutate();
          }}
        >
          <FormField label="Lý do *" helper="Lý do được lưu vào lịch sử kỳ chi trả và nhật ký audit." error={error ?? undefined}>
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={REASON_MAX}
                value={reason}
                disabled={submit.isPending}
                placeholder={kind === "hold" ? "Ví dụ: chờ nhà xe xác minh lại tài khoản nhận tiền" : "Ví dụ: trùng kỳ, số liệu sai"}
                onChange={(event) => setReason(event.target.value)}
              />
            )}
          </FormField>
          <DialogFooter>
            <Button type="button" variant="outline" className={BUTTON} disabled={submit.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" variant={kind === "cancel" ? "destructive" : "default"} className={BUTTON} disabled={submit.isPending}>
              {submit.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              {kind === "hold" ? "Giữ lại" : "Hủy kỳ"}
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}

/**
 * Hộp thoại "Xác nhận đã chuyển khoản" (Figma ADM-08c): Admin đã tự chuyển khoản tới tài khoản nhận tiền đã xác minh, nhập
 * mã giao dịch ngân hàng + thời điểm chuyển + ghi chú; cần mã TOTP. Xác nhận xong kỳ chuyển sang Đã chi trả.
 */
export function PayoutConfirmDialog({
  payout,
  open,
  onClose,
  onDone
}: {
  payout: PayoutDetail;
  open: boolean;
  onClose: () => void;
  onDone: (message: string, next: PayoutDetail | null) => void;
}) {
  const identity = useIdentityField();
  const [bankReference, setBankReference] = useState("");
  const [transferredAt, setTransferredAt] = useState(nowLocalInput);
  const [note, setNote] = useState("");
  const [errors, setErrors] = useState<{ bankReference?: string; transferredAt?: string; note?: string; form?: string }>({});
  const submit = useMutation({
    mutationFn: () =>
      withReauth(identity.secret, () =>
        confirmPayout(payout.payoutId, { bankReference: bankReference.trim(), transferredAt: `${transferredAt}:00+07:00`, note: note.trim() })
      ),
    onSuccess: (next) => onDone(`Đã xác nhận chi trả ${payout.payoutCode}.`, next),
    onError: (failure) => {
      const described = describePayoutError(failure);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      if (described.field === "transferredAt") {
        setErrors({ transferredAt: described.message });
        return;
      }
      setErrors({ form: described.message });
      if (described.refresh) {
        onDone(described.message, null);
      }
    }
  });

  function validate(): boolean {
    const next: typeof errors = {};
    if (bankReference.trim().length < 3) next.bankReference = "Nhập mã giao dịch ngân hàng.";
    if (!/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/.test(transferredAt)) next.transferredAt = "Chọn thời điểm chuyển khoản.";
    if (!note.trim()) next.note = "Nhập ghi chú xác nhận.";
    setErrors(next);
    return identity.check() && Object.keys(next).length === 0;
  }

  return (
    <Dialog open={open} onOpenChange={(value) => !value && !submit.isPending && onClose()}>
      <DialogContent className="sm:max-w-[600px]">
        <DialogHeader>
          <DialogTitle>Xác nhận đã chuyển khoản</DialogTitle>
          <DialogDescription>
            {payout.payoutCode} · {payout.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            if (validate()) submit.mutate();
          }}
        >
          <dl className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
            <div className="flex justify-between gap-4">
              <dt className="text-muted-foreground">Số tiền</dt>
              <dd className="font-semibold tabular-nums">{VND.format(payout.amount)} ₫</dd>
            </div>
            <div className="flex justify-between gap-4">
              <dt className="text-muted-foreground">Tài khoản nhận</dt>
              <dd>{payout.bank ? `${payout.bank.bankName} · ${payout.bank.accountNumberMasked}` : "—"}</dd>
            </div>
            <div className="flex justify-between gap-4">
              <dt className="text-muted-foreground">Chủ tài khoản</dt>
              <dd>{payout.bank?.accountHolder ?? "—"}</dd>
            </div>
          </dl>
          <div className="grid gap-4 sm:grid-cols-2">
            <FormField label="Mã giao dịch ngân hàng *" error={errors.bankReference}>
              {(control) => <Input {...control} maxLength={64} value={bankReference} disabled={submit.isPending} onChange={(event) => setBankReference(event.target.value)} />}
            </FormField>
            <FormField label="Thời điểm chuyển khoản *" error={errors.transferredAt}>
              {(control) => (
                <Input {...control} type="datetime-local" value={transferredAt} disabled={submit.isPending} onChange={(event) => setTransferredAt(event.target.value)} />
              )}
            </FormField>
          </div>
          <p className="flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
            Sau khi xác nhận, khoản chi trả chuyển sang Đã chi trả và sổ giữ hộ của nhà xe được ghi bút toán chi trả.
          </p>
          <FormField label="Ghi chú xác nhận *" helper="Lý do được lưu vào nhật ký audit." error={errors.note}>
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={REASON_MAX}
                value={note}
                disabled={submit.isPending}
                placeholder="Ví dụ: đã chuyển khoản theo lệnh chi ngày 13/10…"
                onChange={(event) => setNote(event.target.value)}
              />
            )}
          </FormField>
          {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={submit.isPending} onChange={identity.change} />}
          {errors.form && (
            <p role="alert" className="text-sm leading-5 text-error-600">
              {errors.form}
            </p>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={BUTTON} disabled={submit.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" className={BUTTON} disabled={submit.isPending}>
              {submit.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              Xác nhận đã chi trả
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
