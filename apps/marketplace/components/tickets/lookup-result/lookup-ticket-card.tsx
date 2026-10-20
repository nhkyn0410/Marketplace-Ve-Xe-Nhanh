"use client";

import React from "react";
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
          <svg
            viewBox="0 0 100 100"
            className="w-14 h-14 text-slate-900"
            fill="currentColor"
            xmlns="http://www.w3.org/2000/svg"
          >
            <rect x="0" y="0" width="30" height="30" rx="3" />
            <rect x="5" y="5" width="20" height="20" fill="white" rx="1.5" />
            <rect x="10" y="10" width="10" height="10" />

            <rect x="70" y="0" width="30" height="30" rx="3" />
            <rect x="75" y="5" width="20" height="20" fill="white" rx="1.5" />
            <rect x="80" y="10" width="10" height="10" />

            <rect x="0" y="70" width="30" height="30" rx="3" />
            <rect x="5" y="75" width="20" height="20" fill="white" rx="1.5" />
            <rect x="10" y="80" width="10" height="10" />

            <rect x="36" y="8" width="8" height="6" />
            <rect x="50" y="4" width="12" height="6" />
            <rect x="36" y="20" width="6" height="8" />
            <rect x="48" y="16" width="14" height="6" />
            <rect x="40" y="32" width="6" height="6" />
            <rect x="52" y="30" width="8" height="8" />
            <rect x="66" y="36" width="8" height="6" />

            <rect x="8" y="38" width="6" height="12" />
            <rect x="20" y="42" width="8" height="6" />
            <rect x="8" y="56" width="8" height="6" />
            <rect x="22" y="54" width="6" height="10" />

            <rect x="36" y="46" width="12" height="12" />
            <rect x="54" y="44" width="6" height="14" />
            <rect x="66" y="48" width="14" height="6" />
            <rect x="42" y="64" width="8" height="6" />
            <rect x="56" y="64" width="6" height="12" />

            <rect x="36" y="76" width="10" height="6" />
            <rect x="50" y="82" width="14" height="6" />
            <rect x="70" y="70" width="6" height="8" />
            <rect x="82" y="70" width="8" height="6" />
            <rect x="74" y="84" width="16" height="6" />
          </svg>
        </div>

        {/* Thông tin hành khách */}
        <div className="space-y-1">
          <div className="flex items-center gap-2">
            <h4 className="font-bold text-foreground text-sm sm:text-base">
              {ticket.passengerName}
            </h4>
            <Badge className="bg-emerald-500/15 text-emerald-800 dark:text-emerald-300 border-emerald-500/30 text-[10px] font-semibold py-0">
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
        <button
          type="button"
          onClick={() => onCancelClick?.(ticket)}
          className="text-xs text-muted-foreground hover:text-foreground font-medium underline-offset-4 hover:underline"
        >
          Hủy vé
        </button>

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
