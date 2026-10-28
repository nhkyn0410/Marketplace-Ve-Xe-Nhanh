import {
  Inject,
  Injectable,
  OnModuleDestroy,
  OnModuleInit,
} from "@nestjs/common";
import { PrismaPg } from "@prisma/adapter-pg";
import { Prisma, PrismaClient } from "../generated/prisma/client";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import {
  type DbScope,
  platformScope,
  systemScope,
  tenantScope,
} from "./db-scope";

export type { DbScope } from "./db-scope";

export type DbTransaction = Prisma.TransactionClient;

// Giới hạn transaction tương tác (ghi tường minh để hạn chót ghi audit bên dưới tính đúng). Chờ lấy kết nối ≤10s (mặc
// định Prisma 2s): instance Render free vừa thức dậy nhận cả loạt request của một trang Admin trong khi pool còn phải mở
// kết nối mới qua Supabase pooler — 2s không đủ, request lỗi P2028 (Sentry NODE-NESTJS-4/5, 20/10/2026).
const TRANSACTION_MAX_WAIT_MS = 10_000;
const TRANSACTION_TIMEOUT_MS = 5_000;
// pg mặc định đóng kết nối rảnh sau 10s (Prisma 6 giữ 300s) → mỗi lần chuyển trang sau 10s lại mở kết nối TLS mới.
const POOL_IDLE_TIMEOUT_MS = 300_000;
// Chừa cho phần còn lại sau lệnh ghi audit (đọc lại + COMMIT) — ghi audit phải xong trước mốc này.
const TRANSACTION_COMMIT_MARGIN_MS = 500;

/**
 * Hạn chót (epoch ms) để một lệnh ngoài Postgres (audit Mongo) chạy xong trong transaction bắt đầu lúc `startedAt`:
 * request phải xếp hàng chờ khoá dòng đã tiêu một phần hạn 5s, nên ghi audit không được dùng trọn 2s cố định.
 */
export function transactionDeadline(startedAt: number): number {
  return startedAt + TRANSACTION_TIMEOUT_MS - TRANSACTION_COMMIT_MARGIN_MS;
}

/**
 * Bảng đã bật + ÉP RLS (migration `add_tenant_rls`). Thêm bảng tenant mới (vehicles, bookings...) thì
 * thêm tên vào đây — kiểm tra lúc khởi động (`rlsProblems`) sẽ đòi bảng đó có FORCE RLS.
 */
