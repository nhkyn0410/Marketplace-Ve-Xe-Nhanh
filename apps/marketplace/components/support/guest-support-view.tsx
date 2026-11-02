"use client";

import React, { useState } from "react";
import { Button } from "@vexenhanh/ui/components/button";
import type { GuestSupportData } from "../../lib/data/types";
import { LookupSessionBanner } from "../tickets/lookup-result/lookup-session-banner";
import { ComplaintListSidebar } from "./complaint-list-sidebar";
import { ComplaintDetailPanel } from "./complaint-detail-panel";
import { ComplaintNewModal } from "./complaint-new-modal";
import { PassengerTopBar } from "../passenger-topbar";

/**
 * Thuộc tính của GuestSupportView
 */
export interface GuestSupportViewProps {
  readonly data: GuestSupportData;
  readonly initialOpenNewModal?: boolean;
}

/**
 * Màn hình Khiếu nại của khách vãng lai chuẩn Figma node 1446:16579 (SCR-PSG-32)
 */
export const GuestSupportView: React.FC<GuestSupportViewProps> = ({
  data,
  initialOpenNewModal = false
}) => {
  const [selectedId, setSelectedId] = useState<string>(
    data.complaints.selectedComplaint.id
  );
  const [isModalOpen, setIsModalOpen] = useState<boolean>(initialOpenNewModal);

  const handleEndSession = () => {
    window.location.href = "/tickets/lookup";
  };

  return (
    <div className="min-h-viewport bg-slate-50/50 pb-16">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Tra cứu vé", href: "/tickets/lookup" }, { label: data.session.bookingCode, href: "/tickets/lookup/result" }, { label: "Khiếu nại" }]} />

      <div className="mx-auto w-full max-w-[1200px] px-4 pt-6 sm:px-6 lg:px-14">
        <div className="mb-6">
          <LookupSessionBanner
          maskedEmail={data.session.maskedEmail}
          bookingCode={data.session.bookingCode}
          expiresInSeconds={data.session.expiresInSeconds}
          onEndSession={handleEndSession}
        />
        </div>

        {/* Tiêu đề trang & Nút Gửi khiếu nại về đơn này */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-border/80">
          <div>
            <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
              Khiếu nại và hỗ trợ
            </h1>
            <p className="text-sm text-muted-foreground mt-1">
              Khách vãng lai chỉ xem và gửi khiếu nại cho đơn đã xác minh. Phản hồi cũng được gửi tới email liên hệ của đơn.
            </p>
          </div>

          <Button
            type="button"
            onClick={() => setIsModalOpen(true)}
            className="text-xs font-bold bg-teal-900 hover:bg-teal-950 text-white rounded-xl shadow-xs self-start sm:self-auto px-5 h-10"
          >
            Gửi khiếu nại về đơn này
          </Button>
        </div>

        {/* Layout 2 cột: Cột trái (Danh sách) và Cột phải (Chi tiết) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 mt-6 items-start">
          {/* Cột trái: 4 cột */}
          <div className="lg:col-span-4">
            <ComplaintListSidebar
              activeComplaints={data.complaints.activeComplaints}
              closedComplaints={data.complaints.closedComplaints}
              selectedId={selectedId}
              onSelectComplaint={(id) => setSelectedId(id)}
            />
          </div>

          {/* Cột phải: 8 cột */}
          <div className="lg:col-span-8">
            <ComplaintDetailPanel complaint={data.complaints.selectedComplaint} />
          </div>
        </div>
      </div>

      {/* Hộp thoại gửi khiếu nại */}
      <ComplaintNewModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        bookingOptions={[
          {
            bookingCode: data.session.bookingCode,
            label: `${data.session.bookingCode} · TP. Hồ Chí Minh → Đà Lạt · 16/10/2026`
          }
        ]}
      />
    </div>
  );
};
