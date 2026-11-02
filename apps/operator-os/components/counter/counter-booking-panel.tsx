"use client";

import { useMutation, useQueries, useQuery, useQueryClient } from "@tanstack/react-query";
import { CounterReceiptInputSchema, type CounterReceiptInput } from "@vexenhanh/types";
import { useCan } from "@vexenhanh/ui/components/auth/auth-context";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Input } from "@vexenhanh/ui/components/input";
import { Banknote, CircleAlert, CircleCheck, LoaderCircle, Printer, RefreshCw } from "lucide-react";
import QRCode from "qrcode";
import { useEffect, useState, type FormEvent } from "react";

import { ApiError } from "../../lib/auth/api-client";
import { confirmCounterReceipt, getCounterBooking, type CounterBooking } from "../../lib/counter/counter-api";
import { counterBookingLabel, counterError, counterExceptionLabel, counterMoney, counterTicketLabel, receiptInputError } from "../../lib/counter/counter-format";
import { clearReceiptAttempt, readReceiptAttempt, saveReceiptAttempt } from "../../lib/counter/receipt-attempt";
import { formatDateTime } from "../../lib/route/route-format";
import { FormField } from "../form-field";

const CARD = "rounded-xl border bg-card p-5 sm:p-6";

/** Mở lại đơn quầy để xác nhận thu, kiểm tra ngoại lệ hoặc in lại vé đã phát. */
export function CounterBookingPanel({ bookingId, onChanged }: { bookingId: string; onChanged: () => void }) {
  const booking = useQuery({ queryKey: ["counter-booking", bookingId], queryFn: () => getCounterBooking(bookingId), retry: (count, error) => !(error instanceof ApiError && [403, 404].includes(error.status)) && count < 2 });
  if (booking.isPending) return <p role="status" className="flex items-center gap-2 py-5 text-sm"><LoaderCircle className="size-4 animate-spin" />Đang tải đơn quầy…</p>;
  if (booking.isError) return <div role="alert" className={`${CARD} flex flex-col gap-4 print:hidden`}><p>{counterError(booking.error)}</p><Button variant="outline" onClick={() => void booking.refetch()}>Thử lại</Button></div>;
  return <BookingBody booking={booking.data} onChanged={onChanged} />;
}

function BookingBody({ booking, onChanged }: { booking: CounterBooking; onChanged: () => void }) {
  const can = useCan();
  const completed = booking.receipts.some((receipt) => receipt.status === "COMPLETED");
  const exception = booking.receipts.some((receipt) => receipt.status === "EXCEPTION");
  useEffect(() => {
    if (completed || exception) clearReceiptAttempt(booking.bookingId);
  }, [booking.bookingId, completed, exception]);
  return <div className="flex flex-col gap-6">
    <section className={`${CARD} flex flex-col gap-4 print:hidden`}>
      <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="font-semibold">Đơn {booking.bookingCode}</h2><Badge tone={completed ? "success" : exception ? "danger" : "warning"}>{completed ? "Đã thu tiền và phát vé" : exception ? "Khoản thu cần xử lý" : counterBookingLabel(booking.status)}</Badge></div>
      <dl className="grid gap-3 text-sm sm:grid-cols-2"><div><dt className="text-xs text-muted-foreground">Chuyến</dt><dd className="mt-1 font-medium">{booking.trip.routeName} · {formatDateTime(booking.trip.departureAt)}</dd></div><div><dt className="text-xs text-muted-foreground">Khách liên hệ</dt><dd className="mt-1">{booking.contact.fullName} · {booking.contact.phone}</dd></div><div><dt className="text-xs text-muted-foreground">Người tạo đơn</dt><dd className="mt-1">{booking.seller}</dd></div><div><dt className="text-xs text-muted-foreground">Tổng phải thu</dt><dd className="mt-1 font-semibold">{counterMoney(booking.total)}</dd></div></dl>
      {!completed && <p className="text-xs text-muted-foreground">Hạn giữ chỗ: {formatDateTime(booking.expiresAt)}. Mốc xe khởi hành thực tế có thể kết thúc khả năng phát vé sớm hơn hạn này.</p>}
      {exception && <p role="alert" className="rounded-lg bg-error-50 p-3 text-sm leading-6 text-error-700">{completed ? "Có khoản thu bổ sung cần xử lý. Vé đã phát vẫn giữ nguyên; kiểm tra khoản thu bên dưới và chuyển chủ nhà xe xử lý." : "Tiền đã được ghi nhận nhưng đơn chưa được phát vé. Kiểm tra khoản thu bên dưới và chuyển chủ nhà xe xử lý. Không thu thêm cho cùng khoản tiền."}</p>}
    </section>

    {!completed && !exception && can("counter:collect") && <ReceiptForm key={booking.bookingId} booking={booking} onChanged={onChanged} />}

    {booking.receipts.length > 0 && (
      <section className={`${CARD} flex flex-col gap-3 print:hidden`} aria-label="Lịch sử thu tiền">
        <h3 className="font-semibold">Khoản tiền đã ghi nhận</h3>
        {booking.receipts.map((receipt) => (
          <div key={receipt.id} className="flex flex-col gap-1 rounded-lg border p-3 text-sm">
            <p className="font-medium">{receipt.method === "CASH" ? "Tiền mặt" : "Chuyển khoản"} · {counterMoney(receipt.amount)}</p>
            <p className="text-xs text-muted-foreground">{formatDateTime(receipt.createdAt)}{receipt.reference ? ` · ${receipt.reference}` : ""}</p>
            <p className={receipt.status === "EXCEPTION" ? "text-error-600" : "text-success-700"}>{receipt.status === "EXCEPTION" ? counterExceptionLabel(receipt.exceptionReason) : "Đã xác nhận và phát vé"}</p>
          </div>
        ))}
      </section>
    )}

    {booking.tickets.length > 0 && <CounterTickets booking={booking} />}
  </div>;
}

