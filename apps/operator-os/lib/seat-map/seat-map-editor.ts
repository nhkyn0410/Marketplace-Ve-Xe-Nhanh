// Dữ liệu và luật của trình soạn sơ đồ ghế (06 UI §7 "lưới tự do", BR-78). Hàm thuần, không đụng React,
// để test được. Giới hạn dưới đây khớp `SeatMapInputDto` của API.
import { ApiError } from "../auth/api-client";
import type { SeatMap, SeatMapInput, SeatType } from "../vehicle/vehicle-api";

export const MAX_DECKS = 2;
export const MAX_ROWS = 30;
export const MAX_COLUMNS = 10;
export const MAX_SEATS = 100;
export const NAME_MAX_LENGTH = 100;
const CODE_PATTERN = /^[A-Z0-9]{1,8}$/;

/** Một ô của lưới: có chỗ, hoặc `null` là ô trống / lối đi. */
export type EditorCell = { code: string; type: SeatType } | null;
/** Một tầng: kích thước lưới và các ô theo `[hàng][cột]`. */
export type EditorDeck = { rows: number; columns: number; cells: EditorCell[][] };
/** Vị trí ô trong trình soạn, đánh số từ 0. */
export type CellPosition = { deck: number; row: number; column: number };
/** Kích thước một tầng nhập ở khối "Cấu hình bố cục". */
export type DeckSize = { rows: number; columns: number };

/** Thứ tự và thông tin của 5 loại chỗ (BR-78): nhãn, tên gọi trong câu, sức chứa. */
export const SEAT_TYPES: { type: SeatType; label: string; noun: string; capacity: 1 | 2 }[] = [
  { type: "SEAT", label: "Ghế", noun: "ghế", capacity: 1 },
  { type: "BED", label: "Giường đơn", noun: "giường đơn", capacity: 1 },
  { type: "BED_DOUBLE", label: "Giường đôi", noun: "giường đôi", capacity: 2 },
  { type: "CABIN", label: "Cabin đơn", noun: "cabin đơn", capacity: 1 },
  { type: "CABIN_DOUBLE", label: "Cabin đôi", noun: "cabin đôi", capacity: 2 }
];

/** Thông tin của một loại chỗ. */
export function seatTypeInfo(type: SeatType) {
  return SEAT_TYPES.find((item) => item.type === type)!;
}

/** Sức chứa của một loại chỗ: chỗ đôi 2 người, còn lại 1 (BR-78). */
export function seatCapacity(type: SeatType): number {
  return seatTypeInfo(type).capacity;
}

/** Chữ cái đầu mã chỗ theo tầng: tầng 1 là `A`, tầng 2 là `B`. */
export function deckLetter(deckIndex: number): string {
  return String.fromCharCode("A".charCodeAt(0) + deckIndex);
}

function formatCode(deckIndex: number, number: number): string {
  return `${deckLetter(deckIndex)}${String(number).padStart(2, "0")}`;
}

/** Kích thước tầng hợp lệ: số nguyên, 1–30 hàng và 1–10 cột. */
export function isValidDeckSize(size: DeckSize): boolean {
  return (
    Number.isInteger(size.rows) &&
    Number.isInteger(size.columns) &&
    size.rows >= 1 &&
    size.rows <= MAX_ROWS &&
    size.columns >= 1 &&
    size.columns <= MAX_COLUMNS
  );
}

/** Tạo lưới mới: mọi ô là loại chỗ ban đầu, mã đánh theo thứ tự `A01`, `A02`… rồi `B01`… */
export function generateDecks(sizes: DeckSize[], type: SeatType): EditorDeck[] {
  return sizes.map((size, deckIndex) => ({
    rows: size.rows,
    columns: size.columns,
    cells: Array.from({ length: size.rows }, (_, row) =>
      Array.from({ length: size.columns }, (_, column) => ({
        code: formatCode(deckIndex, row * size.columns + column + 1),
        type
      }))
    )
  }));
}

/** Dựng lưới từ sơ đồ đã lưu (mở để sửa, xem hoặc tạo bản sao). */
export function decksFromSeatMap(seatMap: Pick<SeatMap, "layout" | "seats">): EditorDeck[] {
  return seatMap.layout.decks.map((deck) => {
    const cells: EditorCell[][] = Array.from({ length: deck.rows }, () =>
      Array.from({ length: deck.columns }, () => null)
    );
    for (const seat of seatMap.seats) {
      if (seat.deck === deck.deck) {
        cells[seat.row - 1]![seat.column - 1] = { code: seat.code, type: seat.type };
      }
    }
    return { rows: deck.rows, columns: deck.columns, cells };
  });
}

