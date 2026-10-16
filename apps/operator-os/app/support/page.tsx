import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Hỗ trợ" };

/** Hỗ trợ (Figma 01…04 · Hỗ trợ) — khung giao diện, chưa có dữ liệu: chờ đặt vé, khiếu nại / đánh giá và ứng dụng Nhân viên (TASK-TRUST-001, TASK-EMP-002). */
export default function SupportPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Hỗ trợ" description="Khiếu nại, tranh chấp và đánh giá liên quan tới chuyến của nhà xe; sự cố và nhật trình do nhân viên gửi về." />
      <PlannedScreen
        tabs={[
          {
            label: "Khiếu nại",
            columns: ["Mã", "Vụ việc", "Đơn liên quan", "Trạng thái", "Cập nhật"],
            empty: "Khiếu nại của hành khách về chuyến của nhà xe hiện ở đây."
          },
          {
            label: "Tranh chấp",
            columns: ["Mã", "Vụ việc", "Số tiền liên quan", "Hạn phản hồi", "Trạng thái"],
            empty: "Tranh chấp Vé Xe Nhanh yêu cầu nhà xe giải trình hiện ở đây."
          },
          {
            label: "Đánh giá",
            columns: ["Hành khách", "Chuyến", "Điểm", "Nội dung", "Phản hồi của nhà xe"],
            empty: "Đánh giá từ hành khách có vé hợp lệ trên chuyến đã hoàn thành hiện ở đây."
          },
          {
            label: "Sự cố và nhật trình",
            columns: ["Thời điểm", "Chuyến", "Loại", "Nội dung", "Người gửi", "Mức ưu tiên"],
            empty: "Sự cố và nhật trình tài xế gửi từ ứng dụng Nhân viên hiện ở đây."
          }
        ]}
        dependency="đặt vé, khiếu nại / đánh giá và ứng dụng Nhân viên (TASK-TRUST-001, TASK-EMP-002)"
      />
    </div>
  );
}
