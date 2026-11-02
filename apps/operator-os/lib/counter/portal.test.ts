import { describe, expect, it } from "vitest";

import { acceptsCounterSession, isCounterPath } from "./portal";

describe("cổng bán vé riêng", () => {
  it("chỉ nhận chủ nhà xe và nhân viên bán vé trong namespace operator", () => {
    expect(acceptsCounterSession({ scope: "operator", role: "OPERATOR_OWNER" })).toBe(true);
    expect(acceptsCounterSession({ scope: "operator", role: "SALES_STAFF" })).toBe(true);
    for (const role of ["DRIVER", "TICKET_STAFF", "SUPPORT_STAFF", "OPERATOR_MANAGER", "PLATFORM_ADMIN"]) {
      expect(acceptsCounterSession({ scope: "operator", role })).toBe(false);
    }
    expect(acceptsCounterSession({ scope: "platform", role: "SALES_STAFF" })).toBe(false);
  });

  it("giữ cổng bán vé trong các đường dẫn riêng, không nhận tiền tố giống tên", () => {
    expect(isCounterPath("/auth/counter/login")).toBe(true);
    expect(isCounterPath("/counter")).toBe(true);
    expect(isCounterPath("/counter/bookings/1")).toBe(true);
    expect(isCounterPath("/counterfeit")).toBe(false);
    expect(isCounterPath("/offices")).toBe(false);
  });
});
