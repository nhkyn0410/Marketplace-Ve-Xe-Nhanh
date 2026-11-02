"use client";

import { cn } from "@vexenhanh/ui/lib/utils";
import Link from "next/link";
import { usePathname } from "next/navigation";

import { PageHeader } from "../page-header";

const TABS = [
  { href: "/finance", label: "Tổng quan" },
  { href: "/finance/payouts", label: "Chi trả" }
];

/** Đầu màn Tài chính + hai tab (Figma "Nhà xe · Tài chính": Tổng quan / Chi trả). */
export function FinanceHeader() {
  const pathname = usePathname();
  return (
    <>
      <PageHeader title="Tài chính" description="Tiền vé do Vé Xe Nhanh giữ hộ và chi trả cho nhà xe sau khi chuyến hoàn thành." />
      <nav aria-label="Tài chính" className="flex w-fit gap-1 rounded-lg bg-muted p-1">
        {TABS.map((tab) => {
          const active = tab.href === "/finance" ? pathname === "/finance" : pathname.startsWith(tab.href);
          return (
            <Link
              key={tab.href}
              href={tab.href}
              aria-current={active ? "page" : undefined}
              className={cn(
                "rounded-md px-3 py-1.5 text-sm leading-5 font-medium text-muted-foreground hover:text-vxn-fg-1",
                active && "bg-card text-vxn-ink shadow-sm"
              )}
            >
              {tab.label}
            </Link>
          );
        })}
      </nav>
    </>
  );
}
