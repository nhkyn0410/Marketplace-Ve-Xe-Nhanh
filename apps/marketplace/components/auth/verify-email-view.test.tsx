import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it, vi } from "vitest";

import { formatCountdown, OTP_LIFETIME_SECONDS, VerifyEmailView } from "./verify-email-view";

vi.mock("next/navigation", () => ({ useRouter: () => ({ push: vi.fn(), refresh: vi.fn() }) }));
vi.mock("../../lib/data/auth", () => ({ requestLoginOtp: vi.fn(), verifyOtp: vi.fn() }));

const render = (expiresInSeconds?: number) =>
  renderToStaticMarkup(
    <VerifyEmailView
      initialData={{ email: "khach@example.com", otpDigits: ["", "", "", "", "", ""], resendCountdownSeconds: 60, ...(expiresInSeconds === undefined ? {} : { expiresInSeconds }) }}
    />
  );

describe("nhập mã OTP khi đăng nhập web (SCR-PSG-09)", () => {
  it("đếm ngược hiệu lực mã, mặc định 5 phút như app", () => {
    expect(OTP_LIFETIME_SECONDS).toBe(300);
    expect(render()).toContain("Mã hết hạn sau 05:00");
    expect(render(272)).toContain("Mã hết hạn sau 04:32");
  });

  it("hết giờ thì báo mã đã hết hạn, hướng dẫn gửi lại", () => {
    const html = render(0);
    expect(html).toContain("Mã đã hết hạn. Hãy gửi lại mã mới.");
    expect(html).not.toContain("Mã hết hạn sau");
  });

  it("định dạng phút:giây", () => {
    expect(formatCountdown(300)).toBe("05:00");
    expect(formatCountdown(59)).toBe("00:59");
    expect(formatCountdown(-3)).toBe("00:00");
  });
});
