import {
  Controller,
  ForbiddenException,
  Get,
  Header,
  Headers,
  HttpCode,
  Inject,
  NotFoundException,
  Param,
  PayloadTooLargeException,
  Put,
  Query,
  Req,
  Res,
} from "@nestjs/common";
import { ApiExcludeController } from "@nestjs/swagger";
import type { Request, Response } from "express";
import { LOCAL_STORAGE_ROUTE, LocalStorageProvider } from "./local-storage-provider";
import { contentDisposition } from "./r2-storage-provider";
import { PRIVATE_STORAGE, PUBLIC_STORAGE, type StorageProvider } from "./storage-provider";

/**
 * Các route đóng vai R2 khi chạy dev / test với kho ổ đĩa: nhận file tải lên bằng URL có token, trả file công
 * khai, và trả file riêng tư (giấy tờ KYC) bằng URL có token. Kho đang là R2 (production) thì mọi route ở đây
 * trả 404. Không vào OpenAPI — client không gọi theo tên route mà theo URL do API trả về.
 */
@ApiExcludeController()
@Controller(LOCAL_STORAGE_ROUTE)
export class LocalStorageController {
  constructor(
    @Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider,
    @Inject(PRIVATE_STORAGE) private readonly privateStorage: StorageProvider | null,
  ) {}

  /** Thay cho `PUT` thẳng lên R2: token ràng đúng khóa, loại và dung lượng như chữ ký của presigned URL. */
  @Put("upload")
  @HttpCode(200)
  async upload(
    @Query("token") token: string | undefined,
    @Headers("content-type") contentType: string | undefined,
    @Req() request: Request,
  ): Promise<void> {
    // Token chỉ khớp chữ ký của đúng kho đã cấp nó (mỗi kho một khóa ký), nên thử lần lượt kho công khai và kho
    // riêng tư: file luôn rơi vào đúng kho đã cấp URL.
    const target = token
      ? this.locals()
          .map((local) => ({ local, grant: local.verifyUploadToken(token) }))
          .find((candidate) => candidate.grant !== null)
      : undefined;
    if (!target?.grant || contentType !== target.grant.contentType) {
      throw new ForbiddenException("URL tải lên không hợp lệ hoặc đã hết hạn.");
    }
    const { local, grant } = target;
    // Body parser JSON bỏ qua `image/*` / `application/pdf` nên luồng còn nguyên: đọc tới đúng dung lượng đã cấp.
    const chunks: Buffer[] = [];
    let received = 0;
    for await (const chunk of request) {
      received += (chunk as Buffer).length;
      if (received > grant.sizeBytes) {
        throw new PayloadTooLargeException("File lớn hơn dung lượng đã khai khi xin URL.");
      }
      chunks.push(chunk as Buffer);
    }
    if (received !== grant.sizeBytes) {
      throw new ForbiddenException("Dung lượng file không khớp với lúc xin URL.");
    }
    await local.write(grant.key, grant.contentType, Buffer.concat(chunks));
  }

  /**
   * Thay cho CDN của R2 public. `nosniff` để trình duyệt không tự đoán loại khác với loại đã lưu. Ảnh công khai
   * được nhúng từ origin khác (Operator OS, Marketplace) nên nới `Cross-Origin-Resource-Policy` mà helmet đặt
   * mặc định là `same-origin` — chỉ cho route này.
   */
  @Get("public/*key")
  @Header("Cache-Control", "public, max-age=300")
  @Header("X-Content-Type-Options", "nosniff")
  @Header("Cross-Origin-Resource-Policy", "cross-origin")
  async read(@Param("key") key: string | string[], @Res() response: Response): Promise<void> {
    const object = await this.local().read(Array.isArray(key) ? key.join("/") : key);
    if (!object) {
      throw new NotFoundException();
    }
    response.type(object.contentType ?? "application/octet-stream").send(object.body);
  }

  /**
   * Thay cho presigned `GET` của R2 private (giấy tờ KYC): chỉ đọc được bằng URL có token do kho riêng tư cấp, hạn
   * ngắn. `no-store` để trình duyệt / proxy không giữ bản sao giấy tờ.
   */
  @Get("download")
  @Header("Cache-Control", "private, no-store")
  @Header("X-Content-Type-Options", "nosniff")
  async download(@Query("token") token: string | undefined, @Res() response: Response): Promise<void> {
    const local = this.privateStorage instanceof LocalStorageProvider ? this.privateStorage : null;
    const grant = local && token ? local.verifyDownloadToken(token) : null;
    const object = grant ? await local!.read(grant.key) : null;
    if (!grant || !object) {
      throw new NotFoundException();
    }
    response
      .type(object.contentType ?? "application/octet-stream")
      .setHeader("Content-Disposition", contentDisposition(grant.fileName))
      .send(object.body);
  }

  private local(): LocalStorageProvider {
    if (!(this.storage instanceof LocalStorageProvider)) {
      throw new NotFoundException();
    }
    return this.storage;
  }

  private locals(): LocalStorageProvider[] {
    const locals = [this.storage, this.privateStorage].filter(
      (store): store is LocalStorageProvider => store instanceof LocalStorageProvider,
    );
    if (locals.length === 0) {
      throw new NotFoundException();
    }
    return locals;
  }
}
