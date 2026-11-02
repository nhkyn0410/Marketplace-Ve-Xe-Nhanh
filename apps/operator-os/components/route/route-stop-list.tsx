"use client";

import { Badge } from "@vexenhanh/ui/components/badge";
import { Input } from "@vexenhanh/ui/components/input";
import { Switch } from "@vexenhanh/ui/components/switch";
import { ArrowDown, ArrowUp, X } from "lucide-react";
import { useId, useState } from "react";

import {
  legMinutesOf,
  legOf,
  lockedFlags,
  parseLegMinutes,
  STOP_NOTE_MAX_LENGTH,
  stopKey,
  type DraftStop,
  type LegMinutes
} from "../../lib/route/route-form";
import { COMPUTED_ON_SAVE, formatDuration, legLabel } from "../../lib/route/route-format";
import { STOP_POINT_TYPE_LABELS } from "../../lib/stop-point/stop-point-format";

const ICON_BUTTON =
  "flex size-8 shrink-0 items-center justify-center rounded-lg text-muted-foreground outline-none hover:bg-muted focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-40";

/**
 * Danh sách điểm dừng theo thứ tự hành trình của form tuyến (Figma "VXN / Route stop item"): mỗi điểm có
 * công tắc cho đón / cho trả (khóa ở điểm đầu, điểm cuối và trạm dừng nghỉ — BR-79), nút đổi thứ tự / bỏ;
 * giữa hai điểm là số liệu chặng hệ thống tính (hoặc "Tính khi lưu") và ô số phút chạy thực tế nhà xe chỉnh được
 * (chờ duyệt 27/10/2026).
 */
export function RouteStopList({
  stops,
  legs,
  legMinutes,
  onMove,
  onRemove,
  onFlag,
  onNote,
  onLegMinutes
}: {
  stops: DraftStop[];
  legs: ReadonlyMap<string, { distanceMeters: number; durationSeconds: number }>;
  legMinutes: LegMinutes;
  onMove: (index: number, direction: -1 | 1) => void;
  onRemove: (index: number) => void;
  onFlag: (index: number, flag: "allowPickup" | "allowDropoff", value: boolean) => void;
  onNote: (index: number, note: string) => void;
  onLegMinutes: (index: number, value: string) => void;
}) {
  return (
    <ol aria-label="Điểm dừng của tuyến" className="flex flex-col gap-1.5">
      {stops.map((stop, index) => (
        <li key={stopKey(stop)} className="flex flex-col gap-1.5">
          {index > 0 && (
            <LegRow
              leg={legOf(legs, stops, index)}
              minutes={legMinutesOf(legMinutes, stops, index)}
              stopName={stop.name}
              position={index + 1}
              onMinutes={(value) => onLegMinutes(index, value)}
            />
          )}
          <RouteStopItem
            stop={stop}
            index={index}
            total={stops.length}
            onMove={(direction) => onMove(index, direction)}
            onRemove={() => onRemove(index)}
            onFlag={(flag, value) => onFlag(index, flag, value)}
            onNote={(note) => onNote(index, note)}
          />
        </li>
      ))}
    </ol>
  );
}

/**
 * Chặng tới một điểm: số hệ thống tính và ô số phút chạy thực tế. Ô trống = dùng số hệ thống; giờ đến của chuyến tính theo
 * tổng thời gian các chặng.
 */
function LegRow({
  leg,
  minutes,
  stopName,
  position,
  onMinutes
}: {
  leg: { distanceMeters: number; durationSeconds: number } | null;
  minutes: string;
  stopName: string;
  position: number;
  onMinutes: (value: string) => void;
}) {
  const inputId = useId();
  const edited = parseLegMinutes(minutes);
  return (
    <div className="flex flex-wrap items-center gap-x-2.5 gap-y-1 pl-[29px] text-xs leading-[18px] text-muted-foreground">
      <span className="h-6 w-0.5 bg-border" aria-hidden />
      <span>
        <span className="sr-only">Chặng tới điểm {position}: </span>
        {leg ? `${legLabel(leg.distanceMeters, leg.durationSeconds)} (hệ thống tính)` : COMPUTED_ON_SAVE}
      </span>
      <span className="flex items-center gap-1.5">
        <label htmlFor={inputId}>Chạy thực tế</label>
        <Input
          id={inputId}
          aria-label={`Thời gian chạy thực tế tới ${stopName}, số phút`}
          inputMode="numeric"
          value={minutes}
          onChange={(event) => onMinutes(event.target.value)}
          placeholder={leg ? String(Math.round(leg.durationSeconds / 60)) : "—"}
          maxLength={4}
          autoComplete="off"
          className="h-7 w-16 px-2 text-xs"
        />
        <span>phút{edited !== null && ` (${formatDuration(edited * 60)})`}</span>
      </span>
      {minutes !== "" && (
        <button
          type="button"
          onClick={() => onMinutes("")}
          className="rounded underline-offset-2 outline-none hover:text-vxn-fg-1 hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
        >
          Dùng số hệ thống
        </button>
      )}
    </div>
  );
}

