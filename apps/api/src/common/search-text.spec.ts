import { describe, expect, it, vi } from "vitest";
import { SearchQueryField, searchTextContains } from "./search-text";

describe("SearchQueryField — tham số `q`", () => {
  it("cắt khoảng trắng; trống coi như không tìm; quá 100 ký tự bị từ chối", () => {
    expect(SearchQueryField.parse("  bến xe ")).toBe("bến xe");
    expect(SearchQueryField.parse("   ")).toBeUndefined();
    expect(SearchQueryField.parse(undefined)).toBeUndefined();
    expect(SearchQueryField.safeParse("x".repeat(101)).success).toBe(false);
  });
});

// Việc bỏ dấu do hàm database làm; kiểm trên Postgres thật ở route.int.spec / catalog.int.spec.
describe("searchTextContains — giá trị cho điều kiện LIKE", () => {
  const dbReturning = (value: string) => ({
    $queryRaw: vi.fn(async () => [{ value }]),
  });

  it("gửi từ khoá dưới dạng tham số, trả kết quả đã chuẩn hoá của database", async () => {
    const db = dbReturning("ben xe mien dong");
    expect(await searchTextContains(db as never, "Bến xe Miền Đông")).toBe(
      "ben xe mien dong",
    );
    const [strings, ...values] = db.$queryRaw.mock.calls[0] as unknown as [
      string[],
      ...unknown[],
    ];
    expect(strings.join("?")).toBe("SELECT vxn_search_text(?) AS value");
    expect(values).toEqual(["Bến xe Miền Đông"]);
  });

  it.each([
    ["50%", "50\\%"],
    ["a_b", "a\\_b"],
    ["a\\b", "a\\\\b"],
    ["%_\\", "\\%\\_\\\\"],
  ])("vô hiệu ký tự đại diện của LIKE: %j → %j", async (normalized, expected) => {
    expect(await searchTextContains(dbReturning(normalized) as never, "x")).toBe(
      expected,
    );
  });
});
