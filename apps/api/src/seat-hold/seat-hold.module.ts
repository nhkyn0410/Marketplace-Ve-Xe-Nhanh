import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { SeatHoldController } from "./seat-hold.controller";
import { SeatHoldService } from "./seat-hold.service";

/** Trip & Inventory (DOMAIN-MAP `seat-hold/`) — TASK-BTP-001: giữ chỗ trên Redis (ADR-015). */
@Module({
  imports: [DatabaseModule, IamModule, RedisModule],
  controllers: [SeatHoldController],
  providers: [SeatHoldService],
  exports: [SeatHoldService],
})
export class SeatHoldModule {}
