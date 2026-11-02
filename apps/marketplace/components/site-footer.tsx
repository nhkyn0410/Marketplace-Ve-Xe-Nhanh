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
  UserPlus,
  type LucideIcon
} from "lucide-react";
import Link from "next/link";

// Operator OS / Admin là app riêng (domain riêng khi deploy); màn đăng nhập của hai app nằm ngay ở "/".
const OPERATOR_OS_URL = (process.env.NEXT_PUBLIC_OPERATOR_OS_URL ?? "http://localhost:3002").replace(/\/$/, "");
const ADMIN_URL = (process.env.NEXT_PUBLIC_ADMIN_URL ?? "http://localhost:3003").replace(/\/$/, "");

interface FooterLink {
  readonly href: string;
  readonly label: string;
  readonly icon: LucideIcon;
}

const PARTNER_LINKS: readonly FooterLink[] = [
  { href: OPERATOR_OS_URL, label: "Đăng nhập nhà xe", icon: LogIn },
  { href: ADMIN_URL, label: "Quản trị hệ thống", icon: LayoutDashboard },
  { href: "/support", label: "Nhân viên chuyến", icon: FileText },
  { href: `${OPERATOR_OS_URL}/register`, label: "Đăng ký nhà xe", icon: UserPlus }
];

const SUPPORT_LINKS: readonly FooterLink[] = [
  { href: "/support", label: "Gửi khiếu nại", icon: Headphones },
  { href: "/faq", label: "Câu hỏi thường gặp", icon: CircleHelp },
  { href: "/legal/refund-policy", label: "Hủy vé và hoàn tiền", icon: ShieldCheck }
];

const CONTACTS = [
  { label: "Hotline", value: "1900 6067", icon: Phone },
  { label: "Email hỗ trợ", value: "support@vexenhanh.vn", icon: Mail },
  { label: "Văn phòng", value: "TP. Hồ Chí Minh, Việt Nam", icon: MapPin }
] as const;

const CARD_RING = "shadow-[0_0_0_1px_#d7e7ee,0_1px_2px_0_rgb(0_0_0/0.05)]";
const CARD_DROP = "shadow-[0_1px_1px_0_rgb(0_0_0/0.05)]";

/**
 * Footer của trang khách hàng Marketplace theo kit Figma `VXN / Passenger footer` (1434:11609).
 */
export function SiteFooter() {
  return (
    <footer className="mt-auto bg-[#eaf6fa] text-vxn-ink">
      <div className="mx-auto w-full max-w-[1200px] px-4 pt-14 pb-12 sm:px-6 lg:px-12">
        <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-[320px_minmax(0,1fr)_minmax(0,1fr)_auto] lg:gap-6">
          {/* Cột 1: Thương hiệu */}
          <section className="flex flex-col gap-5">
            <Link href="/" aria-label="Về trang chủ Vé Xe Nhanh" className="w-fit">
              <LogoWordmark className="h-[58px] w-auto text-vxn-teal-500" />
            </Link>
            <p className="max-w-80 text-[17px] leading-7 text-vxn-fg-3">
              Nền tảng đặt vé xe khách trực tuyến cho khách hàng, nhà xe và nhân viên vận hành chuyến.
            </p>
            <div className={`flex w-full max-w-80 items-center gap-2 rounded-full bg-white px-4 py-2 ${CARD_RING}`}>
              <span className="size-2 shrink-0 rounded-full bg-vxn-saffron-500" />
              <span className="flex-1 text-center text-sm font-medium text-vxn-teal-800">
                Vé điện tử QR · Thanh toán an toàn
              </span>
            </div>
          </section>

          <FooterLinkColumn title="Đối tác" links={PARTNER_LINKS} />
          <FooterLinkColumn title="Hỗ trợ" links={SUPPORT_LINKS} />

          {/* Cột 4: Liên hệ */}
          <section>
            <FooterHeading title="Liên hệ" />
            <div className="flex flex-col gap-4 pt-4">
              {CONTACTS.map(({ label, value, icon: Icon }) => (
                <div key={label} className={`flex items-start gap-3 rounded-lg bg-white p-3 ${CARD_DROP}`}>
                  <Icon className="mt-1 size-3.5 shrink-0 text-vxn-saffron-500" />
                  <div className="min-w-0 text-sm">
                    <p className="text-vxn-fg-5">{label}</p>
                    <p className="font-semibold whitespace-nowrap text-vxn-ink">{value}</p>
                  </div>
                </div>
              ))}

              {/* 3 nút liên kết nhanh (Facebook, Email, Điện thoại) */}
              <div className="flex items-center gap-3">
                <a
                  href="https://facebook.com"
                  target="_blank"
                  rel="noreferrer"
                  aria-label="Facebook Vé Xe Nhanh"
                  className={`flex size-10 items-center justify-center rounded-lg bg-white transition hover:bg-slate-50 ${CARD_DROP}`}
                >
                  <img src="/icons/facebook.svg" alt="" width={16} height={16} />
                </a>
                <a
                  href="mailto:support@vexenhanh.vn"
                  aria-label="Email hỗ trợ"
                  className={`flex size-10 items-center justify-center rounded-lg bg-white text-vxn-teal-800 transition hover:bg-slate-50 ${CARD_DROP}`}
                >
                  <Mail className="size-4" />
                </a>
                <a
                  href="tel:19006067"
                  aria-label="Gọi tổng đài"
                  className={`flex size-10 items-center justify-center rounded-lg bg-white text-vxn-teal-800 transition hover:bg-slate-50 ${CARD_DROP}`}
                >
                  <Phone className="size-4" />
                </a>
              </div>
            </div>
          </section>
        </div>

        {/* Thanh cuối trang */}
        <div className="flex flex-col items-center justify-between gap-3 pt-12 text-[13px] text-vxn-fg-5 sm:flex-row">
          <p>© 2026 Vé Xe Nhanh. All rights reserved.</p>
          <div className="flex flex-wrap items-center justify-center gap-x-1">
            <Link href="/legal/terms-of-service" className="hover:text-vxn-teal-700">
              Điều khoản sử dụng
            </Link>
            <span aria-hidden="true">·</span>
            <Link href="/legal/privacy-policy" className="hover:text-vxn-teal-700">
              Chính sách bảo mật
            </Link>
            <span aria-hidden="true">·</span>
            <Link href="/legal/refund-policy" className="hover:text-vxn-teal-700">
              Chính sách hoàn tiền
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}

function FooterHeading({ title }: { readonly title: string }) {
  return (
    <h2 className="flex items-center gap-2 text-sm font-semibold tracking-[0.35px] text-vxn-ink uppercase">
      <span className="h-5 w-1 rounded-full bg-vxn-saffron-500" />
      {title}
    </h2>
  );
}

function FooterLinkColumn({ title, links }: { readonly title: string; readonly links: readonly FooterLink[] }) {
  return (
    <section>
      <FooterHeading title={title} />
      <ul className="flex flex-col gap-3 py-4">
        {links.map(({ href, label, icon: Icon }) => (
          <li key={label}>
            <Link
              href={href}
              className="group flex items-center gap-3 text-[15px] font-medium text-vxn-fg-3 transition-colors hover:text-vxn-teal-700"
            >
              <span className={`flex size-8 shrink-0 items-center justify-center rounded-lg bg-white text-vxn-saffron-600 ${CARD_RING}`}>
                <Icon className="size-[15px]" />
              </span>
              <span>{label}</span>
            </Link>
          </li>
        ))}
      </ul>
    </section>
  );
}
