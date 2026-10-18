// Logic thuần của vòng đời bán chuyến + khóa chỗ (Figma "03"–"06 · Chuyến xe"; TASK-TRN-006, FR-OPS-10,
// FR-OPS-13, BR-39, BR-42). Tách khỏi component để test được: nút theo trạng thái, khối Điều kiện mở bán, chọn
// chỗ để khóa / mở khóa, đọc lỗi của máy chủ.
import { ApiError } from "../auth/api-client";
import { formatVnd } from "../fare/fare-format";
import type { Trip, TripSeat, TripSeatStatus, TripStatus } from "./trip-api";
import { formatDay, formatTime, seatCountLabel, TRIP_STATUS } from "./trip-format";

const MINUTE_MS = 60_000;

/** Mốc ngừng bán online của chuyến (AS-20): giờ khởi hành trừ số phút đã đặt. */
export function onlineSaleCloseMs(departureAt: string, cutoffMinutes: number): number {
  return new Date(departureAt).getTime() - cutoffMinutes * MINUTE_MS;
}

/** Mốc ngừng bán online để hiển thị: `05:00 · 08/10/2026`. */
export function onlineSaleCloseLabel(departureAt: string, cutoffMinutes: number): string {
  const iso = new Date(onlineSaleCloseMs(departureAt, cutoffMinutes)).toISOString();
  return `${formatTime(iso)} · ${formatDay(iso)}`;
}

/** Cài đặt ngừng bán online: `60 phút trước giờ khởi hành`; 0 phút = bán tới đúng giờ khởi hành. */
export function cutoffLabel(cutoffMinutes: number): string {
  return cutoffMinutes === 0 ? "Bán tới giờ khởi hành" : `${cutoffMinutes} phút trước giờ khởi hành`;
}

// ── Nút thao tác theo trạng thái ──

export type TripAction = "cancel" | "edit" | "withdraw" | "change" | "lock" | "open" | "reopen";

/**
 * Nút ở đầu trang chi tiết theo trạng thái chuyến (LLD §8). Nhà xe chỉ tự đổi giữa Nháp, Đang mở bán, Tạm dừng
 * bán và Đã hủy. Thu hồi về nháp chỉ dùng được khi chuyến chưa có vé — đã có vé thì nút mờ đi. Chuyến đang bán (kể cả đã có
 * vé) đổi lịch chạy / hủy theo TRN-008: bắt buộc lý do, khách nhận thông báo, hủy thì hoàn 100% giá vé.
 */
export function tripActions(status: TripStatus, hasTickets: boolean): { action: TripAction; disabled: boolean }[] {
  switch (status) {
    case "DRAFT":
      return [
        { action: "cancel", disabled: false },
        { action: "edit", disabled: false },
        { action: "open", disabled: false }
      ];
    case "OPEN_FOR_SALE":
      return [
        { action: "cancel", disabled: false },
        { action: "withdraw", disabled: hasTickets },
        { action: "change", disabled: false },
        { action: "lock", disabled: false }
      ];
    case "LOCKED":
      return [
        { action: "cancel", disabled: false },
        { action: "withdraw", disabled: hasTickets },
        { action: "change", disabled: false },
        { action: "reopen", disabled: false }
      ];
    case "SOLD_OUT":
      return [
        { action: "cancel", disabled: false },
        { action: "change", disabled: false }
      ];
    default:
      return [];
  }
}

/** Câu báo sau khi đổi trạng thái thành công; `from` là trạng thái trước đó. */
export function statusChangeNotice(
  from: TripStatus,
  trip: Pick<Trip, "status" | "departureAt" | "onlineSaleCutoffMinutes">
): { title: string; detail: string } {
  switch (trip.status) {
    case "OPEN_FOR_SALE":
      return {
        title: from === "LOCKED" ? "Đã mở bán lại" : "Đã mở bán",
        detail: `Chuyến bán online tới ${onlineSaleCloseLabel(trip.departureAt, trip.onlineSaleCutoffMinutes)}.`
      };
    case "LOCKED":
      return { title: "Đã tạm dừng bán", detail: "Khách không đặt mới được cho tới khi chuyến được mở bán lại." };
    case "DRAFT":
      return { title: "Đã thu hồi về nháp", detail: "Chuyến không còn hiện với khách. Sửa xong thì bấm Mở bán." };
    case "CANCELLED":
      return { title: "Đã hủy chuyến", detail: "Chuyến không mở bán lại được; xe của chuyến nhận được chuyến khác." };
    default:
      return { title: "Đã đổi trạng thái chuyến", detail: TRIP_STATUS[trip.status].label };
  }
}

