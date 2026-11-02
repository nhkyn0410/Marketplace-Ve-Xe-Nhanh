import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { AdminArticleCategoryController, AdminArticleController } from "./admin-article.controller";
import { AdminArticleService } from "./admin-article.service";
import { ArticleController } from "./article.controller";
import { ArticleService } from "./article.service";

/**
 * TASK-CNT-001 — bài viết tin tức / cẩm nang (DOMAIN-MAP `content/`): API công khai của trang Khám phá + Admin soạn,
 * xuất bản, gỡ bài và quản lý chuyên mục (audit qua `AuditModule`, ảnh ở kho công khai qua `StorageModule`).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, StorageModule, RedisModule],
  controllers: [ArticleController, AdminArticleController, AdminArticleCategoryController],
  providers: [ArticleService, AdminArticleService],
})
export class ContentModule {}
