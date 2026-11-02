import { LoginEntry } from "../../../components/auth/auth-entries";

/**
 * Modal đăng nhập phủ lên trang đang xem (intercepting route).
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <LoginEntry params={await searchParams} variant="overlay" />;
}
