import { Controller, Get, Inject, Param, Query } from "@nestjs/common";
import { ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminAuditLogService } from "./admin-audit-log.service";
import {
  AdminAuditLogDetailDto,
  type AuditLogDetail,
  AdminAuditLogIdParamDto,
  AdminAuditLogListDto,
  type AuditLogList,
  AdminAuditLogListQueryDto,
} from "./dto/admin-audit-log.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const UNAVAILABLE = { status: 503, description: "Kho audit không phản hồi.", content: problemContent };

// API §7.5 — Admin tra cứu nhật ký audit (UC-30, FR-ADM-16, BR-58). Quyền `audit:read` (PLATFORM_ADMIN).
@ApiTags("admin-audit-logs")
@Controller("admin/audit-logs")
/** Nhật ký audit toàn hệ thống, chỉ đọc. */
export class AdminAuditLogController {
  constructor(@Inject(AdminAuditLogService) private readonly logs: AdminAuditLogService) {}

  /** Mới nhất trước; lọc thời gian / loại người thực hiện / phân hệ / kết quả, tìm tài khoản hoặc mã đối tượng. */
  @Get()
  @Authorize("audit:read")
  @ZodResponse({ status: 200, description: "Một trang bản ghi audit.", type: AdminAuditLogListDto })
  @ApiResponse(UNAVAILABLE)
  list(@Authz() authz: Authorization, @Query() query: AdminAuditLogListQueryDto): Promise<AuditLogList> {
    return this.logs.list(authz, query);
  }

  /** Chi tiết một bản ghi (trước / sau đã che, chuỗi bản ghi cùng đối tượng); lượt xem được ghi audit. */
  @Get(":id")
  @Authorize("audit:read")
  @ApiParam({ name: "id", type: String, description: "ObjectId (hex 24 ký tự)." })
  @ZodResponse({ status: 200, description: "Một bản ghi audit.", type: AdminAuditLogDetailDto })
  @ApiResponse({ status: 404, description: "`AUDIT_LOG_NOT_FOUND`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  get(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminAuditLogIdParamDto,
  ): Promise<AuditLogDetail> {
    return this.logs.get(authz, actor, params.id);
  }
}
