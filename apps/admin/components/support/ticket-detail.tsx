"use client";

import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@vexenhanh/ui/components/dialog";
import { FormField } from "@vexenhanh/ui/components/form-field";
import { Input } from "@vexenhanh/ui/components/input";
import { BUTTON } from "@vexenhanh/ui/components/list-parts";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@vexenhanh/ui/components/select";
import { Textarea } from "@vexenhanh/ui/components/textarea";
import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { ArrowUpRight, Check, CircleCheck, Flag, LoaderCircle, Send } from "lucide-react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";

import { formatVnd, PAYMENT_STATUS, PROVIDER_LABEL } from "../../lib/payment/payment-format";
import {
  escalateTicket,
  getTicket,
  listAssignees,
  classifyTicket,
  replyTicket,
  setTicketStatus,
  uploadAttachment,
  type SupportCategory,
  type SupportHandler,
  type SupportPriority,
  type TicketDetail
} from "../../lib/support/support-api";
import {
  CATEGORY_LABEL,
  CATEGORY_ORDER,
  describeCaseError,
  displayBookingCode,
  DISPUTE_STATUS,
  fullMoment,
  HANDLER_LABEL,
  PARTY_LABEL,
  PRIORITY_LABEL,
  PRIORITY_ORDER,
  TICKET_STATUS
} from "../../lib/support/support-format";
import { AttachmentPicker, type UploadedFile } from "@vexenhanh/ui/components/attachments";

import { AttachmentChips, Card, LoadState, Row, Shell } from "./case-parts";

const NONE = "none";

/**
 * Chi tiết khiếu nại (Figma ADM-09b; TASK-TRUST-001, FR-NSR-08/09): trao đổi với khách (trả lời, yêu cầu bổ sung, tệp minh chứng),
 * dữ liệu liên quan của đơn, phân loại (danh mục, ưu tiên, bên xử lý chính, người phụ trách), chuyển thành tranh chấp, đánh dấu đã
 * giải quyết / đóng.
 */
export function TicketDetailScreen({ ticketId }: { ticketId: string }) {
  const ticket = useQuery({
    queryKey: ["admin-ticket", ticketId],
    queryFn: () => getTicket(ticketId),
    retry: (count, error) => !(error instanceof ApiError && error.status === 404) && count < 2
  });
  return (
    <Shell back="/disputes" backLabel="Quay lại hàng đợi khiếu nại">
      {ticket.data ? (
        <TicketBody key={ticket.data.ticketId} detail={ticket.data} />
      ) : (
        <LoadState label="khiếu nại" missing={ticket.error instanceof ApiError && ticket.error.status === 404} failed={ticket.isError} onRetry={() => void ticket.refetch()} />
      )}
    </Shell>
  );
}

function useApply(ticketId: string) {
  const queryClient = useQueryClient();
  return (next?: TicketDetail) => {
    if (next) queryClient.setQueryData(["admin-ticket", ticketId], next);
    void queryClient.invalidateQueries({ queryKey: ["admin-tickets"] });
  };
}

