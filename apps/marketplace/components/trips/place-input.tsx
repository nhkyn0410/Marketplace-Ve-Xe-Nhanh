"use client";

import { Building2, History, LoaderCircle, MapPin, MapPinned } from "lucide-react";
import { useEffect, useId, useRef, useState } from "react";
import { getPlaceSuggestions, type PlaceSuggestion } from "../../lib/data/catalog";
import type { PlaceType } from "../../lib/data/trip-mappers";

/** Điểm đã chọn: gửi `type` + `id` vào tìm chuyến, `label` để hiện lại trên ô. */
export interface PlaceValue {
  readonly type: PlaceType;
  readonly id: string;
  readonly label: string;
}

export interface PlaceInputProps {
  readonly id: string;
  readonly label: string;
  readonly placeholder: string;
  readonly value: PlaceValue | null;
  readonly onChange: (value: PlaceValue | null) => void;
  readonly fieldClassName: string;
  readonly labelClassName: string;
  readonly inputClassName: string;
}

const DEBOUNCE_MS = 250;
const KIND_ICON = { PROVINCE: Building2, WARD: MapPinned, STOP_POINT: MapPin, LEGACY: History } as const;

/**
 * Ô nhập điểm đi / điểm đến có gợi ý (`GET /catalog/places`; tự thiết kế 27/10/2026, chờ duyệt): gõ tên tỉnh, phường /
 * xã, bến xe hoặc tên hành chính cũ (trước sáp nhập 2025 — hiện nhãn "Tên cũ" kèm đơn vị mới). Gõ lại sau khi đã chọn
 * thì bỏ lựa chọn cho tới khi chọn gợi ý mới. Bàn phím: ↑ / ↓ chọn, Enter xác nhận, Esc đóng.
 */
export function PlaceInput({ id, label, placeholder, value, onChange, fieldClassName, labelClassName, inputClassName }: PlaceInputProps) {
  const listId = useId();
  const [text, setText] = useState(value?.label ?? "");
  const [items, setItems] = useState<readonly PlaceSuggestion[]>([]);
  const [open, setOpen] = useState(false);
  const [active, setActive] = useState(-1);
  const [loading, setLoading] = useState(false);
  const [failed, setFailed] = useState(false);
  const request = useRef(0);

  // Ô đổi giá trị từ bên ngoài (đảo chiều, nạp lại từ URL) → hiện đúng tên mới.
  useEffect(() => {
    setText(value?.label ?? "");
  }, [value?.id, value?.label]);

  useEffect(() => {
    const q = text.trim();
    if (!open || q.length < 2 || q === value?.label) {
      setItems([]);
      setLoading(false);
      return;
    }
    const current = ++request.current;
    setLoading(true);
    const timer = setTimeout(() => {
      void getPlaceSuggestions(q).then((result) => {
        // Kết quả của lần gõ cũ về sau thì bỏ.
        if (current !== request.current) return;
        setLoading(false);
        setFailed(result.status !== "ok");
        setItems(result.status === "ok" ? result.data : []);
        setActive(result.status === "ok" && result.data.length > 0 ? 0 : -1);
      });
    }, DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [text, open, value?.label]);

  const choose = (item: PlaceSuggestion) => {
    onChange({ type: item.target.type, id: item.target.id, label: item.label });
    setText(item.label);
    setOpen(false);
  };

  const showList = open && text.trim().length >= 2 && text.trim() !== value?.label;

  return (
    <div className={`${fieldClassName} relative`}>
      <label htmlFor={id} className={labelClassName}>
        {label}
      </label>
      <input
        id={id}
        role="combobox"
        aria-expanded={showList}
        aria-controls={listId}
        aria-autocomplete="list"
        aria-activedescendant={showList && active >= 0 ? `${listId}-${active}` : undefined}
        autoComplete="off"
        value={text}
        placeholder={placeholder}
        className={inputClassName}
        onFocus={() => setOpen(true)}
        onBlur={() => setOpen(false)}
        onChange={(event) => {
          setText(event.target.value);
          setOpen(true);
          if (value) onChange(null);
        }}
        onKeyDown={(event) => {
          if (event.key === "ArrowDown" && items.length > 0) {
            event.preventDefault();
            setActive((index) => (index + 1) % items.length);
          } else if (event.key === "ArrowUp" && items.length > 0) {
            event.preventDefault();
            setActive((index) => (index - 1 + items.length) % items.length);
          } else if (event.key === "Enter" && showList && items[active]) {
            event.preventDefault();
            choose(items[active]);
          } else if (event.key === "Escape") {
            setOpen(false);
          }
        }}
      />
      {showList && (
        <ul
          id={listId}
          role="listbox"
          aria-label={`Gợi ý ${label.toLowerCase()}`}
          // Rộng hơn ô nhập (tên cũ kèm đơn vị mới khá dài) nhưng không tràn khỏi màn hình điện thoại.
          className="absolute top-full left-0 z-30 mt-1 max-h-80 w-max min-w-full max-w-[min(26rem,calc(100vw-2rem))] overflow-y-auto rounded-xl border border-slate-200 bg-white py-1 shadow-lg"
        >
          {loading && items.length === 0 ? (
            <li className="flex items-center gap-2 px-4 py-3 text-xs text-slate-500">
              <LoaderCircle className="h-4 w-4 animate-spin" /> Đang tìm…
            </li>
          ) : items.length === 0 ? (
            <li className="px-4 py-3 text-xs text-slate-500">
              {failed ? "Chưa tải được gợi ý. Thử lại sau." : "Không tìm thấy địa điểm phù hợp."}
            </li>
          ) : (
            items.map((item, index) => {
              const Icon = KIND_ICON[item.kind];
              return (
                <li
                  key={`${item.kind}-${item.target.id}-${item.label}`}
                  id={`${listId}-${index}`}
                  role="option"
                  aria-selected={index === active}
                  // `onMouseDown` chặn blur của ô trước khi chọn.
                  onMouseDown={(event) => {
                    event.preventDefault();
                    choose(item);
                  }}
                  onMouseEnter={() => setActive(index)}
                  className={`flex cursor-pointer items-start gap-2.5 px-4 py-2.5 ${index === active ? "bg-[#eef8fa]" : ""}`}
                >
                  <Icon aria-hidden className="mt-0.5 h-4 w-4 shrink-0 text-[#00506a]" />
                  <span className="min-w-0">
                    <span className="flex flex-wrap items-center gap-1.5 text-sm font-semibold text-[#0f172a]">
                      {item.label}
                      {item.kind === "LEGACY" && (
                        <span className="rounded-full bg-amber-50 px-1.5 py-0.5 text-[10px] font-bold text-amber-700">Tên cũ</span>
                      )}
                    </span>
                    {item.detail && <span className="block text-xs text-slate-500">{item.detail}</span>}
                  </span>
                </li>
              );
            })
          )}
        </ul>
      )}
    </div>
  );
}
