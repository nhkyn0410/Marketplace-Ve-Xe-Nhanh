import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "VXN Plus" };

/** VXN Plus (Figma ADM-12a…12d) — khung giao diện, chưa có dữ liệu: chờ chương trình VXN Plus (TASK-LOY-001 — chờ chốt tham số LLD-OQ-06). */
export default function LoyaltyPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="VXN Plus" description="Chương trình thành viên của Vé Xe Nhanh: tham số tích điểm, tài khoản thành viên và báo cáo." />
      <PlannedScreen
        stats={[
          { label: "Thành viên", hint: "Tài khoản VXN Plus" },
          { label: "Điểm đã tích", hint: "30 ngày gần nhất" },
          { label: "Điểm đã đổi", hint: "30 ngày gần nhất" },
          { label: "Voucher đã phát hành", hint: "Đổi từ điểm" }
        ]}
        tabs={[
          {
            label: "Tài khoản thành viên",
            columns: ["Thành viên", "Hạng", "Điểm khả dụng", "Tích trong 12 tháng", "Tham gia từ"],
            empty: "Tài khoản thành viên hiện ở đây khi chương trình VXN Plus được kích hoạt."
          },
          {
            label: "Giao dịch điểm",
            columns: ["Ngày", "Thành viên", "Loại", "Nguồn", "Phiên bản chính sách", "Điểm"],
            empty: "Sổ điểm chỉ ghi thêm (tích / đổi / hết hạn / điều chỉnh) hiện ở đây."
          }
        ]}
        dependency="chương trình VXN Plus (TASK-LOY-001 — chờ chốt tham số LLD-OQ-06)"
      />
    </div>
  );
}
