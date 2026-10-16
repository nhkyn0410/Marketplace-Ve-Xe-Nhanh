import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminPolicyController } from "./admin-policy.controller";
import { AdminPolicyService } from "./admin-policy.service";

/**
 * Chính sách nền tảng (DOMAIN-MAP `policy/`): phiên bản hủy / hoàn tiền, giữ chỗ, chi trả + khung giá vé (FR-ADM-06/08/09,
 * UC-25). Cảnh báo khung giá cho bảng giá nhà xe dùng hàm thuần ở `policy-state.ts` (module `fare/` gọi trực tiếp).
 */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminPolicyController],
  providers: [AdminPolicyService],
})
export class PolicyModule {}
