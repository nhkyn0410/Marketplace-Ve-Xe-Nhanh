import type { Metadata } from "next";
import Link from "next/link";
import { Smartphone } from "lucide-react";
import { PassengerTopBar } from "../../../../../../components/passenger-topbar";

export const metadata: Metadata = {
  title: "Quay lại ứng dụng",
  description: "Hoàn tất thanh toán vé xe trên ứng dụng Vé Xe Nhanh.",
  robots: { index: false, follow: false }
};

/**
 * Cổng thanh toán đưa khách đặt vé trên app về đây (PASSENGER-PARITY A25/P4). Máy có app thì Android mở thẳng app
 * bằng App Link, không tới trang này; còn lại nhắc quay lại app — app tự kiểm tra trạng thái đơn khi được mở lại.
 * Không đọc tham số cổng gửi kèm: kết quả chỉ tin máy chủ (IPN / đối soát).
 */
export default function AppPaymentReturnPage() {
  return (
    <div className="flex-1 bg-neutral-50/40 pb-16">
      <PassengerTopBar breadcrumbs={[{ label: "Trang chủ", href: "/" }, { label: "Thanh toán" }]} />
      <section className="mx-auto flex max-w-md flex-col items-center gap-4 px-4 pt-12 text-center">
        <span className="flex size-14 items-center justify-center rounded-full bg-vxn-teal-50 text-vxn-teal-700">
          <Smartphone className="size-7" />
        </span>
        <h1 className="text-xl/7 font-semibold text-vxn-ink">Quay lại ứng dụng Vé Xe Nhanh</h1>
        <p className="text-sm/6 text-vxn-fg-5">
          Bạn đã xong bước thanh toán ở cổng. Hãy mở lại ứng dụng Vé Xe Nhanh: ứng dụng tự cập nhật trạng thái đơn và
          hiện vé khi thanh toán thành công.
        </p>
        <Link href="/" className="text-sm font-semibold text-primary hover:underline">
          Về trang chủ
        </Link>
      </section>
    </div>
  );
}
