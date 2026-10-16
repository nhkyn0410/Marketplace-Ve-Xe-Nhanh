import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Khuyến mãi" };

/** Khuyến mãi (Figma 01…03 · Khuyến mãi) — khung giao diện, chưa có dữ liệu: chờ khuyến mãi và đặt vé (TASK-PROM-001). */
export default function PromotionsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Khuyến mãi" description="Mã giảm giá của riêng nhà xe, trong giới hạn Vé Xe Nhanh cho phép." />
      <PlannedScreen
        stats={[
          { label: "Đang chạy", hint: "Chương trình" },
          { label: "Lượt áp dụng", hint: "30 ngày gần nhất" },
          { label: "Tổng giá trị giảm", hint: "Trừ vào doanh thu của nhà xe" },
          { label: "Doanh thu có áp mã", hint: "30 ngày gần nhất" }
        ]}
        tabs={[
          {
            label: "Khuyến mãi",
            columns: ["Mã và tên", "Mức giảm", "Phạm vi", "Hiệu lực", "Lượt dùng", "Trạng thái"],
            empty: "Mã giảm giá nhà xe tạo hiện ở đây; nhà xe chỉ tạo được khi Vé Xe Nhanh cấp quyền."
          }
        ]}
        dependency="khuyến mãi và đặt vé (TASK-PROM-001)"
      />
    </div>
  );
}
