"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { IdentityField, useIdentityField } from "@vexenhanh/ui/components/auth/identity-field";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { withReauth } from "@vexenhanh/ui/lib/auth/reauth";
import { Info, LoaderCircle, Paperclip, Scale } from "lucide-react";
import Link from "next/link";
import { useState, type ReactNode } from "react";

import { formatVnd, REFUND_STATUS } from "../../lib/payment/payment-format";
import { decideDispute, getDispute, requestEvidence, setDisputeStatus, type DisputeDecision, type DisputeDetail, type DisputeEvent } from "../../lib/support/support-api";
import {
  defaultDue,
  describeCaseError,
  displayBookingCode,
  DISPUTE_STATUS,
  dueToIso,
  eventLines,
  fullMoment,
  OPEN_DISPUTE,
  PARTY_LABEL,
  policyLabel,
  shortMoment
} from "../../lib/support/support-format";
import { AttachmentChips, Card, LoadState, Row, Shell } from "./case-parts";

const DECISION: Record<DisputeDecision, { title: string; description: string }> = {
  REFUND: { title: "Hoàn tiền", description: "Hoàn toàn bộ hoặc một phần cho hành khách." },
  NO_REFUND: { title: "Không hoàn tiền", description: "Giữ kết quả theo chính sách lưu lúc đặt." },
  OTHER: { title: "Phương án khác", description: "Đổi vé, điều chỉnh hoặc phương án khác theo chính sách." }
};

/**
 * Chi tiết tranh chấp (Figma ADM-09d; TASK-TRUST-001, FR-DSP-02..08): minh chứng hai bên, dữ liệu hệ thống (giờ chạy, check-in,
 * thông báo đổi giờ, chính sách lưu lúc đặt), lịch sử trạng thái; yêu cầu minh chứng có hạn, đang xem xét / leo thang, ra quyết định
 * (ADM-09e — cần xác nhận lại danh tính, chỉ Quản trị viên), đóng sau quyết định.
 */
