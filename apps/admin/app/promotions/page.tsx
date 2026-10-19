import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Khuyến mãi" };

/** Khuyến mãi (Figma ADM-11a, 11b) — khung giao diện, chưa có dữ liệu: chờ khuyến mãi và đặt vé (TASK-PROM-001, TASK-PROM-002). */
export default function PromotionsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Khuyến mãi" description="Chương trình cấp nền tảng và giới hạn cho phép nhà xe tự tạo khuyến mãi." />
      <PlannedScreen
        stats={[
          { label: "Đang chạy", hint: "Chương trình" },
          { label: "Lượt áp dụng", hint: "30 ngày gần nhất" },
          { label: "Tổng giá trị giảm", hint: "30 ngày gần nhất" },
          { label: "Doanh thu có áp mã", hint: "30 ngày gần nhất" }
        ]}
        tabs={[
          {
            label: "Khuyến mãi nền tảng",
            columns: ["Mã và tên", "Mức giảm", "Phạm vi", "Hiệu lực", "Lượt dùng", "Trạng thái"],
            empty: "Chương trình khuyến mãi cấp nền tảng hiện ở đây."
          },
          {
            label: "Quyền của nhà xe",
            columns: ["Nhà xe", "Được tự tạo", "Mức giảm tối đa", "Tuyến / chuyến", "Hiệu lực tối đa", "Ngân sách"],
            empty: "Giới hạn khuyến mãi từng nhà xe được tự tạo hiện ở đây."
          }
        ]}
        dependency="khuyến mãi và đặt vé (TASK-PROM-001, TASK-PROM-002)"
      />
    </div>
  );
}
