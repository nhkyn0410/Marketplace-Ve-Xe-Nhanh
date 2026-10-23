"use client";

import React from "react";
import Image from "next/image";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { QrCode } from "lucide-react";
import type { TicketLookupResultItem } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupTicketCard
 */
export interface LookupTicketCardProps {
  readonly ticket: TicketLookupResultItem;
  readonly onOpenQrModal?: (ticket: TicketLookupResultItem) => void;
  readonly onCancelClick?: (ticket: TicketLookupResultItem) => void;
}

/**
 * Thẻ vé đơn lẻ trong danh sách kết quả tra cứu chuẩn Figma node 1446:15578
 */
export const LookupTicketCard: React.FC<LookupTicketCardProps> = ({
  ticket,
  onOpenQrModal,
  onCancelClick
}) => {
  return (
    <div className="rounded-2xl border border-border/80 bg-card p-4 sm:p-5 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      {/* Cụm thông tin vé và mã QR thu nhỏ */}
      <div className="flex items-center gap-4">
        {/* QR Code vector thu nhỏ */}
        <div
          onClick={() => onOpenQrModal?.(ticket)}
          className="p-1.5 bg-white rounded-xl border border-border shadow-2xs shrink-0 cursor-pointer hover:border-teal-700 transition-colors"
          title="Bấm để phóng to mã QR"
        >
          {ticket.qrCodeDataUrl ? <Image src={ticket.qrCodeDataUrl} alt={`Mã QR vé ${ticket.ticketCode}`} width={64} height={64} unoptimized /> : <QrCode className="h-14 w-14 text-muted-foreground" />}
        </div>

        {/* Thông tin hành khách */}
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <h4 className="font-bold text-foreground text-sm sm:text-base">
              {ticket.passengerName}
            </h4>
            <Badge tone={ticket.status === "valid" ? "success" : "neutral"} className="text-[10px] font-semibold py-0">
              {ticket.statusLabel}
            </Badge>
          </div>

          <div className="text-xs text-muted-foreground">
            Chỗ {ticket.seatCode} · {ticket.seatType}
          </div>

          <div className="text-[11px] font-mono text-muted-foreground">
            Mã vé {ticket.ticketCode}
          </div>
        </div>
      </div>

      {/* Cụm nút hành động */}
      <div className="flex items-center gap-3 self-end sm:self-auto">
        {onCancelClick && <button
          type="button"
          onClick={() => onCancelClick?.(ticket)}
          className="text-xs text-muted-foreground hover:text-foreground font-medium underline-offset-4 hover:underline"
        >
          Hủy vé
        </button>}

        <Button
          type="button"
          size="sm"
          onClick={() => onOpenQrModal?.(ticket)}
          className="h-9 gap-1.5 text-xs font-bold bg-teal-900 hover:bg-teal-950 text-white rounded-xl shadow-xs"
        >
          <QrCode className="h-3.5 w-3.5" />
          <span>Xem mã QR</span>
        </Button>
      </div>
    </div>
  );
};