export function DisputeDetailScreen({ disputeId }: { disputeId: string }) {
  const dispute = useQuery({
    queryKey: ["admin-dispute", disputeId],
    queryFn: () => getDispute(disputeId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  return (
    <Shell back="/disputes?tab=disputes" backLabel="Quay lại hàng đợi tranh chấp">
      {dispute.data ? (
        <DisputeBody detail={dispute.data} />
      ) : (
        <LoadState label="tranh chấp" missing={dispute.error instanceof ApiError && dispute.error.status === 404} failed={dispute.isError} onRetry={() => void dispute.refetch()} />
      )}
    </Shell>
  );
}

function useApply(disputeId: string) {
  const queryClient = useQueryClient();
  return (next?: DisputeDetail) => {
    if (next) queryClient.setQueryData(["admin-dispute", disputeId], next);
    void queryClient.invalidateQueries({ queryKey: ["admin-disputes"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-tickets"] });
    void queryClient.invalidateQueries({ queryKey: ["admin-ticket"] });
  };
}

function DisputeBody({ detail }: { detail: DisputeDetail }) {
  const apply = useApply(detail.disputeId);
  const [dialog, setDialog] = useState<"request" | "decide" | "status" | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const status = DISPUTE_STATUS[detail.status];
  const open = OPEN_DISPUTE.includes(detail.status);
  const resolved = detail.status === "RESOLVED_REFUND" || detail.status === "RESOLVED_NO_REFUND";
  const evidence = detail.events.filter((event) => event.kind === "EVIDENCE");
  const done = (next: DisputeDetail, message: string) => {
    apply(next);
    setNotice(message);
    setDialog(null);
  };
  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">Tranh chấp {detail.disputeCode}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {detail.supportTicketCode && detail.supportTicketId ? (
              <>
                Từ khiếu nại{" "}
                <Link href={`/disputes/tickets/${detail.supportTicketId}`} className="underline">
                  {detail.supportTicketCode}
                </Link>{" "}
                ·{" "}
              </>
            ) : null}
            Đơn {displayBookingCode(detail.bookingCode)} · {detail.operatorName}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {open && (
            <>
              <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setDialog("status")}>
                Đổi trạng thái
              </Button>
              <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setDialog("request")}>
                <Paperclip className="size-[18px]" />
                Yêu cầu minh chứng
              </Button>
              <Button className={BUTTON} onClick={() => setDialog("decide")}>
                <Scale className="size-[18px]" />
                Ra quyết định
              </Button>
            </>
          )}
          {resolved && (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setDialog("status")}>
              Đóng tranh chấp
            </Button>
          )}
        </div>
      </header>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      {detail.decision && (
        <div role="note" className="rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-accent-foreground">
          Quyết định ({fullMoment(detail.decision.decidedAt)}): {DECISION[detail.decision.decision].title}
          {detail.decision.amount !== null ? ` ${formatVnd(detail.decision.amount)}` : ""} — {detail.decision.reason}
          {detail.decision.refund && ` · Hoàn tiền ${detail.decision.refund.refundCode}: ${REFUND_STATUS[detail.decision.refund.status].label}`}
        </div>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_320px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Minh chứng của hai bên" description="Tệp lưu riêng tư; mỗi lần mở tệp được ghi nhật ký audit.">
            {evidence.length === 0 ? (
              <p className="text-sm leading-5 text-muted-foreground">Chưa bên nào gửi minh chứng. Dùng "Yêu cầu minh chứng" để đặt hạn phản hồi.</p>
            ) : (
              <div className="grid gap-4 md:grid-cols-2">
                {evidence.map((event) => (
                  <EvidenceCard key={event.eventId} event={event} />
                ))}
              </div>
            )}
          </Card>
          <Card title="Dữ liệu hệ thống">
            <dl className="flex flex-col gap-3">
              <Row label="Giờ khởi hành theo lịch" value={fullMoment(detail.trip.departureAt)} />
              <Row label="Giờ khởi hành thực tế (tài xế cập nhật)" value={detail.trip.departedAt ? fullMoment(detail.trip.departedAt) : "Chưa ghi nhận"} />
              <Row label="Check-in vé của khách" value={detail.firstCheckInAt ? fullMoment(detail.firstCheckInAt) : "Chưa check-in"} />
              <Row label="Thông báo đổi giờ / hủy chuyến đã gửi" value={detail.tripChangeNotified ? "Có" : "Không có"} />
              <Row label="Chính sách hủy lưu lúc đặt" value={policyLabel(detail.cancellationTiers)} />
            </dl>
          </Card>
          <Card title="Lịch sử trạng thái">
            <ol className="flex flex-col">
              {[...detail.events].reverse().map((event) => {
                const lines = eventLines(event);
                return (
                  <li key={event.eventId} className="flex gap-4 pb-4 last:pb-0">
                    <span className={`mt-1.5 size-2.5 shrink-0 rounded-full ${event.kind === "STATUS" && event.party === "SYSTEM" ? "bg-error-600" : event.kind === "EVIDENCE" ? "bg-vxn-fg-3" : "bg-primary"}`} aria-hidden />
                    <div className="flex min-w-0 flex-1 flex-col gap-0.5">
                      <p className="text-sm leading-5 font-semibold text-vxn-ink">{lines.title}</p>
                      <p className="text-sm leading-5 break-words text-muted-foreground">{lines.detail}</p>
                    </div>
                    <time className="shrink-0 text-xs leading-[18px] text-muted-foreground" dateTime={event.createdAt}>
                      {shortMoment(event.createdAt)}
                    </time>
                  </li>
                );
              })}
            </ol>
          </Card>
        </div>
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Tóm tắt">
            <dl className="flex flex-col gap-3">
              <Row label="Giá trị đơn" value={formatVnd(detail.bookingTotal)} />
              <Row label="Khách đã thanh toán" value={formatVnd(detail.paidAmount)} />
              <Row label="Còn hoàn được" value={formatVnd(detail.refundableAmount)} />
              <Row label="Yêu cầu của khách" value={detail.customerRequest ?? "—"} />
              <Row label="Người phụ trách" value={detail.assignee?.username ?? "Chưa phân công"} />
              {detail.responseDueAt && <Row label="Hạn phản hồi" value={<span className={detail.overdue ? "text-error-600" : ""}>{fullMoment(detail.responseDueAt)}{detail.overdue ? " · quá hạn" : ""}</span>} />}
            </dl>
          </Card>
          <Card title="Các bên">
            <dl className="flex flex-col gap-3">
              <Row label="Hành khách" value={detail.customerName} />
              <Row label="Nhà xe" value={detail.operatorName} />
              <Row label="Chuyến" value={`${shortMoment(detail.trip.departureAt)} · ${detail.trip.routeName}`} />
            </dl>
          </Card>
          <p role="note" className="flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
            <Scale className="mt-0.5 size-4 shrink-0" aria-hidden />
            Vé Xe Nhanh là bên phân xử cuối cùng. Mỗi lần đổi trạng thái đều lưu người thực hiện, lý do và minh chứng.
          </p>
        </div>
      </div>
      {dialog === "request" && <RequestDialog detail={detail} onClose={() => setDialog(null)} onDone={done} />}
      {dialog === "decide" && <DecisionDialog detail={detail} onClose={() => setDialog(null)} onDone={done} />}
      {dialog === "status" && <StatusDialog detail={detail} onClose={() => setDialog(null)} onDone={done} />}
    </>
  );
}

function EvidenceCard({ event }: { event: DisputeEvent }) {
  return (
    <div className="flex flex-col gap-2 rounded-lg bg-muted px-4 py-3">
      <p className="text-sm leading-5 font-semibold text-vxn-ink">{PARTY_LABEL[event.party]}</p>
      <p className="text-xs leading-[18px] text-muted-foreground">Gửi {shortMoment(event.createdAt)} · {event.actorName}</p>
      {event.body && <p className="text-sm leading-5 whitespace-pre-line text-vxn-fg-1">{event.body}</p>}
      <AttachmentChips files={event.attachments} />
    </div>
  );
}

type DialogProps = { detail: DisputeDetail; onClose: () => void; onDone: (next: DisputeDetail, message: string) => void };

function DialogShell({ title, detail, onClose, children }: { title: string; detail: DisputeDetail; onClose: () => void; children: ReactNode }) {
  return (
    <Dialog open onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[560px]">
        <DialogHeader>
          <DialogTitle>{title}</DialogTitle>
          <DialogDescription>
            {detail.disputeCode} · Đơn {displayBookingCode(detail.bookingCode)} · {formatVnd(detail.paidAmount)}
          </DialogDescription>
        </DialogHeader>
        {children}
      </DialogContent>
    </Dialog>
  );
}

function Footer({ pending, onClose, label, error }: { pending: boolean; onClose: () => void; label: string; error: string | null }) {
  return (
    <>
      {error && (
        <p role="alert" className="text-sm leading-5 text-error-600">
          {error}
        </p>
      )}
      <DialogFooter>
        <Button type="button" variant="outline" className={BUTTON} disabled={pending} onClick={onClose}>
          Hủy
        </Button>
        <Button type="submit" className={BUTTON} disabled={pending}>
          {pending && <LoaderCircle className="size-[18px] animate-spin" />}
          {label}
        </Button>
      </DialogFooter>
    </>
  );
}

function Choice({ checked, title, description, onSelect, name }: { checked: boolean; title: string; description: string; onSelect: () => void; name: string }) {
  return (
    <label className={`flex cursor-pointer gap-3 rounded-lg border p-4 text-sm leading-5 ${checked ? "border-primary bg-accent" : "bg-card"}`}>
      <input type="radio" name={name} className="mt-1 accent-[var(--primary)]" checked={checked} onChange={onSelect} />
      <span className="flex flex-col gap-0.5">
        <span className="font-semibold text-vxn-ink">{title}</span>
        <span className="text-muted-foreground">{description}</span>
      </span>
    </label>
  );
}

/** Yêu cầu một bên cung cấp minh chứng + hạn phản hồi (FR-DSP-03). */
function RequestDialog({ detail, onClose, onDone }: DialogProps) {
  const [party, setParty] = useState<"OPERATOR" | "PASSENGER">("OPERATOR");
  const [message, setMessage] = useState("");
  const [due, setDue] = useState(defaultDue());
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => requestEvidence(detail.disputeId, { party, message: message.trim(), dueAt: dueToIso(due) }),
    onSuccess: (next) => onDone(next, `Đã yêu cầu ${party === "OPERATOR" ? "nhà xe" : "khách"} cung cấp minh chứng.`),
    onError: (failure) => setError(describeCaseError(failure).message)
  });
  return (
    <DialogShell title="Yêu cầu minh chứng" detail={detail} onClose={onClose}>
      <form
        className="flex flex-col gap-4"
        onSubmit={(event) => {
          event.preventDefault();
          if (message.trim().length < 3 || !due) {
            setError("Nhập nội dung yêu cầu (3–500 ký tự) và hạn phản hồi.");
            return;
          }
          submit.mutate();
        }}
      >
        <fieldset className="grid gap-3 sm:grid-cols-2">
          <legend className="mb-2 text-sm leading-5 font-medium">Bên được yêu cầu *</legend>
          <Choice name="evidence-party" checked={party === "OPERATOR"} title="Nhà xe" description="Nhật trình, giải trình của nhà xe." onSelect={() => setParty("OPERATOR")} />
          <Choice name="evidence-party" checked={party === "PASSENGER"} title="Hành khách" description="Ảnh, sao kê hoặc thông tin bổ sung của khách." onSelect={() => setParty("PASSENGER")} />
        </fieldset>
        <FormField label="Nội dung yêu cầu *" helper="Bên được yêu cầu nhận email kèm nội dung và hạn phản hồi.">
          {(control) => <Textarea {...control} rows={3} maxLength={500} value={message} disabled={submit.isPending} onChange={(event) => setMessage(event.target.value)} />}
        </FormField>
        <FormField label="Hạn phản hồi *" helper="Quá hạn, tranh chấp tự leo thang và được xử lý theo minh chứng đang có.">
          {(control) => <Input {...control} type="datetime-local" value={due} disabled={submit.isPending} onChange={(event) => setDue(event.target.value)} />}
        </FormField>
        <Footer pending={submit.isPending} onClose={onClose} label="Gửi yêu cầu" error={error} />
      </form>
    </DialogShell>
  );
}

