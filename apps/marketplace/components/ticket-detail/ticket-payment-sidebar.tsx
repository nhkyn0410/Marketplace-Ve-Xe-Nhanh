import React from "react";
import Link from "next/link";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import { Info, Phone, MessageSquare } from "lucide-react";
import { formatVnd } from "../../lib/format";
import type {
  TicketPaymentDetail,
  TicketRefundPolicy,
  TicketRefundPolicyMilestone
} from "../../lib/data/types";

/**
 * Thuộc tính của TicketPaymentSidebar
 */
export interface TicketPaymentSidebarProps {
  readonly payment: TicketPaymentDetail;
  readonly refundPolicy: TicketRefundPolicy;
  readonly operatorHotline: string;
  readonly supportHref?: string;
}

/**
 * Cột bên phải hiển thị chi tiết thanh toán, chính sách hủy hoàn vé và hỗ trợ chuẩn Figma 1445:14456
 */
export const TicketPaymentSidebar: React.FC<TicketPaymentSidebarProps> = ({
  payment,
  refundPolicy,
  operatorHotline,
  supportHref = "/support"
}) => {
  return (
    <div className="space-y-5">
      {/* Khối 1: Thanh toán */}
      <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-4">
        <h3 className="text-base font-bold text-foreground">
          Thanh toán
        </h3>

        <div className="space-y-3">
          <div className="space-y-2 text-xs">
            <div className="flex items-center justify-between text-muted-foreground">
              <span>Giá vé ({payment.ticketCount} chỗ)</span>
              <span className="font-semibold text-foreground">{formatVnd(payment.ticketPriceTotalVnd)}</span>
            </div>

            <div className="flex items-center justify-between text-muted-foreground">
              <span>Phí dịch vụ</span>
              <span className="font-semibold text-foreground">{formatVnd(payment.serviceFeeVnd)}</span>
            </div>

            {payment.discountVnd !== "0" && (
              <div className="flex items-center justify-between text-emerald-600 dark:text-emerald-400">
                <span>Ưu đãi</span>
                <span className="font-semibold">-{formatVnd(payment.discountVnd)}</span>
              </div>
            )}
          </div>

          <div className="pt-3 border-t border-border/50 flex items-center justify-between">
            <span className="text-xs font-bold text-foreground">Đã thanh toán</span>
            <span className="text-xl font-black text-foreground tracking-tight">
              {formatVnd(payment.paidTotalVnd)}
            </span>
          </div>

          <div className="pt-3 border-t border-border/50 space-y-2 text-xs text-muted-foreground">
            <div className="flex items-center justify-between">
              <span>Phương thức</span>
              <span className="font-medium text-foreground">{payment.methodLabel}</span>
            </div>

            <div className="flex items-center justify-between">
              <span>Mã giao dịch</span>
              <span className="font-mono text-foreground">{payment.gatewayTxnId}</span>
            </div>

            <div className="flex items-center justify-between">
              <span>Trạng thái</span>
              <Badge tone={payment.statusLabel === "Đã thanh toán" ? "success" : "neutral"} className="text-[11px] font-semibold py-0">
                {payment.statusLabel}
              </Badge>
            </div>
          </div>
        </div>
      </div>

      {/* Khối 2: Chính sách hủy / hoàn tiền */}
      <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-3.5">
        <div>
          <h3 className="text-base font-bold text-foreground">
            Chính sách hủy / hoàn tiền
          </h3>
          <p className="text-[11px] text-muted-foreground mt-0.5">
            {refundPolicy.savedAtText}
          </p>
        </div>

        {/* Các mốc thời gian hoàn tiền */}
        <div className="space-y-2 text-xs">
          {refundPolicy.milestones.map((milestone: TicketRefundPolicyMilestone, idx: number) => (
            <div
              key={idx}
              className="flex items-center justify-between py-1 border-b border-border/40 last:border-0"
            >
              <span className="text-muted-foreground">{milestone.timeframeText}</span>
              <span
                className={`font-semibold ${
                  milestone.refundPercent > 0
                    ? "text-foreground"
                    : "text-muted-foreground"
                }`}
              >
                {milestone.refundRateText}
              </span>
            </div>
          ))}
        </div>

        {/* Thông báo tỷ lệ hoàn tiền hiện tại */}
        <div className="p-3 rounded-xl bg-amber-500/10 border border-amber-500/20 text-xs font-medium text-amber-950 dark:text-amber-200 flex items-start gap-2">
          <Info className="h-4 w-4 shrink-0 text-amber-600 dark:text-amber-400 mt-0.5" />
          <div className="leading-relaxed">
            {refundPolicy.currentRefundNote}
          </div>
        </div>
      </div>

      {/* Khối 3: Cần hỗ trợ? */}
      <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-3.5">
        <h3 className="text-base font-bold text-foreground">
          Cần hỗ trợ?
        </h3>

        <div className="space-y-2 text-xs">
          {operatorHotline && <div className="flex items-center gap-2 text-muted-foreground">
            <Phone className="h-3.5 w-3.5 text-muted-foreground shrink-0" />
            <span>Nhà xe · </span>
            <a href={`tel:${operatorHotline.replace(/\s+/g, "")}`} className="font-semibold text-foreground hover:underline">
              {operatorHotline}
            </a>
          </div>}
        </div>

        <Link href={supportHref} className="block pt-1">
          <Button
            type="button"
            variant="outline"
            className="w-full h-9 text-xs font-semibold gap-2 border-border/80"
          >
            <MessageSquare className="h-3.5 w-3.5" />
            <span>Gửi khiếu nại về đơn này</span>
          </Button>
        </Link>
      </div>
    </div>
  );
};
