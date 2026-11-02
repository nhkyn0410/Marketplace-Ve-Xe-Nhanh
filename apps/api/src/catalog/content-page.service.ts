import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { AuditService, AuditWriteError } from "../audit/audit.service";
import { decodeTimeCursor, encodeTimeCursor } from "../common/time-cursor";
import type { DbScope } from "../database/db-scope";
import { PrismaService, transactionDeadline, type DbTransaction } from "../database/prisma.service";
import { ContentPageStatus, ContentPageType, type ContentPlacement } from "../database/prisma.types";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { VerifiedAccessToken } from "../iam/auth/token.service";
import type { Authorization } from "../iam/role/authorization";
import { isPrismaUniqueConflict } from "../iam/user/account.errors";
import { detectImageType, IMAGE_SIGNATURE_BYTES, MAX_VEHICLE_IMAGE_BYTES } from "../vehicle/vehicle-image-format";
import {
  catalogAuditUnavailable,
  contentImageInvalid,
  contentPageNotFound,
  contentPageSlugConflict,
  contentPageStateInvalid,
  contentPageTypeImmutable,
  contentStorageUnavailable,
} from "./catalog.errors";
import { contentImageKey, contentTypeOfContentKey } from "./content-page-image-format";
import type {
  ContentImageUploadInput,
  ContentImageUploadResponse,
  ContentPageDetail,
  ContentPageInput,
  ContentPageListQuery,
  ContentPagePage,
  ContentPageSummary,
  PublicContentItem,
  PublicContentList,
} from "./dto/content-page.dto";

type Actor = Pick<VerifiedAccessToken, "sub" | "role">;

const AUDIT_TIMEOUT_MS = 2_000;
/** URL tải ảnh có hiệu lực 5 phút (như ảnh xe / ảnh bài viết, ADR-018). */
const UPLOAD_URL_TTL_SECONDS = 300;
/** Số mục công khai tối đa mỗi lần đọc — banner / FAQ / trang tĩnh của nền tảng chỉ vài chục. */
const PUBLIC_LIMIT = 100;
const AUDIT_TARGET = "content_page";

const SUMMARY_SELECT = {
  id: true,
  type: true,
  placement: true,
  title: true,
  slug: true,
  status: true,
  displayOrder: true,
  imageKey: true,
  updatedAt: true,
} as const;
const DETAIL_SELECT = {
  ...SUMMARY_SELECT,
  bodyMarkdown: true,
  linkUrl: true,
  publishedAt: true,
  createdAt: true,
  updatedBy: true,
} as const;

/**
 * Nội dung công khai do Admin quản lý — banner trang chủ, câu hỏi thường gặp, trang tĩnh chân trang (TASK-ADM-003; FR-ADM-13,
 * UC-28; Figma ADM-10d — thiết kế chờ Khanh duyệt). Admin: scope DB `platform`, mọi thay đổi ghi audit TRONG transaction
 * (lỗi → 503, không lưu gì). API công khai chỉ trả mục đang hiển thị. Nội dung lưu Markdown nguyên văn — nơi hiển thị
 * không render HTML thô.
 */
@Injectable()
export class ContentPageService {
  private readonly logger = new Logger(ContentPageService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(AuditService) private readonly audit: AuditService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
  ) {}

  // ── Admin ───────────────────────────────────────────────────────────────────────────────────────────────

  /** Mới sửa trước; trang theo `(updatedAt, id)`, kèm tổng số khớp bộ lọc. */
  async list(authz: Authorization, query: ContentPageListQuery): Promise<ContentPagePage> {
    return this.prisma.withScope(platformDb(authz), async (tx) => {
      const literal = query.q?.replace(/[\\%_]/g, "\\$&");
      const where = {
        type: query.type,
        status: query.status,
        ...(literal ? { title: { contains: literal, mode: "insensitive" as const } } : {}),
      };
      const after = query.cursor ? decodeTimeCursor(query.cursor) : null;
      if (after && Number.isNaN(after.at.getTime())) {
        return { items: [], nextCursor: null, total: await tx.contentPage.count({ where }) };
      }
      const rows = await tx.contentPage.findMany({
        where: {
          AND: [where, after ? { OR: [{ updatedAt: { lt: after.at } }, { updatedAt: after.at, id: { lt: after.id } }] } : {}],
        },
        orderBy: [{ updatedAt: "desc" }, { id: "desc" }],
        take: query.limit + 1,
        select: SUMMARY_SELECT,
      });
      const kept = rows.slice(0, query.limit);
      const last = kept.at(-1);
      return {
        items: kept.map((row) => this.toSummary(row)),
        nextCursor: rows.length > query.limit && last ? encodeTimeCursor(last.updatedAt, last.id) : null,
        total: await tx.contentPage.count({ where }),
      };
    });
  }

  async get(authz: Authorization, id: string): Promise<ContentPageDetail> {
    return this.prisma.withScope(platformDb(authz), (tx) => this.detail(tx, id));
  }

