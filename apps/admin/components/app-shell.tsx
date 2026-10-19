"use client";

import { useAuth } from "@vexenhanh/ui/components/auth/auth-context";
import { DashboardShell } from "@vexenhanh/ui/components/dashboard-shell";
import { LogoMark } from "@vexenhanh/ui/components/logo";
import { LogOut } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { ROLE_LABELS } from "../lib/auth/portal";
import { NAV_GROUPS } from "../lib/nav";

/**
 * Khung cổng Admin theo Figma "VXN / Admin sidebar" (1661:24142): thương hiệu, nhãn "Platform · Nội bộ", menu sáu
 * nhóm, khối tài khoản + đăng xuất. Nền tối và bảng màu indigo (mode `Admin`) để không nhầm với cổng nhà xe.
 */
export function AppShell({ children }: { children: ReactNode }) {
  const { state, logout } = useAuth();
  // `AuthGate` chỉ dựng khung này khi đã đăng nhập; kiểm lại để kiểu dữ liệu chặt.
  const me = state.status === "authenticated" ? state.me : null;
  const username = me ? `platform/${me.username}` : "";

  return (
    <DashboardShell
      title="Quản trị nền tảng"
      tone="dark"
      navGroups={NAV_GROUPS}
      brand={
        <Link href="/" className="flex shrink-0 items-center gap-3 px-5 pt-5 pb-4">
          <LogoMark className="size-9 shrink-0 text-white" />
          <span className="flex flex-col">
            <span className="text-sm leading-5 font-semibold text-white">Vé Xe Nhanh</span>
            <span className="text-xs leading-[18px] text-[#9aa3c7]">Quản trị nền tảng</span>
          </span>
        </Link>
      }
      sidebarTop={
        <div className="px-4 pb-1">
          <p className="flex items-center gap-2 rounded-lg bg-[#2b3472] px-3 py-2 text-xs leading-[18px] font-medium text-[#e7e9f7]">
            <span aria-hidden className="size-2 rounded-full bg-vxn-saffron-500" />
            Platform · Nội bộ
          </p>
        </div>
      }
      sidebarBottom={
        <div className="flex items-center gap-3 border-t border-[#2a3156] px-5 pt-4 pb-5">
          <span
            aria-hidden
            className="flex size-9 shrink-0 items-center justify-center rounded-full bg-[#2b3472] text-xs font-medium text-white"
          >
            {(me?.username ?? "").slice(0, 2).toUpperCase()}
          </span>
          <span className="flex min-w-0 flex-1 flex-col">
            <span className="truncate text-sm leading-5 font-semibold text-white">{username}</span>
            <span className="truncate text-xs leading-[18px] text-[#9aa3c7]">{ROLE_LABELS[me?.role ?? ""] ?? ""}</span>
          </span>
          <button
            type="button"
            aria-label="Đăng xuất"
            title="Đăng xuất"
            onClick={() => void logout()}
            className="rounded p-1 text-[#9aa3c7] outline-none hover:text-white focus-visible:ring-2 focus-visible:ring-ring"
          >
            <LogOut className="size-[18px]" />
          </button>
        </div>
      }
    >
      {children}
    </DashboardShell>
  );
}