/** Ra quyết định (Figma ADM-09e, FR-DSP-06): hoàn tiền / không hoàn / phương án khác + lý do + xác nhận lại danh tính. */
function DecisionDialog({ detail, onClose, onDone }: DialogProps) {
  const identity = useIdentityField();
  const [decision, setDecision] = useState<DisputeDecision>("REFUND");
  const [amount, setAmount] = useState("");
  const [reason, setReason] = useState("");
  const [errors, setErrors] = useState<{ amount?: string; reason?: string; form?: string }>({});
  const parsed = Number(amount.replace(/\D/g, ""));
  const submit = useMutation({
    mutationFn: () => withReauth(identity.secret, () => decideDispute(detail.disputeId, { decision, amount: decision === "REFUND" ? parsed : null, reason: reason.trim() })),
    onSuccess: (next) => onDone(next, decision === "REFUND" ? `Đã quyết định hoàn ${formatVnd(parsed)} — yêu cầu hoàn tiền đang được gửi cổng.` : "Đã ra quyết định."),
    onError: (failure) => {
      const described = describeCaseError(failure);
      if (described.field === "identity") {
        identity.require(described.message);
        return;
      }
      identity.sync();
      setErrors({ form: described.message });
    }
  });
  function validate(): boolean {
    const next: typeof errors = {};
    if (decision === "REFUND" && (!parsed || parsed > detail.refundableAmount)) next.amount = `Nhập số tiền từ 1 ₫ tới ${formatVnd(detail.refundableAmount)}.`;
    if (reason.trim().length < 3) next.reason = "Nhập lý do (3–500 ký tự).";
    setErrors(next);
    return identity.check() && Object.keys(next).length === 0;
  }
  return (
    <DialogShell title="Ra quyết định tranh chấp" detail={detail} onClose={onClose}>
      <form
        className="flex flex-col gap-4"
        onSubmit={(event) => {
          event.preventDefault();
          if (validate()) submit.mutate();
        }}
      >
        <fieldset className="flex flex-col gap-3" disabled={submit.isPending}>
          <legend className="mb-2 text-sm leading-5 font-medium">Phương án *</legend>
          {(Object.keys(DECISION) as DisputeDecision[]).map((value) => (
            <Choice key={value} name="dispute-decision" checked={decision === value} title={DECISION[value].title} description={DECISION[value].description} onSelect={() => setDecision(value)} />
          ))}
        </fieldset>
        {decision === "REFUND" && (
          <FormField label="Số tiền hoàn (₫) *" helper={`Tối đa ${formatVnd(detail.refundableAmount)} (phần khách đã thanh toán còn lại).`} error={errors.amount}>
            {(control) => (
              <Input {...control} inputMode="numeric" value={amount ? new Intl.NumberFormat("vi-VN").format(parsed) : ""} disabled={submit.isPending} onChange={(event) => setAmount(event.target.value)} />
            )}
          </FormField>
        )}
        <p className="flex gap-2.5 rounded-lg bg-accent px-4 py-3 text-sm leading-5 text-accent-foreground">
          <Info className="mt-0.5 size-4 shrink-0" aria-hidden />
          Quyết định được gửi cho hành khách và nhà xe. Khoản hoàn được xử lý tại mục Thanh toán & hoàn tiền và trừ vào tiền chi trả của nhà xe.
        </p>
        <FormField label="Lý do và căn cứ *" helper="Lý do được lưu vào nhật ký audit." error={errors.reason}>
          {(control) => <Textarea {...control} rows={3} maxLength={500} value={reason} disabled={submit.isPending} placeholder="Nhập lý do (3–500 ký tự)…" onChange={(event) => setReason(event.target.value)} />}
        </FormField>
        {identity.needed && <IdentityField totp value={identity.value} error={identity.error} disabled={submit.isPending} onChange={identity.change} />}
        <Footer pending={submit.isPending} onClose={onClose} label="Xác nhận quyết định" error={errors.form ?? null} />
      </form>
    </DialogShell>
  );
}

