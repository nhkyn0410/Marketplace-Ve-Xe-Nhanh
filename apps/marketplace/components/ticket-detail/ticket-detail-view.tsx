"use client";

import React, { useState } from "react";
import { TicketDetailHeader } from "./ticket-detail-header";
import { BoardingPassCard } from "./boarding-pass-card";
import { TicketTripItinerary } from "./ticket-trip-itinerary";
import { TicketPickupMap } from "./ticket-pickup-map";
import { TicketBoardingRules } from "./ticket-boarding-rules";
import { TicketPaymentSidebar } from "./ticket-payment-sidebar";
import { TicketCancelDialog } from "./ticket-cancel-dialog";
import type { TicketDetailData } from "../../lib/data/types";

/**
 * Thuộc tính của TicketDetailView
 */
export interface TicketDetailViewProps {
  readonly ticketDetail: TicketDetailData;
  readonly defaultOpenCancelDialog?: boolean;
}

/**
 * Giao diện chi tiết vé (SCR-PSG-25) & Hộp thoại hủy vé (SCR-PSG-26)
 */
export const TicketDetailView: React.FC<TicketDetailViewProps> = ({
  ticketDetail,
  defaultOpenCancelDialog = false
}) => {
  const [activeTicketIndex, setActiveTicketIndex] = useState(0);
  const [isCancelDialogOpen, setIsCancelDialogOpen] = useState(defaultOpenCancelDialog);

  // Xử lý in vé
  const handlePrint = (): void => {
    window.print();
  };

  // Xử lý chia sẻ thông tin vé
  const handleShare = async (): Promise<void> => {
    if (typeof navigator !== "undefined" && navigator.clipboard) {
      try {
        await navigator.clipboard.writeText(window.location.href);
        alert("Đã sao chép liên kết vé vào bộ nhớ tạm!");
      } catch {
        // Bỏ qua lỗi sao chép
      }
    }
  };

  return (
    <div className="container mx-auto px-4 sm:px-6 py-6 sm:py-8 max-w-6xl space-y-6">
      {/* Tiêu đề & thanh hành động */}
      <TicketDetailHeader
        bookingCode={ticketDetail.bookingCode}
        bookingTimeText={ticketDetail.bookingTimeText}
        statusLabel={ticketDetail.statusLabel}
        onOpenCancelDialog={() => setIsCancelDialogOpen(true)}
        onPrint={handlePrint}
        onShare={handleShare}
      />

      {/* Boarding Pass thẻ vé xe */}
      <BoardingPassCard
        trip={ticketDetail.trip}
        tickets={ticketDetail.tickets}
        activeTicketIndex={activeTicketIndex}
        bookingCode={ticketDetail.bookingCode}
        onSelectTicket={setActiveTicketIndex}
      />

      {/* Lưới nội dung 2 cột: Cột trái (Hành trình, bản đồ, quy định), Cột phải (Thanh toán, chính sách, hỗ trợ) */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">
        {/* Cột trái: 7 cột */}
        <div className="lg:col-span-7 space-y-6">
          <TicketTripItinerary trip={ticketDetail.trip} />
          <TicketPickupMap
            pointName={ticketDetail.trip.departurePointName}
            address={ticketDetail.trip.departureAddress}
          />
          <TicketBoardingRules rules={ticketDetail.boardingRules} />
        </div>

        {/* Cột phải: 5 cột */}
        <div className="lg:col-span-5">
          <TicketPaymentSidebar
            payment={ticketDetail.payment}
            refundPolicy={ticketDetail.refundPolicy}
            operatorHotline={ticketDetail.trip.operatorHotline}
          />
        </div>
      </div>

      {/* Hộp thoại hủy vé SCR-PSG-26 */}
      <TicketCancelDialog
        isOpen={isCancelDialogOpen}
        onClose={() => setIsCancelDialogOpen(false)}
        bookingCode={ticketDetail.bookingCode}
        trip={ticketDetail.trip}
        tickets={ticketDetail.tickets}
      />
    </div>
  );
};
