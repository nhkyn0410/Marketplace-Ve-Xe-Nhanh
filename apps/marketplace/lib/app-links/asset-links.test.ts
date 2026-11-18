import { describe, expect, it } from "vitest";
import { androidAssetLinks } from "./asset-links";

const fingerprint = Array.from({ length: 32 }, (_, index) => index.toString(16).padStart(2, "0")).join(":");

// PASSENGER-PARITY A25: assetlinks.json cho App Link cổng thanh toán quay về app.
describe("Digital Asset Links của app hành khách", () => {
  it("khai gói + vân tay (chuẩn hóa chữ hoa, bỏ giá trị sai dạng)", () => {
    expect(androidAssetLinks(" com.vexenhanh.passenger_mobile ", `${fingerprint}, sai-dang`)).toEqual([
      {
        relation: ["delegate_permission/common.handle_all_urls"],
        target: {
          namespace: "android_app",
          package_name: "com.vexenhanh.passenger_mobile",
          sha256_cert_fingerprints: [fingerprint.toUpperCase()]
        }
      }
    ]);
  });

  it("thiếu gói hoặc vân tay thì không khai gì — link mở trên web như thường", () => {
    expect(androidAssetLinks(undefined, fingerprint)).toEqual([]);
    expect(androidAssetLinks("com.vexenhanh.passenger_mobile", undefined)).toEqual([]);
    expect(androidAssetLinks("not a package", fingerprint)).toEqual([]);
  });
});
