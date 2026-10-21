import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { AlertCircle, Clock, Home } from "lucide-react";
import Link from "next/link";
import type { ReactNode } from "react";

/**
 * Thuộc tính cấu hình cho component thông báo chức năng chưa sẵn sàng (bản đầy đủ).
 */
export interface FeatureUnavailableProps {
  readonly title?: string;
  readonly endpoint?: string;
  readonly description?: string;
  readonly action?: ReactNode;
  readonly className?: string;
}

/**
 * Hiển thị khối thông báo chức năng chưa sẵn sàng cho vùng nội dung chính.
 */
export function FeatureUnavailable({
  title = "Chức năng chưa sẵn sàng",
  description = "Chức năng này hiện chưa khả dụng. Vui lòng quay lại sau.",
  action,
  className
}: FeatureUnavailableProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center rounded-2xl border border-vxn-teal-100 bg-vxn-teal-50/40 px-6 py-16 text-center",
        className
      )}
    >
      <div className="mb-4 flex size-14 items-center justify-center rounded-full bg-vxn-teal-100 text-vxn-teal-700">
        <Clock className="size-7" />
      </div>
      <h2 className="text-xl font-bold text-vxn-ink sm:text-2xl">{title}</h2>
      <p className="mt-2 max-w-md text-sm text-vxn-fg-3">{description}</p>
      <div className="mt-6 flex flex-wrap items-center justify-center gap-3">
        {action ?? (
          <Button asChild className="rounded bg-vxn-teal-600 text-white hover:bg-vxn-teal-700">
            <Link href="/">
              <Home className="mr-2 size-4" />
              Về trang chủ
            </Link>
          </Button>
        )}
      </div>
    </div>
  );
}

/**
 * Thuộc tính cấu hình cho component thông báo chức năng chưa sẵn sàng (bản gọn).
 */
export interface FeatureUnavailableCompactProps {
  readonly title?: string;
  readonly endpoint?: string;
  readonly className?: string;
}

/**
 * Hiển thị khối thông báo chức năng chưa sẵn sàng bản gọn cho các khối phụ.
 */
export function FeatureUnavailableCompact({
  title = "Dữ liệu chưa sẵn sàng",
  className
}: FeatureUnavailableCompactProps) {
  return (
    <div
      className={cn(
        "flex items-center justify-center gap-3 rounded-lg border border-dashed border-vxn-teal-200 bg-vxn-teal-50/30 p-4 text-center text-sm text-vxn-fg-4",
        className
      )}
    >
      <AlertCircle className="size-4 shrink-0 text-vxn-saffron-500" />
      <span>{title}</span>
    </div>
  );
}
