import { describe, expect, it } from "vitest";

import {
  formatDate,
  OWN_STOP_POINT_TYPES,
  PROPOSAL_STATUS,
  PROPOSAL_STOP_POINT_TYPES,
  provinceLabel,
  routeCountLabel,
  SHARED_STOP_POINT_TYPES,
  STOP_POINT_STATUS,
  STOP_POINT_TYPE_LABELS
} from "./stop-point-format";

describe("nhãn điểm dừng", () => {
  it("bốn loại điểm theo BR-38; nhà xe tự tạo và đề xuất là hai nhóm không trùng nhau", () => {
    expect(STOP_POINT_TYPE_LABELS).toEqual({
      BUS_STATION: "Bến xe",
      PICKUP_POINT: "Điểm dừng đón trả khách",
      OFFICE: "Văn phòng trung chuyển",
      REST_STOP: "Trạm dừng nghỉ"
    });
    expect([...OWN_STOP_POINT_TYPES]).toEqual(["OFFICE", "REST_STOP"]);
    expect([...PROPOSAL_STOP_POINT_TYPES]).toEqual(["BUS_STATION", "PICKUP_POINT"]);
    expect(OWN_STOP_POINT_TYPES.filter((type) => (PROPOSAL_STOP_POINT_TYPES as readonly string[]).includes(type))).toEqual([]);
    expect([...SHARED_STOP_POINT_TYPES]).toEqual(["BUS_STATION", "PICKUP_POINT", "REST_STOP"]);
  });

  it("trạng thái luôn kèm chữ: Bị khóa và Bị từ chối dùng màu cảnh báo đỏ", () => {
    expect(STOP_POINT_STATUS.SUSPENDED).toEqual({ label: "Bị khóa", tone: "danger" });
    expect(STOP_POINT_STATUS.INACTIVE.label).toBe("Ngừng dùng");
    expect(PROPOSAL_STATUS.REJECTED).toMatchObject({ label: "Bị từ chối", tone: "danger" });
    expect(PROPOSAL_STATUS.PENDING.label).toBe("Chờ duyệt");
  });
});

describe("routeCountLabel", () => {
  it.each([
    [0, "Chưa dùng"],
    [1, "1 tuyến"],
    [12, "12 tuyến"]
  ])("%i → %j", (count, label) => {
    expect(routeCountLabel(count)).toBe(label);
  });
});

describe("formatDate", () => {
  it("hiện ngày theo giờ Việt Nam, kể cả khi giờ UTC còn ở ngày hôm trước", () => {
    expect(formatDate("2026-10-02T03:00:00.000Z")).toBe("02/10/2026");
    expect(formatDate("2026-10-01T18:30:00.000Z")).toBe("02/10/2026");
  });
});

describe("provinceLabel", () => {
  it("tỉnh đã ngừng trong danh mục thì báo rõ thay vì để trống", () => {
    const names = new Map([["a", "Lâm Đồng"]]);
    expect(provinceLabel(names, "a")).toBe("Lâm Đồng");
    expect(provinceLabel(names, "b")).toBe("Tỉnh / thành đã ngừng dùng");
  });
});
