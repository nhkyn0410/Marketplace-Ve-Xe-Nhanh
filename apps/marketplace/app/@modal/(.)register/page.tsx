import { RegisterEntry } from "../../../components/auth/auth-entries";

/**
 * Modal tạo tài khoản bước 1 phủ lên trang đang xem.
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <RegisterEntry params={await searchParams} variant="overlay" />;
}
