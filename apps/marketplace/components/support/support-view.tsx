"use client";

import React, { useState } from "react";
import Link from "next/link";
import { Button } from "@vexenhanh/ui/components/button";
import type { MyComplaintsData, NewComplaintPayload } from "../../lib/data/types";
import { ComplaintListSidebar } from "./complaint-list-sidebar";
import { ComplaintDetailPanel } from "./complaint-detail-panel";
import { ComplaintNewModal } from "./complaint-new-modal";

/**
 * Thuộc tính của SupportView
 */
export interface SupportViewProps {
  readonly data: MyComplaintsData;
  readonly initialOpenNewModal?: boolean;
  readonly defaultDraft?: NewComplaintPayload;
}

/**
 * Màn hình Khiếu nại và hỗ trợ chuẩn Figma node 1446:16033 & node 1446:16390
 */
export const SupportView: React.FC<SupportViewProps> = ({
  data,
  initialOpenNewModal = false,
  defaultDraft
}) => {
  const [selectedId, setSelectedId] = useState<string>(data.selectedComplaint.id);
  const [isModalOpen, setIsModalOpen] = useState<boolean>(initialOpenNewModal);

  // Tìm chi tiết khiếu nại đang chọn (nếu có trong dữ liệu)
  const currentDetail =
    data.selectedComplaint.id === selectedId
      ? data.selectedComplaint
      : {
          ...data.selectedComplaint,
          id: selectedId,
          code: selectedId === "kn-02" ? "KN-20260928-007" : data.selectedComplaint.code,
          title:
            selectedId === "kn-02"
              ? "Chưa nhận được tiền hoàn sau khi hủy vé"
              : data.selectedComplaint.title
        };

  return (
    <div className="min-h-screen bg-slate-50/50 pb-16">
      <div className="max-w-6xl mx-auto px-4 sm:px-6 pt-6">
        {/* Breadcrumb theo Figma */}
        <nav className="flex items-center gap-2 text-xs text-muted-foreground mb-4">
          <Link href="/" className="hover:text-foreground transition-colors">
            Trang chủ
          </Link>
          <span>›</span>
          <span className="font-semibold text-foreground">Khiếu nại</span>
        </nav>

        {/* Tiêu đề trang & Nút Gửi khiếu nại mới */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-border/80">
          <div>
            <h1 className="text-2xl sm:text-3xl font-bold tracking-tight text-foreground">
              Khiếu nại và hỗ trợ
            </h1>
            <p className="text-sm text-muted-foreground mt-1">
              Theo dõi yêu cầu hỗ trợ và khiếu nại gắn với vé, chuyến, thanh toán hoặc hoàn tiền.
            </p>
          </div>

          <Button
            type="button"
            onClick={() => setIsModalOpen(true)}
            className="text-xs font-bold bg-teal-900 hover:bg-teal-950 text-white rounded-xl shadow-xs self-start sm:self-auto px-5 h-10"
          >
            Gửi khiếu nại
          </Button>
        </div>

        {/* Layout 2 cột: Cột trái (Danh sách) và Cột phải (Chi tiết) */}
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-8 mt-6 items-start">
          {/* Cột trái: 4 cột */}
          <div className="lg:col-span-4">
            <ComplaintListSidebar
              activeComplaints={data.activeComplaints}
              closedComplaints={data.closedComplaints}
              selectedId={selectedId}
              onSelectComplaint={(id) => setSelectedId(id)}
            />
          </div>

          {/* Cột phải: 8 cột */}
          <div className="lg:col-span-8">
            <ComplaintDetailPanel complaint={currentDetail} />
          </div>
        </div>
      </div>

      {/* Hộp thoại gửi khiếu nại mới (SCR-PSG-31) */}
      <ComplaintNewModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        defaultDraft={defaultDraft}
      />
    </div>
  );
};
