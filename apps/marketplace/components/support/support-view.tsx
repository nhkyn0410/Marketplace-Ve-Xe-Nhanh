"use client";

import React, { useState } from "react";
import { useRouter } from "next/navigation";
import { Button } from "@vexenhanh/ui/components/button";
import type { NewComplaintPayload } from "../../lib/data/types";
import type { SupportData, SupportDetailData } from "../../lib/data/support-mappers";
import { getComplaintDetail } from "../../lib/data/support";
import { ComplaintListSidebar } from "./complaint-list-sidebar";
import { ComplaintDetailPanel } from "./complaint-detail-panel";
import { ComplaintNewModal } from "./complaint-new-modal";
import { PassengerTopBar } from "../passenger-topbar";

/**
 * Thuộc tính của SupportView
 */
export interface SupportViewProps {
  readonly data: SupportData;
  readonly guestBookingId?: string;
  readonly initialOpenNewModal?: boolean;
  readonly defaultDraft?: NewComplaintPayload;
}

/**
 * Màn hình Khiếu nại và hỗ trợ chuẩn Figma node 1446:16033 & node 1446:16390
 */
export const SupportView: React.FC<SupportViewProps> = ({
  data,
  initialOpenNewModal = false,
  defaultDraft,
  guestBookingId
}) => {
  const router = useRouter();
  const [currentDetail, setCurrentDetail] = useState<SupportDetailData | null>(data.selectedComplaint);
  const [detailError, setDetailError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const selectedId = currentDetail?.id ?? "";
  const [isModalOpen, setIsModalOpen] = useState<boolean>(initialOpenNewModal);

  return (
    <div className="min-h-viewport bg-slate-50/50 pb-16">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Khiếu nại" }]} />
      <div className="mx-auto w-full max-w-[1200px] px-4 pt-6 sm:px-6 lg:px-14">

        {/* Tiêu đề trang & Nút Gửi khiếu nại mới */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-border/80">
          <div>
            <h1 className="text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
              Khiếu nại và hỗ trợ
            </h1>
            <p className="text-sm text-muted-foreground mt-1">
              {guestBookingId ? "Bạn đang dùng quyền truy cập đơn được lưu trên trình duyệt đã đặt vé để xem và gửi hỗ trợ." : "Theo dõi yêu cầu hỗ trợ và khiếu nại gắn với vé, chuyến, thanh toán hoặc hoàn tiền."}
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
              onSelectComplaint={async (id) => {
                if (isLoading) return;
                setIsLoading(true); setDetailError(null);
                try {
                  const result = await getComplaintDetail(id, guestBookingId);
                  if (result.status === "ok") setCurrentDetail(result.data);
                  else setDetailError(result.status === "error" ? result.message ?? "Không thể tải yêu cầu." : "Yêu cầu chưa khả dụng.");
                } catch { setDetailError("Không thể tải yêu cầu. Vui lòng thử lại."); }
                finally { setIsLoading(false); }
              }}
            />
          </div>

          {/* Cột phải: 8 cột */}
          <div className="lg:col-span-8">
            {isLoading && <p role="status" className="mb-3 text-sm">Đang tải yêu cầu…</p>}
            {detailError && <p role="alert" className="mb-3 text-sm text-rose-700">{detailError}</p>}
            {currentDetail ? <ComplaintDetailPanel key={currentDetail.id} complaint={currentDetail} guestBookingId={guestBookingId} onUpdated={setCurrentDetail} /> :
              <div className="rounded-2xl border bg-white p-6 text-sm">Bạn chưa có yêu cầu hỗ trợ. Bấm “Gửi khiếu nại” để tạo yêu cầu gắn với đơn vé.</div>}
          </div>
        </div>
      </div>

      {/* Hộp thoại gửi khiếu nại mới (SCR-PSG-31) */}
      <ComplaintNewModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        defaultDraft={defaultDraft}
        guestBookingId={guestBookingId}
        onSubmitted={async (id) => {
          const result = await getComplaintDetail(id, guestBookingId);
          if (result.status === "ok") setCurrentDetail(result.data);
          router.refresh();
        }}
      />
    </div>
  );
};
