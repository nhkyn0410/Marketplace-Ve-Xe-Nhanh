import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiQuery, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { ContentPageStatus, ContentPageType, ContentPlacement } from "../database/prisma.types";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import type { Authorization } from "../iam/role/authorization";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { ContentPageService } from "./content-page.service";
import {
  ContentImageUploadInputDto,
  ContentImageUploadResponseDto,
  type ContentImageUploadResponse,
  type ContentPageDetail,
  ContentPageDetailDto,
  ContentPageInputDto,
  ContentPageListQueryDto,
  type ContentPagePage,
  ContentPagePageDto,
  ContentPageStatusInputDto,
  PublicContentItemDto,
  type PublicContentItem,
  type PublicContentList,
  PublicContentListDto,
  PublicContentListQueryDto,
} from "./dto/content-page.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;

// API §7.5 — chỉ PlatformAdmin (`content:moderate`, FR-ADM-13 / UC-28: kiểm duyệt banner, FAQ, nội dung tĩnh).
@ApiTags("admin-content-pages")
@Controller("admin/content-pages")
/** Admin quản lý nội dung công khai: banner, câu hỏi thường gặp, trang tĩnh (TASK-ADM-003). */
export class AdminContentPageController {
  constructor(@Inject(ContentPageService) private readonly pages: ContentPageService) {}

  /** Một trang nội dung, mới sửa trước. */
  @Get()
  @Authorize("content:moderate")
  @ApiQuery({ name: "type", required: false, enum: Object.values(ContentPageType) })
  @ApiQuery({ name: "status", required: false, enum: Object.values(ContentPageStatus) })
  @ApiQuery({ name: "q", required: false, type: String })
  @ApiQuery({ name: "cursor", required: false, type: String })
  @ApiQuery({ name: "limit", required: false, type: Number, minimum: 1, maximum: 100 })
  @ZodResponse({ status: 200, description: "Một trang nội dung + tổng số khớp bộ lọc.", type: ContentPagePageDto })
  list(@Authz() authz: Authorization, @Query() query: ContentPageListQueryDto): Promise<ContentPagePage> {
    return this.pages.list(authz, query);
  }

  /** Cấp URL tải một ảnh banner (kho công khai, 5 phút). */
  @Post("image-upload-url")
  @HttpCode(200)
  @Authorize("content:moderate")
  @ApiBody({ type: ContentImageUploadInputDto })
  @ZodResponse({ status: 200, description: "URL tải lên + khóa ảnh.", type: ContentImageUploadResponseDto })
  @ApiResponse({ status: 503, description: "Kho ảnh không truy cập được.", content: problemContent })
  createImageUploadUrl(@Body() input: ContentImageUploadInputDto): Promise<ContentImageUploadResponse> {
    return this.pages.createImageUploadUrl(input);
  }

  @Get(":id")
  @Authorize("content:moderate")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Chi tiết nội dung.", type: ContentPageDetailDto })
  @ApiResponse({ status: 404, description: "`CONTENT_PAGE_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param("id") id: string): Promise<ContentPageDetail> {
    return this.pages.get(authz, id);
  }

  /** Tạo nội dung ở trạng thái bản nháp. */
  @Post()
  @HttpCode(201)
  @Authorize("content:moderate")
  @ApiBody({ type: ContentPageInputDto })
  @ZodResponse({ status: 201, description: "Nội dung đã tạo (bản nháp).", type: ContentPageDetailDto })
  @ApiResponse({ status: 409, description: "`CONTENT_PAGE_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`CONTENT_IMAGE_INVALID`.", content: problemContent })
  @ApiResponse({ status: 503, description: "Chưa ghi được audit / kho ảnh lỗi — không lưu gì.", content: problemContent })
  create(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Body() input: ContentPageInputDto,
  ): Promise<ContentPageDetail> {
    return this.pages.create(authz, actor, input);
  }

  /** Thay toàn bộ nội dung (không đổi loại). */
  @Put(":id")
  @Authorize("content:moderate")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: ContentPageInputDto })
  @ZodResponse({ status: 200, description: "Nội dung sau khi sửa.", type: ContentPageDetailDto })
  @ApiResponse({ status: 404, description: "`CONTENT_PAGE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`CONTENT_PAGE_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse({ status: 422, description: "`CONTENT_PAGE_TYPE_IMMUTABLE` / `CONTENT_IMAGE_INVALID`.", content: problemContent })
  update(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("id") id: string,
    @Body() input: ContentPageInputDto,
  ): Promise<ContentPageDetail> {
    return this.pages.update(authz, actor, id, input);
  }

  /** Hiển thị / ẩn về bản nháp. */
  @Put(":id/status")
  @Authorize("content:moderate")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: ContentPageStatusInputDto })
  @ZodResponse({ status: 200, description: "Nội dung sau khi đổi trạng thái.", type: ContentPageDetailDto })
  @ApiResponse({ status: 404, description: "`CONTENT_PAGE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`CONTENT_PAGE_STATE_INVALID`.", content: problemContent })
  setStatus(
    @CurrentUser() actor: VerifiedAccessToken,
    @Authz() authz: Authorization,
    @Param("id") id: string,
    @Body() input: ContentPageStatusInputDto,
  ): Promise<ContentPageDetail> {
    return this.pages.setStatus(authz, actor, id, input.status);
  }
}

// API §7.6 — công khai, không cần đăng nhập (Marketplace / app hành khách đọc sau).
@ApiTags("content-pages")
@Controller("content-pages")
/** Banner, câu hỏi thường gặp, trang tĩnh đang hiển thị. */
export class ContentPageController {
  constructor(@Inject(ContentPageService) private readonly pages: ContentPageService) {}

  @Get()
  @ApiQuery({ name: "type", required: true, enum: Object.values(ContentPageType) })
  @ApiQuery({ name: "placement", required: false, enum: Object.values(ContentPlacement) })
  @ZodResponse({ status: 200, description: "Mục đang hiển thị theo thứ tự.", type: PublicContentListDto })
  list(@Query() query: PublicContentListQueryDto): Promise<PublicContentList> {
    return this.pages.listPublished(query.type, query.placement);
  }

  /** Trang tĩnh đang hiển thị theo đường dẫn. */
  @Get(":slug")
  @ApiParam({ name: "slug", type: String })
  @ZodResponse({ status: 200, description: "Trang tĩnh.", type: PublicContentItemDto })
  @ApiResponse({ status: 404, description: "`CONTENT_PAGE_NOT_FOUND` (không có / chưa hiển thị).", content: problemContent })
  get(@Param("slug") slug: string): Promise<PublicContentItem> {
    return this.pages.getPublishedPage(slug);
  }
}
