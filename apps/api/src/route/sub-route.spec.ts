import { describe, expect, it } from "vitest";
import { locateSpan, type ParentStop, scalePrice, scaleRules, sliceStopRows, spanTotals, suggestSpans } from "./sub-route";

/** Điểm giả: mã `p:<id>`, chặng từ điểm trước `km` km / `min` phút. */
function stop(id: string, flags: { pickup: boolean; dropoff: boolean }, km: number | null, min: number | null): ParentStop {
  return {
    catalogStopPointId: null,
    stopPointId: id,
    note: null,
    allowPickup: flags.pickup,
    allowDropoff: flags.dropoff,
    latitude: 10,
    longitude: 106,
    distanceMetersFromPrevious: km === null ? null : km * 1000,
    durationSecondsFromPrevious: min === null ? null : min * 60,
    measuredDurationSeconds: min === null ? null : min * 60,
  };
}
const PICK = { pickup: true, dropoff: false };
const BOTH = { pickup: true, dropoff: true };
const DROP = { pickup: false, dropoff: true };
const REST = { pickup: false, dropoff: false };
const ref = (id: string) => ({ catalogStopPointId: null, stopPointId: id });

// BX Miền Đông, VP Q1 (TP.HCM) → trạm nghỉ (Bình Phước) → VP Gia Nghĩa → BX BMT.
const route = [
  { ...stop("mde", PICK, null, null), locality: "TP.HCM" },
  { ...stop("q1", PICK, 10, 30), locality: "TP.HCM" },
  { ...stop("rest", REST, 120, 150), locality: "Bình Phước" },
  { ...stop("gn", BOTH, 100, 120), locality: "Gia Nghĩa" },
  { ...stop("bmt", DROP, 120, 150), locality: "Buôn Ma Thuột" },
];

describe("tuyến con — tìm đoạn theo mã điểm (3.2)", () => {
  it("đoạn hợp lệ theo chiều tuyến; điểm đầu phải cho đón, điểm cuối cho trả", () => {
    expect(locateSpan(route, ref("q1"), ref("gn"))).toEqual({ from: 1, to: 3 });
    expect(locateSpan(route, ref("gn"), ref("bmt"))).toEqual({ from: 3, to: 4 });
    expect(locateSpan(route, ref("gn"), ref("q1"))).toBeNull(); // ngược chiều
    expect(locateSpan(route, ref("mde"), ref("q1"))).toBeNull(); // VP Q1 không cho trả
    expect(locateSpan(route, ref("rest"), ref("bmt"))).toBeNull(); // trạm nghỉ không cho đón
    expect(locateSpan(route, ref("mde"), ref("bmt"))).toBeNull(); // trùng cả tuyến chính
    expect(locateSpan(route, ref("x"), ref("bmt"))).toBeNull(); // điểm không còn trên tuyến
  });

  it("quãng đường / thời gian của đoạn = cộng các chặng sau điểm đầu", () => {
    expect(spanTotals(route, { from: 1, to: 3 })).toEqual({ distanceMeters: 220_000, durationSeconds: 270 * 60 });
  });
});

describe("tuyến con — gợi ý theo nhóm nơi", () => {
  it("điểm liền nhau cùng nơi gom một nhóm, bỏ trạm nghỉ; mỗi cặp nhóm là một đoạn, trừ cả tuyến", () => {
    expect(suggestSpans(route)).toEqual([
      { from: 0, to: 3 }, // TP.HCM → Gia Nghĩa: từ điểm đón đầu tiên của nhóm TP.HCM
      { from: 3, to: 4 }, // Gia Nghĩa → Buôn Ma Thuột
    ]);
  });

  it("tuyến chỉ hai nơi (hoặc một nơi) không có gợi ý", () => {
    expect(suggestSpans([route[0]!, route[1]!, route[4]!])).toEqual([]);
  });

  it("bốn nơi → năm đoạn; nhóm giữa không có điểm cho trả thì không làm điểm cuối", () => {
    const four = [
      { ...stop("a", PICK, null, null), locality: "A" },
      { ...stop("b", PICK, 10, 10), locality: "B" },
      { ...stop("c", BOTH, 10, 10), locality: "C" },
      { ...stop("d", DROP, 10, 10), locality: "D" },
    ];
    expect(suggestSpans(four)).toEqual([
      { from: 0, to: 2 },
      { from: 1, to: 2 },
      { from: 1, to: 3 },
      { from: 2, to: 3 },
    ]);
  });
});

describe("tuyến con — chép đoạn thành điểm dừng", () => {
  it("đánh số lại từ 1; điểm đầu chỉ đón, không chặng trước; điểm cuối chỉ trả; điểm giữa giữ quyền và số liệu", () => {
    const rows = sliceStopRows("op", "sub", route, { from: 1, to: 4 });
    expect(rows.map((row) => [row.sequence, row.role, row.stopPointId, row.allowPickup, row.allowDropoff, row.distanceMetersFromPrevious])).toEqual([
      [1, "ORIGIN", "q1", true, false, null],
      [2, "INTERMEDIATE", "rest", false, false, 120_000],
      [3, "INTERMEDIATE", "gn", true, true, 100_000],
      [4, "DESTINATION", "bmt", false, true, 120_000],
    ]);
    expect(rows[0]).toMatchObject({ durationSecondsFromPrevious: null, measuredDurationSeconds: null, operatorId: "op", routeId: "sub" });
  });

  it("điểm đầu vốn cho cả đón và trả ở tuyến chính → chỉ đón ở tuyến con", () => {
    const rows = sliceStopRows("op", "sub", route, { from: 3, to: 4 });
    expect(rows[0]).toMatchObject({ role: "ORIGIN", allowPickup: true, allowDropoff: false });
  });
});

describe("tuyến con — giá gợi ý (tiền, bigint)", () => {
  it("theo tỉ lệ quãng đường, làm tròn 5.000đ gần nhất", () => {
    expect(scalePrice(350_000n, 220_000, 350_000)).toBe(220_000n);
    expect(scalePrice(300_000n, 100_000, 350_000)).toBe(85_000n); // 85.714 → 85.000
    expect(scalePrice(300_000n, 110_000, 350_000)).toBe(95_000n); // 94.285 → 95.000
    expect(scalePrice(100_000n, 7_500, 10_000)).toBe(75_000n);
  });

  it("thấp nhất 5.000đ; giá 0 giữ 0; không vượt giá gốc khi đoạn ngắn hơn tuyến", () => {
    expect(scalePrice(100_000n, 1_000, 300_000)).toBe(5_000n);
    expect(scalePrice(0n, 100_000, 300_000)).toBe(0n);
    expect(scalePrice(100_000_000n, 299_999, 300_000)).toBe(100_000_000n);
  });

  it("bảng giá gợi ý giữ nguyên loại xe / loại chỗ / khung giờ; tuyến dài 0 m hoặc không có quy tắc → không gợi ý", () => {
    const rules = [
      { vehicleTypeId: null, seatType: null, validFrom: null, validTo: null, price: 300_000n },
      { vehicleTypeId: "vt", seatType: "BED_DOUBLE" as const, validFrom: null, validTo: null, price: 500_000n },
    ];
    expect(scaleRules(rules, 150_000, 300_000)).toEqual([
      { ...rules[0], price: 150_000n },
      { ...rules[1], price: 250_000n },
    ]);
    expect(scaleRules(rules, 0, 0)).toBeNull();
    expect(scaleRules([], 10, 100)).toBeNull();
  });
});
