import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Khiếu nại & tranh chấp" };

/** Khiếu nại & tranh chấp (Figma ADM-09a…09e) — khung giao diện, chưa có dữ liệu: chờ đặt vé và quy trình khiếu nại / tranh chấp (TASK-TRUST-001, TASK-ADM-002). */
export default function DisputesPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Khiếu nại & tranh chấp" description="Phân loại, phân công và theo dõi khiếu nại; phân xử tranh chấp giữa hành khách và nhà xe." />
      <PlannedScreen
        tabs={[
          {
            label: "Khiếu nại",
            columns: ["Mã", "Vụ việc", "Người gửi", "Nhà xe", "Phụ trách", "Trạng thái", "Cập nhật"],
            empty: "Khiếu nại của hành khách về đơn đặt vé / chuyến xe hiện ở đây."
          },
          {
            label: "Tranh chấp",
            columns: ["Mã", "Vụ việc", "Nhà xe", "Số tiền liên quan", "Hạn phản hồi", "Trạng thái"],
            empty: "Tranh chấp mở từ khiếu nại cần Vé Xe Nhanh phân xử hiện ở đây."
          }
        ]}
        dependency="đặt vé và quy trình khiếu nại / tranh chấp (TASK-TRUST-001, TASK-ADM-002)"
      />
    </div>
  );
}
