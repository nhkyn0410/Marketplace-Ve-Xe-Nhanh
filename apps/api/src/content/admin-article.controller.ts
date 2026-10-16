import { Body, Controller, Get, HttpCode, Inject, Param, Post, Put, Query } from "@nestjs/common";
import { ApiBody, ApiParam, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import { ZodResponse } from "nestjs-zod";
import { CurrentUser } from "../iam/auth/current-user.decorator";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { Authorize, Authz } from "../iam/role/authorize.decorator";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { AdminArticleService } from "./admin-article.service";
import {
  AdminArticleCategoryDto,
  type Category,
  AdminArticleCategoryInputDto,
  AdminArticleCategoryListDto,
  type CategoryList,
  AdminArticleDto,
  type ArticleDetail,
  AdminArticleIdParamDto,
  AdminArticleImageUploadInputDto,
  AdminArticleImageUploadResponseDto,
  type ImageUploadResponse,
  AdminArticleInputDto,
  AdminArticlePageDto,
  type ArticlePage,
  AdminArticleListQueryDto,
  AdminArticlePublishDto,
} from "./dto/admin-article.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const ID_PARAM = { name: "id", type: String, format: "uuid" } as const;
const UNAVAILABLE = {
  status: 503,
  description: "Chưa ghi được audit / kho ảnh không phản hồi — không lưu gì.",
  content: problemContent,
};
const INVALID_INPUT = {
  status: 422,
  description: "`ARTICLE_CATEGORY_UNAVAILABLE` (chuyên mục ngừng dùng) / `ARTICLE_IMAGE_INVALID` (ảnh bìa).",
  content: problemContent,
};

// API §7.5 — Admin quản lý bài viết (TASK-CNT-001; FR-ADM-18..19, UC-40, BR-74). Quyền `content:manage` (PLATFORM_ADMIN).
@ApiTags("admin-articles")
@Controller("admin/articles")
/** Bài viết tin tức / cẩm nang của trang Khám phá. */
export class AdminArticleController {
  constructor(@Inject(AdminArticleService) private readonly articles: AdminArticleService) {}

  /** Mọi trạng thái, sửa gần nhất trước; lọc trạng thái / chuyên mục, tìm tiêu đề hoặc slug. */
  @Get()
  @Authorize("content:manage")
  @ZodResponse({ status: 200, description: "Một trang bài viết.", type: AdminArticlePageDto })
  list(@Authz() authz: Authorization, @Query() query: AdminArticleListQueryDto): Promise<ArticlePage> {
    return this.articles.list(authz, query);
  }

  /** URL tải một ảnh (bìa / chèn vào nội dung) lên kho công khai, hiệu lực 5 phút. */
  @Post("images")
  @HttpCode(200)
  @Authorize("content:manage")
  @ApiBody({ type: AdminArticleImageUploadInputDto })
  @ZodResponse({
    status: 200,
    description: "URL tải lên + khóa object + địa chỉ công khai.",
    type: AdminArticleImageUploadResponseDto,
  })
  @ApiResponse(UNAVAILABLE)
  createImageUploadUrl(@Body() input: AdminArticleImageUploadInputDto): Promise<ImageUploadResponse> {
    return this.articles.createImageUploadUrl(input);
  }

  @Get(":id")
  @Authorize("content:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Một bài viết kèm nội dung Markdown.", type: AdminArticleDto })
  @ApiResponse({ status: 404, description: "`ARTICLE_NOT_FOUND`.", content: problemContent })
  get(@Authz() authz: Authorization, @Param() params: AdminArticleIdParamDto): Promise<ArticleDetail> {
    return this.articles.get(authz, params.id);
  }

  /** Tạo bài `DRAFT`. */
  @Post()
  @Authorize("content:manage")
  @ApiBody({ type: AdminArticleInputDto })
  @ZodResponse({ status: 201, description: "Bài nháp đã tạo.", type: AdminArticleDto })
  @ApiResponse({ status: 409, description: "`ARTICLE_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse(INVALID_INPUT)
  @ApiResponse(UNAVAILABLE)
  create(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminArticleInputDto,
  ): Promise<ArticleDetail> {
    return this.articles.create(authz, actor, input);
  }

  /** Thay toàn bộ nội dung; bài đang xuất bản đổi ngay trên trang công khai. */
  @Put(":id")
  @Authorize("content:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminArticleInputDto })
  @ZodResponse({ status: 200, description: "Bài sau khi sửa.", type: AdminArticleDto })
  @ApiResponse({ status: 404, description: "`ARTICLE_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`ARTICLE_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse(INVALID_INPUT)
  @ApiResponse(UNAVAILABLE)
  update(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminArticleIdParamDto,
    @Body() input: AdminArticleInputDto,
  ): Promise<ArticleDetail> {
    return this.articles.update(authz, actor, params.id, input);
  }

  /** `DRAFT` / `ARCHIVED` → `PUBLISHED` (audited). */
  @Post(":id/publish")
  @HttpCode(200)
  @Authorize("content:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminArticlePublishDto })
  @ZodResponse({ status: 200, description: "Bài đã xuất bản.", type: AdminArticleDto })
  @ApiResponse({ status: 409, description: "`ARTICLE_STATE_INVALID` — đang xuất bản rồi.", content: problemContent })
  @ApiResponse({ status: 422, description: "`ARTICLE_INCOMPLETE` — chưa có nội dung.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  publish(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminArticleIdParamDto,
    @Body() input: AdminArticlePublishDto,
  ): Promise<ArticleDetail> {
    return this.articles.publish(authz, actor, params.id, input.publishedAt);
  }

  /** `PUBLISHED` → `ARCHIVED` (audited). */
  @Post(":id/archive")
  @HttpCode(200)
  @Authorize("content:manage")
  @ApiParam(ID_PARAM)
  @ZodResponse({ status: 200, description: "Bài đã gỡ.", type: AdminArticleDto })
  @ApiResponse({ status: 409, description: "`ARTICLE_STATE_INVALID` — bài chưa xuất bản.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  archive(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminArticleIdParamDto,
  ): Promise<ArticleDetail> {
    return this.articles.archive(authz, actor, params.id);
  }
}

@ApiTags("admin-articles")
@Controller("admin/article-categories")
/** Chuyên mục bài viết (FR-ADM-19). */
export class AdminArticleCategoryController {
  constructor(@Inject(AdminArticleService) private readonly articles: AdminArticleService) {}

  @Get()
  @Authorize("content:manage")
  @ZodResponse({ status: 200, description: "Mọi chuyên mục theo thứ tự hiển thị.", type: AdminArticleCategoryListDto })
  list(@Authz() authz: Authorization): Promise<CategoryList> {
    return this.articles.listCategories(authz);
  }

  @Post()
  @Authorize("content:manage")
  @ApiBody({ type: AdminArticleCategoryInputDto })
  @ZodResponse({ status: 201, description: "Chuyên mục đã tạo.", type: AdminArticleCategoryDto })
  @ApiResponse({ status: 409, description: "`ARTICLE_CATEGORY_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  create(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Body() input: AdminArticleCategoryInputDto,
  ): Promise<Category> {
    return this.articles.createCategory(authz, actor, input);
  }

  /** Sửa tên / slug / thứ tự / trạng thái (ngừng dùng = `INACTIVE`, không xóa). */
  @Put(":id")
  @Authorize("content:manage")
  @ApiParam(ID_PARAM)
  @ApiBody({ type: AdminArticleCategoryInputDto })
  @ZodResponse({ status: 200, description: "Chuyên mục sau khi sửa.", type: AdminArticleCategoryDto })
  @ApiResponse({ status: 404, description: "`ARTICLE_CATEGORY_NOT_FOUND`.", content: problemContent })
  @ApiResponse({ status: 409, description: "`ARTICLE_CATEGORY_SLUG_CONFLICT`.", content: problemContent })
  @ApiResponse(UNAVAILABLE)
  update(
    @Authz() authz: Authorization,
    @CurrentUser() actor: VerifiedAccessToken,
    @Param() params: AdminArticleIdParamDto,
    @Body() input: AdminArticleCategoryInputDto,
  ): Promise<Category> {
    return this.articles.updateCategory(authz, actor, params.id, input);
  }
}
