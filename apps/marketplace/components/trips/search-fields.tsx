"use client";

import { CalendarDays, Check, ChevronDown, ChevronLeft, ChevronRight } from "lucide-react";
import { useId, useState, type FocusEvent, type KeyboardEvent, type ReactNode } from "react";
import { formatTripDateVi } from "../../lib/format";

/** Kiểu ô dùng chung cho form tìm chuyến (trang chủ + trang /trips). */
export const SEARCH_FIELD = "relative min-w-0 rounded-xl border border-slate-200 bg-white px-4 py-2.5 transition focus-within:border-[#00506a]";
export const SEARCH_LABEL = "block text-xs font-medium text-slate-500";
const VALUE_BOX = "mt-0.5 block w-full truncate bg-transparent text-left text-sm outline-none";
export const SEARCH_VALUE = `${VALUE_BOX} font-semibold text-slate-700`;
/** Chữ gợi ý khi ô chưa có giá trị. */
export const SEARCH_VALUE_EMPTY = `${VALUE_BOX} text-slate-400`;
export const PLACE_INPUT = `${SEARCH_VALUE} placeholder:font-normal placeholder:text-slate-400`;
export const PLACE_PLACEHOLDER = "Tỉnh, phường/xã, bến xe";

/** Số hành khách tối đa mỗi lần tìm. */
export const PASSENGER_OPTIONS = Array.from({ length: 10 }, (_, index) => ({ value: String(index + 1), label: `${index + 1} hành khách` }));

/** Hướng mở danh sách: trang chủ mở lên trên (hero cắt phần tràn đáy), trang /trips mở xuống dưới. */
export type PopoverPlacement = "top" | "bottom";

const PLACEMENT_CLASS: Record<PopoverPlacement, string> = {
  top: "bottom-[calc(100%+10px)]",
  bottom: "top-[calc(100%+10px)]"
};
const WEEKDAYS = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

function iso(year: number, month: number, day: number): string {
  return `${year}-${String(month + 1).padStart(2, "0")}-${String(day).padStart(2, "0")}`;
}

/** Ngày hôm nay theo giờ máy người dùng, dạng `YYYY-MM-DD`. */
function todayIso(): string {
  const now = new Date();
  return iso(now.getFullYear(), now.getMonth(), now.getDate());
}

/**
 * Khung ô + popover dùng chung: bấm ô thì mở/đóng, Esc hoặc bấm ra ngoài thì đóng. Popover bo 4 góc; thanh cuộn nằm
 * trong lớp trong để không đè góc bo.
 */
function PopoverField({ label, valueText, isEmpty, icon, placement, onOpen, className, popupLabel, children }: {
  readonly label: string;
  readonly valueText: string;
  readonly isEmpty: boolean;
  readonly icon: ReactNode;
  readonly placement: PopoverPlacement;
  readonly onOpen?: () => void;
  readonly className: string;
  readonly popupLabel: string;
  readonly children: (close: () => void) => ReactNode;
}) {
  const popupId = useId();
  const [open, setOpen] = useState(false);
  const close = () => setOpen(false);

  return (
    <div
      className={`relative min-w-0 ${className}`}
      onBlur={(e: FocusEvent<HTMLDivElement>) => {
        if (!e.currentTarget.contains(e.relatedTarget)) close();
      }}
      onKeyDown={(e: KeyboardEvent<HTMLDivElement>) => {
        if (e.key === "Escape") close();
      }}
    >
      {open && (
        <div
          id={popupId}
          role="dialog"
          aria-label={popupLabel}
          className={`absolute left-0 z-30 w-max min-w-full max-w-[min(26rem,calc(100vw-2rem))] overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-2xl ${PLACEMENT_CLASS[placement]}`}
        >
          {children(close)}
        </div>
      )}
      <button
        type="button"
        aria-haspopup="dialog"
        aria-expanded={open}
        aria-controls={open ? popupId : undefined}
        onClick={() => {
          if (!open) onOpen?.();
          setOpen(!open);
        }}
        className={`${SEARCH_FIELD} w-full cursor-pointer pr-9 text-left ${open ? "border-[#00506a]" : "hover:border-[#00506a]"}`}
      >
        <span className={SEARCH_LABEL}>{label}</span>
        <span className={isEmpty ? SEARCH_VALUE_EMPTY : SEARCH_VALUE}>{valueText}</span>
        <span className={`absolute top-1/2 right-3 -translate-y-1/2 text-slate-400 transition ${open ? "text-[#00506a]" : ""}`}>{icon}</span>
      </button>
    </div>
  );
}

/**
 * Ô chọn một giá trị (tuyến đường, số hành khách) — thay `<select>` gốc vì danh sách của trình duyệt lệch hẳn giao diện.
 */
