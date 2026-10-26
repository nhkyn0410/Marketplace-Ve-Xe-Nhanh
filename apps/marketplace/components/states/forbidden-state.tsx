import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Home, Lock, LogIn } from "lucide-react";
import Link from "next/link";

/**
 * Thuộc tính cấu hình component ForbiddenState (Lỗi 403).
 */
export interface ForbiddenStateProps {
  readonly title?: string;
  readonly description?: string;
  readonly className?: string;
}

/**
 * Hiển thị giao diện Lỗi 403 theo thiết kế khung Figma 1449:21736 (SCR-PSG-05).
 */
export function ForbiddenState({
  title = "Bạn không có quyền xem nội dung này",
  description = "Nội dung thuộc về tài khoản khác hoặc phiên của bạn đã hết hạn. Hãy đăng nhập đúng tài khoản rồi thử lại.",
  className
}: ForbiddenStateProps) {
  return (
    <div className={cn("flex flex-1 flex-col items-center justify-center px-4 py-16 text-center", className)}>
      <div className="mb-5 flex size-20 items-center justify-center rounded-full bg-amber-50 text-amber-600">
        <Lock className="size-9 stroke-[2.2]" />
      </div>

      <span className="text-xs font-semibold uppercase tracking-wider text-vxn-fg-4">
        LỖI 403
      </span>

      <h1 className="mt-2 text-2xl/9 font-semibold tracking-[-0.24px] text-vxn-ink">
        {title}
      </h1>

      <p className="mt-3 max-w-lg text-sm leading-relaxed text-vxn-fg-3">
        {description}
      </p>

      <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
        <Button asChild className="h-10.5 rounded-lg bg-vxn-teal-700 px-5 text-white hover:bg-vxn-teal-800">
          <Link href="/">
            <Home className="mr-2 size-4" />
            Về trang chủ
          </Link>
        </Button>
        <Button
          asChild
          variant="outline"
          className="h-10.5 rounded-lg border-vxn-border bg-white px-5 text-vxn-ink hover:bg-vxn-bg-2"
        >
          <Link href="/login">
            <LogIn className="mr-2 size-4" />
            Đăng nhập
          </Link>
        </Button>
      </div>
    </div>
  );
}