// ── Điều kiện mở bán (BR-39) ──

/** Mã lý do chưa đủ điều kiện mở bán do máy chủ trả trong `reasons` của 422 `TRIP_NOT_READY_FOR_SALE`. */
export type SaleReadinessReason =
  | "OPERATOR_INACTIVE"
  | "ROUTE_INACTIVE"
  | "STOP_POINT_INACTIVE"
  | "VEHICLE_MISSING"
  | "VEHICLE_INACTIVE"
  | "SEATS_MISSING"
  | "FARE_MISSING"
  | "SEAT_PRICE_MISSING"
  | "SEAT_PRICE_ZERO"
  | "SALE_WINDOW_CLOSED";

export type ReadinessState = "ok" | "fail" | "unknown";
export type ReadinessKey = "operator" | "route" | "stops" | "vehicle" | "seats" | "fare" | "prices" | "window";
export type ReadinessItem = { key: ReadinessKey; label: string; state: ReadinessState; detail: string };

type ReadinessTrip = Pick<
  Trip,
  "status" | "routeName" | "vehicleId" | "seats" | "stops" | "departureAt" | "onlineSaleCutoffMinutes"
>;

const CHECK_ON_OPEN = "Kiểm khi bấm Mở bán";
const NEEDS_VEHICLE = "Kiểm được sau khi gắn xe";
const NEEDS_VEHICLE_AND_FARE = "Kiểm được khi đã gắn xe và tuyến có bảng giá";

/**
 * Tám mục của khối "Điều kiện mở bán". `reasons = null`: chưa bấm Mở bán — chỉ kết luận mục nào giao diện tự
 * biết từ dữ liệu chuyến (xe, chỗ, giá, giờ), mục còn lại ghi "Kiểm khi bấm Mở bán". `reasons` là mảng: kết quả
 * lần bấm Mở bán gần nhất, máy chủ đã kiểm toàn bộ — mục không bị nêu là đạt, trừ mục máy chủ không kiểm được vì
 * thiếu điều kiện đứng trước (chưa gắn xe thì chưa xét được chỗ và giá).
 */