function ReceiptForm({ booking, onChanged }: { booking: CounterBooking; onChanged: () => void }) {
  const queryClient = useQueryClient();
  const [attempt, setAttempt] = useState<CounterReceiptInput | null>(() => readReceiptAttempt(booking.bookingId));
  const [method, setMethod] = useState<"CASH" | "BANK_TRANSFER">(attempt?.method ?? "CASH");
  const [amount, setAmount] = useState(attempt?.amount ?? booking.total);
  const [reference, setReference] = useState(attempt?.reference ?? "");
  const [confirmed, setConfirmed] = useState(Boolean(attempt));
  const [formError, setFormError] = useState<string | null>(null);
  const [storageWarning, setStorageWarning] = useState(false);
  const mutation = useMutation({
    mutationFn: (input: CounterReceiptInput) => confirmCounterReceipt(booking.bookingId, input),
    onSuccess: (result) => {
      clearReceiptAttempt(booking.bookingId);
      queryClient.setQueryData(["counter-booking", booking.bookingId], result.booking);
      onChanged();
    },
    onError: (error) => {
      // Các lỗi từ chối rõ ràng chưa nhận thao tác cho phép sửa dữ liệu; lỗi mạng/5xx giữ đúng mã và nội dung thử lại.
      if (error instanceof ApiError && error.status >= 400 && error.status < 500) {
        clearReceiptAttempt(booking.bookingId);
        setAttempt(null);
      }
      void queryClient.invalidateQueries({ queryKey: ["counter-bookings"] });
    },
  });

  function submit(event: FormEvent) {
    event.preventDefault();
    setFormError(null);
    if (attempt) { mutation.mutate(attempt); return; }
    const error = receiptInputError(method, amount.trim(), reference);
    if (error) { setFormError(error); return; }
    if (!confirmed) { setFormError("Xác nhận đã kiểm đếm hoặc đối chiếu tiền thực nhận trước khi ghi khoản thu."); return; }
    const parsed = CounterReceiptInputSchema.safeParse({ idempotencyKey: crypto.randomUUID(), method, amount: amount.trim(), reference: method === "BANK_TRANSFER" ? reference.trim() : null });
    if (!parsed.success) { setFormError("Kiểm tra số tiền và mã giao dịch trước khi xác nhận."); return; }
    const input = parsed.data;
    setStorageWarning(!saveReceiptAttempt(booking.bookingId, input));
    setAttempt(input);
    mutation.mutate(input);
  }

  return <section className={`${CARD} flex flex-col gap-4 print:hidden`} aria-label="Xác nhận tiền thực nhận"><h2 className="flex items-center gap-2 font-semibold"><Banknote className="size-5" />4. Thu tiền và phát vé</h2><p className="text-sm leading-6 text-muted-foreground">Nhà xe trực tiếp nhận tiền. Chuyển khoản cần đối chiếu trên tài khoản ngân hàng nhà xe; ảnh chụp của khách chưa đủ xác nhận.</p><form onSubmit={submit} noValidate className="flex flex-col gap-4"><fieldset disabled={mutation.isPending || Boolean(attempt)} className="grid gap-4 sm:grid-cols-2"><FormField label="Phương thức thu">{(control) => <select {...control} value={method} onChange={(event) => setMethod(event.target.value as typeof method)} className="h-10 w-full rounded-lg border border-input bg-card px-3 text-sm"><option value="CASH">Tiền mặt</option><option value="BANK_TRANSFER">Chuyển khoản vào nhà xe</option></select>}</FormField><FormField label="Số tiền thực nhận (VND)" helper="Nhập đủ số đồng, không dùng dấu phân cách.">{(control) => <Input {...control} value={amount} inputMode="numeric" onChange={(event) => setAmount(event.target.value)} />}</FormField>{method === "BANK_TRANSFER" && <FormField label="Mã giao dịch ngân hàng *">{(control) => <Input {...control} value={reference} maxLength={160} onChange={(event) => setReference(event.target.value)} />}</FormField>}<label className="flex items-start gap-3 rounded-lg bg-muted p-3 text-sm leading-6 sm:col-span-2"><input type="checkbox" checked={confirmed} onChange={(event) => setConfirmed(event.target.checked)} className="mt-1 size-4 shrink-0 accent-primary" /><span>Tôi đã {method === "CASH" ? "kiểm đếm tiền mặt" : "đối chiếu khoản chuyển vào tài khoản nhà xe"} và xác nhận số tiền thực nhận ở trên.</span></label></fieldset>{amount.trim() !== booking.total && <p className="rounded-lg bg-warning-50 p-3 text-sm text-warning-700">Số thực nhận khác số phải thu. Hệ thống sẽ lưu khoản tiền để xử lý ngoại lệ và không tự phát vé.</p>}{formError && <p role="alert" className="text-sm text-error-600">{formError}</p>}{storageWarning && <p role="alert" className="rounded-lg bg-warning-50 p-3 text-sm leading-6 text-warning-700">Trình duyệt không lưu được lần xác nhận này. Giữ nguyên trang để thử lại nếu mất kết nối; mở lại đơn để đối chiếu trước khi xác nhận thêm khoản tiền.</p>}{mutation.isError && <p role="alert" className="flex items-start gap-2 rounded-lg bg-error-50 p-3 text-sm text-error-700"><CircleAlert className="mt-0.5 size-4 shrink-0" /><span>{counterError(mutation.error)}{attempt && " Thử lại sẽ dùng cùng mã xác nhận; không thu thêm tiền của khách."}</span></p>}<Button type="submit" disabled={mutation.isPending} className="self-end">{mutation.isPending ? <LoaderCircle className="size-4 animate-spin" /> : attempt ? <RefreshCw className="size-4" /> : <CircleCheck className="size-4" />}{attempt ? "Thử lại cùng khoản thu" : "Xác nhận tiền đã nhận"}</Button></form></section>;
}

