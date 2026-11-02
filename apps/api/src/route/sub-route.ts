import { RouteStopRole } from "../database/prisma.types";

/**
 * Tuyến con (giai đoạn 3.2, tự thiết kế 29/10/2026, chờ duyệt) — logic thuần: tìm đoạn của tuyến chính theo mã điểm, gợi ý
 * các đoạn theo nhóm nơi, chép đoạn thành điểm dừng của tuyến con, tính giá gợi ý theo tỉ lệ quãng đường.
 */

/** Một điểm theo mã: catalog HOẶC điểm riêng. */
export type PointRef = { catalogStopPointId: string | null; stopPointId: string | null };

/** Điểm dừng của tuyến chính (dòng `route_stops`) — đủ để tìm đoạn và chép đoạn. */
export type ParentStop = PointRef & {
  note: string | null;
  allowPickup: boolean;
  allowDropoff: boolean;
  latitude: number;
  longitude: number;
  distanceMetersFromPrevious: number | null;
  durationSecondsFromPrevious: number | null;
  measuredDurationSeconds: number | null;
};

/** Đoạn [from, to] theo vị trí trong danh sách điểm của tuyến chính. */
export type Span = { from: number; to: number };

export function samePoint(a: PointRef, b: PointRef): boolean {
  return a.catalogStopPointId ? a.catalogStopPointId === b.catalogStopPointId : a.stopPointId !== null && a.stopPointId === b.stopPointId;
}

/**
 * Vị trí hai đầu tuyến con trên tuyến chính; `null` khi đoạn không hợp lệ: thiếu điểm, sai chiều, điểm đầu không cho đón,
 * điểm cuối không cho trả, hoặc trùng cả tuyến chính.
 */
export function locateSpan(stops: readonly ParentStop[], from: PointRef, to: PointRef): Span | null {
  const start = stops.findIndex((stop) => samePoint(stop, from));
  const end = stops.findIndex((stop) => samePoint(stop, to));
  const last = stops.length - 1;
  if (start < 0 || end <= start || (start === 0 && end === last)) {
    return null;
  }
  return stops[start]!.allowPickup && stops[end]!.allowDropoff ? { from: start, to: end } : null;
}

/** Quãng đường + thời gian chạy của đoạn: cộng các chặng sau điểm đầu tới điểm cuối. */
export function spanTotals(stops: readonly ParentStop[], span: Span): { distanceMeters: number; durationSeconds: number } {
  let distanceMeters = 0;
  let durationSeconds = 0;
  for (let index = span.from + 1; index <= span.to; index++) {
    distanceMeters += stops[index]!.distanceMetersFromPrevious ?? 0;
    durationSeconds += stops[index]!.durationSecondsFromPrevious ?? 0;
  }
  return { distanceMeters, durationSeconds };
}

/**
 * Đoạn gợi ý thành tuyến con: các điểm có đón / trả liền nhau cùng một nơi gom thành một nhóm, mỗi cặp nhóm (theo chiều
 * tuyến) là một đoạn — từ điểm cho đón đầu tiên của nhóm trước tới điểm cho trả cuối cùng của nhóm sau. Bỏ cặp nhóm đầu–cuối
 * (chính là tuyến chính). Vd "TP.HCM – Gia Nghĩa – Buôn Ma Thuột" → "TP.HCM → Gia Nghĩa", "Gia Nghĩa → Buôn Ma Thuột".
 */
export function suggestSpans(stops: readonly (ParentStop & { locality: string })[]): Span[] {
  const groups: number[][] = [];
  stops.forEach((stop, index) => {
    if (!stop.allowPickup && !stop.allowDropoff) {
      return;
    }
    const current = groups[groups.length - 1];
    if (current && stops[current[0]!]!.locality === stop.locality) {
      current.push(index);
    } else {
      groups.push([index]);
    }
  });
  const spans: Span[] = [];
  for (let i = 0; i < groups.length; i++) {
    for (let j = i + 1; j < groups.length; j++) {
      if (i === 0 && j === groups.length - 1) {
        continue;
      }
      const from = groups[i]!.find((index) => stops[index]!.allowPickup);
      const to = [...groups[j]!].reverse().find((index) => stops[index]!.allowDropoff);
      if (from !== undefined && to !== undefined && from < to && locateSpan(stops, stops[from]!, stops[to]!)) {
        spans.push({ from, to });
      }
    }
  }
  return spans;
}

/**
 * Dòng `route_stops` của tuyến con = bản chép đoạn của tuyến chính: đánh số lại từ 1, điểm đầu chỉ đón (không có chặng
 * trước), điểm cuối chỉ trả, điểm giữa giữ quyền đón / trả và số liệu chặng như tuyến chính.
 */
export function sliceStopRows(operatorId: string, routeId: string, stops: readonly ParentStop[], span: Span) {
  const slice = stops.slice(span.from, span.to + 1);
  const last = slice.length - 1;
  return slice.map((stop, index) => ({
    operatorId,
    routeId,
    sequence: index + 1,
    role: index === 0 ? RouteStopRole.ORIGIN : index === last ? RouteStopRole.DESTINATION : RouteStopRole.INTERMEDIATE,
    catalogStopPointId: stop.catalogStopPointId,
    stopPointId: stop.stopPointId,
    note: stop.note,
    allowPickup: index === last ? false : index === 0 ? true : stop.allowPickup,
    allowDropoff: index === 0 ? false : index === last ? true : stop.allowDropoff,
    latitude: stop.latitude,
    longitude: stop.longitude,
    distanceMetersFromPrevious: index === 0 ? null : stop.distanceMetersFromPrevious,
    durationSecondsFromPrevious: index === 0 ? null : stop.durationSecondsFromPrevious,
    measuredDurationSeconds: index === 0 ? null : stop.measuredDurationSeconds,
  }));
}

const PRICE_STEP = 5_000n;

/**
 * Giá gợi ý của tuyến con (VND): giá tuyến chính × quãng đường đoạn / quãng đường tuyến chính, làm tròn tới 5.000đ gần nhất,
 * thấp nhất 5.000đ (giá 0 giữ 0). Tính bằng `bigint`, không qua số thực.
 */
export function scalePrice(price: bigint, partMeters: number, totalMeters: number): bigint {
  if (price === 0n) {
    return 0n;
  }
  const part = BigInt(partMeters);
  const total = BigInt(totalMeters);
  const rounded = ((price * part * 2n + PRICE_STEP * total) / (PRICE_STEP * total * 2n)) * PRICE_STEP;
  return rounded < PRICE_STEP ? PRICE_STEP : rounded;
}

/** Bảng giá gợi ý: mọi quy tắc của tuyến chính, giá theo `scalePrice`; tuyến chính dài 0 m thì không gợi ý được. */
export function scaleRules<R extends { price: bigint }>(rules: readonly R[], partMeters: number, totalMeters: number): R[] | null {
  if (totalMeters <= 0 || rules.length === 0) {
    return null;
  }
  return rules.map((rule) => ({ ...rule, price: scalePrice(rule.price, partMeters, totalMeters) }));
}
