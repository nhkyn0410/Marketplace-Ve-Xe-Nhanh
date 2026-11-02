import type Redis from "ioredis";

// Giữ chỗ trên Redis (ADR-015, LLD §6.1): mỗi chỗ một khóa `seat:{tripId}:{seatCode}:hold` = holdId, `SET NX` qua Lua cho
// cả lô (được cả lô hoặc không), tự hết hạn — không cần job dọn. Bản ghi giữ chỗ `seat-hold:{holdId}` cùng hạn.

export type HoldStop = { sequence: number; name: string; plannedAt: string };

export type HoldRecord = {
  holdId: string;
  tripId: string;
  seatCodes: string[];
  pickup: HoldStop;
  dropoff: HoldStop;
  /** Hành khách đã đăng nhập tạo giữ chỗ; `null` = khách vãng lai (biết `holdId` là chủ). */
  userId: string | null;
  /** Phiên quầy chỉ được chính người bán dùng tại đúng văn phòng. */
  counter?: { operatorId: string; officeId: string; actor: string };
  seats: { code: string; type: string; price: number | string }[];
  subtotal: number | string;
  createdAt: string;
  expiresAt: string;
};

export function seatKey(tripId: string, seatCode: string): string {
  return `seat:{${tripId}}:${seatCode}:hold`;
}

export function holdKey(holdId: string): string {
  return `seat-hold:${holdId}`;
}

// KEYS = khóa từng chỗ…, khóa bản ghi; ARGV = holdId, hạn (ms), bản ghi JSON. Trả 0 = giữ được, i = chỗ thứ i đang bị giữ.
const ACQUIRE = `
local n = #KEYS - 1
for i = 1, n do
  if redis.call('EXISTS', KEYS[i]) == 1 then return i end
end
for i = 1, n do redis.call('SET', KEYS[i], ARGV[1], 'PX', ARGV[2]) end
redis.call('SET', KEYS[#KEYS], ARGV[3], 'PX', ARGV[2])
return 0
`;

// Chỉ xóa khóa chỗ còn mang đúng holdId (khóa đã hết hạn rồi bị người khác giữ thì không đụng).
const RELEASE = `
for i = 1, #KEYS - 1 do
  if redis.call('GET', KEYS[i]) == ARGV[1] then redis.call('DEL', KEYS[i]) end
end
redis.call('DEL', KEYS[#KEYS])
return 1
`;

/** Giữ cả lô chỗ; trả mã chỗ đang bị người khác giữ (`null` = giữ được). */
export async function acquireHold(redis: Redis, record: HoldRecord, ttlMs: number): Promise<string | null> {
  const keys = [...record.seatCodes.map((code) => seatKey(record.tripId, code)), holdKey(record.holdId)];
  const result = Number(await redis.eval(ACQUIRE, keys.length, ...keys, record.holdId, String(ttlMs), JSON.stringify(record)));
  return result === 0 ? null : record.seatCodes[result - 1]!;
}

export async function readHold(redis: Redis, holdId: string): Promise<HoldRecord | null> {
  const raw = await redis.get(holdKey(holdId));
  return raw ? (JSON.parse(raw) as HoldRecord) : null;
}

export async function releaseHold(redis: Redis, record: HoldRecord): Promise<void> {
  const keys = [...record.seatCodes.map((code) => seatKey(record.tripId, code)), holdKey(record.holdId)];
  await redis.eval(RELEASE, keys.length, ...keys, record.holdId);
}

// Mọi khóa chỗ còn mang đúng holdId (chưa hết hạn, chưa bị người khác giữ lại sau khi hết hạn).
const STILL_HELD = `
for i = 1, #KEYS do
  if redis.call('GET', KEYS[i]) ~= ARGV[1] then return 0 end
end
return 1
`;

/** Các chỗ của phiên vẫn đang được giữ bởi chính phiên đó — kiểm ngay trước khi tạo booking (LLD §6.2 bước 1). */
export async function stillHeld(redis: Redis, record: HoldRecord): Promise<boolean> {
  const keys = record.seatCodes.map((code) => seatKey(record.tripId, code));
  return Number(await redis.eval(STILL_HELD, keys.length, ...keys, record.holdId)) === 1;
}

/** Mã chỗ của chuyến đang được giữ (bất kỳ ai) — để sơ đồ chỗ công khai hiện "không đặt được". */
export async function heldSeatCodes(redis: Redis, tripId: string, seatCodes: string[]): Promise<Set<string>> {
  if (seatCodes.length === 0) {
    return new Set();
  }
  const values = await redis.mget(...seatCodes.map((code) => seatKey(tripId, code)));
  return new Set(seatCodes.filter((_code, index) => values[index] !== null));
}
