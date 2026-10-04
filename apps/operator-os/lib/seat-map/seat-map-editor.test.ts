import { describe, expect, it } from "vitest";

import { ApiError } from "../auth/api-client";
import type { SeatMap } from "../vehicle/vehicle-api";
import {
  cellAt,
  changeCellCode,
  changeCellType,
  decksFromSeatMap,
  describeSeatMapSaveError,
  generateDecks,
  hasIssues,
  isValidDeckSize,
  nextSeatCode,
  summarizeDecks,
  toSeatMapInput,
  validateSeatMap
} from "./seat-map-editor";

const twoDecks = () =>
  generateDecks(
    [
      { rows: 2, columns: 3 },
      { rows: 1, columns: 2 }
    ],
    "BED"
  );

describe("generateDecks — tạo lưới (06 UI §7)", () => {
  it("mọi ô là loại chỗ ban đầu; mã đánh theo hàng: tầng 1 A01…, tầng 2 B01…", () => {
    const decks = twoDecks();
    expect(decks.map((deck) => deck.cells.map((row) => row.map((cell) => cell?.code)))).toEqual([
      [
        ["A01", "A02", "A03"],
        ["A04", "A05", "A06"]
      ],
      [["B01", "B02"]]
    ]);
    expect(decks.flatMap((deck) => deck.cells.flat()).every((cell) => cell?.type === "BED")).toBe(true);
  });

  it("kích thước riêng từng tầng, đúng giới hạn 1–30 hàng và 1–10 cột", () => {
    expect(twoDecks().map(({ rows, columns }) => [rows, columns])).toEqual([
      [2, 3],
      [1, 2]
    ]);
    expect(isValidDeckSize({ rows: 30, columns: 10 })).toBe(true);
    for (const size of [
      { rows: 0, columns: 3 },
      { rows: 31, columns: 3 },
      { rows: 3, columns: 11 },
      { rows: 2.5, columns: 3 },
      { rows: Number.NaN, columns: 3 }
    ]) {
      expect(isValidDeckSize(size), JSON.stringify(size)).toBe(false);
    }
  });
});

describe("đổi ô", () => {
  it("chuyển thành ô trống rồi đặt lại chỗ: lấy mã còn trống nhỏ nhất của tầng đó", () => {
    const position = { deck: 0, row: 0, column: 1 };
    const emptied = changeCellType(twoDecks(), position, null);
    expect(cellAt(emptied, position)).toBeNull();
    expect(nextSeatCode(emptied, 0)).toBe("A02");
    expect(nextSeatCode(emptied, 1)).toBe("B03");

    const restored = changeCellType(emptied, position, "CABIN_DOUBLE");
    expect(cellAt(restored, position)).toEqual({ code: "A02", type: "CABIN_DOUBLE" });
  });

  it("đổi loại của chỗ đang có thì giữ nguyên mã; không sửa mảng gốc", () => {
    const original = twoDecks();
    const changed = changeCellType(original, { deck: 1, row: 0, column: 0 }, "BED_DOUBLE");
    expect(cellAt(changed, { deck: 1, row: 0, column: 0 })).toEqual({ code: "B01", type: "BED_DOUBLE" });
    expect(cellAt(original, { deck: 1, row: 0, column: 0 })).toEqual({ code: "B01", type: "BED" });
  });

  it("mã mới không trùng mã người dùng đã tự đặt ở tầng khác", () => {
    let decks = changeCellCode(twoDecks(), { deck: 1, row: 0, column: 0 }, "A07");
    decks = changeCellType(decks, { deck: 0, row: 0, column: 0 }, null);
    expect(nextSeatCode(decks, 0)).toBe("A01");
    decks = changeCellCode(decks, { deck: 1, row: 0, column: 1 }, "a01");
    expect(nextSeatCode(decks, 0)).toBe("A08");
  });

  it("đổi mã: chuẩn hoá chữ hoa, bỏ khoảng trắng; ô trống và vị trí ngoài lưới không đổi gì", () => {
    const decks = changeCellCode(twoDecks(), { deck: 0, row: 0, column: 0 }, " vip1 ");
    expect(cellAt(decks, { deck: 0, row: 0, column: 0 })?.code).toBe("VIP1");
    const emptied = changeCellType(decks, { deck: 0, row: 0, column: 0 }, null);
    expect(changeCellCode(emptied, { deck: 0, row: 0, column: 0 }, "X1")).toBe(emptied);
    expect(changeCellType(decks, { deck: 5, row: 0, column: 0 }, "SEAT")).toBe(decks);
  });
});

describe("summarizeDecks — số chỗ khác sức chứa (BR-78)", () => {
  it("chỗ đôi tính hai người; tách theo tầng và nêu phân loại", () => {
    let decks = generateDecks(
      [
        { rows: 2, columns: 2 },
        { rows: 1, columns: 2 }
      ],
      "CABIN"
    );
    decks = changeCellType(decks, { deck: 0, row: 1, column: 0 }, "CABIN_DOUBLE");
    decks = changeCellType(decks, { deck: 0, row: 1, column: 1 }, null);
    decks = changeCellType(decks, { deck: 1, row: 0, column: 1 }, "BED_DOUBLE");
    const summary = summarizeDecks(decks);
    expect(summary).toMatchObject({ seatCount: 5, passengerCapacity: 7, singles: 3, doubles: 2 });
    expect(summary.decks.map((deck) => [deck.seatCount, deck.passengerCapacity, deck.breakdown])).toEqual([
      [3, 4, "2 cabin đơn + 1 cabin đôi"],
      [2, 3, "1 giường đôi + 1 cabin đơn"]
    ]);
  });
});

