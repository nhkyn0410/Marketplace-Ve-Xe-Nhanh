import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { RoutingModule } from "../external/routing/routing.module";
import { IamModule } from "../iam/iam.module";
import { AdminRouteController } from "./admin-route.controller";
import { AdminRouteService } from "./admin-route.service";
import { RouteController } from "./route.controller";
import { RouteService } from "./route.service";

/**
 * TASK-TRN-002 — tuyến + điểm dừng của nhà xe (DOMAIN-MAP `route/`), số liệu chặng qua RoutingModule; Admin xem tuyến
 * mọi nhà xe + hiệu suất (chờ duyệt 28/10/2026).
 */
@Module({
  imports: [DatabaseModule, IamModule, RoutingModule],
  controllers: [RouteController, AdminRouteController],
  providers: [RouteService, AdminRouteService],
})
export class RouteModule {}
