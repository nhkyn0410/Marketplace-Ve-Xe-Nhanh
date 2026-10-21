"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";
import { endTicketLookup } from "../../../lib/data/tickets";
import { Badge } from "@vexenhanh/ui/components/badge";
import type { TicketLookupResultData, TicketLookupResultItem } from "../../../lib/data/types";
import { LookupSessionBanner } from "./lookup-session-banner";
import { LookupTicketCard } from "./lookup-ticket-card";
import { LookupPickupDropoff } from "./lookup-pickup-dropoff";
import { LookupActionsSidebar } from "./lookup-actions-sidebar";
import { LookupQrModal } from "./lookup-qr-modal";

/**
 * Thuộc tính của LookupResultView
 */
export interface LookupResultViewProps {
  readonly data: TicketLookupResultData;
}

/**
 * Khung hiển thị chi tiết kết quả tra cứu vé cho khách vãng lai (SCR-PSG-29 - node 1446:15578)
 */
export const LookupResultView: React.FC<LookupResultViewProps> = ({ data }) => {
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
    <div className="min-h-screen bg-slate-50/50 pb-16">
      {/* Banner thông báo phiên làm việc an toàn 15 phút */}
      <LookupSessionBanner
        maskedEmail={data.session.maskedEmail}
        bookingCode={data.bookingCode}
        expiresInSeconds={data.session.expiresInSeconds}
        onEndSession={handleEndSession}
      />

      <div className="max-w-6xl mx-auto px-4 sm:px-6 pt-6">
        {/* Breadcrumb theo Figma */}
        <nav className="flex items-center gap-2 text-xs text-muted-foreground mb-5">
          <Link href="/" className="hover:text-foreground transition-colors">Trang chủ</Link>
          <span>›</span>
          <Link href="/tickets/lookup" className="hover:text-foreground transition-colors">Tra cứu vé</Link>
          <span>›</span>
          <span className="font-semibold text-foreground">{data.bookingCode}</span>
        </nav>

        {/* Tiêu đề đơn hàng và trạng thái */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-6">
          <div>
            <div className="flex items-center gap-3">
              <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
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

      {/* Modal phóng to mã QR */}
      <LookupQrModal
        ticket={selectedTicketForQr}
        isOpen={selectedTicketForQr !== null}
        onClose={() => setSelectedTicketForQr(null)}
      />
    </div>
  );
};
