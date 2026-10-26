import { redirect } from "next/navigation";
import { z } from "zod";

import { getAccountProfile } from "../../lib/data/auth";
import { getPreview } from "../../lib/preview";
import { loginFixture, registerFixture, verifyEmailFixture } from "../../lib/preview/fixtures/auth";
import type { AuthModalVariant } from "./auth-modal-shell";
import { LoginView } from "./login-view";
import { RegisterProfileView } from "./register-profile-view";
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
  const flow = text(params, "flow") === "register" ? "register" : "login";
  if (getPreview(params) === "ideal") {
    return <VerifyEmailView initialData={verifyEmailFixture} isPreview variant={variant} flow={flow} />;
  }
  const email = text(params, "email");
  if (!z.email().safeParse(email).success) redirect("/login");
  return (
    <VerifyEmailView
      initialData={{ email, otpDigits: ["", "", "", "", "", ""], resendCountdownSeconds: 60 }}
      variant={variant}
      flow={flow}
    />
  );
}

/** Bước 2 Tạo tài khoản: cần phiên vừa xác minh; chưa đăng nhập thì quay về đăng nhập. */
export async function RegisterProfileEntry({ params, variant }: { readonly params: SearchParams; readonly variant: AuthModalVariant }) {
  if (getPreview(params) === "ideal") {
    return <RegisterProfileView email={registerFixture.email} isPreview variant={variant} />;
  }
  const profile = await getAccountProfile();
  if (profile.status !== "ok") redirect("/login");
  return (
    <RegisterProfileView
      email={profile.data.email}
      initialFullName={profile.data.fullName}
      initialPhone={profile.data.phone}
      variant={variant}
    />
  );
}
