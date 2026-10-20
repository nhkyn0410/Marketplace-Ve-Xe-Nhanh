import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import {
  CircleHelp,
  FileText,
  Headphones,
  LayoutDashboard,
  LogIn,
  Mail,
  MapPin,
  Phone,
  ShieldCheck,
  UserPlus
} from "lucide-react";
import Link from "next/link";

/**
 * Footer của trang khách hàng Marketplace theo thiết kế Figma (kit 1434:11609).
 */
export function SiteFooter() {
  return (
    <footer className="mt-auto border-t border-vxn-teal-100 bg-[#ebf5f8] text-vxn-ink">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-[1.6fr_1fr_1fr_1.4fr]">
          {/* Cột 1: Thương hiệu */}
          <section className="flex flex-col">
            <Link href="/" aria-label="Về trang chủ Vé Xe Nhanh" className="w-fit">
              <LogoWordmark className="h-10 w-auto text-vxn-teal-700" />
            </Link>
            <p className="mt-4 max-w-sm text-sm leading-relaxed text-vxn-fg-3">
              Nền tảng đặt vé xe khách trực tuyến cho khách hàng, nhà xe và nhân viên vận hành chuyến.
            </p>
            <div className="mt-6 inline-flex w-fit items-center gap-2.5 rounded-full border border-vxn-teal-200/80 bg-white px-4 py-1.5 shadow-2xs">
              <span className="size-2 rounded-full bg-vxn-saffron-500" />
              <span className="text-xs font-medium text-vxn-fg-2">
                Vé điện tử QR · Thanh toán an toàn
              </span>
            </div>
          </section>

          {/* Cột 2: Đối tác */}
          <section>
            <h2 className="mb-4 flex items-center text-xs font-bold tracking-wider text-vxn-ink uppercase">
              <span className="mr-2 h-3.5 w-1 rounded-full bg-vxn-saffron-500" />
              ĐỐI TÁC
            </h2>
            <ul className="space-y-3">
              <li>
                <Link
                  href="http://localhost:3002/login"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <LogIn className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Đăng nhập nhà xe</span>
                </Link>
              </li>
              <li>
                <Link
                  href="http://localhost:3003/login"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <LayoutDashboard className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Quản trị hệ thống</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/support"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <FileText className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Nhân viên chuyến</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/partner/register"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <UserPlus className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Đăng ký nhà xe</span>
                </Link>
              </li>
            </ul>
          </section>

          {/* Cột 3: Hỗ trợ */}
          <section>
            <h2 className="mb-4 flex items-center text-xs font-bold tracking-wider text-vxn-ink uppercase">
              <span className="mr-2 h-3.5 w-1 rounded-full bg-vxn-saffron-500" />
              HỖ TRỢ
            </h2>
            <ul className="space-y-3">
              <li>
                <Link
                  href="/support"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <Headphones className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Gửi khiếu nại</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/faq"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <CircleHelp className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Câu hỏi thường gặp</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/legal/refund-policy"
                  className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
                >
                  <ShieldCheck className="size-4 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />
                  <span>Hủy vé và hoàn tiền</span>
                </Link>
              </li>
            </ul>
          </section>

          {/* Cột 4: Liên hệ */}
          <section>
            <h2 className="mb-4 flex items-center text-xs font-bold tracking-wider text-vxn-ink uppercase">
              <span className="mr-2 h-3.5 w-1 rounded-full bg-vxn-saffron-500" />
              LIÊN HỆ
            </h2>
            <div className="space-y-2.5">
              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white p-2.5 shadow-2xs">
                <div className="flex size-8 shrink-0 items-center justify-center rounded-lg bg-amber-50 text-amber-600">
                  <Phone className="size-4" />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Hotline</p>
                  <p className="text-sm font-bold text-vxn-ink">1900 6067</p>
                </div>
              </div>

              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white p-2.5 shadow-2xs">
                <div className="flex size-8 shrink-0 items-center justify-center rounded-lg bg-amber-50 text-amber-600">
                  <Mail className="size-4" />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Email hỗ trợ</p>
                  <p className="truncate text-xs font-bold text-vxn-ink sm:text-sm">support@vexenhanh.vn</p>
                </div>
              </div>

              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white p-2.5 shadow-2xs">
                <div className="flex size-8 shrink-0 items-center justify-center rounded-lg bg-amber-50 text-amber-600">
                  <MapPin className="size-4" />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Văn phòng</p>
                  <p className="truncate text-xs font-bold text-vxn-ink sm:text-sm">TP. Hồ Chí Minh, Việt Nam</p>
                </div>
              </div>
            </div>
          </section>
        </div>

        {/* Thanh cuối trang */}
        <div className="mt-12 flex flex-col items-center justify-between gap-4 border-t border-vxn-teal-200/60 pt-6 text-xs text-vxn-fg-4 sm:flex-row">
          <p>© 2026 Vé Xe Nhanh. All rights reserved.</p>
          <div className="flex flex-wrap items-center gap-4 text-xs">
            <Link href="/legal/terms" className="hover:text-vxn-teal-700">
              Điều khoản sử dụng
            </Link>
            <span>·</span>
            <Link href="/legal/privacy" className="hover:text-vxn-teal-700">
              Chính sách bảo mật
            </Link>
            <span>·</span>
            <Link href="/legal/refund-policy" className="hover:text-vxn-teal-700">
              Chính sách hoàn tiền
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}
