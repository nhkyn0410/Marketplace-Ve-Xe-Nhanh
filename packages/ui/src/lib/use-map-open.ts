// Nhớ bản đồ đang mở hay thu gọn trên trình duyệt này (UI §7: "nhớ lựa chọn gần nhất").
import { useCallback, useSyncExternalStore } from "react";

/** Mỗi bản đồ đóng mở được có một tên riêng để nhớ độc lập. */
export type MapPanelName = "stop-overview" | "route";

const listeners = new Set<() => void>();
// Trình duyệt chặn localStorage (chế độ riêng tư…) thì nhớ tạm trong phiên đang mở.
const memory = new Map<string, string>();

const storageKey = (name: MapPanelName) => `vxn.operator.map.${name}`;

function read(name: MapPanelName): string | null {
  try {
    return window.localStorage.getItem(storageKey(name));
  } catch {
    return memory.get(name) ?? null;
  }
}

function write(name: MapPanelName, value: string) {
  try {
    window.localStorage.setItem(storageKey(name), value);
  } catch {
    memory.set(name, value);
  }
  listeners.forEach((listener) => listener());
}

function subscribe(listener: () => void): () => void {
  listeners.add(listener);
  window.addEventListener("storage", listener);
  return () => {
    listeners.delete(listener);
    window.removeEventListener("storage", listener);
  };
}

/** Giá trị đã nhớ → mở / thu gọn; chưa từng chọn (hoặc giá trị lạ) thì theo mặc định của bản đồ đó. */
export function mapOpenFrom(stored: string | null, fallback: boolean): boolean {
  return stored === "1" ? true : stored === "0" ? false : fallback;
}

/**
 * Trạng thái mở / thu gọn của một bản đồ, nhớ lựa chọn gần nhất của người dùng. Lần hiển thị đầu (trên máy
 * chủ) luôn theo `fallback`, sau đó mới áp lựa chọn đã nhớ.
 */
export function useMapOpen(name: MapPanelName, fallback: boolean): [boolean, (open: boolean) => void] {
  const stored = useSyncExternalStore(
    subscribe,
    () => read(name),
    () => null
  );
  const setOpen = useCallback((open: boolean) => write(name, open ? "1" : "0"), [name]);
  return [mapOpenFrom(stored, fallback), setOpen];
}
