"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { LogoMark } from "@vexenhanh/ui/components/logo";
import { LogOut, Ticket } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { useAuth } from "../../lib/auth/auth-context";

/** Khung cổng bán vé riêng với danh tính người bán luôn hiển thị. */
export function CounterShell({ children }: { children: ReactNode }) {
  const { state, logout } = useAuth();
  const me = state.status === "authenticated" ? state.me : null;
  return (
    <div className="min-h-dvh bg-muted/30">
      <header className="border-b bg-card px-4 py-4 sm:px-6 print:hidden">
        <div className="mx-auto flex max-w-7xl flex-wrap items-center justify-between gap-4">
          <Link href="/counter" className="flex items-center gap-3 font-semibold text-primary"><LogoMark className="size-8" /><span>Vé Xe Nhanh<span className="block text-xs font-normal text-muted-foreground">Bán vé tại văn phòng</span></span></Link>
          <div className="flex flex-wrap items-center gap-3 text-sm">
            <span className="flex items-center gap-2"><Ticket className="size-4 text-primary" /><span>{me?.operatorSlug}<span className="block text-xs text-muted-foreground">Người bán: {me?.username}</span></span></span>
            {me?.role === "OPERATOR_OWNER" && <Button asChild variant="outline" size="sm"><Link href="/offices">Quản lý văn phòng</Link></Button>}
            <Button variant="outline" size="sm" onClick={() => void logout()}><LogOut className="size-4" />Đăng xuất</Button>
          </div>
        </div>
      </header>
      <main className="mx-auto max-w-7xl p-4 sm:p-6">{children}</main>
    </div>
  );
}
