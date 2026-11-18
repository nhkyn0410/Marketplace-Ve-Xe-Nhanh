"use client";

import React, { useEffect, useRef, useState } from "react";
import Script from "next/script";
import { AlertCircle, Loader2 } from "lucide-react";
import { loginWithGoogle } from "../../lib/data/auth";

/**
 * Client ID Google loại "Web application" — cùng giá trị `GOOGLE_CLIENT_ID` của API (client ID công khai được).
 * Bỏ trống thì trang đăng nhập không hiện nút Google.
 */
export const GOOGLE_CLIENT_ID = (process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID ?? "").trim();

/** Phần Google Identity Services trang này dùng (https://developers.google.com/identity/gsi/web/reference/js-reference). */
interface GoogleIdentity {
  readonly accounts: {
    readonly id: {
      initialize(options: {
        client_id: string;
        callback: (response: { credential?: string }) => void;
        ux_mode: "popup";
        context: "signin";
      }): void;
      renderButton(
        parent: HTMLElement,
        options: {
          type: "standard";
          theme: "outline";
          size: "large";
          text: "continue_with";
          shape: "rectangular";
          logo_alignment: "center";
          width: number;
          locale: string;
        }
      ): void;
    };
  };
}

/** Sau đăng nhập về Tài khoản, như đăng nhập OTP. */
const TARGET = "/account";

/**
 * Nút "Tiếp tục với Google" (SCR-PSG-07). Google Identity Services trả ID token trong popup; Server Action
 * `loginWithGoogle` đổi lấy phiên. Không dùng luồng chuyển hướng `/auth/oauth/{provider}`: cookie `state`
 * và phiên Better Auth nằm ở domain API, web (khác domain, CORS không mở cho web) không đọc được.
 */
export function GoogleLoginButton({ clientId }: { readonly clientId: string }) {
  const container = useRef<HTMLDivElement>(null);
  const [scriptReady, setScriptReady] = useState(false);
  const [pending, setPending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const google = (window as Window & { google?: GoogleIdentity }).google;
    const parent = container.current;
    if (!scriptReady || !google || !parent) return;

    async function signIn(credential: string | undefined) {
      if (!credential) {
        setError("Không nhận được thông tin đăng nhập Google. Vui lòng thử lại.");
        return;
      }
      setError(null);
      setPending(true);
      try {
        // Thành công thì Server Action tự redirect (router.push sau Server Action ghi cookie trong modal bị hủy).
        const res = await loginWithGoogle({ credential }, TARGET);
        if (!res) return;
        if (res.status === "ok") {
          window.location.assign(TARGET);
        } else if (res.status === "unavailable") {
          setError("Chưa thể đăng nhập bằng Google. Vui lòng thử lại sau.");
        } else {
          setError(res.message ?? "Không thể đăng nhập bằng Google. Vui lòng thử lại.");
        }
      } catch {
        setError("Đã xảy ra lỗi khi đăng nhập bằng Google. Vui lòng thử lại.");
      } finally {
        setPending(false);
      }
    }

    google.accounts.id.initialize({
      client_id: clientId,
      callback: (response) => void signIn(response.credential),
      ux_mode: "popup",
      context: "signin"
    });
    google.accounts.id.renderButton(parent, {
      type: "standard",
      theme: "outline",
      size: "large",
      text: "continue_with",
      shape: "rectangular",
      logo_alignment: "center",
      // Nút của Google rộng tối đa 400px.
      width: Math.min(400, parent.clientWidth || 320),
      locale: "vi"
    });
  }, [scriptReady, clientId]);

  return (
    <div className="flex w-full flex-col items-center gap-2">
      <Script
        src="https://accounts.google.com/gsi/client"
        strategy="afterInteractive"
        onReady={() => setScriptReady(true)}
        onError={() => setError("Không tải được đăng nhập Google. Vui lòng đăng nhập bằng email.")}
      />
      <div id="google-login-button" ref={container} className="flex min-h-11 w-full justify-center" />
      {pending && (
        <p role="status" className="flex items-center gap-2 text-[13px] text-vxn-fg-5">
          <Loader2 className="size-4 animate-spin text-vxn-teal-500" />
          <span>Đang đăng nhập bằng Google…</span>
        </p>
      )}
      {error && (
        <div role="alert" className="flex w-full items-start gap-2 rounded-xl border border-rose-200 bg-rose-50 p-3 text-sm text-rose-700">
          <AlertCircle className="mt-0.5 size-4 shrink-0" />
          <span>{error}</span>
        </div>
      )}
    </div>
  );
}