  /** Tạo ở trạng thái bản nháp. */
  async create(authz: Authorization, actor: Actor, input: ContentPageInput): Promise<ContentPageDetail> {
    if (input.imageKey) {
      await this.inspectImage(input.imageKey);
    }
    return this.write(authz, async (tx, deadline) => {
      const row = await tx.contentPage.create({
        data: { ...input, createdBy: actor.sub, updatedBy: actor.sub },
        select: { id: true },
      });
      await this.recordAudit(deadline, actor, "content_page.create", row.id, null, snapshot(input));
      return this.detail(tx, row.id);
    });
  }

  /** Thay toàn bộ nội dung (mọi trạng thái — mục đang hiển thị đổi ngay ngoài trang công khai); không đổi loại. */
  async update(authz: Authorization, actor: Actor, id: string, input: ContentPageInput): Promise<ContentPageDetail> {
    const current = await this.prisma.withScope(platformDb(authz), (tx) =>
      tx.contentPage.findUnique({ where: { id }, select: { type: true, imageKey: true } }),
    );
    if (!current) {
      throw contentPageNotFound();
    }
    if (current.type !== input.type) {
      throw contentPageTypeImmutable();
    }
    if (input.imageKey && input.imageKey !== current.imageKey) {
      await this.inspectImage(input.imageKey);
    }
    return this.write(authz, async (tx, deadline) => {
      const before = await tx.contentPage.findUnique({ where: { id }, select: AUDITED_FIELDS });
      if (!before) {
        throw contentPageNotFound();
      }
      await tx.contentPage.update({ where: { id }, data: { ...input, updatedBy: actor.sub } });
      await this.recordAudit(deadline, actor, "content_page.update", id, snapshot(before), snapshot(input));
      return this.detail(tx, id);
    });
  }

  /** Hiển thị (`PUBLISHED`) / ẩn về bản nháp (`DRAFT`); khoá dòng để hai lần đổi cùng lúc chỉ một lần thành công. */
  async setStatus(authz: Authorization, actor: Actor, id: string, status: ContentPageStatus): Promise<ContentPageDetail> {
    return this.write(authz, async (tx, deadline) => {
      const [row] = await tx.$queryRaw<{ status: ContentPageStatus; title: string }[]>`
        SELECT status::text AS "status", title FROM content_pages WHERE id = ${id} FOR NO KEY UPDATE`;
      if (!row) {
        throw contentPageNotFound();
      }
      if (row.status === status) {
        throw contentPageStateInvalid();
      }
      await tx.contentPage.update({
        where: { id },
        data: { status, publishedAt: status === ContentPageStatus.PUBLISHED ? new Date() : null, updatedBy: actor.sub },
      });
      await this.recordAudit(
        deadline,
        actor,
        status === ContentPageStatus.PUBLISHED ? "content_page.publish" : "content_page.unpublish",
        id,
        { status: row.status, title: row.title },
        { status, title: row.title },
      );
      return this.detail(tx, id);
    });
  }

  /** Cấp URL tải MỘT ảnh banner lên kho công khai; khóa do server sinh. */
  async createImageUploadUrl(input: ContentImageUploadInput): Promise<ContentImageUploadResponse> {
    const objectKey = contentImageKey(randomUUID(), input.contentType);
    const target = await this.callStorage(() =>
      this.storage.createUploadUrl({
        key: objectKey,
        contentType: input.contentType,
        sizeBytes: input.sizeBytes,
        expiresInSeconds: UPLOAD_URL_TTL_SECONDS,
      }),
    );
    return {
      uploadUrl: target.uploadUrl,
      objectKey,
      publicUrl: this.storage.publicUrl(objectKey),
      expiresAt: target.expiresAt.toISOString(),
    };
  }

  // ── Công khai ───────────────────────────────────────────────────────────────────────────────────────────

  /** Mục đang hiển thị theo loại (+ vị trí), theo thứ tự hiển thị. */
  async listPublished(type: ContentPageType, placement: ContentPlacement | undefined): Promise<PublicContentList> {
    const rows = await this.prisma.contentPage.findMany({
      where: { type, placement, status: ContentPageStatus.PUBLISHED },
      orderBy: [{ placement: "asc" }, { displayOrder: "asc" }, { title: "asc" }],
      take: PUBLIC_LIMIT,
      select: PUBLIC_SELECT,
    });
    return { items: rows.map((row) => this.toPublic(row)) };
  }

  /** Trang tĩnh đang hiển thị theo đường dẫn; nháp / không có → 404 như nhau. */
  async getPublishedPage(slug: string): Promise<PublicContentItem> {
    const row = await this.prisma.contentPage.findFirst({
      where: { slug, type: ContentPageType.PAGE, status: ContentPageStatus.PUBLISHED },
      select: PUBLIC_SELECT,
    });
    if (!row) {
      throw contentPageNotFound();
    }
    return this.toPublic(row);
  }

  // ── Nội bộ ──────────────────────────────────────────────────────────────────────────────────────────────

