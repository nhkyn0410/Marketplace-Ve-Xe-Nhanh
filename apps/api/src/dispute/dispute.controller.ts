import { Body, Controller, Get, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { BOOKING_TOKEN_HEADER } from "../booking/booking-access";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AttachmentUploadInputDto, AttachmentUploadResponseDto, EscalateInputDto, type AttachmentUploadResponse } from "../support/dto/support.dto";
import { SupportService } from "../support/support.service";
import { DisputeService } from "./dispute.service";
import {
  AdminDisputeListQueryDto,
  CustomerDisputeListDto,
  DisputeDecisionInputDto,
  DisputeDetailDto,
  DisputePageDto,
  DisputeStatusInputDto,
  EvidenceInputDto,
  OperatorDisputeListQueryDto,
  RequestEvidenceInputDto,
  type DisputeDetail,
  type DisputePage,
  type DisputeSummary,
} from "./dto/dispute.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const DISPUTE_PARAM = { name: "disputeId", type: String, format: "uuid" } as const;

// FR-DSP-* — PlatformAdmin + PlatformSupport (`support:manage`) mở / yêu cầu minh chứng / đổi trạng thái; quyết định chỉ PlatformAdmin
// (`dispute:decide` + xác nhận lại danh tính).
@ApiTags("admin-disputes")
@Controller("admin")
/** Tranh chấp — Vé Xe Nhanh là bên phân xử cuối (Figma ADM-09c/d/e; TASK-TRUST-001). */
export class AdminDisputeController {
  constructor(
    @Inject(DisputeService) private readonly disputes: DisputeService,
    @Inject(SupportService) private readonly support: SupportService,
  ) {}

