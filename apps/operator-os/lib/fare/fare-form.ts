// Logic thuần của màn Chỉnh sửa bảng giá (Figma "02 · Bảng giá / Chỉnh sửa bảng giá"; FR-OPS-08, BR-40, BR-41).
// Tách khỏi component để test được: đọc ô nhập của một quy tắc, kiểm trùng phạm vi, dựng body API, đọc lỗi lưu.
import { ApiError } from "../auth/api-client";
import { SEAT_TYPES } from "../seat-map/seat-map-editor";
import { fromLocalParts, toLocalParts } from "../trip/trip-format";
import type { Fare, FareCreateInput, FareRule, FareStatus, FareUpdateInput } from "./fare-api";

/** Trần kỹ thuật một giá ghế và số quy tắc tối đa một bảng giá (giống máy chủ). */
export const MAX_FARE_PRICE = 100_000_000;
export const MAX_FARE_RULES = 200;
export const FARE_NOTE_MAX_LENGTH = 500;
/** Giá trị "mọi loại" của ô chọn loại xe / loại chỗ (ô chọn không nhận chuỗi rỗng). */
export const ANY = "ANY";

const LOCAL_MOMENT = /^(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2})$/;

/** Giá trị các ô của khối "Thêm / Sửa quy tắc". `from` / `to` theo ô `datetime-local` (giờ Việt Nam). */
export type RuleFormValues = { vehicleTypeId: string; seatType: string; from: string; to: string; price: string };
export type RuleFormErrors = Partial<Record<"from" | "to" | "price" | "scope", string>>;

/** Khối nhập trống cho một quy tắc mới: mọi loại xe, mọi loại chỗ, không khung giờ. */
export const EMPTY_RULE_FORM: RuleFormValues = { vehicleTypeId: ANY, seatType: ANY, from: "", to: "", price: "" };

/** Điền khối nhập từ một quy tắc đang có để sửa. */
export function toRuleForm(rule: FareRule): RuleFormValues {
  const local = (iso: string | null) => {
    if (iso === null) {
      return "";
    }
    const { date, time } = toLocalParts(iso);
    return `${date}T${time}`;
  };
  return {
    vehicleTypeId: rule.vehicleTypeId ?? ANY,
    seatType: rule.seatType ?? ANY,
    from: local(rule.validFrom),
    to: local(rule.validTo),
    price: String(rule.price)
  };
}

/** Ô `datetime-local` → mốc UTC (dạng API trả về); `null` khi sai dạng hoặc năm ngoài 1970–9999 (giới hạn của máy chủ). */
function parseMoment(value: string): string | null {
  const match = LOCAL_MOMENT.exec(value);
  if (!match) {
    return null;
  }
  const date = new Date(fromLocalParts(match[1]!, match[2]!));
  const year = date.getUTCFullYear();
  return Number.isNaN(date.getTime()) || year < 1970 || year > 9999 ? null : date.toISOString();
}

/**
 * Giá gõ vào → số nguyên đồng. Nhận dãy chữ số liền (`300000`) hoặc có dấu chấm / khoảng trắng ngăn ĐÚNG từng
 * nhóm ba số (`300.000`, `1 250 000`). Mọi dạng khác bị từ chối — kể cả `1.5` hay `300.5`: dấu chấm lệch nhóm
 * có thể là số thập phân gõ nhầm, đoán bừa sẽ ra giá sai gấp nhiều lần. Tiền không được làm tròn lặng lẽ.
 */
export function parsePrice(value: string): number | null {
  const text = value.trim();
  if (!/^\d{1,9}$/.test(text) && !/^\d{1,3}([.\s]\d{3}){1,2}$/.test(text)) {
    return null;
  }
  const price = Number(text.replace(/[.\s]/g, ""));
  return price <= MAX_FARE_PRICE ? price : null;
}

/** Đọc khối nhập thành một quy tắc; sai thì trả lỗi theo từng ô (giống quy tắc của máy chủ). */
export function parseRuleForm(values: RuleFormValues): { rule: FareRule | null; errors: RuleFormErrors } {
  const errors: RuleFormErrors = {};
  const price = parsePrice(values.price);
  if (price === null) {
    errors.price = "Giá là số nguyên từ 0 đến 100.000.000 ₫.";
  }
  let validFrom: string | null = null;
  let validTo: string | null = null;
  if (values.from !== "" || values.to !== "") {
    validFrom = parseMoment(values.from);
    validTo = parseMoment(values.to);
    if (values.from === "" || values.to === "") {
      errors[values.from === "" ? "from" : "to"] = "Khung giờ phải có đủ mốc bắt đầu và mốc kết thúc.";
    } else if (validFrom === null) {
      errors.from = "Mốc bắt đầu không hợp lệ.";
    } else if (validTo === null) {
      errors.to = "Mốc kết thúc không hợp lệ.";
    } else if (validTo <= validFrom) {
      errors.to = "Mốc kết thúc phải sau mốc bắt đầu.";
    }
  }
  if (price === null || Object.keys(errors).length > 0) {
    return { rule: null, errors };
  }
  return {
    rule: {
      vehicleTypeId: values.vehicleTypeId === ANY ? null : values.vehicleTypeId,
      seatType: values.seatType === ANY ? null : (values.seatType as FareRule["seatType"]),
      validFrom,
      validTo,
      price
    },
    errors
  };
}

