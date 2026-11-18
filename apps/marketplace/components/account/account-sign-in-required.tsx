import Link from "next/link";

export interface AccountSignInRequiredProps {
  /** Câu mô tả theo trang đang mở; mặc định dùng cho các trang Tài khoản. */
  readonly description?: string;
}

/** Hiển thị trạng thái cần đăng nhập khi API từ chối phiên hành khách. */
export function AccountSignInRequired({ description = "Đăng nhập bằng email để xem và quản lý tài khoản của bạn." }: AccountSignInRequiredProps) {
  return (
    <div className="mx-auto max-w-xl space-y-4 px-6 py-16 text-center">
      <h1 className="text-2xl font-semibold">Vui lòng đăng nhập</h1>
      <p className="text-muted-foreground">{description}</p>
      <Link href="/login" className="inline-block rounded-lg bg-vxn-teal-700 px-5 py-3 text-white">Đăng nhập</Link>
    </div>
  );
}
