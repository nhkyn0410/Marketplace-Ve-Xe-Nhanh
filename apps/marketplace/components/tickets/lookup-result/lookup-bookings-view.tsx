"use client";

import React, { useMemo, useState } from "react";
import Link from "next/link";
import { Badge } from "@vexenhanh/ui/components/badge";
import { ChevronRight, UserRound } from "lucide-react";
import { endTicketLookup } from "../../../lib/data/tickets";
import { formatVnd } from "../../../lib/format";
import type { TicketLookupBookingsData } from "../../../lib/data/types";
import { PassengerTopBar } from "../../passenger-topbar";
import { TicketsFilterBar, type TicketTabKey } from "../../my-tickets/tickets-filter-bar";
import { LookupLoginPrompt } from "./lookup-login-prompt";
import { LookupSessionBanner } from "./lookup-session-banner";

/**
 * Thuộc tính của LookupBookingsView
 */
export interface LookupBookingsViewProps {
  readonly data: TicketLookupBookingsData;
  readonly isPreview?: boolean;
}

/**
 * Danh sách đơn của email đã xác minh (tra cứu không nhập mã đặt vé, 12 tháng gần nhất) — SCR-PSG-29 nhiều đơn; chưa có
 * khung Figma riêng nên dùng lại thanh lọc của "Vé của tôi" và banner phiên của màn kết quả.
 */
export const LookupBookingsView: React.FC<LookupBookingsViewProps> = ({ data, isPreview = false }) => {
  const [activeTab, setActiveTab] = useState<TicketTabKey>("all");
  const [searchQuery, setSearchQuery] = useState("");

  const counts = useMemo(() => ({
    upcoming: data.items.filter((item) => item.group === "upcoming").length,
    completed: data.items.filter((item) => item.group === "completed").length,
    cancelled: data.items.filter((item) => item.group === "cancelled").length,
    all: data.items.length
  }), [data.items]);

  const items = useMemo(() => {
    const query = searchQuery.trim().toLowerCase().replace(/-/g, "");
    return data.items.filter((item) =>
      (activeTab === "all" || item.group === activeTab) &&
      (!query || item.bookingCode.toLowerCase().replace(/-/g, "").includes(query) || item.routeName.toLowerCase().includes(query))
    );
  }, [data.items, activeTab, searchQuery]);

  const handleEndSession = async (): Promise<void> => {
    if (!isPreview) await endTicketLookup();
    window.location.href = "/tickets/lookup";
  };

  return (
    <div className="min-h-viewport bg-slate-50/50 pb-16">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé", href: "/tickets/lookup" }, { label: "Đơn của bạn" }]} />

      <div className="mx-auto w-full max-w-[1200px] space-y-6 px-4 pt-6 sm:px-6 lg:px-14">
        <LookupSessionBanner
          maskedEmail={data.maskedEmail}
          summary={`${data.items.length} đơn trong 12 tháng gần nhất`}
          expiresInSeconds={data.expiresInSeconds}
          onEndSession={handleEndSession}
        />

        <div>
          <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">Đơn đặt vé của bạn</h1>
          <p className="mt-1.5 text-sm text-muted-foreground">Các đơn dùng email này làm email liên hệ, mới nhất trước. Chọn một đơn để xem vé và mã QR.</p>
        </div>

        {data.items.length === 0 ? (
          <div className="rounded-2xl border border-border/80 bg-card p-8 text-center shadow-xs">
            <p className="text-base font-semibold text-vxn-ink">Không có đơn nào trong 12 tháng gần nhất</p>
            <p className="mt-1.5 text-sm text-muted-foreground">Đơn cũ hơn hoặc đặt bằng email khác không hiển thị ở đây.</p>
            <Link href="/" className="mt-5 inline-flex h-10 items-center rounded-xl bg-teal-900 px-5 text-sm font-semibold text-white hover:bg-teal-950">
              Đặt vé mới
            </Link>
          </div>
        ) : (
          <div className="space-y-4">
            <TicketsFilterBar activeTab={activeTab} onChangeTab={setActiveTab} searchQuery={searchQuery} onChangeSearch={setSearchQuery} counts={counts} />
            {items.length === 0 && <p className="rounded-xl border bg-white p-5 text-sm text-muted-foreground">Không có đơn phù hợp bộ lọc.</p>}
            {items.map((item) => (
              <Link
                key={item.bookingId}
                href={`/tickets/lookup/result?bookingId=${encodeURIComponent(item.bookingId)}${isPreview ? "&preview=ideal" : ""}`}
                className="group flex flex-col gap-3 rounded-2xl border border-border/80 bg-card p-5 shadow-xs transition hover:border-teal-700/50 hover:shadow-md sm:flex-row sm:items-center sm:justify-between"
              >
                <div className="min-w-0 space-y-1.5">
                  <div className="flex flex-wrap items-center gap-2">
                    <span className="text-base font-semibold text-vxn-ink">Đơn {item.bookingCode}</span>
                    <Badge tone={item.group === "upcoming" ? "success" : "neutral"}>{item.statusLabel}</Badge>
                    {item.bookedWithAccount && (
                      <span className="inline-flex items-center gap-1 rounded-md bg-amber-50 px-2 py-0.5 text-xs font-medium text-amber-800">
                        <UserRound className="size-3" />
                        Đặt bằng tài khoản
                      </span>
                    )}
                  </div>
                  <p className="text-sm text-vxn-ink">{item.routeName}</p>
                  <p className="text-xs text-muted-foreground">{item.departureTimeText} · {item.operatorName} · {item.ticketCountText}</p>
                </div>
                <div className="flex shrink-0 items-center justify-between gap-4 sm:justify-end">
                  <span className="text-base font-bold text-vxn-ink">{formatVnd(item.totalVnd)}</span>
                  <span className="inline-flex items-center gap-1 text-sm font-semibold text-teal-800 group-hover:underline">
                    Xem vé
                    <ChevronRight className="size-4" />
                  </span>
                </div>
              </Link>
            ))}
          </div>
        )}
      </div>

      {data.accountSuggested && <LookupLoginPrompt maskedEmail={data.maskedEmail} hasAccount={data.hasAccount} />}
    </div>
  );
};
