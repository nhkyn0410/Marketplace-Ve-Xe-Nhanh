import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { AlertTriangle, ArrowLeft, RotateCcw } from "lucide-react";
import type { ReactNode } from "react";

/**
 * Thuộc tính của component hiển thị trạng thái lỗi.
 */
export interface ErrorStateProps {
  readonly title?: string;
  readonly description?: string;
  readonly code?: string;
  readonly onRetry?: () => void;
  readonly onBack?: () => void;
  readonly action?: ReactNode;
  readonly className?: string;
}

/**
 * Hiển thị khối giao diện thông báo lỗi hệ thống hoặc lỗi tải dữ liệu.
 */
export function ErrorState({
  title = "Đã có lỗi xảy ra",
  description = "Hệ thống gặp sự cố khi xử lý yêu cầu. Vui lòng thử lại sau.",
  code,
  onRetry,
  onBack,
  action,
  className
}: ErrorStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center rounded-2xl border border-red-100 bg-red-50/30 px-6 py-16 text-center",
        className
      )}
    >
      <div className="mb-4 flex size-14 items-center justify-center rounded-full bg-red-100 text-red-600">
        <AlertTriangle className="size-7" />
      </div>
      <h2 className="text-xl font-bold text-vxn-ink sm:text-2xl">{title}</h2>
      <p className="mt-2 max-w-md text-sm text-vxn-fg-3">{description}</p>
      {code && (
        <code className="mt-3 rounded bg-white px-2.5 py-1 text-xs font-mono text-vxn-fg-4 border border-red-100">
          Mã lỗi: {code}
        </code>
      )}
      <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
        {action ?? (
          <>
            {onBack && (
              <Button
                variant="outline"
                onClick={onBack}
                className="rounded border-vxn-border hover:bg-muted"
              >
                <ArrowLeft className="mr-2 size-4" />
                Về trang trước
              </Button>
            )}
            {onRetry && (
              <Button
                onClick={onRetry}
                className="rounded bg-vxn-teal-600 text-white hover:bg-vxn-teal-700"
              >
                <RotateCcw className="mr-2 size-4" />
                Thử lại
              </Button>
            )}
          </>
        )}
      </div>
    </div>
  );
}
