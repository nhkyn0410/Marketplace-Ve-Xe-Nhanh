"use client";

import { Badge } from "@vexenhanh/ui/components/badge";
import { cn } from "@vexenhanh/ui/lib/utils";

import {
  cellKey,
  seatCapacity,
  seatTypeInfo,
  type CellPosition,
  type EditorCell,
  type EditorDeck,
  type SeatSummary
} from "../../lib/seat-map/seat-map-editor";
import type { SeatType } from "../../lib/vehicle/vehicle-api";

// Cỡ ô theo Figma "Cabin components": chỗ đơn rộng 56, chỗ đôi rộng 96 (một ô lưới vẽ rộng hơn — UX-OQ-03).
const TILE_HEIGHT: Record<SeatType, string> = {
  SEAT: "h-14",
  BED: "h-[84px]",
  BED_DOUBLE: "h-[84px]",
  CABIN: "h-[84px]",
  CABIN_DOUBLE: "h-28"
};
const CABIN_TYPES: SeatType[] = ["CABIN", "CABIN_DOUBLE"];

/** Một tầng của sơ đồ: tiêu đề, số chỗ / sức chứa và lưới ô bấm được (Figma "Tầng N"). */
export function SeatMapDeck({
  deckIndex,
  deck,
  summary,
  selected,
  errors,
  readOnly,
  onSelect
}: {
  deckIndex: number;
  deck: EditorDeck;
  summary: SeatSummary;
  selected: CellPosition | null;
  /** Lỗi theo ô (khoá `cellKey`), để tô viền ô có mã chưa hợp lệ. */
  errors: Map<string, string>;
  readOnly: boolean;
  onSelect: (position: CellPosition) => void;
}) {
  // Cột có chỗ đôi thì cả cột rộng 96 để các hàng thẳng nhau.
  const wideColumns = Array.from({ length: deck.columns }, (_, column) =>
    deck.cells.some((cells) => cells[column] && seatCapacity(cells[column].type) === 2)
  );
  const headingId = `seat-map-deck-${deckIndex + 1}`;

  return (
    <section aria-labelledby={headingId} className="flex flex-col gap-4 rounded-xl border bg-card p-5">
      <div className="flex items-center gap-2">
        <h3 id={headingId} className="flex-1 text-base leading-6 font-semibold text-vxn-ink">
          Tầng {deckIndex + 1}
        </h3>
        <Badge>{summary.seatCount} chỗ</Badge>
        <Badge>{summary.passengerCapacity} người</Badge>
      </div>
      <div className="overflow-x-auto pb-1">
        <div className="mx-auto flex w-max min-w-full flex-col items-center gap-3">
          <div className="flex h-8 w-full items-center justify-center rounded-lg bg-muted text-xs leading-[18px] font-medium text-muted-foreground">
            ĐẦU XE
          </div>
          {deck.cells.map((cells, row) => (
            <div key={row} className="flex items-center justify-center gap-3">
              {cells.map((cell, column) => {
                const position = { deck: deckIndex, row, column };
                return (
                  <div
                    key={column}
                    className={cn("flex items-center justify-center", wideColumns[column] ? "w-24" : "w-14")}
                  >
                    <Cell
                      cell={cell}
                      position={position}
                      selected={
                        selected?.deck === deckIndex && selected.row === row && selected.column === column
                      }
                      invalid={errors.has(cellKey(position))}
                      readOnly={readOnly}
                      onSelect={onSelect}
                    />
                  </div>
                );
              })}
            </div>
          ))}
          <p className="flex h-7 items-center text-xs leading-[18px] text-muted-foreground">CUỐI XE</p>
        </div>
      </div>
      <p className="text-xs leading-[18px] text-muted-foreground">
        {summary.seatCount === 0
          ? "Tầng này chưa có chỗ nào."
          : `${summary.breakdown} · Tối đa ${summary.passengerCapacity} người`}
      </p>
    </section>
  );
}

function Cell({
  cell,
  position,
  selected,
  invalid,
  readOnly,
  onSelect
}: {
  cell: EditorCell;
  position: CellPosition;
  selected: boolean;
  invalid: boolean;
  readOnly: boolean;
  onSelect: (position: CellPosition) => void;
}) {
  const where = `tầng ${position.deck + 1}, hàng ${position.row + 1}, cột ${position.column + 1}`;
  if (!cell) {
    // Chế độ xem: ô trống chỉ là lối đi, không bấm được.
    if (readOnly) {
      return <span className="h-14 w-14" />;
    }
    return (
      <button
        type="button"
        aria-label={`Ô trống, ${where}`}
        aria-pressed={selected}
        onClick={() => onSelect(position)}
        className={cn(
          "h-14 w-14 rounded-lg border border-dashed border-transparent outline-none hover:border-vxn-border-strong hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50",
          selected && "border-primary bg-accent hover:border-primary hover:bg-accent"
        )}
      />
    );
  }
  const info = seatTypeInfo(cell.type);
  const double = info.capacity === 2;
  return (
    <button
      type="button"
      aria-label={`${cell.code || "Chưa có mã"}, ${info.label}, ${where}`}
      aria-pressed={selected}
      onClick={() => onSelect(position)}
      className={cn(
        "flex flex-col items-center justify-center gap-2 rounded-lg border bg-accent text-xs leading-[18px] outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50",
        double ? "w-24" : "w-14",
        TILE_HEIGHT[cell.type],
        invalid && "border-destructive",
        selected && "border-primary bg-primary"
      )}
    >
      {CABIN_TYPES.includes(cell.type) && (
        <span className="flex h-2 justify-center gap-1" aria-hidden>
          {Array.from({ length: info.capacity }, (_, pillow) => (
            <span
              key={pillow}
              className={cn("h-2 rounded-lg border bg-card", double ? "w-7" : "w-8", selected && "border-card")}
            />
          ))}
        </span>
      )}
      <span className={cn("font-medium", selected ? "text-primary-foreground" : "text-accent-foreground")}>
        {cell.code || "—"}
      </span>
      {double && <span className={selected ? "text-primary-foreground" : "text-muted-foreground"}>Đôi</span>}
    </button>
  );
}
