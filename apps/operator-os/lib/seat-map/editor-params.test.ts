import { describe, expect, it } from "vitest";

import { parseSeatMapId, parseVehicleReturn } from "./editor-params";

const ID = "3f2b8c1e-9d4a-4c7b-8e21-0a1b2c3d4e5f";

describe("tham số URL của trình soạn sơ đồ ghế", () => {
  it("nhận đúng dạng mong đợi", () => {
    expect(parseSeatMapId(ID)).toBe(ID);
    expect(parseVehicleReturn(ID)).toBe(ID);
    expect(parseVehicleReturn("new")).toBe("new");
  });

  it.each([undefined, "", "abc", "../admin", "//evil.example", `${ID}/..`, [ID, ID]])(
    "bỏ qua giá trị lạ %j — đường quay lại luôn là một trang trong app",
    (value) => {
      expect(parseSeatMapId(value)).toBeUndefined();
      expect(parseVehicleReturn(value)).toBeUndefined();
    }
  );

  it("`new` chỉ hợp lệ cho tham số vehicle, không phải id sơ đồ nguồn", () => {
    expect(parseSeatMapId("new")).toBeUndefined();
  });
});
