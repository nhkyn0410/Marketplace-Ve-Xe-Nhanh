import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { InboxController } from "./inbox.controller";
import { InboxService } from "./inbox.service";
import { AdminNotificationController, PreferenceController } from "./preference.controller";
import { PreferenceService } from "./preference.service";
import { JourneyDemoController } from "./journey-demo.controller";
import { JourneyDemoService } from "./journey-demo.service";
import { QueueModule } from "../queue/queue.module";
import { NotificationModule } from "../external/notification/notification.module";

/** Cấu hình nhận thông báo, đăng ký thiết bị và hộp thư của chủ thể đã xác thực. */
@Module({ imports: [DatabaseModule, IamModule, QueueModule, NotificationModule], controllers: [PreferenceController, InboxController, AdminNotificationController, JourneyDemoController], providers: [PreferenceService, InboxService, JourneyDemoService] })
export class PreferenceModule {}
