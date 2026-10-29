import { describe, expect, it } from "vitest";
import { localityName } from "../database/stop-localities";
import { composeRouteName, nameCandidates, ROUTE_NAME_MAX } from "./route-name";

const stop = (locality: string, name = `Bến ${locality}`, allowPickup = true, allowDropoff = true) => ({ locality, name, allowPickup, allowDropoff });

describe("localityName — tên nơi của điểm dừng theo đơn vị hành chính cũ", () => {
  it("thành phố trực thuộc trung ương cũ → tên thành phố, không tách quận (TP.HCM gọn)", () => {
    expect(localityName({ provinceName: "Thành phố Hồ Chí Minh", legacyProvinceName: "Thành phố Hồ Chí Minh", legacyDistrictName: "Quận 1" })).toBe("TP.HCM");
    expect(localityName({ provinceName: "Thành phố Hồ Chí Minh", legacyProvinceName: "Thành phố Hồ Chí Minh", legacyDistrictName: "Thành phố Thủ Đức" })).toBe("TP.HCM");
    expect(localityName({ provinceName: "Thành phố Đà Nẵng", legacyProvinceName: "Thành phố Đà Nẵng", legacyDistrictName: "Quận Hải Châu" })).toBe("Đà Nẵng");
  });

  it("thành phố / thị xã / huyện cũ của tỉnh khác → tên đơn vị bỏ cấp (kể cả nay thuộc TP.HCM như Vũng Tàu)", () => {
    expect(localityName({ provinceName: "Thành phố Hồ Chí Minh", legacyProvinceName: "Tỉnh Bà Rịa - Vũng Tàu", legacyDistrictName: "Thành phố Vũng Tàu" })).toBe("Vũng Tàu");
    expect(localityName({ provinceName: "Tỉnh Lâm Đồng", legacyProvinceName: "Tỉnh Đắk Nông", legacyDistrictName: "Thành phố Gia Nghĩa" })).toBe("Gia Nghĩa");
    expect(localityName({ provinceName: "Tỉnh Lâm Đồng", legacyProvinceName: "Tỉnh Lâm Đồng", legacyDistrictName: "Huyện Di Linh" })).toBe("Di Linh");
  });

  it("không có dữ liệu tên cũ → tên tỉnh mới gọn", () => {
    expect(localityName({ provinceName: "Tỉnh Lâm Đồng", legacyProvinceName: null, legacyDistrictName: null })).toBe("Lâm Đồng");
    expect(localityName({ provinceName: "Thành phố Hồ Chí Minh", legacyProvinceName: null, legacyDistrictName: null })).toBe("TP.HCM");
  });
});

describe("composeRouteName — tên tuyến tự động", () => {
  it("nơi điểm đầu → nơi điểm cuối, kèm (qua …) cho nơi khác có điểm cho đón / trả", () => {
    expect(composeRouteName([stop("TP.HCM"), stop("TP.HCM", "Bến xe An Sương"), stop("Gia Nghĩa"), stop("Buôn Ma Thuột")])).toBe(
      "TP.HCM → Buôn Ma Thuột (qua Gia Nghĩa)",
    );
    expect(composeRouteName([stop("TP.HCM"), stop("Vũng Tàu")])).toBe("TP.HCM → Vũng Tàu");
  });

  it("bỏ trạm dừng nghỉ (không đón / trả) khỏi phần qua; nơi lặp chỉ ghi một lần", () => {
    const rest = stop("Bảo Lộc", "Trạm nghỉ", false, false);
    expect(composeRouteName([stop("TP.HCM"), rest, stop("Di Linh"), stop("Di Linh", "Bến Di Linh 2"), stop("Đà Lạt")])).toBe("TP.HCM → Đà Lạt (qua Di Linh)");
  });

  it("hai đầu cùng một nơi → tên hai điểm", () => {
    expect(composeRouteName([stop("TP.HCM", "Bến xe Miền Đông"), stop("TP.HCM", "Bến xe Miền Tây")])).toBe("Bến xe Miền Đông → Bến xe Miền Tây");
  });

  it("quá dài thì bớt nơi qua ở cuối, không vượt giới hạn", () => {
    const stops = [stop("A"), ...Array.from({ length: 20 }, (_, index) => stop(`Nơi giữa số ${index} khá dài`)), stop("B")];
    const name = composeRouteName(stops);
    expect(name.length).toBeLessThanOrEqual(ROUTE_NAME_MAX);
    expect(name).toMatch(/^A → B \(qua Nơi giữa số 0 khá dài, .*…\)$/);
  });
});

describe("nameCandidates — tránh trùng tên tuyến của nhà xe", () => {
  it("tên gốc, rồi kèm bến đầu, rồi đánh số; hậu tố không bị cắt khi tên dài", () => {
    expect(nameCandidates("TP.HCM → Đà Lạt", "Bến xe Miền Đông").slice(0, 3)).toEqual([
      "TP.HCM → Đà Lạt", "TP.HCM → Đà Lạt · Bến xe Miền Đông", "TP.HCM → Đà Lạt (2)",
    ]);
    const long = "x".repeat(ROUTE_NAME_MAX);
    for (const name of nameCandidates(long, "Bến").slice(1)) {
      expect(name.length).toBeLessThanOrEqual(ROUTE_NAME_MAX);
    }
    expect(nameCandidates(long, "Bến")[2]).toMatch(/… \(2\)$/);
  });
});
