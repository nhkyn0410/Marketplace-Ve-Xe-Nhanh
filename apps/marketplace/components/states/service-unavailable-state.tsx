import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { ArrowLeft, Clock, Hourglass, RotateCcw } from "lucide-react";
import Link from "next/link";

/**
 * Thuộc tính của component ServiceUnavailableState (Lỗi 503).
 */
export interface ServiceUnavailableStateProps {
  readonly title?: string;
  readonly description?: string;
  readonly countdownSeconds?: number;
  readonly onRetry?: () => void;
  readonly className?: string;
}

/**
 * Hiển thị giao diện Lỗi 503 theo thiết kế khung Figma 1449:21999 (SCR-PSG-05).
 */
export function ServiceUnavailableState({
  title = "Dịch vụ giữ chỗ đang tạm gián đoạn",
  description = "Chưa có chỗ nào được giữ ở bước này. Vui lòng thử lại sau 30 giây; trong lúc đó bạn vẫn có thể xem thông tin chuyến.",
  countdownSeconds = 30,
  onRetry,
  className
}: ServiceUnavailableStateProps) {
  const formattedCountdown = `00:${String(countdownSeconds).padStart(2, "0")}`;

  return (
    <div className={cn("flex flex-1 flex-col items-center justify-center px-4 py-16 text-center", className)}>
      <div className="mb-5 flex size-20 items-center justify-center rounded-full bg-amber-50 text-amber-600">
        <Hourglass className="size-9 stroke-[2.2]" />
      </div>

      <span className="text-xs font-semibold uppercase tracking-wider text-vxn-fg-4">
        LỖI 503
      </span>

      <h1 className="mt-2 text-2xl font-bold text-vxn-ink sm:text-3xl">
        {title}
      </h1>

      <p className="mt-3 max-w-lg text-sm leading-relaxed text-vxn-fg-3">
        {description}
      </p>

      <div className="mt-5 inline-flex items-center gap-2 rounded-full border border-amber-200 bg-amber-50/80 px-4 py-1.5 text-xs text-amber-800">
        <Clock className="size-3.5 text-amber-600" />
        <span>Tự thử lại sau</span>
        <span className="font-bold text-amber-900">{formattedCountdown}</span>
      </div>

      <div className="mt-8 flex flex-wrap items-center justify-center gap-3">
        <Button
          asChild
          variant="outline"
          className="h-10.5 rounded-lg border-vxn-border bg-white px-5 text-vxn-ink hover:bg-vxn-bg-2"
        >
          <Link href="/trips">
            <ArrowLeft className="mr-2 size-4" />
            Xem lại chuyến
          </Link>
        </Button>
        <Button
          onClick={onRetry}
          className="h-10.5 rounded-lg bg-vxn-teal-700 px-5 text-white hover:bg-vxn-teal-800"
        >
          <RotateCcw className="mr-2 size-4" />
          Thử lại ngay
        </Button>
      </div>
    </div>
  );
}
