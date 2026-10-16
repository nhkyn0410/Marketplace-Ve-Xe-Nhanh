import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Thanh toán & hoàn tiền" };

/** Thanh toán & hoàn tiền (Figma ADM-07a…07d) — khung giao diện, chưa có dữ liệu: chờ đặt vé, thanh toán và hoàn tiền (TASK-BTP-002, 003, 005; phần Admin ở TASK-ADM-002). */
export default function PaymentsPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Thanh toán & hoàn tiền" description="Giám sát giao dịch qua cổng thanh toán, hoàn tiền và các khoản cần đối soát." />
      <PlannedScreen
        tabs={[
          {
            label: "Thanh toán",
            columns: ["Mã thanh toán", "Đơn đặt vé", "Nhà xe", "Cổng", "Số tiền", "Trạng thái", "Thời gian"],
            empty: "Giao dịch qua VNPay / MoMo hiện ở đây khi hành khách thanh toán đơn đặt vé."
          },
          {
            label: "Hoàn tiền",
            columns: ["Mã hoàn tiền", "Đơn đặt vé", "Nhà xe", "Nguồn", "Số tiền hoàn", "Trạng thái", "Cập nhật"],
            empty: "Yêu cầu hoàn tiền lỗi cổng, lệch số tiền hoặc ngoài chính sách sẽ chuyển về đây để Admin xử lý."
          }
        ]}
        dependency="đặt vé, thanh toán và hoàn tiền (TASK-BTP-002, 003, 005; phần Admin ở TASK-ADM-002)"
      />
    </div>
  );
}
