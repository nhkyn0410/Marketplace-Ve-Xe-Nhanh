import type { DbScope } from "../../database/db-scope";
import type { AuthenticatedRequest } from "../auth/access-token.guard";
import type { GrantScope, Permission } from "./permissions";

/** Metadata key của `@Authorize()` — tách file riêng để decorator và guard không import vòng. */
export const REQUIRED_PERMISSION = "iam:required-permission";

/** Kết quả phân quyền của request — controller truyền `db` xuống service để chạy đúng ngữ cảnh RLS. */
export type Authorization = {
  permission: Permission;
  scope: GrantScope;
  /**
   * `tenant`/`assigned` → `{ kind: "tenant", operatorId }` lấy từ JWT; `any` của PLATFORM_* →
   * `platform`; còn lại `null` (own / công khai): service tự kiểm ownership hoặc dùng ngữ cảnh của
   * task sở hữu.
   */
  db: DbScope | null;
};

export type AuthorizedRequest = AuthenticatedRequest & { authz?: Authorization };