export function ChoiceField({ label, options, value, onChange, onOpen, placement = "top", className = "" }: {
  readonly label: string;
  readonly options: readonly { readonly value: string; readonly label: string }[];
  readonly value: string;
  readonly onChange: (value: string) => void;
  readonly onOpen?: () => void;
  readonly placement?: PopoverPlacement;
  readonly className?: string;
}) {
  const selected = options.find((option) => option.value === value) ?? options[0];

  return (
    <PopoverField
      label={label}
      valueText={selected?.label ?? ""}
      isEmpty={false}
      icon={<ChevronDown className="h-4 w-4" />}
      placement={placement}
      onOpen={onOpen}
      className={className}
      popupLabel={label}
    >
      {(close) => (
        <ul role="listbox" aria-label={label} className="max-h-[23.5rem] overflow-y-auto p-2">
          {options.map((option) => (
            <li key={option.value} role="option" aria-selected={option.value === value}>
              <button
                type="button"
                onClick={() => {
                  onChange(option.value);
                  close();
                }}
                className={`flex w-full items-center justify-between gap-2 rounded-xl px-3 py-2 text-left text-sm transition hover:bg-[#eef6f9] ${
                  option.value === value ? "bg-[#eef6f9] font-semibold text-[#00506a]" : "text-slate-700"
                }`}
              >
                <span className="truncate">{option.label}</span>
                {option.value === value && <Check className="h-4 w-4 shrink-0" />}
              </button>
            </li>
          ))}
        </ul>
      )}
    </PopoverField>
  );
}

/**
 * Ô Ngày đi: hiện "T6, 16/10/2026", bấm mở lịch tháng cùng kiểu các popover khác (thay lịch gốc của trình duyệt).
 * Không chọn được ngày đã qua.
 */
export function DateField({ value, onChange, onOpen, placement = "top", className = "" }: {
  readonly value: string;
  readonly onChange: (value: string) => void;
  readonly onOpen?: () => void;
  readonly placement?: PopoverPlacement;
  readonly className?: string;
}) {
  return (
    <PopoverField
      label="Ngày đi"
      valueText={value ? formatTripDateVi(value) : "Chọn ngày"}
      isEmpty={!value}
      icon={<CalendarDays className="h-4 w-4" />}
      placement={placement}
      onOpen={onOpen}
      className={className}
      popupLabel="Chọn ngày đi"
    >
      {(close) => (
        <MonthCalendar
          value={value}
          onSelect={(date) => {
            onChange(date);
            close();
          }}
        />
      )}
    </PopoverField>
  );
}

/** Lịch một tháng, tuần bắt đầu từ thứ Hai; chỉ render khi popover mở nên "hôm nay" luôn là giờ máy người dùng. */
function MonthCalendar({ value, onSelect }: { readonly value: string; readonly onSelect: (date: string) => void }) {
  const today = todayIso();
  const start = value || today;
  const [view, setView] = useState({ year: Number(start.slice(0, 4)), month: Number(start.slice(5, 7)) - 1 });

  const firstWeekday = (new Date(view.year, view.month, 1).getDay() + 6) % 7;
  const daysInMonth = new Date(view.year, view.month + 1, 0).getDate();
  // Luôn đủ 6 hàng (42 ô) để lịch không đổi chiều cao khi chuyển tháng.
  const cells = Array.from({ length: 42 }, (_, index) => {
    const day = index - firstWeekday + 1;
    return day >= 1 && day <= daysInMonth ? day : null;
  });
  // Không lùi về tháng trước tháng hiện tại (toàn ngày đã qua).
  const canGoBack = iso(view.year, view.month, 1) > `${today.slice(0, 7)}-01`;
  const shift = (delta: number) => {
    const next = new Date(view.year, view.month + delta, 1);
    setView({ year: next.getFullYear(), month: next.getMonth() });
  };
  const navButton = "inline-flex h-8 w-8 items-center justify-center rounded-full text-slate-500 transition hover:bg-[#eef6f9] hover:text-[#00506a] disabled:pointer-events-none disabled:opacity-30";

  return (
    <div className="w-[296px] p-3">
      <div className="mb-2 flex items-center justify-between px-1">
        <button type="button" aria-label="Tháng trước" disabled={!canGoBack} onClick={() => shift(-1)} className={navButton}>
          <ChevronLeft className="h-4 w-4" />
        </button>
        <span className="text-sm font-semibold text-slate-700">
          Tháng {view.month + 1}, {view.year}
        </span>
        <button type="button" aria-label="Tháng sau" onClick={() => shift(1)} className={navButton}>
          <ChevronRight className="h-4 w-4" />
        </button>
      </div>
      <div className="grid grid-cols-7 gap-1 text-center">
        {WEEKDAYS.map((weekday) => (
          <span key={weekday} className="py-1 text-[11px] font-semibold text-slate-400">
            {weekday}
          </span>
        ))}
        {cells.map((day, index) => {
          if (day === null) return <span key={`blank-${index}`} className="h-9" />;
          const date = iso(view.year, view.month, day);
          const isPast = date < today;
          const isSelected = date === value;
          return (
            <button
              key={date}
              type="button"
              disabled={isPast}
              aria-pressed={isSelected}
              aria-label={formatTripDateVi(date)}
              onClick={() => onSelect(date)}
              className={`h-9 rounded-xl text-sm transition disabled:cursor-not-allowed disabled:text-slate-300 ${
                isSelected
                  ? "bg-[#00506a] font-semibold text-white"
                  : date === today
                    ? "font-semibold text-[#00506a] ring-1 ring-[#00506a]/40 hover:bg-[#eef6f9]"
                    : "text-slate-700 hover:bg-[#eef6f9]"
              }`}
            >
              {day}
            </button>
          );
        })}
      </div>
    </div>
  );
}
