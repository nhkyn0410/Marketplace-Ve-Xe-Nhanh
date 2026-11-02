import { z } from "zod";

/**
 * Cursor của danh sách xếp mới nhất trước: thời điểm (ISO) + `id` của dòng cuối trang trước, vd
 * `2026-10-13T03:40:00.000Z_<uuid>`. Cùng thời điểm thì so tiếp `id` để không lặp / sót dòng.
 */
const TIME_CURSOR_PATTERN =
  /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;

export const TimeCursorField = z.string().regex(TIME_CURSOR_PATTERN).optional();

export function encodeTimeCursor(at: Date, id: string): string {
  return `${at.toISOString()}_${id}`;
}

export function decodeTimeCursor(cursor: string): { at: Date; id: string } {
  const separator = cursor.indexOf("_");
  return { at: new Date(cursor.slice(0, separator)), id: cursor.slice(separator + 1) };
}
