import { Body, Controller, Get, HttpCode, Inject, Post } from "@nestjs/common";
import { ApiBody, ApiTags } from "@nestjs/swagger";
import { ReconciliationPageSchema, ReconciliationRecordSchema, ReconciliationRequestSchema } from "@vexenhanh/types";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { AdminReconciliationService } from "./admin-reconciliation.service";

/** Lý do và mã chống gửi lặp khi yêu cầu chạy đối soát. */
export class ReconciliationRequestDto extends createZodDto(ReconciliationRequestSchema) {}
/** Một lần đối soát và các sai lệch cần vận hành kiểm tra. */
export class ReconciliationRecordDto extends createZodDto(ReconciliationRecordSchema) {}
/** Lịch sử đối soát gần đây. */
export class ReconciliationPageDto extends createZodDto(ReconciliationPageSchema) {}

/** Xem lịch sử và chủ động chạy đối soát thanh toán, sổ giữ hộ, kỳ chi trả (UC-32). */
@ApiTags("admin-system")
@Controller("admin/system/reconciliation")
export class AdminReconciliationController {
  constructor(@Inject(AdminReconciliationService) private readonly reconciliation: AdminReconciliationService) {}

  /** Xem các mốc và sai lệch của 20 lần đối soát gần nhất. */
  @Get() @Authorize("system:read")
  @ZodResponse({ status: 200, type: ReconciliationPageDto })
  list(@Authz() authz: Authorization) { return this.reconciliation.list(authz); }

  /** Chạy lại toàn bộ đối soát theo quyền Admin và xác nhận lại danh tính. */
  @Post() @HttpCode(202) @Authorize("system:run", { requireReauth: true })
  @ApiBody({ type: ReconciliationRequestDto })
  @ZodResponse({ status: 202, type: ReconciliationRecordDto })
  run(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: ReconciliationRequestDto) { return this.reconciliation.run(authz, actor, input); }
}
