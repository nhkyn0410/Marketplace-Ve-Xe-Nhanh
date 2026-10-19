"use client";

import React from "react";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter
} from "@vexenhanh/ui/components/dialog";
import { Button } from "@vexenhanh/ui/components/button";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Download } from "lucide-react";
import type { TicketLookupResultItem } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupQrModal
 */
export interface LookupQrModalProps {
  readonly ticket: TicketLookupResultItem | null;
  readonly isOpen: boolean;
  readonly onClose: () => void;
}

/**
 * Hộp thoại phóng to mã QR vé xe để hành khách xuất trình khi lên xe
 */
export const LookupQrModal: React.FC<LookupQrModalProps> = ({
  ticket,
  isOpen,
  onClose
}) => {
  if (!ticket) return null;

  return (
    <Dialog open={isOpen} onOpenChange={(open) => !open && onClose()}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <div className="flex items-center justify-between gap-2">
            <DialogTitle className="text-xl font-bold">Mã vé xe lên xe</DialogTitle>
            <Badge tone="success">
              {ticket.statusLabel}
            </Badge>
          </div>
          <DialogDescription className="text-sm text-muted-foreground pt-1">
            Xuất trình mã QR này trực tiếp cho tài xế hoặc nhân viên soát vé tại điểm đón.
          </DialogDescription>
        </DialogHeader>

        <div className="flex flex-col items-center justify-center p-6 bg-slate-50 rounded-2xl border border-dashed border-border gap-4 my-2">
          {/* Mã QR phóng to */}
          <div className="p-4 bg-white rounded-2xl shadow-sm border border-border">
            <svg
              viewBox="0 0 100 100"
              className="w-48 h-48 text-slate-900"
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
              <rect x="34" y="44" width="10" height="6" />
              <rect x="48" y="42" width="6" height="10" />
              <rect x="60" y="46" width="8" height="8" />
              <rect x="76" y="44" width="14" height="6" />
              <rect x="38" y="58" width="12" height="6" />
              <rect x="56" y="56" width="6" height="12" />
              <rect x="68" y="60" width="12" height="6" />
              <rect x="84" y="58" width="8" height="8" />
              <rect x="36" y="72" width="8" height="10" />
              <rect x="48" y="76" width="12" height="6" />
              <rect x="64" y="74" width="6" height="8" />
              <rect x="76" y="78" width="12" height="6" />
              <rect x="42" y="88" width="10" height="6" />
              <rect x="58" y="86" width="14" height="6" />
              <rect x="78" y="88" width="8" height="6" />
            </svg>
          </div>

          {/* Chi tiết vé */}
          <div className="text-center space-y-1">
            <p className="font-mono font-bold text-lg text-foreground tracking-wider">{ticket.ticketCode}</p>
            <p className="text-sm font-medium text-foreground">Hành khách: {ticket.passengerName}</p>
            <p className="text-xs text-muted-foreground">Ghế {ticket.seatCode} · {ticket.seatType}</p>
          </div>
        </div>

        <DialogFooter className="flex-col sm:flex-row gap-2">
          <Button
            type="button"
            variant="outline"
            className="w-full sm:w-auto gap-2"
            onClick={() => window.print()}
          >
            <Download className="w-4 h-4" />
            Tải vé / In
          </Button>
          <Button
            type="button"
            variant="default"
            className="w-full sm:w-auto"
            onClick={onClose}
          >
            Đóng
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  );
};
