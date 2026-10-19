"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Info, LoaderCircle } from "lucide-react";
import { useState, type ReactNode } from "react";

import { getRefund, refundPayment, resolveRefund, retryRefund, type PaymentDetail, type RefundDetail } from "../../lib/payment/payment-api";
import { describeRefundError, formatVnd, moment, PROVIDER_LABEL, reconcileReasonLabel, REFUND_SOURCE, REFUND_STATUS } from "../../lib/payment/payment-format";

const REASON_MAX = 500;

/** Sau thao tác: làm mới danh sách hoàn tiền, thanh toán (nhãn tab "Cần đối soát") và chi tiết thanh toán. */
function useRefresh() {
  const queryClient = useQueryClient();
  return (refundId?: string, next?: RefundDetail) => {
    if (refundId && next) queryClient.setQueryData(["admin-refund", refundId], next);
    void queryClient.invalidateQueries({ queryKey: ["admin-refunds"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-payments"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-payment"] });
  };
}

/**
 * Hoàn tiền — chi tiết + xử lý (Figma ADM-07d; TASK-ADM-002, UC-27 A4, Security §8 "Refund thủ công"). Yêu cầu THẤT BẠI: gửi
 * lại cổng (lần gửi mới) hoặc ghi nhận đã hoàn ngoài cổng (mã tham chiếu); cần lý do + mã TOTP. Trạng thái khác: chỉ xem.
 */
