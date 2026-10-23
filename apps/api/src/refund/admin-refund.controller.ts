import { applyDecorators, Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { RefundStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminRefundService } from "./admin-refund.service";
import {
  AdminRefundDetailDto,
  AdminRefundListQueryDto,
  AdminRefundPageDto,
  REFUND_SOURCES,
  RefundReasonInputDto,
  RefundResolveInputDto,
  type AdminRefundDetail,
  type AdminRefundPage,
} from "./dto/admin-refund.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const REFUND_PARAM = { name: "refundId", type: String, format: "uuid" } as const;
/** Lỗi chung của các route ghi. */
const WriteErrors = () =>
  applyDecorators(
    ApiResponse({ status: 404, description: "`REFUND_NOT_FOUND` / `PAYMENT_NOT_FOUND`.", content: problemContent }),
    ApiResponse({ status: 409, description: "`REFUND_STATUS_INVALID`.", content: problemContent }),
    ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent }),
  );

// API §7.5 — hoàn tiền phía Admin (FR-ADM-10, UC-27 A4, UC-32 bước 8). Xem: `payment:monitor`. Thao tác: `refund:manage` (TASK-IAM-007, tách từ `finance:configure`)
// (PLATFORM_ADMIN) + xác nhận lại danh tính + lý do (Security §8 "Refund thủ công"). `refund:request` không dùng ở đây vì chủ
// nhà xe có quyền đó theo tenant.
@ApiTags("admin-refunds")
@Controller("admin")
/** Yêu cầu hoàn tiền — danh sách, chi tiết, xử lý hoàn tiền thất bại, hoàn thanh toán cần đối soát (TASK-ADM-002, Figma ADM-07c–d). */
export class AdminRefundController {
  constructor(@Inject(AdminRefundService) private readonly refunds: AdminRefundService) {}

  @Get("refunds")
  @Authorize("payment:monitor")
  @ApiQuery({ name: "from", required: false, type: String, format: "date" })
  @ApiQuery({ name: "to", required: false, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "source", required: false, enum: REFUND_SOURCES })
  @ApiQuery({ name: "status", required: false, enum: RefundStatus })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang yêu cầu hoàn tiền, mới trước + tổng.", type: AdminRefundPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminRefundListQueryDto): Promise<AdminRefundPage> {
    return this.refunds.list(authz, query);
  }

  @Get("refunds/:refundId")
  @Authorize("payment:monitor")
  @ApiParam(REFUND_PARAM)
  @ZodResponse({ status: 200, description: "Chi tiết yêu cầu hoàn tiền.", type: AdminRefundDetailDto })
  @ApiResponse({ status: 404, description: "`REFUND_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("refundId", new ParseUUIDPipe()) refundId: string): Promise<AdminRefundDetail> {
    return this.refunds.get(authz, refundId);
  }

  /** Gửi lại cổng một yêu cầu hoàn tiền thất bại (lần gửi mới). */
  @Post("refunds/:refundId/retry")
  @HttpCode(200)
  @Authorize("refund:manage", { requireReauth: true })
  @WriteErrors()
  @ApiParam(REFUND_PARAM)
  @ApiBody({ type: RefundReasonInputDto })
  @ZodResponse({ status: 200, description: "Yêu cầu đã chuyển về chờ hoàn qua cổng.", type: AdminRefundDetailDto })
  retry(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("refundId", new ParseUUIDPipe()) refundId: string,
    @Body() input: RefundReasonInputDto,
  ): Promise<AdminRefundDetail> {
    return this.refunds.retry(authz, actor, refundId, input.reason);
  }

  /** Ghi nhận đã hoàn ngoài luồng tự động (chuyển khoản tay / đã hoàn trên trang quản trị cổng) kèm mã tham chiếu. */
  @Post("refunds/:refundId/resolve")
  @HttpCode(200)
  @Authorize("refund:manage", { requireReauth: true })
  @WriteErrors()
  @ApiParam(REFUND_PARAM)
  @ApiBody({ type: RefundResolveInputDto })
  @ZodResponse({ status: 200, description: "Yêu cầu đã hoàn.", type: AdminRefundDetailDto })
  resolve(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("refundId", new ParseUUIDPipe()) refundId: string,
    @Body() input: RefundResolveInputDto,
  ): Promise<AdminRefundDetail> {
    return this.refunds.resolve(authz, actor, refundId, input);
  }

  /** Hoàn toàn bộ cho thanh toán cần đối soát (khách trả muộn / trùng). */
  @Post("payments/:paymentId/refunds")
  @HttpCode(201)
  @Authorize("refund:manage", { requireReauth: true })
  @WriteErrors()
  @ApiParam({ name: "paymentId", type: String, format: "uuid" })
  @ApiBody({ type: RefundReasonInputDto })
  @ZodResponse({ status: 201, description: "Yêu cầu hoàn tiền vừa tạo (chờ hoàn qua cổng).", type: AdminRefundDetailDto })
  refundPayment(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param("paymentId", new ParseUUIDPipe()) paymentId: string,
    @Body() input: RefundReasonInputDto,
  ): Promise<AdminRefundDetail> {
    return this.refunds.refundPayment(authz, actor, paymentId, input.reason);
  }
}
