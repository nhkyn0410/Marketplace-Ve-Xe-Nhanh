/** Tên tuyến tối đa (khớp `RouteInputSchema.name`). */
export const ROUTE_NAME_MAX = 150;

/** Một điểm dừng khi ghép tên: nơi quen thuộc (`localityName`), tên điểm, quyền đón / trả. */
export type NamingStop = { locality: string; name: string; allowPickup: boolean; allowDropoff: boolean };

/**
 * Tên tuyến tự động (giai đoạn 3.1, tự thiết kế 29/10/2026, chờ duyệt): "nơi điểm đầu → nơi điểm cuối", có điểm giữa cho
 * đón / trả ở nơi khác thì thêm "(qua X, Y)" — vd "TP.HCM → Buôn Ma Thuột (qua Gia Nghĩa)". Hai đầu cùng một nơi (tuyến nội
 * vùng) thì dùng tên hai điểm. Quá dài thì bớt dần nơi "qua" ở cuối.
 */
export function composeRouteName(stops: readonly NamingStop[]): string {
  const first = stops[0];
  const last = stops[stops.length - 1];
  if (!first || !last) {
    return "";
  }
  if (first.locality === last.locality) {
    return clip(`${first.name} → ${last.name}`);
  }
  const via: string[] = [];
  for (const stop of stops.slice(1, -1)) {
    if ((stop.allowPickup || stop.allowDropoff) && stop.locality !== first.locality && stop.locality !== last.locality && !via.includes(stop.locality)) {
      via.push(stop.locality);
    }
  }
  const base = `${first.locality} → ${last.locality}`;
  for (let count = via.length; count > 0; count -= 1) {
    const name = `${base} (qua ${via.slice(0, count).join(", ")}${count < via.length ? "…" : ""})`;
    if (name.length <= ROUTE_NAME_MAX) {
      return name;
    }
  }
  return clip(base);
}

/**
 * Các tên thử lần lượt khi tên tự động đã có ở tuyến khác của nhà xe (tên tuyến không được trùng trong nhà xe): kèm tên bến
 * đầu ("… · Bến xe Miền Đông"), rồi đánh số "(2)", "(3)"…
 */
export function nameCandidates(base: string, firstStopName: string): string[] {
  // Cắt phần tên chính chứ không cắt hậu tố — hậu tố là thứ làm hai tên khác nhau.
  const withSuffix = (suffix: string) =>
    base.length + suffix.length <= ROUTE_NAME_MAX ? `${base}${suffix}` : `${base.slice(0, ROUTE_NAME_MAX - suffix.length - 1)}…${suffix}`;
  return [base, withSuffix(` · ${firstStopName}`), ...Array.from({ length: 8 }, (_, index) => withSuffix(` (${index + 2})`))];
}

function clip(name: string): string {
  return name.length <= ROUTE_NAME_MAX ? name : `${name.slice(0, ROUTE_NAME_MAX - 1)}…`;
}