export function RefundDialog({ refundId, onClose }: { refundId: string | null; onClose: () => void }) {
  const refund = useQuery({ queryKey: ["admin-refund", refundId], queryFn: () => getRefund(refundId!), enabled: refundId !== null });
  const detail = refund.data;
  // Câu báo sau khi xử lý: refund đổi trạng thái thì hộp thoại chuyển sang chế độ xem, câu báo vẫn giữ.
  const [notice, setNotice] = useState<string | null>(null);
  const close = () => {
    setNotice(null);
    onClose();
  };
  return (
    <Dialog open={refundId !== null} onOpenChange={(open) => !open && close()}>
      <DialogContent className="sm:max-w-[600px]">
        <DialogHeader>
          <DialogTitle>{detail?.status === "FAILED" ? "Xử lý hoàn tiền" : "Chi tiết hoàn tiền"}</DialogTitle>
          <DialogDescription>{detail ? `${detail.refundCode} · Đơn ${detail.bookingCode} · ${detail.operatorName}` : "Đang tải…"}</DialogDescription>
        </DialogHeader>
        {refund.isError && !detail ? (
          <p role="alert" className="text-sm leading-5 text-error-600">
            Không tải được yêu cầu hoàn tiền. Đóng rồi mở lại.
          </p>
        ) : !detail ? (
          <div role="status" aria-label="Đang tải yêu cầu hoàn tiền" className="flex flex-col gap-3">
            <Skeleton className="h-28 rounded-lg" />
            <Skeleton className="h-20 rounded-lg" />
          </div>
        ) : detail.status === "FAILED" ? (
          <RefundActionForm key={detail.refundId} detail={detail} onClose={close} onDone={setNotice} />
        ) : (
          <>
            {notice && (
              <p role="status" className="rounded-lg bg-success-50 px-4 py-3 text-sm leading-5 text-success-700">
                {notice}
              </p>
            )}
            <RefundSummaryBox detail={detail} />
            <RefundHistory detail={detail} />
            <DialogFooter>
              <Button variant="outline" className={BUTTON} onClick={close}>
                Đóng
              </Button>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}

function RefundSummaryBox({ detail }: { detail: RefundDetail }) {
  const status = REFUND_STATUS[detail.status];
  const reconciling = detail.paymentStatus === "RECONCILING";
  const reference = detail.bankReference ?? detail.providerRefundId;
  return (
    <dl className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
      <SummaryRow label="Trạng thái" value={<Badge tone={status.tone}>{status.label}</Badge>} />
      <SummaryRow label="Khách đã thanh toán" value={formatVnd(detail.paidAmount)} />
      <SummaryRow label={reconciling ? "Số tiền hoàn (toàn bộ thanh toán cần đối soát)" : `Số tiền hoàn (${detail.refundPercent}% theo chính sách lưu lúc đặt)`} value={formatVnd(detail.amount)} strong />
      <SummaryRow label="Nguồn" value={REFUND_SOURCE[detail.source]} />
      <SummaryRow label="Cổng" value={`${PROVIDER_LABEL[detail.provider]} · lần gửi ${detail.attempt}`} />
      {detail.failureCode && <SummaryRow label="Lỗi gần nhất của cổng" value={detail.failureCode} />}
      {reference && <SummaryRow label={detail.bankReference ? "Mã tham chiếu (ghi nhận tay)" : "Mã hoàn của cổng"} value={reference} />}
      {detail.tickets.length > 0 && <SummaryRow label="Vé" value={detail.tickets.map((ticket) => `${ticket.ticketCode} (${ticket.seatCode})`).join(", ")} />}
    </dl>
  );
}

function SummaryRow({ label, value, strong }: { label: string; value: ReactNode; strong?: boolean }) {
  return (
    <div className="flex items-baseline justify-between gap-4">
      <dt className="text-muted-foreground">{label}</dt>
      <dd className={`text-right tabular-nums ${strong ? "font-semibold text-vxn-ink" : ""}`}>{value}</dd>
    </div>
  );
}

function RefundHistory({ detail }: { detail: RefundDetail }) {
  return (
    <section aria-label="Tiến trình hoàn tiền" className="flex flex-col gap-3">
      <h3 className="text-sm leading-5 font-semibold text-vxn-ink">Tiến trình</h3>
      <ol className="flex flex-col gap-3">
        {[...detail.histories].reverse().map((history, index) => (
          <li key={index} className="flex gap-3 text-sm leading-5">
            <span className="mt-1.5 size-2 shrink-0 rounded-full bg-primary" aria-hidden />
            <div className="flex min-w-0 flex-1 flex-col">
              <span className="font-medium text-vxn-ink">{REFUND_STATUS[history.toStatus].label}</span>
              <span className="text-muted-foreground">{[history.actor ?? "Hệ thống", history.reason].filter(Boolean).join(" · ")}</span>
            </div>
            <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={history.createdAt}>
              {moment(history.createdAt)}
            </time>
          </li>
        ))}
      </ol>
    </section>
  );
}

/** Hai cách xử lý yêu cầu thất bại + lý do + mã TOTP. */
function RefundActionForm({ detail, onClose, onDone }: { detail: RefundDetail; onClose: () => void; onDone: (message: string) => void }) {
  const refresh = useRefresh();
  const identity = useIdentityField();
  const [action, setAction] = useState<"retry" | "resolve">(detail.canRetry ? "retry" : "resolve");
  const [reference, setReference] = useState("");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<{ reference?: string; reason?: string; form?: string }>({});
  const provider = PROVIDER_LABEL[detail.provider];
  const submit = useMutation({
    mutationFn: () =>
      withReauth(identity.secret, () =>
        action === "retry" ? retryRefund(detail.refundId, reason.trim()) : resolveRefund(detail.refundId, { reference: reference.trim(), reason: reason.trim() })
      ),
    onSuccess: (next) => {
      onDone(action === "retry" ? `Đã gửi lại ${detail.refundCode} tới cổng ${provider}.` : `Đã ghi nhận ${detail.refundCode} đã hoàn.`);
      refresh(detail.refundId, next);
    },
    onError: (failure) => {
      const described = describeRefundError(failure);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
      if (described.refresh) refresh();
    }
  });

  function validate(): boolean {
    const next: typeof errors = {};
    if (action === "resolve" && reference.trim().length < 3) next.reference = "Nhập mã tham chiếu (3–64 ký tự).";
    if (reason.trim().length < 3) next.reason = "Nhập lý do (3–500 ký tự).";
    setErrors(next);
    return identity.check() && Object.keys(next).length === 0;
  }

  return (
    <form
      className="flex flex-col gap-4"
      onSubmit={(event) => {
        event.preventDefault();
        if (validate()) submit.mutate();
      }}
    >
      <RefundSummaryBox detail={detail} />
      <fieldset className="grid gap-3 sm:grid-cols-2" disabled={submit.isPending}>
        <legend className="sr-only">Cách xử lý</legend>
        <ChoiceCard
          checked={action === "retry"}
          disabled={!detail.canRetry}
          title="Gửi lại cổng"
          description={detail.canRetry ? `Tạo lần gửi mới tới cổng ${provider}.` : "Thanh toán gốc thiếu mã giao dịch cổng."}
          onSelect={() => setAction("retry")}
        />
        <ChoiceCard
          checked={action === "resolve"}
          title="Đã hoàn ngoài cổng"
          description="Đã chuyển khoản tay cho khách hoặc đã hoàn trên trang quản trị cổng."
          onSelect={() => setAction("resolve")}
        />
      </fieldset>
      {action === "resolve" && (
        <FormField label="Mã tham chiếu *" helper="Mã giao dịch ngân hàng hoặc mã hoàn trên trang quản trị cổng." error={errors.reference}>
          {(control) => <Input {...control} maxLength={64} value={reference} disabled={submit.isPending} onChange={(event) => setReference(event.target.value)} />}
        </FormField>
      )}
      <p className="flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
        <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
        {action === "retry"
          ? "Kiểm tra trên trang quản trị cổng trước khi gửi lại: nếu cổng đã hoàn, chọn \"Đã hoàn ngoài cổng\" để tránh hoàn hai lần."
          : detail.paymentStatus === "RECONCILING"
            ? "Thanh toán cần đối soát không có vé và chưa vào sổ giữ hộ — chỉ cập nhật trạng thái hoàn tiền."
            : "Vé chuyển sang Đã hoàn tiền; khoản hoàn được trừ khỏi sổ giữ hộ của nhà xe ở kỳ chi trả liên quan."}
      </p>
      <FormField label="Lý do và căn cứ *" helper="Lý do được lưu vào lịch sử hoàn tiền và nhật ký audit." error={errors.reason}>
        {(control) => (
          <Textarea
            {...control}
            rows={3}
            maxLength={REASON_MAX}
            value={reason}
            disabled={submit.isPending}
            placeholder="Nhập lý do (3–500 ký tự)…"
            onChange={(event) => setReason(event.target.value)}
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
          Xác nhận xử lý
        </Button>
      </DialogFooter>
    </form>
  );
}

function ChoiceCard({ checked, disabled, title, description, onSelect }: { checked: boolean; disabled?: boolean; title: string; description: string; onSelect: () => void }) {
  return (
    <label
      className={`flex cursor-pointer gap-3 rounded-lg border p-4 text-sm leading-5 ${checked ? "border-primary bg-accent" : "bg-card"} ${disabled ? "cursor-not-allowed opacity-60" : ""}`}
    >
      <input type="radio" name="refund-action" className="mt-1 accent-[var(--primary)]" checked={checked} disabled={disabled} onChange={onSelect} />
      <span className="flex flex-col gap-0.5">
        <span className="font-semibold text-vxn-ink">{title}</span>
        <span className="text-muted-foreground">{description}</span>
      </span>
    </label>
  );
}

/**
 * Hoàn toàn bộ cho thanh toán cần đối soát (Figma ADM-07b "Tạo hoàn tiền thủ công", thu hẹp v1): khách bị trừ tiền nhưng
 * thanh toán không nhận vào đơn. Tạo yêu cầu hoàn 100%, hệ thống gửi cổng. Cần lý do + mã TOTP.
 */
export function PaymentRefundDialog({ payment, open, onClose, onDone }: { payment: PaymentDetail; open: boolean; onClose: () => void; onDone: (message: string) => void }) {
  const refresh = useRefresh();
  const identity = useIdentityField();
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<{ reason?: string; form?: string }>({});
  const provider = PROVIDER_LABEL[payment.provider];
  const submit = useMutation({
    mutationFn: () => withReauth(identity.secret, () => refundPayment(payment.paymentId, reason.trim())),
    onSuccess: (created) => {
      refresh(created.refundId, created);
      onDone(`Đã tạo yêu cầu hoàn ${created.refundCode} (${formatVnd(created.amount)}) — hệ thống đang gửi cổng ${provider}.`);
    },
    onError: (failure) => {
      const described = describeRefundError(failure);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
      if (described.refresh) refresh();
    }
  });
  return (
    <Dialog open={open} onOpenChange={(value) => !value && !submit.isPending && onClose()}>
      <DialogContent className="sm:max-w-[560px]">
        <DialogHeader>
          <DialogTitle>Hoàn toàn bộ cho khách</DialogTitle>
          <DialogDescription>
            {payment.paymentCode} · Đơn {payment.bookingCode} · {payment.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            const reasonError = reason.trim().length < 3 ? "Nhập lý do (3–500 ký tự)." : undefined;
            setErrors({ reason: reasonError });
            if (identity.check() && !reasonError) submit.mutate();
          }}
        >
          <dl className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3 text-sm leading-5">
            <SummaryRow label="Số tiền hoàn" value={formatVnd(payment.amount)} strong />
            <SummaryRow label="Cổng" value={`${provider} · ${payment.providerTxnId ?? "—"}`} />
            <SummaryRow label="Lý do cần đối soát" value={reconcileReasonLabel(payment.reconcileReason)} />
          </dl>
          <p className="flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
            Thanh toán này không có vé và chưa vào sổ giữ hộ của nhà xe — hoàn tiền không ảnh hưởng đơn đặt vé hay kỳ chi trả.
          </p>
          <FormField label="Lý do và căn cứ *" helper="Lý do được lưu vào lịch sử hoàn tiền và nhật ký audit." error={errors.reason}>
            {(control) => (
              <Textarea
                {...control}
                rows={3}
                maxLength={REASON_MAX}
                value={reason}
                disabled={submit.isPending}
                placeholder="Ví dụ: khách trả hai lần cho cùng đơn…"
                onChange={(event) => setReason(event.target.value)}
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
              Tạo hoàn tiền
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
