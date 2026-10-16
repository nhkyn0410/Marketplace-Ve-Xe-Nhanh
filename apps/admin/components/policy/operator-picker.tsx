"use client";

import { useQuery } from "@tanstack/react-query";
import { Input } from "@vexenhanh/ui/components/input";
import { useDebouncedValue } from "@vexenhanh/ui/components/list-controls";
import { cn } from "@vexenhanh/ui/lib/utils";
import { Check, Search, X } from "lucide-react";
import { useState } from "react";

import { listOperatorOptions, type OperatorOption } from "../../lib/policy/policy-api";

/**
 * Ô chọn nhà xe có tìm kiếm (tên / mã). `platformLabel`: thêm lựa chọn "mặc định nền tảng" (giá trị `null`) — dùng cho
 * phạm vi chính sách hủy / hoàn tiền.
 */
export function OperatorPicker({
  id,
  value,
  onChange,
  disabled,
  platformLabel,
  invalid
}: {
  id?: string;
  value: OperatorOption | null;
  onChange: (value: OperatorOption | null) => void;
  disabled?: boolean;
  platformLabel?: string;
  invalid?: boolean;
}) {
  const [search, setSearch] = useState("");
  const q = useDebouncedValue(search.trim());
  const options = useQuery({ queryKey: ["admin-operator-options", q], queryFn: () => listOperatorOptions(q), enabled: !disabled });
  const choices: (OperatorOption | null)[] = [...(platformLabel ? [null] : []), ...(options.data ?? []).slice(0, 6)];

  return (
    <div className={cn("flex flex-col gap-2 rounded-md border p-2", invalid && "border-error-500")}>
      <div className="relative">
        <Search className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted-foreground" aria-hidden />
        <Input
          id={id}
          type="search"
          value={search}
          disabled={disabled}
          placeholder="Tìm tên hoặc mã nhà xe"
          aria-label="Tìm nhà xe"
          className="pl-9"
          onChange={(event) => setSearch(event.target.value)}
        />
      </div>
      <ul role="listbox" aria-label="Nhà xe" className="flex max-h-56 flex-col gap-0.5 overflow-y-auto">
        {choices.map((choice) => {
          const selected = choice === null ? value === null : value?.id === choice.id;
          return (
            <li key={choice?.id ?? "platform"}>
              <button
                type="button"
                role="option"
                aria-selected={selected}
                disabled={disabled}
                onClick={() => onChange(choice)}
                className={cn(
                  "flex w-full items-center gap-3 rounded-md px-3 py-2 text-left text-sm hover:bg-muted",
                  selected && "bg-accent text-accent-foreground"
                )}
              >
                <span className="min-w-0 flex-1">
                  <span className="block truncate font-medium">{choice ? choice.name : platformLabel}</span>
                  {choice && <span className="block text-xs text-muted-foreground">{choice.slug}</span>}
                </span>
                {selected && <Check className="size-4 shrink-0" />}
              </button>
            </li>
          );
        })}
        {options.isSuccess && options.data.length === 0 && (
          <li className="px-3 py-2 text-sm text-muted-foreground">Không có nhà xe phù hợp.</li>
        )}
      </ul>
      {value && !choices.some((choice) => choice?.id === value.id) && (
        <p className="flex items-center gap-2 px-1 text-sm">
          Đã chọn: <strong className="truncate">{value.name}</strong>
          <button type="button" aria-label="Bỏ chọn nhà xe" disabled={disabled} onClick={() => onChange(null)}>
            <X className="size-4" />
          </button>
        </p>
      )}
    </div>
  );
}
