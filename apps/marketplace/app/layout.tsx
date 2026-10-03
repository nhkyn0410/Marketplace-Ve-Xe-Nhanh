import "@vexenhanh/ui/globals.css";

import type { Metadata } from "next";
import { Be_Vietnam_Pro } from "next/font/google";
import type { ReactNode } from "react";

import { SiteShell } from "../components/site-shell";

const beVietnamPro = Be_Vietnam_Pro({
  subsets: ["latin", "vietnamese"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-be-vietnam-pro",
  display: "swap"
});

export const metadata: Metadata = {
  title: { default: "Vé Xe Nhanh — Đặt vé xe khách trực tuyến", template: "%s | Vé Xe Nhanh" },
  description: "Tìm chuyến, so sánh nhà xe, chọn ghế và nhận vé điện tử QR."
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="vi" className={beVietnamPro.variable}>
      <body>
        <SiteShell>{children}</SiteShell>
      </body>
    </html>
  );
}
