"use client";

import { Input } from "@vexenhanh/ui/components/input";
import { useId } from "react";

/** Hai ô ngày "Từ ngày" / "Đến ngày" của bộ lọc kỳ (giờ VN, `YYYY-MM-DD`). */
export function PeriodFields({ value, onChange }: { value: { from: string; to: string }; onChange: (next: { from: string; to: string }) => void }) {
  return (
    <>
      <DateField label="Từ ngày" value={value.from} onChange={(from) => onChange({ ...value, from })} />
      <DateField label="Đến ngày" value={value.to} onChange={(to) => onChange({ ...value, to })} />
    </>
  );
}

function DateField({ label, value, onChange }: { label: string; value: string; onChange: (value: string) => void }) {
  const id = useId();
  return (
    <div className="flex w-40 flex-col gap-1.5">
      <label htmlFor={id} className="text-xs leading-[18px] font-medium text-muted-foreground">
        {label}
      </label>
      <Input id={id} type="date" value={value} onChange={(event) => onChange(event.target.value)} />
    </div>
  );
}
