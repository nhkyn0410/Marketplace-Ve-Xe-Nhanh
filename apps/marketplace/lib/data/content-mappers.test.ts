import { describe, expect, it } from "vitest";
import { resolveLegalAlias } from "./content-mappers";

const kitSlugs = ["gioi-thieu", "quy-che-hoat-dong", "chinh-sach-bao-mat", "co-che-giai-quyet-tranh-chap", "huong-dan-dat-ve"];

describe("resolveLegalAlias", () => {
  it("maps fixed web links to the published CMS page", () => {
    expect(resolveLegalAlias("privacy-policy", kitSlugs)).toBe("chinh-sach-bao-mat");
    expect(resolveLegalAlias("privacy", kitSlugs)).toBe("chinh-sach-bao-mat");
    expect(resolveLegalAlias("terms-of-service", kitSlugs)).toBe("quy-che-hoat-dong");
    expect(resolveLegalAlias("terms", kitSlugs)).toBe("quy-che-hoat-dong");
  });

  it("prefers a dedicated page when the CMS has one", () => {
    expect(resolveLegalAlias("terms-of-service", [...kitSlugs, "dieu-khoan-su-dung"])).toBe("dieu-khoan-su-dung");
    expect(resolveLegalAlias("terms", ["terms-of-service", "quy-che-hoat-dong"])).toBe("terms-of-service");
  });

  it("returns null when no matching page is published or the slug has no alias", () => {
    expect(resolveLegalAlias("refund-policy", kitSlugs)).toBeNull();
    expect(resolveLegalAlias("gioi-thieu", kitSlugs)).toBeNull();
    expect(resolveLegalAlias("privacy-policy", [])).toBeNull();
  });
});
