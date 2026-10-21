// Phân quyền tài khoản quản trị (FR-IAM-07, TASK-IAM-007): nhãn + nhóm theo màn hình của thanh bên + mẫu điền sẵn.
// Quyền nào tick được do API quyết (`grantable`, theo vai trò và quyền của người thao tác) — file này chỉ là chữ.
import type { PermissionGroup, PermissionTemplate } from "@vexenhanh/ui/lib/permission-matrix";

import type { PlatformAccount, PlatformRole } from "./user-api";

export type Permission = PlatformAccount["permissions"][number];

export const PERMISSION_GROUPS: PermissionGroup<Permission>[] = [
  {
    label: "Đối tác & người dùng",
    items: [
      { permission: "kyc:review", label: "Duyệt nhà xe & KYC", description: "Hồ sơ đăng ký, giấy tờ, yêu cầu đổi tài khoản nhận tiền." },
      { permission: "user:manage", label: "Nhà xe & người dùng", description: "Tạm khóa nhà xe, khóa hành khách, xem nhân viên nhà xe." },
      { permission: "access:manage", label: "Tài khoản quản trị & phân quyền", description: "Cấp, khóa, cấp lại mật khẩu và phân quyền tài khoản quản trị." }
    ]
  },
  {
    label: "Danh mục & chính sách",
    items: [
      { permission: "catalog:manage", label: "Danh mục & điểm dừng", description: "Tỉnh, loại xe, tiện ích, điểm dùng chung, duyệt đề xuất điểm." },
      { permission: "finance:configure", label: "Chính sách & hoa hồng", description: "Phiên bản chính sách, hoa hồng, khung giá." }
    ]
  },
  {
    label: "Tài chính",
    items: [
      { permission: "payment:monitor", label: "Xem thanh toán & báo cáo", description: "Thanh toán, hoàn tiền, chi trả, báo cáo — chỉ xem." },
      { permission: "refund:manage", label: "Xử lý hoàn tiền", description: "Gửi lại cổng, ghi nhận đã hoàn thủ công." },
      { permission: "payout:manage", label: "Chi trả nhà xe", description: "Lập đợt chi trả, xác nhận đã chuyển khoản." },
      { permission: "system:run", label: "Chạy đối soát", description: "Chạy đối soát thanh toán thủ công." }
    ]
  },
  {
    label: "Hỗ trợ & nội dung",
    items: [
      { permission: "support:manage", label: "Khiếu nại & tranh chấp", description: "Phân loại, phân công, trả lời, yêu cầu minh chứng." },
      { permission: "dispute:decide", label: "Quyết định tranh chấp", description: "Ra quyết định, kể cả hoàn tiền cho khách." },
      { permission: "content:moderate", label: "Kiểm duyệt", description: "Đánh giá, ảnh phương tiện, nội dung công khai." },
      { permission: "promotion:configure", label: "Khuyến mãi", description: "Khuyến mãi nền tảng, quyền khuyến mãi của nhà xe." },
      { permission: "loyalty:manage", label: "VXN Plus", description: "Tra cứu, điều chỉnh điểm thành viên." },
      { permission: "content:manage", label: "Bài viết", description: "Soạn, xuất bản, gỡ bài viết và chuyên mục." }
    ]
  },
  {
    label: "Hệ thống",
    items: [
      { permission: "audit:read", label: "Nhật ký audit", description: "Tra cứu nhật ký thao tác toàn hệ thống." },
      { permission: "system:read", label: "Tích hợp & hệ thống", description: "Trạng thái dịch vụ, tác vụ nền — chỉ xem." }
    ]
  }
];

/** Mẫu điền sẵn theo vai trò khi cấp / phân quyền. */
export const PERMISSION_TEMPLATES: Record<PlatformRole, PermissionTemplate<Permission>[]> = {
  PLATFORM_ADMIN: [
    { id: "all", label: "Toàn quyền", permissions: "all" },
    { id: "partner", label: "Vận hành đối tác", permissions: ["kyc:review", "user:manage", "catalog:manage", "payment:monitor"] },
    { id: "finance", label: "Kế toán", permissions: ["payment:monitor", "refund:manage", "payout:manage", "system:run"] },
    { id: "care", label: "Chăm sóc khách hàng", permissions: ["support:manage", "payment:monitor", "content:moderate"] },
    { id: "content", label: "Nội dung & khuyến mãi", permissions: ["content:manage", "content:moderate", "promotion:configure", "loyalty:manage"] }
  ],
  PLATFORM_SUPPORT: [{ id: "all", label: "Đủ quyền hỗ trợ", permissions: "all" }]
};

const CATALOG_SIZE = PERMISSION_GROUPS.reduce((total, group) => total + group.items.length, 0);

/** Tóm tắt cột "Quyền": quản trị viên đủ cả danh mục → "Toàn quyền", ngược lại "N quyền". */
export function permissionSummary(account: Pick<PlatformAccount, "role" | "permissions">): string {
  if (account.permissions.length === 0) {
    return "Chưa có quyền";
  }
  return account.role === "PLATFORM_ADMIN" && account.permissions.length >= CATALOG_SIZE ? "Toàn quyền" : `${account.permissions.length} quyền`;
}