/**
 * Hai quy tắc cùng loại xe × loại chỗ có đụng nhau không (giống máy chủ): cùng là giá thường, hoặc hai khung giờ
 * `[validFrom, validTo)` chồng nhau. Mốc ISO dạng UTC so được theo thứ tự chữ.
 */
export function rulesConflict(a: FareRule, b: FareRule): boolean {
  if (a.vehicleTypeId !== b.vehicleTypeId || a.seatType !== b.seatType) {
    return false;
  }
  if (a.validFrom === null && b.validFrom === null) {
    return true;
  }
  return (
    a.validFrom !== null &&
    a.validTo !== null &&
    b.validFrom !== null &&
    b.validTo !== null &&
    a.validFrom < b.validTo &&
    b.validFrom < a.validTo
  );
}

/** Vị trí quy tắc đang có đụng với `candidate`; bỏ qua dòng đang sửa (`ignoreIndex`). `-1` = không đụng. */
export function findConflict(rules: FareRule[], candidate: FareRule, ignoreIndex: number | null): number {
  return rules.findIndex((rule, index) => index !== ignoreIndex && rulesConflict(rule, candidate));
}

/**
 * Thứ tự hiển thị như máy chủ trả về: giá thường trước, rồi theo khung giờ; trong mỗi nhóm "mọi loại" đứng đầu,
 * loại chỗ theo thứ tự của BR-78 (ghế → giường → cabin).
 */
export function sortRules(rules: FareRule[]): FareRule[] {
  const key = (value: string | null) => value ?? "";
  const seatOrder = (seatType: FareRule["seatType"]) => SEAT_TYPES.findIndex((seat) => seat.type === seatType);
  return [...rules].sort(
    (a, b) =>
      key(a.validFrom).localeCompare(key(b.validFrom)) ||
      key(a.vehicleTypeId).localeCompare(key(b.vehicleTypeId)) ||
      seatOrder(a.seatType) - seatOrder(b.seatType)
  );
}

export type FareInfoValues = { routeId: string; status: FareStatus; note: string };

/** Thông tin bảng giá của form trống / của một bảng giá đã lưu. */
export const EMPTY_FARE_INFO: FareInfoValues = { routeId: "", status: "ACTIVE", note: "" };
export function toFareInfo(fare: Fare): FareInfoValues {
  return { routeId: fare.routeId, status: fare.status, note: fare.note ?? "" };
}

/** Body thay toàn bộ bảng giá. */
export function toFareUpdateInput(info: FareInfoValues, rules: FareRule[]): FareUpdateInput {
  return { status: info.status, note: info.note.trim() || null, rules };
}

/** Body tạo bảng giá cho tuyến đã chọn. */
export function toFareCreateInput(info: FareInfoValues, rules: FareRule[]): FareCreateInput {
  return { routeId: info.routeId, ...toFareUpdateInput(info, rules) };
}

export type FareSaveErrorField = "routeId" | "rules" | null;

/** Đổi lỗi lưu bảng giá thành câu báo và nơi cần gắn lỗi. */
export function describeFareSaveError(error: unknown): { field: FareSaveErrorField; message: string } {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "FARE_ROUTE_CONFLICT":
        return { field: "routeId", message: "Tuyến này đã có bảng giá. Mở bảng giá đó để chỉnh sửa." };
      case "ROUTE_UNAVAILABLE":
        return { field: "routeId", message: "Tuyến không còn hoạt động nên chưa tạo được bảng giá." };
      case "FARE_RULES_OVERLAP":
        return {
          field: "rules",
          message: "Có hai quy tắc cùng loại xe và loại chỗ bị trùng (cùng là giá thường hoặc chồng khung giờ)."
        };
      case "CATALOG_ITEM_UNAVAILABLE":
        return { field: "rules", message: "Có loại xe không còn trong danh mục. Chọn lại loại xe cho quy tắc đó." };
      case "FARE_NOT_FOUND":
        return { field: null, message: "Bảng giá không còn tồn tại. Vui lòng quay lại danh sách." };
      case "SERVICE_UNAVAILABLE":
        return { field: null, message: "Máy chủ đang bận nên bảng giá chưa thay đổi. Vui lòng thử lại sau." };
    }
    if (error.status === 400) {
      return { field: null, message: "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại các quy tắc giá." };
    }
  }
  return { field: null, message: "Chưa lưu được bảng giá. Vui lòng kiểm tra kết nối và thử lại." };
}
