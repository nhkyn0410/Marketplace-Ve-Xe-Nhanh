import { describe, expect, it } from "vitest";
import { resolveIdentifier } from "./namespace.resolver";

describe("resolveIdentifier", () => {
  it("resolves passenger email", () => {
    expect(resolveIdentifier("a@b.com")).toEqual({ scope: "passenger", email: "a@b.com" });
  });

  it("lowercases passenger email", () => {
    expect(resolveIdentifier("User@Example.COM")).toEqual({
      scope: "passenger",
      email: "user@example.com"
    });
  });

  it("resolves platform namespace", () => {
    expect(resolveIdentifier("platform/khanh")).toEqual({ scope: "platform", username: "khanh" });
  });

  it("resolves operator namespace", () => {
    expect(resolveIdentifier("phuongtrang/owner01")).toEqual({
      scope: "operator",
      operatorSlug: "phuongtrang",
      username: "owner01"
    });
  });

  it("lowercases operator slug but keeps username case", () => {
    expect(resolveIdentifier("PhuongTrang/Owner01")).toEqual({
      scope: "operator",
      operatorSlug: "phuongtrang",
      username: "Owner01"
    });
  });

  it.each([
    ["empty", "   "],
    ["bare username (no slash, not email)", "owner01"],
    ["trailing slash", "phuongtrang/"],
    ["leading slash", "/owner01"],
    ["nested slash", "a/b/c"]
  ])("returns null for %s", (_label, input) => {
    expect(resolveIdentifier(input)).toBeNull();
  });
});
