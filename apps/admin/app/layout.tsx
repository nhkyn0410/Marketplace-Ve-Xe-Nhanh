import "@vexenhanh/ui/globals.css";
import "./admin-theme.css";

import type { Metadata } from "next";
import { Be_Vietnam_Pro, JetBrains_Mono } from "next/font/google";
import type { ReactNode } from "react";

import { AppShell } from "../components/app-shell";
import { AuthGate } from "../components/auth/auth-gate";
import { AuthProvider } from "../lib/auth/auth-provider";
import { QueryProvider } from "../lib/query-provider";

const beVietnamPro = Be_Vietnam_Pro({
  subsets: ["latin", "vietnamese"],
  weight: ["400", "500", "600", "700"],
  variable: "--font-be-vietnam-pro",
  display: "swap"
});

// Chữ đơn cách cho khóa thiết lập TOTP và mã dự phòng (Figma "VXN / Auth / Code").
const jetBrainsMono = JetBrains_Mono({
  subsets: ["latin"],
  weight: ["400"],
  variable: "--font-jetbrains-mono",
  display: "swap"
});

export const metadata: Metadata = {
  title: { default: "Quản trị nền tảng | Vé Xe Nhanh", template: "%s | Quản trị nền tảng" },
  // Cổng nội bộ — không cho công cụ tìm kiếm index.
  robots: { index: false, follow: false }
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="vi" className={`${beVietnamPro.variable} ${jetBrainsMono.variable}`}>
      <body>
        <AuthProvider>
          <AuthGate>
            <QueryProvider>
              <AppShell>{children}</AppShell>
            </QueryProvider>
          </AuthGate>
        </AuthProvider>
      </body>
    </html>
  );
}
