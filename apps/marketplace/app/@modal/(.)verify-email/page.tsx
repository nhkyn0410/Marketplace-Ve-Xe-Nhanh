import { VerifyEmailEntry } from "../../../components/auth/auth-entries";

/**
 * Modal nhập OTP phủ lên trang đang xem.
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <VerifyEmailEntry params={await searchParams} variant="overlay" />;
}
