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
 * Footer của trang khách hàng Marketplace theo thiết kế Figma (kit 1434:11609 & trang chủ 776:791).
 */
export function SiteFooter() {
  return (
    <footer className="mt-auto border-t border-vxn-teal-100 bg-[#ebf5f8] text-vxn-ink">
      <div className="mx-auto w-full max-w-[1120px] px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-[1.5fr_1fr_1fr_1.3fr]">
          {/* Cột 1: Thương hiệu */}
          <section className="flex flex-col">
            <Link href="/" aria-label="Về trang chủ Vé Xe Nhanh" className="w-fit">
              <LogoWordmark className="h-10 w-auto text-vxn-teal-700" />
            </Link>
            <p className="mt-4 max-w-xs text-xs leading-relaxed text-vxn-fg-3 sm:text-sm">
              Nền tảng đặt vé xe khách trực tuyến cho khách hàng, nhà xe và nhân viên vận hành chuyến.
            </p>
            <div className="mt-6 inline-flex w-fit items-center gap-2.5 rounded-full border border-vxn-teal-200/80 bg-white px-4 py-1.5 shadow-2xs">
              <span className="size-2 rounded-full bg-vxn-saffron-500" />
              <span className="text-xs font-semibold text-[#00506a]">
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
            <ul className="space-y-2.5">
              <li>
                <Link
                  href="http://localhost:3002/login"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <LogIn className="size-3.5" />
                  </span>
                  <span>Đăng nhập nhà xe</span>
                </Link>
              </li>
              <li>
                <Link
                  href="http://localhost:3003/login"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <LayoutDashboard className="size-3.5" />
                  </span>
                  <span>Quản trị hệ thống</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/support"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <FileText className="size-3.5" />
                  </span>
                  <span>Nhân viên chuyến</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/partner/register"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <UserPlus className="size-3.5" />
                  </span>
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
            <ul className="space-y-2.5">
              <li>
                <Link
                  href="/support"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <Headphones className="size-3.5" />
                  </span>
                  <span>Gửi khiếu nại</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/faq"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <CircleHelp className="size-3.5" />
                  </span>
                  <span>Câu hỏi thường gặp</span>
                </Link>
              </li>
              <li>
                <Link
                  href="/legal/refund-policy"
                  className="group flex items-center gap-3 text-xs font-medium text-vxn-ink transition-colors hover:text-vxn-teal-700 sm:text-sm"
                >
                  <span className="flex size-8 shrink-0 items-center justify-center rounded-lg border border-vxn-teal-100 bg-white text-vxn-saffron-500 shadow-2xs">
                    <ShieldCheck className="size-3.5" />
                  </span>
                  <span>Đổi và hủy vé</span>
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
              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white px-3.5 py-2.5 shadow-2xs">
                <Phone className="size-4 shrink-0 text-vxn-saffron-500" />
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Hotline</p>
                  <p className="text-xs font-bold text-vxn-ink sm:text-sm">1900 6067</p>
                </div>
              </div>

              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white px-3.5 py-2.5 shadow-2xs">
                <Mail className="size-4 shrink-0 text-vxn-saffron-500" />
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Email hỗ trợ</p>
                  <p className="truncate text-xs font-bold text-vxn-ink sm:text-sm">support@vexenhanh.vn</p>
                </div>
              </div>

              <div className="flex items-center gap-3 rounded-xl border border-vxn-teal-100 bg-white px-3.5 py-2.5 shadow-2xs">
                <MapPin className="size-4 shrink-0 text-vxn-saffron-500" />
                <div className="min-w-0 flex-1">
                  <p className="text-[11px] text-vxn-fg-4">Văn phòng</p>
                  <p className="truncate text-xs font-bold text-vxn-ink sm:text-sm">TP. Hồ Chí Minh, Việt Nam</p>
                </div>
              </div>

              {/* 3 nút liên kết nhanh (Facebook, Email, Điện thoại) chuẩn Figma */}
              <div className="flex items-center gap-2 pt-1">
                <a
                  href="https://facebook.com"
                  target="_blank"
                  rel="noreferrer"
                  aria-label="Facebook Vé Xe Nhanh"
                  className="flex size-9 items-center justify-center rounded-xl border border-vxn-teal-100 bg-white text-[#00506a] shadow-2xs transition hover:bg-slate-50"
                >
                  <span className="flex size-4 items-center justify-center rounded-[3px] border-[1.5px] border-current text-[10px] font-extrabold leading-none">
                    f
                  </span>
                </a>
                <a
                  href="mailto:support@vexenhanh.vn"
                  aria-label="Email hỗ trợ"
                  className="flex size-9 items-center justify-center rounded-xl border border-vxn-teal-100 bg-white text-[#00506a] shadow-2xs transition hover:bg-slate-50"
                >
                  <Mail className="size-4" />
                </a>
                <a
                  href="tel:19006067"
                  aria-label="Gọi tổng đài"
                  className="flex size-9 items-center justify-center rounded-xl border border-vxn-teal-100 bg-white text-[#00506a] shadow-2xs transition hover:bg-slate-50"
                >
                  <Phone className="size-4" />
                </a>
              </div>
            </div>
          </section>
        </div>

        {/* Thanh cuối trang */}
        <div className="mt-10 flex flex-col items-center justify-between gap-4 border-t border-vxn-teal-200/60 pt-6 text-xs text-vxn-fg-4 sm:flex-row">
          <p>© 2026 Vé Xe Nhanh. All rights reserved.</p>
          <div className="flex flex-wrap items-center gap-3 text-xs">
            <Link href="/legal/terms-of-service" className="hover:text-vxn-teal-700">
              Điều khoản sử dụng
            </Link>
            <span>·</span>
            <Link href="/legal/privacy-policy" className="hover:text-vxn-teal-700">
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
