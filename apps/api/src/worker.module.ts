import { Module } from "@nestjs/common";
import { SentryModule } from "@sentry/nestjs/setup";
import { AuditModule } from "./audit/audit.module";
import { AppConfigModule } from "./config/app-config.module";
import { APP_CONFIG, type AppConfig } from "./config/env.config";
import { DatabaseModule } from "./database/database.module";
import { NotificationModule } from "./external/notification/notification.module";
import { createPrivateStorage, createPublicStorage } from "./external/storage/storage.module";
import { PRIVATE_STORAGE, PUBLIC_STORAGE } from "./external/storage/storage-provider";
import { BookingExpiryProcessor } from "./booking/booking-expiry.processor";
import { PaymentCallbackProcessor } from "./payment/payment-callback.processor";
import { RefundProcessor } from "./refund/refund.processor";
import { PayoutGenerationProcessor } from "./payout/payout-generation.processor";
import { PAYMENT_GATEWAYS } from "./external/payment/payment-gateway";
import { createPaymentGateways } from "./external/payment/payment.module";
import { ApplicationDocumentCleanupProcessor } from "./operator-kyc/application-document-cleanup.processor";
import { SessionCleanupProcessor } from "./iam/session/session-cleanup.processor";
import { FoundationQueueProcessor } from "./queue/processors/foundation.processor";
import { QueueModule } from "./queue/queue.module";
import { VehicleImageCleanupProcessor } from "./vehicle/vehicle-image-cleanup.processor";
import { NotificationDispatcher } from "./notification/notification-dispatcher";
import { NotificationProcessor } from "./notification/notification.processor";

@Module({
  imports: [SentryModule.forRoot(), AppConfigModule, DatabaseModule, AuditModule, QueueModule, NotificationModule],
  providers: [
    FoundationQueueProcessor,
    SessionCleanupProcessor,
    // Chỉ lấy adapter kho, không import `StorageModule`: worker không phục vụ HTTP nên không cần route dev của nó.
    { provide: PUBLIC_STORAGE, inject: [APP_CONFIG], useFactory: createPublicStorage },
    VehicleImageCleanupProcessor,
    { provide: PRIVATE_STORAGE, inject: [APP_CONFIG], useFactory: createPrivateStorage },
    ApplicationDocumentCleanupProcessor,
    BookingExpiryProcessor,
    PaymentCallbackProcessor,
    // Chỉ lấy các cổng, không import `PaymentGatewayModule`: worker không phục vụ route cổng giả lập.
    { provide: PAYMENT_GATEWAYS, inject: [APP_CONFIG], useFactory: (config: AppConfig) => createPaymentGateways(config).gateways },
    RefundProcessor,
    PayoutGenerationProcessor,
    // Gửi email thông báo (TASK-NSR-001); dispatcher cho các processor ghi thông báo (vé điện tử, hoàn tiền).
    NotificationDispatcher,
    NotificationProcessor
  ]
})
export class WorkerModule {}
