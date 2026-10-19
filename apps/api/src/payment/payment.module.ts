import { Module } from "@nestjs/common";
import { DatabaseModule } from "../database/database.module";
import { PaymentGatewayModule } from "../external/payment/payment.module";
import { IamModule } from "../iam/iam.module";
import { QueueModule } from "../queue/queue.module";
import { AdminPaymentController } from "./admin-payment.controller";
import { AdminPaymentService } from "./admin-payment.service";
import { PaymentController } from "./payment.controller";
import { PaymentService } from "./payment.service";
import { PaymentWebhookController } from "./payment-webhook.controller";
import { PaymentWebhookService } from "./payment-webhook.service";

/**
 * Booking/Ticket/Payment (DOMAIN-MAP `payment/`) — TASK-BTP-003: tạo payment, nhận IPN; xử lý callback ở worker. TASK-ADM-002:
 * giám sát thanh toán phía Admin.
 */
@Module({
  imports: [DatabaseModule, IamModule, QueueModule, PaymentGatewayModule],
  controllers: [PaymentController, PaymentWebhookController, AdminPaymentController],
  providers: [PaymentService, PaymentWebhookService, AdminPaymentService],
})
export class PaymentModule {}
