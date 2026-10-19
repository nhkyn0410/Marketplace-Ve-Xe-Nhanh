import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Patch, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { SupportCategory, SupportStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AdminMessageInputDto,
  AdminTicketListQueryDto,
  AssigneeListDto,
  AttachmentUploadInputDto,
  AttachmentUploadResponseDto,
  ClassifyInputDto,
  DownloadUrlResponseDto,
  TicketDetailDto,
  TicketPageDto,
  TicketStatusInputDto,
  type AssigneeList,
  type AttachmentUploadResponse,
  type DownloadUrlResponse,
  type TicketDetail,
  type TicketPage,
} from "./dto/support.dto";
import { SupportService } from "./support.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TICKET_PARAM = { name: "ticketId", type: String, format: "uuid" } as const;

// FR-NSR-08 — PlatformAdmin + PlatformSupport (`support:manage`): phân loại, phân công, trả lời, yêu cầu bổ sung, đóng.
@ApiTags("admin-support")
@Controller("admin")
/** Hàng đợi khiếu nại (Figma ADM-09a/b; TASK-TRUST-001). */
export class AdminSupportController {
  constructor(@Inject(SupportService) private readonly support: SupportService) {}

  @Get("support-tickets")
  @Authorize("support:manage")
  @ApiQuery({ name: "status", required: false, enum: SupportStatus })
  @ApiQuery({ name: "category", required: false, enum: SupportCategory })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "assigneeId", required: false, type: String, description: "UUID tài khoản nền tảng hoặc `none`." })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Khiếu nại, cập nhật mới trước.", type: TicketPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminTicketListQueryDto): Promise<TicketPage> {
    return this.support.adminList(authz, query);
  }

  @Get("support-assignees")
  @Authorize("support:manage")
  @ZodResponse({ status: 200, description: "Tài khoản nền tảng đang hoạt động.", type: AssigneeListDto })
  assignees(@Authz() authz: Authorization): Promise<AssigneeList> {
    return this.support.assignees(authz);
  }

  @Get("support-tickets/:ticketId")
  @Authorize("support:manage")
  @ApiParam(TICKET_PARAM)
  @ZodResponse({ status: 200, description: "Khiếu nại, trao đổi, dữ liệu liên quan.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("ticketId", new ParseUUIDPipe()) ticketId: string): Promise<TicketDetail> {
    return this.support.adminGet(authz, ticketId);
  }

  @Patch("support-tickets/:ticketId")
  @Authorize("support:manage")
  @ApiParam(TICKET_PARAM)
  @ApiBody({ type: ClassifyInputDto })
  @ZodResponse({ status: 200, description: "Đã lưu phân loại.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID` — đã đóng / đã chuyển tranh chấp.", content: problemContent })
  @ApiResponse({ status: 422, description: "`SUPPORT_ASSIGNEE_INVALID`.", content: problemContent })
  classify(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Body() input: ClassifyInputDto,
  ): Promise<TicketDetail> {
    return this.support.classify(authz, actor, ticketId, input);
  }

  @Post("support-tickets/:ticketId/messages")
  @HttpCode(201)
  @Authorize("support:manage")
  @ApiParam(TICKET_PARAM)
  @ApiBody({ type: AdminMessageInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi phản hồi cho khách.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID` — khiếu nại đã đóng.", content: problemContent })
  reply(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Body() input: AdminMessageInputDto,
  ): Promise<TicketDetail> {
    return this.support.adminReply(authz, actor, ticketId, input);
  }

  @Post("support-tickets/:ticketId/status")
  @HttpCode(200)
  @Authorize("support:manage")
  @ApiParam(TICKET_PARAM)
  @ApiBody({ type: TicketStatusInputDto })
  @ZodResponse({ status: 200, description: "Đã giải quyết / đã đóng.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID`.", content: problemContent })
  setStatus(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Body() input: TicketStatusInputDto,
  ): Promise<TicketDetail> {
    return this.support.setStatus(authz, actor, ticketId, input);
  }

  @Post("support-tickets/:ticketId/attachments/upload-url")
  @HttpCode(200)
  @Authorize("support:manage")
  @ApiParam(TICKET_PARAM)
  @ApiBody({ type: AttachmentUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải tệp lên kho riêng tư (5 phút).", type: AttachmentUploadResponseDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  upload(@Authz() authz: Authorization, @Param("ticketId", new ParseUUIDPipe()) ticketId: string, @Body() input: AttachmentUploadInputDto): Promise<AttachmentUploadResponse> {
    return this.support.adminUploadFor(authz, { ticketId }, input);
  }

  @Post("support-attachments/:attachmentId/download-url")
  @HttpCode(200)
  @Authorize("support:manage")
  @ApiParam({ name: "attachmentId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "URL xem tệp (5 phút, có audit).", type: DownloadUrlResponseDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_ATTACHMENT_NOT_FOUND`.", content: problemContent })
  download(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("attachmentId", new ParseUUIDPipe()) attachmentId: string): Promise<DownloadUrlResponse> {
    return this.support.adminDownload(authz, actor, attachmentId);
  }
}