/** Body gửi API: bố cục từng tầng và danh sách chỗ (vị trí đánh số từ 1). */
export function toSeatMapInput(name: string, decks: EditorDeck[]): SeatMapInput {
  return {
    name: name.trim(),
    layout: { decks: decks.map((deck, index) => ({ deck: index + 1, rows: deck.rows, columns: deck.columns })) },
    seats: decks.flatMap((deck, deckIndex) =>
      deck.cells.flatMap((cells, row) =>
        cells.flatMap((cell, column) =>
          cell ? [{ code: cell.code, deck: deckIndex + 1, row: row + 1, column: column + 1, type: cell.type }] : []
        )
      )
    )
  };
}

/** Ô tại một vị trí (`undefined` nếu vị trí nằm ngoài lưới). */
export function cellAt(decks: EditorDeck[], position: CellPosition): EditorCell | undefined {
  return decks[position.deck]?.cells[position.row]?.[position.column];
}

function replaceCell(decks: EditorDeck[], position: CellPosition, cell: EditorCell): EditorDeck[] {
  return decks.map((deck, deckIndex) =>
    deckIndex !== position.deck
      ? deck
      : {
          ...deck,
          cells: deck.cells.map((cells, row) =>
            row !== position.row ? cells : cells.map((current, column) => (column === position.column ? cell : current))
          )
        }
  );
}

/** Mã còn trống nhỏ nhất của một tầng (`A01`, `A02`…), không trùng với mã nào trong cả sơ đồ. */
export function nextSeatCode(decks: EditorDeck[], deckIndex: number): string {
  const used = new Set(decks.flatMap((deck) => deck.cells.flat().flatMap((cell) => (cell ? [cell.code] : []))));
  for (let number = 1; ; number++) {
    const code = formatCode(deckIndex, number);
    if (!used.has(code)) {
      return code;
    }
  }
}

/**
 * Đổi loại của một ô. `null` biến ô thành ô trống / lối đi; đặt loại cho ô đang trống thì tạo chỗ mới với
 * mã còn trống kế tiếp của tầng đó; ô đã có chỗ thì giữ nguyên mã.
 */
export function changeCellType(decks: EditorDeck[], position: CellPosition, type: SeatType | null): EditorDeck[] {
  const current = cellAt(decks, position);
  if (current === undefined) {
    return decks;
  }
  if (type === null) {
    return replaceCell(decks, position, null);
  }
  return replaceCell(decks, position, { code: current?.code ?? nextSeatCode(decks, position.deck), type });
}

/** Đổi mã của một chỗ; mã được chuẩn hoá chữ hoa, bỏ khoảng trắng hai đầu. Ô trống thì không đổi gì. */
export function changeCellCode(decks: EditorDeck[], position: CellPosition, code: string): EditorDeck[] {
  const current = cellAt(decks, position);
  return current ? replaceCell(decks, position, { ...current, code: code.trim().toUpperCase() }) : decks;
}

/** Số liệu của một nhóm chỗ: số chỗ, sức chứa và câu phân loại ("9 cabin đơn + 2 cabin đôi"). */
export type SeatSummary = { seatCount: number; passengerCapacity: number; singles: number; doubles: number; breakdown: string };

function summarizeCells(cells: EditorCell[]): SeatSummary {
  const seats = cells.filter((cell) => cell !== null);
  const doubles = seats.filter((seat) => seatCapacity(seat.type) === 2).length;
  return {
    seatCount: seats.length,
    passengerCapacity: seats.length + doubles,
    singles: seats.length - doubles,
    doubles,
    breakdown: SEAT_TYPES.map((item) => ({ item, count: seats.filter((seat) => seat.type === item.type).length }))
      .filter(({ count }) => count > 0)
      .map(({ item, count }) => `${count} ${item.noun}`)
      .join(" + ")
  };
}

/** Số liệu của cả sơ đồ và của từng tầng (số chỗ khác sức chứa — BR-78). */
export function summarizeDecks(decks: EditorDeck[]): SeatSummary & { decks: SeatSummary[] } {
  return {
    ...summarizeCells(decks.flatMap((deck) => deck.cells.flat())),
    decks: decks.map((deck) => summarizeCells(deck.cells.flat()))
  };
}

