import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Báo cáo" };

/** Báo cáo (Figma ADM-14a) — khung giao diện, chưa có dữ liệu: chờ đặt vé, thanh toán và báo cáo (TASK-RPT-002). */
export default function ReportsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Báo cáo" description="Số liệu toàn hệ thống. Số liệu đang đối soát được đánh dấu “tạm tính”." />
      <PlannedScreen
        stats={[
          { label: "Giá trị giao dịch", hint: "Đơn · vé" },
          { label: "Doanh thu sau hoàn tiền", hint: "Tạm tính khi còn đối soát" },
          { label: "Tỷ lệ lấp đầy", hint: "Chuyến đã chạy" },
          { label: "Chuyến bị nhà xe hủy", hint: "Tỷ lệ" }
        ]}
        tabs={[
          {
            label: "Theo nhà xe",
            columns: ["Nhà xe", "Chuyến", "Vé", "Lấp đầy", "Giá trị giao dịch", "Hoàn tiền", "Đánh giá"],
            empty: "Số liệu theo nhà xe hiện ở đây khi có đơn đặt vé."
          },
          {
            label: "Yêu cầu xuất báo cáo",
            columns: ["Báo cáo", "Người yêu cầu", "Yêu cầu lúc", "Trạng thái"],
            empty: "Yêu cầu xuất tệp (chạy nền, che cột nhạy cảm, ghi nhật ký audit) hiện ở đây."
          }
        ]}
        dependency="đặt vé, thanh toán và báo cáo (TASK-RPT-002)"
      />
    </div>
  );
}
