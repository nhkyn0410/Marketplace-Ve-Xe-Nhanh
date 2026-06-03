import { Injectable, OnModuleDestroy, OnModuleInit } from "@nestjs/common";
import { Prisma, PrismaClient } from "@prisma/client";

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit(): Promise<void> {
    await this.$connect();
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
  }

  /**
   * Mở transaction + set GUC `app.operator_id` (transaction-local) cho Postgres RLS.
   * YÊU CẦU mỗi tenant table: ENABLE + FORCE ROW LEVEL SECURITY + policy
   * `USING (operator_id = current_setting('app.operator_id')::bigint)`, và app DB role
   * KHÔNG owner/superuser (nếu không RLS bị bypass). Xem 04-database-design DB-PRIN-01.
   */
  async withOperatorContext<T>(
    operatorId: string,
    callback: (tx: Prisma.TransactionClient) => Promise<T>
  ): Promise<T> {
    return this.$transaction(async (tx) => {
      await tx.$executeRaw`SELECT set_config('app.operator_id', ${operatorId}, true)`;
      return callback(tx);
    });
  }
}
