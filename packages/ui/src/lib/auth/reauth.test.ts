import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { ApiError, resetApiClientForTest } from "./api-client";
import {
  describeReauthError,
  forgetReauth,
  hasRecentReauth,
  isReauthRequired,
  reauthenticate,
  toReauthBody,
  withReauth
} from "./reauth";

function json(status: number, body: unknown): Response {
  return new Response(JSON.stringify(body), { status, headers: { "content-type": "application/json" } });
}

describe("toReauthBody", () => {
  it("đúng 6 chữ số (kể cả gõ cách đôi) là mã của ứng dụng xác thực", () => {
    expect(toReauthBody("123456")).toEqual({ mfaCode: "123456" });
    expect(toReauthBody(" 123 456 ")).toEqual({ mfaCode: "123456" });
  });

  it("mọi dạng khác là mật khẩu, giữ nguyên từng ký tự kể cả khoảng trắng", () => {
    expect(toReauthBody("mat-khau-rat-dai-2026")).toEqual({ password: "mat-khau-rat-dai-2026" });
    expect(toReauthBody(" co khoang trang ")).toEqual({ password: " co khoang trang " });
    expect(toReauthBody("1234567")).toEqual({ password: "1234567" });
    expect(toReauthBody("12345a")).toEqual({ password: "12345a" });
  });
});

describe("bằng chứng xác nhận lại danh tính", () => {
  const bodies: unknown[] = [];
  let respond: (path: string) => Response;

  beforeEach(() => {
    resetApiClientForTest();
    forgetReauth();
    bodies.length = 0;
    vi.stubGlobal(
      "fetch",
      vi.fn(async (url: string, init: RequestInit) => {
        const path = url.replace("http://localhost:3000/v1", "");
        if (path === "/auth/csrf") {
          return json(200, { csrfToken: "csrf" });
        }
        if (path === "/auth/re-auth") {
          bodies.push(JSON.parse(String(init.body)));
        }
        return respond(path);
      })
    );
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it("xác nhận đúng thì nhớ bằng chứng gần 5 phút, hết thì hỏi lại", async () => {
    respond = () => json(200, { status: "ok" });
    const start = 1_000_000;
    expect(hasRecentReauth(start)).toBe(false);
    await reauthenticate("123456", start);
    expect(bodies).toEqual([{ mfaCode: "123456" }]);
    expect(hasRecentReauth(start + 4 * 60_000)).toBe(true);
    // Hết sớm hơn máy chủ 30 giây để không gửi thao tác sát mốc.
    expect(hasRecentReauth(start + 5 * 60_000 - 30_000)).toBe(false);
  });

  it("sai mật khẩu: ném lỗi, không nhớ bằng chứng, thao tác không chạy", async () => {
    respond = () => json(401, { code: "AUTH_INVALID_CREDENTIALS", detail: "x" });
    const action = vi.fn(async () => "done");
    const error = await withReauth("sai-mat-khau-12", action).catch((e: unknown) => e);
    expect((error as ApiError).code).toBe("AUTH_INVALID_CREDENTIALS");
    expect(action).not.toHaveBeenCalled();
    expect(hasRecentReauth()).toBe(false);
    expect(describeReauthError(error)).toBe("Mật khẩu hoặc mã xác thực không đúng.");
  });

  it("còn bằng chứng thì chạy thẳng thao tác, không gọi re-auth", async () => {
    respond = () => json(200, { status: "ok" });
    await reauthenticate("mat-khau-rat-dai-2026");
    bodies.length = 0;
    await expect(withReauth(null, async () => "done")).resolves.toBe("done");
    expect(bodies).toEqual([]);
  });

  it("máy chủ báo bằng chứng không còn (vd phiên vừa được làm mới): quên mốc đã nhớ để hỏi lại", async () => {
    respond = () => json(200, { status: "ok" });
    await reauthenticate("mat-khau-rat-dai-2026");
    expect(hasRecentReauth()).toBe(true);
    const lost = new ApiError(401, "AUTH_REAUTH_REQUIRED", "x");
    const error = await withReauth(null, async () => {
      throw lost;
    }).catch((e: unknown) => e);
    expect(error).toBe(lost);
    expect(isReauthRequired(error)).toBe(true);
    expect(hasRecentReauth()).toBe(false);
  });

  it("lỗi của chính thao tác không làm mất bằng chứng", async () => {
    respond = () => json(200, { status: "ok" });
    await reauthenticate("mat-khau-rat-dai-2026");
    await withReauth(null, async () => {
      throw new ApiError(409, "ACCOUNT_USERNAME_CONFLICT", "x");
    }).catch(() => undefined);
    expect(hasRecentReauth()).toBe(true);
  });
});

describe("describeReauthError", () => {
  it("chỉ nhận lỗi của bước xác nhận lại danh tính", () => {
    expect(describeReauthError(new ApiError(401, "AUTH_REAUTH_REQUIRED", "x"))).toMatch(/xác nhận lại danh tính/);
    expect(describeReauthError(new ApiError(429, "AUTH_OTP_RATE_LIMITED", "x"))).toMatch(/quá nhiều lần/);
    expect(describeReauthError(new ApiError(409, "ACCOUNT_USERNAME_CONFLICT", "x"))).toBeNull();
    expect(describeReauthError(new TypeError("Failed to fetch"))).toBeNull();
  });
});
