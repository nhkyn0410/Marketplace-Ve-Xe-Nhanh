import { randomUUID } from "node:crypto";
import { HttpException, Inject, Injectable, Logger } from "@nestjs/common";
import { PrismaService, type DbTransaction } from "../database/prisma.service";
import { PUBLIC_STORAGE, type StorageProvider } from "../external/storage/storage-provider";
import type { Authorization } from "../iam/role/authorization";
import { requireTenant } from "../iam/role/require-tenant";
import type {
  VehicleImageResponse,
  VehicleImagesInput,
  VehicleImagesResponse,
  VehicleImageUploadInput,
  VehicleImageUploadResponse,
} from "./dto/vehicle-image.dto";
import {
  contentTypeOfKey,
  detectImageType,
  IMAGE_SIGNATURE_BYTES,
  MAX_VEHICLE_IMAGE_BYTES,
  MAX_VEHICLE_IMAGES,
  vehicleImageKey,
  type VehicleImageContentType,
} from "./vehicle-image-format";
import { VehicleImageUploadLimiter } from "./vehicle-image-upload-limiter";
import {
  vehicleImageInvalid,
  vehicleImageLimitExceeded,
  vehicleImageStorageUnavailable,
  vehicleNotFound,
} from "./vehicle.errors";

/** URL tải ảnh có hiệu lực 5 phút (LLD §6.12 bước 2). */
export const UPLOAD_URL_TTL_SECONDS = 300;
/**
 * Object tải lên quá lâu mà chưa gắn thì không gắn được nữa. Mốc này phải NHỎ HƠN tuổi tối thiểu của job dọn
 * object mồ côi (24 giờ — `vehicle-image-cleanup.ts`): thứ gắn được luôn trẻ hơn thứ job xóa, nên job không bao
 * giờ xóa nhầm một object vừa được gắn vào xe.
 */
export const ATTACHABLE_MAX_AGE_MS = 23 * 3_600_000;

export const VEHICLE_IMAGE_SELECT = { id: true, objectKey: true, position: true, caption: true } as const;
export type VehicleImageRow = { id: string; objectKey: string; position: number; caption: string | null };

/** Dòng ảnh → phần tử trả ra API, kèm địa chỉ công khai của object. */
export function toVehicleImages(
  rows: readonly VehicleImageRow[],
  storage: Pick<StorageProvider, "publicUrl">,
): VehicleImageResponse[] {
  return [...rows]
    .sort((a, b) => a.position - b.position)
    .map((row) => ({
      id: row.id,
      objectKey: row.objectKey,
      url: storage.publicUrl(row.objectKey),
      position: row.position,
      caption: row.caption,
    }));
}

type StoredRow = VehicleImageRow & { sizeBytes: number; contentType: string; createdAt: Date };
type Inspected = { sizeBytes: number; contentType: VehicleImageContentType };

/**
 * Ảnh công khai của xe (TASK-TRN-009, FR-OPS-16, BR-76, LLD §6.12). Trình duyệt tải file thẳng lên kho bằng URL
 * có chữ ký; API chỉ cấp URL, rồi kiểm lại object trước khi gắn vào xe. Mọi truy vấn lọc `operatorId` tường minh
 * và chạy trong scope tenant (RLS).
 */
@Injectable()
export class VehicleImageService {
  private readonly logger = new Logger(VehicleImageService.name);

  constructor(
    @Inject(PrismaService) private readonly prisma: PrismaService,
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @Inject(VehicleImageUploadLimiter) private readonly limiter: VehicleImageUploadLimiter,
  ) {}

  /** Cấp URL để tải MỘT ảnh lên kho. Khóa object do server sinh dưới tiền tố của đúng xe này. */
  async createUploadUrl(
    actor: { sub: string },
    authz: Authorization,
    vehicleId: string,
    input: VehicleImageUploadInput,
  ): Promise<VehicleImageUploadResponse> {
    const { db, operatorId } = requireTenant(authz);
    await this.limiter.assertWithinLimit(actor.sub);
    const vehicle = await this.prisma.withScope(db, (tx) =>
      tx.vehicle.findFirst({ where: { id: vehicleId, operatorId }, select: { id: true } }),
    );
    if (!vehicle) {
      throw vehicleNotFound();
    }
    const objectKey = vehicleImageKey(operatorId, vehicleId, randomUUID(), input.contentType);
    const target = await this.callStorage(() =>
      this.storage.createUploadUrl({
        key: objectKey,
        contentType: input.contentType,
        sizeBytes: input.sizeBytes,
        expiresInSeconds: UPLOAD_URL_TTL_SECONDS,
      }),
    );
    return { uploadUrl: target.uploadUrl, objectKey, expiresAt: target.expiresAt.toISOString() };
  }

