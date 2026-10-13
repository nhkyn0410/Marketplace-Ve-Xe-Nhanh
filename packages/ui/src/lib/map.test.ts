import { describe, expect, it } from "vitest";

import { boundsOf, goongStyleUrl, isValidPoint, pointsKey, VIETNAM_BOUNDS } from "./map";

describe("goongStyleUrl", () => {
  it("luôn trỏ tới bản đồ nền của Goong và mã hóa khóa", () => {
    const url = new URL(goongStyleUrl("abc 123&x=1"));
    expect(url.origin).toBe("https://tiles.goong.io");
    expect(url.pathname).toBe("/assets/goong_map_web.json");
    expect(url.searchParams.get("api_key")).toBe("abc 123&x=1");
    expect([...url.searchParams.keys()]).toEqual(["api_key"]);
  });
});

describe("VIETNAM_BOUNDS", () => {
  it("bao cả Hoàng Sa và Trường Sa", () => {
    const inside = (latitude: number, longitude: number) =>
      latitude >= VIETNAM_BOUNDS.south &&
      latitude <= VIETNAM_BOUNDS.north &&
      longitude >= VIETNAM_BOUNDS.west &&
      longitude <= VIETNAM_BOUNDS.east;
    expect(inside(16.5, 111.6)).toBe(true); // Hoàng Sa
    expect(inside(8.64, 111.92)).toBe(true); // Trường Sa Lớn
    expect(inside(10.38, 114.36)).toBe(true); // Ba Bình, giữa quần đảo Trường Sa
    expect(inside(8.86, 116.27)).toBe(true); // Bãi Trăng Khuyết, rìa đông Trường Sa
    expect(inside(21.03, 105.85)).toBe(true); // Hà Nội
    expect(inside(8.6, 104.72)).toBe(true); // Mũi Cà Mau
  });
});

describe("isValidPoint", () => {
  it("nhận tọa độ trong khoảng và loại giá trị ngoài khoảng / không phải số", () => {
    expect(isValidPoint({ latitude: 11.9404, longitude: 108.4583 })).toBe(true);
    expect(isValidPoint({ latitude: -90, longitude: 180 })).toBe(true);
    expect(isValidPoint({ latitude: 90.01, longitude: 0 })).toBe(false);
    expect(isValidPoint({ latitude: 0, longitude: -180.5 })).toBe(false);
    expect(isValidPoint({ latitude: Number.NaN, longitude: 0 })).toBe(false);
    expect(isValidPoint({ latitude: 0, longitude: Number.POSITIVE_INFINITY })).toBe(false);
  });
});

describe("boundsOf", () => {
  it("không có điểm hợp lệ thì trả null", () => {
    expect(boundsOf([])).toBeNull();
    expect(boundsOf([{ latitude: Number.NaN, longitude: 0 }])).toBeNull();
  });

  it("một điểm cho khung có diện tích bằng không", () => {
    expect(boundsOf([{ latitude: 10.75, longitude: 106.68 }])).toEqual({
      west: 106.68,
      south: 10.75,
      east: 106.68,
      north: 10.75
    });
  });

  it("bao mọi điểm và bỏ qua điểm sai", () => {
    expect(
      boundsOf([
        { latitude: 10.75, longitude: 106.68 },
        { latitude: 12.25, longitude: 109.19 },
        { latitude: 11.94, longitude: 108.45 },
        { latitude: 200, longitude: 500 }
      ])
    ).toEqual({ west: 106.68, south: 10.75, east: 109.19, north: 12.25 });
  });
});

describe("pointsKey", () => {
  it("đổi khi thứ tự hoặc tọa độ đổi, giữ nguyên khi dãy như cũ", () => {
    const a = { latitude: 10.75, longitude: 106.68 };
    const b = { latitude: 12.25, longitude: 109.19 };
    expect(pointsKey([a, b])).toBe(pointsKey([{ ...a }, { ...b }]));
    expect(pointsKey([a, b])).not.toBe(pointsKey([b, a]));
    expect(pointsKey([a])).not.toBe(pointsKey([a, b]));
    expect(pointsKey([])).toBe("");
  });
});
