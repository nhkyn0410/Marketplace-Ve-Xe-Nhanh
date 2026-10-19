import { Module } from "@nestjs/common";
import { APP_INTERCEPTOR } from "@nestjs/core";
import { ZodSerializerInterceptor } from "nestjs-zod";
import { AppController } from "../app.controller";
import { APP_CONFIG } from "../config/env.config";
import { DatabaseHealthService } from "../database/database-health.service";
import { PrismaService } from "../database/prisma.service";
import { MongoHealthService } from "../database/mongo-health.service";
import { AuthController } from "../iam/auth/auth.controller";
import { AuthService } from "../iam/auth/auth.service";
import { TokenService } from "../iam/auth/token.service";
import { WebAuthService } from "../iam/auth/web/web-auth.service";
import { PermissionGuard } from "../iam/role/permission.guard";
import { RecentReauthGuard } from "../iam/role/recent-reauth.guard";
import { TenantGuard } from "../iam/role/tenant.guard";
import { SessionController } from "../iam/session/session.controller";
import { SessionService } from "../iam/session/session.service";
import { EmployeeAccountController } from "../iam/user/employee-account.controller";
import { EmployeeAccountService } from "../iam/user/employee-account.service";
import { QueueHealthService } from "../queue/queue-health.service";
import { RedisHealthService } from "../redis/redis-health.service";
import { CatalogController } from "../catalog/catalog.controller";
import { AdminCatalogController } from "../catalog/admin-catalog.controller";
import { AdminCatalogService } from "../catalog/admin-catalog.service";
import { CatalogService } from "../catalog/catalog.service";
import { RouteController } from "../route/route.controller";
import { RouteService } from "../route/route.service";
import { StopPointProposalController } from "../stop-point/stop-point-proposal.controller";
import {
  AdminOperatorStopPointController,
  AdminSharedStopPointController,
  AdminStopPointProposalController,
} from "../stop-point/admin-stop-point.controller";
import { AdminStopPointService } from "../stop-point/admin-stop-point.service";
import { StopPointProposalService } from "../stop-point/stop-point-proposal.service";
import { StopPointController } from "../stop-point/stop-point.controller";
import { StopPointService } from "../stop-point/stop-point.service";
import { FareController } from "../fare/fare.controller";
import { FareService } from "../fare/fare.service";
import { TripController } from "../trip/trip.controller";
import { TripService } from "../trip/trip.service";
import { TripScheduleController } from "../trip/trip-schedule.controller";
import { EmployeeAssignmentController } from "../employee/employee-assignment.controller";
import { AdminContentPageController, ContentPageController } from "../catalog/content-page.controller";
import { ContentPageService } from "../catalog/content-page.service";
import { PublicTripController } from "../marketplace/public-trip.controller";
import { TripSearchService } from "../marketplace/trip-search.service";
import { SeatHoldController } from "../seat-hold/seat-hold.controller";
import { SeatHoldService } from "../seat-hold/seat-hold.service";
import { BookingController } from "../booking/booking.controller";
import { BookingService } from "../booking/booking.service";
import { OperatorBookingController } from "../booking/operator-booking.controller";
import { OperatorBookingService } from "../booking/operator-booking.service";
import { PaymentController } from "../payment/payment.controller";
import { PaymentService } from "../payment/payment.service";
import { AdminPaymentController } from "../payment/admin-payment.controller";
import { AdminPaymentService } from "../payment/admin-payment.service";
import { TicketController } from "../ticket/ticket.controller";
import { TicketService } from "../ticket/ticket.service";
import { CancellationController } from "../refund/cancellation.controller";
import { CancellationService } from "../refund/cancellation.service";
import { AdminRefundController } from "../refund/admin-refund.controller";
import { AdminRefundService } from "../refund/admin-refund.service";
import { AdminPayoutController } from "../payout/admin-payout.controller";
import { AdminPayoutService } from "../payout/admin-payout.service";
import { OperatorFinanceController } from "../payout/operator-finance.controller";
import { OperatorFinanceService } from "../payout/operator-finance.service";
import { EmployeeAssignmentService } from "../employee/employee-assignment.service";
import { TripScheduleService } from "../trip/trip-schedule.service";
import { SeatMapController } from "../vehicle/seat-map.controller";
import { SeatMapService } from "../vehicle/seat-map.service";
import { OperatorApplicationController } from "../operator-kyc/operator-application.controller";
import { OperatorApplicationService } from "../operator-kyc/operator-application.service";
import { OperatorApplicationReviewController } from "../operator-kyc/operator-application-review.controller";
import { OperatorApplicationReviewService } from "../operator-kyc/operator-application-review.service";
import { AdminAuditLogController } from "../audit/admin-audit-log.controller";
import { AdminOperatorController } from "../operator/admin-operator.controller";
import { AdminOperatorService } from "../operator/admin-operator.service";
import { OperatorProfileController } from "../operator/operator-profile.controller";
import { OperatorProfileService } from "../operator/operator-profile.service";
import { AdminPolicyController } from "../policy/admin-policy.controller";
import { AdminPolicyService } from "../policy/admin-policy.service";
import { AdminCommissionController } from "../commission/admin-commission.controller";
import { AdminCommissionService } from "../commission/admin-commission.service";
import { SystemStatusController } from "../admin/system-status.controller";
import { SystemStatusService } from "../admin/system-status.service";
import { AdminAccountService } from "../iam/user/admin-account.service";
import {
  AdminEmployeeController,
  AdminPassengerController,
  AdminPlatformAccountController,
} from "../iam/user/admin-user.controller";
import { AdminArticleCategoryController, AdminArticleController } from "../content/admin-article.controller";
import { AdminArticleService } from "../content/admin-article.service";
import { ArticleController } from "../content/article.controller";
import { ArticleService } from "../content/article.service";
import { AdminAuditLogService } from "../audit/admin-audit-log.service";
import { AdminVehicleImageController } from "../vehicle/admin-vehicle-image.controller";
import { AdminVehicleImageService } from "../vehicle/admin-vehicle-image.service";
import { VehicleImageController } from "../vehicle/vehicle-image.controller";
import { VehicleImageService } from "../vehicle/vehicle-image.service";
import { VehicleController } from "../vehicle/vehicle.controller";
import { VehicleService } from "../vehicle/vehicle.service";

