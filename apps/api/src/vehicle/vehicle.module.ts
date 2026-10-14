import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { SeatMapController } from "./seat-map.controller";
import { SeatMapService } from "./seat-map.service";
import { VehicleImageController } from "./vehicle-image.controller";
import { VehicleImageService } from "./vehicle-image.service";
import { VehicleImageUploadLimiter } from "./vehicle-image-upload-limiter";
import { VehicleController } from "./vehicle.controller";
import { VehicleService } from "./vehicle.service";

/**
 * TASK-TRN-001 — Vehicle + SeatMap/Seat của nhà xe (DOMAIN-MAP `vehicle/`). IamModule cho `@Authorize`.
 * TASK-TRN-009 — ảnh xe: kho object qua `StorageModule`, bộ đếm tần suất qua `RedisModule`.
 */
@Module({
  imports: [DatabaseModule, IamModule, StorageModule, RedisModule],
  controllers: [VehicleController, VehicleImageController, SeatMapController],
  providers: [VehicleService, VehicleImageService, VehicleImageUploadLimiter, SeatMapService],
})
export class VehicleModule {}