function TicketBody({ detail }: { detail: TicketDetail }) {
  const apply = useApply(detail.ticketId);
  const assignees = useQuery({ queryKey: ["admin-support", "assignees"], queryFn: listAssignees });
  const [form, setForm] = useState({ category: detail.category, priority: detail.priority, handler: detail.handler, assigneeId: detail.assignee?.id ?? NONE });
  const [notice, setNotice] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [escalating, setEscalating] = useState(false);
  const status = TICKET_STATUS[detail.status];
  const locked = detail.status === "CLOSED" || detail.status === "ESCALATED";
  const save = useMutation({
    mutationFn: () => classifyTicket(detail.ticketId, { ...form, assigneeId: form.assigneeId === NONE ? null : form.assigneeId }),
    onSuccess: (next) => {
      apply(next);
      setError(null);
      setNotice(next.status === "WAITING_OPERATOR" && detail.status !== "WAITING_OPERATOR" ? "Đã lưu phân loại và chuyển nhà xe phản hồi." : "Đã lưu phân loại.");
    },
    onError: (failure) => {
      const described = describeCaseError(failure);
      setError(described.message);
      if (described.refresh) apply();
    }
  });
  const close = useMutation({
    mutationFn: (next: "RESOLVED" | "CLOSED") => setTicketStatus(detail.ticketId, { status: next, note: null }),
    onSuccess: (next) => {
      apply(next);
      setNotice(next.status === "RESOLVED" ? "Đã đánh dấu đã giải quyết." : "Đã đóng khiếu nại.");
    },
    onError: (failure) => setError(describeCaseError(failure).message)
  });

  return (
    <>
      <header className="flex flex-wrap items-start justify-between gap-4">
        <div className="flex min-w-0 flex-1 basis-80 flex-col gap-1.5">
          <h1 className="text-[30px] leading-[38px] font-semibold text-vxn-ink">{detail.subject}</h1>
          <p className="text-sm leading-5 text-muted-foreground">
            {detail.ticketCode} · tạo lúc {fullMoment(detail.createdAt)} · Đơn {displayBookingCode(detail.bookingCode)}
          </p>
        </div>
        <div className="flex flex-wrap items-center gap-3">
          <Badge tone={status.tone}>{status.label}</Badge>
          {!locked && (
            <Button variant="outline" className={`${BUTTON} bg-card`} onClick={() => setEscalating(true)}>
              <Flag className="size-[18px]" />
              Chuyển thành tranh chấp
            </Button>
          )}
          {!locked && (
            <Button className={BUTTON} disabled={save.isPending} onClick={() => save.mutate()}>
              {save.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Check className="size-[18px]" />}
              Lưu phân loại
            </Button>
          )}
        </div>
      </header>
      {notice && (
        <p role="status" className="rounded-lg bg-success-50 px-5 py-3 text-sm leading-5 text-success-700">
          {notice}
        </p>
      )}
      {error && (
        <p role="alert" className="rounded-lg bg-error-50 px-5 py-3 text-sm leading-5 text-error-600">
          {error}
        </p>
      )}
      {detail.dispute && (
        <p role="note" className="rounded-lg bg-accent px-5 py-3 text-sm leading-5 text-accent-foreground">
          Đã chuyển thành tranh chấp{" "}
          <Link href={`/disputes/cases/${detail.dispute.disputeId}`} className="font-semibold underline">
            {detail.dispute.disputeCode}
          </Link>{" "}
          · {DISPUTE_STATUS[detail.dispute.status].label}.
        </p>
      )}
      <div className="grid items-start gap-6 xl:grid-cols-[minmax(0,1fr)_340px]">
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Trao đổi">
            <ul className="flex flex-col gap-3">
              {detail.messages.map((message) => (
                <li key={message.messageId} className={`flex flex-col gap-2 rounded-lg px-4 py-3 ${message.party === "PLATFORM" ? "border bg-card" : "bg-muted"}`}>
                  <p className="text-xs leading-[18px] text-muted-foreground">
                    <span className="font-semibold text-vxn-ink">
                      {PARTY_LABEL[message.party]} · {message.authorName}
                    </span>{" "}
                    {fullMoment(message.createdAt)}
                  </p>
                  <p className="text-sm leading-5 whitespace-pre-line text-vxn-fg-1">{message.body}</p>
                  <AttachmentChips files={message.attachments} />
                </li>
              ))}
            </ul>
            {detail.status !== "CLOSED" && (
              <Composer
                detail={detail}
                onDone={(next, message) => {
                  apply(next);
                  setNotice(message);
                  setError(null);
                }}
              />
            )}
          </Card>
          <Card title="Dữ liệu liên quan" description="Tự động lấy theo đơn đặt vé.">
            <dl className="flex flex-col gap-3">
              {detail.payments.map((payment) => (
                <Row
                  key={payment.paymentId}
                  label={`Thanh toán ${payment.paymentCode}`}
                  value={`${PAYMENT_STATUS[payment.status].label} · ${formatVnd(payment.amount)} · ${PROVIDER_LABEL[payment.provider]}`}
                />
              ))}
              {detail.payments.length === 0 && <Row label="Thanh toán" value="Chưa có" />}
              <Row label="Vé" value={`${detail.validTickets} vé hợp lệ`} />
              <Row label="Chuyến" value={`${fullMoment(detail.trip.departureAt)} · ${detail.trip.routeName}`} />
            </dl>
            {detail.payments[0] && (
              <Link href={`/payments/${detail.payments[0].paymentId}`} className="inline-flex w-fit items-center gap-1.5 text-sm leading-5 font-semibold text-vxn-ink hover:underline">
                <ArrowUpRight className="size-4" />
                Mở chi tiết thanh toán
              </Link>
            )}
          </Card>
        </div>
        <div className="flex min-w-0 flex-col gap-6">
          <Card title="Phân loại">
            <ChoiceField label="Danh mục *" value={form.category} disabled={locked} onChange={(category) => setForm({ ...form, category: category as SupportCategory })} options={CATEGORY_ORDER.map((value) => ({ value, label: CATEGORY_LABEL[value] }))} />
            <ChoiceField
              label="Mức ưu tiên *"
              helper={`Khách chọn: ${PRIORITY_LABEL[detail.requestedPriority]}`}
              value={form.priority}
              disabled={locked}
              onChange={(priority) => setForm({ ...form, priority: priority as SupportPriority })}
              options={PRIORITY_ORDER.map((value) => ({ value, label: PRIORITY_LABEL[value] }))}
            />
            <ChoiceField
              label="Bên xử lý chính *"
              helper={form.handler === "OPERATOR" ? "Nhà xe thấy khiếu nại và nhận email để phản hồi khách." : undefined}
              value={form.handler}
              disabled={locked}
              onChange={(handler) => setForm({ ...form, handler: handler as SupportHandler })}
              options={(Object.keys(HANDLER_LABEL) as SupportHandler[]).map((value) => ({ value, label: HANDLER_LABEL[value] }))}
            />
            <ChoiceField
              label="Người phụ trách"
              value={form.assigneeId}
              disabled={locked}
              onChange={(assigneeId) => setForm({ ...form, assigneeId })}
              options={[{ value: NONE, label: "Chưa phân công" }, ...(assignees.data ?? []).map((item) => ({ value: item.id, label: item.username }))]}
            />
            {!locked && (
              <div className="flex flex-wrap gap-2 border-t pt-4">
                {detail.status !== "RESOLVED" && (
                  <Button variant="outline" className={`${BUTTON} bg-card`} disabled={close.isPending} onClick={() => close.mutate("RESOLVED")}>
                    <CircleCheck className="size-[18px]" />
                    Đã giải quyết
                  </Button>
                )}
                <Button variant="outline" className={`${BUTTON} bg-card`} disabled={close.isPending} onClick={() => close.mutate("CLOSED")}>
                  Đóng khiếu nại
                </Button>
              </div>
            )}
          </Card>
          <Card title="Người gửi">
            <dl className="flex flex-col gap-3">
              <Row label={PARTY_LABEL[detail.reporterParty]} value={detail.reporterName} />
              <Row label="Liên hệ" value={detail.contactEmailMasked ?? "—"} />
              <Row label="Nhà xe liên quan" value={detail.operatorName} />
            </dl>
          </Card>
        </div>
      </div>
      <EscalateDialog open={escalating} detail={detail} onClose={() => setEscalating(false)} />
    </>
  );
}

