"use client";

import React, { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@vexenhanh/ui/components/button";
import { AlertTriangle, X } from "lucide-react";
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
    <div role="dialog" aria-modal="true" aria-labelledby="cancel-dialog-title" className="fixed inset-0 z-50 flex items-center justify-center bg-[rgb(8_23_33/0.55)] p-4">
      {/* Modal Hủy vé — Figma 1456:23988 */}
      <div className="flex max-h-[calc(var(--vxn-vh)*0.9)] w-full max-w-[480px] flex-col overflow-hidden rounded-2xl border border-border bg-card shadow-2xl">
        <div className="flex items-center justify-between px-5 pt-5 pb-3">
          <h2 id="cancel-dialog-title" className="text-lg/6 font-semibold text-vxn-ink">Hủy vé</h2>
          <button type="button" onClick={onClose} disabled={isSubmitting} aria-label="Đóng hộp thoại" className="rounded-full p-0.5 text-vxn-fg-5 hover:bg-muted hover:text-vxn-ink">
            <X className="h-5 w-5" />
          </button>
        </div>

        <div className="space-y-4 overflow-y-auto px-5 pb-5 text-sm">
          <div className="rounded-xl bg-vxn-bg-soft p-3">
            <p className="text-[13px] font-semibold text-vxn-ink">{bookingCode} · {trip.routeName}</p>
            <p className="mt-0.5 text-xs text-vxn-fg-5">Khởi hành {trip.departureTime} · {trip.departureDateText} · {trip.operatorName}</p>
          </div>

          {error && <p role="alert" className="rounded-xl bg-destructive/10 p-3 text-[13px] text-destructive">{error}</p>}

          <fieldset className="space-y-2">
            <legend className="mb-2 text-[13px] font-semibold text-vxn-ink">Chọn vé muốn hủy</legend>
            {tickets.map((ticket) => (
              <label key={ticket.ticketId} className={`flex items-center gap-3 rounded-xl border border-vxn-border px-3 py-2.5 ${ticket.status === "valid" ? "cursor-pointer" : "opacity-60"}`}>
                <input type="checkbox" className="size-4 accent-vxn-teal-700" checked={selectedTicketIds.includes(ticket.ticketId)} disabled={isSubmitting || ticket.status !== "valid"} onChange={() => { setQuote(null); setSelectedTicketIds((ids) => ids.includes(ticket.ticketId) ? ids.filter((id) => id !== ticket.ticketId) : [...ids, ticket.ticketId]); }} />
                <span className="min-w-0 flex-1 text-[13px] text-vxn-ink">Chỗ {ticket.seatCode} · {ticket.passengerName}</span>
                <span className="shrink-0 text-xs text-vxn-fg-5">{ticket.statusLabel}</span>
              </label>
            ))}
          </fieldset>

          {quoteLoading && <p role="status" className="text-[13px] text-vxn-fg-5">Đang lấy báo giá hoàn tiền…</p>}
          {quote && (
            <div className="space-y-2 rounded-xl border border-vxn-border p-4 text-[13px]">
              <p className="text-xs font-semibold text-vxn-ink">Tiền hoàn dự kiến (theo chính sách lưu lúc đặt)</p>
              <div className="flex justify-between text-vxn-fg-5"><span>Số tiền đã trả cho vé hủy</span><span className="text-vxn-ink">{formatVnd(quote.totalPaidVnd)}</span></div>
              <div className="flex justify-between text-vxn-fg-5"><span>Không hoàn lại</span><span className="text-vxn-ink">-{formatVnd(quote.feeVnd)}</span></div>
              <div className="flex items-baseline justify-between border-t border-vxn-border pt-2">
                <span className="font-semibold text-vxn-ink">Tiền hoàn ({quote.refundPercent}%)</span>
                <span className="text-lg font-semibold text-success-600">{formatVnd(quote.refundAmountVnd)}</span>
              </div>
            </div>
          )}
          {!quote && !quoteLoading && bookingId && <Button variant="outline" onClick={() => setQuoteVersion((version) => version + 1)}>Lấy lại báo giá</Button>}

          <label className="block space-y-2">
            <span className="text-[13px] font-semibold text-vxn-ink">Lý do hủy (không bắt buộc)</span>
            <textarea value={reason} onChange={(event) => setReason(event.target.value)} maxLength={500} disabled={isSubmitting} rows={3} placeholder="Ví dụ: đổi kế hoạch đi lại" className="w-full rounded-xl border border-vxn-border bg-white p-3 text-[13px] outline-none focus:border-vxn-teal-700" />
          </label>

          <div className="flex items-start gap-2 rounded-xl border border-amber-200 bg-amber-50 p-3 text-xs text-amber-800">
            <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" />
            <span>Vé đã hủy không khôi phục được. Hệ thống kiểm tra lại số tiền hoàn khi xác nhận.</span>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3 border-t border-vxn-border p-5">
          <Button variant="outline" onClick={onClose} disabled={isSubmitting}>Giữ vé</Button>
          <Button variant="destructive" onClick={handleSubmit} disabled={!quote?.cancellable || quoteLoading || isSubmitting}>
            {isSubmitting ? "Đang xử lý…" : selectedTicketIds.length ? `Hủy ${selectedTicketIds.length} vé` : "Hủy vé"}
          </Button>
        </div>
      </div>
    </div>
  );
};
