import { renderToStaticMarkup } from "react-dom/server";
import { describe, expect, it, vi } from "vitest";

import { LoginView } from "./login-view";

vi.mock("next/navigation", () => ({ useRouter: () => ({ push: vi.fn(), refresh: vi.fn() }) }));
vi.mock("next/script", () => ({ default: () => null }));
vi.mock("../../lib/data/auth", () => ({ requestLoginOtp: vi.fn(), loginWithGoogle: vi.fn() }));

describe("đăng nhập web (SCR-PSG-07)", () => {
  it("có Client ID Google thì hiện nút Google dưới form email", () => {
    const html = renderToStaticMarkup(<LoginView googleClientId="web-client.apps.googleusercontent.com" />);
    expect(html).toContain("Tiếp tục với email");
    expect(html).toContain("hoặc");
    expect(html).toContain('id="google-login-button"');
  });

  it("chưa cấu hình Google hoặc đang xem preview thì chỉ có đăng nhập bằng email", () => {
    for (const html of [
      renderToStaticMarkup(<LoginView googleClientId="" />),
      renderToStaticMarkup(<LoginView googleClientId="web-client.apps.googleusercontent.com" isPreview />)
    ]) {
      expect(html).toContain("Tiếp tục với email");
      expect(html).not.toContain("google-login-button");
    }
  });
});
