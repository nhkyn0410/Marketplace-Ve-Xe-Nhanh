import { describe, expect, it } from "vitest";
import { assertCounterBelowOnline, type CommissionScheduleRule } from "./commission-schedule";

const now = new Date("2030-01-01T00:00:00Z");
const at = (day: number) => new Date(now.getTime() + day * 86_400_000);
const rule = (channel: "ONLINE" | "COUNTER", rateBps: number, from = 0, to: number | null = null, operatorId: string | null = "op"): CommissionScheduleRule => ({ channel, rateBps, operatorId, effectiveFrom: at(from), effectiveTo: to === null ? null : at(to) });

describe("Counter commission effective periods", () => {
  it("hai kênh chồng hiệu lực được nếu mức quầy thấp hơn", () => {
    expect(() => assertCounterBelowOnline([rule("ONLINE", 500), rule("COUNTER", 200)], "op", now)).not.toThrow();
  });
  it("kiểm cả mức online giảm ở tương lai trong khoảng quầy không thời hạn", () => {
    expect(() => assertCounterBelowOnline([rule("ONLINE", 500, 0, 5), rule("ONLINE", 100, 5), rule("COUNTER", 200)], "op", now)).toThrow();
  });
  it("mức riêng hết hạn dùng mức online mặc định; kiểm cả biên không bao gồm", () => {
    const rules = [rule("ONLINE", 100, 0, null, null), rule("ONLINE", 500, 0, 5), rule("COUNTER", 200, 0, 5)];
    expect(() => assertCounterBelowOnline(rules, "op", now)).not.toThrow();
    expect(() => assertCounterBelowOnline([...rules.slice(0, 2), rule("COUNTER", 200)], "op", now)).toThrow();
  });
  it("không cấu hình quầy thì 0% hợp lệ ngay cả online 0%; cấu hình bằng online bị từ chối", () => {
    expect(() => assertCounterBelowOnline([rule("ONLINE", 0)], "op", now)).not.toThrow();
    expect(() => assertCounterBelowOnline([rule("ONLINE", 200), rule("COUNTER", 200)], "op", now)).toThrow();
  });
  it("mặc định online chưa cấu hình là500bps; không xét lịch sử đã kết thúc", () => {
    expect(() => assertCounterBelowOnline([rule("COUNTER", 499)], "op", now)).not.toThrow();
    expect(() => assertCounterBelowOnline([rule("COUNTER", 500)], "op", now)).toThrow();
    expect(() => assertCounterBelowOnline([rule("ONLINE", 100), rule("COUNTER", 200, -5, 0)], "op", now)).not.toThrow();
  });
});
