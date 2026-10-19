import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { ConnectionStates, type FilterQuery, type Model, Types } from "mongoose";
import { getRequestId } from "../common/observability/request-context";
import { getCurrentTraceId } from "../common/observability/tracing";
import { AUDIT_EVENT_MODEL, type AuditEvent, type AuditEventDocument } from "./audit-event.schema";
import { SYSTEM_LOG_MODEL, type SystemLog, type SystemLogDocument } from "./system-log.schema";

export type AuditEventInput = Omit<AuditEvent, "schemaVersion" | "createdAt"> & {
  createdAt?: Date;
};

export type SystemLogInput = Omit<SystemLog, "schemaVersion" | "createdAt"> & {
  createdAt?: Date;
};

// Dưới mức này một lần ghi Mongo lúc bình thường cũng khó kịp — coi như hết giờ.
const MIN_BOUNDED_WRITE_MS = 200;

/** Trường audit trả cho màn lịch sử — không lộ `requestId`, `traceId`, `reason`… của bản ghi gốc. */
export type AuditHistoryItem = Pick<AuditEvent, "action" | "actorId" | "createdAt" | "before" | "after">;

/** Bộ lọc tra cứu audit toàn hệ thống của Admin (UC-30). Mọi điều kiện ghép AND; trường bỏ trống = không lọc. */
export type AuditSearchFilter = {
  from?: Date;
  /** Mốc cuối, không gồm. */
  to?: Date;
  /** `actorRole` thuộc tập này. */
  actorRoles?: readonly string[];
  /** Chỉ sự kiện không có người thực hiện (tác vụ nền). */
  systemOnly?: boolean;
  /** `action` bắt đầu bằng một trong các tiền tố (phân hệ). */
  actionPrefixes?: readonly string[];
  result?: "SUCCESS" | "FAILURE";
  /** Ô tìm: đúng mã đối tượng HOẶC người thực hiện thuộc danh sách. */
  match?: { targetId: string; actorIds: readonly string[] };
};

/** Một audit event kèm `id` (ObjectId dạng hex) để mở chi tiết. */
export type AuditRecord = Omit<AuditEvent, "schemaVersion"> & { id: string };

/**
 * Hành động kết thúc thất bại / bị chặn theo quy ước đặt tên: `auth.login.failure`, `….delivery_failed`,
 * `auth.mfa.verification_failed`, `….rate_limited`, `auth.token.reuse_detected`, `auth.mfa.locked`.
 */
const FAILURE_ACTION = /\.(failure|[a-z_]*failed|rate_limited|reuse_detected|locked)$/;

export function isFailureAction(action: string): boolean {
  return FAILURE_ACTION.test(action);
}

/** Ghi audit có giới hạn thời gian thất bại (Mongo chậm / sập) — bản ghi KHÔNG được lưu; nơi gọi trả 503. */
export class AuditWriteError extends Error {
  constructor(cause: unknown) {
    super("Ghi audit thất bại hoặc quá thời gian.", { cause });
    this.name = "AuditWriteError";
  }
}

@Injectable()
export class AuditService {
  constructor(
    @InjectModel(AUDIT_EVENT_MODEL)
    private readonly auditEventModel: Model<AuditEventDocument>,
    @InjectModel(SYSTEM_LOG_MODEL)
    private readonly systemLogModel: Model<SystemLogDocument>
  ) {}

