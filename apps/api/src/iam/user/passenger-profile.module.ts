import { Module } from "@nestjs/common";
import { DatabaseModule } from "../../database/database.module";
import { IamModule } from "../iam.module";
import { PassengerProfileController } from "./passenger-profile.controller";
import { PassengerProfileService } from "./passenger-profile.service";

/** Hồ sơ và danh sách riêng của hành khách (MKT-002). */
@Module({ imports: [DatabaseModule, IamModule], controllers: [PassengerProfileController], providers: [PassengerProfileService] })
export class PassengerProfileModule {}
