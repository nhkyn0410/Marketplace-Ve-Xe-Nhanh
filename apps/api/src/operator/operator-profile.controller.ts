import { Body, Controller, Delete, Get, HttpCode, Inject, Param, Post, Put } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { OperatorApplicationDocumentType } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  BankChangeInputDto,
  KycDocumentTypeParamDto,
  KycDownloadResponseDto,
  type KycDownloadResponse,
  KycReplaceInputDto,
  KycUploadInputDto,
  KycUploadResponseDto,
  type KycUploadResponse,
  LogoAttachInputDto,
  LogoUploadInputDto,
  LogoUploadResponseDto,
  type LogoUploadResponse,
  OperatorProfileResponseDto,
  type OperatorProfileResponse,
  OperatorProfileUpdateDto,
} from "./dto/operator-profile.dto";
import { OperatorProfileService } from "./operator-profile.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const TYPE_PARAM = { name: "type", enum: Object.values(OperatorApplicationDocumentType) } as const;

// API §7.3 `/operator/profile` (TASK-OPR-001b, UC-11, FR-OPR-02..05). Quyền `kyc:submit` — chỉ chủ nhà xe (tenant).
@ApiTags("operator-profile")
@Controller("operator/profile")
/** Hồ sơ, giấy tờ KYC và tài khoản nhận tiền của nhà xe đang đăng nhập. */
export class OperatorProfileController {
  constructor(@Inject(OperatorProfileService) private readonly profiles: OperatorProfileService) {}

  @Get()
  @Authorize("kyc:submit")
  @ZodResponse({ status: 200, description: "Hồ sơ nhà xe.", type: OperatorProfileResponseDto })
  get(@Authz() authz: Authorization): Promise<OperatorProfileResponse> {
    return this.profiles.get(authz);
  }

  /** Sửa thông tin công khai (tên hiển thị, hotline, email, địa chỉ, mô tả) — audited. */
  @Put()
  @Authorize("kyc:submit")
  @ApiBody({ type: OperatorProfileUpdateDto })
  @ZodResponse({ status: 200, description: "Hồ sơ sau khi sửa.", type: OperatorProfileResponseDto })
  @ApiResponse({ status: 400, description: "Dữ liệu không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  update(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: OperatorProfileUpdateDto,
  ): Promise<OperatorProfileResponse> {
    return this.profiles.update(authz, actor, input);
  }

  /** Cấp URL để trình duyệt tải thẳng logo lên kho công khai (hiệu lực 5 phút). */
  @Post("logo/upload-url")
  @HttpCode(200)
  @Authorize("kyc:submit")
  @ApiBody({ type: LogoUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải lên và khóa object.", type: LogoUploadResponseDto })
  @ApiResponse({ status: 400, description: "Loại file hoặc dung lượng không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho công khai không phản hồi.", content: problemContent })
  createLogoUploadUrl(@Authz() authz: Authorization, @Body() input: LogoUploadInputDto): Promise<LogoUploadResponse> {
    return this.profiles.createLogoUpload(authz, input);
  }

  /** Đặt logo vừa tải lên làm logo nhà xe (audited); logo cũ bị xóa khỏi kho. */
  @Put("logo")
  @Authorize("kyc:submit")
  @ApiBody({ type: LogoAttachInputDto })
  @ZodResponse({ status: 200, description: "Hồ sơ sau khi đổi logo.", type: OperatorProfileResponseDto })
  @ApiResponse({ status: 422, description: "`OPERATOR_LOGO_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho công khai / audit không phản hồi.", content: problemContent })
  setLogo(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: LogoAttachInputDto,
  ): Promise<OperatorProfileResponse> {
    return this.profiles.setLogo(authz, actor, input);
  }

  /** Gỡ logo (audited) — trang nhà xe quay về chữ viết tắt. */
  @Delete("logo")
  @Authorize("kyc:submit")
  @ZodResponse({ status: 200, description: "Hồ sơ sau khi gỡ logo.", type: OperatorProfileResponseDto })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  removeLogo(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken): Promise<OperatorProfileResponse> {
    return this.profiles.removeLogo(authz, actor);
  }

  /** Cấp URL để trình duyệt tải thẳng một giấy tờ lên kho riêng tư (hiệu lực 5 phút). */
  @Post("documents/upload-url")
  @HttpCode(200)
  @Authorize("kyc:submit")
  @ApiBody({ type: KycUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải lên và khóa object.", type: KycUploadResponseDto })
  @ApiResponse({ status: 400, description: "Loại file hoặc dung lượng không hợp lệ.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho riêng tư chưa cấu hình / không phản hồi.", content: problemContent })
  createUploadUrl(@Authz() authz: Authorization, @Body() input: KycUploadInputDto): Promise<KycUploadResponse> {
    return this.profiles.createDocumentUpload(authz, input);
  }

  /** Thay giấy tờ loại `type` bằng bản vừa tải lên (audited). */
  @Put("documents/:type")
  @Authorize("kyc:submit")
  @ApiParam(TYPE_PARAM)
  @ApiBody({ type: KycReplaceInputDto })
  @ZodResponse({ status: 200, description: "Hồ sơ sau khi thay giấy tờ.", type: OperatorProfileResponseDto })
  @ApiResponse({ status: 422, description: "`KYC_DOCUMENT_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho riêng tư / audit không phản hồi.", content: problemContent })
  replaceDocument(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: KycDocumentTypeParamDto,
    @Body() input: KycReplaceInputDto,
  ): Promise<OperatorProfileResponse> {
    return this.profiles.replaceDocument(authz, actor, params.type, input);
  }

  /** URL xem giấy tờ, hạn 5 phút; mỗi lần cấp ghi audit. */
  @Post("documents/:type/download-url")
  @HttpCode(200)
  @Authorize("kyc:submit")
  @ApiParam(TYPE_PARAM)
  @ZodResponse({ status: 200, description: "URL xem giấy tờ.", type: KycDownloadResponseDto })
  @ApiResponse({ status: 404, description: "`KYC_DOCUMENT_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Kho riêng tư / audit không phản hồi.", content: problemContent })
  createDownloadUrl(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: KycDocumentTypeParamDto,
  ): Promise<KycDownloadResponse> {
    return this.profiles.createDocumentDownload(authz, actor, params.type);
  }

  /** Gửi yêu cầu đổi tài khoản nhận tiền — cần xác nhận lại danh tính, chờ Admin xác minh (BR-37). */
  @Post("bank-account-change")
  @HttpCode(201)
  @Authorize("kyc:submit", { requireReauth: true })
  @ApiBody({ type: BankChangeInputDto })
  @ZodResponse({ status: 201, description: "Hồ sơ kèm yêu cầu đang chờ.", type: OperatorProfileResponseDto })
  @ApiResponse({ status: 401, description: "`AUTH_REAUTH_REQUIRED`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`BANK_ACCOUNT_CHANGE_PENDING`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`BANK_ACCOUNT_UNCHANGED`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit — không đổi gì.", content: problemContent })
  requestBankChange(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: BankChangeInputDto,
  ): Promise<OperatorProfileResponse> {
    return this.profiles.requestBankChange(authz, actor, input);
  }
}
