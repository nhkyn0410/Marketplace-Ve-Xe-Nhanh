import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Báo cáo" };

/** Báo cáo (Figma 01 · Báo cáo) — khung giao diện, chưa có dữ liệu: chờ đặt vé, phân công và soát vé (TASK-RPT-001, TASK-EMP-001, 002). */
export default function ReportsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Báo cáo" description="Số liệu vận hành và doanh thu của nhà xe trong khoảng thời gian đã chọn." />
      <PlannedScreen
        stats={[
          { label: "Doanh thu gộp", hint: "Chuyến đã chạy" },
          { label: "Vé đã bán", hint: "Đơn đặt vé" },
          { label: "Tỷ lệ lấp đầy", hint: "Chỗ đã bán / chỗ mở bán" },
          { label: "Tỷ lệ hủy", hint: "Hoàn tiền" }
        ]}
        tabs={[
          {
            label: "Theo tuyến",
            columns: ["Tuyến", "Chuyến", "Vé bán", "Lấp đầy", "Doanh thu gộp"],
            empty: "Số liệu theo tuyến hiện ở đây khi có vé đã bán."
          },
          {
            label: "Nhân viên theo chuyến",
            columns: ["Nhân viên", "Vai trò", "Chuyến được phân công", "Chuyến hoàn thành", "Vé đã soát", "Sự cố đã báo"],
            empty: "Số liệu nhân viên hiện ở đây khi có phân công chuyến và soát vé."
          }
        ]}
        dependency="đặt vé, phân công và soát vé (TASK-RPT-001, TASK-EMP-001, 002)"
      />
    </div>
  );
}
