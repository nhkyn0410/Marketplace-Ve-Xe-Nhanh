import { Logger, Module } from "@nestjs/common";
import { resolve } from "node:path";
import { APP_CONFIG, type AppConfig } from "../../config/env.config";
import { LocalStorageController } from "./local-storage.controller";
import { LocalStorageProvider } from "./local-storage-provider";
import { R2StorageProvider } from "./r2-storage-provider";
import { PRIVATE_STORAGE, PUBLIC_STORAGE, type StorageProvider } from "./storage-provider";

/** Thư mục mặc định của kho ổ đĩa (tính từ thư mục chạy API); đã nằm trong `.gitignore`. */
const DEFAULT_LOCAL_DIR = ".storage/public";
/** Kho riêng tư ở dev / test: thư mục anh em của kho công khai, KHÔNG phục vụ qua route `public/*`. */
const PRIVATE_LOCAL_DIR = "private";

/** Tạo kho công khai theo config — tách ra để worker và test dựng cùng một cách. */
export function createPublicStorage(config: AppConfig): StorageProvider {
  if (
    config.R2_ACCOUNT_ID &&
    config.R2_ACCESS_KEY_ID &&
    config.R2_SECRET_ACCESS_KEY &&
    config.R2_PUBLIC_BUCKET &&
    config.R2_PUBLIC_BASE_URL
  ) {
    return new R2StorageProvider({
      accountId: config.R2_ACCOUNT_ID,
      accessKeyId: config.R2_ACCESS_KEY_ID,
      secretAccessKey: config.R2_SECRET_ACCESS_KEY,
      bucket: config.R2_PUBLIC_BUCKET,
      publicBaseUrl: config.R2_PUBLIC_BASE_URL.replace(/\/+$/, ""),
    });
  }
  new Logger("StorageModule").warn("Chưa cấu hình R2 — file công khai lưu trên ổ đĩa local (chỉ dùng cho dev / test).");
  return new LocalStorageProvider({
    rootDir: resolve(config.STORAGE_LOCAL_DIR ?? DEFAULT_LOCAL_DIR),
    // `BETTER_AUTH_URL` là origin công khai của chính API: URL tải lên / đọc file của kho local trỏ về đó.
    apiBaseUrl: config.BETTER_AUTH_URL.replace(/\/+$/, ""),
  });
}

/**
 * Tạo kho riêng tư (giấy tờ KYC — ADR-018 bucket `private`). Đủ cấu hình R2 + `R2_PRIVATE_BUCKET` → R2. Production
 * chưa khai bucket private → `null`: nơi lưu KYC production chờ OQ-21, API tải / xem giấy tờ trả 503 thay vì lưu giấy
 * tờ lên ổ đĩa tạm của máy chủ. Dev / test → ổ đĩa local.
 */
export function createPrivateStorage(config: AppConfig): StorageProvider | null {
  if (
    config.R2_ACCOUNT_ID &&
    config.R2_ACCESS_KEY_ID &&
    config.R2_SECRET_ACCESS_KEY &&
    config.R2_PRIVATE_BUCKET
  ) {
    return new R2StorageProvider({
      accountId: config.R2_ACCOUNT_ID,
      accessKeyId: config.R2_ACCESS_KEY_ID,
      secretAccessKey: config.R2_SECRET_ACCESS_KEY,
      bucket: config.R2_PRIVATE_BUCKET,
      // Bucket private không có địa chỉ công khai; chỉ đọc qua presigned URL.
      publicBaseUrl: "",
    });
  }
  if (config.NODE_ENV === "production") {
    new Logger("StorageModule").warn("Chưa cấu hình R2_PRIVATE_BUCKET — tải / xem giấy tờ KYC trả 503 (OQ-21).");
    return null;
  }
  return new LocalStorageProvider({
    rootDir: resolve(config.STORAGE_LOCAL_DIR ?? DEFAULT_LOCAL_DIR, "..", PRIVATE_LOCAL_DIR),
    apiBaseUrl: config.BETTER_AUTH_URL.replace(/\/+$/, ""),
  });
}

/**
 * Chọn adapter lưu object theo config (mẫu RoutingModule, ADR-018): đủ biến `R2_*` → Cloudflare R2; không có →
 * ổ đĩa local (env đã bắt buộc R2 ở production). Controller dev chỉ phục vụ khi kho là ổ đĩa local.
 */
@Module({
  controllers: [LocalStorageController],
  providers: [
    { provide: PUBLIC_STORAGE, inject: [APP_CONFIG], useFactory: createPublicStorage },
    { provide: PRIVATE_STORAGE, inject: [APP_CONFIG], useFactory: createPrivateStorage },
  ],
  exports: [PUBLIC_STORAGE, PRIVATE_STORAGE],
})
export class StorageModule {}
