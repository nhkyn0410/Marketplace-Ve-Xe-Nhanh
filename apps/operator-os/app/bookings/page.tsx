import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Đặt vé" };

/** Đặt vé (Figma 01…03 · Đặt vé) — khung giao diện, chưa có dữ liệu: chờ đặt vé và phát hành vé (TASK-BTP-002, 004; màn của nhà xe ở TASK-OPR-003). */
export default function BookingsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Đặt vé" description="Đơn đặt vé và vé thuộc các chuyến của nhà xe." />
      <PlannedScreen
        tabs={[
          {
            label: "Đơn đặt vé",
            columns: ["Mã đặt vé", "Khách liên hệ", "Chuyến", "Vé", "Giá vé", "Thanh toán", "Trạng thái đơn"],
            empty: "Đơn hành khách đặt trên các chuyến của nhà xe hiện ở đây."
          },
          {
            label: "Hành khách theo chuyến",
            columns: ["Chỗ", "Hành khách", "Điểm đón", "Điểm trả", "Mã vé", "Trạng thái"],
            empty: "Danh sách hành khách của từng chuyến hiện ở đây khi có vé."
          }
        ]}
        dependency="đặt vé và phát hành vé (TASK-BTP-002, 004; màn của nhà xe ở TASK-OPR-003)"
      />
    </div>
  );
}
