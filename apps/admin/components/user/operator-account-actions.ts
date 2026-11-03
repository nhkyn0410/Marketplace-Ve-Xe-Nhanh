import { resetOperatorPassword, type OperatorAccount } from "../../lib/user/user-api";
import type { AccountAction } from "./account-dialogs";

/** Hộp xác nhận cấp lại mật khẩu nhà xe và thông báo đúng kết quả gửi email. */
export function operatorPasswordAction(account: Pick<OperatorAccount, "id" | "username" | "email">): AccountAction {
  return {
    title: "Cấp lại mật khẩu tạm",
    subtitle: `${account.username} · ${account.email ?? "chưa có email"}`,
    warning: "Mật khẩu cũ hết hiệu lực và mọi phiên đăng nhập của tài khoản bị thu hồi.",
    note: "Mật khẩu tạm có hiệu lực 24 giờ, gửi tới email của tài khoản và phải đổi khi đăng nhập. Nhà xe đang tạm khóa cần được mở khóa để đăng nhập lại.",
    withReason: true,
    confirmLabel: "Cấp lại mật khẩu",
    run: (reason) => resetOperatorPassword(account.id, reason),
    done: `Đã cấp lại mật khẩu tạm cho ${account.username}.`,
    outcome: (result) => {
      const updated = result as OperatorAccount;
      return updated.credentialDeliveryPending
        ? { tone: "warning", text: `Đã đổi mật khẩu cho ${account.username} nhưng chưa gửi được email. Tài khoản đang chờ gửi mật khẩu tạm; hãy thử cấp lại sau.` }
        : { tone: "success", text: `Đã gửi mật khẩu tạm cho ${account.username} tới ${updated.email}.` };
    }
  };
}
