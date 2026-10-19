import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminNotificationController, PreferenceController } from "./preference.controller";
import { PreferenceService } from "./preference.service";

/** Cấu hình nhận thông báo và đăng ký thiết bị của chủ thể đã xác thực. */
@Module({ imports: [DatabaseModule, IamModule], controllers: [PreferenceController, AdminNotificationController], providers: [PreferenceService] })
export class PreferenceModule {}
