import { Module } from "@nestjs/common";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { SentryModule } from "@sentry/nestjs/setup";
import { ZodSerializerInterceptor } from "nestjs-zod";
import { AppController } from "./app.controller";
import { AdminAuditLogModule } from "./audit/admin-audit-log.module";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { DatabaseModule } from "./database/database.module";
import { FareModule } from "./fare/fare.module";
import { MongoAuditModule } from "./database/mongo-audit.module";
import { OperatorKycModule } from "./operator-kyc/operator-kyc.module";
import { OperatorModule } from "./operator/operator.module";
import { PolicyModule } from "./policy/policy.module";
import { CommissionModule } from "./commission/commission.module";
import { AdminSystemModule } from "./admin/admin-system.module";
import { EmployeeModule } from "./employee/employee.module";
import { MarketplaceModule } from "./marketplace/marketplace.module";
import { SeatHoldModule } from "./seat-hold/seat-hold.module";
import { BookingModule } from "./booking/booking.module";
import { PaymentModule } from "./payment/payment.module";
import { TicketModule } from "./ticket/ticket.module";
import { RefundModule } from "./refund/refund.module";
import { PayoutModule } from "./payout/payout.module";
import { IamModule } from "./iam/iam.module";
import { QueueModule } from "./queue/queue.module";
import { CatalogModule } from "./catalog/catalog.module";
import { ContentModule } from "./content/content.module";
import { RouteModule } from "./route/route.module";
import { StopPointModule } from "./stop-point/stop-point.module";
import { TripModule } from "./trip/trip.module";
import { VehicleModule } from "./vehicle/vehicle.module";

@Module({
  imports: [
    SentryModule.forRoot(),
    AppConfigModule,
    DatabaseModule,
    MongoAuditModule,
    AuditModule,
    QueueModule,
    IamModule,
    CatalogModule,
    VehicleModule,
    StopPointModule,
    RouteModule,
    TripModule,
    FareModule,
    OperatorKycModule,
    AdminAuditLogModule,
    ContentModule,
    OperatorModule,
    PolicyModule,
    CommissionModule,
    AdminSystemModule,
    EmployeeModule,
    MarketplaceModule,
    SeatHoldModule,
    BookingModule,
    PaymentModule,
    TicketModule,
    RefundModule,
    PayoutModule,
  ],
  controllers: [AppController],
  providers: [{ provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor }],
})
export class AppModule {}