/** Trả lời khách / yêu cầu khách bổ sung (kèm tệp). */
function Composer({ detail, onDone }: { detail: TicketDetail; onDone: (next: TicketDetail, message: string) => void }) {
  const [body, setBody] = useState("");
  const [files, setFiles] = useState<UploadedFile[]>([]);
  const [error, setError] = useState<string | null>(null);
  const send = useMutation({
    mutationFn: (requestInfo: boolean) => replyTicket(detail.ticketId, { body: body.trim(), attachments: files.map(({ objectKey, fileName }) => ({ objectKey, fileName })), requestInfo }),
    onSuccess: (next, requestInfo) => {
      setBody("");
      setFiles([]);
      setError(null);
      onDone(next, requestInfo ? "Đã yêu cầu khách bổ sung thông tin." : "Đã gửi phản hồi cho khách.");
    },
    onError: (failure) => setError(describeCaseError(failure).message)
  });
  const submit = (requestInfo: boolean) => {
    if (body.trim().length === 0) {
      setError("Nhập nội dung phản hồi.");
      return;
    }
    send.mutate(requestInfo);
  };
  return (
    <div className="flex flex-col gap-3 rounded-lg border p-3">
      <Textarea aria-label="Phản hồi cho hành khách" rows={3} maxLength={2000} value={body} disabled={send.isPending} placeholder="Nhập phản hồi cho hành khách…" className="border-0 shadow-none focus-visible:ring-0" onChange={(event) => setBody(event.target.value)} />
      <div className="flex flex-wrap items-center justify-between gap-3">
        <AttachmentPicker value={files} onChange={setFiles} upload={(file) => uploadAttachment({ ticketId: detail.ticketId }, file)} disabled={send.isPending} />
        <div className="flex flex-wrap gap-2">
          <Button variant="outline" className={`${BUTTON} bg-card`} disabled={send.isPending} onClick={() => submit(true)}>
            Yêu cầu khách bổ sung
          </Button>
          <Button className={BUTTON} disabled={send.isPending} onClick={() => submit(false)}>
            {send.isPending ? <LoaderCircle className="size-[18px] animate-spin" /> : <Send className="size-[18px]" />}
            Gửi phản hồi
          </Button>
        </div>
      </div>
      {error && (
        <p role="alert" className="text-sm leading-5 text-error-600">
          {error}
        </p>
      )}
    </div>
  );
}

