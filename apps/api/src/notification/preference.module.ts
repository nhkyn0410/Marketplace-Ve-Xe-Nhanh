import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { InboxController } from "./inbox.controller";
import { InboxService } from "./inbox.service";
import { AdminNotificationController, PreferenceController } from "./preference.controller";
import { PreferenceService } from "./preference.service";

/** Cấu hình nhận thông báo, đăng ký thiết bị và hộp thư của chủ thể đã xác thực. */
@Module({ imports: [DatabaseModule, IamModule], controllers: [PreferenceController, InboxController, AdminNotificationController], providers: [PreferenceService, InboxService] })
export class PreferenceModule {}
