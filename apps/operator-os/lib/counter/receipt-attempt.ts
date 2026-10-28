import { CounterReceiptInputSchema, type CounterReceiptInput } from "@vexenhanh/types";

type AttemptStorage = Pick<Storage, "getItem" | "setItem" | "removeItem">;
const storageKey = (bookingId: string) => `vxn:counter-receipt:${bookingId}`;

function tabStorage(): AttemptStorage | undefined {
  try { return typeof window === "undefined" ? undefined : window.sessionStorage; } catch { return undefined; }
}

/** Khôi phục lần xác nhận đang chờ kết quả trong cùng tab sau khi tải lại trang. */
export function readReceiptAttempt(bookingId: string, storage: AttemptStorage | undefined = tabStorage()): CounterReceiptInput | null {
  try {
    const raw = storage?.getItem(storageKey(bookingId));
    if (!raw) return null;
    const parsed = CounterReceiptInputSchema.safeParse(JSON.parse(raw));
    return parsed.success ? parsed.data : null;
  } catch { return null; }
}

/** Giữ mã và nội dung khoản thu trước khi gửi để việc thử lại không ghi thêm khoản tiền. */
export function saveReceiptAttempt(bookingId: string, input: CounterReceiptInput, storage: AttemptStorage | undefined = tabStorage()): boolean {
  try {
    if (!storage) return false;
    const raw = JSON.stringify(input);
    storage.setItem(storageKey(bookingId), raw);
    return storage.getItem(storageKey(bookingId)) === raw;
  } catch { return false; }
}

/** Bỏ bản chờ sau khi máy chủ đã trả kết quả rõ ràng. */
export function clearReceiptAttempt(bookingId: string, storage: AttemptStorage | undefined = tabStorage()): void {
  try { storage?.removeItem(storageKey(bookingId)); } catch { /* Không chặn kết quả thu tiền vì bộ nhớ trình duyệt. */ }
}