export const RLS_TABLES = [
  "incident_reports",
  "reconciliation_records",
  "user_vouchers",
  "journey_logs",
  "notification_preferences",
  "push_devices",
  "notification_push_receipts",
  "operator_profiles",
  "operator_accounts",
  "sales_offices",
  "sales_office_assignments",
  "employee_accounts",
  "operator_login_names",
  "auth_sessions",
  "mfa_credentials",
  "mfa_backup_codes",
  // Catalog Platform (TASK-CAT-001): không tenant, nhưng RLS chặn ghi ngoài platform/system.
  "provinces",
  "wards",
  "legacy_administrative_mappings",
  "stop_points_catalog",
  "vehicle_types",
  "amenities",
  // Transport — Vehicle (TASK-TRN-001): tenant_isolation theo operator_id.
  "seat_maps",
  "seats",
  "vehicles",
  "vehicle_amenities",
  // Transport — Route & StopPoint (TASK-TRN-002).
  "stop_points",
  "stop_point_proposals",
  "routes",
  "route_stops",
  // Trip & Inventory (TASK-TRN-003).
  "trips",
  "trip_stops",
  "trip_seats",
  // Fare (TASK-TRN-005).
  "fares",
  "fare_rules",
  "vehicle_images",
  // Operator onboarding (TASK-OPR-001): dữ liệu cấp Platform, chỉ scope platform / system.
  "operator_applications",
  "operator_application_documents",
  "operator_application_access_tokens",
  // Content (TASK-CNT-001): ai cũng đọc, chỉ platform / system ghi.
  "article_categories",
  "articles",
  // Hồ sơ & KYC sau duyệt (TASK-OPR-001b): tenant_isolation; bank_accounts tenant chỉ gửi yêu cầu PENDING.
  "kyc_documents",
  "bank_accounts",
  // Chính sách nền tảng (TASK-ADM-001): ai cũng đọc (hoa hồng: tenant chỉ thấy của mình), chỉ platform / system ghi.
  "policy_versions",
  "commission_rules",
  "fare_bands",
  // Lịch chuyến lặp lại (TASK-TRN-007): tenant_isolation.
  "trip_schedules",
  // Phân công nhân viên cho chuyến (TASK-EMP-001): tenant_isolation.
  "employee_assignments",
  // Nội dung công khai (TASK-ADM-003): ai cũng đọc, chỉ platform / system ghi.
  "content_pages",
  // Booking (TASK-BTP-002): tenant_isolation.
  "bookings",
  "counter_receipts",
  "counter_commission_receivables",
  "counter_commission_settlements",
  "passenger_infos",
  "booking_status_histories",
  // Payment (TASK-BTP-003): tenant_isolation.
  "payments",
  "payment_status_histories",
  // Ticket (TASK-BTP-004): tenant_isolation.
  "tickets",
  "ticket_status_histories",
  // Refund (TASK-BTP-005): tenant_isolation.
  "refunds",
  "refund_status_histories",
  // Escrow + payout (TASK-BTP-006): tenant_isolation; sổ escrow chỉ ghi thêm.
  "escrow_ledgers",
  "payouts",
  "payout_items",
  "payout_status_histories",
  // Thông báo (TASK-NSR-001) + lịch sử đổi chuyến đã bán vé (TASK-TRN-008): tenant_isolation.
  "notifications",
  "notification_deliveries",
  "trip_changes",
  // Khiếu nại / tranh chấp / đánh giá (TASK-TRUST-001): tenant_isolation.
  "support_tickets",
  "support_messages",
  "dispute_cases",
  "dispute_events",
  "support_attachments",
  "reviews",
  // Khuyến mãi (TASK-PROM-001): nhà xe đọc khuyến mãi nền tảng, ghi của mình; quyền + lượt dùng theo tenant.
  "promotion_permissions",
  "promotions",
  "promotion_participations",
  "promotion_redemptions",
  // VXN Plus (TASK-LOY-001): chỉ platform / system.
  "loyalty_accounts",
  "loyalty_point_transactions",
  "user_vouchers",
] as const;

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor(@Inject(APP_CONFIG) private readonly config: AppConfig) {
    const connectionString = config.DATABASE_URL;
    if (!connectionString) {
      throw new Error("DATABASE_URL is required to initialize PrismaService.");
    }

    // Prisma 7: dùng driver adapter (pg) thay query-engine binary → hợp distroless (không libssl).
    super({ adapter: new PrismaPg({ connectionString, idleTimeoutMillis: POOL_IDLE_TIMEOUT_MS }) });
  }

  async onModuleInit(): Promise<void> {
    await this.$connect();
    if (this.config.NODE_ENV !== "production") {
      return;
    }
    // Production: RLS không có hiệu lực thì mọi policy chỉ là trang trí — thà không khởi động còn hơn
    // chạy "an toàn giả". Ca hay gặp: DATABASE_URL trên Render vẫn là owner (DB-PRIN-01).
    const problems = await this.rlsProblems();
    if (problems.length > 0) {
      throw new Error(
        `RLS không có hiệu lực — từ chối khởi động: ${problems.join("; ")}`,
      );
    }
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
  }

  /**
   * Những lý do khiến RLS không chặn được gì với kết nối hiện tại. Rỗng = ổn.
   * Superuser/BYPASSRLS bỏ qua mọi policy; owner (hoặc thành viên role owner) thì tắt được RLS.
   */
  async rlsProblems(): Promise<string[]> {
    const tables = [...RLS_TABLES];
    const [role] = await this.$queryRaw<
      {
        user: string;
        rolsuper: boolean;
        rolbypassrls: boolean;
        owns: boolean;
      }[]
    >`
      SELECT current_user AS "user", r.rolsuper, r.rolbypassrls,
        EXISTS (
          SELECT 1 FROM pg_tables t
          WHERE t.schemaname = current_schema() AND t.tablename = ANY(${tables}::text[])
            AND pg_has_role(current_user, t.tableowner, 'USAGE')
        ) AS owns
      FROM pg_roles r WHERE r.rolname = current_user`;
    const forced = await this.$queryRaw<{ relname: string }[]>`
      SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE n.nspname = current_schema() AND c.relname = ANY(${tables}::text[])
        AND c.relrowsecurity AND c.relforcerowsecurity`;

    const problems: string[] = [];
    if (!role) {
      return ["không đọc được thông tin role hiện tại"];
    }
    if (role.rolsuper) problems.push(`role "${role.user}" là SUPERUSER`);
    if (role.rolbypassrls) problems.push(`role "${role.user}" có BYPASSRLS`);
    if (role.owns)
      problems.push(
        `role "${role.user}" là owner (hoặc thành viên role owner) của bảng tenant`,
      );
    const forcedNames = new Set(forced.map((row) => row.relname));
    const missing = tables.filter((table) => !forcedNames.has(table));
    if (missing.length > 0)
      problems.push(`chưa ENABLE+FORCE RLS: ${missing.join(", ")}`);
    return problems;
  }

  /**
   * Chạy `work` trong MỘT transaction đã gắn ngữ cảnh RLS. `set_config(..., true)` là
   * transaction-local: hết transaction là mất, kết nối trả về pool không mang ngữ cảnh sang
   * request khác. Chỉ có tác dụng khi app chạy bằng role KHÔNG superuser/BYPASSRLS/owner
   * (`scripts/db-app-role.mjs`, DB-PRIN-01).
   *
   * RLS là lớp chặn cuối, KHÔNG thay bộ lọc: policy không dùng được index, query vẫn phải lọc
   * `operator_id` tường minh. Module nghiệp vụ chỉ gọi `withScope(authz.db, ...)` với scope guard trao.
   * Chi phí: mỗi lần gọi là BEGIN + set_config + query + COMMIT, và chịu giới hạn transaction tương
   * tác của Prisma (chờ ≤10s, chạy ≤5s) — gom query vào một lần gọi thay vì gọi lẻ từng câu.
   */
  async withScope<T>(
    scope: DbScope,
    work: (tx: DbTransaction) => Promise<T>,
  ): Promise<T> {
    const operatorId = scope.kind === "tenant" ? scope.operatorId : "";
    return this.$transaction(
      async (tx) => {
        await tx.$executeRaw`SELECT set_config('app.scope', ${scope.kind}, true), set_config('app.operator_id', ${operatorId}, true)`;
        return work(tx);
      },
      { maxWait: TRANSACTION_MAX_WAIT_MS, timeout: TRANSACTION_TIMEOUT_MS },
    );
  }

  async withTenant<T>(
    operatorId: string,
    work: (tx: DbTransaction) => Promise<T>,
  ): Promise<T> {
    return this.withScope(tenantScope(operatorId), work);
  }

  async withPlatform<T>(work: (tx: DbTransaction) => Promise<T>): Promise<T> {
    return this.withScope(platformScope(), work);
  }

  /** Vượt ranh giới tenant cho auth/session/cron. ESLint chỉ cho gọi trong `iam/auth`, `iam/session`. */
  async withSystem<T>(work: (tx: DbTransaction) => Promise<T>): Promise<T> {
    return this.withScope(systemScope(), work);
  }
}
