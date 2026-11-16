import { describe, expect, it } from "vitest";

import { parseSupportHotline } from "./support-contact";

describe("tổng đài hỗ trợ đọc từ một cấu hình", () => {
  it("chưa cấu hình hoặc cấu hình rỗng thì không có số để hiện", () => {
    expect(parseSupportHotline(undefined)).toBeNull();
    expect(parseSupportHotline("")).toBeNull();
    expect(parseSupportHotline("   ")).toBeNull();
    expect(parseSupportHotline("chưa có")).toBeNull();
  });

  it("giữ nguyên số hiển thị và tạo liên kết gọi chỉ gồm chữ số", () => {
    expect(parseSupportHotline(" 1900 1234 ")).toEqual({ label: "1900 1234", telHref: "tel:19001234" });
    expect(parseSupportHotline("+84 28 1234 5678")).toEqual({ label: "+84 28 1234 5678", telHref: "tel:+842812345678" });
  });
});
