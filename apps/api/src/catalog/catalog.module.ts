import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { AdminCatalogController } from "./admin-catalog.controller";
import { AdminCatalogService } from "./admin-catalog.service";
import { CatalogController } from "./catalog.controller";
import { CatalogService } from "./catalog.service";
import { AdminContentPageController, ContentPageController } from "./content-page.controller";
import { ContentPageService } from "./content-page.service";

/**
 * TASK-CAT-001 — catalog chuẩn Platform, API đọc công khai (DOMAIN-MAP `catalog/`). TASK-ADM-001 phần catalog —
 * Admin thêm / đổi tên / ngừng dùng tỉnh, phường, loại xe, tiện ích (ghi audit). TASK-ADM-003 — nội dung công khai
 * (banner, câu hỏi thường gặp, trang tĩnh; ảnh banner ở kho công khai qua `StorageModule`).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule, StorageModule],
  controllers: [CatalogController, AdminCatalogController, ContentPageController, AdminContentPageController],
  providers: [CatalogService, AdminCatalogService, ContentPageService],
})
export class CatalogModule {}