export function readinessItems(
  trip: ReadinessTrip,
  reasons: readonly string[] | null,
  nowMs: number,
  plate: string | null
): ReadinessItem[] {
  const failed = (reason: SaleReadinessReason) => reasons?.includes(reason) ?? false;
  const checked = reasons !== null;
  // Chuyến đang Nháp sửa thẳng được; đang bán / tạm dừng thì phải thu hồi về nháp trước.
  const editHint = trip.status === "DRAFT" ? "Bấm Sửa chuyến" : "Thu hồi về nháp rồi sửa chuyến";
  const closeLabel = onlineSaleCloseLabel(trip.departureAt, trip.onlineSaleCutoffMinutes);
  const prices = trip.seats.map((seat) => seat.price);
  const missingPrice = checked ? failed("SEAT_PRICE_MISSING") : prices.some((price) => price === null);
  const zeroPrice = checked ? failed("SEAT_PRICE_ZERO") : prices.some((price) => price === 0);
  const noVehicle = checked ? failed("VEHICLE_MISSING") : trip.vehicleId === null;
  const noSeats = checked ? failed("SEATS_MISSING") : trip.seats.length === 0;
  const windowClosed = checked
    ? failed("SALE_WINDOW_CLOSED")
    : nowMs >= onlineSaleCloseMs(trip.departureAt, trip.onlineSaleCutoffMinutes);

  const items: ReadinessItem[] = [];
  const add = (key: ReadinessKey, label: string, state: ReadinessState, detail: string) =>
    items.push({ key, label, state, detail });

  if (!checked) {
    add("operator", "Nhà xe đang hoạt động", "unknown", CHECK_ON_OPEN);
    add("route", "Tuyến đang hoạt động", "unknown", CHECK_ON_OPEN);
    add("stops", "Mọi điểm dừng đang hoạt động", "unknown", CHECK_ON_OPEN);
  } else {
    add(
      "operator",
      "Nhà xe đang hoạt động",
      failed("OPERATOR_INACTIVE") ? "fail" : "ok",
      failed("OPERATOR_INACTIVE")
        ? "Tài khoản nhà xe đang bị tạm khóa hoặc ngừng hoạt động. Liên hệ Vé Xe Nhanh để được hỗ trợ."
        : "Tài khoản nhà xe không bị khóa bán"
    );
    add(
      "route",
      "Tuyến đang hoạt động",
      failed("ROUTE_INACTIVE") ? "fail" : "ok",
      failed("ROUTE_INACTIVE")
        ? `Tuyến ${trip.routeName} đã ngừng dùng. Bật lại tuyến ở mục Tuyến đường.`
        : trip.routeName
    );
    add(
      "stops",
      "Mọi điểm dừng đang hoạt động",
      failed("STOP_POINT_INACTIVE") ? "fail" : "ok",
      failed("STOP_POINT_INACTIVE")
        ? "Có điểm dừng của chuyến đang ngừng dùng hoặc bị khóa. Kiểm tra ở mục Điểm dừng."
        : `${trip.stops.length} điểm dừng`
    );
  }

  if (noVehicle) {
    add("vehicle", "Đã gắn xe đang hoạt động", "fail", `Chuyến chưa gắn xe. ${editHint} để gắn xe.`);
  } else if (!checked) {
    add("vehicle", "Đã gắn xe đang hoạt động", "unknown", CHECK_ON_OPEN);
  } else if (failed("VEHICLE_INACTIVE")) {
    add(
      "vehicle",
      "Đã gắn xe đang hoạt động",
      "fail",
      `Xe ${plate ?? "của chuyến"} đang bảo dưỡng hoặc ngừng dùng. Bật lại xe ở mục Phương tiện hoặc đổi xe.`
    );
  } else {
    add("vehicle", "Đã gắn xe đang hoạt động", "ok", plate ?? "Xe đang hoạt động");
  }

  if (noVehicle) {
    add("seats", "Xe có sơ đồ ghế", "unknown", NEEDS_VEHICLE);
  } else if (noSeats) {
    add("seats", "Xe có sơ đồ ghế", "fail", `Chuyến chưa có chỗ nào. ${editHint} để gắn lại xe có sơ đồ ghế.`);
  } else {
    add("seats", "Xe có sơ đồ ghế", "ok", seatCountLabel(trip.seats.length));
  }

  // Có ít nhất một chỗ đã có giá thì chắc chắn tuyến có bảng giá đang áp dụng (bảng giá ngừng áp dụng thì mọi
  // chỗ mất giá) — mục này giao diện tự biết được trước khi bấm.
  const fareKnownActive = prices.some((price) => price !== null);
  if (failed("FARE_MISSING")) {
    add(
      "fare",
      "Tuyến có bảng giá đang áp dụng",
      "fail",
      "Tuyến chưa có bảng giá đang áp dụng. Tạo hoặc bật lại bảng giá ở mục Bảng giá."
    );
  } else if (checked || fareKnownActive) {
    add("fare", "Tuyến có bảng giá đang áp dụng", "ok", `Bảng giá của tuyến ${trip.routeName}`);
  } else {
    add("fare", "Tuyến có bảng giá đang áp dụng", "unknown", CHECK_ON_OPEN);
  }

  const pricesUnknown = checked
    ? noVehicle || noSeats || failed("FARE_MISSING")
    : trip.seats.length === 0 || !fareKnownActive;
  if (pricesUnknown && !missingPrice && !zeroPrice) {
    add("prices", "Mọi chỗ đều có giá lớn hơn 0", "unknown", NEEDS_VEHICLE_AND_FARE);
  } else if (!checked && !fareKnownActive) {
    // Mọi chỗ đều chưa có giá: chưa rõ do thiếu bảng giá hay thiếu quy tắc — để máy chủ kết luận khi bấm.
    add("prices", "Mọi chỗ đều có giá lớn hơn 0", "fail", "Các chỗ của chuyến chưa có giá. Kiểm tra bảng giá của tuyến.");
  } else if (missingPrice || zeroPrice) {
    const parts = [
      missingPrice ? "Bảng giá chưa có giá cho loại xe hoặc loại chỗ của chuyến này." : "",
      zeroPrice ? `Có chỗ đang có giá ${formatVnd(0)}.` : ""
    ].filter(Boolean);
    add("prices", "Mọi chỗ đều có giá lớn hơn 0", "fail", `${parts.join(" ")} Bổ sung ở bảng giá của tuyến.`);
  } else {
    add("prices", "Mọi chỗ đều có giá lớn hơn 0", "ok", "Giá lấy theo bảng giá của tuyến");
  }

  add(
    "window",
    "Còn trong thời gian bán online",
    windowClosed ? "fail" : "ok",
    windowClosed
      ? `Đã qua mốc ngừng bán online (${closeLabel}). ${editHint} để đổi giờ khởi hành hoặc số phút ngừng bán.`
      : `Ngừng bán lúc ${closeLabel}`
  );
  return items;
}

