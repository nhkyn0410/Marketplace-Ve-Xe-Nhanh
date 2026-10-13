"use client";

import { Input } from "@vexenhanh/ui/components/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue
} from "@vexenhanh/ui/components/select";
import { Skeleton } from "@vexenhanh/ui/components/skeleton";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Search } from "lucide-react";
import { useEffect, useId, useState, type MouseEvent } from "react";

/** Giá trị "không lọc" của các ô lọc. */
export const ALL = "ALL";

const CONTROL_LABEL = "text-xs leading-[18px] font-medium text-muted-foreground";

/** Giá trị đi sau người gõ: chỉ đổi khi đã ngừng gõ `delay` ms, để ô tìm không gọi API theo từng phím. */
export function useDebouncedValue<T>(value: T, delay = 300): T {
  const [debounced, setDebounced] = useState(value);
  useEffect(() => {
    const timer = setTimeout(() => setDebounced(value), delay);
    return () => clearTimeout(timer);
  }, [value, delay]);
  return debounced;
}

/** Ô tìm theo tên hoặc địa chỉ, có nhãn phía trên để cao bằng các ô lọc (Figma "VXN / Search field"). */
export function SearchField({
  value,
  onChange,
  className
}: {
  value: string;
  onChange: (value: string) => void;
  className?: string;
}) {
  const id = useId();
  return (
    <div className={cn("flex min-w-[220px] flex-1 flex-col gap-1.5", className)}>
      <label htmlFor={id} className={CONTROL_LABEL}>
        Tìm kiếm
      </label>
      <div className="relative">
        <Search className="pointer-events-none absolute top-3 left-3 size-4 text-muted-foreground" aria-hidden />
        <Input
          id={id}
          type="search"
          value={value}
          onChange={(event) => onChange(event.target.value)}
          maxLength={100}
          placeholder="Tìm theo tên hoặc địa chỉ"
          autoComplete="off"
          className="pl-9"
        />
      </div>
    </div>
  );
}

/** Ô lọc một lựa chọn, mục đầu là "Tất cả …" (Figma "VXN / Filter"). */
export function FilterSelect({
  label,
  allLabel,
  value,
  onChange,
  options,
  disabled,
  className
}: {
  label: string;
  allLabel: string;
  value: string;
  onChange: (value: string) => void;
  options: { value: string; label: string }[];
  disabled?: boolean;
  className?: string;
}) {
  const id = useId();
  return (
    <div className={cn("flex w-52 flex-col gap-1.5", className)}>
      <label htmlFor={id} className={CONTROL_LABEL}>
        {label}
      </label>
      <Select value={value} onValueChange={onChange} disabled={disabled}>
        <SelectTrigger id={id}>
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value={ALL}>{allLabel}</SelectItem>
          {options.map((option) => (
            <SelectItem key={option.value} value={option.value}>
              {option.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </div>
  );
}

/** Khung chờ của bảng: thanh tiêu đề và vài dòng xương. */
export function TableSkeleton({ label, rows = 6 }: { label: string; rows?: number }) {
  return (
    <div role="status" aria-label={label} className="flex flex-col">
      <div className="h-11 rounded-lg bg-muted" />
      {Array.from({ length: rows }, (_, row) => (
        <div key={row} className="flex h-[76px] items-center gap-6 border-b px-4">
          <div className="flex flex-1 flex-col gap-2.5">
            <Skeleton className="h-4 w-2/5" />
            <Skeleton className="h-2.5 w-3/5" />
          </div>
          <Skeleton className="h-4 w-[16%]" />
          <Skeleton className="h-4 w-[14%]" />
          <Skeleton className="h-4 w-[10%]" />
        </div>
      ))}
    </div>
  );
}

/** Kiểu nút tab cỡ chữ thường (Figma "VXN / Tabs item"): tab đang mở nền trắng, chữ đậm. */
export const TAB_TRIGGER =
  "h-8 flex-none px-3 text-sm leading-5 data-[state=active]:font-semibold data-[state=active]:text-vxn-fg-1 data-[state=active]:shadow-sm";

/** Kiểu chung của bảng danh sách: ô tiêu đề nền xám bo hai đầu, dòng cách nhau bằng đường kẻ. */
export const TABLE = "w-full table-fixed border-collapse text-left";
export const TABLE_HEAD_ROW = "h-11 text-xs leading-[18px] text-muted-foreground";
export const TABLE_HEAD_CELL = "bg-muted pr-3 font-medium first:rounded-l-lg first:pl-4 last:rounded-r-lg";
export const TABLE_CELL = "py-3.5 pr-3 align-middle text-sm leading-5 text-vxn-fg-1 first:pl-4";

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
