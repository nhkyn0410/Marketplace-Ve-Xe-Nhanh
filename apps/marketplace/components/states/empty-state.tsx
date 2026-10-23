import { cn } from "@vexenhanh/ui/lib/utils";
import { Inbox, type LucideIcon } from "lucide-react";
import type { ReactNode } from "react";

/**
 * Thuộc tính của component hiển thị trạng thái rỗng.
 */
export interface EmptyStateProps {
  readonly title?: string;
  readonly description?: string;
  readonly icon?: LucideIcon;
  readonly action?: ReactNode;
  readonly className?: string;
}

/**
 * Hiển thị khối giao diện trạng thái rỗng khi không có kết quả hoặc không có dữ liệu.
 */
export function EmptyState({
  title = "Không có dữ liệu",
  description = "Hiện tại chưa có dữ liệu nào để hiển thị trong mục này.",
  icon: Icon = Inbox,
  action,
  className
}: EmptyStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center rounded-2xl border border-vxn-border/60 bg-muted/20 px-6 py-16 text-center",
        className
      )}
    >
      <div className="mb-4 flex size-14 items-center justify-center rounded-full bg-muted text-vxn-fg-4">
        <Icon className="size-7" />
      </div>
      <h2 className="text-xl font-bold text-vxn-ink sm:text-2xl">{title}</h2>
      <p className="mt-2 max-w-md text-sm text-vxn-fg-3">{description}</p>
      {action && <div className="mt-6 flex items-center justify-center">{action}</div>}
    </div>
  );
}
