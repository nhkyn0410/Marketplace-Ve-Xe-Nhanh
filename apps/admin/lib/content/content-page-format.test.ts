import { ApiError } from "@vexenhanh/ui/lib/auth/api-client";
import { describe, expect, it } from "vitest";

import { changeType, contentErrors, describeContentError, emptyContentValues, toContentInput } from "./content-page-format";

describe("nội dung công khai (ADM-003)", () => {
  it("đổi loại: vị trí về vị trí đầu của loại mới, bỏ đường dẫn / ảnh / liên kết không thuộc loại", () => {
    const banner = { ...changeType(emptyContentValues(), "BANNER"), imageKey: "content-pages/a.jpg", linkUrl: "/tim-chuyen" };
    expect(banner.placement).toBe("HOME");
    const page = changeType(banner, "PAGE");
    expect(page).toMatchObject({ placement: "FOOTER", imageKey: null, linkUrl: "" });
    expect(changeType(page, "FAQ").placement).toBe("BOOKING");
  });

  it("kiểm theo loại giống máy chủ", () => {
    expect(contentErrors(emptyContentValues())).toMatchObject({ title: "Nhập tiêu đề.", bodyMarkdown: "Nhập nội dung." });
    const page = { ...changeType(emptyContentValues(), "PAGE"), title: "Điều khoản", bodyMarkdown: "x", slug: "Dieu Khoan" };
    expect(contentErrors(page)).toHaveProperty("slug");
    const banner = { ...changeType(emptyContentValues(), "BANNER"), title: "Banner", linkUrl: "//evil.example" };
    expect(contentErrors(banner)).toMatchObject({ imageKey: "Tải ảnh banner lên.", linkUrl: expect.any(String) });
    expect(contentErrors({ ...banner, imageKey: "content-pages/a.jpg", linkUrl: "/tim-chuyen" })).toEqual({});
    expect(contentErrors({ ...banner, imageKey: "k", linkUrl: "", displayOrder: "1000" })).toHaveProperty("displayOrder");
  });

  it("body API: trường không thuộc loại gửi null, tiêu đề / liên kết cắt khoảng trắng, thứ tự là số", () => {
    expect(
      toContentInput({ ...emptyContentValues(), title: "  Có cần tài khoản?  ", bodyMarkdown: "Không.", slug: "x", linkUrl: "/y", displayOrder: "3" })
    ).toEqual({
      type: "FAQ",
      placement: "BOOKING",
      title: "Có cần tài khoản?",
      slug: null,
      bodyMarkdown: "Không.",
      imageKey: null,
      linkUrl: null,
      displayOrder: 3
    });
  });

  it("lỗi lưu → ô tương ứng", () => {
    expect(describeContentError(new ApiError(409, "CONTENT_PAGE_SLUG_CONFLICT", "x")).field).toBe("slug");
    expect(describeContentError(new ApiError(422, "CONTENT_IMAGE_INVALID", "x")).field).toBe("imageKey");
    expect(describeContentError(new ApiError(503, "SERVICE_UNAVAILABLE", "x")).message).toContain("nhật ký");
    expect(describeContentError(new Error("mạng")).field).toBe("form");
  });
});
