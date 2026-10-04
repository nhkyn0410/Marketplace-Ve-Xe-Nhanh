"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@vexenhanh/ui/components/tabs";
import { cn } from "@vexenhanh/ui/lib/utils";

import type { Seat, SeatMap, SeatType } from "../../lib/vehicle/vehicle-api";

const DOUBLE_TYPES: SeatType[] = ["BED_DOUBLE", "CABIN_DOUBLE"];

const SEAT_TYPE_LABELS: Record<SeatType, string> = {
  SEAT: "Ghế",
  BED: "Giường đơn",
  BED_DOUBLE: "Giường đôi",
  CABIN: "Cabin đơn",
  CABIN_DOUBLE: "Cabin đôi"
};

/** Xem trước sơ đồ ghế theo từng tầng (chỉ đọc) trong form xe — Figma "Sơ đồ ghế / Preview". */
export function SeatMapPreview({ seatMap }: { seatMap: SeatMap }) {
  const decks = seatMap.layout.decks;
  return (
    <Tabs defaultValue="1" className="gap-5">
      {decks.length > 1 && (
        <TabsList aria-label="Tầng của sơ đồ">
          {decks.map(({ deck }) => (
            <TabsTrigger key={deck} value={String(deck)}>
              Tầng {deck} · {seatMap.seats.filter((seat) => seat.deck === deck).length} chỗ
            </TabsTrigger>
          ))}
        </TabsList>
      )}
      {decks.map(({ deck, rows, columns }) => (
        <TabsContent key={deck} value={String(deck)} className="flex flex-col items-center gap-3">
          <div className="flex h-9 w-full items-center justify-center rounded-lg bg-muted text-xs leading-[18px] font-medium text-muted-foreground">
            ĐẦU XE
          </div>
          <DeckGrid deck={deck} rows={rows} columns={columns} seats={seatMap.seats} />
        </TabsContent>
      ))}
    </Tabs>
  );
}

function DeckGrid({ deck, rows, columns, seats }: { deck: number; rows: number; columns: number; seats: Seat[] }) {
  const byPosition = new Map(
    seats.filter((seat) => seat.deck === deck).map((seat) => [`${seat.row}:${seat.column}`, seat])
  );
  return (
    // Bảng chỉ để đọc: mỗi hàng căn giữa như xe thật; chỗ đôi là một ô vẽ rộng hơn (UX-OQ-03).
    <div role="img" aria-label={`Bố cục tầng ${deck}: ${byPosition.size} chỗ`} className="flex flex-col gap-3">
      {Array.from({ length: rows }, (_, rowIndex) => (
        <div key={rowIndex} className="flex items-center justify-center gap-3">
          {Array.from({ length: columns }, (_, columnIndex) => {
            const seat = byPosition.get(`${rowIndex + 1}:${columnIndex + 1}`);
            if (!seat) {
              return <span key={columnIndex} className="h-[54px] w-9" />;
            }
            const double = DOUBLE_TYPES.includes(seat.type);
            return (
              <span
                key={columnIndex}
                title={`${seat.code} · ${SEAT_TYPE_LABELS[seat.type]}`}
                className={cn(
                  "flex h-[54px] flex-col items-center justify-center rounded-lg border bg-accent text-xs leading-[18px] font-medium text-accent-foreground",
                  double ? "w-[84px]" : "w-9"
                )}
              >
                {seat.code}
                {double && <span className="font-normal text-muted-foreground">Đôi</span>}
              </span>
            );
          })}
        </div>
      ))}
    </div>
  );
}
