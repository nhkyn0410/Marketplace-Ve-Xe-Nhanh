import { PageHeader } from "../components/page-header";

/** Tổng quan nền tảng (Figma ADM-01). Chỉ số giao dịch / chi trả cần đặt vé và thanh toán (M3, M4). */
export default function AdminOverviewPage() {
  return (
    <div className="flex flex-col gap-6">
      <PageHeader title="Tổng quan nền tảng" description="Số liệu toàn hệ thống sẽ hiển thị khi có dữ liệu đặt vé." />
      <p className="rounded-xl border bg-card p-6 text-sm leading-5 text-muted-foreground">
        Chọn một mục ở thanh bên để bắt đầu.
      </p>
    </div>
  );
}
