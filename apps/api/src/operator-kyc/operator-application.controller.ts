import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Req } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { OperatorApplicationDocumentType } from "../database/prisma.types";
import {
  type Applicant,
  ApplicantAccess,
  ApplicationPublicAccess,
  CurrentApplicant,
} from "../iam/role/application-access";
import type { Authorization } from "../iam/role/authorization";
import { Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  ApplicationAccessLinkInputDto,
  ApplicationCreateInputDto,
  ApplicationResponseDto,
  type ApplicationResponse,
  ApplicationUpdateInputDto,
  DocumentDownloadResponseDto,
  type DocumentDownloadResponse,
  DocumentTypeParamDto,
  DocumentUploadInputDto,
  DocumentUploadResponseDto,
  type DocumentUploadResponse,
} from "./dto/operator-application.dto";
import { OperatorApplicationService } from "./operator-application.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const RATE_LIMITED = { status: 429, description: "`OPERATOR_APPLICATION_RATE_LIMITED`.", content: problemContent };
const UNAVAILABLE = { status: 503, description: "Bộ đếm / kho giấy tờ / audit không phản hồi.", content: problemContent };
const NOT_EDITABLE = {
  status: 409,
  description: "`OPERATOR_APPLICATION_INVALID_STATE` — hồ sơ không ở `DRAFT` / `NEEDS_INFO`.",
  content: problemContent,
};

// API §7.3 — đăng ký nhà xe công khai, trước khi có tài khoản (BR-75, TASK-OPR-001).
@ApiTags("operator-applications")
@Controller("operator-applications")
/** Hồ sơ đăng ký nhà xe phía người nộp: tạo hồ sơ, link bảo mật, lưu nháp, giấy tờ KYC, gửi duyệt. */
export class OperatorApplicationController {
  constructor(
    @Inject(OperatorApplicationService) private readonly applications: OperatorApplicationService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /** Tạo hồ sơ nháp và gửi link bảo mật tới email liên hệ. Luôn `202` — không lộ email đã có hồ sơ hay chưa. */
  @Post()
  @HttpCode(202)
  @ApplicationPublicAccess()
  @ApiBody({ type: ApplicationCreateInputDto })
  @ApiResponse({ status: 202, description: "Đã nhận; link (nếu hợp lệ) được gửi tới email liên hệ." })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  create(@Authz() authz: Authorization, @Body() input: ApplicationCreateInputDto, @Req() request: Request): Promise<void> {
    return this.applications.create(authz, input, resolveTrustedClientIp(request, this.config.NODE_ENV));
  }

  /** Gửi lại link cho email liên hệ + mã hồ sơ; link cũ hết hiệu lực. Luôn `202`. */
  @Post("access-link")
  @HttpCode(202)
  @ApplicationPublicAccess()
  @ApiBody({ type: ApplicationAccessLinkInputDto })
  @ApiResponse({ status: 202, description: "Đã nhận; khớp hồ sơ chưa có kết quả thì link mới được gửi." })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  requestAccessLink(
    @Authz() authz: Authorization,
    @Body() input: ApplicationAccessLinkInputDto,
    @Req() request: Request,
  ): Promise<void> {
    return this.applications.requestAccessLink(authz, input, resolveTrustedClientIp(request, this.config.NODE_ENV));
  }

  /** Hồ sơ của link đang mở. Lần mở đầu xác minh email liên hệ. */
  @Get("current")
  @ApplicantAccess()
  @ZodResponse({ status: 200, description: "Hồ sơ và trạng thái.", type: ApplicationResponseDto })
  get(@Authz() authz: Authorization, @CurrentApplicant() applicant: Applicant): Promise<ApplicationResponse> {
    return this.applications.get(authz, applicant);
  }

  /** Lưu nháp: thông tin doanh nghiệp, thông tin công khai, tài khoản nhận tiền, bộ giấy tờ. */
  @Put("current")
  @ApplicantAccess()
  @ApiBody({ type: ApplicationUpdateInputDto })
  @ZodResponse({ status: 200, description: "Hồ sơ sau khi lưu.", type: ApplicationResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse(NOT_EDITABLE)
  @ApiResponse({ status: 422, description: "`OPERATOR_APPLICATION_DOCUMENT_INVALID`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  update(
    @Authz() authz: Authorization,
    @CurrentApplicant() applicant: Applicant,
    @Body() input: ApplicationUpdateInputDto,
  ): Promise<ApplicationResponse> {
    return this.applications.update(authz, applicant, input);
  }

  /** Cấp URL để trình duyệt tải thẳng một giấy tờ KYC lên kho riêng tư (hạn 5 phút). */
  @Post("current/documents")
  @HttpCode(200)
  @ApplicantAccess()
  @ApiBody({ type: DocumentUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải lên và khóa object.", type: DocumentUploadResponseDto })
  @ApiResponse({ status: 400, description: "Loại file / dung lượng không hợp lệ.", content: problemContent })
  @ApiResponse(NOT_EDITABLE)
  @ApiResponse(RATE_LIMITED)
  @ApiResponse(UNAVAILABLE)
  createDocumentUpload(
    @Authz() authz: Authorization,
    @CurrentApplicant() applicant: Applicant,
    @Body() input: DocumentUploadInputDto,
  ): Promise<DocumentUploadResponse> {
    return this.applications.createDocumentUpload(authz, applicant, input);
  }

  /** URL xem một giấy tờ đã gắn vào hồ sơ (hạn 5 phút, mỗi lần cấp ghi audit). */
  @Post("current/documents/:type/download-url")
  @HttpCode(200)
  @ApplicantAccess()
  @ApiParam({ name: "type", enum: Object.values(OperatorApplicationDocumentType) })
  @ZodResponse({ status: 200, description: "URL xem giấy tờ.", type: DocumentDownloadResponseDto })
  @ApiResponse({
    status: 404,
    description: "`OPERATOR_APPLICATION_DOCUMENT_NOT_FOUND`.",
    content: problemContent,
  })
  @ApiResponse(UNAVAILABLE)
  createDocumentDownload(
    @Authz() authz: Authorization,
    @CurrentApplicant() applicant: Applicant,
    @Param() params: DocumentTypeParamDto,
  ): Promise<DocumentDownloadResponse> {
    return this.applications.createDocumentDownload(authz, applicant, params.type);
  }

  /** Gửi duyệt → `SUBMITTED`. Còn thiếu → 422 kèm mọi mục còn thiếu trong `reasons`. */
  @Post("current/submit")
  @HttpCode(200)
  @ApplicantAccess()
  @ZodResponse({ status: 200, description: "Hồ sơ đã gửi duyệt.", type: ApplicationResponseDto })
  @ApiResponse(NOT_EDITABLE)
  @ApiResponse({ status: 422, description: "`OPERATOR_APPLICATION_INCOMPLETE` (+ `reasons`).", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  submit(@Authz() authz: Authorization, @CurrentApplicant() applicant: Applicant): Promise<ApplicationResponse> {
    return this.applications.submit(authz, applicant);
  }
}
