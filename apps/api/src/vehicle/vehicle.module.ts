import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { NotificationModule } from "../external/notification/notification.module";
import { StorageModule } from "../external/storage/storage.module";
import { IamModule } from "../iam/iam.module";
import { RedisModule } from "../redis/redis.module";
import { AdminVehicleImageController } from "./admin-vehicle-image.controller";
import { AdminVehicleImageService } from "./admin-vehicle-image.service";
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
 * TASK-ADM-003 (phần ảnh xe) — Admin rà soát / gỡ ảnh: audit qua `AuditModule`, báo chủ nhà xe qua email.
 */
@Module({
  imports: [DatabaseModule, IamModule, StorageModule, RedisModule, AuditModule, NotificationModule],
  controllers: [VehicleController, VehicleImageController, AdminVehicleImageController, SeatMapController],
  providers: [VehicleService, VehicleImageService, VehicleImageUploadLimiter, AdminVehicleImageService, SeatMapService],
})
export class VehicleModule {}
