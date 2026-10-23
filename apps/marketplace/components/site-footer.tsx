import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { CircleHelp, FileText, Headphones, LogIn, ShieldCheck, Ticket, UserPlus } from "lucide-react";
import Link from "next/link";

const footerGroups = [
  { title: "TÀI KHOẢN", links: [
    { href: "/login", label: "Đăng nhập", icon: LogIn },
    { href: "/register", label: "Tạo tài khoản", icon: UserPlus },
    { href: "/my-tickets", label: "Hành trình của tôi", icon: Ticket }
  ] },
  { title: "HỖ TRỢ", links: [
    { href: "/support", label: "Hỗ trợ đơn vé", icon: Headphones },
    { href: "/faq", label: "Câu hỏi thường gặp", icon: CircleHelp },
    { href: "/tickets/lookup", label: "Tra cứu đơn vé", icon: FileText }
  ] },
  { title: "CHÍNH SÁCH", links: [
    { href: "/legal/terms", label: "Điều khoản sử dụng", icon: FileText },
    { href: "/legal/privacy", label: "Chính sách bảo mật", icon: ShieldCheck },
    { href: "/legal/refund-policy", label: "Hủy vé và hoàn tiền", icon: Ticket }
  ] }
];

/** Hiển thị liên kết khách hàng đang được hỗ trợ, không dùng địa chỉ liên hệ hoặc cổng đối tác mẫu. */
export function SiteFooter() {
  return (
    <footer className="mt-auto border-t border-vxn-teal-100 bg-[#ebf5f8] text-vxn-ink">
      <div className="mx-auto max-w-7xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid gap-10 md:grid-cols-2 lg:grid-cols-[1.6fr_1fr_1fr_1.4fr]">
          <section className="flex flex-col">
            <Link href="/" aria-label="Về trang chủ Vé Xe Nhanh" className="w-fit">
              <LogoWordmark className="h-10 w-auto text-vxn-teal-700" />
            </Link>
            <p className="mt-4 max-w-sm text-sm leading-relaxed text-vxn-fg-3">
              Tìm chuyến, đặt vé và quản lý hành trình của bạn trên Vé Xe Nhanh.
            </p>
            <div className="mt-6 inline-flex w-fit items-center gap-2.5 rounded-full border border-vxn-teal-200/80 bg-white px-4 py-1.5 shadow-2xs">
              <span className="size-2 rounded-full bg-vxn-saffron-500" />
              <span className="text-xs font-medium text-vxn-fg-2">Vé điện tử QR · VNPay · MoMo</span>
            </div>
          </section>
          {footerGroups.map((group) => (
            <section key={group.title}>
              <h2 className="mb-4 flex items-center text-xs font-bold tracking-wider text-vxn-ink uppercase">
                <span className="mr-2 h-3.5 w-1 rounded-full bg-vxn-saffron-500" />{group.title}
              </h2>
              <ul className="space-y-3">
                {group.links.map(({ href, label, icon: Icon }) => (
                  <li key={href}>
                    <Link href={href} className="group flex items-center gap-2.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-700">
                      <Icon className="size-4 shrink-0 text-vxn-fg-4 transition-colors group-hover:text-vxn-teal-700" />{label}
                    </Link>
                  </li>
                ))}
              </ul>
            </section>
          ))}
        </div>
        <div className="mt-12 border-t border-vxn-teal-200/60 pt-6 text-center text-xs text-vxn-fg-4 sm:text-left">
          © 2026 Vé Xe Nhanh. All rights reserved.
        </div>
      </div>
    </footer>
  );
}
