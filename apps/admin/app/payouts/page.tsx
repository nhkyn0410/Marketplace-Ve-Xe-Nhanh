import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Chi trả nhà xe" };

/** Chi trả nhà xe (Figma ADM-08a…08c) — khung giao diện, chưa có dữ liệu: chờ sổ giữ hộ và chi trả T+3 (TASK-BTP-006; phần Admin ở TASK-ADM-002). */
export default function PayoutsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Chi trả nhà xe" description="Kỳ chi trả được tạo tự động khi chuyến hoàn thành đủ T+3. Admin rà soát, chuyển khoản và xác nhận." />
      <PlannedScreen
        stats={[
          { label: "Chờ rà soát", hint: "Khoản đã đủ T+3" },
          { label: "Sẵn sàng chuyển khoản", hint: "Đã rà soát" },
          { label: "Đang giữ lại", hint: "Tranh chấp hoặc tài khoản chưa xác minh" },
          { label: "Đã chi trả trong tháng", hint: "Tổng thực chi" }
        ]}
        tabs={[
          {
            label: "Kỳ chi trả",
            columns: ["Mã chi trả", "Nhà xe", "Kỳ", "Thực chi", "Tài khoản nhận", "Trạng thái"],
            empty: "Kỳ chi trả được tạo khi chuyến có vé đã thanh toán hoàn thành đủ T+3 (chính sách Chi trả)."
          }
        ]}
        dependency="sổ giữ hộ và chi trả T+3 (TASK-BTP-006; phần Admin ở TASK-ADM-002)"
      />
    </div>
  );
}
