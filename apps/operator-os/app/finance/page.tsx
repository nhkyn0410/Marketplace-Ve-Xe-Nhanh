import { PlannedScreen } from "@vexenhanh/ui/components/planned-screen";
import type { Metadata } from "next";

import { PageHeader } from "../../components/page-header";

export const metadata: Metadata = { title: "Tài chính" };

/** Tài chính (Figma 01…03 · Tài chính) — khung giao diện, chưa có dữ liệu: chờ thanh toán, sổ giữ hộ và chi trả (TASK-BTP-006, TASK-OPR-002). */
export default function FinancePage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Tài chính" description="Tiền vé do Vé Xe Nhanh giữ hộ và chi trả cho nhà xe sau khi chuyến hoàn thành." />
      <PlannedScreen
        stats={[
          { label: "Số dư đang giữ", hint: "Tiền vé đã thu, chưa chi trả" },
          { label: "Đủ điều kiện chi trả", hint: "Đã qua T+3 kể từ khi chuyến hoàn thành" },
          { label: "Chờ đủ điều kiện", hint: "Chuyến chưa hoàn thành hoặc chưa đủ T+3" },
          { label: "Kỳ chi trả gần nhất", hint: "Thực nhận" }
        ]}
        tabs={[
          {
            label: "Giao dịch",
            columns: ["Mã đặt vé", "Chuyến", "Giá vé", "Hoa hồng", "Hoàn / điều chỉnh", "Nhà xe nhận", "Tình trạng"],
            empty: "Tiền vé từng đơn (sau hoa hồng, hoàn tiền) hiện ở đây."
          },
          {
            label: "Chi trả",
            columns: ["Kỳ chi trả", "Đủ điều kiện", "Hoa hồng", "Hoàn / điều chỉnh", "Thực nhận", "Trạng thái"],
            empty: "Các kỳ chi trả T+3 vào tài khoản nhận tiền đã xác minh hiện ở đây."
          }
        ]}
        dependency="thanh toán, sổ giữ hộ và chi trả (TASK-BTP-006, TASK-OPR-002)"
      />
    </div>
  );
}
