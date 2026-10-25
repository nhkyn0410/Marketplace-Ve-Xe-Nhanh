"use client";

import React from "react";
import Link from "next/link";
import { Badge } from "@vexenhanh/ui/components/badge";
import { Button } from "@vexenhanh/ui/components/button";
import {
  MessageSquare,
  UserPlus,
  ArrowRight,
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
  readonly bookingId?: string;
  readonly canManageBooking?: boolean;
  readonly ticketId?: string;
  readonly onPrintOrder?: () => void;
}

/**
 * Cột bên phải: Thanh toán, Thao tác với đơn và Đăng ký tài khoản chuẩn Figma node 1446:15578
 */
export const LookupActionsSidebar: React.FC<LookupActionsSidebarProps> = ({
  payment,
  bookingId,
  canManageBooking,
  ticketId,
  onPrintOrder
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
            <span className="text-xl font-extrabold text-foreground tracking-tight">
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
              <Badge tone={payment.statusLabel === "Đã thanh toán" ? "success" : "neutral"} className="text-[11px] font-semibold py-0">
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
            {canManageBooking ? "Trình duyệt này còn quyền quản lý đơn đã đặt." : "Tra cứu cho phép xem vé. Để hủy vé hoặc gửi hỗ trợ, mở trình duyệt đã đặt vé hoặc đăng nhập tài khoản đặt vé."}
          </p>
        </div>

        <div className="space-y-2">
          {canManageBooking && bookingId && ticketId && <Link href={`/my-tickets/${ticketId}?bookingId=${encodeURIComponent(bookingId)}`} className="block rounded-xl border border-border/80 px-4 py-3 text-xs font-semibold hover:bg-muted/50">Quản lý vé / yêu cầu hoàn tiền</Link>}

          {canManageBooking && bookingId && <Link href={`/support/guest?bookingId=${encodeURIComponent(bookingId)}`} className="block">
            <Button
              type="button"
              variant="outline"
              className="w-full h-10 justify-start gap-2 text-xs font-semibold border-border/80 text-foreground hover:bg-muted/50"
            >
              <MessageSquare className="h-4 w-4 text-muted-foreground" />
              <span>Gửi khiếu nại về đơn này</span>
            </Button>
          </Link>}
          {!canManageBooking && <Link href="/login?next=%2Fmy-tickets" className="block rounded-xl border border-border/80 px-4 py-3 text-xs font-semibold hover:bg-muted/50">Đăng nhập để quản lý vé</Link>}

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
