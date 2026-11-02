import { describe, expect, it } from "vitest";

import { isPublicPath } from "./public-routes";

describe("isPublicPath", () => {
  it("chỉ các trang đăng ký nhà xe là công khai", () => {
    for (const path of ["/register", "/register/resend", "/register/application"]) {
      expect(isPublicPath(path), path).toBe(true);
    }
    for (const path of ["/", "/vehicles", "/registered", "/registers/x", "/account", null]) {
      expect(isPublicPath(path), String(path)).toBe(false);
    }
  });
});
