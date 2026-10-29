// Logic thuần của phần Tuyến con (giai đoạn 3.2, tự thiết kế 29/10/2026, chờ duyệt): chọn hai đầu trên tuyến chính, xem đoạn,
// dựng body API, giá gợi ý nhà xe sửa được. Tách khỏi component để test được.
import { ApiError } from "../auth/api-client";
import type { FareRule } from "../fare/fare-api";
import type { Route, RouteStop, SubRouteInput, SubRouteSuggestion } from "./route-api";

/** Mã điểm (catalog HOẶC điểm riêng) — giống cách máy chủ nhận hai đầu tuyến con. */
export function pointKey(point: { catalogStopPointId: string | null; stopPointId: string | null }): string {
  return point.catalogStopPointId ? `catalog:${point.catalogStopPointId}` : `private:${point.stopPointId}`;
}

function pointRef(stop: RouteStop) {
  return { catalogStopPointId: stop.catalogStopPointId, stopPointId: stop.stopPointId };
}

/** Điểm làm được điểm đầu tuyến con: cho đón, chưa phải điểm cuối của tuyến chính. */
export function fromOptions(stops: RouteStop[]): RouteStop[] {
  return stops.filter((stop, index) => stop.allowPickup && index < stops.length - 1);
}

/** Điểm làm được điểm cuối khi đã chọn điểm đầu: sau điểm đầu, cho trả, không trùng cả tuyến chính. */
export function toOptions(stops: RouteStop[], fromKey: string): RouteStop[] {
  const start = stops.findIndex((stop) => pointKey(stop) === fromKey);
  if (start < 0) {
    return [];
  }
  return stops.filter(
    (stop, index) => index > start && stop.allowDropoff && !(start === 0 && index === stops.length - 1)
  );
}

/** Đoạn của tuyến chính giữa hai đầu đã chọn (gồm cả hai đầu); chọn chưa hợp lệ → rỗng. */
export function sliceOf(stops: RouteStop[], fromKey: string, toKey: string): RouteStop[] {
  const start = stops.findIndex((stop) => pointKey(stop) === fromKey);
  const end = stops.findIndex((stop) => pointKey(stop) === toKey);
  return start >= 0 && end > start ? stops.slice(start, end + 1) : [];
}

/** Quãng đường / thời gian của đoạn = cộng các chặng sau điểm đầu (như máy chủ). */
export function sliceTotals(slice: RouteStop[]): { distanceMeters: number; durationSeconds: number } {
  return slice.slice(1).reduce(
    (sum, stop) => ({
      distanceMeters: sum.distanceMeters + (stop.distanceMetersFromPrevious ?? 0),
      durationSeconds: sum.durationSeconds + (stop.durationSecondsFromPrevious ?? 0)
    }),
    { distanceMeters: 0, durationSeconds: 0 }
  );
}

/** Điểm của đoạn theo dạng body tuyến (để xem trước tên tự động): đầu chỉ đón, cuối chỉ trả, giữa giữ quyền. */
export function sliceStopInputs(slice: RouteStop[]) {
  const last = slice.length - 1;
  return slice.map((stop, index) => ({
    ...pointRef(stop),
    note: null,
    allowPickup: index === 0 ? true : index === last ? false : stop.allowPickup,
    allowDropoff: index === 0 ? false : index === last ? true : stop.allowDropoff
  }));
}

/** Ô nhập của form tuyến con. */
export type SubRouteValues = {
  fromKey: string;
  toKey: string;
  nameSource: "AUTO" | "MANUAL";
  name: string;
  status: Route["status"];
  note: string;
};

export function toSubRouteValues(route: Route): SubRouteValues {
  const first = route.stops[0];
  const last = route.stops[route.stops.length - 1];
  return {
    fromKey: first ? pointKey(first) : "",
    toKey: last ? pointKey(last) : "",
    nameSource: route.nameSource,
    name: route.name,
    status: route.status,
    note: route.note ?? ""
  };
}

/** Form tuyến con trống: tự đặt tên, lưu Nháp (chưa có bảng giá nên chưa bật được). */
export const EMPTY_SUB_ROUTE: SubRouteValues = { fromKey: "", toKey: "", nameSource: "AUTO", name: "", status: "DRAFT", note: "" };

