import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Put, Query } from "@nestjs/common";
import { ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import {
  NotificationAudienceEstimateSchema,
  NotificationAudienceInputSchema,
  NotificationCampaignDetailSchema,
  NotificationCampaignInputSchema,
  NotificationCampaignOptionsSchema,
  NotificationCampaignPageSchema,
  NotificationCampaignQuerySchema,
  NotificationCampaignSchema,
  NotificationCampaignSendInputSchema,
  NotificationCampaignTestInputSchema,
  NotificationCampaignTestResultSchema,
} from "@vexenhanh/types";
import { createZodDto, ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../../iam/auth/token.service";
import { Authorize, Authz } from "../../iam/role/authorize.decorator";
import type { Authorization } from "../../iam/role/authorization";
import { ProblemDetailsDto } from "../../openapi/openapi.dto";
import { NotificationCampaignService } from "./notification-campaign.service";

class CampaignDto extends createZodDto(NotificationCampaignSchema) {}
class CampaignDetailDto extends createZodDto(NotificationCampaignDetailSchema) {}
class CampaignPageDto extends createZodDto(NotificationCampaignPageSchema) {}
class CampaignOptionsDto extends createZodDto(NotificationCampaignOptionsSchema) {}
class CampaignQueryDto extends createZodDto(NotificationCampaignQuerySchema) {}
class CampaignInputDto extends createZodDto(NotificationCampaignInputSchema) {}
class AudienceInputDto extends createZodDto(NotificationAudienceInputSchema) {}
class AudienceEstimateDto extends createZodDto(NotificationAudienceEstimateSchema) {}
class CampaignSendInputDto extends createZodDto(NotificationCampaignSendInputSchema) {}
class CampaignTestInputDto extends createZodDto(NotificationCampaignTestInputSchema) {}
class CampaignTestResultDto extends createZodDto(NotificationCampaignTestResultSchema) {}

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const CAMPAIGN_PARAM = { name: "campaignId", type: String, format: "uuid" } as const;

/** Admin gửi thông báo dịch vụ, khuyến mãi, tin tức tới hành khách qua hộp thư + push (TASK-NSR-003). */
@ApiTags("admin-notification-campaigns")
@Controller("admin/notification-campaigns")
export class AdminNotificationCampaignController {
  constructor(@Inject(NotificationCampaignService) private readonly campaigns: NotificationCampaignService) {}

  /** Các chiến dịch, mới tạo trước. */
  @Get()
  @Authorize("notification:broadcast")
  @ZodResponse({ status: 200, description: "Danh sách chiến dịch.", type: CampaignPageDto })
  list(@Authz() authz: Authorization, @Query() query: CampaignQueryDto) {
    return this.campaigns.list(authz, query);
  }

  /** Khuyến mãi đang chạy và bài viết đã đăng để gắn vào chiến dịch. */
  @Get("options")
  @Authorize("notification:broadcast")
  @ZodResponse({ status: 200, description: "Nội dung có thể gắn.", type: CampaignOptionsDto })
  options(@Authz() authz: Authorization) {
    return this.campaigns.options(authz);
  }

  /** Ước tính số người sẽ nhận theo dạng và đối tượng. */
  @Post("estimate")
  @HttpCode(200)
  @Authorize("notification:broadcast")
  @ZodResponse({ status: 200, description: "Số người sẽ nhận.", type: AudienceEstimateDto })
  estimate(@Authz() authz: Authorization, @Body() input: AudienceInputDto) {
    return this.campaigns.estimate(authz, input);
  }

  /** Tạo bản nháp. */
  @Post()
  @Authorize("notification:broadcast")
  @ZodResponse({ status: 201, description: "Bản nháp.", type: CampaignDto })
  @ApiResponse({ status: 422, description: "`CAMPAIGN_INVALID`.", content: problemContent })
  create(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Body() input: CampaignInputDto) {
    return this.campaigns.create(authz, actor, input);
  }

  /** Chi tiết và số liệu gửi. */
  @Get(":campaignId")
  @Authorize("notification:broadcast")
  @ApiParam(CAMPAIGN_PARAM)
  @ZodResponse({ status: 200, description: "Chiến dịch.", type: CampaignDetailDto })
  @ApiResponse({ status: 404, description: "`CAMPAIGN_NOT_FOUND`.", content: problemContent })
  detail(@Authz() authz: Authorization, @Param("campaignId", new ParseUUIDPipe()) campaignId: string) {
    return this.campaigns.detail(authz, campaignId);
  }

  /** Sửa bản nháp. */
  @Put(":campaignId")
  @Authorize("notification:broadcast")
  @ApiParam(CAMPAIGN_PARAM)
  @ZodResponse({ status: 200, description: "Bản nháp đã sửa.", type: CampaignDto })
  @ApiResponse({ status: 409, description: "`CAMPAIGN_STATE_INVALID`.", content: problemContent })
  update(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("campaignId", new ParseUUIDPipe()) campaignId: string, @Body() input: CampaignInputDto) {
    return this.campaigns.update(authz, actor, campaignId, input);
  }

  /** Gửi thử cho một tài khoản hành khách. */
  @Post(":campaignId/test")
  @HttpCode(200)
  @Authorize("notification:broadcast")
  @ApiParam(CAMPAIGN_PARAM)
  @ZodResponse({ status: 200, description: "Đã gửi thử.", type: CampaignTestResultDto })
  @ApiResponse({ status: 404, description: "`CAMPAIGN_TEST_RECIPIENT_NOT_FOUND`.", content: problemContent })
  test(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("campaignId", new ParseUUIDPipe()) campaignId: string, @Body() input: CampaignTestInputDto) {
    return this.campaigns.test(authz, actor, campaignId, input);
  }

  /** Gửi ngay hoặc hẹn giờ. */
  @Post(":campaignId/send")
  @HttpCode(200)
  @Authorize("notification:broadcast")
  @ApiParam(CAMPAIGN_PARAM)
  @ZodResponse({ status: 200, description: "Đã xếp lịch gửi.", type: CampaignDto })
  @ApiResponse({ status: 422, description: "`CAMPAIGN_QUIET_HOURS` · `CAMPAIGN_INVALID`.", content: problemContent })
  send(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("campaignId", new ParseUUIDPipe()) campaignId: string, @Body() input: CampaignSendInputDto) {
    return this.campaigns.send(authz, actor, campaignId, input);
  }

  /** Hủy khi chưa gửi xong. */
  @Post(":campaignId/cancel")
  @HttpCode(200)
  @Authorize("notification:broadcast")
  @ApiParam(CAMPAIGN_PARAM)
  @ZodResponse({ status: 200, description: "Đã hủy.", type: CampaignDto })
  cancel(@Authz() authz: Authorization, @CurrentUser() actor: VerifiedAccessToken, @Param("campaignId", new ParseUUIDPipe()) campaignId: string) {
    return this.campaigns.cancel(authz, actor, campaignId);
  }
}