  /**
   * Thay toàn bộ bộ ảnh của xe theo thứ tự gửi lên (phần tử đầu là ảnh đại diện). Ảnh mới phải là object đã tải
   * lên hợp lệ dưới tiền tố của chính xe đó; sai một ảnh thì từ chối cả lần gọi, bộ ảnh cũ giữ nguyên. Ảnh giữ lại
   * giữ nguyên `id`. Object của ảnh bị bỏ được xóa SAU khi commit, lỗi xóa để job dọn xử lý.
   */
  async replace(authz: Authorization, vehicleId: string, input: VehicleImagesInput): Promise<VehicleImagesResponse> {
    const { db, operatorId } = requireTenant(authz);
    if (input.images.length > MAX_VEHICLE_IMAGES) {
      throw vehicleImageLimitExceeded(MAX_VEHICLE_IMAGES);
    }
    const types = new Map<string, VehicleImageContentType>();
    for (const image of input.images) {
      const type = contentTypeOfKey(operatorId, vehicleId, image.objectKey);
      if (!type) {
        throw this.invalid("foreign_key", image.objectKey);
      }
      types.set(image.objectKey, type);
    }

    const before = await this.prisma.withScope(db, (tx) =>
      tx.vehicle.findFirst({
        where: { id: vehicleId, operatorId },
        select: { images: { select: { objectKey: true } } },
      }),
    );
    if (!before) {
      throw vehicleNotFound();
    }
    // Kiểm object của ảnh mới TRƯỚC transaction: gọi kho là gọi mạng, không giữ khóa dòng xe trong lúc đó.
    const known = new Set(before.images.map((image) => image.objectKey));
    const inspected = new Map<string, Inspected>();
    await Promise.all(
      input.images
        .filter((image) => !known.has(image.objectKey))
        .map(async (image) => {
          inspected.set(image.objectKey, await this.inspect(image.objectKey, types.get(image.objectKey)!));
        }),
    );

    const { rows, removed } = await this.prisma.withScope(db, async (tx) => {
      // Khoá dòng xe: hai lần thay bộ ảnh đồng thời xếp hàng, không trộn hai danh sách (DB §8).
      const locked = await tx.$queryRaw<unknown[]>`
        SELECT 1 FROM vehicles WHERE id = ${vehicleId} AND operator_id = ${operatorId} FOR NO KEY UPDATE`;
      if (locked.length === 0) {
        throw vehicleNotFound();
      }
      const current = await findStoredRows(tx, operatorId, vehicleId);
      const currentByKey = new Map(current.map((row) => [row.objectKey, row]));
      const data = input.images.map((image, position) => {
        const kept = currentByKey.get(image.objectKey);
        if (kept) {
          return { ...kept, operatorId, vehicleId, position, caption: image.caption };
        }
        const fresh = inspected.get(image.objectKey);
        if (!fresh) {
          // Ảnh "đang có" lúc đọc trước đã bị một lần thay khác gỡ mất (object có thể đã bị xóa).
          throw this.invalid("removed_concurrently", image.objectKey);
        }
        return { operatorId, vehicleId, objectKey: image.objectKey, position, caption: image.caption, ...fresh };
      });
      await tx.vehicleImage.deleteMany({ where: { vehicleId, operatorId } });
      if (data.length > 0) {
        await tx.vehicleImage.createMany({ data });
      }
      const kept = new Set(input.images.map((image) => image.objectKey));
      return {
        rows: await findStoredRows(tx, operatorId, vehicleId),
        removed: current.filter((row) => !kept.has(row.objectKey)).map((row) => row.objectKey),
      };
    });

    await Promise.all(
      removed.map((key) =>
        this.storage.delete(key).catch((error: unknown) => {
          this.logger.warn({ event: "vehicle.image.delete_failed", key, error });
        }),
      ),
    );
    return { images: toVehicleImages(rows, this.storage) };
  }

  /** Kiểm một object vừa tải lên: tồn tại, đủ mới, đúng dung lượng, đúng loại và đúng chữ ký định dạng. */
  private async inspect(objectKey: string, expected: VehicleImageContentType): Promise<Inspected> {
    const object = await this.callStorage(() => this.storage.head(objectKey));
    if (!object) {
      throw this.invalid("missing", objectKey);
    }
    if (Date.now() - object.lastModified.getTime() > ATTACHABLE_MAX_AGE_MS) {
      throw this.invalid("stale", objectKey);
    }
    if (object.sizeBytes < 1 || object.sizeBytes > MAX_VEHICLE_IMAGE_BYTES) {
      throw this.invalid("size", objectKey);
    }
    if (object.contentType !== expected) {
      throw this.invalid("content_type", objectKey);
    }
    const start = await this.callStorage(() => this.storage.readStart(objectKey, IMAGE_SIGNATURE_BYTES));
    if (detectImageType(start) !== expected) {
      throw this.invalid("signature", objectKey);
    }
    return { sizeBytes: object.sizeBytes, contentType: expected };
  }

  /**
   * Mọi trường hợp ảnh sai dùng chung một mã và một thông báo, không lộ lý do (LLD §7); lý do chỉ ghi log để vận
   * hành tra cứu.
   */
  private invalid(reason: string, objectKey: string): HttpException {
    this.logger.warn({ event: "vehicle.image.invalid", reason, objectKey });
    return vehicleImageInvalid();
  }

  // Kho không phản hồi → 503 thử lại được, thay cho 500 không rõ nguyên nhân.
  private async callStorage<T>(work: () => Promise<T>): Promise<T> {
    try {
      return await work();
    } catch (error) {
      if (error instanceof HttpException) {
        throw error;
      }
      this.logger.error({ event: "vehicle.image.storage_failed", error });
      throw vehicleImageStorageUnavailable();
    }
  }
}

function findStoredRows(tx: DbTransaction, operatorId: string, vehicleId: string): Promise<StoredRow[]> {
  return tx.vehicleImage.findMany({
    where: { vehicleId, operatorId },
    orderBy: { position: "asc" },
    select: { ...VEHICLE_IMAGE_SELECT, sizeBytes: true, contentType: true, createdAt: true },
  });
}
