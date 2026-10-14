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
import { PUBLIC_STORAGE, type StorageProvider } from "./storage-provider";

/**
 * Hai route đóng vai R2 khi chạy dev / test với kho ổ đĩa: nhận file tải lên bằng URL có token và trả file công
 * khai. Kho đang là R2 (production) thì mọi route ở đây trả 404. Không vào OpenAPI — client không gọi theo tên
 * route mà theo URL do API trả về.
 */
@ApiExcludeController()
@Controller(LOCAL_STORAGE_ROUTE)
export class LocalStorageController {
  constructor(@Inject(PUBLIC_STORAGE) private readonly storage: StorageProvider) {}

  /** Thay cho `PUT` thẳng lên R2: token ràng đúng khóa, loại và dung lượng như chữ ký của presigned URL. */
  @Put("upload")
  @HttpCode(200)
  async upload(
    @Query("token") token: string | undefined,
    @Headers("content-type") contentType: string | undefined,
    @Req() request: Request,
  ): Promise<void> {
    const local = this.local();
    const grant = token ? local.verifyUploadToken(token) : null;
    if (!grant || contentType !== grant.contentType) {
      throw new ForbiddenException("URL tải lên không hợp lệ hoặc đã hết hạn.");
    }
    // Body parser JSON bỏ qua `image/*` nên luồng còn nguyên: đọc tới đúng dung lượng đã cấp rồi dừng.
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

  private local(): LocalStorageProvider {
    if (!(this.storage instanceof LocalStorageProvider)) {
      throw new NotFoundException();
    }
    return this.storage;
  }
}
