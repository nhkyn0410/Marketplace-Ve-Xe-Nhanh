import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { StorageModule } from "../external/storage/storage.module";
import { RedisModule } from "../redis/redis.module";
import { PublicTripController } from "./public-trip.controller";
import { TripSearchService } from "./trip-search.service";

/** Marketplace layer (DOMAIN-MAP `marketplace/`) — TASK-TRN-004: tìm chuyến + chi tiết chuyến công khai. */
@Module({
  imports: [DatabaseModule, StorageModule, RedisModule],
  controllers: [PublicTripController],
  providers: [TripSearchService],
})
export class MarketplaceModule {}