/** Dòng tóm tắt dưới tiêu đề khối Điều kiện mở bán. */
export function readinessSummary(items: readonly ReadinessItem[], checked: boolean): string {
  const count = (state: ReadinessState) => items.filter((item) => item.state === state).length;
  const parts = [`${count("ok")} mục đạt`, `${count("fail")} mục chưa đạt`];
  if (count("unknown") > 0) {
    parts.push(`${count("unknown")} mục ${checked ? "chưa kiểm được" : "chờ kiểm"}`);
  }
  return checked
    ? `Kết quả lần bấm Mở bán gần nhất: ${parts.join(", ")}.`
    : `Chưa bấm Mở bán: ${parts.join(", ")}.`;
}

// ── Chỗ của chuyến ──

/** Số chỗ theo từng tình trạng, để dựng thẻ "Tình trạng chỗ". */
export function seatStatusCounts(seats: readonly Pick<TripSeat, "status">[]): Record<TripSeatStatus, number> {
  const counts: Record<TripSeatStatus, number> = { AVAILABLE: 0, HOLDING: 0, BOOKED: 0, CHECKED_IN: 0, BLOCKED: 0 };
  for (const seat of seats) {
    counts[seat.status] += 1;
  }
  return counts;
}

/** Số vé đã bán của chuyến: chỗ Đã bán + Đã lên xe. Có vé thì không thu hồi về nháp / hủy ở màn này được. */
export function soldSeatCount(seats: readonly Pick<TripSeat, "status">[]): number {
  const counts = seatStatusCounts(seats);
  return counts.BOOKED + counts.CHECKED_IN;
}

/** Khóa / mở khóa chỗ được khi chuyến đang Nháp, Đang mở bán hoặc Tạm dừng bán (BR-42). */
export function canEditSeats(status: TripStatus): boolean {
  return status === "DRAFT" || status === "OPEN_FOR_SALE" || status === "LOCKED";
}

export type SeatSelectionMode = "lock" | "unlock";
export type SeatSelection = { mode: SeatSelectionMode; codes: string[] };

/** Chỗ Còn trống chọn để khóa, chỗ Đã khóa chọn để mở khóa; chỗ đang giữ / đã bán / đã lên xe không chọn được. */
export function seatSelectionMode(status: TripSeatStatus): SeatSelectionMode | null {
  if (status === "AVAILABLE") {
    return "lock";
  }
  return status === "BLOCKED" ? "unlock" : null;
}