  @Post("support-tickets/:ticketId/escalate")
  @HttpCode(201)
  @Authorize("support:manage")
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ApiBody({ type: EscalateInputDto })
  @ZodResponse({ status: 201, description: "Đã mở tranh chấp từ khiếu nại.", type: DisputeDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID` — đã chuyển tranh chấp / đã đóng.", content: problemContent })
  escalate(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Body() input: EscalateInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.escalate(authz, actor, ticketId, input);
  }

  @Get("disputes")
  @Authorize("support:manage")
  @ApiQuery({ name: "status", required: false, type: String, description: "Trạng thái hoặc `open`." })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "due", required: false, enum: ["overdue", "upcoming"] })
  @ApiQuery({ name: "assigneeId", required: false, type: String, description: "UUID tài khoản nền tảng hoặc `none`." })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Tranh chấp, cập nhật mới trước.", type: DisputePageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminDisputeListQueryDto): Promise<DisputePage> {
    return this.disputes.adminList(authz, query);
  }

  @Get("disputes/:disputeId")
  @Authorize("support:manage")
  @ApiParam(DISPUTE_PARAM)
  @ZodResponse({ status: 200, description: "Tranh chấp: minh chứng hai bên, dữ liệu hệ thống, lịch sử.", type: DisputeDetailDto })
  @ApiResponse({ status: 404, description: "`DISPUTE_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("disputeId", new ParseUUIDPipe()) disputeId: string): Promise<DisputeDetail> {
    return this.disputes.adminGet(authz, disputeId);
  }

  @Post("disputes/:disputeId/evidence-requests")
  @HttpCode(201)
  @Authorize("support:manage")
  @ApiParam(DISPUTE_PARAM)
  @ApiBody({ type: RequestEvidenceInputDto })
  @ZodResponse({ status: 201, description: "Đã yêu cầu minh chứng (chờ khách / chờ nhà xe).", type: DisputeDetailDto })
  @ApiResponse({ status: 409, description: "`DISPUTE_STATE_INVALID` — đã có quyết định / hạn không hợp lệ.", content: problemContent })
  requestEvidence(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Body() input: RequestEvidenceInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.requestEvidence(authz, actor, disputeId, input);
  }

  @Post("disputes/:disputeId/status")
  @HttpCode(200)
  @Authorize("support:manage")
  @ApiParam(DISPUTE_PARAM)
  @ApiBody({ type: DisputeStatusInputDto })
  @ZodResponse({ status: 200, description: "Đã đổi trạng thái.", type: DisputeDetailDto })
  @ApiResponse({ status: 409, description: "`DISPUTE_STATE_INVALID`.", content: problemContent })
  setStatus(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Body() input: DisputeStatusInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.setStatus(authz, actor, disputeId, input);
  }

  @Post("disputes/:disputeId/decision")
  @HttpCode(200)
  @Authorize("dispute:decide", { requireReauth: true })
  @ApiParam(DISPUTE_PARAM)
  @ApiBody({ type: DisputeDecisionInputDto })
  @ZodResponse({ status: 200, description: "Đã ra quyết định; hoàn tiền → yêu cầu hoàn đã tạo, worker hoàn qua cổng.", type: DisputeDetailDto })
  @ApiResponse({ status: 409, description: "`DISPUTE_STATE_INVALID` — đã có quyết định.", content: problemContent })
  @ApiResponse({ status: 422, description: "`DISPUTE_REFUND_INVALID` — vượt phần khách đã trả còn lại / không có thanh toán qua cổng.", content: problemContent })
  decide(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Body() input: DisputeDecisionInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.decide(authz, actor, disputeId, input);
  }

  @Post("disputes/:disputeId/attachments/upload-url")
  @HttpCode(200)
  @Authorize("support:manage")
  @ApiParam(DISPUTE_PARAM)
  @ApiBody({ type: AttachmentUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải tệp lên kho riêng tư (5 phút).", type: AttachmentUploadResponseDto })
  upload(@Authz() authz: Authorization, @Param("disputeId", new ParseUUIDPipe()) disputeId: string, @Body() input: AttachmentUploadInputDto): Promise<AttachmentUploadResponse> {
    return this.support.adminUploadFor(authz, { disputeId }, input);
  }
}

// FR-DSP-04 — chủ nhà xe (`support:respond`, tenant từ JWT) xem tranh chấp của nhà xe và gửi giải trình + minh chứng.
@ApiTags("operator-disputes")
@Controller("operator")
/** Tranh chấp của nhà xe (Figma "Nhà xe · Hỗ trợ / Tranh chấp"). */
export class OperatorDisputeController {
  constructor(@Inject(DisputeService) private readonly disputes: DisputeService) {}

  @Get("disputes")
  @Authorize("support:respond")
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Tranh chấp của nhà xe.", type: DisputePageDto })
  list(@Authz() authz: Authorization, @Query() query: OperatorDisputeListQueryDto): Promise<DisputePage> {
    return this.disputes.operatorList(authz, query);
  }

  @Get("disputes/:disputeId")
  @Authorize("support:respond")
  @ApiParam(DISPUTE_PARAM)
  @ZodResponse({ status: 200, description: "Tranh chấp (không gồm minh chứng của khách).", type: DisputeDetailDto })
  @ApiResponse({ status: 404, description: "`DISPUTE_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("disputeId", new ParseUUIDPipe()) disputeId: string): Promise<DisputeDetail> {
    return this.disputes.operatorGet(authz, disputeId);
  }

  @Post("disputes/:disputeId/responses")
  @HttpCode(201)
  @Authorize("support:respond")
  @ApiParam(DISPUTE_PARAM)
  @ApiBody({ type: EvidenceInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi giải trình; đang chờ nhà xe → đang xem xét.", type: DisputeDetailDto })
  @ApiResponse({ status: 409, description: "`DISPUTE_STATE_INVALID` — đã có quyết định.", content: problemContent })
  respond(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Body() input: EvidenceInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.operatorRespond(authz, actor, disputeId, input);
  }
}

// FR-DSP-04 — khách của đơn (`support:create`, phạm vi `own`; khách vãng lai dùng mã truy cập đơn).
@ApiTags("disputes")
@Controller("bookings/:bookingId")
/** Tranh chấp của một đơn — khách xem + gửi minh chứng. */
export class CustomerDisputeController {
  constructor(@Inject(DisputeService) private readonly disputes: DisputeService) {}

  @Get("disputes")
  @GuestOrPassenger("support:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." })
  @ZodResponse({ status: 200, description: "Tranh chấp của đơn.", type: CustomerDisputeListDto })
  @ApiResponse({ status: 404, description: "`DISPUTE_NOT_FOUND` — đơn không có / không thuộc người gọi.", content: problemContent })
  async list(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
  ): Promise<{ items: DisputeSummary[] }> {
    return { items: await this.disputes.customerList(user, bookingId, token) };
  }

  @Get("disputes/:disputeId")
  @GuestOrPassenger("support:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiParam(DISPUTE_PARAM)
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." })
  @ZodResponse({ status: 200, description: "Tranh chấp (không gồm minh chứng của nhà xe).", type: DisputeDetailDto })
  @ApiResponse({ status: 404, description: "`DISPUTE_NOT_FOUND`.", content: problemContent })
  get(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
  ): Promise<DisputeDetail> {
    return this.disputes.customerGet(user, bookingId, token, disputeId);
  }

  @Post("disputes/:disputeId/responses")
  @HttpCode(201)
  @GuestOrPassenger("support:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiParam(DISPUTE_PARAM)
  @ApiHeader({ name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." })
  @ApiBody({ type: EvidenceInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi minh chứng; đang chờ khách → đang xem xét.", type: DisputeDetailDto })
  @ApiResponse({ status: 409, description: "`DISPUTE_STATE_INVALID` — đã có quyết định.", content: problemContent })
  respond(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Param("disputeId", new ParseUUIDPipe()) disputeId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
    @Body() input: EvidenceInputDto,
  ): Promise<DisputeDetail> {
    return this.disputes.customerRespond(user, bookingId, token, disputeId, input);
  }
}

