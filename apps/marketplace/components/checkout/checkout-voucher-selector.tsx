import { Tag } from "lucide-react";

/** Thông báo đúng khả năng áp ưu đãi của luồng đặt vé hiện tại. */
export function CheckoutVoucherSelector() {
  return (
    <section className="rounded-2xl border border-vxn-border bg-white p-5 sm:p-6 shadow-2xs">
      <h3 className="flex items-center gap-2 text-base font-bold text-vxn-ink sm:text-lg"><Tag className="h-4 w-4 text-vxn-teal-700" />Ưu đãi</h3>
      <p className="mt-2 text-xs leading-relaxed text-vxn-fg-4">Áp voucher và mã khuyến mãi khi đặt vé hiện chưa khả dụng. Đơn này tiếp tục với giá vé giữ chỗ, không áp ưu đãi.</p>
    </section>
  );
}
