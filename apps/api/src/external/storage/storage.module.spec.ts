import { describe, expect, it } from "vitest";
import type { AppConfig } from "../../config/env.config";
import { LocalStorageProvider } from "./local-storage-provider";
import { R2StorageProvider } from "./r2-storage-provider";
import { createPrivateStorage } from "./storage.module";

const R2 = {
  R2_ACCOUNT_ID: "account",
  R2_ACCESS_KEY_ID: "key-id",
  R2_SECRET_ACCESS_KEY: "secret",
  R2_PUBLIC_BUCKET: "vexenhanh-public",
  R2_PUBLIC_BASE_URL: "https://cdn.example.com",
};
const config = (overrides: Partial<AppConfig>) =>
  ({ NODE_ENV: "development", BETTER_AUTH_URL: "http://localhost:3000", ...overrides }) as AppConfig;

describe("createPrivateStorage (kho giấy tờ KYC — ADR-018, OQ-21)", () => {
  it("dev / test → ổ đĩa local", () => {
    expect(createPrivateStorage(config({}))).toBeInstanceOf(LocalStorageProvider);
    expect(createPrivateStorage(config({ NODE_ENV: "test", ...R2 }))).toBeInstanceOf(LocalStorageProvider);
  });

  it("đủ R2 + bucket private → R2", () => {
    expect(createPrivateStorage(config({ ...R2, R2_PRIVATE_BUCKET: "vexenhanh-private" }))).toBeInstanceOf(
      R2StorageProvider,
    );
  });

  it("production chưa khai bucket private → null (API giấy tờ trả 503), không bao giờ rơi về ổ đĩa của máy chủ", () => {
    expect(createPrivateStorage(config({ NODE_ENV: "production", ...R2 }))).toBeNull();
  });
});