/** Khoá của một ô trong bảng lỗi theo ô. */
export function cellKey(position: CellPosition): string {
  return `${position.deck}:${position.row}:${position.column}`;
}

/** Kết quả kiểm sơ đồ trước khi lưu: lỗi tên, lỗi theo từng ô (mã), và lỗi chung của bố cục. */
export type SeatMapIssues = { name?: string; cells: Map<string, string>; layout: string[] };

/** Sơ đồ không còn lỗi nào thì mới được lưu. */
export function hasIssues(issues: SeatMapIssues): boolean {
  return issues.name !== undefined || issues.cells.size > 0 || issues.layout.length > 0;
}

/**
 * Kiểm sơ đồ theo cùng luật với API: tên 1–100 ký tự; 1–100 chỗ; mã 1–8 ký tự A–Z, 0–9 và không trùng.
 * Riêng trình soạn còn yêu cầu mỗi tầng có ít nhất một chỗ (Khanh chốt 05/10/2026).
 */
export function validateSeatMap(name: string, decks: EditorDeck[]): SeatMapIssues {
  const issues: SeatMapIssues = { cells: new Map(), layout: [] };
  const trimmed = name.trim();
  if (trimmed === "") {
    issues.name = "Nhập tên sơ đồ.";
  } else if (trimmed.length > NAME_MAX_LENGTH) {
    issues.name = `Tên sơ đồ tối đa ${NAME_MAX_LENGTH} ký tự.`;
  }

  const summary = summarizeDecks(decks);
  if (summary.seatCount === 0) {
    issues.layout.push("Sơ đồ chưa có chỗ nào.");
  } else {
    summary.decks.forEach((deck, index) => {
      if (deck.seatCount === 0) {
        issues.layout.push(`Tầng ${index + 1} chưa có chỗ nào. Thêm chỗ hoặc giảm số tầng.`);
      }
    });
  }
  if (summary.seatCount > MAX_SEATS) {
    issues.layout.push(
      `Sơ đồ có ${summary.seatCount} chỗ, vượt giới hạn ${MAX_SEATS}. Chuyển bớt ô thành ô trống.`
    );
  }

  const firstByCode = new Map<string, string>();
  decks.forEach((deck, deckIndex) =>
    deck.cells.forEach((cells, row) =>
      cells.forEach((cell, column) => {
        if (!cell) {
          return;
        }
        const key = cellKey({ deck: deckIndex, row, column });
        if (cell.code === "") {
          issues.cells.set(key, "Nhập mã chỗ.");
        } else if (!CODE_PATTERN.test(cell.code)) {
          issues.cells.set(key, "Mã chỗ chỉ gồm 1–8 ký tự A–Z, 0–9.");
        } else if (firstByCode.has(cell.code)) {
          const message = `Mã ${cell.code} đã tồn tại. Hãy chọn mã khác.`;
          issues.cells.set(key, message);
          issues.cells.set(firstByCode.get(cell.code)!, message);
        } else {
          firstByCode.set(cell.code, key);
        }
      })
    )
  );
  return issues;
}

/** Ô của trình soạn mà lỗi lưu thuộc về; `inUse` = sơ đồ vừa bị khóa vì có chuyến dùng. */
export type SeatMapSaveError = { kind: "name" | "form" | "inUse" | "notFound"; message: string };

/** Đổi lỗi API khi lưu sơ đồ thành thông báo cho người dùng (mã lỗi theo GLOSSARY). */
export function describeSeatMapSaveError(error: unknown): SeatMapSaveError {
  if (error instanceof ApiError) {
    switch (error.code) {
      case "SEAT_MAP_NAME_CONFLICT":
        return { kind: "name", message: "Tên sơ đồ đã có trong nhà xe. Hãy đặt tên khác." };
      case "SEAT_MAP_IN_USE":
        return {
          kind: "inUse",
          message: "Sơ đồ vừa được dùng cho chuyến nên không lưu được. Tạo bản sao để giữ các chỉnh sửa."
        };
      case "SEAT_MAP_NOT_FOUND":
        return { kind: "notFound", message: "Sơ đồ không còn tồn tại. Vui lòng quay lại danh sách." };
    }
    if (error.status === 400) {
      return { kind: "form", message: "Sơ đồ chưa hợp lệ. Vui lòng kiểm tra lại tên, mã chỗ và bố cục." };
    }
  }
  return { kind: "form", message: "Chưa lưu được sơ đồ. Vui lòng kiểm tra kết nối và thử lại." };
}
