import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { SupportStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AttachmentUploadInputDto,
  AttachmentUploadResponseDto,
  DownloadUrlResponseDto,
  MessageInputDto,
  OperatorTicketListQueryDto,
  TicketDetailDto,
  TicketPageDto,
  type AttachmentUploadResponse,
  type DownloadUrlResponse,
  type TicketDetail,
  type TicketPage,
} from "./dto/support.dto";
import { SupportService } from "./support.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};

// FR-NSR-07 — chủ nhà xe (`support:respond`, tenant từ JWT) phản hồi khiếu nại Vé Xe Nhanh đã chuyển cho nhà xe.
@ApiTags("operator-support")
@Controller("operator")
/** Khiếu nại liên quan tới chuyến của nhà xe (Figma "Nhà xe · Hỗ trợ / Khiếu nại"; TASK-TRUST-001). */
export class OperatorSupportController {
  constructor(@Inject(SupportService) private readonly support: SupportService) {}

  @Get("support-tickets")
  @Authorize("support:respond")
  @ApiQuery({ name: "status", required: false, enum: SupportStatus })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Khiếu nại đã chuyển cho nhà xe, cập nhật mới trước.", type: TicketPageDto })
  list(@Authz() authz: Authorization, @Query() query: OperatorTicketListQueryDto): Promise<TicketPage> {
    return this.support.operatorList(authz, query);
  }

  @Get("support-tickets/:ticketId")
  @Authorize("support:respond")
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Khiếu nại + trao đổi (liên hệ khách đã che).", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND` (kể cả chưa chuyển cho nhà xe / của nhà xe khác).", content: problemContent })
  get(@Authz() authz: Authorization, @Param("ticketId", new ParseUUIDPipe()) ticketId: string): Promise<TicketDetail> {
    return this.support.operatorGet(authz, ticketId);
  }

  @Post("support-tickets/:ticketId/messages")
  @HttpCode(201)
  @Authorize("support:respond")
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ApiBody({ type: MessageInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi phản hồi cho khách.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID` — khiếu nại đã đóng.", content: problemContent })
  reply(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Body() input: MessageInputDto,
  ): Promise<TicketDetail> {
    return this.support.operatorReply(authz, actor, ticketId, input);
  }

  @Post("support-attachments/upload-url")
  @HttpCode(200)
  @Authorize("support:respond")
  @ApiBody({ type: AttachmentUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải tệp minh chứng lên kho riêng tư (5 phút).", type: AttachmentUploadResponseDto })
  @ApiResponse({ status: 503, description: "Kho tệp riêng tư chưa sẵn sàng.", content: problemContent })
  upload(@Authz() authz: Authorization, @Body() input: AttachmentUploadInputDto): Promise<AttachmentUploadResponse> {
    return this.support.operatorUpload(authz, input);
  }

  @Post("support-attachments/:attachmentId/download-url")
  @HttpCode(200)
  @Authorize("support:respond")
  @ApiParam({ name: "attachmentId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "URL xem tệp (5 phút, có audit).", type: DownloadUrlResponseDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_ATTACHMENT_NOT_FOUND`.", content: problemContent })
  download(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("attachmentId", new ParseUUIDPipe()) attachmentId: string): Promise<DownloadUrlResponse> {
    return this.support.operatorDownload(authz, actor, attachmentId);
  }
}