@Module({
  // Mọi controller IAM phải có mặt ở đây, nếu không route biến mất khỏi OpenAPI
  // và `gen:api-client` sinh client thiếu toàn bộ auth mà CI vẫn xanh (ADR-012).
  controllers: [
    AppController,
    AuthController,
    SessionController,
    EmployeeAccountController,
    CatalogController,
    AdminCatalogController,
    VehicleController,
    VehicleImageController,
    AdminVehicleImageController,
    SeatMapController,
    StopPointController,
    StopPointProposalController,
    AdminSharedStopPointController,
    AdminStopPointProposalController,
    AdminOperatorStopPointController,
    RouteController,
    TripController,
    TripScheduleController,
    EmployeeAssignmentController,
    ContentPageController,
    AdminContentPageController,
    PublicTripController,
    SeatHoldController,
    BookingController,
    OperatorBookingController,
    PaymentController,
    AdminPaymentController,
    TicketController,
    CancellationController,
    AdminRefundController,
    AdminPayoutController,
    OperatorFinanceController,
    FareController,
    OperatorApplicationController,
    OperatorApplicationReviewController,
    AdminAuditLogController,
    ArticleController,
    AdminArticleController,
    AdminArticleCategoryController,
    AdminOperatorController,
    OperatorProfileController,
    AdminPolicyController,
    AdminCommissionController,
    SystemStatusController,
    AdminPassengerController,
    AdminEmployeeController,
    AdminPlatformAccountController,
  ],
  providers: [
    { provide: APP_INTERCEPTOR, useClass: ZodSerializerInterceptor },
    // Scan-only: chỉ cần metadata route, không cần dependency thật (không Postgres/Redis/Mongo).
    { provide: AuthService, useValue: {} },
    { provide: CatalogService, useValue: {} },
    { provide: AdminCatalogService, useValue: {} },
    { provide: VehicleService, useValue: {} },
    { provide: VehicleImageService, useValue: {} },
    { provide: AdminVehicleImageService, useValue: {} },
    { provide: AdminAuditLogService, useValue: {} },
    { provide: ArticleService, useValue: {} },
    { provide: AdminArticleService, useValue: {} },
    { provide: AdminOperatorService, useValue: {} },
    { provide: OperatorProfileService, useValue: {} },
    { provide: AdminPolicyService, useValue: {} },
    { provide: AdminCommissionService, useValue: {} },
    { provide: SystemStatusService, useValue: {} },
    { provide: AdminAccountService, useValue: {} },
    { provide: OperatorApplicationService, useValue: {} },
    { provide: OperatorApplicationReviewService, useValue: {} },
    // Dependency của ApplicationTokenGuard (link bảo mật hồ sơ nhà xe) — Nest dựng guard lúc khởi tạo module.
    { provide: PrismaService, useValue: {} },
    { provide: SeatMapService, useValue: {} },
    { provide: StopPointService, useValue: {} },
    { provide: StopPointProposalService, useValue: {} },
    { provide: AdminStopPointService, useValue: {} },
    { provide: RouteService, useValue: {} },
    { provide: TripService, useValue: {} },
    { provide: TripScheduleService, useValue: {} },
    { provide: EmployeeAssignmentService, useValue: {} },
    { provide: ContentPageService, useValue: {} },
    { provide: TripSearchService, useValue: {} },
    { provide: SeatHoldService, useValue: {} },
    { provide: BookingService, useValue: {} },
    { provide: OperatorBookingService, useValue: {} },
    { provide: PaymentService, useValue: {} },
    { provide: AdminPaymentService, useValue: {} },
    { provide: TicketService, useValue: {} },
    { provide: CancellationService, useValue: {} },
    { provide: AdminRefundService, useValue: {} },
    { provide: AdminPayoutService, useValue: {} },
    { provide: OperatorFinanceService, useValue: {} },
    { provide: FareService, useValue: {} },
    // Dependency của AccessTokenGuard (logout, re-auth) — Nest dựng guard lúc khởi tạo module.
    { provide: TokenService, useValue: {} },
    { provide: SessionService, useValue: {} },
    // TASK-IAM-006: AuthController/SessionController ghi cookie qua service này (scan-only thì không gọi).
    { provide: WebAuthService, useValue: {} },
    { provide: EmployeeAccountService, useValue: {} },
    { provide: PermissionGuard, useValue: {} },
    { provide: TenantGuard, useValue: {} },
    { provide: RecentReauthGuard, useValue: {} },
    { provide: APP_CONFIG, useValue: { NODE_ENV: "test" } },
    {
      provide: DatabaseHealthService,
      useValue: {
        check: () =>
          Promise.resolve({
            status: "ok",
            service: "postgres",
            timestamp: timestamp(),
          }),
      },
    },
    {
      provide: MongoHealthService,
      useValue: {
        check: () =>
          Promise.resolve({
            status: "ok",
            service: "mongo",
            timestamp: timestamp(),
          }),
      },
    },
    {
      provide: RedisHealthService,
      useValue: {
        check: () =>
          Promise.resolve({
            status: "ok",
            service: "redis",
            timestamp: timestamp(),
          }),
      },
    },
    {
      provide: QueueHealthService,
      useValue: {
        check: () =>
          Promise.resolve({
            status: "ok",
            queues: [{ name: "foundation", counts: {} }],
            timestamp: timestamp(),
          }),
      },
    },
  ],
})
export class OpenApiModule {}

function timestamp(): string {
  return new Date(0).toISOString();
}
