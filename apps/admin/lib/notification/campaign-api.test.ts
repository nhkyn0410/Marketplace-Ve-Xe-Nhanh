import { describe, expect, it } from "vitest";

import { audienceLabel, inQuietHours } from "./campaign-api";

describe("quy tắc hiển thị chiến dịch", () => {
  it("đối tượng theo hạng ghi tên hạng tiếng Việt", () => {
    expect(audienceLabel({ audience: "ALL", tiers: [] })).toBe("Tất cả hành khách");
    expect(audienceLabel({ audience: "LOYALTY_TIER", tiers: ["GOLD", "PLATINUM"] })).toBe("Hạng Vàng, Bạch kim");
  });

  it("giờ yên tĩnh theo giờ Việt Nam, giống máy chủ", () => {
    expect(inQuietHours("PROMOTION", new Date("2026-11-02T14:00:00Z"))).toBe(true); // 21:00 VN
    expect(inQuietHours("NEWS", new Date("2026-11-02T00:59:00Z"))).toBe(true); // 07:59 VN
    expect(inQuietHours("PROMOTION", new Date("2026-11-02T01:00:00Z"))).toBe(false); // 08:00 VN
    expect(inQuietHours("SERVICE", new Date("2026-11-02T20:00:00Z"))).toBe(false); // dịch vụ không chịu giờ yên tĩnh
  });
});
