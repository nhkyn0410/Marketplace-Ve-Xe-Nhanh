"use client";

import React, { useState } from "react";
import { Button } from "@vexenhanh/ui/components/button";
import { AlertCircle, AlertTriangle, X, Check } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { cancelTickets } from "../../lib/data/tickets";
import type { TicketPassengerDetail, TicketTripInfo } from "../../lib/data/types";

/**
 * Thuộc tính của TicketCancelDialog
 */
export interface TicketCancelDialogProps {
  readonly isOpen: boolean;
  readonly onClose: () => void;
  readonly bookingCode: string;
  readonly trip: TicketTripInfo;
  readonly tickets: readonly TicketPassengerDetail[];
}

/**
 * Danh sách lý do hủy vé mẫu chuẩn Figma 1456:23988
 */
const CANCEL_REASONS = [
  "Thay đổi kế hoạch cá nhân",
  "Đặt nhầm ngày / giờ khởi hành",
  "Có việc gia đình đột xuất",
  "Tìm được phương tiện di chuyển khác",
  "Lý do khác"
] as const;

/**
 * Hộp thoại Hủy vé (SCR-PSG-26) theo Figma node 1456:23988
 */
export const TicketCancelDialog: React.FC<TicketCancelDialogProps> = ({
  isOpen,
  onClose,
  bookingCode,
  trip,
  tickets
}) => {
  const [selectedTicketIds, setSelectedTicketIds] = useState<string[]>(() => {
    return tickets.length > 0 && tickets[0] ? [tickets[0].ticketId] : [];
  });
  const [reason, setReason] = useState<string>("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [inlineErrorMessage, setInlineErrorMessage] = useState<string | null>(null);

  if (!isOpen) {
    return null;
  }

  // Chuyển đổi chọn/bỏ chọn vé
  const handleToggleTicket = (ticketId: string): void => {
    setInlineErrorMessage(null);
    setSelectedTicketIds((prev) => {
      if (prev.includes(ticketId)) {
        if (prev.length === 1) {
          return prev;
        }
        return prev.filter((id) => id !== ticketId);
      }
      return [...prev, ticketId];
    });
  };

  const selectedTickets = tickets.filter((t) => selectedTicketIds.includes(t.ticketId));
  const selectedCount = selectedTickets.length;

  // Tính toán số tiền bằng BigInt (giả sử mỗi vé 230.000đ, phí hủy 10% = 23.000đ, hoàn 207.000đ)
  const totalPaidBigInt = selectedTickets.reduce((acc, t) => {
    return acc + BigInt(t.pricePaidVnd);
  }, BigInt(0));

  const feeBigInt = (totalPaidBigInt * BigInt(10)) / BigInt(100);
  const refundBigInt = totalPaidBigInt - feeBigInt;

  // Xử lý gửi yêu cầu hủy vé (tuân thủ A3 #6: hiển thị lỗi tại chỗ)
  const handleSubmitCancel = async (): Promise<void> => {
    setIsSubmitting(true);
    setInlineErrorMessage(null);

    try {
      const result = await cancelTickets(bookingCode, selectedTicketIds, reason);
      if (result.status === "unavailable" || result.status === "error") {
        setInlineErrorMessage(
          "Chức năng hủy vé trực tuyến tạm thời chưa khả dụng trên hệ thống. Quý khách vui lòng gọi tổng đài 1900 6067 để nhân viên hỗ trợ ngay lập tức."
        );
      }
    } catch {
      setInlineErrorMessage("Đã có lỗi xảy ra. Quý khách vui lòng thử lại sau.");
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div
      role="dialog"
      aria-modal="true"
      aria-labelledby="cancel-dialog-title"
      className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs animate-in fade-in duration-200"
    >
      <div className="relative w-full max-w-lg rounded-2xl bg-background border border-border shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Header Modal */}
        <div className="flex items-center justify-between px-6 pt-5 pb-3">
          <h2 id="cancel-dialog-title" className="text-xl font-bold text-foreground">
            Hủy vé
          </h2>

          <button
            type="button"
            onClick={onClose}
            aria-label="Đóng hộp thoại"
            className="p-1 rounded-md text-muted-foreground hover:bg-muted hover:text-foreground transition-colors"
          >
            <X className="h-5 w-5" />
          </button>
        </div>

        {/* Nội dung chính Modal */}
        <div className="px-6 py-2 overflow-y-auto space-y-4">
          {/* Thông báo lỗi tại chỗ nếu bấm hủy */}
          {inlineErrorMessage && (
            <div className="p-3.5 rounded-xl bg-destructive/10 border border-destructive/30 flex items-start gap-2.5 text-xs text-destructive animate-in fade-in">
              <AlertCircle className="h-4 w-4 shrink-0 mt-0.5" />
              <div className="leading-relaxed font-medium">
                {inlineErrorMessage}
              </div>
            </div>
          )}

          {/* Box thông tin tóm tắt chuyến xe nền xám bo tròn chuẩn Figma */}
          <div className="p-3.5 rounded-xl bg-muted/40 border border-border/60 space-y-1">
            <div className="text-xs font-bold text-foreground">
              {bookingCode} · {trip.routeName}
            </div>
            <div className="text-[11px] text-muted-foreground">
              Khởi hành {trip.departureTime} · {trip.departureDayOfWeek}, {trip.departureDateText} · {trip.operatorName}
            </div>
          </div>

          {/* Danh sách chọn vé muốn hủy */}
          <div className="space-y-2">
            <label className="text-xs font-semibold text-foreground">
              Chọn vé muốn hủy
            </label>
            <div className="space-y-2">
              {tickets.map((ticket) => {
                const isChecked = selectedTicketIds.includes(ticket.ticketId);
                return (
                  <div
                    key={ticket.ticketId}
                    onClick={() => handleToggleTicket(ticket.ticketId)}
                    className="flex items-center justify-between p-3 rounded-xl border border-border/60 bg-background hover:bg-muted/30 cursor-pointer transition-all"
                  >
                    <div className="flex items-center gap-2.5">
                      <div
                        className={`h-4 w-4 rounded flex items-center justify-center border transition-colors ${
                          isChecked
                            ? "bg-teal-700 border-teal-700 text-white"
                            : "border-muted-foreground/40 bg-background"
                        }`}
                      >
                        {isChecked && <Check className="h-3 w-3 stroke-[3]" />}
                      </div>
                      <div className="text-xs text-foreground">
                        <span className="font-bold">Chỗ {ticket.seatCode}</span>
                        <span className="text-muted-foreground"> · {ticket.passengerName}</span>
                      </div>
                    </div>

                    <div className="text-xs text-muted-foreground">
                      Đã trả {formatVnd(ticket.pricePaidVnd)}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Bảng tính tiền hoàn dự kiến */}
          <div className="p-4 rounded-xl border border-border/80 space-y-2.5 text-xs">
            <div className="font-bold text-foreground text-xs pb-1 border-b border-border/50">
              Tiền hoàn dự kiến (theo chính sách lưu lúc đặt)
            </div>

            <div className="flex items-center justify-between text-muted-foreground pt-1">
              <span>Số tiền đã trả cho vé hủy</span>
              <span className="font-semibold text-foreground">{formatVnd(totalPaidBigInt.toString())}</span>
            </div>

            <div className="flex items-center justify-between text-muted-foreground">
              <span>Phí hủy 10% (hủy trước 24 giờ)</span>
              <span className="font-semibold text-rose-600">-{formatVnd(feeBigInt.toString())}</span>
            </div>

            <div className="pt-2 border-t border-border/50 flex items-center justify-between font-bold">
              <span className="text-foreground">Hoàn về VNPay</span>
              <span className="text-base text-emerald-600 dark:text-emerald-400">
                {formatVnd(refundBigInt.toString())}
              </span>
            </div>
          </div>

          {/* Chọn lý do hủy (không bắt buộc) */}
          <div className="space-y-1.5">
            <label htmlFor="cancel-reason-select" className="text-xs font-semibold text-foreground">
              Lý do hủy (không bắt buộc)
            </label>
            <select
              id="cancel-reason-select"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              className="w-full text-xs rounded-lg border border-border bg-background px-3 py-2 text-foreground focus:outline-none focus:ring-2 focus:ring-primary/20"
            >
              <option value="">Chọn lý do</option>
              {CANCEL_REASONS.map((r) => (
                <option key={r} value={r}>
                  {r}
                </option>
              ))}
            </select>
          </div>

          {/* Cảnh báo vàng quan trọng chuẩn Figma */}
          <div className="p-3.5 rounded-xl bg-amber-500/10 border border-amber-500/25 flex items-start gap-2.5 text-xs text-amber-950 dark:text-amber-200">
            <AlertTriangle className="h-4 w-4 shrink-0 text-amber-600 dark:text-amber-400 mt-0.5" />
            <div className="leading-relaxed">
              Voucher đã dùng cho đơn này không được trả lại khi bạn tự hủy vé. Vé đã hủy không khôi phục được.
            </div>
          </div>
        </div>

        {/* Footer nút hành động */}
        <div className="p-5 border-t border-border space-y-2">
          <div className="grid grid-cols-2 gap-3">
            <Button
              type="button"
              variant="outline"
              size="sm"
              onClick={onClose}
              disabled={isSubmitting}
              className="h-10 text-xs font-semibold"
            >
              Giữ vé
            </Button>

            <Button
              type="button"
              variant="destructive"
              size="sm"
              onClick={handleSubmitCancel}
              disabled={isSubmitting || selectedCount === 0}
              className="h-10 text-xs font-semibold bg-rose-600 hover:bg-rose-700 text-white"
            >
              {isSubmitting ? "Đang xử lý..." : `Tiếp tục hủy ${selectedCount} vé`}
            </Button>
          </div>

          <p className="text-[11px] text-center text-muted-foreground pt-1">
            Bước tiếp theo: nhập mã OTP gửi tới email của bạn để xác minh.
          </p>
        </div>
      </div>
    </div>
  );
};
