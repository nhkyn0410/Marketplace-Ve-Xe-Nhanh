"use client";

import React from "react";
import Image from "next/image";
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
            {ticket.qrCodeDataUrl ? <Image src={ticket.qrCodeDataUrl} alt={`Mã QR vé ${ticket.ticketCode}`} width={240} height={240} unoptimized /> : <p>Mã QR chưa khả dụng</p>}
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
