import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminCatalogController } from "./admin-catalog.controller";
import { AdminCatalogService } from "./admin-catalog.service";
import { CatalogController } from "./catalog.controller";
import { CatalogService } from "./catalog.service";

/**
 * TASK-CAT-001 — catalog chuẩn Platform, API đọc công khai (DOMAIN-MAP `catalog/`). TASK-ADM-001 phần catalog —
 * Admin thêm / đổi tên / ngừng dùng tỉnh, phường, loại xe, tiện ích (ghi audit).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [CatalogController, AdminCatalogController],
  providers: [CatalogService, AdminCatalogService],
})
export class CatalogModule {}