/**
 * Bấm một chỗ: thêm / bỏ khỏi lô đang chọn. Một lô chỉ gồm một loại (cùng khóa hoặc cùng mở khóa) vì máy chủ đổi
 * cả lô sang một trạng thái; bấm chỗ khác loại khi đang có lô thì không đổi gì — phải bỏ chọn trước.
 */
export function toggleSeat(
  selection: SeatSelection | null,
  seat: Pick<TripSeat, "code" | "status">
): SeatSelection | null {
  const mode = seatSelectionMode(seat.status);
  if (!mode || (selection && selection.mode !== mode)) {
    return selection;
  }
  const current = selection?.codes ?? [];
  const codes = current.includes(seat.code) ? current.filter((code) => code !== seat.code) : [...current, seat.code];
  return codes.length === 0 ? null : { mode, codes };
}

/**
 * Lô đang chọn sau khi sơ đồ ghế được tải lại: bỏ chỗ không còn ở tình trạng chọn được (vừa có khách giữ, vừa
 * bị khóa ở phiên khác…), xếp theo thứ tự trên sơ đồ.
 */
export function validSelection(
  selection: SeatSelection | null,
  seats: readonly Pick<TripSeat, "code" | "status">[]
): SeatSelection | null {
  if (!selection) {
    return null;
  }
  const codes = seats
    .filter((seat) => selection.codes.includes(seat.code) && seatSelectionMode(seat.status) === selection.mode)
    .map((seat) => seat.code);
  return codes.length === 0 ? null : { mode: selection.mode, codes };
}

/** Câu báo sau khi khóa / mở khóa chỗ: `Đã khóa 2 chỗ: A05, A06`. */
export function seatChangeNotice(mode: SeatSelectionMode, codes: readonly string[]): string {
  return `${mode === "lock" ? "Đã khóa" : "Đã mở khóa"} ${seatCountLabel(codes.length)}: ${codes.join(", ")}`;
}

// ── Lỗi của máy chủ ──

/** Lỗi khi đổi trạng thái bán (trừ 422 chưa đủ điều kiện mở bán — lỗi đó hiện ở khối Điều kiện mở bán). */
export function describeStatusChangeError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "TRIP_STATUS_TRANSITION_INVALID":
        return "Chuyến vừa đổi trạng thái hoặc đã có vé nên thao tác này không còn dùng được. Trang đã tải lại thông tin mới nhất.";
      case "TRIP_NOT_FOUND":
        return "Chuyến không còn tồn tại. Vui lòng quay lại danh sách.";
      case "SERVICE_UNAVAILABLE":
        return "Máy chủ đang bận nên chuyến chưa đổi trạng thái. Vui lòng thử lại sau.";
    }
    if (error.status === 400) {
      return "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại lý do đã nhập.";
    }
  }
  return "Chưa đổi được trạng thái chuyến. Vui lòng kiểm tra kết nối và thử lại.";
}

/** Lỗi khi khóa / mở khóa chỗ. */
export function describeSeatChangeError(error: unknown): string {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "TRIP_SEAT_NOT_AVAILABLE":
        return "Có chỗ vừa được giữ hoặc đã bán nên chưa đổi được chỗ nào. Sơ đồ ghế đã tải lại, vui lòng chọn lại.";
      case "TRIP_SEAT_UNKNOWN":
        return "Sơ đồ ghế của chuyến vừa thay đổi nên chưa đổi được chỗ nào. Sơ đồ ghế đã tải lại, vui lòng chọn lại.";
      case "TRIP_NOT_EDITABLE":
        return "Chuyến đã hủy hoặc đã khởi hành nên không khóa / mở khóa chỗ được nữa.";
      case "TRIP_NOT_FOUND":
        return "Chuyến không còn tồn tại. Vui lòng quay lại danh sách.";
      case "SERVICE_UNAVAILABLE":
        return "Chuyến đang được cập nhật bởi thao tác khác. Vui lòng thử lại.";
    }
    if (error.status === 400) {
      return "Thông tin chưa hợp lệ. Vui lòng kiểm tra lại ghi chú đã nhập.";
    }
  }
  return "Chưa đổi được tình trạng chỗ. Vui lòng kiểm tra kết nối và thử lại.";
}