describe("toSeatMapInput ↔ decksFromSeatMap", () => {
  it("gửi vị trí đánh số từ 1, bỏ ô trống, tên đã cắt khoảng trắng", () => {
    const decks = changeCellType(twoDecks(), { deck: 0, row: 0, column: 1 }, null);
    const input = toSeatMapInput("  Giường 8  ", decks);
    expect(input.name).toBe("Giường 8");
    expect(input.layout).toEqual({
      decks: [
        { deck: 1, rows: 2, columns: 3 },
        { deck: 2, rows: 1, columns: 2 }
      ]
    });
    expect(input.seats).toHaveLength(7);
    expect(input.seats[0]).toEqual({ code: "A01", deck: 1, row: 1, column: 1, type: "BED" });
    expect(input.seats[1]).toEqual({ code: "A03", deck: 1, row: 1, column: 3, type: "BED" });
    expect(input.seats.at(-1)).toEqual({ code: "B02", deck: 2, row: 1, column: 2, type: "BED" });
  });

  it("mở sơ đồ đã lưu rồi lưu lại không đổi dữ liệu (kể cả ô trống và kích thước từng tầng)", () => {
    const decks = changeCellType(twoDecks(), { deck: 0, row: 1, column: 2 }, null);
    const input = toSeatMapInput("Sơ đồ", decks);
    const reopened = decksFromSeatMap(input as Pick<SeatMap, "layout" | "seats">);
    expect(reopened).toEqual(decks);
    expect(toSeatMapInput("Sơ đồ", reopened)).toEqual(input);
  });
});

describe("validateSeatMap — cùng luật với API + mỗi tầng phải có chỗ", () => {
  it("sơ đồ hợp lệ không có lỗi", () => {
    const issues = validateSeatMap("Giường 8", twoDecks());
    expect(issues).toEqual({ cells: new Map(), layout: [] });
    expect(hasIssues(issues)).toBe(false);
  });

  it("tên trống hoặc quá 100 ký tự", () => {
    expect(validateSeatMap("   ", twoDecks()).name).toBe("Nhập tên sơ đồ.");
    expect(validateSeatMap("a".repeat(101), twoDecks()).name).toBe("Tên sơ đồ tối đa 100 ký tự.");
    expect(validateSeatMap("a".repeat(100), twoDecks()).name).toBeUndefined();
  });

  it("không có chỗ nào; một tầng không có chỗ", () => {
    const empty = generateDecks([{ rows: 1, columns: 1 }], "SEAT");
    expect(validateSeatMap("x", changeCellType(empty, { deck: 0, row: 0, column: 0 }, null)).layout).toEqual([
      "Sơ đồ chưa có chỗ nào."
    ]);
    let decks = twoDecks();
    decks = changeCellType(decks, { deck: 1, row: 0, column: 0 }, null);
    decks = changeCellType(decks, { deck: 1, row: 0, column: 1 }, null);
    expect(validateSeatMap("x", decks).layout).toEqual(["Tầng 2 chưa có chỗ nào. Thêm chỗ hoặc giảm số tầng."]);
  });

  it("quá 100 chỗ → báo số chỗ hiện có; đúng 100 thì qua", () => {
    expect(validateSeatMap("x", generateDecks([{ rows: 10, columns: 10 }], "SEAT")).layout).toEqual([]);
    expect(validateSeatMap("x", generateDecks([{ rows: 11, columns: 10 }], "SEAT")).layout).toEqual([
      "Sơ đồ có 110 chỗ, vượt giới hạn 100. Chuyển bớt ô thành ô trống."
    ]);
  });

  it("mã trùng → báo ở cả hai ô (kể cả khác tầng); mã trống / ký tự lạ / quá 8 ký tự → báo tại ô", () => {
    let decks = changeCellCode(twoDecks(), { deck: 1, row: 0, column: 0 }, "a01");
    decks = changeCellCode(decks, { deck: 0, row: 0, column: 1 }, "");
    decks = changeCellCode(decks, { deck: 0, row: 0, column: 2 }, "A-3");
    decks = changeCellCode(decks, { deck: 0, row: 1, column: 0 }, "ABCDEFGHI");
    const issues = validateSeatMap("x", decks);
    expect(Object.fromEntries(issues.cells)).toEqual({
      "0:0:0": "Mã A01 đã tồn tại. Hãy chọn mã khác.",
      "1:0:0": "Mã A01 đã tồn tại. Hãy chọn mã khác.",
      "0:0:1": "Nhập mã chỗ.",
      "0:0:2": "Mã chỗ chỉ gồm 1–8 ký tự A–Z, 0–9.",
      "0:1:0": "Mã chỗ chỉ gồm 1–8 ký tự A–Z, 0–9."
    });
    expect(hasIssues(issues)).toBe(true);
  });
});

describe("describeSeatMapSaveError", () => {
  it.each([
    ["SEAT_MAP_NAME_CONFLICT", 409, "name"],
    ["SEAT_MAP_IN_USE", 409, "inUse"],
    ["SEAT_MAP_NOT_FOUND", 404, "notFound"],
    ["VALIDATION_ERROR", 400, "form"]
  ])("%s → %s", (code, status, kind) => {
    expect(describeSeatMapSaveError(new ApiError(status, code, "chi tiết máy chủ")).kind).toBe(kind);
  });

  it("lỗi mạng → thông báo chung, không lộ chi tiết kỹ thuật", () => {
    expect(describeSeatMapSaveError(new TypeError("Failed to fetch"))).toEqual({
      kind: "form",
      message: "Chưa lưu được sơ đồ. Vui lòng kiểm tra kết nối và thử lại."
    });
  });
});
