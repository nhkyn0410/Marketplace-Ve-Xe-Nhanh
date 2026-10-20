"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  XCircle,
  MessageSquare,
  Mail,
  UserPlus,
  ArrowRight,
  AlertCircle,
  CheckCircle2,
  Printer
} from "lucide-react";
import { formatVnd } from "../../../lib/format";
import type { TicketLookupResultData } from "../../../lib/data/types";

/**
 * Thuộc tính của LookupActionsSidebar
 */
export interface LookupActionsSidebarProps {
  readonly payment: TicketLookupResultData["payment"];
  readonly bookingCode: string;
  readonly onCancelOrder?: () => void;
  readonly onComplaintOrder?: () => void;
  readonly onResendEmail?: () => void;
  readonly onPrintOrder?: () => void;
}

/**
 * Cột bên phải: Thanh toán, Thao tác với đơn và Đăng ký tài khoản chuẩn Figma node 1446:15578
 */
export const LookupActionsSidebar: React.FC<LookupActionsSidebarProps> = ({
  payment,
  bookingCode,
  onCancelOrder,
  onComplaintOrder,
  onResendEmail,
  onPrintOrder
}) => {
  const [actionNotice, setActionNotice] = useState<string | null>(null);

  const handleAction = (type: "cancel" | "complaint" | "resend"): void => {
    if (type === "cancel") {
      console.warn(`[marketplace] chưa có API: POST /guest/ticket-lookup/${bookingCode}/cancel`);
      setActionNotice("Chức năng hủy vé trực tuyến tạm thời chưa khả dụng. Quý khách vui lòng gọi CSKH 1900 6067 để được hỗ trợ.");
      onCancelOrder?.();
    } else if (type === "complaint") {
      console.warn(`[marketplace] chưa có API: POST /guest/complaints for ${bookingCode}`);
      onComplaintOrder?.();
    } else {
      console.warn(`[marketplace] chưa có API: POST /guest/ticket-lookup/${bookingCode}/resend-email`);
      setActionNotice("Đã ghi nhận yêu cầu gửi lại email vé. Chức năng đang được tích hợp dịch vụ gửi thư.");
      onResendEmail?.();
    }
  };

  return (
    <div className="space-y-5">
      {/* Thông báo thao tác nếu có */}
      {actionNotice && (
        <div className="p-3.5 rounded-xl bg-amber-500/10 border border-amber-500/30 flex items-start gap-2 text-xs text-amber-950 dark:text-amber-200 animate-in fade-in">
          <AlertCircle className="h-4 w-4 shrink-0 text-amber-600 dark:text-amber-400 mt-0.5" />
          <div className="leading-relaxed font-medium">{actionNotice}</div>
        </div>
      )}

      {/* Khối 1: Thanh toán */}
      <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-4">
        <h3 className="text-base font-bold text-foreground">
          Thanh toán
        </h3>

        <div className="space-y-3">
          <div className="space-y-2 text-xs">
            <div className="flex items-center justify-between text-muted-foreground">
              <span>Giá vé ({payment.seatCount} chỗ)</span>
              <span className="font-semibold text-foreground">{formatVnd(payment.ticketPriceTotalVnd)}</span>
            </div>

            <div className="flex items-center justify-between text-muted-foreground">
              <span>Phí dịch vụ</span>
              <span className="font-semibold text-foreground">{formatVnd(payment.serviceFeeVnd)}</span>
            </div>
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
              <span>Trạng thái</span>
              <Badge className="bg-emerald-500/15 text-emerald-800 dark:text-emerald-300 border-emerald-500/30 text-[11px] font-semibold py-0 flex items-center gap-1">
                <CheckCircle2 className="h-3 w-3" />
                <span>{payment.statusLabel}</span>
              </Badge>
            </div>
          </div>
        </div>
      </div>

      {/* Khối 2: Thao tác với đơn */}
      <div className="rounded-2xl border border-border/80 bg-card p-5 sm:p-6 shadow-xs space-y-3.5">
        <div>
          <h3 className="text-base font-bold text-foreground">
            Thao tác với đơn
          </h3>
          <p className="text-[11px] text-muted-foreground mt-0.5">
            Hủy vé và gửi khiếu nại cần xác minh lại bằng OTP.
          </p>
        </div>

        <div className="space-y-2">
          <Button
            type="button"
            variant="outline"
            onClick={() => handleAction("cancel")}
            className="w-full h-10 justify-start gap-2 text-xs font-semibold border-border/80 text-foreground hover:bg-muted/50"
          >
            <XCircle className="h-4 w-4 text-muted-foreground" />
            <span>Hủy vé / yêu cầu hoàn tiền</span>
          </Button>

          <Link href={`/support/guest?bookingCode=${bookingCode}`} className="block">
            <Button
              type="button"
              variant="outline"
              className="w-full h-10 justify-start gap-2 text-xs font-semibold border-border/80 text-foreground hover:bg-muted/50"
            >
              <MessageSquare className="h-4 w-4 text-muted-foreground" />
              <span>Gửi khiếu nại về đơn này</span>
            </Button>
          </Link>

          <Button
            type="button"
            variant="outline"
            onClick={() => handleAction("resend")}
            className="w-full h-10 justify-start gap-2 text-xs font-semibold border-border/80 text-foreground hover:bg-muted/50"
          >
            <Mail className="h-4 w-4 text-muted-foreground" />
            <span>Gửi lại vé qua email</span>
          </Button>

          {onPrintOrder && (
            <Button
              type="button"
              variant="outline"
              onClick={onPrintOrder}
              className="w-full h-10 justify-start gap-2 text-xs font-semibold border-border/80 text-foreground hover:bg-muted/50"
            >
              <Printer className="h-4 w-4 text-muted-foreground" />
              <span>In thông tin đơn vé</span>
            </Button>
          )}
        </div>
      </div>

      {/* Khối 3: Tạo tài khoản Vé Xe Nhanh */}
      <div className="rounded-2xl border border-amber-300/80 bg-amber-50/50 dark:bg-amber-950/20 p-5 sm:p-6 shadow-xs space-y-3">
        <div className="flex items-center gap-2 text-amber-950 dark:text-amber-200">
          <UserPlus className="h-4 w-4 text-amber-700 dark:text-amber-400 shrink-0" />
          <h4 className="font-bold text-sm">
            Tạo tài khoản Vé Xe Nhanh
          </h4>
        </div>

        <p className="text-xs text-muted-foreground leading-relaxed">
          Lưu lịch sử vé, hành khách thường đi và tích điểm VXN Plus cho các chuyến đặt sau khi đăng nhập.
        </p>

        <Link href="/register" className="block pt-1">
          <Button
            type="button"
            variant="outline"
            className="h-9 gap-1.5 text-xs font-bold border-amber-400/80 bg-background hover:bg-amber-100/50 dark:hover:bg-amber-900/40 text-amber-950 dark:text-amber-200"
          >
            <span>Tạo tài khoản</span>
            <ArrowRight className="h-3.5 w-3.5" />
          </Button>
        </Link>
      </div>
    </div>
  );
};