function CounterTickets({ booking }: { booking: CounterBooking }) {
  const qr = useQueries({ queries: booking.tickets.map((ticket) => ({ queryKey: ["counter-ticket-qr", ticket.ticketId], queryFn: () => QRCode.toDataURL(ticket.qrToken, { width: 240, margin: 2 }), staleTime: Infinity })) });
  const pending = qr.some((result) => result.isPending);
  const failed = qr.some((result) => result.isError);
  return (
    <section className={`${CARD} flex flex-col gap-4 print:border-0 print:p-0`} aria-label="Vé đã phát">
      <div className="flex flex-wrap items-center justify-between gap-3 print:hidden">
        <div><h2 className="font-semibold">Vé đã phát</h2><p className="mt-1 text-xs text-muted-foreground">In lại chỉ dùng vé đã có, không tạo khoản thu hoặc vé mới.</p></div>
        <Button variant="outline" disabled={pending || failed} onClick={() => window.print()}><Printer className="size-4" />In vé</Button>
      </div>
      {failed && <p role="alert" className="text-sm text-error-600 print:hidden">Chưa tạo được ảnh QR. <button type="button" className="underline" onClick={() => qr.forEach((query) => void query.refetch())}>Thử lại</button></p>}
      <div className="grid gap-4 sm:grid-cols-2 print:grid-cols-1">
        {booking.tickets.map((ticket, index) => (
          <article key={ticket.ticketId} className="flex break-inside-avoid flex-col items-center gap-3 rounded-xl border p-5 text-center">
            <p className="text-xs font-semibold uppercase tracking-wide text-primary">Vé Xe Nhanh · Vé tại văn phòng</p>
            <h3 className="text-lg font-semibold">{booking.trip.routeName}</h3>
            <p className="text-sm">{formatDateTime(booking.trip.departureAt)}</p>
            <p className="text-base font-semibold">Ghế {ticket.seatCode} · {ticket.passengerName}{ticket.companionName ? ` và ${ticket.companionName}` : ""}</p>
            {qr[index]?.data && <img src={qr[index].data} alt={`Mã QR vé ${ticket.ticketCode}`} width={200} height={200} />}
            {qr[index]?.isPending && <p role="status" className="text-sm">Đang tạo QR…</p>}
            <p className="font-mono text-sm font-semibold">{ticket.ticketCode}</p>
            <p className="text-xs text-muted-foreground">Đơn {booking.bookingCode} · Người bán {booking.seller}</p>
            <Badge tone={ticket.status === "VALID" ? "success" : "neutral"}>{counterTicketLabel(ticket.status)}</Badge>
          </article>
        ))}
      </div>
    </section>
  );
}
