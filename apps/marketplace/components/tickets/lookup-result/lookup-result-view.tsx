"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { endTicketLookup } from "../../../lib/data/tickets";
import { Badge } from "@vexenhanh/ui/components/badge";
import type { TicketLookupResultData, TicketLookupResultItem } from "../../../lib/data/types";
import { LookupSessionBanner } from "./lookup-session-banner";
import { LookupTicketCard } from "./lookup-ticket-card";
import { LookupPickupDropoff } from "./lookup-pickup-dropoff";
import { LookupActionsSidebar } from "./lookup-actions-sidebar";
import { LookupQrModal } from "./lookup-qr-modal";
import { LookupLoginPrompt, type LookupLoginPromptProps } from "./lookup-login-prompt";
import { PassengerTopBar } from "../../passenger-topbar";

/**
 * Thuộc tính của LookupResultView
 */
export interface LookupResultViewProps {
  readonly data: TicketLookupResultData;
  /** Phiên theo email: đơn này được chọn từ danh sách — hiện đường quay lại danh sách. */
  readonly backToList?: boolean;
  /** Hỏi khách có muốn đăng nhập (email có tài khoản / đơn đặt bằng tài khoản). */
  readonly loginPrompt?: LookupLoginPromptProps | null;
}

/**
 * Khung hiển thị chi tiết kết quả tra cứu vé cho khách vãng lai (SCR-PSG-29 - node 1446:15578)
 */
export const LookupResultView: React.FC<LookupResultViewProps> = ({ data, backToList = false, loginPrompt = null }) => {
  const [selectedTicketForQr, setSelectedTicketForQr] = useState<TicketLookupResultItem | null>(null);

  useEffect(() => {
    const timer = setTimeout(() => {
      void endTicketLookup().finally(() => window.location.replace("/tickets/lookup"));
    }, Math.max(0, data.session.expiresInSeconds) * 1000);
    return () => clearTimeout(timer);
  }, [data.session.expiresInSeconds]);

  const handleEndSession = async () => {
    await endTicketLookup();
    window.location.href = "/tickets/lookup";
  };

  return (
    <div className="min-h-viewport bg-slate-50/50 pb-16">
      <PassengerTopBar
        breadcrumbs={backToList
          ? [{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé", href: "/tickets/lookup" }, { label: "Đơn của bạn", href: "/tickets/lookup/result" }, { label: data.bookingCode }]
          : [{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé", href: "/tickets/lookup" }, { label: data.bookingCode }]}
      />

      <div className="mx-auto w-full max-w-[1200px] px-4 pt-6 sm:px-6 lg:px-14">
        <div className="mb-6">
          <LookupSessionBanner
          maskedEmail={data.session.maskedEmail}
          {...(backToList ? { summary: `đang xem đơn ${data.bookingCode}` } : { bookingCode: data.bookingCode })}
          expiresInSeconds={data.session.expiresInSeconds}
          onEndSession={handleEndSession}
        />
        </div>

        {backToList && (
          <Link href="/tickets/lookup/result" className="mb-4 inline-flex items-center gap-1.5 text-xs font-semibold text-teal-800 hover:underline">
            <ArrowLeft className="h-3.5 w-3.5" />
            Danh sách đơn của email này
          </Link>
        )}

        {/* Tiêu đề đơn hàng và trạng thái */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-6">
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
                Đơn {data.bookingCode}
              </h1>
              <Badge tone={data.statusLabel === "Đã xác nhận" ? "success" : "neutral"} className="font-semibold px-2.5 py-0.5">
                {data.statusLabel}
              </Badge>
            </div>
            <p className="text-sm text-muted-foreground mt-1.5">
              {data.routeName} · {data.departureTimeText} · {data.operatorName}
            </p>
          </div>
        </div>

        {/* Lưới nội dung 2 cột: Cột chính (Vé + Điểm đón trả) và Cột phụ (Thanh toán + Thao tác + Tạo TK) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 items-start">
          {/* Cột chính bên trái: 7 cột */}
          <div className="lg:col-span-7 space-y-6">
            {/* Danh sách vé xe trong đơn */}
            <div className="space-y-4">
              {data.tickets.length === 0 && <p className="rounded-xl border bg-white p-5 text-sm text-muted-foreground">Đơn chưa có vé được phát hành. Kiểm tra trạng thái thanh toán của đơn.</p>}
              {data.tickets.map((ticket) => (
                <LookupTicketCard
                  key={ticket.ticketId}
                  ticket={ticket}
                  onOpenQrModal={(t) => setSelectedTicketForQr(t)}
                />
              ))}
            </div>

            {/* Điểm đón và Điểm trả */}
            <LookupPickupDropoff
              pickupPoint={data.pickupPoint}
              dropoffPoint={data.dropoffPoint}
            />
          </div>

          {/* Cột phụ bên phải: 5 cột */}
          <div className="lg:col-span-5">
            <LookupActionsSidebar
              bookingCode={data.bookingCode}
              bookingId={data.bookingId}
              canManageBooking={data.canManageBooking}
              ticketId={data.tickets[0]?.ticketId}
              payment={data.payment}
              onPrintOrder={() => window.print()}
            />
          </div>
        </div>
      </div>

      {loginPrompt && <LookupLoginPrompt {...loginPrompt} />}

      {/* Modal phóng to mã QR */}
      <LookupQrModal
        ticket={selectedTicketForQr}
        isOpen={selectedTicketForQr !== null}
        onClose={() => setSelectedTicketForQr(null)}
      />
    </div>
  );
};