  private async detail(tx: DbTransaction, id: string): Promise<ContentPageDetail> {
    const row = await tx.contentPage.findUnique({ where: { id }, select: DETAIL_SELECT });
    if (!row) {
      throw contentPageNotFound();
    }
    const editor = await tx.platformAccount.findUnique({ where: { id: row.updatedBy }, select: { username: true } });
    return {
      ...this.toSummary(row),
      bodyMarkdown: row.bodyMarkdown,
      imageKey: row.imageKey,
      linkUrl: row.linkUrl,
      publishedAt: row.publishedAt?.toISOString() ?? null,
      createdAt: row.createdAt.toISOString(),
      updatedByName: editor ? `platform/${editor.username}` : null,
    };
  }

  private toSummary(row: {
    id: string;
    type: ContentPageType;
    placement: ContentPlacement;
    title: string;
    slug: string | null;
    status: ContentPageStatus;
    displayOrder: number;
    imageKey: string | null;
    updatedAt: Date;
  }): ContentPageSummary {
    const { imageKey, updatedAt, ...rest } = row;
    return {
      ...rest,
      imageUrl: imageKey ? this.storage.publicUrl(imageKey) : null,
      updatedAt: updatedAt.toISOString(),
    };
  }

  private toPublic(row: {
    id: string;
    type: ContentPageType;
    placement: ContentPlacement;
    title: string;
    slug: string | null;
    bodyMarkdown: string;
    imageKey: string | null;
    linkUrl: string | null;
    displayOrder: number;
    updatedAt: Date;
  }): PublicContentItem {
    const { imageKey, updatedAt, ...rest } = row;
    return { ...rest, imageUrl: imageKey ? this.storage.publicUrl(imageKey) : null, updatedAt: updatedAt.toISOString() };
  }

  /** Ảnh banner phải là object do server cấp khóa, đã tải lên, đúng loại, ≤ 5 MB và đúng chữ ký định dạng. */
  private async inspectImage(objectKey: string): Promise<void> {
    const expected = contentTypeOfContentKey(objectKey);
    if (!expected) {
      throw contentImageInvalid();
    }
    const object = await this.callStorage(() => this.storage.head(objectKey));
    if (!object || object.sizeBytes < 1 || object.sizeBytes > MAX_VEHICLE_IMAGE_BYTES || object.contentType !== expected) {
      throw contentImageInvalid();
    }
    const start = await this.callStorage(() => this.storage.readStart(objectKey, IMAGE_SIGNATURE_BYTES));
    if (detectImageType(start) !== expected) {
      throw contentImageInvalid();
    }
  }

  private async callStorage<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "content_page.image.storage_failed", error });
      throw contentStorageUnavailable();
    }
  }

  /** Transaction scope platform; trùng đường dẫn → 409; audit lỗi / hết hạn transaction → 503, không lưu gì. */
  private async write<T>(authz: Authorization, work: (tx: DbTransaction, deadline: number) => Promise<T>): Promise<T> {
    try {
      return await this.prisma.withScope(platformDb(authz), (tx) => work(tx, transactionDeadline(Date.now())));
    } catch (error) {
      if (isPrismaUniqueConflict(error)) {
        throw contentPageSlugConflict();
      }
      if (error instanceof AuditWriteError || (error as { code?: unknown } | null)?.code === "P2028") {
        throw catalogAuditUnavailable();
      }
      throw error;
    }
  }

  private recordAudit(
    deadline: number,
    actor: Actor,
    action: string,
    targetId: string,
    before: Record<string, unknown> | null,
    after: Record<string, unknown>,
  ): Promise<void> {
    return this.audit.recordAuditEvent(
      { actorId: actor.sub, actorRole: actor.role, action, targetType: AUDIT_TARGET, targetId, before, after },
      { timeoutMs: AUDIT_TIMEOUT_MS, deadline },
    );
  }
}

const PUBLIC_SELECT = {
  id: true,
  type: true,
  placement: true,
  title: true,
  slug: true,
  bodyMarkdown: true,
  imageKey: true,
  linkUrl: true,
  displayOrder: true,
  updatedAt: true,
} as const;

/** Trường ghi vào audit trước / sau — nội dung dài chỉ ghi độ dài. */
const AUDITED_FIELDS = {
  type: true,
  placement: true,
  title: true,
  slug: true,
  bodyMarkdown: true,
  imageKey: true,
  linkUrl: true,
  displayOrder: true,
} as const;

function snapshot(input: {
  type: ContentPageType;
  placement: ContentPlacement;
  title: string;
  slug: string | null;
  bodyMarkdown: string;
  imageKey: string | null;
  linkUrl: string | null;
  displayOrder: number;
}): Record<string, unknown> {
  const { bodyMarkdown, ...rest } = input;
  return { ...rest, bodyLength: bodyMarkdown.length };
}

function platformDb(authz: Authorization): DbScope {
  if (authz.db?.kind !== "platform") {
    // Lỗi lập trình: route Admin thiếu `@Authorize` với quyền phạm vi `any`.
    throw new Error("Route Admin nội dung công khai cần ngữ cảnh DB platform.");
  }
  return authz.db;
}