function RouteStopItem({
  stop,
  index,
  total,
  onMove,
  onRemove,
  onFlag,
  onNote
}: {
  stop: DraftStop;
  index: number;
  total: number;
  onMove: (direction: -1 | 1) => void;
  onRemove: () => void;
  onFlag: (flag: "allowPickup" | "allowDropoff", value: boolean) => void;
  onNote: (note: string) => void;
}) {
  const pickupId = useId();
  const dropoffId = useId();
  const [editingNote, setEditingNote] = useState(false);
  const locked = lockedFlags(index, total, stop.type) !== null;
  const role = index === 0 ? "Điểm đầu" : index === total - 1 && total > 1 ? "Điểm cuối" : null;
  const source = stop.catalogStopPointId ? "Dùng chung" : "Của nhà xe";

  return (
    <div className="flex flex-wrap items-center gap-3 rounded-lg border bg-card px-4 py-3.5">
      <span
        className="flex size-7 shrink-0 items-center justify-center rounded-full bg-accent text-sm font-semibold text-vxn-teal-700"
        aria-hidden
      >
        {index + 1}
      </span>

      <div className="flex min-w-[200px] flex-1 flex-col gap-1">
        <div className="flex flex-wrap items-center gap-2">
          <span className="text-sm leading-5 font-semibold text-vxn-ink">
            <span className="sr-only">Điểm {index + 1}: </span>
            {stop.name}
          </span>
          {role && <Badge>{role}</Badge>}
        </div>
        <span className="text-xs leading-[18px] text-muted-foreground">{stop.address}</span>
        <span className="text-xs leading-[18px] font-medium text-vxn-teal-700">
          {STOP_POINT_TYPE_LABELS[stop.type]} · {source}
        </span>
        {editingNote ? (
          <Input
            aria-label={`Ghi chú cho ${stop.name}`}
            value={stop.note}
            onChange={(event) => onNote(event.target.value)}
            onBlur={() => setEditingNote(false)}
            onKeyDown={(event) => event.key === "Enter" && setEditingNote(false)}
            maxLength={STOP_NOTE_MAX_LENGTH}
            placeholder="Ví dụ: nghỉ 20 phút, đón tại cổng số 2"
            autoComplete="off"
            autoFocus
            className="mt-1 h-9"
          />
        ) : (
          <button
            type="button"
            onClick={() => setEditingNote(true)}
            aria-label={stop.note ? `Sửa ghi chú của ${stop.name}` : `Thêm ghi chú cho ${stop.name}`}
            className="w-fit rounded text-left text-xs leading-[18px] text-muted-foreground underline-offset-2 outline-none hover:text-vxn-fg-1 hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50"
          >
            {stop.note ? `Ghi chú: ${stop.note}` : "Thêm ghi chú"}
          </button>
        )}
      </div>

      <div className="flex shrink-0 flex-col gap-2">
        <div className="flex items-center gap-2">
          <Switch
            id={pickupId}
            checked={stop.allowPickup}
            disabled={locked}
            aria-label={`Cho đón tại ${stop.name}`}
            onCheckedChange={(value) => onFlag("allowPickup", value)}
          />
          <label htmlFor={pickupId} className="text-xs leading-[18px] text-vxn-fg-1">
            Cho đón
          </label>
        </div>
        <div className="flex items-center gap-2">
          <Switch
            id={dropoffId}
            checked={stop.allowDropoff}
            disabled={locked}
            aria-label={`Cho trả tại ${stop.name}`}
            onCheckedChange={(value) => onFlag("allowDropoff", value)}
          />
          <label htmlFor={dropoffId} className="text-xs leading-[18px] text-vxn-fg-1">
            Cho trả
          </label>
        </div>
      </div>

      <div className="flex shrink-0 items-center gap-0.5">
        <button
          type="button"
          className={ICON_BUTTON}
          disabled={index === 0}
          aria-label={`Chuyển ${stop.name} lên trước`}
          title="Chuyển lên"
          onClick={() => onMove(-1)}
        >
          <ArrowUp className="size-[18px]" />
        </button>
        <button
          type="button"
          className={ICON_BUTTON}
          disabled={index === total - 1}
          aria-label={`Chuyển ${stop.name} xuống sau`}
          title="Chuyển xuống"
          onClick={() => onMove(1)}
        >
          <ArrowDown className="size-[18px]" />
        </button>
        <button
          type="button"
          className={ICON_BUTTON}
          aria-label={`Bỏ ${stop.name} khỏi tuyến`}
          title="Bỏ khỏi tuyến"
          onClick={onRemove}
        >
          <X className="size-[18px]" />
        </button>
      </div>
    </div>
  );
}
