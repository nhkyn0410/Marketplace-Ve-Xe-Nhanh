import { RegisterProfileEntry } from "../../../../components/auth/auth-entries";

/**
 * Modal tạo tài khoản bước 2 phủ lên trang đang xem.
 */
export default async function Page({ searchParams }: { readonly searchParams: Promise<{ readonly [key: string]: string | string[] | undefined }> }) {
  return <RegisterProfileEntry params={await searchParams} variant="overlay" />;
}