  /**
   * Ghi một audit event. Có `timeoutMs` (dùng khi ghi TRONG transaction Postgres): quá hạn, Mongo chưa kết nối hoặc
   * lỗi ghi → `AuditWriteError`, và bản ghi KHÔNG xuất hiện "về sau" khi transaction Postgres đã rollback. `deadline`
   * (epoch ms, `transactionDeadline`) rút ngắn giới hạn theo phần còn lại của transaction; không còn đủ → lỗi, không ghi.
   */
  async recordAuditEvent(input: AuditEventInput, options?: { timeoutMs: number; deadline?: number }): Promise<void> {
    const document = {
      ...withCorrelation(input),
      schemaVersion: 1,
      createdAt: input.createdAt ?? new Date()
    };
    if (!options) {
      await this.auditEventModel.create(document);
      return;
    }
    // Kiểm schema như `create` (sai schema là lỗi lập trình → ném nguyên, không thành 503).
    const event = new this.auditEventModel(document);
    await event.validate();
    // Chưa kết nối thì Mongoose XẾP HÀNG lệnh (tới 10s) rồi chạy khi Mongo lên lại — lúc đó Postgres có thể đã
    // rollback → dòng lịch sử "ma". Từ chối ngay thay vì xếp hàng.
    if (this.auditEventModel.db.readyState !== ConnectionStates.connected) {
      throw new AuditWriteError(new Error("Mongo audit chưa kết nối."));
    }
    // Transaction đã tiêu gần hết hạn (vd xếp hàng chờ khoá dòng): ghi lúc này có thể xong ở Mongo SAU khi Postgres đã
    // hết hạn → dòng audit "ma". Từ chối trước khi ghi.
    const timeoutMs = Math.min(options.timeoutMs, (options.deadline ?? Infinity) - Date.now());
    if (timeoutMs < MIN_BOUNDED_WRITE_MS) {
      throw new AuditWriteError(new Error("Không còn đủ thời gian trong transaction để ghi audit."));
    }
    try {
      // `create`/`save` của Mongoose bỏ qua `timeoutMS` và schema chặn `insertMany` (append-only) → ghi thẳng driver.
      // CSOT: driver thôi chờ chọn server / đọc socket VÀ gửi `maxTimeMS` để server tự huỷ lệnh quá hạn.
      await this.auditEventModel.collection.insertOne(event.toObject(), { timeoutMS: timeoutMs });
    } catch (error) {
      throw new AuditWriteError(error);
    }
  }

  /**
   * Đọc audit event của một đối tượng trong một tenant, mới nhất trước — dùng cho lịch sử hiển thị (vd lịch sử giá,
   * BR-40). Chỉ đọc các `actions` nơi gọi liệt kê và chỉ trả `AuditHistoryItem`; nơi gọi phải kiểm đối tượng thuộc
   * tenant trước (Mongo không có RLS). `operatorId: null` = đối tượng cấp Platform, chưa thuộc tenant nào (vd hồ sơ
   * đăng ký nhà xe) — chỉ đọc sự kiện không gắn tenant.
   */
  async listAuditEvents(query: {
    targetType: string;
    targetId: string;
    operatorId: string | null;
    actions: readonly string[];
    before?: Date;
    limit: number;
  }): Promise<AuditHistoryItem[]> {
    // `undefined` / chuỗi rỗng KHÔNG phải `null`: thiếu bộ lọc tenant thì Mongoose bỏ điều kiện → đọc lẫn tenant.
    if ((query.operatorId !== null && !query.operatorId) || !query.targetId || query.actions.length === 0) {
      // Bộ lọc rỗng sẽ đọc lịch sử của tenant / đối tượng khác — lỗi lập trình, không phải lỗi người dùng.
      throw new Error("listAuditEvents cần operatorId, targetId và ít nhất một action.");
    }
    return this.auditEventModel
      .find({
        targetType: query.targetType,
        targetId: query.targetId,
        // `null` khớp cả bản ghi không có trường `operatorId` (sự kiện cấp Platform).
        operatorId: query.operatorId,
        action: { $in: query.actions },
        ...(query.before ? { createdAt: { $lt: query.before } } : {}),
      })
      .select({ _id: 0, action: 1, actorId: 1, createdAt: 1, before: 1, after: 1 })
      .sort({ createdAt: -1 })
      .limit(query.limit)
      .lean<AuditHistoryItem[]>()
      .exec();
  }

