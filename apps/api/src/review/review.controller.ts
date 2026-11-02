import { Body, Controller, Get, HttpCode, Inject, Param, ParseUUIDPipe, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { ReviewStatus } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import {
  AdminReviewQueryDto,
  CustomerReviewDto,
  ModerationInputDto,
  OperatorReviewQueryDto,
  ReplyInputDto,
  ReportInputDto,
  ReviewDto,
  ReviewInputDto,
  ReviewPageDto,
  type CustomerReview,
  type Review,
  type ReviewPage,
} from "./dto/review.dto";
import { ReviewService } from "./review.service";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const REVIEW_PARAM = { name: "reviewId", type: String, format: "uuid" } as const;

// FR-NSR-10, BR-18 — chỉ hành khách đã đăng nhập (`review:create`, phạm vi `own`); khách vãng lai không đánh giá (v1).
@ApiTags("reviews")
@Controller("bookings/:bookingId")
/** Đánh giá chuyến của đơn (TASK-TRUST-001). */
export class CustomerReviewController {
  constructor(@Inject(ReviewService) private readonly reviews: ReviewService) {}

  @Get("review")
  @Authorize("review:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ZodResponse({ status: 200, description: "Đánh giá của đơn (nếu có) + đơn có đủ điều kiện đánh giá không.", type: CustomerReviewDto })
  @ApiResponse({ status: 404, description: "`REVIEW_NOT_FOUND` — đơn không có / không phải của hành khách.", content: problemContent })
  get(@CurrentUser() user: VerifiedAccessToken, @Param("bookingId", new ParseUUIDPipe()) bookingId: string): Promise<CustomerReview> {
    return this.reviews.customerGet(user, bookingId);
  }

  @Post("review")
  @HttpCode(201)
  @Authorize("review:create")
  @ApiParam({ name: "bookingId", type: String, format: "uuid" })
  @ApiBody({ type: ReviewInputDto })
  @ZodResponse({ status: 201, description: "Đã gửi đánh giá.", type: ReviewDto })
  @ApiResponse({ status: 404, description: "`REVIEW_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`REVIEW_NOT_ALLOWED` — chuyến chưa hoàn thành / chưa đi / đã đánh giá.", content: problemContent })
  create(@CurrentUser() user: VerifiedAccessToken, @Param("bookingId", new ParseUUIDPipe()) bookingId: string, @Body() input: ReviewInputDto): Promise<Review> {
    return this.reviews.customerCreate(user, bookingId, input);
  }
}

// Chủ nhà xe (`support:respond`, tenant từ JWT): xem, phản hồi, báo vi phạm — không sửa / xóa được đánh giá.
@ApiTags("operator-reviews")
@Controller("operator")
/** Đánh giá của hành khách cho nhà xe (Figma "Nhà xe · Hỗ trợ / Đánh giá"). */
export class OperatorReviewController {
  constructor(@Inject(ReviewService) private readonly reviews: ReviewService) {}

  @Get("reviews")
  @Authorize("support:respond")
  @ApiQuery({ name: "routeId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "rating", required: false, type: Number, minimum: 1, maximum: 5 })
  @ApiQuery({ name: "replied", required: false, enum: ["yes", "no"] })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Đánh giá (trừ đã ẩn), mới trước, kèm điểm trung bình đánh giá hợp lệ.", type: ReviewPageDto })
  list(@Authz() authz: Authorization, @Query() query: OperatorReviewQueryDto): Promise<ReviewPage> {
    return this.reviews.operatorList(authz, query);
  }

  @Put("reviews/:reviewId/reply")
  @Authorize("support:respond")
  @ApiParam(REVIEW_PARAM)
  @ApiBody({ type: ReplyInputDto })
  @ZodResponse({ status: 200, description: "Đã lưu phản hồi.", type: ReviewDto })
  @ApiResponse({ status: 404, description: "`REVIEW_NOT_FOUND`.", content: problemContent })
  reply(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("reviewId", new ParseUUIDPipe()) reviewId: string, @Body() input: ReplyInputDto): Promise<Review> {
    return this.reviews.reply(authz, actor, reviewId, input);
  }

  @Post("reviews/:reviewId/report")
  @HttpCode(200)
  @Authorize("support:respond")
  @ApiParam(REVIEW_PARAM)
  @ApiBody({ type: ReportInputDto })
  @ZodResponse({ status: 200, description: "Đã báo Vé Xe Nhanh xem xét.", type: ReviewDto })
  @ApiResponse({ status: 404, description: "`REVIEW_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`REVIEW_NOT_ALLOWED` — đã báo cáo.", content: problemContent })
  report(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("reviewId", new ParseUUIDPipe()) reviewId: string, @Body() input: ReportInputDto): Promise<Review> {
    return this.reviews.report(authz, actor, reviewId, input);
  }
}

// UC-28 — kiểm duyệt đánh giá, chỉ PlatformAdmin (`content:moderate`).
@ApiTags("admin-reviews")
@Controller("admin")
/** Kiểm duyệt đánh giá (Figma ADM-10a). */
export class AdminReviewController {
  constructor(@Inject(ReviewService) private readonly reviews: ReviewService) {}

  @Get("reviews")
  @Authorize("content:moderate")
  @ApiQuery({ name: "status", required: false, type: String, description: `${Object.values(ReviewStatus).join(" / ")} hoặc \`attention\`.` })
  @ApiQuery({ name: "operatorId", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "rating", required: false, type: Number, minimum: 1, maximum: 5 })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String, format: "uuid" })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Đánh giá kèm tín hiệu cần xem xét.", type: ReviewPageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminReviewQueryDto): Promise<ReviewPage> {
    return this.reviews.adminList(authz, query);
  }

  @Post("reviews/:reviewId/moderation")
  @HttpCode(200)
  @Authorize("content:moderate")
  @ApiParam(REVIEW_PARAM)
  @ApiBody({ type: ModerationInputDto })
  @ZodResponse({ status: 200, description: "Đã giữ chờ / ẩn / hiển thị lại.", type: ReviewDto })
  @ApiResponse({ status: 404, description: "`REVIEW_NOT_FOUND`.", content: problemContent })
  moderate(@CurrentUser() actor: VerifiedAccessToken, @Authz() authz: Authorization, @Param("reviewId", new ParseUUIDPipe()) reviewId: string, @Body() input: ModerationInputDto): Promise<Review> {
    return this.reviews.moderate(authz, actor, reviewId, input);
  }
}
