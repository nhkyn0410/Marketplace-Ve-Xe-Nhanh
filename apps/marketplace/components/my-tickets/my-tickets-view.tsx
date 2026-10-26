"use client";

import { useState, useMemo } from "react";
import { MyTicketsData, MyTicketItem } from "../../lib/data/types";
import { TicketsHeader } from "./tickets-header";
import { TicketsFilterBar, TicketTabKey } from "./tickets-filter-bar";
import { TicketsFeaturedCard } from "./tickets-featured-card";
import { TicketCardItem } from "./ticket-card-item";
import { TicketsEmptyCard } from "./tickets-empty-card";
import { GuestLookupBanner } from "./guest-lookup-banner";

export interface MyTicketsViewProps {
  readonly initialData: MyTicketsData;
  readonly onCancelTicket?: (ticket: MyTicketItem) => void;
}

/**
 * Client component hiển thị trang Hành trình của tôi (SCR-PSG-24).
 */
export function MyTicketsView({ initialData, onCancelTicket }: MyTicketsViewProps) {
  const [activeTab, setActiveTab] = useState<TicketTabKey>("upcoming");
  const [searchQuery, setSearchQuery] = useState("");

  const filteredTickets = useMemo(() => {
    let list = initialData.tickets;

    // Lọc theo tab
    if (activeTab === "upcoming") {
      list = list.filter((t) => t.status === "valid" || t.status === "pending_payment");
    } else if (activeTab === "completed") {
      list = list.filter((t) => t.status === "completed");
    } else if (activeTab === "cancelled") {
      list = list.filter((t) => t.status === "cancelled");
    }

    // Lọc theo tìm kiếm
    if (searchQuery.trim()) {
      const q = searchQuery.toLowerCase().trim();
      list = list.filter(
        (t) =>
          t.bookingCode.toLowerCase().includes(q) ||
          t.routeName.toLowerCase().includes(q) ||
          t.operatorName.toLowerCase().includes(q)
      );
    }

    return list;
  }, [initialData.tickets, activeTab, searchQuery]);

  const isEmpty = filteredTickets.length === 0;

  return (
    <div className="mx-auto w-full max-w-[1200px] px-4 sm:px-6 lg:px-14 py-8 space-y-6">
      {/* Tiêu đề & nút Đặt vé mới */}
      <TicketsHeader />

      {/* Thanh tab và ô tìm kiếm */}
      <TicketsFilterBar
        activeTab={activeTab}
        onChangeTab={setActiveTab}
        searchQuery={searchQuery}
        onChangeSearch={setSearchQuery}
        counts={initialData.counts}
      />

      {/* Thẻ Chuyến gần nhất (chỉ hiện khi ở tab Sắp tới và có dữ liệu chuyến nổi bật) */}
      {activeTab === "upcoming" && initialData.featuredTrip && !isEmpty && !searchQuery && (
        <TicketsFeaturedCard featured={initialData.featuredTrip} />
      )}

      {/* Danh sách vé hoặc Trạng thái rỗng */}
      {isEmpty ? (
        <TicketsEmptyCard />
      ) : (
        <div className="space-y-4">
          {filteredTickets.map((ticket) => (
            <TicketCardItem
              key={ticket.id}
              ticket={ticket}
              onCancelClick={onCancelTicket}
            />
          ))}
        </div>
      )}

      {/* Banner tra cứu vé cho khách chưa đăng nhập */}
      <GuestLookupBanner />
    </div>
  );
}
