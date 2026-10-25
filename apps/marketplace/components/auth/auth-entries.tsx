import { redirect } from "next/navigation";
import { z } from "zod";

import { getPreview } from "../../lib/preview";
import { loginFixture, registerFixture, verifyEmailFixture } from "../../lib/preview/fixtures/auth";
import type { AuthModalVariant } from "./auth-modal-shell";
import { LoginView } from "./login-view";
import { RegisterView } from "./register-view";
import { VerifyEmailView } from "./verify-email-view";

/**
 * Đọc tham số và dựng màn xác thực; dùng chung cho trang thường (`app/login`…) và
 * modal phủ trang (`app/@modal/(.)login`…) để hai đường vào luôn giống nhau.
 */
type SearchParams = { readonly [key: string]: string | string[] | undefined };

const text = (params: SearchParams, key: string) => (typeof params[key] === "string" ? (params[key] as string) : "");

export function LoginEntry({ params, variant }: { readonly params: SearchParams; readonly variant: AuthModalVariant }) {
  if (getPreview(params) === "ideal") {
    return <LoginView initialEmail={loginFixture.email} isPreview variant={variant} />;
  }
  return <LoginView initialEmail={text(params, "email")} variant={variant} />;
}

export function RegisterEntry({ params, variant }: { readonly params: SearchParams; readonly variant: AuthModalVariant }) {
  if (getPreview(params) === "ideal") {
    return <RegisterView initialData={registerFixture} isPreview variant={variant} />;
  }
  return <RegisterView initialData={{ email: text(params, "email") }} variant={variant} />;
}

export function VerifyEmailEntry({ params, variant }: { readonly params: SearchParams; readonly variant: AuthModalVariant }) {
  if (getPreview(params) === "ideal") {
    return <VerifyEmailView initialData={verifyEmailFixture} isPreview variant={variant} />;
  }
  const email = text(params, "email");
  if (!z.email().safeParse(email).success) redirect("/login");
  return (
    <VerifyEmailView
      initialData={{ email, otpDigits: ["", "", "", "", "", ""], resendCountdownSeconds: 60 }}
      variant={variant}
    />
  );
}
