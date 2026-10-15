"use client";

import { cn } from "@vexenhanh/ui/lib/utils";
import type { MouseEvent } from "react";

// Ô tìm / ô lọc / bảng dùng chung nằm ở `packages/ui` (cổng Admin dùng cùng); file này giữ phần riêng của điểm dừng.
export * from "@vexenhanh/ui/components/list-controls";

/**
 * Thuộc tính của một dòng điểm dừng. Khi bản đồ tổng quan đang mở (`onLocate` có giá trị), bấm vào dòng thì
 * bản đồ chuyển tới điểm đó — trừ khi bấm trúng một nút trong dòng; dòng của điểm đang chọn được tô nền.
 */
export function locatableRow(id: string, selectedId: string | null, onLocate?: (id: string) => void) {
  return {
    className: cn(
      "h-[76px] border-b",
      onLocate && "cursor-pointer hover:bg-muted/50",
      onLocate && id === selectedId && "bg-accent hover:bg-accent"
    ),
    onClick: onLocate
      ? (event: MouseEvent<HTMLTableRowElement>) => {
          if (!(event.target as Element).closest("button, a")) {
            onLocate(id);
          }
        }
      : undefined
  };
}

/**
 * Tên điểm dừng trong bảng. Khi bản đồ tổng quan đang mở thì tên là một nút, để dùng bàn phím cũng đưa được
 * bản đồ tới điểm đó (bấm vào dòng chỉ dùng được bằng chuột).
 */
export function LocatableName({
  id,
  name,
  className,
  onLocate
}: {
  id: string;
  name: string;
  className?: string;
  onLocate?: (id: string) => void;
}) {
  if (!onLocate) {
    return <span className={className}>{name}</span>;
  }
  return (
    <button
      type="button"
      aria-label={`Xem ${name} trên bản đồ`}
      className={cn(
        "max-w-full cursor-pointer self-start rounded text-left underline-offset-2 outline-none hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50",
        className
      )}
      onClick={() => onLocate(id)}
    >
      {name}
    </button>
  );
}