/** Đang xem xét / leo thang (khi còn mở) hoặc đóng (sau quyết định), kèm lý do. */
function StatusDialog({ detail, onClose, onDone }: DialogProps) {
  const resolved = detail.status === "RESOLVED_REFUND" || detail.status === "RESOLVED_NO_REFUND";
  const choices = resolved ? (["CLOSED"] as const) : (["UNDER_REVIEW", "ESCALATED"] as const).filter((value) => value !== detail.status);
  const [status, setStatus] = useState<"UNDER_REVIEW" | "ESCALATED" | "CLOSED">(choices[0] ?? "UNDER_REVIEW");
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => setDisputeStatus(detail.disputeId, { status, reason: reason.trim() }),
    onSuccess: (next) => onDone(next, `Đã chuyển sang "${DISPUTE_STATUS[next.status].label}".`),
    onError: (failure) => setError(describeCaseError(failure).message)
  });
  return (
    <DialogShell title={resolved ? "Đóng tranh chấp" : "Đổi trạng thái tranh chấp"} detail={detail} onClose={onClose}>
      <form
        className="flex flex-col gap-4"
        onSubmit={(event) => {
          event.preventDefault();
          if (reason.trim().length < 3) {
            setError("Nhập lý do (3–500 ký tự).");
            return;
          }
          submit.mutate();
        }}
      >
        {!resolved && (
          <fieldset className="grid gap-3 sm:grid-cols-2">
            <legend className="mb-2 text-sm leading-5 font-medium">Trạng thái mới *</legend>
            {choices.map((value) => (
              <Choice
                key={value}
                name="dispute-status"
                checked={status === value}
                title={DISPUTE_STATUS[value].label}
                description={value === "ESCALATED" ? "Cần cấp xử lý cao hơn / quá hạn." : "Đủ minh chứng, đang xem xét để quyết định."}
                onSelect={() => setStatus(value)}
              />
            ))}
          </fieldset>
        )}
        <FormField label="Lý do *">{(control) => <Textarea {...control} rows={3} maxLength={500} value={reason} disabled={submit.isPending} onChange={(event) => setReason(event.target.value)} />}</FormField>
        <Footer pending={submit.isPending} onClose={onClose} label="Xác nhận" error={error} />
      </form>
    </DialogShell>
  );
}
