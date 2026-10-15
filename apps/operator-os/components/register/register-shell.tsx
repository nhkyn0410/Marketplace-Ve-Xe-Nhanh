"use client";

import { Button } from "@vexenhanh/ui/components/button";
import { LogoWordmark } from "@vexenhanh/ui/components/logo";
import { cn } from "@vexenhanh/ui/lib/utils";
import { ArrowRight, Check } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

import { REGISTER_STEPS } from "../../lib/register/application";

/**
 * Khung các trang đăng ký nhà xe công khai (Figma "Đăng ký nhà xe" 01–08): header thương hiệu + "Đăng nhập nhà xe",
 * thanh bốn bước. `step` là bước đang ở (1–4); bước trước đó hiện dấu tích.
 */
export function RegisterShell({ step, children }: { step: 1 | 2 | 3 | 4; children: ReactNode }) {
  return (
    <div className="min-h-dvh bg-background">
      <header className="flex h-[73px] items-center gap-3.5 border-b bg-card px-4 sm:px-14">
        <Link href="/register" aria-label="Vé Xe Nhanh — đăng ký nhà xe" className="shrink-0">
          <LogoWordmark className="h-[34px] w-auto text-vxn-teal-700" />
        </Link>
        <span aria-hidden className="hidden h-10 w-px bg-border sm:block" />
        <span className="hidden text-sm leading-5 text-muted-foreground sm:block">Đối tác nhà xe</span>
        <span className="flex-1" />
        <span className="hidden text-sm leading-5 text-muted-foreground md:block">Đã có tài khoản?</span>
        <Button asChild variant="outline" className="h-10 rounded-lg bg-card px-4 text-sm font-semibold">
          <Link href="/">
            <ArrowRight className="size-[18px]" />
            Đăng nhập nhà xe
          </Link>
        </Button>
      </header>
      <main className="mx-auto flex w-full max-w-[1248px] flex-col items-center gap-7 px-4 py-10 sm:px-14">
        <Steps current={step} />
        {children}
      </main>
    </div>
  );
}

function Steps({ current }: { current: number }) {
  return (
    <ol aria-label="Các bước đăng ký" className="flex flex-wrap items-center justify-center gap-3">
      {REGISTER_STEPS.map((label, index) => {
        const number = index + 1;
        const state = number < current ? "done" : number === current ? "current" : "todo";
        return (
          <li key={label} className="flex items-center gap-3" aria-current={state === "current" ? "step" : undefined}>
            {index > 0 && (
              <span aria-hidden className={cn("h-px w-10", number <= current ? "bg-success-600" : "bg-border")} />
            )}
            <span className="flex items-center gap-2">
              <span
                className={cn(
                  "flex size-7 items-center justify-center rounded-full text-[13px] leading-[19.5px] font-semibold",
                  state === "done" && "bg-success-50 text-success-600",
                  state === "current" && "bg-primary text-primary-foreground",
                  state === "todo" && "bg-muted text-muted-foreground"
                )}
              >
                {state === "done" ? <Check className="size-3.5" aria-label="Đã xong" /> : number}
              </span>
              <span
                className={cn(
                  "text-sm leading-5",
                  state === "current" ? "font-semibold text-vxn-ink" : "text-muted-foreground"
                )}
              >
                {label}
              </span>
            </span>
          </li>
        );
      })}
    </ol>
  );
}

/** Thẻ trắng ở giữa trang (Figma 01, 02, 04). */
export function RegisterCard({ children, className }: { children: ReactNode; className?: string }) {
  return (
    <section className={cn("flex w-full max-w-[560px] flex-col gap-4 rounded-2xl border bg-card p-6 shadow-xs", className)}>
      {children}
    </section>
  );
}
