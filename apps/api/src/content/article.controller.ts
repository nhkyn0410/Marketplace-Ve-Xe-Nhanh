import { Controller, Get, HttpCode, Inject, Param, Post, Query, Req } from "@nestjs/common";
import { ApiExtraModels, ApiResponse, ApiTags, getSchemaPath } from "@nestjs/swagger";
import type { Request } from "express";
import { ZodResponse } from "nestjs-zod";
import { resolveTrustedClientIp } from "../common/trusted-client-ip";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { ProblemDetailsDto } from "../openapi/openapi.dto";
import { ArticleService } from "./article.service";
import {
  ArticleCategoryListDto,
  ArticleDto,
  ArticleListQueryDto,
  ArticlePageDto,
  ArticleSlugParamDto,
  type PublicArticle,
  type PublicArticlePage,
  type PublicCategoryList,
} from "./dto/article.dto";

const problemContent = {
  "application/problem+json": { schema: { $ref: getSchemaPath(ProblemDetailsDto) } },
};
const NOT_FOUND = {
  status: 404,
  description: "`ARTICLE_NOT_FOUND` — không có, chưa xuất bản, chưa tới giờ hoặc đã gỡ.",
  content: problemContent,
};

// CÔNG KHAI (API §7.2 — trang Khám phá, TASK-CNT-001, FR-MKT-14): Guest / User đọc bài đã xuất bản. Không
// `@Authorize` (decorator đó đòi token). Ghi bài viết thuộc `/admin/articles*`.
@ApiTags("articles")
@ApiExtraModels(ProblemDetailsDto)
@Controller()
/** Bài viết tin tức / cẩm nang công khai. */
export class ArticleController {
  constructor(
    @Inject(ArticleService) private readonly articles: ArticleService,
    @Inject(APP_CONFIG) private readonly config: AppConfig,
  ) {}

  /** Chuyên mục đang dùng + số bài đang hiện. */
  @Get("article-categories")
  @ZodResponse({ status: 200, description: "Chuyên mục theo thứ tự hiển thị.", type: ArticleCategoryListDto })
  listCategories(): Promise<PublicCategoryList> {
    return this.articles.listCategories();
  }

  /** Bài đã xuất bản, mới nhất trước; lọc chuyên mục / nổi bật, tìm tiêu đề hoặc tóm tắt. */
  @Get("articles")
  @ZodResponse({ status: 200, description: "Một trang bài viết.", type: ArticlePageDto })
  list(@Query() query: ArticleListQueryDto): Promise<PublicArticlePage> {
    return this.articles.list(query);
  }

  @Get("articles/:slug")
  @ZodResponse({ status: 200, description: "Một bài kèm nội dung Markdown.", type: ArticleDto })
  @ApiResponse(NOT_FOUND)
  get(@Param() params: ArticleSlugParamDto): Promise<PublicArticle> {
    return this.articles.get(params.slug);
  }

  /** Ghi lượt xem best-effort: một người (IP) một lượt / bài / 30 phút. */
  @Post("articles/:slug/views")
  @HttpCode(204)
  @ApiResponse({ status: 204, description: "Đã ghi nhận (hoặc bỏ qua vì vừa xem)." })
  @ApiResponse(NOT_FOUND)
  recordView(@Param() params: ArticleSlugParamDto, @Req() request: Request): Promise<void> {
    return this.articles.recordView(params.slug, resolveTrustedClientIp(request, this.config.NODE_ENV));
  }
}
