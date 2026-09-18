import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import Link from "next/link";

const FOOTER_SECTIONS = [
  {
    title: "Dịch vụ",
    links: [
      { href: "/", label: "Tìm chuyến xe" },
      { href: "/tickets/lookup", label: "Tra cứu vé" }
    ]
  },
  {
    title: "Hỗ trợ",
    links: [
      { href: "/support", label: "Trung tâm hỗ trợ" },
      { href: "/faq", label: "Câu hỏi thường gặp" }
    ]
  }
];

export function SiteFooter() {
  return (
    <footer className="mt-auto border-t bg-vxn-teal-50">
      <div className="mx-auto max-w-8xl px-4 py-12 sm:px-6 lg:px-8">
        <div className="grid gap-10 md:grid-cols-[2fr_1fr_1fr]">
          <section>
            <LogoWordmark className="h-12 w-auto text-vxn-teal-500" />
            <p className="mt-4 max-w-sm text-sm leading-6 text-vxn-fg-3">
              Nền tảng đặt vé xe khách trực tuyến, kết nối hành khách với các nhà xe trên toàn quốc.
            </p>
          </section>

          {FOOTER_SECTIONS.map((section) => (
            <section key={section.title}>
              <h2 className="mb-3 flex items-center gap-2 text-sm font-semibold tracking-wide text-vxn-ink uppercase">
                <span className="h-4 w-1 rounded-full bg-vxn-saffron-500" />
                {section.title}
              </h2>
              <ul className="space-y-1">
                {section.links.map((link) => (
                  <li key={link.href}>
                    <Link
                      href={link.href}
                      className="inline-block py-1.5 text-sm text-vxn-fg-3 transition-colors hover:text-vxn-teal-600"
                    >
                      {link.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </section>
          ))}
        </div>

        <div className="mt-10 border-t pt-6 text-xs text-vxn-fg-5">
          © {new Date().getFullYear()} Vé Xe Nhanh
        </div>
      </div>
    </footer>
  );
}