/** Body tạo / sửa tuyến con; `null` khi chưa chọn đủ hai đầu trên tuyến chính. */
export function toSubRouteInput(values: SubRouteValues, parentStops: RouteStop[]): SubRouteInput | null {
  const from = parentStops.find((stop) => pointKey(stop) === values.fromKey);
  const to = parentStops.find((stop) => pointKey(stop) === values.toKey);
  if (!from || !to || sliceOf(parentStops, values.fromKey, values.toKey).length === 0) {
    return null;
  }
  return {
    from: pointRef(from),
    to: pointRef(to),
    nameSource: values.nameSource,
    name: values.nameSource === "AUTO" ? "" : values.name.trim(),
    status: values.status,
    note: values.note.trim() || null
  };
}

/** Body tạo tuyến con từ một gợi ý: tự đặt tên (tên gợi ý đã tránh trùng), Nháp. */
export function suggestionInput(suggestion: SubRouteSuggestion): SubRouteInput {
  return {
    from: { catalogStopPointId: suggestion.from.catalogStopPointId, stopPointId: suggestion.from.stopPointId },
    to: { catalogStopPointId: suggestion.to.catalogStopPointId, stopPointId: suggestion.to.stopPointId },
    nameSource: "AUTO",
    name: "",
    status: "DRAFT",
    note: null
  };
}

const isGeneral = (rule: FareRule) =>
  rule.vehicleTypeId === null && rule.seatType === null && rule.validFrom === null && rule.validTo === null;

/** Giá chung (mọi loại xe, mọi loại chỗ, không khung giờ) của bảng giá gợi ý — ô nhà xe sửa được ở danh sách gợi ý. */
export function generalPrice(rules: FareRule[] | null): number | null {
  return rules?.find(isGeneral)?.price ?? null;
}

/**
 * Quy tắc giá để tạo bảng giá cho tuyến con từ gợi ý: giá chung thay bằng số nhà xe nhập (nếu có), các quy tắc khác giữ giá
 * gợi ý (máy chủ đã tính theo tỉ lệ quãng đường). Tuyến chính chưa có bảng giá thì giá nhập thành một quy tắc giá chung.
 * Không có gì để tạo → `null`.
 */
export function suggestedFareRules(rules: FareRule[] | null, price: number | null): FareRule[] | null {
  if (!rules || rules.length === 0) {
    return price === null ? null : [{ vehicleTypeId: null, seatType: null, validFrom: null, validTo: null, price }];
  }
  if (price === null) {
    return rules;
  }
  return rules.some(isGeneral)
    ? rules.map((rule) => (isGeneral(rule) ? { ...rule, price } : rule))
    : [{ vehicleTypeId: null, seatType: null, validFrom: null, validTo: null, price }, ...rules];
}

export type SubRouteErrorField = "name" | "bounds" | "status" | null;

/** Đổi lỗi lưu tuyến con thành câu báo và nơi cần gắn lỗi. */
export function describeSubRouteError(error: unknown): { field: SubRouteErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "ROUTE_NAME_CONFLICT":
        return { field: "name", message: "Tên tuyến đã có trong nhà xe. Chọn tên khác hoặc bật tự đặt tên." };
      case "SUB_ROUTE_CONFLICT":
        return { field: "bounds", message: "Tuyến chính đã có tuyến con cùng điểm đầu và điểm cuối." };
      case "SUB_ROUTE_BOUNDS_INVALID":
        return {
          field: "bounds",
          message: "Điểm đầu phải cho đón, điểm cuối phải cho trả và nằm sau điểm đầu trên tuyến chính."
        };
      case "SUB_ROUTE_NOT_READY":
        return {
          field: "status",
          message: "Tạo bảng giá cho tuyến con (và chọn lại hai đầu nếu cần xem lại) trước khi bật."
        };
      case "ROUTE_NOT_FOUND":
        return { field: null, message: "Tuyến chính hoặc tuyến con không còn tồn tại. Vui lòng quay lại danh sách." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại." };
    }
  }
  return { field: null, message: "Chưa lưu được tuyến con. Vui lòng kiểm tra kết nối và thử lại." };
}
