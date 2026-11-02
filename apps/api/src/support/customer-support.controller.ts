import { Body, Controller, Get, Headers, HttpCode, Inject, Param, ParseUUIDPipe, Post } from "@nestjs/common";
import { ApiBody, ApiHeader, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { BOOKING_TOKEN_HEADER } from "../booking/booking-access";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { GuestOrPassenger, OptionalPassenger } from "../iam/role/guest-or-passenger";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AttachmentUploadInputDto,
  AttachmentUploadResponseDto,
  CustomerTicketInputDto,
  CustomerTicketListDto,
  DownloadUrlResponseDto,
  MessageInputDto,
  TicketDetailDto,
  type AttachmentUploadResponse,
  type CustomerTicketList,
  type DownloadUrlResponse,
  type TicketDetail,
} from "./dto/support.dto";
import { SupportService } from "./support.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TOKEN_HEADER = { name: "X-Booking-Token", required: false, description: "Mã truy cập booking (khách vãng lai)." } as const;
const BOOKING_PARAM = { name: "bookingId", type: String, format: "uuid" } as const;

// UC-09 — khiếu nại của khách (hành khách sở hữu đơn hoặc khách vãng lai có mã truy cập — `support:create`, phạm vi `own`).
@ApiTags("support")
@Controller("bookings/:bookingId")
/** Khiếu nại / hỗ trợ gắn với một đơn (TASK-TRUST-001, FR-NSR-06, FR-NSR-09). */
export class CustomerSupportController {
  constructor(@Inject(SupportService) private readonly support: SupportService) {}

  @Get("support-tickets")
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiHeader(TOKEN_HEADER)
  @ZodResponse({ status: 200, description: "Khiếu nại của đơn, mới trước.", type: CustomerTicketListDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND` — đơn không có / không thuộc người gọi.", content: problemContent })
  list(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
  ): Promise<CustomerTicketList> {
    return this.support.customerList(user, bookingId, token);
  }

  @Post("support-tickets")
  @HttpCode(201)
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiHeader(TOKEN_HEADER)
  @ApiBody({ type: CustomerTicketInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi khiếu nại (`NEW`).", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`SUPPORT_ATTACHMENT_INVALID`.", content: problemContent })
  create(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
    @Body() input: CustomerTicketInputDto,
  ): Promise<TicketDetail> {
    return this.support.customerCreate(user, bookingId, token, input);
  }

  @Get("support-tickets/:ticketId")
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ApiHeader(TOKEN_HEADER)
  @ZodResponse({ status: 200, description: "Khiếu nại + trao đổi.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  get(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
  ): Promise<TicketDetail> {
    return this.support.customerGet(user, bookingId, token, ticketId);
  }

  @Post("support-tickets/:ticketId/messages")
  @HttpCode(201)
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiParam({ name: "ticketId", type: String, format: "uuid" })
  @ApiHeader(TOKEN_HEADER)
  @ApiBody({ type: MessageInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi; chờ khách / đã giải quyết → Vé Xe Nhanh xử lý tiếp.", type: TicketDetailDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_TICKET_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`SUPPORT_STATE_INVALID` — khiếu nại đã đóng.", content: problemContent })
  reply(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Param("ticketId", new ParseUUIDPipe()) ticketId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
    @Body() input: MessageInputDto,
  ): Promise<TicketDetail> {
    return this.support.customerReply(user, bookingId, token, ticketId, input);
  }

  @Post("support-attachments/upload-url")
  @HttpCode(200)
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiHeader(TOKEN_HEADER)
  @ApiBody({ type: AttachmentUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải tệp lên kho riêng tư (5 phút).", type: AttachmentUploadResponseDto })
  @ApiResponse({ status: 503, description: "Kho tệp riêng tư chưa sẵn sàng.", content: problemContent })
  upload(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
    @Body() input: AttachmentUploadInputDto,
  ): Promise<AttachmentUploadResponse> {
    return this.support.customerUpload(user, bookingId, token, input);
  }

  @Post("support-attachments/:attachmentId/download-url")
  @HttpCode(200)
  @GuestOrPassenger("support:create")
  @ApiParam(BOOKING_PARAM)
  @ApiParam({ name: "attachmentId", type: String, format: "uuid" })
  @ApiHeader(TOKEN_HEADER)
  @ZodResponse({ status: 200, description: "URL xem tệp (5 phút, có audit).", type: DownloadUrlResponseDto })
  @ApiResponse({ status: 404, description: "`SUPPORT_ATTACHMENT_NOT_FOUND`.", content: problemContent })
  download(
    @OptionalPassenger() user: VerifiedAccessToken | null,
    @Param("bookingId", new ParseUUIDPipe()) bookingId: string,
    @Param("attachmentId", new ParseUUIDPipe()) attachmentId: string,
    @Headers(BOOKING_TOKEN_HEADER) token: string | undefined,
  ): Promise<DownloadUrlResponse> {
    return this.support.customerDownload(user, bookingId, token, attachmentId);
  }
}
