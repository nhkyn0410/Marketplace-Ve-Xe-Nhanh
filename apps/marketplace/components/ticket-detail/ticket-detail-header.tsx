import React from "react";
import Link from "next/link";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Printer, Share2, AlertCircle, ChevronRight } from "lucide-react";

/**
 * Thuộc tính của TicketDetailHeader
 */
export interface TicketDetailHeaderProps {
  readonly bookingCode: string;
  readonly bookingTimeText: string;
  readonly statusLabel: string;
  readonly onOpenCancelDialog: () => void;
  readonly onPrint: () => void;
  readonly onShare: () => void;
}

/**
 * Tiêu đề trang chi tiết vé cùng các nút hành động (In vé, Chia sẻ, Hủy vé) chuẩn theo Figma 1445:14456
 */
export const TicketDetailHeader: React.FC<TicketDetailHeaderProps> = ({
  bookingCode,
  bookingTimeText,
  statusLabel,
  onOpenCancelDialog,
  onPrint,
  onShare
}) => {
  return (
    <div className="space-y-3">
      {/* Breadcrumb điều hướng */}
      <nav aria-label="Breadcrumb" className="flex items-center gap-1.5 text-xs text-muted-foreground">
        <Link href="/" className="hover:text-foreground transition-colors">
          Trang chủ
        </Link>
        <ChevronRight className="h-3 w-3 text-muted-foreground/60" />
        <Link href="/my-tickets" className="hover:text-foreground transition-colors">
          Hành trình
        </Link>
        <ChevronRight className="h-3 w-3 text-muted-foreground/60" />
        <span className="font-medium text-foreground">{bookingCode}</span>
      </nav>

      {/* Tiêu đề chính và các nút hành động */}
      <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between pb-1">
        <div>
          <div className="flex flex-wrap items-center gap-2.5">
            <h1 className="text-2xl font-bold tracking-tight text-foreground sm:text-3xl">
              Đơn {bookingCode}
            </h1>
            <Badge className="bg-emerald-500/15 text-emerald-800 dark:text-emerald-300 hover:bg-emerald-500/20 border-emerald-500/30 font-semibold px-2.5 py-0.5 text-xs">
              {statusLabel}
            </Badge>
          </div>
          <p className="mt-1 text-xs text-muted-foreground">{bookingTimeText}</p>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={onPrint}
            className="h-8 gap-1.5 text-xs font-medium"
          >
            <Printer className="h-3.5 w-3.5" />
            <span>In vé</span>
          </Button>

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={onShare}
            className="h-8 gap-1.5 text-xs font-medium"
          >
            <Share2 className="h-3.5 w-3.5" />
            <span>Chia sẻ</span>
          </Button>

          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={onOpenCancelDialog}
            className="h-8 gap-1.5 text-xs font-medium text-rose-600 border-rose-200 dark:border-rose-900/60 hover:bg-rose-50 dark:hover:bg-rose-950/20"
          >
            <AlertCircle className="h-3.5 w-3.5" />
            <span>Hủy vé</span>
          </Button>
        </div>
      </div>
    </div>
  );
};
