import { InjectQueue } from "@nestjs/bullmq";
import { Inject, Injectable, Logger } from "@nestjs/common";
import type { Queue } from "bullmq";
import { APP_CONFIG, type AppConfig } from "../config/env.config";
import { DatabaseHealthService } from "../database/database-health.service";
import { MongoHealthService } from "../database/mongo-health.service";
import { PRIVATE_STORAGE, PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import { QUEUE_NAMES } from "../queue/queue.constants";
import { RedisHealthService } from "../redis/redis-health.service";
import type { BackgroundJobs, SystemIntegrations } from "./dto/system-status.dto";

type Integration = SystemIntegrations["items"][number];
type Job = BackgroundJobs["jobs"][number];

/** Một lần kiểm tra không được giữ trang quá lâu khi dịch vụ treo. */
const CHECK_TIMEOUT_MS = 3_000;

/** Tác vụ nền đã có trong hệ thống (ADR-016 / ADR-024) — tên tiếng Việt cho trang Tác vụ nền. */
const JOB_LABELS: Record<string, string> = {
  "session-cleanup": "Dọn phiên đăng nhập hết hạn",
  "vehicle-image-cleanup": "Dọn ảnh phương tiện mồ côi",
  "application-document-cleanup": "Dọn giấy tờ hồ sơ / KYC mồ côi",
  "booking-expiry": "Hủy booking quá hạn thanh toán, trả chỗ",
  "payment-callback": "Xử lý callback thanh toán (VNPay / MoMo)",
  refund: "Hoàn tiền qua cổng thanh toán",
  "payout-generation": "Tạo kỳ chi trả nhà xe (T+3)",
  deliver: "Gửi email / push thông báo",
  sweep: "Gửi lại thông báo bị kẹt",
  "payment-reconciliation": "Đối soát thanh toán, sổ giữ hộ và kỳ chi trả",
  "dispute-overdue": "Leo thang tranh chấp quá hạn phản hồi",
  "loyalty-maintenance": "VXN Plus: tích / thu hồi / hết hạn điểm",
  "foundation.smoke": "Kiểm tra hàng đợi (smoke)",
};

/**
 * Trạng thái vận hành CHỈ ĐỌC cho trang Tích hợp & hệ thống (Figma ADM-16a / 16b; Khanh 16/10/2026: chỉ đọc, không chế độ
 * bảo trì / chạy lại). Kiểm tra kết nối thật cho Postgres, Redis, Mongo audit, hàng đợi và kho lưu trữ; dịch vụ gửi đi
 * (email, bản đồ) chỉ đọc cấu hình — không gửi / gọi thử. Không bao giờ trả khóa / bí mật.
 */
@Injectable()
export class SystemStatusService {
  private readonly logger = new Logger(SystemStatusService.name);
  private readonly queues: Queue[];

  constructor(
    @Inject(APP_CONFIG) private readonly config: AppConfig,
    @Inject(DatabaseHealthService) private readonly postgres: DatabaseHealthService,
    @Inject(MongoHealthService) private readonly mongo: MongoHealthService,
    @Inject(RedisHealthService) private readonly redis: RedisHealthService,
    @Inject(PUBLIC_STORAGE) private readonly publicStorage: StorageProvider,
    @Inject(PRIVATE_STORAGE) private readonly privateStorage: StorageProvider | null,
    @InjectQueue(QUEUE_NAMES.foundation) foundation: Queue,
    @InjectQueue(QUEUE_NAMES.sessionMaintenance) sessions: Queue,
    @InjectQueue(QUEUE_NAMES.storageMaintenance) storage: Queue,
    @InjectQueue(QUEUE_NAMES.kycMaintenance) kyc: Queue,
    @InjectQueue(QUEUE_NAMES.bookingMaintenance) bookings: Queue,
    @InjectQueue(QUEUE_NAMES.paymentCallbacks) payments: Queue,
    @InjectQueue(QUEUE_NAMES.refundProcessing) refunds: Queue,
    @InjectQueue(QUEUE_NAMES.payoutMaintenance) payouts: Queue,
    @InjectQueue(QUEUE_NAMES.notifications) notifications: Queue,
    @InjectQueue(QUEUE_NAMES.paymentReconciliation) reconciliation: Queue,
    @InjectQueue(QUEUE_NAMES.disputeMaintenance) disputes: Queue,
    @InjectQueue(QUEUE_NAMES.loyaltyMaintenance) loyalty: Queue,
  ) {
    this.queues = [sessions, storage, kyc, bookings, payments, refunds, payouts, notifications, reconciliation, disputes, loyalty, foundation];
  }

  async integrations(): Promise<SystemIntegrations> {
    const config = this.config;
    const r2 = Boolean(config.R2_ACCOUNT_ID && config.R2_ACCESS_KEY_ID && config.R2_SECRET_ACCESS_KEY);
    const [postgres, redis, mongo, queues, publicStore, privateStore] = await Promise.all([
      this.probe("postgres", "PostgreSQL", "Cơ sở dữ liệu nghiệp vụ", () => this.postgres.check(), "Đọc / ghi dữ liệu nghiệp vụ (ADR-011)."),
      this.probe("redis", "Redis", "Bộ nhớ đệm, giữ chỗ, hàng đợi", () => this.redis.check(), "Giữ chỗ, giới hạn tần suất, BullMQ (ADR-015)."),
      this.probe("mongo", "MongoDB", "Nhật ký audit", () => this.mongo.check(), "Cụm riêng, chỉ ghi thêm (ADR-011)."),
      this.probe("queues", "BullMQ", "Hàng đợi tác vụ nền", () => Promise.all(this.queues.map((queue) => queue.getJobCounts("waiting"))), "Tác vụ chạy ở worker riêng (ADR-024)."),
      this.probe(
        "storage-public",
        r2 && config.R2_PUBLIC_BUCKET ? "Cloudflare R2 · công khai" : "Kho công khai (ổ đĩa)",
        "Ảnh xe, ảnh bài viết",
        () => this.publicStorage.head("healthcheck/ping"),
        r2 && config.R2_PUBLIC_BUCKET ? "Bucket công khai + CDN (ADR-018)." : "Bản dev lưu ổ đĩa — chưa cấu hình R2.",
        !(r2 && config.R2_PUBLIC_BUCKET),
      ),
      this.privateStorage
        ? this.probe(
            "storage-private",
            r2 && config.R2_PRIVATE_BUCKET ? "Cloudflare R2 · riêng tư" : "Kho riêng tư (ổ đĩa)",
            "Giấy tờ KYC",
            () => this.privateStorage!.head("healthcheck/ping"),
            r2 && config.R2_PRIVATE_BUCKET ? "URL có hạn 5 phút + audit (ADR-018)." : "Bản dev lưu ổ đĩa — dữ liệu KYC thật chờ OQ-21.",
            !(r2 && config.R2_PRIVATE_BUCKET),
          )
        : Promise.resolve<Integration>({
            key: "storage-private",
            name: "Kho riêng tư",
            category: "Giấy tờ KYC",
            status: "NOT_CONFIGURED",
            latencyMs: null,
            detail: "Chưa cấu hình — tải / xem giấy tờ trả 503 (OQ-21).",
          }),
    ]);
    const configured = (key: string, name: string, category: string, value: string | undefined, yes: string, no: string, localFallback = true): Integration => ({
      key,
      name,
      category,
      status: value ? "CONFIGURED" : config.NODE_ENV === "production" || !localFallback ? "NOT_CONFIGURED" : "LOCAL",
      latencyMs: null,
      detail: value ? yes : no,
    });
    return {
      checkedAt: new Date().toISOString(),
      environment: config.NODE_ENV,
      items: [
        postgres,
        redis,
        mongo,
        queues,
        configured("email", "Resend", "Email", config.RESEND_API_KEY, "Đã cấu hình khóa gửi email (không gửi thử).", "Chưa cấu hình — email chỉ ghi log, không gửi (bản dev)."),
        configured("goong", "Goong", "Bản đồ và định tuyến", config.GOONG_API_KEY, "Đã cấu hình khóa (không gọi thử).", "Chưa cấu hình — khoảng cách tuyến ước lượng đường chim bay."),
        publicStore,
        privateStore,
        configured("vnpay", "VNPay", "Cổng thanh toán", config.VNPAY_TMN_CODE && config.VNPAY_HASH_SECRET, "Đã cấu hình adapter VNPay (không giao dịch thử).", "Chưa cấu hình khóa — dev dùng cổng giả lập, production chưa sẵn sàng (OQ-22)."),
        configured("momo", "MoMo", "Cổng thanh toán", config.MOMO_PARTNER_CODE && config.MOMO_ACCESS_KEY && config.MOMO_SECRET_KEY, "Đã cấu hình adapter MoMo (không giao dịch thử).", "Chưa cấu hình khóa — dev dùng cổng giả lập, production chưa sẵn sàng (OQ-22)."),
        configured("push", "FCM / APNs", "Thông báo đẩy", (config.FCM_PROJECT_ID && config.FCM_CLIENT_EMAIL && config.FCM_PRIVATE_KEY) || (config.APNS_TEAM_ID && config.APNS_KEY_ID && config.APNS_PRIVATE_KEY && config.APNS_TOPIC) || undefined, "Đã cấu hình adapter push server (không gửi thử).", "Chưa cấu hình khóa FCM / APNs; thông báo email vẫn hoạt động.", false),
        { key: "sms", name: "SMS", category: "Tin nhắn", status: "DISABLED", latencyMs: null, detail: "Tắt ở v1; mã xác minh và thông báo gửi qua email (ADR-020)." },
      ],
    };
  }

  /** Lần chạy gần nhất của từng tác vụ + lịch kế tiếp, đọc từ BullMQ (job xong giữ 24 giờ, lỗi giữ 7 ngày). */
  async backgroundJobs(): Promise<BackgroundJobs> {
    try {
      return await withTimeout(this.readJobs(), CHECK_TIMEOUT_MS * 2);
    } catch (error) {
      this.logger.warn({ event: "system.jobs.unavailable", error });
      return { checkedAt: new Date().toISOString(), available: false, jobs: [], queues: [] };
    }
  }

  private async readJobs(): Promise<BackgroundJobs> {
    const jobs: Job[] = [];
    const queues: BackgroundJobs["queues"] = [];
    for (const queue of this.queues) {
      const [counts, schedulers, active, completed, failed] = await Promise.all([
        queue.getJobCounts("waiting", "active", "delayed", "failed"),
        queue.getJobSchedulers(0, 50),
        queue.getJobs(["active"], 0, 49),
        queue.getJobs(["completed"], 0, 99),
        queue.getJobs(["failed"], 0, 99),
      ]);
      // Trạng thái lấy theo danh sách chứa job (job xong sau vài lần thử vẫn có thể còn `failedReason` cũ).
      const recent = [
        ...active.map((job) => ({ job, state: "active" as const })),
        ...completed.map((job) => ({ job, state: "completed" as const })),
        ...failed.map((job) => ({ job, state: "failed" as const })),
      ];
      queues.push({
        name: queue.name,
        waiting: counts.waiting ?? 0,
        active: counts.active ?? 0,
        delayed: counts.delayed ?? 0,
        failed: counts.failed ?? 0,
      });
      const names = new Set([...schedulers.map((scheduler) => scheduler.name), ...recent.map((run) => run.job.name)]);
      for (const name of names) {
        const scheduler = schedulers.find((item) => item.name === name);
        const runs = recent
          .filter((run) => run.job.name === name)
          .map((run) => ({ ...run, at: run.job.finishedOn ?? run.job.processedOn ?? run.job.timestamp }))
          .sort((a, b) => b.at - a.at);
        const last = runs[0];
        jobs.push({
          queue: queue.name,
          name,
          label: JOB_LABELS[name] ?? name,
          schedule: scheduler?.pattern ?? null,
          nextRunAt: scheduler?.next ? new Date(scheduler.next).toISOString() : null,
          lastRun: last
            ? {
                state: last.state,
                at: new Date(last.at).toISOString(),
                processed: last.state === "completed" ? processedOf(last.job.returnvalue) : null,
                error: last.state === "failed" ? (last.job.failedReason || "Lỗi không rõ").slice(0, 200) : null,
                attempts: last.job.attemptsMade,
              }
            : null,
          failedCount: runs.filter((run) => run.state === "failed").length,
        });
      }
    }
    return { checkedAt: new Date().toISOString(), available: true, jobs, queues };
  }

  private async probe(
    key: string,
    name: string,
    category: string,
    check: () => Promise<unknown>,
    detail: string,
    local = false,
  ): Promise<Integration> {
    const started = Date.now();
    try {
      await withTimeout(check(), CHECK_TIMEOUT_MS);
      return { key, name, category, status: local ? "LOCAL" : "UP", latencyMs: Date.now() - started, detail };
    } catch (error) {
      this.logger.warn({ event: "system.integration.down", key, error });
      return { key, name, category, status: "DOWN", latencyMs: Date.now() - started, detail: "Không kết nối được hoặc quá 3 giây." };
    }
  }
}

function withTimeout<T>(work: Promise<T>, ms: number): Promise<T> {
  let timer: NodeJS.Timeout | undefined;
  return Promise.race([
    work,
    new Promise<never>((_, reject) => {
      timer = setTimeout(() => reject(new Error("timeout")), ms);
    }),
  ]).finally(() => clearTimeout(timer));
}

/** Số bản ghi tác vụ trả về (`{ deleted: 12 }`, `{ revoked: 3 }`…); không có → `null`. */
function processedOf(value: unknown): number | null {
  if (typeof value === "number" && Number.isInteger(value)) {
    return value;
  }
  if (value && typeof value === "object") {
    const first = Object.values(value).find((item) => typeof item === "number" && Number.isInteger(item));
    return typeof first === "number" ? first : null;
  }
  return null;
}
