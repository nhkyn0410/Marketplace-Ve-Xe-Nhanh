import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminLoyaltyController } from "./admin-loyalty.controller";
import { AdminLoyaltyService } from "./admin-loyalty.service";
import { PassengerLoyaltyController } from "./passenger-loyalty.controller";
import { PassengerLoyaltyService } from "./passenger-loyalty.service";

/** VXN Plus cho Admin và hành khách; tích / thu hồi / hết hạn điểm và voucher chạy ở worker. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [AdminLoyaltyController, PassengerLoyaltyController],
  providers: [AdminLoyaltyService, PassengerLoyaltyService],
})
export class LoyaltyModule {}
