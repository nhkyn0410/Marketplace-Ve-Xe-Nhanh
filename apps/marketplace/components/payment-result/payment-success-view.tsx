"use client";

import { useState } from "react";
import Link from "next/link";
import { Check, Copy, Printer, Mail, Clock, Bookmark, QrCode } from "lucide-react";
import { formatVnd } from "../../lib/format";
import { BookingPaymentResultData } from "../../lib/data/types";

/**
 * Thuộc tính của component màn hình thanh toán thành công (SCR-PSG-22).
 */
export interface PaymentSuccessViewProps {
  readonly result: BookingPaymentResultData;
}

/**
 * View hiển thị kết quả Thanh toán thành công và danh sách vé điện tử theo Figma 1444:13772.
 */
export function PaymentSuccessView({ result }: PaymentSuccessViewProps) {
  const [isCopied, setIsCopied] = useState(false);
  const [resendStatus, setResendStatus] = useState<string | null>(null);

  const handleCopyCode = async () => {
    try {
      await navigator.clipboard.writeText(result.bookingCode);
      setIsCopied(true);
      setTimeout(() => setIsCopied(false), 2000);
    } catch {
      // Bỏ qua lỗi sao chép trình duyệt
    }
  };

  const handlePrint = () => {
    if (typeof window !== "undefined") {
      window.print();
    }
  };

  const handleResendEmail = () => {
    console.warn(`[marketplace] chưa có API: POST /bookings/${result.bookingId}/resend-email`);
    setResendStatus("Đã gửi lại yêu cầu gửi vé qua email (giả lập thử nghiệm).");
    setTimeout(() => setResendStatus(null), 3500);
  };

  const tickets = result.tickets ?? [];
  const trip = result.trip;
  const paymentDetails = result.paymentDetails;

  return (
    <div className="space-y-8">
      {/* 1. Header Banner Thành Công */}
      <div className="rounded-3xl border border-vxn-border bg-white p-6 sm:p-8 shadow-xs">
        <div className="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
          {/* Cụm thông tin thành công bên trái */}
          <div className="flex items-start gap-4 sm:gap-5">
            <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-full bg-emerald-50 text-emerald-600 border border-emerald-200">
              <Check className="h-7 w-7 stroke-[3]" />
            </div>
            <div className="space-y-1.5">
              <h1 className="text-xl sm:text-2xl font-black text-vxn-ink">
                Thanh toán thành công
              </h1>
              <div className="flex items-center gap-2 text-xs sm:text-sm text-vxn-fg-4">
                <span>Mã đặt vé</span>
                <span className="font-bold text-vxn-ink">{result.bookingCode}</span>
                <button
                  type="button"
                  onClick={handleCopyCode}
                  title="Sao chép mã đặt vé"
                  className="rounded p-1 text-neutral-400 hover:bg-neutral-100 hover:text-neutral-700 transition cursor-pointer"
                >
                  <Copy className="h-3.5 w-3.5" />
                </button>
                {isCopied && (
                  <span className="text-xs font-medium text-emerald-600">Đã chép</span>
                )}
              </div>
              <p className="text-xs sm:text-sm text-vxn-fg-4 leading-relaxed">
                Vé điện tử đã gửi tới{" "}
                <strong className="text-vxn-ink font-semibold">
                  {result.customerEmail ?? "khach.nguyen@gmail.com"}
                </strong>
                . Bạn cũng xem được vé trong mục Hành trình.
              </p>
            </div>
          </div>

          {/* Cụm 3 nút hành động bên phải */}
          <div className="flex flex-wrap items-center gap-2.5 shrink-0">
            <Link
              href="/my-tickets"
              className="inline-flex items-center justify-center gap-1.5 rounded-xl bg-[#00506a] px-5 py-2.5 text-xs sm:text-sm font-bold text-white shadow-xs transition hover:bg-[#00476b] active:scale-[0.99]"
            >
              <QrCode className="h-4 w-4" />
              <span>Xem vé và mã QR</span>
            </Link>
            <button
              type="button"
              onClick={handlePrint}
              className="inline-flex items-center justify-center gap-1.5 rounded-xl border border-neutral-300 bg-white px-4 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 active:scale-[0.99] cursor-pointer"
            >
              <Printer className="h-4 w-4 text-neutral-500" />
              <span>In vé</span>
            </button>
            <button
              type="button"
              onClick={handleResendEmail}
              className="inline-flex items-center justify-center gap-1.5 rounded-xl border border-neutral-300 bg-white px-4 py-2.5 text-xs sm:text-sm font-semibold text-neutral-700 transition hover:bg-neutral-50 active:scale-[0.99] cursor-pointer"
            >
              <Mail className="h-4 w-4 text-neutral-500" />
              <span>Gửi lại</span>
            </button>
          </div>
        </div>

        {/* Thông báo gửi lại email nếu có */}
        {resendStatus && (
          <div className="mt-4 rounded-xl bg-emerald-50 border border-emerald-200 p-3 text-xs sm:text-sm text-emerald-800">
            {resendStatus}
          </div>
        )}
      </div>

      {/* 2. Lưới 2 cột bên dưới */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
        {/* Cột trái (8 cột trên lg): Vé điện tử và Thông tin chuyến */}
        <div className="lg:col-span-8 space-y-6">
          {/* Khối danh sách vé điện tử */}
          <section className="space-y-4">
            <div>
              <h2 className="text-base sm:text-lg font-bold text-vxn-ink">
                Vé điện tử ({tickets.length})
              </h2>
              <p className="text-xs sm:text-sm text-vxn-fg-4 mt-0.5">
                Xuất trình mã QR của từng vé cho nhân viên nhà xe khi lên xe.
              </p>
            </div>

            <div className="space-y-3.5">
              {tickets.map((ticket) => (
                <div
                  key={ticket.ticketId}
                  className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 rounded-2xl border border-vxn-border bg-white p-4 sm:p-5 shadow-2xs"
                >
                  <div className="flex items-center gap-4">
                    {/* Minh họa mã QR */}
                    <div className="flex h-16 w-16 shrink-0 items-center justify-center rounded-xl bg-neutral-900 p-2 text-white shadow-2xs">
                      {/* Minh họa hoa văn QR Code tinh xảo */}
                      <div className="grid grid-cols-4 gap-1 w-full h-full p-0.5">
                        <div className="bg-white rounded-xs" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-neutral-900" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-neutral-900" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-neutral-900" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-neutral-900" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-white rounded-xs" />
                        <div className="bg-neutral-900" />
                        <div className="bg-white rounded-xs" />
                      </div>
                    </div>

                    {/* Thông tin vé */}
                    <div className="space-y-1">
                      <div className="font-bold text-sm sm:text-base text-vxn-ink">
                        {ticket.passengerName}
                      </div>
                      <div className="text-xs sm:text-sm text-neutral-600">
                        {ticket.seatType}
                      </div>
                      <div className="text-xs text-neutral-400">
                        {ticket.ticketCode}
                      </div>
                    </div>
                  </div>

                  {/* Badge trạng thái */}
                  <div className="self-start sm:self-center shrink-0">
                    <span className="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
                      Hợp lệ
                    </span>
                  </div>
                </div>
              ))}
            </div>
          </section>

          {/* Khối thông tin chuyến đi */}
          {trip && (
            <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs space-y-4">
              <div className="flex items-center gap-3 border-b border-vxn-border/50 pb-4">
                <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-full bg-vxn-teal-800 text-white font-bold text-sm">
                  {trip.operatorCode}
                </div>
                <div>
                  <h3 className="text-base font-bold text-vxn-ink">
                    {trip.routeName}
                  </h3>
                  <p className="text-xs sm:text-sm text-vxn-fg-4">
                    {trip.operatorName} · {trip.vehicleType}
                  </p>
                </div>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs sm:text-sm">
                <div>
                  <span className="text-vxn-fg-4 block mb-1">Khởi hành</span>
                  <span className="font-bold text-vxn-ink">
                    {trip.departureTimeText}
                  </span>
                </div>
                <div>
                  <span className="text-vxn-fg-4 block mb-1">Điểm đón</span>
                  <span className="font-semibold text-vxn-ink">
                    {trip.pickupPointName}
                  </span>
                </div>
                <div className="sm:col-span-2">
                  <span className="text-vxn-fg-4 block mb-1">Điểm trả</span>
                  <span className="font-semibold text-vxn-ink">
                    {trip.dropoffPointName} · {trip.dropoffTimeText}
                  </span>
                </div>
              </div>

              {trip.noticeText && (
                <div className="flex items-center gap-2 rounded-xl bg-neutral-50 p-3 text-xs text-neutral-600 border border-neutral-100">
                  <Clock className="h-4 w-4 text-neutral-500 shrink-0" />
                  <span>{trip.noticeText}</span>
                </div>
              )}
            </section>
          )}
        </div>

        {/* Cột phải (4 cột trên lg): Chi tiết thanh toán & Điểm thưởng VXN Plus */}
        <div className="lg:col-span-4 space-y-4">
          {paymentDetails && (
            <div className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs space-y-4">
              <h3 className="text-base font-bold text-vxn-ink border-b border-vxn-border/50 pb-3">
                Chi tiết thanh toán
              </h3>

              <div className="space-y-2.5 text-xs sm:text-sm">
                <div className="flex items-center justify-between text-neutral-600">
                  <span>Giá vé ({paymentDetails.ticketCount} chỗ)</span>
                  <span className="font-medium text-vxn-ink">
                    {formatVnd(paymentDetails.ticketPriceTotalVnd)}
                  </span>
                </div>
                <div className="flex items-center justify-between text-neutral-600">
                  <span>Phí dịch vụ</span>
                  <span className="font-medium text-vxn-ink">
                    {formatVnd(paymentDetails.serviceFeeVnd)}
                  </span>
                </div>
                <div className="flex items-center justify-between text-emerald-700">
                  <span>Voucher đổi điểm</span>
                  <span className="font-bold">
                    -{formatVnd(paymentDetails.discountVnd)}
                  </span>
                </div>

                <div className="flex items-baseline justify-between border-t border-vxn-border/60 pt-3">
                  <span className="font-bold text-vxn-ink text-sm sm:text-base">
                    Tổng thanh toán
                  </span>
                  <span className="text-xl sm:text-2xl font-black text-vxn-ink">
                    {formatVnd(paymentDetails.finalTotalVnd)}
                  </span>
                </div>
              </div>

              <div className="border-t border-vxn-border/50 pt-3 space-y-2.5 text-xs">
                <div className="flex items-center justify-between">
                  <span className="text-vxn-fg-4">Phương thức</span>
                  <span className="font-semibold text-vxn-ink">{result.paymentMethodLabel}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-vxn-fg-4">Mã giao dịch</span>
                  <span className="font-mono font-medium text-vxn-ink">{paymentDetails.gatewayTxnId}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-vxn-fg-4">Thời gian</span>
                  <span className="text-vxn-ink">{paymentDetails.paidAtText}</span>
                </div>
                <div className="flex items-center justify-between pt-1">
                  <span className="text-vxn-fg-4">Trạng thái</span>
                  <span className="inline-flex items-center rounded-md bg-emerald-50 px-2.5 py-1 text-xs font-bold text-emerald-700 border border-emerald-200">
                    Đã thanh toán
                  </span>
                </div>
              </div>
            </div>
          )}

          {/* Thẻ thưởng điểm VXN Plus */}
          <div className="flex items-center gap-3 rounded-2xl bg-amber-50/70 p-4 border border-amber-200/60 text-xs sm:text-sm text-amber-900">
            <Bookmark className="h-5 w-5 text-amber-600 shrink-0" />
            <p className="font-medium leading-relaxed">
              Bạn sẽ nhận điểm VXN Plus sau khi chuyến hoàn thành.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