  /**
   * Tra cứu audit toàn hệ thống cho Admin có quyền `audit:read` (UC-30) — mới nhất trước, trang theo
   * `(createdAt, _id)`. Không lọc tenant: CHỈ gọi từ route Admin phạm vi `any`.
   */
  async searchAuditEvents(
    filter: AuditSearchFilter,
    page: { after?: { at: Date; id: string }; limit: number },
  ): Promise<AuditRecord[]> {
    const conditions = searchConditions(filter);
    if (page.after) {
      const id = new Types.ObjectId(page.after.id);
      conditions.push({ $or: [{ createdAt: { $lt: page.after.at } }, { createdAt: page.after.at, _id: { $lt: id } }] });
    }
    const rows = await this.auditEventModel
      .find(conditions.length > 0 ? { $and: conditions } : {})
      .sort({ createdAt: -1, _id: -1 })
      .limit(page.limit)
      .lean<(AuditEvent & { _id: Types.ObjectId })[]>()
      .exec();
    return rows.map(toRecord);
  }

  async countAuditEvents(filter: AuditSearchFilter): Promise<number> {
    const conditions = searchConditions(filter);
    return this.auditEventModel.countDocuments(conditions.length > 0 ? { $and: conditions } : {}).exec();
  }

  /** Một audit event theo id; id sai dạng hoặc không có → `null`. Chỉ cho route Admin `audit:read`. */
  async findAuditEvent(id: string): Promise<AuditRecord | null> {
    if (!Types.ObjectId.isValid(id)) {
      return null;
    }
    const row = await this.auditEventModel
      .findOne({ _id: new Types.ObjectId(id) })
      .lean<AuditEvent & { _id: Types.ObjectId }>()
      .exec();
    return row ? toRecord(row) : null;
  }

  /** Chuỗi bản ghi của cùng một đối tượng, mọi tenant, mới nhất trước — chi tiết audit của Admin (UC-30 bước 6). */
  async listTargetAuditEvents(targetType: string, targetId: string, limit: number): Promise<AuditRecord[]> {
    const rows = await this.auditEventModel
      .find({ targetType, targetId })
      .sort({ createdAt: -1, _id: -1 })
      .limit(limit)
      .lean<(AuditEvent & { _id: Types.ObjectId })[]>()
      .exec();
    return rows.map(toRecord);
  }

  async recordSystemLog(input: SystemLogInput): Promise<void> {
    await this.systemLogModel.create({
      ...withCorrelation(input),
      schemaVersion: 1,
      createdAt: input.createdAt ?? new Date()
    });
  }
}

function searchConditions(filter: AuditSearchFilter): FilterQuery<AuditEvent>[] {
  const conditions: FilterQuery<AuditEvent>[] = [];
  if (filter.from || filter.to) {
    conditions.push({ createdAt: { ...(filter.from ? { $gte: filter.from } : {}), ...(filter.to ? { $lt: filter.to } : {}) } });
  }
  if (filter.actorRoles) {
    conditions.push({ actorRole: { $in: [...filter.actorRoles] } });
  }
  if (filter.systemOnly) {
    conditions.push({ actorId: { $exists: false }, actorRole: { $exists: false } });
  }
  if (filter.actionPrefixes && filter.actionPrefixes.length > 0) {
    const prefixes = filter.actionPrefixes.map((prefix) => prefix.replace(/[.*+?^${}()|[\]\\]/g, "\\$&"));
    conditions.push({ action: { $regex: `^(${prefixes.join("|")})` } });
  }
  if (filter.result === "FAILURE") {
    conditions.push({ action: { $regex: FAILURE_ACTION } });
  } else if (filter.result === "SUCCESS") {
    conditions.push({ action: { $not: FAILURE_ACTION } });
  }
  if (filter.match) {
    conditions.push({ $or: [{ targetId: filter.match.targetId }, { actorId: { $in: [...filter.match.actorIds] } }] });
  }
  return conditions;
}

function toRecord({ _id, schemaVersion: _version, ...event }: AuditEvent & { _id: Types.ObjectId }): AuditRecord {
  return { ...event, id: _id.toHexString() };
}

function withCorrelation<T extends { requestId?: string; traceId?: string }>(input: T): T {
  return {
    ...input,
    requestId: input.requestId ?? getRequestId(),
    traceId: input.traceId ?? getCurrentTraceId()
  };
}
