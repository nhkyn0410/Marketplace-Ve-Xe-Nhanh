"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@vexenhanh/ui/components/button";
import { X } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { cancelTickets, getCancellationQuote } from "../../lib/data/tickets";
import type { TicketPassengerDetail, TicketTripInfo } from "../../lib/data/types";

/** Thuộc tính hộp thoại hủy vé với booking ID phục vụ gọi API. */
export interface TicketCancelDialogProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly bookingId?: string;
  readonly bookingCode: string;
  readonly trip: TicketTripInfo;
  readonly tickets: readonly TicketPassengerDetail[];
}

type Quote = Extract<Awaited<ReturnType<typeof getCancellationQuote>>, { status: "ok" }>["data"];

/** Hủy vé theo báo giá hoàn tiền hiện hành do máy chủ trả về. */
export const TicketCancelDialog: React.FC<TicketCancelDialogProps> = ({ isOpen, onClose, bookingId, bookingCode, trip, tickets }) => {
  const router = useRouter();
  const [selectedTicketIds, setSelectedTicketIds] = useState<string[]>(() => tickets.filter((ticket) => ticket.status === "valid").slice(0, 1).map((ticket) => ticket.ticketId));
  const [reason, setReason] = useState("");
  const [quote, setQuote] = useState<Quote | null>(null);
  const [quoteLoading, setQuoteLoading] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [quoteVersion, setQuoteVersion] = useState(0);

  useEffect(() => {
    if (!isOpen) return;
    let active = true;
    setQuote(null);
    setError(null);
    if (!bookingId || selectedTicketIds.length === 0) {
      setError(bookingId ? "Vui lòng chọn vé cần hủy." : "Bản xem trước không gửi yêu cầu hủy vé.");
      return;
    }
    setQuoteLoading(true);
    void getCancellationQuote(bookingId, selectedTicketIds).then((result) => {
      if (!active) return;
      if (result.status === "ok") { setQuote(result.data); if (!result.data.cancellable) setError(result.data.reason || "Vé không còn đủ điều kiện hủy."); }
      else setError(result.status === "error" ? result.message ?? "Không thể lấy báo giá hoàn tiền." : "Chưa thể lấy báo giá hoàn tiền.");
    }).catch(() => { if (active) setError("Không thể kết nối hệ thống. Vui lòng thử lại."); }).finally(() => { if (active) setQuoteLoading(false); });
    return () => { active = false; };
  }, [isOpen, bookingId, selectedTicketIds, quoteVersion]);

  if (!isOpen) return null;

  const handleSubmit = async (): Promise<void> => {
    if (!bookingId || !quote?.cancellable || quoteLoading || isSubmitting) return;
    setIsSubmitting(true);
    setError(null);
    try {
      const result = await cancelTickets(bookingId, selectedTicketIds, reason, quote.refundAmountVnd);
      if (result.status === "ok") { onClose(); router.refresh(); }
      else { setError(result.status === "error" ? result.message ?? "Không thể hủy vé. Vui lòng lấy báo giá lại." : "Chưa thể hủy vé."); setQuote(null); }
    } catch { setError("Không thể kết nối hệ thống. Vui lòng kiểm tra lại trạng thái vé trước khi thử tiếp."); setQuote(null); }
    finally { setIsSubmitting(false); }
  };

  return (
    <div role="dialog" aria-modal="true" aria-labelledby="cancel-dialog-title" className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 p-4">
      <div className="flex max-h-[90vh] w-full max-w-lg flex-col overflow-hidden rounded-2xl border border-border bg-background shadow-2xl">
        <div className="flex items-center justify-between px-6 py-5">
          <h2 id="cancel-dialog-title" className="text-xl font-bold">Hủy vé</h2>
          <button type="button" onClick={onClose} disabled={isSubmitting} aria-label="Đóng hộp thoại"><X className="h-5 w-5" /></button>
        </div>
        <div className="space-y-4 overflow-y-auto px-6 pb-5 text-sm">
          <p>{bookingCode} · {trip.routeName}<br />{trip.departureTime} · {trip.departureDateText}</p>
          {error && <p role="alert" className="rounded-xl bg-destructive/10 p-3 text-destructive">{error}</p>}
          <div className="space-y-2">
            {tickets.map((ticket) => (
              <label key={ticket.ticketId} className="flex items-center gap-3 rounded-xl border p-3">
                <input type="checkbox" checked={selectedTicketIds.includes(ticket.ticketId)} disabled={isSubmitting || ticket.status !== "valid"} onChange={() => { setQuote(null); setSelectedTicketIds((ids) => ids.includes(ticket.ticketId) ? ids.filter((id) => id !== ticket.ticketId) : [...ids, ticket.ticketId]); }} />
                <span>Chỗ {ticket.seatCode} · {ticket.passengerName}<span className="block text-xs text-muted-foreground">{ticket.statusLabel}</span></span>
              </label>
            ))}
          </div>
          {quoteLoading && <p role="status">Đang lấy báo giá hoàn tiền…</p>}
          {quote && <div className="space-y-2 rounded-xl border p-4">
            <div className="flex justify-between"><span>Giá trị vé được chọn</span><span>{formatVnd(quote.totalPaidVnd)}</span></div>
            <div className="flex justify-between"><span>Không hoàn lại</span><span>{formatVnd(quote.feeVnd)}</span></div>
            <div className="flex justify-between font-bold"><span>Tiền hoàn ({quote.refundPercent}%)</span><span>{formatVnd(quote.refundAmountVnd)}</span></div>
          </div>}
          {!quote && !quoteLoading && bookingId && <Button variant="outline" onClick={() => setQuoteVersion((version) => version + 1)}>Lấy lại báo giá</Button>}
          <label className="block space-y-2"><span>Lý do hủy (không bắt buộc)</span><textarea value={reason} onChange={(event) => setReason(event.target.value)} maxLength={500} disabled={isSubmitting} className="w-full rounded-xl border bg-background p-3" /></label>
          <p className="text-xs text-muted-foreground">Vé đã hủy không khôi phục được. Hệ thống kiểm tra lại số tiền hoàn khi xác nhận.</p>
        </div>
        <div className="grid grid-cols-2 gap-3 border-t p-5">
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>Giữ vé</Button>
          <Button variant="destructive" onClick={handleSubmit} disabled={!quote?.cancellable || quoteLoading || isSubmitting}>{isSubmitting ? "Đang xử lý…" : "Xác nhận hủy vé"}</Button>
        </div>
      </div>
    </div>
  );
};
