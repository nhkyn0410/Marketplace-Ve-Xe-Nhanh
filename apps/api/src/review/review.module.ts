import { Module } from "@nestjs/common";
import { AuditModule } from "../audit/audit.module";
import { DatabaseModule } from "../database/database.module";
import { IamModule } from "../iam/iam.module";
import { AdminReviewController, CustomerReviewController, OperatorReviewController, PassengerReviewController } from "./review.controller";
import { ReviewService } from "./review.service";

/** Support & Trust (DOMAIN-MAP `review/`) — TASK-TRUST-001: đánh giá chuyến đi, nhà xe phản hồi / báo vi phạm, Admin kiểm duyệt. */
@Module({
  imports: [DatabaseModule, IamModule, AuditModule],
  controllers: [CustomerReviewController, PassengerReviewController, OperatorReviewController, AdminReviewController],
  providers: [ReviewService],
})
export class ReviewModule {}