function ChoiceField({
  label,
  helper,
  value,
  options,
  disabled,
  onChange
}: {
  label: string;
  helper?: string;
  value: string;
  options: { value: string; label: string }[];
  disabled?: boolean;
  onChange: (value: string) => void;
}) {
  return (
    <FormField label={label} helper={helper}>
      {(control) => (
        <Select value={value} onValueChange={onChange} disabled={disabled}>
          <SelectTrigger id={control.id} aria-describedby={control["aria-describedby"]}>
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            {options.map((option) => (
              <SelectItem key={option.value} value={option.value}>
                {option.label}
              </SelectItem>
            ))}
          </SelectContent>
        </Select>
      )}
    </FormField>
  );
}

/** Chuyển khiếu nại thành tranh chấp (FR-DSP-01): tiêu đề, yêu cầu của khách, lý do. */
function EscalateDialog({ open, detail, onClose }: { open: boolean; detail: TicketDetail; onClose: () => void }) {
  const router = useRouter();
  const queryClient = useQueryClient();
  const [title, setTitle] = useState(detail.subject);
  const [request, setRequest] = useState("");
  const [reason, setReason] = useState("");
  const [error, setError] = useState<string | null>(null);
  const submit = useMutation({
    mutationFn: () => escalateTicket(detail.ticketId, { title: title.trim() === detail.subject ? null : title.trim(), customerRequest: request.trim() || null, reason: reason.trim() }),
    onSuccess: (dispute) => {
      void queryClient.invalidateQueries({ queryKey: ["admin-tickets"] });
      void queryClient.invalidateQueries({ queryKey: ["admin-disputes"] });
      router.push(`/disputes/cases/${dispute.disputeId}`);
    },
    onError: (failure) => setError(describeCaseError(failure).message)
  });
  return (
    <Dialog open={open} onOpenChange={(next) => !next && onClose()}>
      <DialogContent className="sm:max-w-[560px]">
        <DialogHeader>
          <DialogTitle>Chuyển thành tranh chấp</DialogTitle>
          <DialogDescription>
            {detail.ticketCode} · Đơn {displayBookingCode(detail.bookingCode)} · {detail.operatorName}
          </DialogDescription>
        </DialogHeader>
        <form
          className="flex flex-col gap-4"
          onSubmit={(event) => {
            event.preventDefault();
            if (title.trim().length < 3 || reason.trim().length < 3) {
              setError("Nhập tiêu đề và lý do (3–500 ký tự).");
              return;
            }
            submit.mutate();
          }}
        >
          <FormField label="Tiêu đề tranh chấp *">{(control) => <Input {...control} maxLength={200} value={title} disabled={submit.isPending} onChange={(event) => setTitle(event.target.value)} />}</FormField>
          <FormField label="Yêu cầu của khách" helper="Ví dụ: Hoàn một phần tiền vé.">
            {(control) => <Input {...control} maxLength={200} value={request} disabled={submit.isPending} onChange={(event) => setRequest(event.target.value)} />}
          </FormField>
          <FormField label="Lý do chuyển *" helper="Lý do được lưu vào lịch sử tranh chấp và nhật ký audit.">
            {(control) => <Textarea {...control} rows={3} maxLength={500} value={reason} disabled={submit.isPending} onChange={(event) => setReason(event.target.value)} />}
          </FormField>
          {error && (
            <p role="alert" className="text-sm leading-5 text-error-600">
              {error}
            </p>
          )}
          <DialogFooter>
            <Button type="button" variant="outline" className={BUTTON} disabled={submit.isPending} onClick={onClose}>
              Hủy
            </Button>
            <Button type="submit" className={BUTTON} disabled={submit.isPending}>
              {submit.isPending && <LoaderCircle className="size-[18px] animate-spin" />}
              Mở tranh chấp
            </Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
