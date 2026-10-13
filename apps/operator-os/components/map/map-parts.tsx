import { Button } from "@vexenhanh/ui/components/button";
import { cn } from "@vexenhanh/ui/lib/utils";
import { ChevronDown, ChevronRight } from "lucide-react";

import { MARKER_KIND_CLASS, type MapLegendItem, type MarkerKind } from "../../lib/map/stop-map";
import { BUTTON } from "../list-parts";

/** Chấm màu của một điểm dừng trên bản đồ (Figma "VXN / Map marker"). */
export function MapDot({ kind, className }: { kind: MarkerKind; className?: string }) {
  return (
    <span
      className={cn("block size-[22px] rounded-full border-[3px] border-card shadow-md", MARKER_KIND_CLASS[kind], className)}
    />
  );
}

/** Chú giải màu ghim. */
export function MapLegend({ items, className }: { items: readonly MapLegendItem[]; className?: string }) {
  return (
    <ul aria-label="Chú giải bản đồ" className={cn("flex flex-wrap items-center gap-x-4 gap-y-1", className)}>
      {items.map((item) => (
        <li key={item.label} className="flex items-center gap-1.5 text-xs leading-[18px] text-muted-foreground">
          <span className={cn("size-2 shrink-0 rounded-full", MARKER_KIND_CLASS[item.kind])} aria-hidden />
          {item.label}
        </li>
      ))}
    </ul>
  );
}

/** Nút mở / thu gọn một khối bản đồ. `controls` là id của vùng chứa bản đồ. */
export function MapToggle({
  open,
  controls,
  onToggle
}: {
  open: boolean;
  controls: string;
  onToggle: (open: boolean) => void;
}) {
  const Icon = open ? ChevronDown : ChevronRight;
  return (
    <Button
      type="button"
      variant="ghost"
      className={`${BUTTON} ml-auto shrink-0 text-vxn-fg-1`}
      aria-expanded={open}
      aria-controls={controls}
      onClick={() => onToggle(!open)}
    >
      <Icon className="size-[18px]" />
      {open ? "Ẩn bản đồ" : "Hiện bản đồ"}
    </Button>
  );
}
