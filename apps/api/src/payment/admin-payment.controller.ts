import { Controller, Get, Inject, Param, ParseUUIDPipe, Query } from "@nestjs/common";
import { ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { PaymentProvider, PaymentStatus } from "../database/prisma.types";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminPaymentService } from "./admin-payment.service";
import { AdminPaymentDetailDto, AdminPaymentListQueryDto, AdminPaymentPageDto, type AdminPaymentDetail, type AdminPaymentPage } from "./dto/admin-payment.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// API §7.5 — giám sát thanh toán toàn hệ thống (FR-ADM-10, FR-BTP-17). `payment:monitor` (Admin + hỗ trợ nền tảng; chủ nhà xe
// không có). Hoàn toàn bộ thanh toán cần đối soát: `POST /admin/payments/{id}/refunds` ở `refund/admin-refund.controller.ts`.
@ApiTags("admin-payments")
@Controller("admin/payments")
/** Giao dịch thanh toán qua cổng — danh sách + chi tiết (TASK-ADM-002, Figma ADM-07a–b). */
export class AdminPaymentController {
  constructor(@Inject(AdminPaymentService) private readonly payments: AdminPaymentService) {}

  @Get()
  @Authorize("payment:monitor")
  @ApiQuery({ name: "from", required: false, type: String, format: "date" })
  @ApiQuery({ name: "to", required: false, type: String, format: "date" })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "provider", required: false, enum: PaymentProvider })
  @ApiQuery({ name: "status", required: false, enum: PaymentStatus })
  @ApiQuery({ name: "reconcile", required: false, enum: ["open"] })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang giao dịch, mới trước + tổng + số cần đối soát.", type: AdminPaymentPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminPaymentListQueryDto): Promise<AdminPaymentPage> {
    return this.payments.list(authz, query);
  }

  @Get(":paymentId")
  @Authorize("payment:monitor")
  @ApiParam({ name: "paymentId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Chi tiết giao dịch: dòng thời gian, phân bổ số tiền, vé, sổ giữ hộ, hoàn tiền.", type: AdminPaymentDetailDto })
  @ApiResponse({ status: 404, description: "`PAYMENT_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("paymentId", new ParseUUIDPipe()) paymentId: string): Promise<AdminPaymentDetail> {
    return this.payments.get(authz, paymentId);
  }
}
